Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDA26D550F
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 01:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjDCXDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 19:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbjDCXDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 19:03:07 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AA64EC5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 16:02:56 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id j6so16114355ilr.7
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 16:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680562976;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2DJUnpvToW+YdaGaIjOCej5ju9qtc5BUSfOsOwGVCeU=;
        b=cibzMPWLipxjGJW474of9k5eZIZmb3VDh/W8OYCGm+K6Ura/lICW2BXQ8s71A5AI+K
         8ec5/EIHODyoIw2+7bu/VjX3d5DrMNXMMHRfRt57NjXGg+ogXzD4Hxn6Pxv8rOIjgMlD
         inqcQlsX6tqvcoSkhqKjqSC//JPZTs8RAWdhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562976;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DJUnpvToW+YdaGaIjOCej5ju9qtc5BUSfOsOwGVCeU=;
        b=tCAJ3FoM/16GUz5kuweKTFe0FrvTaoEn+zTPZV2opmqj7DAGZxPmlM31NKnxIHEzlw
         vKKUmz/AP+Jmd8iG7+wkD0WszkgoRMaY9lU/kp2Gl5u+d4+zglxWv8St45Rjyx44fhOe
         yogiHNtUWl7Ucw5pivi8bo5FZVnj+YaudBvtl9gvUZebO1mDrffmSAL9BVpFAt1uMT7+
         aNBJqdqQ6Zk7zuRd9B5BHmYNE1bQ+DLE9BWa5cR8Rg0vIqrXxX75tfaEV+onqkNhL2Gj
         cKXYm0Q+0BaoiXt4LCZHDQ9Hg9Ynv5KWyZq9OdydO9kvx2/C+s0Ns/vJNz+xk1qloVAu
         zSHw==
X-Gm-Message-State: AAQBX9ertIey1ZI1VYwA9b/tehdWPI22gRej2ikSN6RJfQLDXwKp9ugD
        Gd41tTegr+BLAd78ikkU9YuptA==
X-Google-Smtp-Source: AKy350YHQsG6dRFgRMo1YTtY8mehsEEl+9emNZMA9fHQ84PPSQInKrEHswOPdfuT07hDnjfdpUIs/Q==
X-Received: by 2002:a92:7b14:0:b0:326:8404:4534 with SMTP id w20-20020a927b14000000b0032684044534mr503619ilc.0.1680562976326;
        Mon, 03 Apr 2023 16:02:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r17-20020a056e02109100b00325c21a9e44sm2878638ilj.13.2023.04.03.16.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 16:02:56 -0700 (PDT)
Message-ID: <e3b97e7f-52be-4608-912e-3924e8f92926@linuxfoundation.org>
Date:   Mon, 3 Apr 2023 17:02:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.10 000/173] 5.10.177-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/23 08:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.177 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.177-rc1.gz
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
