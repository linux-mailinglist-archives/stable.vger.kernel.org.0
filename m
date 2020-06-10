Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AEF1F562C
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 15:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbgFJNv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 09:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgFJNv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 09:51:59 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AB5C03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 06:51:58 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id a3so2120173oid.4
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 06:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rw9Mj0/+zzahZvyDMEuzuvW0Rn8QEeky5cPhAciCJPw=;
        b=MUaQd6f/BXiIREv15GSwQVLeIhm4Wa2S6Q0t8CHFYR7CME4+8bThfnPUpI9gTi21wt
         w553O7sARRIPJ0pkWVfikDPaLsjFvKTFjE8Y5sf1Kvr+3YaBdnImkWxSTt/8XQyAwV2d
         lM8IqHeCuVDN0YSSSECwnn8vzQb4GRR/kC1H8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rw9Mj0/+zzahZvyDMEuzuvW0Rn8QEeky5cPhAciCJPw=;
        b=sGg/1RfaAm1bKAhWuXb+6RtgZnIKO9uTng9xHS1sc19Y7vvUS/BcC80op+0BfaPiTH
         pjiOW2GeWaqb9lzptVMlTqK4BsTMBCQeqODOOEKV0Bsdr9rICXVXDurYE8tXlcuecRyA
         nCQ7obcw/cPsAOIs/d3ERS2K3SVUNM4jSXHSXQ85mBc5Wq0ZPv1PMQXofKQWzsKBUgno
         oq18kVTXuzQiPN1OdCkLAEvGd2EXR0B3TT2CfDCQ2aPf3aLrOjePEupWHUASMUlxhsDX
         Dp/eXY7vIyAv2i4usILL0gOllD8h6h6cir5YIN9R/ToWSaY/diNHR7X1kGdIQUB9GLiF
         H7kQ==
X-Gm-Message-State: AOAM5330i3J18f0h1IFrOvmiNnykCMsfQefVeCO3UI9OeUBrlG7b7sTG
        q8eITi6lWr2XrVHtDf5Ulzx6UA==
X-Google-Smtp-Source: ABdhPJxtlQuwQmxDLMoDK57a9/HXESSPe9khaYCy0R14MDk7Rimx4iT8K/X5OC/DbN9zfqtovRPIZg==
X-Received: by 2002:a05:6808:ab0:: with SMTP id r16mr2574689oij.24.1591797117980;
        Wed, 10 Jun 2020 06:51:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y89sm12308ota.16.2020.06.10.06.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 06:51:57 -0700 (PDT)
Subject: Re: [PATCH 5.6 00/41] 5.6.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200609174112.129412236@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9696dbd3-0ee3-a511-076a-98bb924bda8e@linuxfoundation.org>
Date:   Wed, 10 Jun 2020 07:51:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 11:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.18 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 17:40:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
