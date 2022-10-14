Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5845FF1AA
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 17:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJNPqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 11:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiJNPqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 11:46:38 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F001D5E2C
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 08:46:33 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id u10so2715395ilm.5
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 08:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z5kWJWTbhCLIU0KzFSLz7SA+60MxdeDsMWAk776+PIY=;
        b=JFcBJzFYE7749zg1Yq5unvXfW9bdpJKVEHHrGTa7PO8VZ4bvaQlVQRoC4xF+noCUWC
         ylAv1wt9PPZ04nRjJr1/eaETmk2wpiUFxfWbaKWRZwCU8lJShAP2avPE5FFggyxyUHYW
         3SGAlXonlLpS3BQWj0/DhxnfGvHGy4VKB2lrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z5kWJWTbhCLIU0KzFSLz7SA+60MxdeDsMWAk776+PIY=;
        b=nZAVCEqhv/eTL6u7yHiWGA3a7RZPV9YCq1J5M3YWhH7GJflAZEXAm0USRdLeeGT9xa
         ILSNKM0AFim8g5e20JoAtG8q6jHT9CgjlPh7vfISednPT/sipTf5cIg8MJEdrq0bRkU0
         ThpxCnkrgZN36khRQOCVKLBW6f4WN5ilyRLl4atnpBjN88gl0tOhUkpXsirjwyLuxbht
         xOFeK+f/VfHHdyXDR0qjssVRE33f+bRXWUV/3X1OazlkZl0UkokW+ADDXTPpkgShxGRC
         +wNLOsf6SwAerjF7e60YAESZtX6BgWxr2VOnYXwsKCFzSlqO8wWYUVt9uV1Ngmj1u1/O
         6Hvw==
X-Gm-Message-State: ACrzQf0y/wMJQ+uu36+iTDmE6VXwnw6YVbF3Pt1UUEQUzCzRpZ4XqE6F
        xUgrIdSu1gz/fWhUHWxgnl4nfg==
X-Google-Smtp-Source: AMsMyM75L5kND4ZIQ8A7WllHGvM61JfcpjFyk3/le4pBszfYptiOnWhMisPh4aReM9RY8ADdb2Eq0g==
X-Received: by 2002:a05:6e02:160c:b0:2fc:1bc4:1811 with SMTP id t12-20020a056e02160c00b002fc1bc41811mr2795194ilu.306.1665762391684;
        Fri, 14 Oct 2022 08:46:31 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id az34-20020a05663841a200b003635b1313b9sm1215441jab.112.2022.10.14.08.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 08:46:31 -0700 (PDT)
Message-ID: <0229ec53-376e-75f2-fb80-12c9534cc2c7@linuxfoundation.org>
Date:   Fri, 14 Oct 2022 09:46:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 00/38] 5.4.218-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221013175144.245431424@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 11:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.218 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.218-rc1.gz
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

