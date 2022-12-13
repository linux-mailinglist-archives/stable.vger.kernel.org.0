Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C39364AC47
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiLMAYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiLMAYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:24:08 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD0E1DDD7;
        Mon, 12 Dec 2022 16:23:21 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-14455716674so10599979fac.7;
        Mon, 12 Dec 2022 16:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWRRBJwqz9M78uBhUbPd2Wqa0O5Mu6T0Z4NHOcknz4E=;
        b=alRC+lsmlCQzCgOLkQEwDacTNL/gdlGT5N0HZmjwTuAmmvnGxTTWkxCH2onpHs0uc3
         ef418gZEWMCbfeum/GLCj/vlr5WWtZyWbuBarCTWd19DlqVrcZtYvxlMYdtP/Odphbd4
         1uUrauOpWiaN813DvHjKQmSLgAlO5AhctL8p3HfqGsZzFpCsqLqn9+fDNAxm6tknQ/wg
         KzLKp775N8gJXMVOmRso3Rifn4mHmvwmstNHNPwh0JiaLmIuTb0AnHgRCJGsyxSDrkON
         YfEiaf0FiJ3iM2z4MESSs5Q2wOYO/V2M5j4KBEsnr5BufUo7SvP+QYACX1tG2w1NKov/
         yegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWRRBJwqz9M78uBhUbPd2Wqa0O5Mu6T0Z4NHOcknz4E=;
        b=HbeFtISvKfUS6Ej1L6xktrUxL0PhmtXuR4+ocvbmIQ2sISk7IPUV2EN5YU8hpbaq7C
         MUlsIvD+wYPjAEezemGHKZbWNOoEBfr/QEXaVhBIc8e38UGBA2X9qIZJon/ofoWM/+fu
         vaiZwG8+byQcNjqAVHph8C2+C3QhXhx8sKtLpcol53c5cms7EkXvP+Zxwkd6Zg8515yd
         1zaL4p0aVq2zyrvz5UnWWVvUG02EVH0dwt2NYvUpl/UlOpd76lcs6wgb25lFdV1Xe2oS
         RhJzZWFo/gsUmYc+8fe+JZRI5KSnfiA7ZkJyzQ5mTjIlH5LtJOLXclENaDNGcVJ751Bc
         5+ag==
X-Gm-Message-State: ANoB5pmTFUErBRy8mnnBRrtomrJ5ve4x8gxgzKd/9yhFoUd3FkUdGdBX
        wYwAv/4UCbXPuwlVhoxCkGOsxxzbJ74=
X-Google-Smtp-Source: AA0mqf70hQVz1iHWAblz6DYY/NExSanSWJiQZ0ImgGuZLWoh/tWxLIpGUpPzZa6k4OwAWlyLk3jbyg==
X-Received: by 2002:a05:6870:d9b:b0:144:a3cb:3fe7 with SMTP id mj27-20020a0568700d9b00b00144a3cb3fe7mr8831699oab.40.1670891001148;
        Mon, 12 Dec 2022 16:23:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n1-20020a056870558100b0013d6d924995sm667219oao.19.2022.12.12.16.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:23:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Dec 2022 16:23:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
Message-ID: <20221213002319.GA2375064@roeck-us.net>
References: <20221212130909.943483205@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 02:19:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.336 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
