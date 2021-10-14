Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4BF42E1DE
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 21:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhJNTPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 15:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhJNTPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 15:15:11 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26F1C061570;
        Thu, 14 Oct 2021 12:13:06 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id d23so6403808pgh.8;
        Thu, 14 Oct 2021 12:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XNnqsSoZve6k+LCoPoxyK46MaGi3htzBtJNjcufQmt0=;
        b=OHWl8hbEkxFlYNHgVZ7xqsspAUPuoAakUzwknJlZIE0eji1t6olCV7CC2DPv8jVeWE
         L0p3uZu893BF8xMQG0o5Lvdz0rHhV3tyuawVSOKwxVgl9JI2NztNvQxzLZxfdm+YyU9P
         VhuSLE0JTfHhQXhWOnJj/qjJzFL53iSKg33ZUj5h2kHEhF8PiGUm4dovMGZg2r28GFUn
         Xdh7TdOcgXBYCKxK0w/8g8YStsyp3rVvuHlEFx25lUARdJBQBY81aD5D9iw28VxV9pvH
         A+dlw0/GPFIxROkPGiwpZfllKdrq6hDTWCdpgtoZkfoSPS7EKSXs+NDRrZ1BWoitymZL
         H9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XNnqsSoZve6k+LCoPoxyK46MaGi3htzBtJNjcufQmt0=;
        b=KCgwjr0ZjzGwi3yzEKvBWGUyMmU+sN8YXnE1JoB6dc7GPSNAL1yYwrHKspYqSsA5Ua
         zq3tiEpM3JqVOij9+xpbupQQSR3RKK1TUrTkvGhlHPbXg0SMhMU40UauRkETrjIvoGcV
         Jz4mPftappKuqTmhXrp7YaGLyKQi6uYyY+QosmnuT3Ip/ilujD3ueLpXQzzEi9PnaVLJ
         mpX/z7Vl18p07LSg2q5X3shEndj+IO+qtgexN8qdf5LUnFebTLm04u93LxjrEzvPM4Ak
         DcM+s7QJHLjKrvoz5kVpCauilxuECQEKgCzcAuVjQVoJSpZKZvRN62poxD0OCyt/WjP+
         MRNw==
X-Gm-Message-State: AOAM533YAeszvitrJvcKIiztowEPoBYIQZBb9S9ST/fK4bgLu1bMftZC
        lNx4XDUD4PAF1f63G+svOTuXeA7hHZw=
X-Google-Smtp-Source: ABdhPJzM6KwXriLDSLAQ7j1qNurYYy/CpzgVntk2BTlmw9Aydt3OnXrv8fsJdSGfrbjU3RpTDlt9Qw==
X-Received: by 2002:a63:8542:: with SMTP id u63mr5665335pgd.402.1634238785623;
        Thu, 14 Oct 2021 12:13:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h12sm7266736pja.1.2021.10.14.12.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 12:13:04 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/25] 4.9.287-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211014145207.575041491@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <02224646-aae6-d406-52a7-fa2d0feb4bac@gmail.com>
Date:   Thu, 14 Oct 2021 12:12:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/21 7:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.287 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.287-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit ARM and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
