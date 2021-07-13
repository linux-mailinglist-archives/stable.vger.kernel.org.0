Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7D93C67EE
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 03:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhGMBQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 21:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhGMBQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 21:16:49 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA61C0613E9
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 18:14:00 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id w15-20020a056830144fb02904af2a0d96f3so20853422otp.6
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 18:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p/B7pflU3Od3RHnj9p/EEMZxfVsuLS5SnuuAqionUUI=;
        b=MjRTtib9DFayz+RkwG3CpWkcCiCngxixVEqoIa1jRcdgyE49603cQaZpHWYy1WMaGu
         b0uFJjL3NQ073Ok6oLNoMtvtU2cdhlrM/VBlh1Uca/iyqmo1gkam0Pu+Y8Uu+bv2CweP
         XL7eHdgG6iZbqMURC0cn4q/l8XbkVAmb1ksUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p/B7pflU3Od3RHnj9p/EEMZxfVsuLS5SnuuAqionUUI=;
        b=BkkkhXCvNR4g3AUubB172ZUHqLy1+M3iLTc/D9CHsphLnHTtuLhOMKcQzhPHP3oIwl
         tQX+O50cGdhfaWKq1lN5AfZYHpy0Fko/oBBizvyiUkRuWMgU5f50waov+1ec+MwG5iyQ
         SB87Eqk+Qp+xY/NWkj0KU8wV/AzOFh1ANwpIST/5BF09wdag35ybwhAGr5BH+fvzZWtv
         CmvF+FY8dmsR1gydMXmQt8NEkwSlmgzenvbwJRnYlAhHsbayW7c+gVg/cNIHdVwbVC54
         wOTNO/O8cTzlrmf3ySD+S2c3WsIuthDDtWA3k3r4bnDOTUJC74w22iPLUjc7/LE/9ce8
         UDSQ==
X-Gm-Message-State: AOAM5306Lb7QLRrmND6CPFKHPF+3DbW3XKrt9QviVphcUx330UiZWGGX
        s5SbDrt1DTABU+FMKwGBrf+sNq31uq1J4g==
X-Google-Smtp-Source: ABdhPJz4LzKxZBDHW2NFz6wYIBJybuuTbyO4/7JXAqVSTQZLTD9KeoNNfsrjIlvh5Gyu/okQf7JRlg==
X-Received: by 2002:a9d:d04:: with SMTP id 4mr1457433oti.251.1626138839413;
        Mon, 12 Jul 2021 18:13:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m3sm3398341otf.12.2021.07.12.18.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 18:13:59 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/700] 5.12.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <89ad58cb-b431-a0b1-ef42-9e198c7e2f28@linuxfoundation.org>
Date:   Mon, 12 Jul 2021 19:13:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/21 12:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.17 release.
> There are 700 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
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
