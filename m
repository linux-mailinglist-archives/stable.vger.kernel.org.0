Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189E05EC094
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 13:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiI0LIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 07:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiI0LH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 07:07:58 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E8811801;
        Tue, 27 Sep 2022 04:05:46 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id ay7-20020a05600c1e0700b003b49861bf48so814406wmb.0;
        Tue, 27 Sep 2022 04:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=I/+qazAbCquknbfC89IGs5vFGdodx7UdB0Cp6y+C5Us=;
        b=fmdJXDwrY5l89G0IrG6tM83x4WXeQcNYYAqBLvg7WczU4XCO3KLwj0dfsT4HDzcswl
         5gQXbbqs4y17JLlkGgEJa0yzlQKdyhP11oTLcnVxG2GG8FiPH0w5kHq0CsjICmZCeXpA
         boVVhJzSqDFvh87LBsQa8JQkyG86ZvEdGT2LU3FdT10mKKBbHaA+lSHUSWFpMVXQoAwl
         hJyrHTNbW3eHKdOZbNoHC4YdYz6omyi+dhvNl/mnO3DSmVblipiY7pNvVCm31yhp8j0N
         +YmXEORbsvV/ZazeF8CAh85zyWoe72qtze8SPpxXem6yiHkn+ZPOjP6TXzh65xFVfWiP
         esuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=I/+qazAbCquknbfC89IGs5vFGdodx7UdB0Cp6y+C5Us=;
        b=o645mRt4evK7//AzpMLd0QZxuqUWlvJO3DwKpKChLC9THHA0H9ZV93U2+0sXu8yeLS
         MvAmjO0kWcUn7jqDaFB87eUDyUeLumPBDJ/1vd9//Wq6qr75QbGoiYJAzxoxtZ1nksLe
         4iLzS99grCEIccOi4eAK4fs7fE5vs/B/FOPUhFBxgxF/uWWE1b2tro3aV+jgdEBrKKX0
         sdqS9E3vaZDkM8tlc/Qvr0r2ixK0amMfYUIlleIZq/XU8dUMDXuW2MjEmk83G/5cazWA
         fIIVsegFXHFYyjO58qP+MdOmxHAEy6u94pKhK/GZmmzUvfDxmOc3xAIcckmE1OjW1/m6
         acOQ==
X-Gm-Message-State: ACrzQf3Ej5ScI54n0RwH2NGGnO5pl2tmY6CzeD2xN1zkZEhYwIvj3fm8
        gZTOZ930KoootYphuEpYKzfJnsK7Clw=
X-Google-Smtp-Source: AMsMyM7A43ZPh9Z/VL0ST/XxYq4XRcmEujRMR98VNm81EP0tMx56R5ZXR4dsqyMD5CMNAlLVxZKb+g==
X-Received: by 2002:a05:600c:4fd1:b0:3b4:c00d:230a with SMTP id o17-20020a05600c4fd100b003b4c00d230amr2145645wmq.62.1664276744925;
        Tue, 27 Sep 2022 04:05:44 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b003b476cabf1csm1943979wms.26.2022.09.27.04.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 04:05:44 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:05:42 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/143] 5.15.71-rc2 review
Message-ID: <YzLZBlpNUNSCTIhN@debian>
References: <20220926163551.791017156@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163551.791017156@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 06:37:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220925):
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1906
[2]. https://openqa.qa.codethink.co.uk/tests/1910
[3]. https://openqa.qa.codethink.co.uk/tests/1913

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
