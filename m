Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DBC50609B
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbiDSAJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbiDSAI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:08:59 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E408FD23;
        Mon, 18 Apr 2022 17:05:57 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-de3eda6b5dso15891752fac.0;
        Mon, 18 Apr 2022 17:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uL+g4LiGSoHxKG5lc8Yfn2j7/n1lv4jEUcjjI32wVmw=;
        b=mn24Ta0iNT/ci/J7cPMi91sD3HbX0pqciSaGPtJF6BOIfwSRZzPSb9Pzd073whdklE
         vcc1fa2ocYWR+1gsR2Moqhp6qHoe9aj91cciExJkTP1gg2SlILlCKxtDzZCG6VeR8fzm
         bDCeBCh34Ap98/fkzNpID6Jw+Q2tt1lIq5X3xAkCzzKT9MGCpJbu5zcCQnLkNhJHRabG
         JSQZ2c+utC3COqgR9OEcGmaADLPB2wq2IsaF5+ztwZ/7m2Dt4KJLsfSd4KayUAGC6e4E
         nGAqujzwcZKp6SZ0gEQcD/Dsevp77r7ypJ+aC5ukwyFOVEeCtnXCr1mmMx+EKT1Uh369
         nGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=uL+g4LiGSoHxKG5lc8Yfn2j7/n1lv4jEUcjjI32wVmw=;
        b=LhStHu3uvJRubXZPX7NtFWNynDJjxYY3lRiu/qtj8Qxyc2+A6bE9ckWFD002FOwZdo
         opdOOGtc9166l0nLdyEg2YYv+SVMgSLaOKZm7dv/wRIJImmpq/jIH2VufCvtxDW6XEKF
         tWHQTOjyQTsj6LiWcNtVjOJf3BF4/PVc9deqIA+r784Plaqv5RXVWGzWmOz1Om5x03yY
         inrX8y4FcnjypnDoAiBTMseIDmJBXqDvQ6MFmzhZeiU0oEkG/dLhCrz7yjhLB61tiBPn
         gnZJE2m52ut/GAG49fgfKU774BBRdHCQa3MKV5waaU3nvJhajcJYV3TXHzLiFwSyuFeL
         ud1g==
X-Gm-Message-State: AOAM533qST4Dnwi9856B6VPzzvTL2QzaDphiPj3qVK9ttCzE/QI+eitN
        Xj/Jwl9iEumgowZ35HyZPJ4=
X-Google-Smtp-Source: ABdhPJyglRQzjtVLuFY5rAtcTK9/50EHdG37wurGAWA+qo3ECoKAjJXCGkH04p5crEZzoTE7+a7MZQ==
X-Received: by 2002:a05:6870:2404:b0:e2:8913:98d7 with SMTP id n4-20020a056870240400b000e2891398d7mr7037679oap.16.1650326756367;
        Mon, 18 Apr 2022 17:05:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id oa9-20020a056870bc0900b000e60e510d5esm646840oab.25.2022.04.18.17.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:05:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Apr 2022 17:05:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/105] 5.10.112-rc1 review
Message-ID: <20220419000554.GE1369577@roeck-us.net>
References: <20220418121145.140991388@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:12:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.112 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
