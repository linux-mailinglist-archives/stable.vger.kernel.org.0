Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F13059AA3B
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 02:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245389AbiHTAkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 20:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244404AbiHTAkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 20:40:00 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525A1113DF2
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:39:59 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l5so3076904iln.8
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=iBopgMnmoUJvc7cVDH8fqn3f/dhwKkQ8lfdEKBMoa04=;
        b=cLroeU3Ru7UQVtCk9D9W6zQ1lTLBKb+Ud+93k79Yhf+67A5RlOw79Q4+Wy1suVlHvu
         v0U1NKAce3VfxwjRXOHCVSVrdjKpOSYgm+ZiZw8TyPY7gCWv0uGirTlEIq7TPOW5YFTv
         Xrg1uIpWB8pjpVYAG54P7L7KzeLZoPW9YZAxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=iBopgMnmoUJvc7cVDH8fqn3f/dhwKkQ8lfdEKBMoa04=;
        b=l995aLZOLBxlW6fVYd9ClF6R2IM6PoSWJcvFqpQozJ9ropGqAxZTxBKmdPeySGfg2K
         NCuDFXal0m9OUGPGPQ/fHVTx1u7SJns/b0DVUqr45kPNz9SxZ6As/JIs61ECFqtehvIE
         0fIsN/BzLGm/1wAzNxd8/2CDcKR31v2LOhlDg9xbQKGADUftzmbAU/mEN0u7m81mVsZu
         1TBQWVkihEFW5/lTBB4R/LJdHKuAyjc1Tv/sxlLi90Kye4OGu/qSIUPt4LEn0jiNMD0p
         Zr/fj/R9wkMaR+WN9V1FM203FMAidApMt7RduqV7c37VMGvBMl1KKO5jU+W5N3SnGTl2
         focA==
X-Gm-Message-State: ACgBeo34RNaxKOfhJstyyxlKDeT8fHI6vP2yOEyI0ihc5i7J/oH+h75j
        kr2dq6zxY45ZlC5BFmQ4Nie5WA==
X-Google-Smtp-Source: AA6agR44VAlVKGhzUVWtLo63G30iCyCXxVgQSvLlhP9reqy7ykNJPCUkb8YUgpDvqaY/KAsXWIZm9Q==
X-Received: by 2002:a92:d942:0:b0:2e8:fb76:c647 with SMTP id l2-20020a92d942000000b002e8fb76c647mr4745528ilq.86.1660955998731;
        Fri, 19 Aug 2022 17:39:58 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u17-20020a92da91000000b002e90d810961sm2157771iln.6.2022.08.19.17.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 17:39:58 -0700 (PDT)
Subject: Re: [PATCH 5.19 0/7] 5.19.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220819153711.552247994@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dbeec116-a78a-3aa5-0cc7-75d653ad2519@linuxfoundation.org>
Date:   Fri, 19 Aug 2022 18:39:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220819153711.552247994@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/22 9:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.3 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
