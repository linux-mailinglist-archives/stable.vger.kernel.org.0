Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8561F5BFF
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgFJTfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgFJTfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:35:19 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8543AC03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 12:35:19 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id s13so2658889otd.7
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 12:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h8DwvDaJUW54D89L5CMJ9LLKG/vnyzMlJjqUWjz0Z8g=;
        b=C+Y4rLt2w3UZ1fcrpPsiMniHpA5n0CU8kGPE68MsI+ACFQ64MMIo+HXItyb5puP9FF
         16OLooGZARLUqNXn69uF0uku4IdQCpApKsLmFZkkIrVErfm/ssZO2HbWw5rJj7RWlaUV
         nOkE5sFXz/5Q2TYWrH9AJtBqF6Gt7wi8BsZCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h8DwvDaJUW54D89L5CMJ9LLKG/vnyzMlJjqUWjz0Z8g=;
        b=RmEvdZUW4+oWb5O0dhwqd11MERPnH2Hv/s8c7VVjt4nv47tdKK7EukT88Jz8QdqA7Q
         7GwfvJT8rikapIZV8+9SoxuB4ijiG9/oZSCfpvSSd+1ue2CPTMNmTz90eJ7qZI6BSdNx
         w8MeuOR4Br5CZvM7H/1Ewx8MLAUCATLetaHegpN/xB07RiLwhX5splzlrZpUY/VJsEJO
         UtqvNu1SVqy7J5BVJCSeRmiwPnGIuunaeCcHCWoHEZq92nJOXL9ZGlUZ/Wb22XMXIl/C
         z/1yungqd7nH9talGJBPvQ/Xl4e9EUQs21BpqpclL+mMwCx1wUvGesv6CN0NHueqWUsv
         y2vw==
X-Gm-Message-State: AOAM533P98uIaRpJiATmxkHLND7jR1vM95kTL2+Bq6ZdO2LToe9iewRY
        Jbl/ZwOtUjjGHfbQqsjU/n/qbw==
X-Google-Smtp-Source: ABdhPJw8sENmOAJTSPxHUs5ygnsNC353XrXO+/GNlaXXENgexAxIVbyDjRk4pAiA8P5TacUy3Vc9fQ==
X-Received: by 2002:a05:6830:141a:: with SMTP id v26mr4006758otp.250.1591817718211;
        Wed, 10 Jun 2020 12:35:18 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w197sm168898oif.1.2020.06.10.12.35.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 12:35:17 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/42] 4.9.227-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200609190124.109610974@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7f9f02b0-b568-adf7-0816-1505709875b9@linuxfoundation.org>
Date:   Wed, 10 Jun 2020 13:35:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609190124.109610974@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 1:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.227 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 19:01:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.227-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
