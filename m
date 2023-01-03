Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EB365BE42
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 11:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbjACKfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 05:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbjACKfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 05:35:15 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE64FAF6;
        Tue,  3 Jan 2023 02:35:06 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id b24-20020a05600c4a9800b003d21efdd61dso22747636wmp.3;
        Tue, 03 Jan 2023 02:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AfGReWJsEpgaC6MfseBZWuw9WJkIOAaz/xT/DXX/SQU=;
        b=h1QSt+MknGre39BJ3Yo48XOqq76l0gckHT2kutJymoheskHYcPM2hx+Jz9hrZiyMid
         LaJlwr6uoJWjPizaE2L5HJI+IU0peEYrP29PMYyTspZf9UKb0rJItRuMEjlly3c/Gf9O
         tAOSy49U9WKvfNkFxIzlkq+uVbwebchmNkOIiPEbTRP7TQ9Co9OZxLh+uZJFS6VqrSzJ
         fWOS6jOBkwECFgTZfZlxFt7JTX/tMN8mBOPgDK9j36ohhCXmLWxMX8+0zsASn7TEISlZ
         GLRMSlz84JakMsenRmYGy6GXENNR/ZUV3xz+h1IzGxlC1BNLDZyFRrKkdbTdkYTKc6J+
         RzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfGReWJsEpgaC6MfseBZWuw9WJkIOAaz/xT/DXX/SQU=;
        b=HjByeFIke7iNDo7Lm3mFmPHUh1QTQFc/eEtcQlWijizfXpCUk1y8MQ9T7Rubf0oPgS
         c+38eBSJCJoR7Dsq4TGp8L47PTwwXuL7qh0ISBiTfEavWuOqchSwlcivYiIJQCXhPpME
         htLjT4l8Xsc44T+3WUBQ3gBP2CK/XnjLSanK0N5L8Ju9G6wU/NHq7NoYHGgnzLLDbW3N
         LTqypISUXMKyB+zj81vkuy6QJNwtVhBF1ISuc0kRtoC4PC7SyubcrAH06ebaxzFSUGsI
         M8ZFf8zrqnSB9Un+2uACelWOAociqtGsXUKpKiwq4TLBdjZeBTiDSLS5dDnBSuF5Qshd
         6Lfw==
X-Gm-Message-State: AFqh2kpjB0x7Pw2+72KrqNKZ2HUMJ0SQtXY6wJEQmjCEqdMyK2shMXZT
        lLWcNTSWZ6iFyT5aKP2Bg3w=
X-Google-Smtp-Source: AMrXdXvAgmJxGp0ZymYz1kaRaPpZhGWjGO9FbeOEeYVlz28b4UTTrLiCHaVQnyc/IPneBTDZD2rq5A==
X-Received: by 2002:a05:600c:a4f:b0:3d2:196c:270c with SMTP id c15-20020a05600c0a4f00b003d2196c270cmr33126523wmq.31.1672742105262;
        Tue, 03 Jan 2023 02:35:05 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id fc7-20020a05600c524700b003a3442f1229sm52161164wmb.29.2023.01.03.02.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 02:35:04 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:34:58 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <Y7QE0sSGtrM54Ch1@debian>
References: <20230102110551.509937186@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
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

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2542
[2]. https://openqa.qa.codethink.co.uk/tests/2543
[3]. https://openqa.qa.codethink.co.uk/tests/2544

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
