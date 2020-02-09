Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4880156C4D
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 20:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgBIT6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 14:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbgBIT6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 14:58:08 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D4D220726;
        Sun,  9 Feb 2020 19:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581278287;
        bh=2lHMTvAtQK5z6b5BuzYTkRS2cBKV4mQNRfKKrcMNyuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w13/A/T1sfv2ZjT1hLOVDmabjSoRISEBc7k8MtmNjogBBn+/OfEhKUU981i35fsoD
         9Oje3pG00dKJZjTt95cuFFAOVap567CJbbon9hUW0Lzd3BjDyw0HR/D3wtbRZLm+k5
         nQcXw0ITWEp95KJ7uwwhFnYJOvJZf2V6Q4Uu4wlc=
Date:   Sun, 9 Feb 2020 14:58:05 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: use CPUID to locate host page
 table reserved bits" failed to apply to 5.4-stable tree
Message-ID: <20200209195805.GW3584@sasha-vm>
References: <158125147044100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158125147044100@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:31:10PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From 7adacf5eb2d2048045d9fd8fdab861fd9e7e2e96 Mon Sep 17 00:00:00 2001
>From: Paolo Bonzini <pbonzini@redhat.com>
>Date: Wed, 4 Dec 2019 15:50:27 +0100
>Subject: [PATCH] KVM: x86: use CPUID to locate host page table reserved bits
>
>The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
>true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally if
>available, it is simplest and works even if memory is not encrypted.
>
>Cc: stable@vger.kernel.org
>Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

For 5.4 it was just due to a file rename, I've fixed it and queued it
up. 4.19 still needs a backport.

-- 
Thanks,
Sasha
