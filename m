Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C7A6A792A
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 02:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCBBsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 20:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCBBso (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 20:48:44 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA25302AC
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 17:48:42 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id f14so6190758iow.5
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 17:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LI9ktTm0KAROfKF+Tom49bo5EIIc3UNFtFo5FidgKv4=;
        b=EXm7q/w3WIA/IVlRBLgD33z8jF6s+CSYYB5aCHm3zDGtZf3MGjK2ECk2IL5YzxCnu+
         FTx9bVN/jce0Pqaj+P3BNay1BGzI1ELULYHdJ5LpkkghCEc7AbhkeQ26HetJgDgwz4/r
         jMSyh64zUHBUWzXEty/pkQtRZFaovNJhKPq8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LI9ktTm0KAROfKF+Tom49bo5EIIc3UNFtFo5FidgKv4=;
        b=CbDzfeqshya/Xc77QKUaPN3QGgFgFVEzfNBaCMVIJFzoGQIqQYB5RvFVGenbtAy7Tg
         Zu8GWQNr8J3HoIb0ylbulJpyNHxNMfouDv2iasoDyHAiAzO6o/p4Z8H28OyBHGV3HBm0
         NfCAzIF8v5SwbwWl8l/nRwvk8hZ9RjK0FE+kbLvVqzqBSESjKucFk5Xtawqh43YpgEIh
         43HBvSDIgdt51URhmBRjSRL3D9WzrozKlyCkpdwUlkuT8zhjusQXHOFu2hQ4nBaIHQeQ
         CCh2A8oAhN6k0aSu7kouvM9nY6Ckedn7c7ePmJ6owhdUj5O4pYqVsAeS7lu0IGWT7X6s
         QwfQ==
X-Gm-Message-State: AO0yUKUTgMuebPZhfQymYRkZeyOWsSC7ZuAvRQwmGhuPIToq88h7HQ5w
        rY0CPm1Dl6B4MnUWMjSD0L83aw==
X-Google-Smtp-Source: AK7set+h2Hmg2PVUhZc4ZIVCAowgVdcDj1RupIMahDS5XqhSqWrSaeoXudOk78dxiEOrYNpYK/pfzg==
X-Received: by 2002:a6b:c80b:0:b0:715:f031:a7f5 with SMTP id y11-20020a6bc80b000000b00715f031a7f5mr4751655iof.1.1677721721616;
        Wed, 01 Mar 2023 17:48:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m16-20020a92cad0000000b00314007fdbc2sm4071526ilq.62.2023.03.01.17.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:48:41 -0800 (PST)
Message-ID: <80f1631a-52d9-b576-ca78-5809b74b6da5@linuxfoundation.org>
Date:   Wed, 1 Mar 2023 18:48:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
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
References: <20230301180652.316428563@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/23 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.171-rc1.gz
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
