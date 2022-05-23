Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A0531EED
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 00:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiEWW4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 18:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiEWW4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 18:56:24 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D19EBE2D
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:56:22 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id s23so16763421iog.13
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8IkeMFpxJap9iRNlZOWaqDw2lZTtvovlAlgCcbHJF40=;
        b=LlregArFTPBIO/O9VGixT3FvwF1GpeuFbzm0b77/+P3VvZwrojQj/TbOczcN8pwqtg
         ER9n4xU2Kfj/hJcj0C3g0WRc1UBKrJ+r48LoVBTMsEq6Lc7MDoDtZmGdwjpDQt2tQ6aQ
         y1Q6k4W1MV6QMssFMcmUmq3cAl3ltq+oci+00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8IkeMFpxJap9iRNlZOWaqDw2lZTtvovlAlgCcbHJF40=;
        b=WnBtAawxVByDrwPi6vNgRrZqj30RHgjrqZ5VLHvSMcVV3e0EFhj1yHwlRP40Wq0BA+
         J8cjrLAgT/ISPrlBhCS8hHF6oRcIkJGTyXkl6ZMEOApUuPW05izHvwripIxeeAfHSSKo
         DsAw7r8flQRi0L5mDmc0Rt3t7E8Y3nNp3HW/WXPnkzIPBNbwUbgynWBVRXH5OZWVBF0v
         TshgtDRS5wmlrPXSlN4wUqzF+8fnbPTBsvtkp8xVoLOREjHITWNau3m39Eqz+nw/zqbl
         h8nnZJG8P23eNcjMyWFlaObiJy68tkI5UyUGw6m+OeBNpLwdMUKrns4w11XtVwAqfpgF
         Zf4A==
X-Gm-Message-State: AOAM5326YvVoTMgx9cbX/e7qpf6MfsFQ0ZJWJPvGPuPAJioV2966L9QQ
        lt91KRS1t8iBC7nE+TUxyEAFww==
X-Google-Smtp-Source: ABdhPJzWMaKhgKkfN18pAF/PsAzLVa92H2TqCZJuPdFvHy+0A0QC8Oao+IrQw7s2wr/dGKchalIM6w==
X-Received: by 2002:a05:6638:b81:b0:32e:5009:192d with SMTP id b1-20020a0566380b8100b0032e5009192dmr12212751jad.28.1653346581939;
        Mon, 23 May 2022 15:56:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q16-20020a02c8d0000000b0032ee3870122sm210085jao.48.2022.05.23.15.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 15:56:21 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/132] 5.15.42-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9bf829b3-e6a8-d151-d81d-51262995c428@linuxfoundation.org>
Date:   Mon, 23 May 2022 16:56:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 11:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.42 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.42-rc1.gz
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
