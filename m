Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B822D4D3DC7
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 00:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiCIX5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 18:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiCIX5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 18:57:05 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5EC12223A;
        Wed,  9 Mar 2022 15:56:02 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id im7so3327029qvb.4;
        Wed, 09 Mar 2022 15:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=rizZQOUvkQDGoYcuJYhkskqNjSqvNewN+f3KTJL24GY=;
        b=oJi5LwbgbrANiYPxcsqGVPiyP171mK+sH73jgBikJv0gT3dfhrhl18ASGhLUtI3TbV
         vYvUzhYgPon+uKIQsH+LTjJtCmSr+Hd4CHxGuDCXLuzMkAib5ZvURHf4KP1tXVXuN5DR
         DeGiYH94zBIlsJwZapTIEFZ6yeIVH4NlBf/BRbiOQ2AgtJrySBNkA2An52Ve7ZHTV7M2
         WUNE20cTUiU1NCEiU1u5uAw7wt/Kg8QpPboUyShycEQySwNAhrBhKdgEOYQP8YmakMRx
         ojHxQI6QLa142wa9s8ItRACTIfIfONsX+jmo2UzLpod9oQtzwk7eUA3E7Wi/29OUbIc/
         MRtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=rizZQOUvkQDGoYcuJYhkskqNjSqvNewN+f3KTJL24GY=;
        b=iV73bAAFoG8BUzjljiIGD7Ite66if0gB8z65NwikszKzSBkg7Thtby8th+4OYPTV/b
         lcJiNA/3sw8sXuPwNLbVr3TPYnZerqaxQIBkPzvIbtiDWcfgk3zLW6y2zbhsMItchqaG
         57uXmkM4b1HhNmcndDbTXUlLh83YS5PCmVVyi+EHL02kgIlXuKAfrWUof8h9ISbI8Xyp
         9EOn1MN79NRo15zG1b+DlWXx/bEJ3eqZXtru3Crgymkqx/Ay3fTQSliN3yYVurb9VBEL
         zsrn6VayWcjFuWnoMAC0WvZdSAWCURf4H3utsME3z/p0W1ot2iMl+24LGeYdMF0U61QA
         9VbA==
X-Gm-Message-State: AOAM5314/mlDl5edDUiaGtIeYxUssiily3/bS706H2ev/mAi7Fj2oUck
        kFeIcn1ERjADn/1AD/0E3QasaNRVje0xqcufOuOauQ==
X-Google-Smtp-Source: ABdhPJxeUZ4Hz64AnOVESdO/NH+js1iCo54nPx3Srdm8mTg/V7a9o7dEAkGszH9sSgfuQZl2HEHu2w==
X-Received: by 2002:a05:6214:2607:b0:435:49c6:5c7c with SMTP id gu7-20020a056214260700b0043549c65c7cmr1776950qvb.23.1646870160843;
        Wed, 09 Mar 2022 15:56:00 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id i20-20020ac85c14000000b002de4b6004a7sm2112632qti.27.2022.03.09.15.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 15:56:00 -0800 (PST)
Message-ID: <62293e90.1c69fb81.652e4.d068@mx.google.com>
Date:   Wed, 09 Mar 2022 15:56:00 -0800 (PST)
X-Google-Original-Date: Wed, 09 Mar 2022 23:55:58 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220309155859.239810747@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/43] 5.10.105-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed,  9 Mar 2022 16:59:33 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.105-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

