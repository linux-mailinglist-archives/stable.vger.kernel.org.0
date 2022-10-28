Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF76611B03
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 21:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJ1TnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 15:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJ1TnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 15:43:12 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36346226E69;
        Fri, 28 Oct 2022 12:43:11 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j15so7902354wrq.3;
        Fri, 28 Oct 2022 12:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=80FlYR4ra67WxSs9hG7X4/v7MPicXs8P7V1IbHZmi6U=;
        b=AFmoHX+zTSVWJ/FPNTT7aiVVklllmTVbnNvip/xTAVAd190pw8syBPclWFQiDITFdw
         TJe+h+zO+eoxmhwihRk5RkKLlc6TuUVht9dRQQD205/7jtKrqx1/pVDveXOkq/l9JQm6
         bEbrmj8UMIJDXJWkKLe46uTM+WQTw0SWbw1DoX4qMVLwDZJMIt4xinLZOgvmi5Vm02zP
         mN6oeW7UwRc3UCvJS0w0xSl9gpsvjQLkLpbxoaWRphEwTqWmenOEBgom7a+od7MnGnbV
         Nz17JAyI23+WOg9EYH6FHP9jHovk2Qzw7MRRA+TANLoGD+i0HiLRJsn5W7KlNQcy6W2E
         O+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80FlYR4ra67WxSs9hG7X4/v7MPicXs8P7V1IbHZmi6U=;
        b=IEQHI5wAcS8zNQrJeMjuvDv4hVwpGanzznQx7YD2aFr384Gz7iBgfLjIW7K8pp3F5K
         J2O9jS9/FDylrV1s1MpEG5LMMQ3BP+/r0BB5yaxrGS5/BvPD+E/biu+GLVl9DptA7O1R
         BGQJ6qHarVs+tn7vfV0VHFc/BQ5PdMnnhSkU6C49n8Qr6y/1lm1f4ofKJ2ur17vZmFou
         2uXmHebBnFc1g6UX7dQOfY09J7FpFFK3b2pS4G0LFL6fj/3Csyf6n8BcawQkWf0ikukd
         2RZNKF0wNbaSgvsUgO+0T1yCRqyLAknugB0f1mZ5fmYjH7xidXAvQgaGr8vTMeCmrF9h
         vOKQ==
X-Gm-Message-State: ACrzQf1/5N7RqV24pR7kJDlfpfQpiTllAGrnEmhMRp7pPtm8J4CwsRYu
        9k+L56YhJDrHRhgaJxuUgPaxtp7zfxM=
X-Google-Smtp-Source: AMsMyM7M7lqjoiGpYhS7NRkp4swbbzyv8eD1Jxf0VfzmLRHUirEHIM0KthXXrmNmjjZYXpkcNgqsLQ==
X-Received: by 2002:a5d:6488:0:b0:22b:3b0b:5e72 with SMTP id o8-20020a5d6488000000b0022b3b0b5e72mr567153wri.138.1666986189672;
        Fri, 28 Oct 2022 12:43:09 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j21-20020a05600c42d500b003b492753826sm4779470wme.43.2022.10.28.12.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 12:43:09 -0700 (PDT)
Date:   Fri, 28 Oct 2022 20:43:07 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/78] 5.15.76-rc2 review
Message-ID: <Y1wwyzl/2ZX7G4VD@debian>
References: <20221028120302.594918388@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120302.594918388@linuxfoundation.org>
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

On Fri, Oct 28, 2022 at 02:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:44 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2058
[2]. https://openqa.qa.codethink.co.uk/tests/2061

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
