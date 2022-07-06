Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987E55696A3
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 01:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiGFXy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 19:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiGFXy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 19:54:57 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23B42D1C8
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 16:54:56 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id m13so15484171ioj.0
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 16:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X+SKcGDi/3Vpuz7zts3QVdWjQ+ceALJgn0lTynUN7MA=;
        b=LtiEy4o9eJ2X3uQWTdJ/qvTWBSU/XybxOAMKgpr5MSdZagDKt3qTOoPDro2Md/az10
         GMOWHB3SRBxnoxdBnOPWpbZBGKiO055Ec6Lvq3UqzMvqLJ+u9MHeS9uafduTgd8OJbT7
         5S5sv+fqBZMlBQ/kPU0ywghoL4ka6/elRvk9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X+SKcGDi/3Vpuz7zts3QVdWjQ+ceALJgn0lTynUN7MA=;
        b=JwBCEQbcRX6AVw4Fj+dRIkWJ5yTcHC09/q8Fwd6V5uy8DlhXh+Ag61TRcVq7Z39itU
         Eg7091hLeBxiNEeSIa0mBgznFztiUmbst2rUdHGJTMY/euP/r93ddonBPwRET2jsZVr+
         Pbwj/cFUA8Z5Wa9yPonL9Epr1EKs7iRcQL9yKn0dCdISVPEUoTHH0dJt9/j1FWkXvcEx
         4d8yTQUKGyaa1J4Y2LExa81gQNitO9WWx6Z1MGqKG8O5kCGrhT16mDUSbOM8rtfoz8wG
         RUYWg2J3jXsCsjVNdQF7hgD7cNqZA4O38Jj/F0OvQ23u1/bsiTHeiQSO/VaqShSZGtqf
         W8Ug==
X-Gm-Message-State: AJIora/r9M7wN8pCxjmvPHgKJM/Rel5mMAuDZR1+Dh05VE8lA0PrViEA
        NNFvMzsODu3sydM1P6b9o7ZYfw==
X-Google-Smtp-Source: AGRyM1sbfoDCgXPJb2bvcTdEXovQJWQZf0x47aSfvTpXGuox5ve910306UGXQzpz0gYlDaBiZhUnJg==
X-Received: by 2002:a6b:3e87:0:b0:678:de2a:9103 with SMTP id l129-20020a6b3e87000000b00678de2a9103mr613423ioa.140.1657151696140;
        Wed, 06 Jul 2022 16:54:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w13-20020a927b0d000000b002dc33dbed87sm1219996ilc.39.2022.07.06.16.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 16:54:55 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/98] 5.15.53-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bff725e4-e563-d0d9-a08e-4b46a4411b81@linuxfoundation.org>
Date:   Wed, 6 Jul 2022 17:54:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/22 5:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.53 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
