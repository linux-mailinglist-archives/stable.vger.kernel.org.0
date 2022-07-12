Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65205570F59
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 03:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiGLBTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 21:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiGLBTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 21:19:06 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D3225C6F;
        Mon, 11 Jul 2022 18:19:05 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f11so5931839plr.4;
        Mon, 11 Jul 2022 18:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A7DGCMKP025OCWc2vwKYycd9+zuCu6iTHE/WYjdmoR0=;
        b=QDN9p1DVvWko6ZclfSR+y1/Q7BhGw60VqOBeIpC9of62xCjMhjaHFbxcahiCV5qXl5
         TzJ1M69XhHySI0SOZqJ79oY2rff6101O3MFzbQqtSHVmSlx4Zwo2KhHtN75FF582fVgu
         XK2sAx17sfYqIuTkPuSZ6kdh8EDtg7GCCbXiijQIzw6MrTntfZfeyLNvINqX9I08t6mb
         epYrhIE69styLQFwEgOfgBsjgN6S/Vp91z2lOUKdmoYY8AbbLLOK40VGrenu4mLaw9cI
         GGSLcn9JROGqG3kRe60jd21FMQJO5OLqwEp6X9LQzmBf926QaNSE/EekXj4VVRhScAGW
         58Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=A7DGCMKP025OCWc2vwKYycd9+zuCu6iTHE/WYjdmoR0=;
        b=bDDM1XV2TPfvlJkZ8hndLDhizUp7Swx8rK3IVbsiskOrO3HJSA+bwpMYkLQIIQ76Ju
         54+ylMobWmB7yfShsI6bp5SIeXhZ6Txl/CW+TEqfXilRRaYJ/QHPkeAsaM9mzOz9EeVD
         LqhwHauK4w1wSaebUVBwgeegpSgsz6FiRt1+SkOrOWtm4nY716W8uqdFZT38dFWCOrOs
         9az1ayuwoZDSjQVRw7HOcfLa8/nDHLEQ4ywjTwMbRfTK00K2+QXEMKN6sJOpjkM0QhY9
         1vNK3WBcV0sHI/R7CBX3I28YAlkexfBrpJ0SehBm/+6Jd3pAF4KiV+c9MaUDxyQqO5Qm
         35yg==
X-Gm-Message-State: AJIora8P0UlAYl2EOo/jfMS6TSKjRXb5ccoMOeiR5sJXTZAp968mgXqh
        IXHaUQYIsWeD1v4pSLZiv0o=
X-Google-Smtp-Source: AGRyM1tiP1yGKYV4fMkLvM6TjcUuSTwSv8MJSREJBhU0m0HGFVamVfAyHU/2jCQuOBbvviIoQ8WDDg==
X-Received: by 2002:a17:90a:982:b0:1ef:f525:9801 with SMTP id 2-20020a17090a098200b001eff5259801mr1317719pjo.191.1657588745538;
        Mon, 11 Jul 2022 18:19:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g11-20020aa79f0b000000b0052aaff953aesm5400757pfr.115.2022.07.11.18.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 18:19:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jul 2022 18:19:04 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/229] 5.15.54-rc2 review
Message-ID: <20220712011904.GG2305683@roeck-us.net>
References: <20220711145306.494277196@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711145306.494277196@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 04:54:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 14:51:35 +0000.
> Anything received after that time might be too late.
> 

This report is for v5.15.53-230-gfba36d04986b.

Build results:
	total: 159 pass: 153 fail: 6
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
	powerpc:ppc64e_defconfig
	powerpc:cell_defconfig
	powerpc:skiroot_defconfig
	powerpc:maple_defconfig
Qemu test results:
	total: 488 pass: 457 fail: 31
Failed tests:
	<all ppc64>

All failed builds/tests:
--------------
Error log:
arch/powerpc/kernel/vdso64/gettimeofday.S: Assembler messages:
arch/powerpc/kernel/vdso64/gettimeofday.S:25: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:36: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:47: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:57: Error: unrecognized opcode: `cvdso_call_time'
make[2]: *** [scripts/Makefile.build:390: arch/powerpc/kernel/vdso64/gettimeofday.o] Error 1

and:

Building powerpc:allmodconfig ... failed

same as above, plus

arch/powerpc/perf/callchain_64.c: In function 'is_sigreturn_64_address':
arch/powerpc/include/asm/vdso.h:20:61: error: 'vdso64_offset_sigtramp_rt64' undeclared

arch/powerpc/kernel/vdso.c: In function 'vdso_fixup_features':
arch/powerpc/include/asm/vdso.h:20:61: error: 'vdso64_offset_ftr_fixup_start' undeclared
arch/powerpc/include/asm/vdso.h:20:61: error: 'vdso64_offset_ftr_fixup_end' undeclared

and various other similar errors.

Guenter
