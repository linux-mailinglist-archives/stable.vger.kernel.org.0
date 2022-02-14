Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA514B5D9C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiBNWZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:25:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiBNWZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:25:52 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A876013FAF1
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:25:43 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id z18so13491966iln.2
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DuQT2xA3BnOJpRi73IVi7R+ZCtq3czWUMashKJJgSOI=;
        b=JUFhW4YL1emwnQJ3IRDDXOsfnplT9q2hyHtnT1NRJI/jpEAtuto3bg1UcC/XztEwmu
         VRb2Uu/vaKCRAmu4r++gptQrcn9eCmlGrQjHiQoDAcVRwxpAdboeCRlYW/x6Zn77fNF5
         XmZvWE/yhVyU+RVP0gwyUuCasY12MMBHyRpVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DuQT2xA3BnOJpRi73IVi7R+ZCtq3czWUMashKJJgSOI=;
        b=wFbAjmUOmi+VBIftrxcm3OQj0BXRN3T/334GBu4afa9xdvKJKllYjoOFSZMzVA6eTT
         GbP9Vm56QrUNk0/huQ/h0KK+aotQj5CXaDri0yzRZwzOWTqY+3jkI3OLBxyyRwlxkTDa
         mRYX7hj590lqWUyYdNGdq6o/42TqCYKG2P0CnUzwWBlYpL2NgdL998yD7jb/kNKNfqog
         QXWRYnbwqaG3GyHpOHF5jt3uAE07KSAfjswHVjyp8QcZO+3Cwl6fpSfaK5DOnzxk8TWa
         KzYGmeXM/GO+AMErLpiIoc81ysBT2R860i9Ayc8X1g1q6LM95F8Hzn32kQgyZR5YwiKn
         ToWA==
X-Gm-Message-State: AOAM531mDIkGwJB3LzNPBOxD5EGWQ7CqZ5YElgNKv9OOFl7VLXNS/Jmf
        1HR3eejwK7Zf9Y8A0t1iuaKu5w==
X-Google-Smtp-Source: ABdhPJzjUaXUBP16xH+PV3TJoMKsbVnQziOexR1Er6U3w1HVe9/ikPHnRFS7BE2+9UPjhKoY/wFebQ==
X-Received: by 2002:a05:6e02:1547:: with SMTP id j7mr646875ilu.20.1644877543087;
        Mon, 14 Feb 2022 14:25:43 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id i15sm21940223iog.14.2022.02.14.14.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 14:25:42 -0800 (PST)
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ced29237-c4e8-ca18-37ff-fe399dd59b21@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:25:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 2:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.101-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
