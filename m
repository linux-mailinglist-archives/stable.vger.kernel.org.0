Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C749D471
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 22:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiAZVZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 16:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiAZVZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 16:25:33 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F016FC06161C;
        Wed, 26 Jan 2022 13:25:32 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id y23so2058678oia.13;
        Wed, 26 Jan 2022 13:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=Obxrbqjwxsi1/QOHHdg4l4SwLk+iJQUgcbMubNB4HNc=;
        b=IP8ccAarolOPGdvNJNCz756teqHKJ79/MZ1MnfQ8f/8JnGyL73r6VsdRkEiKMjgg83
         +A7f7yTypYVRkSepMFaQmrfhqTRhcR2KUIMqRxk3Ezbi7Sh/KzoehUpGK2u8CRe6zfTL
         LAGTuZyo0TKPYoEoztnHowKA7+R4IDUFzq9oYZHps/aIDZMs03QWpY12FB2haFuPzU66
         iBpYCNvxOjNtD5fvfHL8nQb2bkUQsAA1f51DUZB7Pj4jIjnLBKG63NfPUHpayq5e2aQT
         9bV83OVybzfkKvprE/WH1bKYK74RF/xN2l6xyO/vnSjU0WYaN5Ui/5JtLib1yjPVM3lE
         H5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=Obxrbqjwxsi1/QOHHdg4l4SwLk+iJQUgcbMubNB4HNc=;
        b=F+7BkV9Aipzk3A6c9qv1mivrY7Wt9VNPPBkdff/vdnJ8AiUb5zU10Y/3MAerGCCsWR
         cFpgKT4MlAcwbOGSYA7p/5LDQttJFJ5boKNCZkH+RIp1TgekpsraLMRbppPjvjU7GtZL
         9V8eoHlcUactsz2k7PwizJNCV6S4gz0nGtivmA2R6xPtrZmra9PWgnEZZYs2FCSUdV0D
         ZCPtgruKK3rF8tm+qA5/AoSHz0vS4OpYZnG4e1Os4UEeijll5VxHBlmppx0YE3s91c4I
         TyBjEbreYg6HVWfQdCgsbj3OEmfxRxzlm/zO/QUCutHjSOt7CIX3uC0JOIzEQJFW43Ni
         /iiA==
X-Gm-Message-State: AOAM530QCPncIZq3Us1CKxGgwq3ejFv6kgBGdy65Wx4GBI1/Dh16TUCA
        WwtTxGLxRZ+xkI3GTfYLMca4upDHFUY=
X-Google-Smtp-Source: ABdhPJyb/0AOYIQ4bTYOsG+CiyTLBLW64+qUNBlTWGM75BJgnrwowfYgNMM8rcabC5Exhu1aT70Ivg==
X-Received: by 2002:a05:6808:1691:: with SMTP id bb17mr4969321oib.120.1643232332394;
        Wed, 26 Jan 2022 13:25:32 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n67sm2658674oib.31.2022.01.26.13.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 13:25:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <abdecad5-9733-033b-e911-d692fef42ed0@roeck-us.net>
Date:   Wed, 26 Jan 2022 13:25:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
References: <20220124183927.095545464@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.4 000/114] 4.4.300-rc1 review
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 1/24/22 10:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.300 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 

A new version of this branch was pushed into the stable-queue git
repository around 10:30 PST, AFAICS without any actual changes.
This caused all my builders to start from scratch (again).
Would it be possible to avoid such dummy pushes ?

Thanks,
Guenter
