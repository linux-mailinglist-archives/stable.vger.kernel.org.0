Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4B960C29B
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJYE32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJYE30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:29:26 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7056AB1C;
        Mon, 24 Oct 2022 21:29:25 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-13bd19c3b68so3586524fac.7;
        Mon, 24 Oct 2022 21:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXPJFFzeRPOSnT6bSMVtRNKw2fAJ9TYO77SCPwInrqY=;
        b=eZEts+HxhAYXKMA68oLzSNltZ0V9Dq7AfTKA8HH4yoBGKhJMsKbpOIy1ULMY8pWSGS
         Kxd9VIdEJ6q0yfjcA9lc+HZ5WWfbMP/5z/gkT5FAKitrygWm59SjI/W1x7Y1DFSwPvbd
         o7ArOvpoFfeCUoFfPfCHiHUHw209+5LGB6jmu9dG7az6fCMdWb8XhbeWZDyaaSe67VsW
         Fqr72UqFB3IO/wjlfb6uTeZ9aDSq6bNTiuofsoymiDgOm3JW3NGW8xLuhJ2O1h8juMuN
         +1JTEgZdMSUv40s4YR70UliUkbqB8ew+Oc801cxQUhBZWnSGwkPZJJrezV1O3Mr/6dSw
         so6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXPJFFzeRPOSnT6bSMVtRNKw2fAJ9TYO77SCPwInrqY=;
        b=dtRyPrvtuhksXPVpvx8EBYxz8WZprX5rq99hihPB5B5LKIdMNgE0vA35pJIOqOZqBT
         G+maW4CVUca2oqlStg6lyth0CGOtyKwKhVVPIHZS/GlLvwIaYflz87Bhry/K9d8eHfW4
         Ofm40+q3/J2dENkHH33J7A1s/mBAmYLOSG/MF1Z2qAQRyTsV50OYj4gRoUFHZWdKyIAR
         D74ApKqExxMpiU/Ur9ncQ/Ahwbmfw+a674H0Fth6GCjZOqe08bOxwzb5nrMphQD2faou
         cL8xgoAUk/BobuBhbpKm/bJQiwb6FSwhiSq4Bos6qLLyEzrDVIM4jOW1KDuqqUG3d1EO
         0RJg==
X-Gm-Message-State: ACrzQf0aK28mSHlNi8lqdbjRh3YrLcxbAzL1Ql0SkEDZG/3XfMZ3jfo5
        pFpELHP/sdKM4DzQyHLEq1U=
X-Google-Smtp-Source: AMsMyM7t2YPRsKorY/FrppCYPMCq1WijmGqqoJtKC22EUzo9YhxhsPZ9hrdIImuhEjRfMTD++p3ODw==
X-Received: by 2002:a05:6871:687:b0:132:fd73:4551 with SMTP id l7-20020a056871068700b00132fd734551mr39588131oao.195.1666672164783;
        Mon, 24 Oct 2022 21:29:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y3-20020a4ac403000000b00480d833038fsm706220oop.48.2022.10.24.21.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 21:29:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Oct 2022 21:29:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.9 000/159] 4.9.331-rc1 review
Message-ID: <20221025042921.GA4152986@roeck-us.net>
References: <20221024112949.358278806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
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

On Mon, Oct 24, 2022 at 01:29:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.331 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
