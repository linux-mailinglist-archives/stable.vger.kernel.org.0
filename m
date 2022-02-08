Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E234ACCF9
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbiBHBFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343963AbiBHARA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 19:17:00 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1915C061355;
        Mon,  7 Feb 2022 16:16:59 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i186so15936626pfe.0;
        Mon, 07 Feb 2022 16:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oYb+TKlhtWCmTBA0in0deukx57dvAeJvt1UBMh7FFAI=;
        b=IXTwSnFlP2wvPfk6fe6LoClgrSmg3of4+0Zkchx/6kuZHPPmWm9qPQ5aCfYjzfArrg
         zu5wtWJXIv484JJyCAkZIEyVZ+rVDMRdmaCJEQMzcZOxLHo72zBwJPPMNAlJwkUuFXm1
         rWwVsYTPs/9Sp42r88DgHAxnE++HS2pZzCKm0q2X3lHEZufEGmqtna/IPVTtbamb59/O
         Q2Dehg4LmBBlRbkza2KwXKANG5Q4FX8gKuoOxoq6CB0DLttPFyZnVYZWP9W6c93dQMZF
         I5G4yMg03dKJs0aYcLFUJJygYosA2zn5BUA5rnrZRwz63PxVrNHRms9z3iTjM+a/LMGS
         Ji/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oYb+TKlhtWCmTBA0in0deukx57dvAeJvt1UBMh7FFAI=;
        b=Y4GHLSbYqjV/jucq4wiR+EFwnrqgLmtAGVjGxTGSAcKh923qc8squ6A7CRKUIBoTTX
         I5fcIM9zfSFaPy/A/pzdMSEzAX066oDMcwtfjGMjfnedwm9+euJb55eJ1FEvna9Gy5Ea
         27i+T/YEdE2K9soqAQhJVKDz51NE+yzNnZYLKTShpg9laech805pH6hQx0IzF0Tea/78
         lwjvsZEq0tb6n1Sk/rMJE+hwN+HGptfbVfTkKdUG0PpbXX27sLdB+SZbnZjzZG0J5URY
         UlemnawLhTldsUJNnLMxSJwaoZBAiw7U/5KyZlxul4E2UybH590xL4EDxrvG58IJkONS
         Z3Tw==
X-Gm-Message-State: AOAM533p1Nug3/VbzLP5LRWiz3pmr5v34YmwFJfTuDwuUguqU2ht+fBd
        f6KCBGCbdIBsuF7NpVEHa7Q=
X-Google-Smtp-Source: ABdhPJzhlQpIPCtFtoVgUzmSwtBJOOnJ/BY0IBkp9vYtebKRQCBsOJ2UTknaAKV4GbMpi1c6giB+7Q==
X-Received: by 2002:a63:982:: with SMTP id 124mr1515613pgj.438.1644279419347;
        Mon, 07 Feb 2022 16:16:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x12sm9108836pgp.25.2022.02.07.16.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 16:16:58 -0800 (PST)
Subject: Re: [PATCH 5.15 000/111] 5.15.22-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220207133903.595766086@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <09ccdf2b-b458-0def-c2e2-181641ee77e6@gmail.com>
Date:   Mon, 7 Feb 2022 16:16:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220207133903.595766086@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 6:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.22-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
