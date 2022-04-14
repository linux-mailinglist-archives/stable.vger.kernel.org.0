Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9709C5019B1
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 19:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiDNRM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 13:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245170AbiDNRMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 13:12:00 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DABED3704
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:02:47 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r11so3499809ila.1
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GjEQSvduyN0/TJE/Jlki9Iezw71PlCdMxAXFTJZFBLo=;
        b=RJ0nifPqE99iCjBsuoGScCCHdETY7l8xcMXQF9Ee7dfna05JX1upTUPVVcd4zeL26q
         cUq5elDmxChCrW6+z/d2PBuqyJljOeTCQ7WA7kdLS47KO08JshV3V14dwFaPkRcUQLeQ
         3A86g4Bd0IA8HAPA4RIEGM2p8XOVn3XLaSi+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GjEQSvduyN0/TJE/Jlki9Iezw71PlCdMxAXFTJZFBLo=;
        b=xxlPMmwHz4gl/Qb/+nS9YStXL+U4Ozxnza7k2acXcNymO6zE5Mjjj/XdIz5Um6dTIl
         b4kJ0wOZBH5u3O+ejuzzcYG3TchMlRZ8lphYOXqeWpwGgKbB3N2oSi4W2DgKLcfADb8b
         1C+ScWlHk+yR0+7ZxyYxnl/z0ChyPm9NRuB0YwWll6G3aA9OxJFYOnvZQqa1Y56EAPZ6
         IRny+3ZY25U2AwYXFJZizdpZeNu6rX3RhYn85t2WgRk3t+NHGZyEbSjo5diJJERiwpVq
         Ktgy3lB5SVOuqXe00h3EkXs7F3coSjef6+l1K+hNWyBd82V6jh2J+U993R6eKhwNA1OE
         m9cA==
X-Gm-Message-State: AOAM533ilaEvepofETsJI4n+k/tKDsDaHr+tmFb2GhiXEpSQFVy4m/XF
        FgHkwWGO2StFaS/mnvQ6Q4/Ysw==
X-Google-Smtp-Source: ABdhPJxVgar9TUDwXqhznrPjwmOujBp9CZo6w1rUoSqceF5rPn34WXzTYNw0w8QFQeJEZ5RDB42k8w==
X-Received: by 2002:a05:6e02:20c4:b0:2c9:a514:6a99 with SMTP id 4-20020a056e0220c400b002c9a5146a99mr1513400ilq.50.1649955766270;
        Thu, 14 Apr 2022 10:02:46 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm1504152iov.46.2022.04.14.10.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 10:02:45 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/475] 5.4.189-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6bfcb678-5843-8557-b7de-9ced0defa881@linuxfoundation.org>
Date:   Thu, 14 Apr 2022 11:02:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/22 7:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.189 release.
> There are 475 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.189-rc1.gz
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
