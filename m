Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428445ABBDF
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 02:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiICAgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 20:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiICAgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 20:36:45 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C8E9C239;
        Fri,  2 Sep 2022 17:36:43 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y141so3411109pfb.7;
        Fri, 02 Sep 2022 17:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=Wd+shfTse2Be8fvmZbQDLREAzIs3ZnsPcpYRi3YSys8=;
        b=WwG+6NTBj0DjRTF5ZVAxuk3vQ+U/Ux+iTdus16+Nh/V3TrAP7PdDnsw87zJYeOXD0T
         24gIdJ4Vp+fZXxrcBCltLuN408cM33FUMoqCj6rMl3BgniTsUgmdXAkbjcRuN2FpFURD
         VICld16M/hUGGxa3A9VRPwj8hzmnagVXc4mJB2vngv3PNxal8h/kFkDtMGaoAynFS5Qe
         X0ZhEy5/ubVG/EMAip7mlA1nxJ5q4+DB6eqtblgXvx/DTQOZzKdczMz4Sz8Tb7nKUuj9
         loG+5kwx9oFZoeHC1jZ+lZKlBduJbov23P/nOy1ZWAQTNpnRCGHdvfLk63ZV5DS2nq3o
         bWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Wd+shfTse2Be8fvmZbQDLREAzIs3ZnsPcpYRi3YSys8=;
        b=6r0oisTsQ/cAcPrDD//3/Jmskt+7OpqrgYGXeIDd3SyX5bE89h+QcxlAQS4EPuQHsL
         hYkb88Gb4odY6nn+fF3l0D73T6PMKoSSyS3bIQepz1IoAd3Yn94ArUYo37bM+QVEapT4
         FWxS1IEiVISHfI0FMTRE0Jn+EfAf3aWzn53YBunBMu8uof2aJnBQPyWy106c50ooIm68
         OkcAEl4+OkeAsrfgStaROLxkFIOSruSCJ4X9Mrtwu6TGKKlC1gF4tJ4oyh5mHb1B5uqS
         IEo9YeRu3STongCg/XWG5BkyELX2a6m/Hdwo8vocbMzAPsT+K4SJ9KSZx7OIgT7a4GRm
         KC4g==
X-Gm-Message-State: ACgBeo1hywZ2Q0jM/VydgBFK83UEK4H5AC78/aPqcB2LEwwAlTudRO5F
        EXE/GJw4Jil+uVDmLCbjpTg=
X-Google-Smtp-Source: AA6agR49KNaTio8CpzZx0h+4h9qpXaax0cgQHhqrkpZrTgX2o5GCx/gmzNqgjo68boY4Sr4Hb+Ml/g==
X-Received: by 2002:a62:7b4f:0:b0:537:dcaf:acf1 with SMTP id w76-20020a627b4f000000b00537dcafacf1mr35290556pfc.58.1662165403384;
        Fri, 02 Sep 2022 17:36:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902e88800b0016c4546fbf9sm2310326plg.128.2022.09.02.17.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 17:36:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 2 Sep 2022 17:36:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/73] 5.15.65-rc1 review
Message-ID: <20220903003641.GF847372@roeck-us.net>
References: <20220902121404.435662285@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:18:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.65 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
