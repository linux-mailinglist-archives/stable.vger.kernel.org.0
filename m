Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA045207EFF
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 23:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgFXV5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 17:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729463AbgFXV5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 17:57:42 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F55C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 14:57:42 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id h17so3201611oie.3
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 14:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F5AhL2bw/AOtKqc03G2nDI16ZsoZh1UsNskRAYtbaNU=;
        b=Ub0IvynTicp+ncO5uesCo41hnMa6SGFTx+Rk5RUhRB/bX8HEyqVyOlI3jviU/nKKuT
         SEMLWUKenW8w6jKxISbDptqFASkR0dY3ANVGFobTFLVmo4yvCJnQv7OJIaLz9Psv2xbd
         1NeV3vpx7icM7V2WMXYqzLl0MGcOwIzwZg8t0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F5AhL2bw/AOtKqc03G2nDI16ZsoZh1UsNskRAYtbaNU=;
        b=XP7kunuoR6hrk9ZXfoF7tz6SKIxO/gj6MvcUT/N4lZrG3pD6e4RCWDBanqNg7XNAUb
         LF9ipa3TimUbIepFAyKwfv8omJMav3j8baXd5LLwjMUhouI5hRrhco5mSbH92ogiP7n7
         g3RRR6SAraQAq7qs4OMq7/cQFqBI9k4jg3w3kE/Pp4xqd+kn/1CqXX1cseghBlnjdWrm
         T/q7kUtCu20oPs9i4sURPZwEDyQoUg+3KGPDp0AxmfhFEQlG+3xaPif99lLihqCNCxSM
         qbKs62ERIxGCmXDydQezDPhek+71RS9goZzz/Fj9IzlqWn6DcDR/CHSiNgS8k5TtMWll
         UcCg==
X-Gm-Message-State: AOAM531kT2BZNqYf9Cory95qwk8Us1ucm8mpXr95p7jmWFEuGCDzjwbO
        K6Zo57834dMo1O6E4sO/hxfbhg==
X-Google-Smtp-Source: ABdhPJyyEtqUlR6E8hzeOtso0lOe7AZ2Fmexq6+l1Rhftt9AFPvFyjXqyH+anZEIkaCgIM7dcfKe5A==
X-Received: by 2002:a05:6808:99c:: with SMTP id a28mr22100205oic.162.1593035861670;
        Wed, 24 Jun 2020 14:57:41 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g51sm5070186otg.17.2020.06.24.14.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 14:57:41 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/477] 5.7.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200623195407.572062007@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <86d738fd-5f5d-9328-6d7b-6f5148bc3e72@linuxfoundation.org>
Date:   Wed, 24 Jun 2020 15:57:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/20 1:49 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.6 release.
> There are 477 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jun 2020 19:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

