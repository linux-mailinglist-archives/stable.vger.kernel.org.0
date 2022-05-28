Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0171D536A47
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 04:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240903AbiE1Cuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 22:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiE1Cum (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 22:50:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD61104CB1;
        Fri, 27 May 2022 19:50:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q92-20020a17090a17e500b001e0817e77f6so8603491pja.5;
        Fri, 27 May 2022 19:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P5xo1bFB58EAueBxvGYMNkb/9Rel1/20oqO8YBkucTI=;
        b=WW6gGfj2rUYzPhJZfPXkW25p/BgNz69+WlVMWV93xGmhTkmrDDYvBLwPtD5F2g5rGl
         6m3/V0T1LwdOxsLvBfzSeLL0aB4lDEZDTC/UuDROGmt8viYcVABDg9TcV/+nwCe8XtYl
         L+YNjKd/yQXMe/MWTi20z+6nxWWHXxIWDX3Y7awSCBtdlB3oEH/m6T+mO68njuGF7eUD
         exDSMQjbBHcye3tuiXk37ayul6ieUbJgG9Kjk67woW2uSsLmx0CYpahQ4PCQyz6g6h0Y
         OPG8mDETUJpJSWNaUJFRUFf4wIHZ/IDakB07ZqtLgQJBNs3dA1BomWWlJzJ5xM1Db9in
         rFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P5xo1bFB58EAueBxvGYMNkb/9Rel1/20oqO8YBkucTI=;
        b=PC1sGTv8T5lVzCAqI0zKK7vufa+FLJsNm3q0s6KE7/M65htjnBiENZpa3JngBV0gnG
         YSCrc4mXIvU75+ytUI9Cf3rwEydXaMptUrKAirkSecm0i4TaaXQ5NUsoP9AZ4fT8HMn6
         QrrOLFYsMYlykz53fF4ONcKYeZfHXaP2YRcWJK/treVyAaxcEtzvoSyJcbZtG3gPhpfP
         YaKiZ48E+NyKYILVAnMZ+5GE2PcQ9l/QlfmV2A9nzpcki5S7w/SvcU6mOE/+o+YNV22V
         FSOejgSBedq3d18rT6z9TRfmaiY+lfqDg8Qoysgas9yZ0un7IZzkemu5uNBGTM0HBBD3
         IXdA==
X-Gm-Message-State: AOAM5320aFE4kgQNuoUv9hguuVeJ/NXxBkToAjppP60zDdcPYiEpu3CM
        pBC8G5FgN74t8f1hVWXFiQtmSgCe5pg77/TD
X-Google-Smtp-Source: ABdhPJyBBoY4gi4gpyiJHe78GElVwaPt02zpBTmBcU15D7aK/DkadqwDcUehW0Kf7mlQjhoe0hE1cA==
X-Received: by 2002:a17:90b:224a:b0:1e0:f91:3a3f with SMTP id hk10-20020a17090b224a00b001e00f913a3fmr11415343pjb.62.1653706240713;
        Fri, 27 May 2022 19:50:40 -0700 (PDT)
Received: from localhost (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b0015e8d4eb267sm4513964plp.177.2022.05.27.19.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 19:50:40 -0700 (PDT)
Date:   Sat, 28 May 2022 09:50:37 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/47] 5.18.1-rc1 review
Message-ID: <YpGN/S5ioNbJqEeW@debian.me>
References: <20220527084801.223648383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 10:49:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.1 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
