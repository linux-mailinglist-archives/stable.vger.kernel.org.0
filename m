Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC885626CB
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbiF3XSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiF3XSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:18:05 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBAD9FC1
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 16:18:01 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id p13so406027ilq.0
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 16:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=03++94PzvVG3b/012gf2suelyAkCCpPeh9VDHLXmve4=;
        b=CqDHVXt0KRgn/w01hYDr2JRIlb34z+64H0I3D13v873RWxtj6WoCVIFGwui2kmla5F
         gW9hqngGalfOXPyECpKNzYjy/1M6YozEKuudCSGEqVrfhHqnJNRE+mnQlG/jq1rtpS4C
         rlaQzt425NE/eXiFZUJ+PbgS6M5lBsS+Irc1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=03++94PzvVG3b/012gf2suelyAkCCpPeh9VDHLXmve4=;
        b=4gbhqWHn2w50Leg9H6goe7FprcG/q5MJ6ppKWdEdZIZPGQsg3TVV91EwKLbB5PYLjj
         4etAvxVC5EfsMcf+RMmjOJAmORqNqgAvVhh7lcw0jOo0epHazyT59bvCMFNo+6Q59dsG
         2HJnUDJC8AbNnEQEOxb8KBn8AkHUTEJf32LBxLZIYDgRPx0AVL9touVK55Ot8DLEDcWW
         OFZlUTFtryXkpQGvjgLZLXDA+xEZAEQwgdIyL7MsP0D4YZyeoCOIKTkSdRn9B/X2HFDj
         rnF+QicsJyU9H3FWFvperianPVgz0kESal8Z/1Cr3+fRYbEbAbo5ppAkxIeup5oaWePk
         92VA==
X-Gm-Message-State: AJIora+VGvnYiwvlyMFshrZCkfq0jnsIKpPEF+4GHzavLEVuIgyKOGcN
        XwcwQ/xTq3Y9SZNEOYnWuJM2XQ==
X-Google-Smtp-Source: AGRyM1u/97oQ+eDiph4/CGJnP0FPiwky03AkFrnqrGVLgu4HE/ptrs+/vjl28bP27/JHGNnwO9d++A==
X-Received: by 2002:a05:6e02:1583:b0:2d7:a75d:888f with SMTP id m3-20020a056e02158300b002d7a75d888fmr6490251ilu.13.1656631080973;
        Thu, 30 Jun 2022 16:18:00 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n41-20020a056602342900b00669536b0d71sm9598977ioz.14.2022.06.30.16.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 16:18:00 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2778b022-0c04-b572-a801-4e1b3ed7deb9@linuxfoundation.org>
Date:   Thu, 30 Jun 2022 17:17:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/30/22 7:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.52 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.52-rc1.gz
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
