Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF07C6A1594
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 04:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBXDnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 22:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjBXDnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 22:43:09 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABED95E875;
        Thu, 23 Feb 2023 19:42:34 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so1540331pjh.0;
        Thu, 23 Feb 2023 19:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dm48pFZyVUakxJYWdujNt6jVqzb33IRoM5ttLAEElTc=;
        b=NckyLiPi7//kP1eOXaMTWSJx6sObdjPdjQ5u87ghNeY1HoSDgB6HJCSb3b3DNmOzzb
         S6adJSW7ggHTP78XJk20CzmhbUeO8fa7nVDiNBphzFhcMiGdF3dnJ8JJmVRSgtlm3XVT
         IyWIBFMU99fyzWiONpRCKEBs1ZURWHjgO3krA6dwTz9jtPF5v/emVqHQ1fDiX7CX1/Dq
         3Mo7YWEKfwFrR5aYBXnufS0BoXZSSKwLSlrkJ7kL0zm4D7DTz1xHk5qUfcT1n3YeB5HO
         GI0TAGfRyD4ia0ElAxag/nQsV0z3/oDdCN1eMat5Q4oF9n7cd0LeuKJc+kTACtC7BUWU
         f5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm48pFZyVUakxJYWdujNt6jVqzb33IRoM5ttLAEElTc=;
        b=0SGb/gE8P95QyQSRrWg7INTJQVSwR4GWSWPE4A5D2Si1uR5utVUXa5+RXQOndTg09l
         VnNyHtPPnbFrh/t30isiIGeJABYAB5sMlnL4sikT7XGe3GrCK1KsE+gLYvHR2p+uIAFz
         LSeP3LUCMOKCbgL4eDpU+ZS/S4etQNT/5FNDzsmoCq5q4YLZ6MY1yEUt0f2n/mnkTwS7
         iw75RxTTaqbEddpIErjHSJZuAwF2N4hqVw8CGPnOLo5ph0FPP4l6zIfGHD4NpnEmbOZb
         slheUf+3ZI0relI8dKzX4dMDa7zty/rvBYmyAs/ADP84FTQAaSQElO0vJBQcGaGytmn+
         9zkQ==
X-Gm-Message-State: AO0yUKUSiGuh6f8SC3GK8gyEsu1Pr0karMtbYMiPJjF6DT5Cx0ZCu7n0
        vyWzNEL/sh/Aunra7txHkQ4=
X-Google-Smtp-Source: AK7set/EF7WV/kje5lDltcwnQzpGuNdswVxJYj8nhFHVGkSTqyQ4dhXgEe9H8jtZ2HyPzr3AXMBCvg==
X-Received: by 2002:a17:90a:15:b0:237:161e:33bc with SMTP id 21-20020a17090a001500b00237161e33bcmr12796870pja.16.1677210144300;
        Thu, 23 Feb 2023 19:42:24 -0800 (PST)
Received: from debian.me (subs02-180-214-232-89.three.co.id. [180.214.232.89])
        by smtp.gmail.com with ESMTPSA id x18-20020a17090abc9200b00233aacab89esm429235pjr.48.2023.02.23.19.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 19:42:23 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 171FD105EA5; Fri, 24 Feb 2023 10:42:17 +0700 (WIB)
Date:   Fri, 24 Feb 2023 10:42:17 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <Y/gyGS08EIuFYxjH@debian.me>
References: <20230223141545.280864003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara
