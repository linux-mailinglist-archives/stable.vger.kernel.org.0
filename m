Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2F9156C35
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 20:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgBITAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 14:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727408AbgBITAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 14:00:19 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D00720715;
        Sun,  9 Feb 2020 19:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581274818;
        bh=vgsPAO3P6qvfgyUPvpfi4Nxp4MFVXELY1Bpx+hbzFsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C3hCfjXx/8ZE7NVOf8PO409xHFBkPWjS7yCbnN0HWhv1NurATKteeMSa683cghmj1
         HQasiVEXtr1ZQG80rh4CZQ/kSAjhHc3FWRJ2Sz+jdwuNO3jJOafSbIQwVshfZCwFvJ
         c3wr0eqz8PiJe3RdYf9WrV55e6UUGmCQfY1CeMpE=
Date:   Sun, 9 Feb 2020 14:00:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pomonis@google.com, ahonig@google.com, jmattson@google.com,
        nifi@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Protect kvm_lapic_reg_write()
 from Spectre-v1/L1TF" failed to apply to 4.4-stable tree
Message-ID: <20200209190017.GS3584@sasha-vm>
References: <158124948610483@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124948610483@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:58:06PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.4-stable tree.
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
>From 4bf79cb089f6b1c6c632492c0271054ce52ad766 Mon Sep 17 00:00:00 2001
>From: Marios Pomonis <pomonis@google.com>
>Date: Wed, 11 Dec 2019 12:47:46 -0800
>Subject: [PATCH] KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF
> attacks
>
>This fixes a Spectre-v1/L1TF vulnerability in kvm_lapic_reg_write().
>This function contains index computations based on the
>(attacker-controlled) MSR number.
>
>Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")
>
>Signed-off-by: Nick Finco <nifi@google.com>
>Signed-off-by: Marios Pomonis <pomonis@google.com>
>Reviewed-by: Andrew Honig <ahonig@google.com>
>Cc: stable@vger.kernel.org
>Reviewed-by: Jim Mattson <jmattson@google.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

We didn't have 1e6e2755b635 ("KVM: x86: Misc LAPIC changes to expose
helper functions") in 4.4. I've fixed it and queued this patch for 4.4.

-- 
Thanks,
Sasha
