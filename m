Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62541AB635
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390344AbgDPD1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390824AbgDPD1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:27:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD0DF2076D;
        Thu, 16 Apr 2020 03:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587007661;
        bh=GTUR/RkmpaELCQcelgfhQf+pM8gOG28zF1FlvVeMsf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=021+rxYv9un7iVQA95HHLWdxWicqeJqFluHwV3QaPRVQwI85qBRf5hJW8JIhdAfeC
         eKwvUOCHA6xoqxUyzFIXD28NXA6rM5cpQXhxZtmwRaRiq7hLN8o0+5GXk9P05IKpHN
         0CDx1Yw2Vesst1OpoOaRFGeMkBp61WCjGGNYffLM=
Date:   Wed, 15 Apr 2020 23:27:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     christophe.leroy@c-s.fr, mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/kasan: Fix
 kasan_remap_early_shadow_ro()" failed to apply to 5.6-stable tree
Message-ID: <20200416032739.GG1068@sasha-vm>
References: <15869567019927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15869567019927@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 03:18:21PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From af92bad615be75c6c0d1b1c5b48178360250a187 Mon Sep 17 00:00:00 2001
>From: Christophe Leroy <christophe.leroy@c-s.fr>
>Date: Fri, 6 Mar 2020 15:09:40 +0000
>Subject: [PATCH] powerpc/kasan: Fix kasan_remap_early_shadow_ro()
>
>At the moment kasan_remap_early_shadow_ro() does nothing, because
>k_end is 0 and k_cur < 0 is always true.
>
>Change the test to k_cur != k_end, as done in
>kasan_init_shadow_page_tables()
>
>Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>Fixes: cbd18991e24f ("powerpc/mm: Fix an Oops in kasan_mmu_init()")
>Cc: stable@vger.kernel.org
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/4e7b56865e01569058914c991143f5961b5d4719.1583507333.git.christophe.leroy@c-s.fr

Conflict because we don't have 0b1c524caaae ("powerpc/32: refactor
pmd_offset(pud_offset(pgd_offset..."). Fixed and queued up.

-- 
Thanks,
Sasha
