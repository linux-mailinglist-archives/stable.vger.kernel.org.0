Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0274671CC0
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 13:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjARM4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 07:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjARM4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 07:56:15 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A570676E7;
        Wed, 18 Jan 2023 04:17:56 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id fl11-20020a05600c0b8b00b003daf72fc844so1302875wmb.0;
        Wed, 18 Jan 2023 04:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mQwYW5KDblKTSx+ajOZBkrTtlYIGhtAaQMmLmq0XAvM=;
        b=h/Z1OgTwkfzhRKOgLAk7YIrFqFsU7nvoJ5UVg9HF4H4VmfVTcnyYaRHmgy8G+5t83T
         kNHNWex2v+6OyzgY8Eh0ncnL0M18a6s2y95UIhG6X0IqkZHRe1FD3asUBODkGRn6Um6r
         zS4sl8/2uUCx0OnuJCnyZyq57zP3WIreoXhYH1zZScBEoMM8NiPv0xO4Z8jh6m1JJd1m
         ugglpIVn2zYBzJQMhpF4C324Nh8KTemo4Mfj7H2wrMsG61RkehMUCK9oN1JQqx6ejzNS
         fj/ttuna31hjAJ8vuN0zYvJH7AYIgfK45vtGyoB5cA5GaD3Hf//gZaSmFM+oXmlp3Cb6
         dQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQwYW5KDblKTSx+ajOZBkrTtlYIGhtAaQMmLmq0XAvM=;
        b=HYXrAvS4hVeby8SBbSvFanaKlbb5Q7HyToX05b61KvcAcWzG36fUrUWmf7Ddo3HKsr
         x6cC3esGP+mEu4WAwRwNFtUxq8a1rG5qixhAB6mtgOaEsG7hUOrSToxfgCl2+61Swatf
         c6bYGVU5pHJ43DS/sQMXl5y6LNezVdms/3rVhauuTpHNKQhWylVi2YwCuq/leBqKJLfm
         ejXDLEqtpniXuvwaknq+B3hm5Hfk/ajVRtlnJZ0kWKbPSqzYkIULh4ly9SlykBk8yaoB
         YhejT/6ayx8chi/4xKtOd9R88CR3nwwxeWiVQpEj/QjmY5fNRBK87efqqlKNskCLPjKy
         LNQg==
X-Gm-Message-State: AFqh2kplu5XEUJ2IEKbUcG1VB7//uQYv40dpfJKFMCcP9oJhXukHKYJM
        GVKMTVIHaTbyEw8qx0SHkbM=
X-Google-Smtp-Source: AMrXdXsq4d22ynp1z2KClSTX+9uf7/VlGE8AQQLMSxBMCLti3qViryJkQ48wlr6DxNf0t4aYwmcf1A==
X-Received: by 2002:a05:600c:1508:b0:3d3:5166:2da4 with SMTP id b8-20020a05600c150800b003d351662da4mr6598202wmg.8.1674044273159;
        Wed, 18 Jan 2023 04:17:53 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o22-20020a05600c165600b003da119d7251sm1702696wmn.21.2023.01.18.04.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 04:17:52 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:17:51 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/622] 5.4.229-rc2 review
Message-ID: <Y8fjb5TsQaSGpZFW@debian>
References: <20230117124648.308618956@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124648.308618956@linuxfoundation.org>
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

On Tue, Jan 17, 2023 at 01:48:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 622 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2674


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
