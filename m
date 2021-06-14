Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDF23A6EE3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhFNT1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhFNT1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:27:06 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CC5C061767
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:24:48 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so11985861otl.0
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g4WUeLs2D1l7ROEskHRsmjDVIRiSibTt/wIIvDS1csE=;
        b=Mv2PMc2r7gdaDG1/wkwAIZxF2YIP09VFhR+iT79QvLBmb0xczbXHToPwd9fQaIeUIM
         seCbuXfraa9RTC5VR0DhK0Q2qgp2TG77ZrH90QmGB5DBKtsoq5rd1w3rVc6T0pXLO03A
         9FGVaH4xrzvWeo86m2dmnWmNlsLf4Q4DBzpEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g4WUeLs2D1l7ROEskHRsmjDVIRiSibTt/wIIvDS1csE=;
        b=HAnH4vOLSkgdQmVnKaGiX1fyI21Vg6DT33zsOLMNsw0VoZT5O/t6jWDWxOp3m6ghW7
         sjWc1fHjZD2pRiWx/J45mdb0bLEwdWECCctNjZoQH3A/t0XInDqBtz+K6jKk82j/npFv
         dhVPoNT2khI9EEnxEg/UpcZnK/J7jP+my3q4jheWezn0BKl/3Db/txCAQEfQoHDudSFp
         b3y8QxO79hojEQGW5d0qOHtJ3kmHFRytuvczkGsgrEL/Sc+bzr8r2+YdQANgLG22e+b3
         E6QoNYGRqKKQcKBkkIoen0t/Pm1l0rsIXriuwe6nguqGwh4f/XSHX1z9zcu1qylFHgRz
         qd7w==
X-Gm-Message-State: AOAM532VLPJJTNVFzQo5rsRKFoffjgeT95AhhGzDm2GbgIsNEDrpldsV
        Jquu8DAkJmKXiIf7fWSIwIF6Sw==
X-Google-Smtp-Source: ABdhPJwjg0opGSoKtewwlFOjm78b0d7DDvpeAyXt6UXwgDTuiLpQh7c1iWsqFzjE1QFCAnDzNC1ubQ==
X-Received: by 2002:a05:6830:1643:: with SMTP id h3mr13127189otr.76.1623698688083;
        Mon, 14 Jun 2021 12:24:48 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l2sm3566873otn.32.2021.06.14.12.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:24:47 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/42] 4.9.273-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a1724860-a004-5044-11e4-ee6ce73acfad@linuxfoundation.org>
Date:   Mon, 14 Jun 2021 13:24:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/21 4:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.273 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
