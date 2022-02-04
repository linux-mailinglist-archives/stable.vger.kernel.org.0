Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06774AA12A
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 21:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbiBDUb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 15:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235778AbiBDUb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 15:31:57 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB04C061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 12:31:56 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id w7so8835304ioj.5
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 12:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j/ZieDjJVDjS65pV7NQLd1h81ioo0WtSoLsoUkvGdY0=;
        b=IGVTI+6D73EnLthw8y7RolJqH8GW+CVYtcuAkWKxakKVQ3KiW0KMKeXoz9kkdPv7CY
         nIf1SvgBHHE4CM3SEmkMo4I87t/Sgs7XeNj6mIUswa6Oua7FLZ7T6pmY+sAcVr4q+kko
         5tDM8Y3CSIkZXQQKbklgItFSp2UN8iNKBaQOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j/ZieDjJVDjS65pV7NQLd1h81ioo0WtSoLsoUkvGdY0=;
        b=rzZNo9mcgMXYLK+SUCH57OrRaitYywGFdgD1jq+PUrEoo/3r7vCxA9kQLF1iv+z6u8
         4J01w+i5lr4L3UQdJZs8ou/nuqjSYSc7g5EzI1YC3koFwMKvLrQMYHbmXsy2lI3xpU0e
         zD/TILaqZagovLov7Z/f5wRwxZjERbRfKSciZsMJtOCxcEpyma1muvWQATs+4Atu7F6O
         ab1zzqnaUZor1HTfuLIhnE2y68B635+TU+gpmAz4JRHxVRdzprvyVjBPjd/Q7SSiFmg4
         Z6+iLa+aG/9U0THEDYYcBgjFp8C6xc4JoViGPxwwRSehiqTQHDNhxt5DL/wsQCrZ1y5I
         wyuQ==
X-Gm-Message-State: AOAM532QRBJ6cuCdmK3lwLuIDq9bL6QHl7R/NWm6ypPyTlvZaG/Lq4tU
        wRSNPnWomlTFkPlFYE9p+/WPkA==
X-Google-Smtp-Source: ABdhPJwbxmSx9lbU0uF7egzn3z2FU577sszNKsng0JEuSTd/j81+K7ePBfLZHLhcJZK5NlUSDbXXZQ==
X-Received: by 2002:a02:77d3:: with SMTP id g202mr447391jac.268.1644006715609;
        Fri, 04 Feb 2022 12:31:55 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id l2sm1412414ilk.61.2022.02.04.12.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 12:31:55 -0800 (PST)
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f9d4824c-478a-507f-7695-59e696d04cb0@linuxfoundation.org>
Date:   Fri, 4 Feb 2022 13:31:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/22 2:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.20-rc1.gz
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


