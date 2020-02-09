Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050AE156C5E
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 21:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbgBIUUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 15:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbgBIUUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 15:20:16 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04B6B20733;
        Sun,  9 Feb 2020 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581279616;
        bh=P5HCLvJzE1lMscUx39LZyTusKt00vdCNB9oi3JfY8OE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HTTrcwomEDEabg3Hcq+o617cKURytzUl6hyzCWN1UCC3u8d7wscIET5D6Y2RdiJfv
         e0ramYOaKgEXAQ9i8Vv7FDHqu51T/pyWX6HewYY5dWM620Jdkvk8O937pSYNUZ+y2D
         SlnYGtJeQe10+4nvQZ4xN9/dQRkxTi0VNgmTorbU=
Date:   Sun, 9 Feb 2020 15:20:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pomonis@google.com, ahonig@google.com, nifi@google.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Protect exit_reason from being
 used in" failed to apply to 5.5-stable tree
Message-ID: <20200209202015.GA3584@sasha-vm>
References: <15812515873364@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15812515873364@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:33:07PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
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
>From c926f2f7230b1a29e31914b51db680f8cbf3103f Mon Sep 17 00:00:00 2001
>From: Marios Pomonis <pomonis@google.com>
>Date: Wed, 11 Dec 2019 12:47:51 -0800
>Subject: [PATCH] KVM: x86: Protect exit_reason from being used in
> Spectre-v1/L1TF attacks
>
>This fixes a Spectre-v1/L1TF vulnerability in vmx_handle_exit().
>While exit_reason is set by the hardware and therefore should not be
>attacker-influenced, an unknown exit_reason could potentially be used to
>perform such an attack.
>
>Fixes: 55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")
>
>Signed-off-by: Marios Pomonis <pomonis@google.com>
>Signed-off-by: Nick Finco <nifi@google.com>
>Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Reviewed-by: Andrew Honig <ahonig@google.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

The conflict in 5.5 was because we didn't have 1e9e2622a149 ("KVM: VMX:
FIXED+PHYSICAL mode single target IPI fastpath"), I've fixed it and
queued it up.

Backports for older kernels are still missing.

-- 
Thanks,
Sasha
