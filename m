Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880AD573AB0
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 17:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbiGMP6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 11:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbiGMP6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 11:58:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A17550062;
        Wed, 13 Jul 2022 08:58:03 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so1456369wmb.5;
        Wed, 13 Jul 2022 08:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=48XiXsvgflXP27bBSXP7oTByPyeZt0B+vVdaoJE787g=;
        b=ZL3mtvrqgr0ayl1LX7eOgu5o1i7JW7HboekDGhcXlCj9Onsisq1sAJ9gAVTui/YeEP
         3kQffAiMc6cnQhfeBOY9jP8+KMfUOFIokHO2rc1KGESp1iVr6Ejk9Lm6RvF7HHirNJEx
         LqokN2XgCj+mK51WM73+AS3aDhjO+kCU6muAvE0iWe9vpGIXWQzA6uOS3XAJn6kjhakb
         4Tbm1Kd0HYHCueEL31gsbdBDocbP0hiAAFWYnn9pwZ5od+rrOqAhAF+sdZ0TlZTy+sBn
         9DEYqXbwkOpY4MP4a3dDwHSJCyrIweGxPsyVGH2vNzi+xq66Zum3rqvK4Vmynw7kwpjr
         Kubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=48XiXsvgflXP27bBSXP7oTByPyeZt0B+vVdaoJE787g=;
        b=O/YSEMlqL9Fnf8V9MegLByvLIfllwmxUW0Thxiz3HpRj6C/u3JixbSk1DlIz0oznJj
         4JbuedPKUL7vVYkr8NLfpH/ra+bcespmy1WdadbNeuRjxbnWE/5vomDbyDyuAquV9v9h
         g7cQ7Mt2ge/xesaXkrX/2+j2jmVsvOIwanZkUIPEJdKIRJAcIK/5Tok5SlLCWifhhsAX
         /sW9FOgAEbM8zk20Qc2532LB05BvlSkuVDR5PM+pWB2DHWRdDBbLJAdPdcbdoKi6Lxks
         2hKkOVGpgT48+2g05hP91Cor815J/HEVplOPodKUXxou0vK1IPoMiEDWqte5osaMh/fx
         5RZg==
X-Gm-Message-State: AJIora+/OCgKsaw6xrHPb3p0K5ndiMwmB0Kez/otYqK21Z76HDw1XQz0
        C17GeyH6ojLhaFWxm14iCSE=
X-Google-Smtp-Source: AGRyM1vJQ4+Ir2n/Sv6sNllUbEOX2zONlOVcJWrHnBtXuj9fOZN/S4YNaQJP0kKg4ZYdSeIuNL+EXw==
X-Received: by 2002:a1c:f018:0:b0:3a0:3f8d:d71e with SMTP id a24-20020a1cf018000000b003a03f8dd71emr4563333wmb.104.1657727881512;
        Wed, 13 Jul 2022 08:58:01 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id u20-20020adfa194000000b0021da61caa10sm8298017wru.56.2022.07.13.08.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 08:58:01 -0700 (PDT)
Date:   Wed, 13 Jul 2022 16:57:59 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/131] 5.10.131-rc2 review
Message-ID: <Ys7rhw7nKhMCDCiq@debian>
References: <20220713094820.698453505@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713094820.698453505@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Jul 13, 2022 at 03:10:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 Jul 2022 09:47:55 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1515
[2]. https://openqa.qa.codethink.co.uk/tests/1518


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
