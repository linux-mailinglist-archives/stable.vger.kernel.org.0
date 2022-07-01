Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A009C5627E7
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 02:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiGAA6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 20:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbiGAA6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 20:58:46 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B04B599C4;
        Thu, 30 Jun 2022 17:58:45 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so4936288pjr.0;
        Thu, 30 Jun 2022 17:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4FT7xtlckYCIRyfX6vf/17noDK9uQ9l+VBKCbjjWfJ8=;
        b=gfnmiOHmucaBHmOE5Zd9dVlesnUzZeaJ7bFWFjh29SFzbXvegy979FVGVmkHsrOwJV
         VH4yacjNYTCgw54Z+WQygJu7lKHZDmd/bx4NdDQnNCaFNW8pgLOUCOGo8zJjm3HzJIl/
         Ly2idMFj2dovLsyJyJvNm4yqdHFwr95GY0I7lLyUHdMqtPfdAdmFPwJX0elJfwacWzQ8
         5BzUNi4TaK1kFpRVzzqoTmnDb2eBLekeX38pHh3zY9zXDlm2SUh+nVNNTn+O8eu5gBLA
         rHjfo6ioB0SuvH28BjOFQrkmZmcTGRnRdADCGSBBFa7TbFpVyDb1v5AemSxnFEL6KPa6
         8LSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4FT7xtlckYCIRyfX6vf/17noDK9uQ9l+VBKCbjjWfJ8=;
        b=kSArAwSrupaqp88D2NsSGPd85lUIF8p10J3AGi+PXHUOhm/fsXXG19gZWgpYfW16fC
         uJRzJ7N9L9FF0yo4LQvtxIqR0nH7qbHT1P/PCLdnhI644kj9EQqY9kIw48wO1/jOOPw2
         xKbcE+f42BTSDijOdJPBm1lCjQQH+6Q4ae/e+9XGv/FyTKC1GZPdPbKJ0oLriKLxYuUv
         H73O2cZzqKDLhmRZc9PUFg/aVKoRm8erxTe0Jk3yND4szJa5/8Bo5XJ2Tqj4wPnJA42K
         XXDxLqwAgx7gF7/3ZtShMllJVlrcXEF6uBIT9WjrWoSxNYBeFpGrmY1z+FtjbdNz3bAx
         CPNg==
X-Gm-Message-State: AJIora/apTos6xKYVhLmsgJeZBbWOF9/R/8aK/lij0EnBN0uTl2ef7Ho
        KRKDbdoOgIcNpmi9dDD3C84=
X-Google-Smtp-Source: AGRyM1vHitwoLwFrRVrQjpXF1UtsPR2SjCJTO/zpgSTZljMNfee75g0mZnMEe7BFtd5Ih1bLehUL8g==
X-Received: by 2002:a17:902:ba90:b0:16a:2863:fb85 with SMTP id k16-20020a170902ba9000b0016a2863fb85mr18206558pls.15.1656637125198;
        Thu, 30 Jun 2022 17:58:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t10-20020a17090ad50a00b001eccaf818c5sm2033740pju.27.2022.06.30.17.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:58:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 30 Jun 2022 17:58:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Message-ID: <20220701005843.GG3104033@roeck-us.net>
References: <20220630133230.239507521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:47:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
