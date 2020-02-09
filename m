Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B197156C5F
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 21:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgBIUV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 15:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbgBIUV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 15:21:59 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0DB5207FF;
        Sun,  9 Feb 2020 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581279718;
        bh=DAIiZ1FeKjFZJRrjvW4ERJIBqsFExtCLkv7b+RM75uQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xz4I4FEopAXqH2y0pzug4TRQAqrl3Ko2MKyY2EyKKtEZk5UbR8tAG7q0zbgivjG5j
         MZ4tP9owzlClCZ92+b29WAfP+OCthRTaSxwYWMNNqUMQfICpR9F16uwYHR/Ud33NBi
         xuj97SyxINp7YfHghRHKGgp8JVwE6Erbc21ivJj8=
Date:   Sun, 9 Feb 2020 15:21:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pbonzini@redhat.com, bgardon@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: fix overlap between
 SPTE_MMIO_MASK and generation" failed to apply to 5.4-stable tree
Message-ID: <20200209202157.GB3584@sasha-vm>
References: <1581251651184158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581251651184158@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:34:11PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 56871d444bc4d7ea66708775e62e2e0926384dbc Mon Sep 17 00:00:00 2001
>From: Paolo Bonzini <pbonzini@redhat.com>
>Date: Sat, 18 Jan 2020 20:09:03 +0100
>Subject: [PATCH] KVM: x86: fix overlap between SPTE_MMIO_MASK and generation
>
>The SPTE_MMIO_MASK overlaps with the bits used to track MMIO
>generation number.  A high enough generation number would overwrite the
>SPTE_SPECIAL_MASK region and cause the MMIO SPTE to be misinterpreted.
>
>Likewise, setting bits 52 and 53 would also cause an incorrect generation
>number to be read from the PTE, though this was partially mitigated by the
>(useless if it weren't for the bug) removal of SPTE_SPECIAL_MASK from
>the spte in get_mmio_spte_generation.  Drop that removal, and replace
>it with a compile-time assertion.
>
>Fixes: 6eeb4ef049e7 ("KVM: x86: assign two bits to track SPTE kinds")
>Reported-by: Ben Gardon <bgardon@google.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Conflict due to file rename. I've fixed it up and queued up.

-- 
Thanks,
Sasha
