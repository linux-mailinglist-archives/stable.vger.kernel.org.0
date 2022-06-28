Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9127955E439
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiF1NQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 09:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346173AbiF1NQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 09:16:30 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D813205F;
        Tue, 28 Jun 2022 06:16:19 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v14so17645576wra.5;
        Tue, 28 Jun 2022 06:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OF8+wuAU0MUk90WE9+RnBsdbMFKcgcNmC55SJVRxGno=;
        b=BNgruZQ6jQ4QwdKvusVmf6nPU5Jrwwzo21is/E4eNCRPwH2AxzQqSjwpfRAcBHFBqs
         iblS815YaHUEgisF+H2RCH1WXvV/Zgj8sNb105UfUEYPGEkIfMhn/ewVbEIQ3UxZW9H9
         HkUp/6F/ZKUMIBs/njzlqG6HGtV0pgk4eFiXiYNadzJ61q3sfbDvrY3wKNhVdFG1l7hi
         AlycSCsQ5JI9DeUs+r7fKaiMOeipv/WtUYJdmpOsQO1LtE2aBk6Jo1m9iNP7xoMRtM12
         JSLw3665H9UUf5P0GuupDlC6ZI2SoMEMJhaLRNf/JanRR3e67Qu3XNYUmR/kmldbRTrU
         eVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OF8+wuAU0MUk90WE9+RnBsdbMFKcgcNmC55SJVRxGno=;
        b=YlfNpDqXqbBKk0+HZZbXZZyHC9HDEayhHs3vKAE1nltlRSB1FmcqUqk77umXvJ7cyI
         ExclldpkZqO9c/W+moK9IgS8PHFchar3HUR91Og8/HuanGpZ9eFCfeaj9efdCvSHVXUm
         kkLdWRu7v/tB54do9/Y4m9VxPnTVaV0pqRDSM9JQH4Y6Sxq/9AbW35H8AKpS208rvic4
         U2k/thO6Wg0x40WjY9V0rxdh8KeyDZe/b+OCPaqMHD6bGq8O0txJ9reLfwsA8S8Ky36j
         3gN21nRWsSwr1a8AuoPMW2G5oBqtj92gpJm/wLshEO/ymxGAzNB4NTRJVrRj4SPkh3g6
         mcGw==
X-Gm-Message-State: AJIora+XG6uEA/NOsSFKcn50YWpNMdaZTrNlZppclzkQPIEgeV8SUDbH
        T9/m0AQ6KhW5jr5FKsO/LHs=
X-Google-Smtp-Source: AGRyM1t+qfltl3toomQYvihUHEEwnmbEY232i7dr9qSSacuIacCTYS8Qi9hZZINtwAZWzaZrpM86aA==
X-Received: by 2002:adf:f446:0:b0:21b:821f:a916 with SMTP id f6-20020adff446000000b0021b821fa916mr18000715wrp.11.1656422178306;
        Tue, 28 Jun 2022 06:16:18 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id r15-20020a05600c35cf00b003a0375c4f73sm17445535wmq.44.2022.06.28.06.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:16:17 -0700 (PDT)
Date:   Tue, 28 Jun 2022 14:16:15 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/60] 5.4.202-rc1 review
Message-ID: <Yrr/H/Od5FJN1pro@debian>
References: <20220627111927.641837068@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
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

On Mon, Jun 27, 2022 at 01:21:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.202 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1401


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

