Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF7F4FEBAA
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiDLXxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiDLXxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:53:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A519DFA8;
        Tue, 12 Apr 2022 16:51:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso283984pjh.3;
        Tue, 12 Apr 2022 16:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=rINbs2i2kBO41zmQeAZXcKL7FtvF3faOCzAqWEne8T0=;
        b=PE2EL/WgG3TM02Lg+0AREQBO5I4vFbUgXsX288L26XCCUzIlWyjeROMB29PvI6vX9d
         HpvJMOQ4H0iyDymJxr77SrrGSvSik2mKHXfPyaB+UDP8rQLVH3No1BPUW0NIkiad2RiG
         mfsa3dm5tP5nZQ0Z9LvjchGEe1AWwjzKroz5BYBdVOW1urPfp+PkxlrK93njBzjUGMtY
         iQ4pNkpRQc8mGAcVr3WrHUYuPp4csGebV6WgjGVQLh7njsXWE+Wg619gPXj9PiIO5lbp
         JotlhHcfD5zlkT6iqz/ZodZ++a3I49AQXB38GwYLNyEZTfbYnSLcnHpGFUafvzAVv2Fm
         k2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=rINbs2i2kBO41zmQeAZXcKL7FtvF3faOCzAqWEne8T0=;
        b=m9MnrlkkPhuJBHieb9xKkrz6wnXRtatYEetMimeyQgHNtITqMhqJWmejBOWzfe/u/D
         nAls52iY/+JUMlxlXfntW3n1N8jq7opFpT38OOgKoDeP6ci2bOWxKO2UsIGjW1BryImE
         5TOilhMp9AQg5OOGewb6pLoS8+VRdaneMWqXjP7DmZDkvGXfGtHzxWeod/IeQ9Ouhr/8
         167KCQXh0G8Ze8r7gGvk9uVS47mVYvwk/5291jyz5b/coUm2UDfkX8J0wAiWE2tV5+Zg
         BcTB+cjIP1MGAmafZzmWFSjPjMMrcBjfmFBZxjY7mQmA2vLjztdUuhpb9epYgphkfJ5b
         B8ZA==
X-Gm-Message-State: AOAM530PhwpEyixm4hrXJtP0D/L5bOtOW/6rRx2/nppbVwXPRyFARfgA
        B1cVyjcZ95WNktXPRmFez4ja4cq5WvzsUXK6q8c=
X-Google-Smtp-Source: ABdhPJxQw37rWHc47tm0fLA8oep1W4BQTVGv5Hp3hTO+TaMaDYscfeNEQq0hdRe6FRkhUD3b5QK2YQ==
X-Received: by 2002:a17:90a:1c08:b0:1cd:474a:a4f8 with SMTP id s8-20020a17090a1c0800b001cd474aa4f8mr2075510pjs.82.1649807479230;
        Tue, 12 Apr 2022 16:51:19 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 124-20020a621682000000b005061d974f5fsm256090pfw.19.2022.04.12.16.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 16:51:18 -0700 (PDT)
Message-ID: <62561076.1c69fb81.1fa91.107d@mx.google.com>
Date:   Tue, 12 Apr 2022 16:51:18 -0700 (PDT)
X-Google-Original-Date: Tue, 12 Apr 2022 23:51:16 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
Subject: RE: [PATCH 5.17 000/343] 5.17.3-rc1 review
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

On Tue, 12 Apr 2022 08:26:58 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.3 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.3-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

