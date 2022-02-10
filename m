Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAF74B175D
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 22:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344475AbiBJVBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 16:01:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243229AbiBJVBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 16:01:08 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C702E10E1;
        Thu, 10 Feb 2022 13:01:08 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id s24so7381065oic.6;
        Thu, 10 Feb 2022 13:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bpjj2tQ7a4F+UEWhrBX9XU1rvPuIjFQDC70/Ep+ucqE=;
        b=Lass6/mC88dNs0janWyijDSnH6MUbaJtY44uFb92jr4Ri7isaTva62YSFZFpRQtUAr
         3I0VmmSitpo02P2o3PIWVSjngUmf9aZ767N+c/MKYi88V3UcTUTrbDPYI5fZWZRWI8ib
         vuYOjScNil9gYq6wSulZngCxfV5rf+aoy2NXqds9dB7sheG3BVkoapD2He3NIimCooMX
         aTCnhDLFbfSRb98U8FPVJTwlBy2om32xgqiRGDOEH7y0QtyJvK27nQ8MUVmsNaB96XQP
         Pl7Dx80mkS2W9mP6TykwIYWIb+zCzTv66Wr0gZGhD+stnB1AIZZCWuvRR3Cpms7yabr0
         dM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bpjj2tQ7a4F+UEWhrBX9XU1rvPuIjFQDC70/Ep+ucqE=;
        b=IblT5UDoAxX/kiVWaVgNxFzeoIaVvm9eQwZA1bqfKV6OhznNJWDyLRSN9/zVnc/LjI
         hRbOEeEduvqQzzv3gos1ShGKqiAyp6J2aqB4kywVM1QSJWFA9vChNMo2P68FaUAKBZU2
         9Q9EaqS0po6jB6lI4FajX+nk7gsg68RsDe4sOrTA/P7B15yQYffLCKn9fE9TOVAd+8uN
         9E8JR3M4+U5XkkcjXS6BDx82X5DO/+i+A+HO8Gu05Q+SXcHjeMUtuBPLZXZ46EmPGREA
         v2LpWDdz1jXWbsBujDl+98g+Pz1skp2bD35H+125MeQBtnbKsPMlKSB920VHBahhmmaa
         0sNQ==
X-Gm-Message-State: AOAM533jUYF1IfF4sgXmhuX0TVhqR/Ii+mfPFt6yZ0/7VjhZvKFeQhq/
        amZ3MtKvsRKBf9rPvX+SJeTP8DTINkvviw==
X-Google-Smtp-Source: ABdhPJz1wbtO6lAY/KCSLkWWxabjRMa38a/jYhsBMda5PCWCW8VYMW73ZATuuZGA+OeRj6bVSoA/fg==
X-Received: by 2002:a05:6808:219d:: with SMTP id be29mr1795036oib.77.1644526868173;
        Thu, 10 Feb 2022 13:01:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v78sm8654559oie.18.2022.02.10.13.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:01:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 10 Feb 2022 13:01:06 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 0/1] 5.4.179-rc1 review
Message-ID: <20220210210106.GC2963498@roeck-us.net>
References: <20220209191248.688351316@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191248.688351316@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:14:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.179 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
