Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A75559EEE4
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 00:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiHWWR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 18:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiHWWRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 18:17:47 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051FB289
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:17:47 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id c4so11214333iof.3
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=7FUjVO9GR81/UhnwyOKJJo8rSozKTnslxizaSfoijBs=;
        b=K5VG7NVhLCQkuB0ziwKY8taDXxixXoRNwyvz137DMg5u6Wsdm2QQCJDP3UeXm3r65D
         uVoKRX5J6mD97MZ0pj8nKnL1Hph7JsApvkyJWiQrc86QkURErDKQO3su8oX569kzaaah
         85zuG9fnIC9OxbU216hu//aZUar+NdlftroHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=7FUjVO9GR81/UhnwyOKJJo8rSozKTnslxizaSfoijBs=;
        b=xNTwdY1jGKICbM8KlW/7xM48DigpFI3IdMNeVNEBPiPwYKvnNDliRGqL00fkor08Sq
         TWQ5YJuUJkOHq7ZDyIk5ubHypIT/Y+NqXjAMUxZV1OM6FiR4G4wwo5YW6qe79DaqPCa8
         eTXgMio4AaQxc2irJeUEOkNfANRH7+cPZITYgFdk/qTUd83W/x3aevWwOfz3uNhFFAXh
         Ve8N4A05hATU2pMYVRC5zLDrDhs5Fe8ELzFLp7MMYzNuvca5LoR7eUxHGOqiyee+9Imu
         2Dk0LPrp9a6DMNaHrldNJbC4S4FoNCIuxL0xiiHCRojM8tz7iyghRW/Wld/8AtyRgZXi
         jnbg==
X-Gm-Message-State: ACgBeo3jXgBpc6YcQ+cZ3UMxA0A6KaiY37wCiwbsnHmhUs6/0udk4FYj
        ffw7kpB/XQDRj7OAKaoFi14p7g==
X-Google-Smtp-Source: AA6agR6VAeWobV/2XDAhx3PWbM8J5iuh/p+zbor3ZQ1SJk+oxZJOxfZne67a+fW0RoiUGyRUBXvBGA==
X-Received: by 2002:a6b:6704:0:b0:688:d06b:2233 with SMTP id b4-20020a6b6704000000b00688d06b2233mr11508043ioc.174.1661293066373;
        Tue, 23 Aug 2022 15:17:46 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x1-20020a92de01000000b002e90c794bbesm331395ilm.55.2022.08.23.15.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 15:17:45 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/287] 4.19.256-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <82e5e8a3-87cc-07d9-e859-ab265263349a@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 16:17:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/22 2:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.256 release.
> There are 287 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.256-rc1.gz
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
