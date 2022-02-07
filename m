Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE184ACD57
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiBHBFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343655AbiBGXpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 18:45:33 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3288C061355;
        Mon,  7 Feb 2022 15:45:32 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id w20so3128654plq.12;
        Mon, 07 Feb 2022 15:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SOlDcigm4n6gdPdH8AmGLkuI+tW6UrV7hcWCFZoVrAY=;
        b=dm5xfy+c5fdS/CNt4z29/lpJizNfFByAYYUdWsehbVpACh16EeTDHldhl6Uve6GeaD
         zB1Zs5saDQ9Ef+hjJfkMjvNDcwB2KYaQXj/fONn9Y9mhVq1TMreaDNcdlVENvIhbOY6L
         j6HXXs2SDVSV4tQO/7kjysAkTuQFlG3t+y/RaV9k78HC03IjLEsk3uuo1SSt9vDnCOUh
         HklHZ8sHCbdwOjtb3yOA5JmDeoKKcEJ4Hi+H7vprDFQKDmMEhTrhWw2x8gKFYO8zX/tn
         mzLTxOxGN3rrNCEBOgxVbiiBITxv1rf9OUoHXM1rfydveqegGiF2RcBdsncnMZQfQ5tq
         Y51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SOlDcigm4n6gdPdH8AmGLkuI+tW6UrV7hcWCFZoVrAY=;
        b=dayFwLRa4rOmO23foOZmLPf4EKkWGfMbgjJWjjPz/rTRVVWfmUQXt2RyPA3wr24YSr
         y1yc5KzVzH/FCBPfNPJwmGic32rhZGxMbkceJNZWbA3xQXUvM7+dY7xlkygLzU4Q7ETg
         Ibg39txUde9Dl+GFCYNekurWZKnJ/FqOnBPr9JWNw4SAA0Er1w2sm07FMsK8MBMBBBS6
         HA+Huhatn6pLZ08nOJdsJGQqY4RA5TEVh6tKIN751r8xHyBLgojMkAo64pfBVj86bXMt
         0QSC6okx4l+4qX3zn7bK7IyTd1rFKM3lxZlo/2HReut/OrgKi72Ful8kIValzMbOuD8/
         X9qg==
X-Gm-Message-State: AOAM5324wAPkhKQbxkZ2Xz5fLu5I/6aSs0Y+Xo5Zhusd+IIoSwr7c5nW
        889Hghpz1Mr2C/OOp06B1Ik=
X-Google-Smtp-Source: ABdhPJxAxSduiwveZrKdhTzAuehj2Mp5gyMESO5lr/vwkznD+9omhXJFsS1EdUPiJwJm1ECDK52YLg==
X-Received: by 2002:a17:902:6903:: with SMTP id j3mr2049032plk.137.1644277532196;
        Mon, 07 Feb 2022 15:45:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o8sm13391432pfu.52.2022.02.07.15.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 15:45:31 -0800 (PST)
Subject: Re: [PATCH 5.10 00/74] 5.10.99-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220207103757.232676988@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <151d741f-f93a-b8f9-15c3-9c72d2395de1@gmail.com>
Date:   Mon, 7 Feb 2022 15:45:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
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

On 2/7/22 3:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.99 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.99-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
