Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70AF3CF0E1
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 02:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345884AbhGTADU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 20:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351764AbhGSXwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 19:52:02 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67697C061767
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:32:40 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id t6so5287477oic.0
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SBDr1BMfTKLG/QF9tGc6lz+RFPiqfPmPF2WpUh7uf3Y=;
        b=VlFu7oHBRFv0Ew7ZWXB5xboZCXr0LNInB0c5pbyESfXby/n6hrIlps3x5QccF/EnJo
         RXMAUB8CSxa1WQDFu3MreSmvkhcWmr8Ku36nh+mnz3w9S5V9VjGUnEuQEv5JpAYv3UiT
         bWdYaL05b2sQ0xHNpBfG91WUkkzHAgIDxrGEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SBDr1BMfTKLG/QF9tGc6lz+RFPiqfPmPF2WpUh7uf3Y=;
        b=HjQuhOwE5RAhkAsmB1ayFZqhgjDW0paKIFyPLJSQGU4y6dtaPi0xO6PmDggEOtKrKi
         oVtGO74hLXGk3azdoQ6OppDLuTOr4WUtFy15ACz73xEkiF7ebAHVoRz6TZSNMqa/gKWa
         eaFjn+k7o+fNEb4iuGZQaFjMiv8z4BSurnKq6+uhRlhnXd8F9enp82E6T+LZTtYvJAgf
         BwWTg8g7Y50PpW/M/HhVdy/cYa2U614rlMHIJIPBfUWwRDynaxXfU2nRNfiE+/Zn0j+1
         zKBommru9+lLkMFmGak0CVCzmWbmY208KrvD2b7Wfh47z0srMGDGHnqGM/CpNTLJeoVW
         EXpg==
X-Gm-Message-State: AOAM530fXh3glWxvOI57ZWWsC3qZKiLmhH0G1s/DTn6ZBvq8asVSzVNh
        izArK7zx/aBhLpeVoTd/KOzIgw==
X-Google-Smtp-Source: ABdhPJxW8oELQL/vw1mb7V/21K8rF1gyGJoepbgb86J4ExMA4fdD5tRbdotKYMgloPjmLhdkhTSp/Q==
X-Received: by 2002:a05:6808:5d4:: with SMTP id d20mr10777218oij.43.1626741159845;
        Mon, 19 Jul 2021 17:32:39 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j10sm3190695oog.47.2021.07.19.17.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 17:32:39 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/245] 4.9.276-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c4c03a6f-f862-0ca5-c9c3-0310e219fa4f@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 18:32:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 8:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.276 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

