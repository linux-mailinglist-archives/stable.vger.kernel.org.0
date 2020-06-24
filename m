Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CFA207F07
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 23:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389816AbgFXV7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 17:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388253AbgFXV7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 17:59:32 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337DCC0613ED
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 14:59:32 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id v13so3432496otp.4
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 14:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yEXhJgBgPrqHMMJogxhjG1bdCWukEFMnbzG4N1vRV7c=;
        b=JvVENXq1wzSp2eMxk6pEMLtvr0SU3Kd17HTaulkVgPEby4Sxex36KUd1Vcx/28tOf9
         9JMhb62xU6xGhdewqIjyWRnGYc2+zFMWBchj7DKMuct2Hzw+WWo2/tW8aXs5KhmOk3MR
         iQk87wZgxlQ5POjg4urLzVLbLz8xzgqMJt+uE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yEXhJgBgPrqHMMJogxhjG1bdCWukEFMnbzG4N1vRV7c=;
        b=i9W5K+1+vbQh7PQEYg5umifa4BL7lqGGdV83KRWBTHT6b3k7mNem0UmjdIPPElSqLk
         YVxk8LzV7/aKnp1/QtNFamnbt67jzvRph2eiJifvJd5ubs4m0ACXd1d+9iEAxuPk+Z4x
         6faRttAIYFQQtNku/pLK86g6g73hhL4kq+2Fg0HZpbwn3oKjDo7GXIqI8oQjBu3Jaqss
         DM4vEIJVJ34u01Ns8rUBXVaQTQjZGUJ1OLHPwkQnUoC6o9/nZNTqMhip3ptHJrbc90In
         mPD4qvmHpb3xSur7eczQQ8xBnmgkNWpIz9SHnoNmxPXLzpLt11fCTmWjhgXtPi/B8yOu
         kuug==
X-Gm-Message-State: AOAM533TtSh8Scf8LFG9zmrgA0Sw2lOQGYNPecSGeHwlJ2xNi+IWpvy7
        qAD4vMtr8JFf52ilwEifDjUxjA==
X-Google-Smtp-Source: ABdhPJzsN/3QWLW2SpTQqN8LiebWhT0I3GqHv5grQ6oZDR90JY0rEk1dqlJNH7smQw4QUh5ZfP9cVA==
X-Received: by 2002:a05:6830:1dbb:: with SMTP id z27mr24465512oti.340.1593035971629;
        Wed, 24 Jun 2020 14:59:31 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f30sm1957785ook.4.2020.06.24.14.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 14:59:31 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/206] 4.19.130-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1b7194d1-b8f1-6b38-32ea-d8370c98bc59@linuxfoundation.org>
Date:   Wed, 24 Jun 2020 15:59:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/20 1:55 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.130 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jun 2020 19:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.130-rc1.gz
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

