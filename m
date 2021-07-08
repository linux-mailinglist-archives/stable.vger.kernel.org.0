Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158BB3BF5C7
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 08:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhGHGwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 02:52:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45682 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhGHGwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 02:52:43 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 02:52:43 EDT
Date:   Wed, 7 Jul 2021 23:40:02 -0700
From:   Georgy Yakovlev <gyakovlev@gentoo.org>
To:     stable@vger.kernel.org
Cc:     paulus@ozlabs.org, farosas@linux.ibm.com, kernel@gentoo.org,
        dist-kernel@gentoo.org
Subject: please include KVM: PPC: Book3S HV: Save and restore FSCR in the P9
 path
Message-ID: <20210708064002.hzkjvvzhjticalzm@cerberus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'd like to propose the following patch for inclusion into 5.10 LTS

commit: 25edcc50d76c834479d11fcc7de46f3da4d95121
subject: [PATCH] KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path

Without this patch qemu does not work on POWER9 on modern glibc,
so I think it should be included in at least 5.10 lts branch.

I cannot test on older LTS versions unfortunately, only 5.10.

Started Virtual Machine qemu-2-gentoo-ppc64-stable.
Facility 'SCV' unavailable (12), exception at 0x7fff9f81d4b0, MSR=900000000280f033
CPU 0/KVM[2914766]: illegal instruction (4) at 7fff9f81d4b0 nip 7fff9f81d4b0 lr 13e6048e0 code 1 in libc-2.33.so[7fff9f6f0000+200000]
CPU 0/KVM[2914766]: code: e8010010 7c0803a6 4e800020 60420000 7ca42b78 4bffedb5 60000000 38210020
CPU 0/KVM[2914766]: code: e8010010 7c0803a6 4e800020 60420000 <44000001> 4bffffb8 60000000 60420000

-- 
Best regards,
Georgy
