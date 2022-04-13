Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02614FECDA
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 04:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiDMC0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 22:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiDMC0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 22:26:31 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ED92529E;
        Tue, 12 Apr 2022 19:24:12 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id p128-20020a4a4886000000b003296205eb59so125413ooa.7;
        Tue, 12 Apr 2022 19:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v5ZGKLrKQQdBRcm6fKcfYcV4BBmkSLJyNnFY0fCxmfw=;
        b=NAQYDY/VIc4UTOYivKD03T99Z4cL//qkStTHmKpE88vwedRdT4IznJevUQHYFoMiE5
         OywoHfhuutkPQZrLWcZtE7KytgGT7n32VxOW85UZkuVOE5EVOGh83z6LX3awmG6G52/w
         Fr8fAvswULTL3YZ9XHFijr2I4vbhqAQGX/1w7DtYFQLCJ+dNdICD5TTdVTX2cVbi4Lvq
         xCvjP8uAlOXyD67jd6VMXaU9fnSm3xQbTn8ANqGVBQ8ybuadHbJH3T8H4n6zxoP3Goaz
         cJjQ4Y2YJ5QVkxcVtXW11mO76QPvRRLf56fhFumeE4xX9RLmSAIDpD7FDaB5oc8kw4ct
         L4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=v5ZGKLrKQQdBRcm6fKcfYcV4BBmkSLJyNnFY0fCxmfw=;
        b=tjmYTtxwFUafgQA2wpFy5ipXKFFr8KjDbn69aspYtgvXFHqYk/P2SxqdWk2jA+IND+
         btsoLXPiV5a1zBpG3a+EwLOFJ9rlcgz+erbeseOi9m4dRbtBbK2lth3aJ8D0X3dBpGhH
         jN2wjfq7LUiwOEgafdX7rnFjTCP3dH3xLEkogQVTbSuUKPS2ox0SlEh3z9ToHXu8ScaX
         ZpeGgdiW9GGZaZECkPRSmoH4nEfBsVmpscqTpuwA6NH9T/LMWNFzo80d6TXum0CE1vOI
         nNGf9Gc6Zmdm4bm1MwWfhaYD32AKIR5ca8/aTf66YJwsSsgSv/eEsJEeLWwg/sZZmANW
         ae3w==
X-Gm-Message-State: AOAM532s9YKSlfZN102ENjlJ9XDqoaxsaOOEI7J6FyzERzpupWefTTzf
        BTJzuwbxXcDf78Im9bNantAXflpI0Dk=
X-Google-Smtp-Source: ABdhPJxdyhNXcbTUsGpA0cAYb2G6Mktod3LkblsSA/NEB2hc4NuL9eWlW6aQ03pwgYtdzCg0wNDstg==
X-Received: by 2002:a4a:c894:0:b0:321:1b7e:f130 with SMTP id t20-20020a4ac894000000b003211b7ef130mr12723827ooq.56.1649816651790;
        Tue, 12 Apr 2022 19:24:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i16-20020a056870d41000b000e1a3a897basm14157552oag.26.2022.04.12.19.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 19:24:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 12 Apr 2022 19:24:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/343] 5.17.3-rc1 review
Message-ID: <20220413022410.GB2128171@roeck-us.net>
References: <20220412062951.095765152@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
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

On Tue, Apr 12, 2022 at 08:26:58AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.3 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
