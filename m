Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC13B24139A
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 01:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgHJXKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 19:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgHJXKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 19:10:38 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EF6C06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 16:10:38 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r21so8653546ota.10
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 16:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oDBSjRVdrxSdo/zb6G9D/Gc+1eHy/zbqd68BxSpTpsk=;
        b=Mc1c4nKbTFsOT0G6P5jppbmdXZv2/qIOeB3bkzjdsWJJiRrRXCOrGoazMoSM+Zctbb
         JqG2uvtFB+ACwNjBk1aCExZg1ItHW1dg5bJnL8lVOSt+Wr3u4jeeZQjoRrF5OTvSRp6F
         F7zR+VErwGS0ufWssysHVnCffP+stlCF04Ik0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oDBSjRVdrxSdo/zb6G9D/Gc+1eHy/zbqd68BxSpTpsk=;
        b=NCs9RXaa1jIIV/uPLd9iFjFwTBo7EwdMKAV+6R/L2ZzlXvc7Ag2G/gIni1TqsWYZYF
         vJ4esg4DZb0/BKv2DGzrVmfMPwZtcvKtlpxulzNp5UmtLsCuzkEQZKVqLP8h3MYmSZ7o
         yMfOr0+wUHU20TC9mAm/GrPJVT5D5xTPATnvU0/DuqyPLELQkBXDFrR7AMo1Yz/SZDed
         ZRKYyC+QW/Ofbflp7zoKiEcIl2qjUH77U+Mht7wuLjlX61IxLvWrqb2zxZdeL3EnwzLN
         XE8mPuJeVbot2ASc7AnW4eLlk6w0dYKs815CU8tyQfHDzz5AhdnYFqv4gqgUBj5YhX4p
         2D5w==
X-Gm-Message-State: AOAM532ZScnYagMm+hlbjA8N1A7Y2bEp4j7KeDW4sPlfD7KYypjMKAI8
        5NplW4fsAZfqOM6wYAjKhT7ulboNZq4=
X-Google-Smtp-Source: ABdhPJy4Rx2TybXq8PCQy6YRHxndxiSIIHUBHnhzDArah6ixxcRWeFKmLM4EwBMWZZ9G/3EBguOr+w==
X-Received: by 2002:a9d:6d08:: with SMTP id o8mr2607774otp.257.1597101037850;
        Mon, 10 Aug 2020 16:10:37 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v3sm3707410oig.30.2020.08.10.16.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 16:10:37 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/67] 5.4.58-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <11a22932-4e07-77db-7cbe-70d9e0c18603@linuxfoundation.org>
Date:   Mon, 10 Aug 2020 17:10:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 9:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.58 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
