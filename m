Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF3124D72
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 17:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfLRQ0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 11:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfLRQ0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 11:26:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD28B227BF;
        Wed, 18 Dec 2019 16:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576686368;
        bh=UvJV5+V5GLxfdacULy68GLBFVz/DGrDdaw3cACZWHcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1wxC876a3n7CpULPIipSeOs97JkwwYdJEYVfc4Zku80A7YWvdkiP2ebrQZjvkVqF2
         kFPmjEoYlMyCUZ/il8b7C0zGilgDyHoY56/Egirz2+3hEGDAUzZepUk5H/E8OX3BLW
         /Oz0m25SbUjJaVmp8EKwOszq4Vii1bymymw8YOEs=
Date:   Wed, 18 Dec 2019 17:26:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vipul Kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [PATCH] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Message-ID: <20191218162606.GC482612@kroah.com>
References: <1576683039-5311-1-git-send-email-vipulk0511@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576683039-5311-1-git-send-email-vipulk0511@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 09:00:39PM +0530, Vipul Kumar wrote:
> From: Vipul Kumar <vipul_kumar@mentor.com>
> 
> 'commit f3a02ecebed7 ("x86/tsc: Set TSC_KNOWN_FREQ and TSC_RELIABLE
> flags on Intel Atom SoCs")', causing time drift for Bay trail SoC.
> These flags are set for SoCs having cpuid_level 0x15 or more.
> Bay trail is having cpuid_level 0xb.
> 
> So, unset both flags to make sure the clocksource calibration can
> be done.
> 
> Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>
> ---
>  arch/x86/kernel/tsc_msr.c | 3 +++
>  1 file changed, 3 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
