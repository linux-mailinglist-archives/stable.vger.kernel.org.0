Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B92123C0D0
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 22:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgHDUhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 16:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgHDUhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 16:37:24 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BCFC06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 13:37:24 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id y30so556205ooj.3
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 13:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pFDh7nGN736WMoIOc8zyOhHg72v4zuXANR8Au8EWk5k=;
        b=e0+NO2RTD/3gnAomEZmJ+y6dRWbz+AvOQcXjJF79gUFk5jIRu8RqHsGEvkO2ptyc6e
         ruPdNPVhHavJ9RN9SeA8S54JIvuTFf/JvvFGFTzzp6JvJceTXyFaJhYz4mRaqRafLzxk
         dgOce6drY5Ip62u9u8WY8r3GVjLldW/QZc6Uo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pFDh7nGN736WMoIOc8zyOhHg72v4zuXANR8Au8EWk5k=;
        b=W1ro8f6/A6Lk4z6ZRSWi3R9QpccqDO3gci7RdQ1Na5b7tzSTeHZ5OBUMq3OiaLx47k
         9Nzxa263xTjSUZiUcum2K1OarEvizHdFMWNbm1zKjTuOzzYeoZC/w348K64OL0wIB4L3
         COm/5i4KHn9cgjn61/U2t/ncEFFCOP3K2zmTFjOaGFqQ6ypJ+M64nZTy8KVT8pdA0WRJ
         5RsthyuB83cH2it9JDf8F6RnHxWEK8dODnu/FykdXlC3ThHuop54tZUj4DnvWGD/8HVr
         IO5SGXHavFJDw1kzJLXhpzAHnNZd6PcTgdLGFIT7iYRVoO564HkvojNKSkwPBfdMq/QJ
         5rJg==
X-Gm-Message-State: AOAM533W8dBxe3y8lsZwW7enuTez9HLO8asL984aUKWemrVzjRxNnYh7
        X5X1rs6+V1F98heio/mlfnElhg==
X-Google-Smtp-Source: ABdhPJylcFBlLBp1D9EE6Jj+XuaHU5c42yOmKFtHkBsTeawlpg5iTCKqYkNF6p/zAVw7pdugSew8QA==
X-Received: by 2002:a4a:c299:: with SMTP id b25mr20392446ooq.35.1596573444141;
        Tue, 04 Aug 2020 13:37:24 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 90sm3840981oty.9.2020.08.04.13.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 13:37:23 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/52] 4.19.137-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200804085216.109206737@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <395f3142-efdf-d16e-5bee-19f02646212e@linuxfoundation.org>
Date:   Tue, 4 Aug 2020 14:37:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804085216.109206737@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/4/20 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.137 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.137-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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



