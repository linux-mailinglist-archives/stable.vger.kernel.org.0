Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4C4E3446
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiCUX3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiCUX1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:27:33 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390802F8517
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:23:27 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id w7so18520820ioj.5
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z7GYRK6IETNjibdyCzXuzRzS+jOr8M8+4su/L9ANDeg=;
        b=DSqOwXk1fFMoDc2gfn1Z85aiP6QzCnbXUHS6HngKA/NQ+a8TG75zM3DKc51lFa7aMU
         7fiPxzk1gz/zY6KNz2RNJXb/hH8oLYcCxuXjKszPDCyry9F46EPpX9RrZ50EGmMIV5JA
         GkugYTbi0LnwsQxqlPQL1DDKdYPK/Ak1Tef6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z7GYRK6IETNjibdyCzXuzRzS+jOr8M8+4su/L9ANDeg=;
        b=iqLpOZvaHKxrUZk8UOsqRQWhv4G4UD8Q/o7jIyabYnweqAJOqjgH8DH6JTuSPgwf/I
         z9BVKgEkeLMhlcOD/CL5hvzPoJpSNSqI4mzHxtWksSxEJI9Nx7FmhEpM91HXFocpL05N
         qh/a/JKVl9rdS8Pfgqt7Bp7we/WRcJQg1K1e1i4fuBJqOi7Uc1dKdpckAaTwZYrHrhbJ
         Ayl6rANn4KAB5P5GlD/Jlvvag0FXkIxDbbOrhFHOYFNEVYT7zxMyo7gyWoelmYdc8q6u
         JZ+Umq/pvqWkIXNnTxQeOUg3ChaEz9agC+5he66wNSAVKOJGcOeYE9JurKIoIoyoYy+X
         8gDw==
X-Gm-Message-State: AOAM533r8WpiLMWq85ZYYASK28XZJ4xjfh2n9Y/88vha44LNsowgZhtd
        QFHF2Gl5/OqdJ99taxHeBd41Sg==
X-Google-Smtp-Source: ABdhPJwUUp5th8yCFZhPrIe2F9XtrOunLwXeCq5g6pLK5s/n8oQIbjbxlFAL8ijpTU9/u+yQSas+FQ==
X-Received: by 2002:a05:6602:26cb:b0:648:f391:c37d with SMTP id g11-20020a05660226cb00b00648f391c37dmr11288493ioo.198.1647905006597;
        Mon, 21 Mar 2022 16:23:26 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id g2-20020a056e021e0200b002c82a3f69cesm2786051ila.8.2022.03.21.16.23.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:23:26 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/30] 5.10.108-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8a957a1c-9f0d-0965-8127-7b0399089840@linuxfoundation.org>
Date:   Mon, 21 Mar 2022 17:23:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/21/22 7:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.108 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.108-rc1.gz
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
