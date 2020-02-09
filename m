Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD1E156C31
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgBISvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbgBISvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:51:10 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6719320708;
        Sun,  9 Feb 2020 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581274269;
        bh=WDRwRInItWiMY6XwZKELgn9SyAP4XMRb3EoNvIBjwkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ya3ekBfp9cazUDXRNbX6mrWOI0nQSpYQoH1MgEoem2xjToEy8ytNk7bVcM4JaBPkD
         K42KGeE6GYsXzwf4Kp+qsa9r+M8fyNY1t6bavkNUTU+rdYed6pAmvNs2oeSzSYiy2J
         6g4dL7+RkEQvL8mRIl9Mc+lrbyDqD7q9qtAlcX7Y=
Date:   Sun, 9 Feb 2020 13:51:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pomonis@google.com, ahonig@google.com, jmattson@google.com,
        nifi@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Protect pmu_intel.c from
 Spectre-v1/L1TF attacks" failed to apply to 4.14-stable tree
Message-ID: <20200209185108.GR3584@sasha-vm>
References: <158124937222923@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124937222923@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:56:12PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From 66061740f1a487f4ed54fde75e724709f805da53 Mon Sep 17 00:00:00 2001
>From: Marios Pomonis <pomonis@google.com>
>Date: Wed, 11 Dec 2019 12:47:53 -0800
>Subject: [PATCH] KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks
>
>This fixes Spectre-v1/L1TF vulnerabilities in intel_find_fixed_event()
>and intel_rdpmc_ecx_to_pmc().
>kvm_rdpmc() (ancestor of intel_find_fixed_event()) and
>reprogram_fixed_counter() (ancestor of intel_rdpmc_ecx_to_pmc()) are
>exported symbols so KVM should treat them conservatively from a security
>perspective.
>
>Fixes: 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support vPMU function dispatch")
>
>Signed-off-by: Nick Finco <nifi@google.com>
>Signed-off-by: Marios Pomonis <pomonis@google.com>
>Reviewed-by: Andrew Honig <ahonig@google.com>
>Cc: stable@vger.kernel.org
>Reviewed-by: Jim Mattson <jmattson@google.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Conflict due to missing 0e6f467ee28e ("KVM: x86/pmu: mask the result of
rdpmc according to the width of the counters"). I've fixed it and queued
for 4.14-4.4.

-- 
Thanks,
Sasha
