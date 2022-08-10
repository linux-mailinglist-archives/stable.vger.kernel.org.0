Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D634A58E623
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 06:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiHJETP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 00:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiHJETP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 00:19:15 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B5B804BC;
        Tue,  9 Aug 2022 21:19:14 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso920638pjf.5;
        Tue, 09 Aug 2022 21:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=VfUAsm0a5MqrnTQHJAZK1DuhdIBh2RhMmlBI/LT8zT4=;
        b=T8Ix7wbjQiuBAhOeEWSSR6YRMPiNjh3DZr82CCFNF3TamND+KRYGnky1+VivFI9bxz
         6DmFhgNNPagmJ9zcxlTty/UYtojhqyJNI0B50HoA5DYgeh7ZaKt2kcOd366lBaUwvSLI
         Pe934Bo1PG8HUMa3VNhGzhDmxrbs5EbD9UmDlSonCbpnkHCsX7l0EvhQ5l2crkDZpXfW
         i3k7dDITJS7yX7CpG6Wd5QHn81yPu82ed7UHmz0AA8PxiayjKSDKOCsQNRvk25ce59oi
         EFcTkuCzNCoofDJwGnclQVIj6aym11tZHrkqypGWNOxE3l33wDAC4cseW+YiTNYIaX5k
         LCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=VfUAsm0a5MqrnTQHJAZK1DuhdIBh2RhMmlBI/LT8zT4=;
        b=U+t31AEqKR1Ch8WSq1jLKqZpOWYwaHxzUm1zP9X2+tHz7j+hNMKIeSVGz8Lw32w/o4
         6IeyUi4icAQZbu5F1xIfofUkJwXf7XDfUc6IEZUjfBSbizpTWKMJLKazDtTvV4u66ekz
         AhZb4YRuzlF9Gt3d0tz0Kk7gZIwRoCUTQ0MxQZfzcAyn+UcafounwqIISr6QxLv2Xepz
         m9KtEViHTPKAZXv5YlDmf0DklN6ZdVt5c3yJW2zyO/pM73e4jyA3oaaPUXlk3q8n4YWY
         +9SIQtzZEQCEYJBQEWZ2mPr4S/xkZBur0rhV3Zx9UjX5EGafwxQgXZZzxMIjN4Rc8lc3
         xrSg==
X-Gm-Message-State: ACgBeo3FDJuKzW4R4YVV6kJbIc2d2MT4tkhOlTk9a4+OdRy700dEeVuw
        MmD8JFNnk7q/ZKog4U5LwIk=
X-Google-Smtp-Source: AA6agR4JfzusQ2V2pdmsS5uzcW1kpSir/lfwhyxsolsJCHxqn/oJ1/F2FuoLmwOMvo8fhoyoGh13cg==
X-Received: by 2002:a17:90a:fc2:b0:1f3:20d0:2e47 with SMTP id 60-20020a17090a0fc200b001f320d02e47mr1685252pjz.117.1660105154076;
        Tue, 09 Aug 2022 21:19:14 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-89.three.co.id. [180.214.232.89])
        by smtp.gmail.com with ESMTPSA id a28-20020aa795bc000000b0052f20d70845sm709929pfk.150.2022.08.09.21.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 21:19:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7FC96103B15; Wed, 10 Aug 2022 11:19:10 +0700 (WIB)
Date:   Wed, 10 Aug 2022 11:19:10 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/30] 5.15.60-rc1 review
Message-ID: <YvMxvmvsH4wtACEC@debian.me>
References: <20220809175514.276643253@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 08:00:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.60 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
