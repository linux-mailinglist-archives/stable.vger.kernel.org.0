Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C19FF2E
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 12:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfH1KLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 06:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfH1KLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 06:11:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1E7C3087958
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 10:11:21 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 58CE45C1D6;
        Wed, 28 Aug 2019 10:11:21 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     stable@vger.kernel.org
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: kvm: x86: skip populating logical dest map if apic is not sw enabled
Date:   Wed, 28 Aug 2019 06:11:20 -0400
Message-ID: <jpgmuftvbuf.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 28 Aug 2019 10:11:21 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Please consider

commit b14c876b994f208b6b95c222056e1deb0a45de0e
Author: Radim Krcmar <rkrcmar@redhat.com>
Date:   Tue Aug 13 23:37:37 2019 -0400

kvm: x86: skip populating logical dest map if apic is not sw enabled


This fixes 1e08ec4a130e2745d96df169e67c58df98a07311 that was introduced in v3.7.
The bug is that the KVM lapic is not considering whether the guest apic is enabled before
populating the apic in the logical destination table.

Thanks,
Bandan
