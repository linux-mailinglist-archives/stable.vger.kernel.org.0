Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B00427478A
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIVReQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 13:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgIVReQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 13:34:16 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0F622206;
        Tue, 22 Sep 2020 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600796056;
        bh=cwkQtjTlUawHnfi1R9kwlgW90Y2s8e5YmR1TzoxWoX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NtABOmRhI/lLt3P/0Z45VobBRiHnFsd6Z/NQM6nms7rGpHewDKWloZPyl8k/bdBQA
         Ldc876ha/tw3FGMsyCYinpggBfyUH2CbblXa+vXBV9GR/33CkA2ekBXcEvUnkExO43
         qDst/GIadN2d0nqzHSs6NxVgEQ+ofsmV2oZHaeAM=
Date:   Tue, 22 Sep 2020 10:34:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        stable@vger.kernel.org, rppt@linux.ibm.com, richard@nod.at,
        peterz@infradead.org, paulus@samba.org, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, linux@armlinux.org.uk,
        jgg@nvidia.com, jdike@addtoit.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        dave.hansen@linux.intel.com, dave.hansen@intel.com,
        catalin.marinas@arm.com, bp@alien8.de, benh@kernel.crashing.org,
        aryabinin@virtuozzo.com, arnd@arndb.de, agordeev@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: + mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch
 added to -mm tree
Message-Id: <20200922103413.5e410c70c33577c8ca6d94cd@linux-foundation.org>
In-Reply-To: <eac62020-0526-cbc9-18d3-499526ef7a14@de.ibm.com>
References: <20200916003608.ib4Ln%akpm@linux-foundation.org>
        <eac62020-0526-cbc9-18d3-499526ef7a14@de.ibm.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 19:37:14 +0200 Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> now that this is part of next, what are the plans for merging this in 5.9?
> It does fix a data corruption issue on s390.

It'll be in this week's hotfix pile for Linus.
