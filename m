Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017EA6A815D
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 12:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCBLl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 06:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCBLlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 06:41:24 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A522B2D58;
        Thu,  2 Mar 2023 03:41:01 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id v16so13405645wrn.0;
        Thu, 02 Mar 2023 03:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677757257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oC1DbDlSWN0TGCPVLZNEcsLa7RZfu8RnAEjQdiG3KSw=;
        b=TpBM3QY97ZtmZG+k4ZeAN2Fdtgk+wGLaR9y0Sa/G+BkfuUurnoBacXmmraBjEYcwm3
         +lCDCBnqzxOnXhgEROFU0F6MGUFEPY64W9+Ed/P1RIm90G3H6FsReK5PjvHVnUYJSEII
         KK1QWHR07aOirAUScWhytYOw4oVGc7y9fnO9NSAp/1dJ1lWuB1ty9JgEpIpvRh2yN2HK
         jvpo8rdcqyHyE1bCqskIVB0nyL0tzj6A/EQCSuj420ocjhxhh0Nm3WTsOktL1ZU6wbD2
         wUOqVV0XWMiAbFc4bJRS44kqqaBgpf5uIVfKOxE1z4pcIU9HnwlxlMp68wAJz4VhzeOw
         D9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677757257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oC1DbDlSWN0TGCPVLZNEcsLa7RZfu8RnAEjQdiG3KSw=;
        b=xAowpcO3ATr4/Rmm/YpFJPGo3FAz+EnSGCcgBiUNUbLKYp8ea072gCnFfFv9ez2Ktf
         D4LIROJzNTdUmH0sM4aE+/7PSH4kpdiZabY/mvrrYCIpPnWYJPOL4WB2UI8WKMNoZ5p2
         xcQVyK02twPO6XeeOcUVgVeXHOBTRPqTwGQsyFNmEYANtuHQNClZLsJxlJSTEpcIEfn7
         OcjGPyNIyI1GViGEtgrw/XIcPRWbx4Q31NUpGDo63+Ub6C9/uf3bMHbhsNMKEvcgGhp4
         u5Y/TzRDAxAxlaP+bwwA+ib5i5wSVlRcMAGjkkzrNigqj8liVMgeQCW9GVtMeQ4RSBBs
         BYfw==
X-Gm-Message-State: AO0yUKWMpC4eg3e1FRWnVvj5kFBizo/azpy0flkHC68AyZsefnSNiOJj
        Yvugb/lByZ8MHzE9p8jfwv0=
X-Google-Smtp-Source: AK7set8cbosfnmyBbKxsgdiY/Kpjqi6P6a9mCfqoAUbLFvws3qsrucJMAviDpLV2Jy+dyziHoyTEbQ==
X-Received: by 2002:a5d:5186:0:b0:2c7:454:cee3 with SMTP id k6-20020a5d5186000000b002c70454cee3mr6951668wrv.7.1677757256882;
        Thu, 02 Mar 2023 03:40:56 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id bi25-20020a05600c3d9900b003e89e3284fasm2623054wmb.36.2023.03.02.03.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:40:56 -0800 (PST)
Date:   Thu, 2 Mar 2023 11:40:54 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Message-ID: <ZACLRjbPOKjeGrc2@debian>
References: <20230301180653.263532453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Mar 01, 2023 at 07:07:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2976
[2]. https://openqa.qa.codethink.co.uk/tests/2984

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
