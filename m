Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A531F5B21
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 20:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgFJS2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 14:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFJS2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 14:28:34 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D83DC03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 11:28:33 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g7so2469577oti.13
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 11:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zyv1EVC5aQ7p40tg97oP6U8UUyPJu7Y8g2caqHmmDMU=;
        b=JmthF9888oAGJCcqQME0wV2BsV7zzmVSwLn3tbKObFtqJM6cwBJU76dSXH6zyfSFuV
         8udvfTCNLy3oTQr4YqEl6PpsfDV4HsiyNWq+T1y+zqqsLwx8hhehv5GYoqhKhFFZADAb
         Mt4iF97vmgS4f4h2Xy2iJx+riY2ezAvSgqs5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zyv1EVC5aQ7p40tg97oP6U8UUyPJu7Y8g2caqHmmDMU=;
        b=cdeRogrYiXLxCivKCxTnDpzH6vC7Nrcpr7mYYUusuDMtU5W+hxxAd8dtEf6mx9IjPs
         429RGC0L0jRJAI/Rmh/d9KX5S59R2viwN/ze1TM4ZZZguywDpi0rTlSSRQ2O0vb5PKkL
         Zn+D0ePA9L6PIAwco43MdMRC1OqBlVNYRKcVQVl5OaOYFwTMom/B+bXlQ+BhAomjgdah
         knAuEOAE1JJYSsceDYjn/xoSQdPz/y3NNv2Jvhy6LK5e9c5UWY9+LlTCUuub0GYIcheb
         YFOqIXd+k8Xwkor3c374lUJzITyEJOXNS2ia5VVBUMuTviht4j9DB7KddGuhOXnuPHPW
         t/pg==
X-Gm-Message-State: AOAM5312yXPUva9A1QFmBvo9iSdNy7UBPT4vRFzWizbbWWZJoVaBtObd
        GPC7ujH7hRNIb4cIVKplGOoQbQ==
X-Google-Smtp-Source: ABdhPJyoPbqBrHmCEpSP2rYJC3OybCisfNTjpANhnhJoNrKpjjhZ2j4130VgDowrT04pkISFdnN7qA==
X-Received: by 2002:a9d:7b46:: with SMTP id f6mr3843182oto.286.1591813711180;
        Wed, 10 Jun 2020 11:28:31 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g51sm162045otg.17.2020.06.10.11.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 11:28:30 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/25] 4.19.128-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200609185946.866927360@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0c600bf6-f032-ae5b-76ff-907efacabf8f@linuxfoundation.org>
Date:   Wed, 10 Jun 2020 12:28:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609185946.866927360@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 1:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.128 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 18:59:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.128-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

