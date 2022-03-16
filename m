Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490374DAC6A
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 09:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354533AbiCPI1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 04:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354534AbiCPI1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 04:27:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C6C63BD6;
        Wed, 16 Mar 2022 01:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7246100E;
        Wed, 16 Mar 2022 08:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ABCC340E9;
        Wed, 16 Mar 2022 08:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647419161;
        bh=yOVl+FQTQWwlW6qkOjHbShzpJFR8SvXUEhmI+JKz94s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=COgMl6WYxYf9ROMwBJr6Pr5aZOwoXcI9xdwMsC4QC4BAIGTfyzvPvpdFL4ZdBM8Su
         SejiS401i4N1IeP/XAuQcbf4XRU4mc+Ux7YKnIuUhfw9RTgcsvakNIz5A9MGp/ExXJ
         d3pmZeUd/K3BhtHCEKNdmQ/jI6vz65naIRikDkus=
Date:   Wed, 16 Mar 2022 09:25:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/29] 4.19.235-rc2 review
Message-ID: <YjGfFjzdemmtiJE2@kroah.com>
References: <20220314145920.247358804@linuxfoundation.org>
 <20220315005123.GC1943350@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315005123.GC1943350@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 05:51:23PM -0700, Guenter Roeck wrote:
> On Mon, Mar 14, 2022 at 04:00:14PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.235 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 16 Mar 2022 14:59:12 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 153 fail: 3
> Failed builds:
> 	ia64:defconfig
> 	ia64:allnoconfig
> 	ia64:tinyconfig
> Qemu test results:
> 	total: 425 pass: 425 fail: 0
> 
> Build failures as already reported.
> 
> arch/ia64/kernel/acpi.c: In function 'acpi_numa_fixup':
> arch/ia64/kernel/acpi.c:540:17: error: implicit declaration of function 'slit_distance'; did you mean 'node_distance'? [-Werror=implicit-function-declaration]
>   540 |                 slit_distance(0, 0) = LOCAL_DISTANCE;
>       |                 ^~~~~~~~~~~~~
>       |                 node_distance
> arch/ia64/kernel/acpi.c:540:37: error: lvalue required as left operand of assignment
>   540 |                 slit_distance(0, 0) = LOCAL_DISTANCE;
>       |                                     ^
> 
> Tested-and-reported-failed-by: Guenter Roeck <linux@roeck-us.net>

Crap, ok, I'll go drop the 3 patches that this change came from.  Odds
are someone still uses ia64...

thanks,

greg k-h
