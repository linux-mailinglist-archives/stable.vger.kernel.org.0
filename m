Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6345B8F9F
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 22:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiINUTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 16:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiINUTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 16:19:10 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5364481B37;
        Wed, 14 Sep 2022 13:19:09 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id s9so9535308qkg.4;
        Wed, 14 Sep 2022 13:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=lpHByRGbF1nRnOM3PFbxTIBtTn5RMhR5wf8fqvOiTmE=;
        b=Sz4LjlCVRgkhT0zgU648kjbmtd3/9ky//3eK4DJRZRtzwMtcYsBGb+clRLGedv8XyU
         tmbDxcsnqJt5MP5nTWOOOmus7xLjpJUD6sFqCRFMb39zeZQdcIa0DiBxBmnUTCR4xsyn
         sW9p+LS1dD6Z8Xs5ZdLHjiiQxmOJqEf5478E59CKDJ9MWjTZG9e/iDGfcc1153V/a537
         7OqmMzY2ooWbbX1j5VRvSdysT9JmmNiQOl9J8gR2IO0PBW7ZM1iegcH9jqrkRX6gBwhk
         tt+YewvoOV2o1NNFeTN3+s616Z6d8ak65ZvyjizHHjI8B/rtkAGh2FQ+zOACTsamholx
         5cYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=lpHByRGbF1nRnOM3PFbxTIBtTn5RMhR5wf8fqvOiTmE=;
        b=RR4dPj4P+YkB6vyRYvWOV+UIXF6I9oLdle10jYDjycLA+8G1dlOYJ7OmVdnsyzS2pc
         qrUlEru/XJ8mt6JveD0IwYcGPAp9BZHKf3J28VQ9dB9/0PftCRe1Qtb58szbkY1em7V6
         eW4qWx2u31ofjJpE9GbP9z19qv9iJTa51t/bkT7TwRozSCmntg6HW8LxbKvw+M2iPHKw
         TrsLuqapiiJgmruN3lJEk+MvVg90OD7rDsp0uyXQxOUdtAQYX6MpKORMMNsHV/3ItevA
         E3XxEWijMNQiALjpdJgfm5jmsqK+1ixFSlYWWo1rIMkYwVLdiB3vf3xMSPa/o483dL6x
         WKVA==
X-Gm-Message-State: ACgBeo2Bfzq2vRornFeuAPJMP8USlUUvV8YzD4bvkocNP+7WSZlExasG
        8B7KPSZ+qgWeO5vhqvRxmuE=
X-Google-Smtp-Source: AA6agR5QLHeW5p7GOj9fCzmTwVzEon5ioSkfXORc42IgKXjkZkLfk+odkkrP/Or8s9jNx5HKpoJKUQ==
X-Received: by 2002:a05:620a:190b:b0:6ce:611f:b380 with SMTP id bj11-20020a05620a190b00b006ce611fb380mr8231462qkb.41.1663186748328;
        Wed, 14 Sep 2022 13:19:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r21-20020a05620a299500b006ce5ba64e30sm2618901qkp.136.2022.09.14.13.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 13:19:07 -0700 (PDT)
Message-ID: <4f94c916-fd58-bc29-0f50-b9ed9be312db@gmail.com>
Date:   Wed, 14 Sep 2022 13:19:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 000/108] 5.4.212-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220913140353.549108748@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/22 07:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.212 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.212-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
