Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805AE207F0C
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 00:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389274AbgFXWBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 18:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389065AbgFXWBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 18:01:39 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FDFC0613ED
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 15:01:38 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id 5so1423772oty.11
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 15:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yOgHGV8TRMzo68skBN0k7YZtFC8RQZSVK1V6TRXSLNA=;
        b=CS+j/Mg8UAUzneJWwG2tPHnivDeZBXQykN9FqolFmN+Z1gLa3sOxDMf4gQkTMbkEA3
         /CtGdFAOPpFau0j3yN6avw2V0RBRwvX4o/qodlbVOF2ZwW2PaP1SzXypXz3+c8x7Ww4Y
         oAiezN4zuBzgdv9pJOjylXhVx2BQrLPs1Nhzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yOgHGV8TRMzo68skBN0k7YZtFC8RQZSVK1V6TRXSLNA=;
        b=g7XnvpFBGjRJNpHLIboiG4kex6wT3pbRpeMQ/mEfWbJokqNzLlwsZ9OUvYvKRTebmJ
         vKhDp24q12sDkXx+Bmcqf6GHXFXvBuU6BbAc/+b8qQJu1kBEIDCqDcuZKCtIrnw8j4QN
         tuZClsPfjZoeByVNHi0OXn8GvrKVN28KySZrrtBWnLuQQWvQrtk4hI2X7v6yLzlWqo6H
         W12Nt34BaVAZ2bMn7dQULt+M6LAHYkm1KD8UAD/fzvOJgorK6udvK5Twv8Z5jhRp9tv+
         wHz/GyUMaOtDv0vysW5XODs75b69SNFl9Ob75DewYjuP9RQiTV+3RsQk2hZXWxHKbKJu
         ey3g==
X-Gm-Message-State: AOAM532tf8TSZgh28FL/WBLkmdMRhbIUCvWSrCh5zP5c72nOMV/qwEDg
        zIB/A/NMcZbrvXD6md4+LbuC4Q==
X-Google-Smtp-Source: ABdhPJz5NFAZZ18jqTNCmM2dfEmfknZHF3igSzFZERbZiQwVSmVJpQ8I9V6787DtNUl6BrMqMc3ITA==
X-Received: by 2002:a9d:6d0a:: with SMTP id o10mr11692730otp.160.1593036098206;
        Wed, 24 Jun 2020 15:01:38 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v24sm1866512oou.42.2020.06.24.15.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 15:01:37 -0700 (PDT)
Subject: Re: [PATCH 4.14 000/136] 4.14.186-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200623195303.601828702@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e66287f6-6b0f-d136-7874-21cfb00cf15f@linuxfoundation.org>
Date:   Wed, 24 Jun 2020 16:01:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/20 1:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.186 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jun 2020 19:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

