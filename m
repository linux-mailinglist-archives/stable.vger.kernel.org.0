Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02C964E4C7
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 00:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiLOXrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 18:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLOXrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 18:47:47 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718B3DA1
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 15:47:46 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id j28so481917ila.9
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 15:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DFWfpc//dWvOBKoGlK25YY9oGZBsORiw2JQ1wUsg5lc=;
        b=N6s9lkTDogylaJKCi1XDaYJmKaEOM2Fn/TVqq11p0J0Fh3m5hzFOI3YLYusuX3pVTv
         XCsQDXT+aa2hT39KqYmxza8gWpyQYRVRQPCvwBpeKCM0LYXqNZsShu/7ikVz5ZfbdGsY
         mZQsgOx720nBEvPAl25axuHmfJebrTuVsEJTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFWfpc//dWvOBKoGlK25YY9oGZBsORiw2JQ1wUsg5lc=;
        b=Hm4+W8aNcO5UWorYj1C0xKJg8U3zQXT7RxAHezW21ezj6+1kQV1LM70B8IuyvUH8Fs
         nP16iYIkHwDJL1PnjhZfzmY4AjHwImJbJXgtDvFX/QpFM/9j4D4K7WwbQc1XcG6D8voh
         VclETNcG1lLPWTcZu1CYNblVSFG93NkpyYuG8ffdcspqbaabEX6SazNywLiimW3Fwis2
         FYuhr8B8pS2aHtuqL9XMRLfqGDl2oMariooGqCsKc3BZUFxDm7JBpicrwVanMnyhGZUR
         rW6+BSrLIeEN2GFYgbRjxuJPRmZbGGJNJzc+hfl8bDy8jcwqyQADqU5+sUjkiS8D7in2
         bOpQ==
X-Gm-Message-State: ANoB5pkcl8PT3ZPPJLgkj4/wj6UiNJgIk+ko84LihQ/R5JanmtkWR78z
        hL13EEi/aSkUlM/WfJQyJomERA==
X-Google-Smtp-Source: AA0mqf7Y4g123//H+2jMnkADCNsb2ly/e/mDdRaYmJnK7xa6NHiwn/8UfLNbHkLtpX89p3XsNkSLdQ==
X-Received: by 2002:a92:dc91:0:b0:304:c683:3c8a with SMTP id c17-20020a92dc91000000b00304c6833c8amr1688440iln.3.1671148065751;
        Thu, 15 Dec 2022 15:47:45 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i14-20020a056e020ece00b002eb3b43cd63sm217054ilk.18.2022.12.15.15.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 15:47:45 -0800 (PST)
Message-ID: <cfb586b0-c4f5-42fd-48db-0fa0082abdeb@linuxfoundation.org>
Date:   Thu, 15 Dec 2022 16:47:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221215172906.338769943@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/22 11:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.84-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
