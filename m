Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AAA4C7E21
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 00:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiB1XNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 18:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiB1XNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 18:13:07 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CE51A38A;
        Mon, 28 Feb 2022 15:12:26 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m22so12533044pja.0;
        Mon, 28 Feb 2022 15:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JSjAfvUdT/Q3hQ4edod5NiJpJDoeQDlMN0iECfgbzdQ=;
        b=elnXzltamAeeLdjM4rXWxHaWjdvk3ORX+x+sdDi/dCvDa0AjydkRfBWstC4cOjexyD
         kc/6hj2d2lm6Qsne84dH2qfyA+i5uTJvwzUpHMnj1BScRGhg6X9Ic91kVqY4vDRtnKXz
         1p9B8xMZeDhFWtWHH08QWPPhREkv0G1tTv5lFteC6iNdwuakqNmKH/4xStBtwHOhyR4b
         H3SYygNnl03e+TrZ7E6/x9ZmAQPLLCYMK4dqronp7kfZsvQaTqiVo/sQBvF7oM+4yAEK
         TByDf71Yqn4TS97dgZh5QfPoo/hP7UJykItramWYFNHoGBG+Mn8aibPf3VJcYDZ13rHo
         ejKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JSjAfvUdT/Q3hQ4edod5NiJpJDoeQDlMN0iECfgbzdQ=;
        b=o79KbRmLQJVaqZW7Z47MzcM99LhmO9V60uAJtbs122xXq1Rry/6DkJDOQBNWESyMHX
         ZU71QUhvCHeoQZha6F39sBddTpJu+8ib44qlSdK8FCaKJmNLGZToFFdXt0IPorK0REJb
         Db2Vl30e9bpqYDkHMqTUmTag/B7++mqrWgOQbdpYFfRa0mTw+gtpwBpTJPZXZf+qG4PW
         oMax5fXFLK9jOoaw8yZ/k27MH4t0qFZRxFRQDOSueWWDmFPsbg5YB7/h9rQT/Ynn7owD
         Sn3KPJKaKv6h0ryX0QpuhwxIkRitVCRbFtmYNZ5qqQRX2D9s3JeUwvmQ7o/8xKiYzJdB
         gNPA==
X-Gm-Message-State: AOAM533VNgXrpBN4Zows+qci/KecuAqmILUiA5Ix0eOQwDSUDuZ3GqOv
        lPZUVCcuWoYLFZOwunPbqNg=
X-Google-Smtp-Source: ABdhPJxjj4VOWJSj0uLiymvz1WwoPFG5hL9TAtDpDv9RwoXTlREHMA/bd2yhhCwe+2vTkClgDJihpw==
X-Received: by 2002:a17:902:cf0d:b0:14f:e424:3579 with SMTP id i13-20020a170902cf0d00b0014fe4243579mr22763423plg.74.1646089946220;
        Mon, 28 Feb 2022 15:12:26 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id k13-20020a056a00134d00b004f35ee59a9dsm15614759pfu.106.2022.02.28.15.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 15:12:25 -0800 (PST)
Message-ID: <1b1c56aa-eeab-08e1-6c15-e2b02629fdf0@gmail.com>
Date:   Mon, 28 Feb 2022 15:12:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.4 00/53] 5.4.182-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220228172248.232273337@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/28/2022 9:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.182 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.182-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTb using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
