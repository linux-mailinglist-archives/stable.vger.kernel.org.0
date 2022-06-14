Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C80154B4D6
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 17:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356891AbiFNPgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 11:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344072AbiFNPgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 11:36:36 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F973F896;
        Tue, 14 Jun 2022 08:36:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t2so8058173pld.4;
        Tue, 14 Jun 2022 08:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dv4biwQeh7Ed3LXwlQIVQYCCbthcKgtA5OHubbSXGeU=;
        b=ZInJR3dzSQJRMo8PajSRPZKT89e2NGw8no052HJf63eOIgbzNiNHshgUwEPfw0un9Q
         HVUQF+pqw98TTvq16KmKc+aK01OnaE8I4DEq5rg21WXUjcbsQAyC6bgrgC62vpYl1Nm2
         cyH0tANjk21u/zKhuYZgtLh5Jn6221UNVD5LGkWJatX8H4Cd9K9iZBusqFemqZPpi8O6
         Qnv1wFxHhGnISeyiDbaYrovAHZds1H0WR18tXGQKv8yRia93Dy127SlWEARCYALSIehE
         ABZACuneEPt4bgXCdVfdgn2IPuM2CIDP/yJfQgTXdAWk+Vfpr4UuuUX16Vp9D0g4eHgh
         Zwpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dv4biwQeh7Ed3LXwlQIVQYCCbthcKgtA5OHubbSXGeU=;
        b=joYO2r9VAtz5x8rURV2kO94kl1rsZfpukFfjgsrfMh1e3z/ViQUIdQ+Si2nStnCzj0
         Nor1LiLKQa9MGA6eKJ6uRHxnG/ajdVqvGGRekmetyd2pdwPnQPhCeLyoDVIv6deIlXnp
         xKobATrAT1AoeEHGyOaS4ZQ323UEZkSefWC1CEOIkD1GkjX/+3Jc/GK8gijYCmIzLNmn
         yEctwfYEitxVcEbrlShzJHK1D0QIMYPpAlG25qH1OqoV3WeqiU7vW80loVeELxuPa/zZ
         AiiMekIF2fIjYB2cjSjsxbBjrjPTfutTQgbKznNHO9RqVymjmeCu0ouxqdSRaC9baZKR
         nwsw==
X-Gm-Message-State: AJIora8/3oVb24JuBiD+D7tPLPzC9WN+q61Zz28shru4KVFqyQzTWvgX
        qUja15Ys1JUTVM9IQPT3kFwaomOKBx8=
X-Google-Smtp-Source: AGRyM1tjKN27zpjcpXFw7T+2VANw22STjXKOuFuOomVD8R8yg4C2QgPhm508k1AQ/R+IAQKfwOdNeA==
X-Received: by 2002:a17:90b:1b07:b0:1e8:41d8:fa2 with SMTP id nu7-20020a17090b1b0700b001e841d80fa2mr5193512pjb.204.1655220995125;
        Tue, 14 Jun 2022 08:36:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v1-20020a62c301000000b0051bc581b62asm7729839pfg.121.2022.06.14.08.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:36:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Jun 2022 08:36:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/303] 5.17.15-rc2 review
Message-ID: <20220614153633.GC3088490@roeck-us.net>
References: <20220613181529.324450680@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181529.324450680@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 08:18:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.15 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
