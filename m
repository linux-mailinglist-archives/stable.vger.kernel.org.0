Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB0E06E0A3
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 07:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfGSFhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 01:37:09 -0400
Received: from len.romanrm.net ([91.121.75.85]:57928 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfGSFhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 01:37:09 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 857B420282;
        Fri, 19 Jul 2019 05:37:06 +0000 (UTC)
Date:   Fri, 19 Jul 2019 10:37:06 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-ide@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH] libata: Disable queued TRIM for Samsung 860 series SSDs
Message-ID: <20190719103706.6f452ca3@natsu>
In-Reply-To: <yq1lfwuwwxc.fsf@oracle.com>
References: <20190714224242.4689a874@natsu>
 <yq1y30z2ojx.fsf@oracle.com>
 <20190715224215.2186bc8e@natsu>
 <yq1lfwuwwxc.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Jul 2019 23:00:31 -0400
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> I have tested two mSATA 860s on two different systems, both with Intel
> AHCI controllers, and queued trim works fine for me.

What is the firmware version?

Also, do you have an ASMedia ASM1062 controller to try (often seen on
motherboards for additional SATA ports)? That's the one I tested with.

Before tried with AMD chipset ones, but on those the 860s are known[1] to
have serious NCQ issues in general, not just TRIM, so they are not useful for
this test.

With ASMedia only queued TRIM fails and everything else works fine. So I
wonder if 850's queued TRIM issue in 860's case remains only on some SATA
controllers.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=201693

-- 
With respect,
Roman
