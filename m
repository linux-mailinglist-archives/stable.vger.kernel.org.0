Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7C66A73C3
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCASs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCASs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:48:57 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305B636FE3
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:48:56 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id cf14so15394185qtb.10
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 10:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lgEtVBqhYQM2xpZGmxizRfxew/mOAe3TsmV4ZLiINaw=;
        b=RsU5IMSG1sBe8t0gbZfGIvbtH9WMsbxCL0HIBI7r73OWudhZwiNkJ2YObGnL2Zv04k
         JxVdGGqOBoOZDlrIWfs/R3WB9fUbETelHfXwOVkAgu9Sqh/BPxOB4WjLODzjoANboTmg
         1g0lfzw5n6VGidrPdkQZsJ33K/iw8HptueoykObmlSEyXjYj9GeQNWZeyfvPtrWBG0fs
         lZqMsXUSwBlJiHvswDQMCgCQpE4bwqkmLhuGNWKfrWDpsolPkm0BEjZBXjUaFgtBKQTH
         9qLtbkvurAGjLkLyr0OI8h19AjxJgbiSh0JOPyC9cJzoWST/ziLtZ+R14POzbWDwcY09
         PZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lgEtVBqhYQM2xpZGmxizRfxew/mOAe3TsmV4ZLiINaw=;
        b=RHr2vBYJD+Lq+mMMQKd2A7EHJfTCRynW83Iw49d1rmQVpHCwX3Wup7zjOmmYu/pUU7
         admDSmF8n06qqMWOmXElUcQYUfxierN09a1Yqd/IpUV1uXzzTPrausVlO5+1XfOX+B8g
         6Y6gVj2928zrDvLm/Hjf4YGuTvdFoLyQxn8K4SnFfHZNX9FPFuJNva3hhfqDvnU01KPm
         U3QT4TphUXquqB2JHEd8ETK/6ezUmfPM5q7aFfcSAte+2bq7f0VFWjueWjxa7RCMg1Gt
         O5WNYvbssNPFET1gDCSluwidL7YWzkpoyDv41Z2pnitFZ/6XDN2cwIMwr0tv/VxUlaPk
         sXIw==
X-Gm-Message-State: AO0yUKXbJ1GJHQRfT1QFCWnw7qJKU/3rESD2QY1ZPA1V4ZfMo3nMcuEv
        +OgnAnCqN+CJRpJE3xH8CvGboA==
X-Google-Smtp-Source: AK7set+1bLqI9kSwZBv3jy3IhBPxDvILB+hOxhOtidyH7eT01aGzUUHCgN8J7MjDAUGUV0Zy+9kb/A==
X-Received: by 2002:ac8:7d42:0:b0:3bf:e005:3a85 with SMTP id h2-20020ac87d42000000b003bfe0053a85mr12492782qtb.5.1677696535305;
        Wed, 01 Mar 2023 10:48:55 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id k14-20020ac8604e000000b003bffe7fdc38sm246366qtm.9.2023.03.01.10.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 10:48:54 -0800 (PST)
Message-ID: <26116769-3620-0544-cdaf-02516ab5ae60@sladewatkins.net>
Date:   Wed, 1 Mar 2023 13:48:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180651.177668495@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.234-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

5.4.234-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade

