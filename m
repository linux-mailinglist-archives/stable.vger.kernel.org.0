Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9F94D308D
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 14:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiCINtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 08:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbiCINtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 08:49:39 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43FB914A043
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 05:48:40 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E15AC1688;
        Wed,  9 Mar 2022 05:48:39 -0800 (PST)
Received: from [10.1.196.218] (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F5B53FA20;
        Wed,  9 Mar 2022 05:48:39 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] arm64: proton-pack: Include unprivileged
 eBPF status in" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, catalin.marinas@arm.com
Cc:     stable@vger.kernel.org
References: <164682752912586@kroah.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <d8d13ff7-9951-6120-a992-8e9c5cc6124f@arm.com>
Date:   Wed, 9 Mar 2022 13:48:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <164682752912586@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 09/03/2022 12:05, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

> ------------------ original commit in Linus's tree ------------------
> 
> From 58c9a5060cb7cd529d49c93954cdafe81c1d642a Mon Sep 17 00:00:00 2001
> From: James Morse <james.morse@arm.com>
> Date: Thu, 3 Mar 2022 16:53:56 +0000
> Subject: [PATCH] arm64: proton-pack: Include unprivileged eBPF status in
>  Spectre v2 mitigation reporting
> 
> The mitigations for Spectre-BHB are only applied when an exception is
> taken from user-space. The mitigation status is reported via the spectre_v2
> sysfs vulnerabilities file.
> 
> When unprivileged eBPF is enabled the mitigation in the exception vectors
> can be avoided by an eBPF program.
> 
> When unprivileged eBPF is enabled, print a warning and report vulnerable
> via the sysfs vulnerabilities file.

> diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
> index d3fbff00993d..6d45c63c6454 100644
> --- a/arch/arm64/kernel/proton-pack.c
> +++ b/arch/arm64/kernel/proton-pack.c

Yup, this far back the code lives in cpu_errata.c, as it hadn't been centralised.
I'll look at what is involved in backporting the whole lot...


Thanks,

James
