Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF57A43A981
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 02:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhJZBAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 21:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbhJZBAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 21:00:38 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F31BC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 17:58:15 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id h196so18019911iof.2
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 17:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2ll5cKDY8kF1fxCicyzWa7qSx1nS6AEo9QjRtCDlYXo=;
        b=W8HsSqzcAP+xsHtCowkvy/5QMMu8JCwdsxeQStgC3ofogmMzwUOWnTXJJPKM9iAtGV
         CxIiq6jXldenexKPyj7No6473ctL+cQHcs+HZn5fRtBYl8ugBNK1meKcGU8H3FdfyMU6
         cqofg7YoXG7Qac6F3SbirESeH2+Aku9ZZUkZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ll5cKDY8kF1fxCicyzWa7qSx1nS6AEo9QjRtCDlYXo=;
        b=WwCtJatL9f9lU87OJEiJd8HpSkdCGTBCFFvF5xG5xJxMitbAuY477Ri0PFuLfI9Ep7
         Z1sFNMZuE9ZTJEOakzJYPkGF8fkyXWB2FpZ9ZkywFhqAX8wo3iPcG3xKn/Oj+RLTQAvW
         WPT/OdFO5EGWCiy8C7EvJYJOVsrgxMiIAEeFQFRMSVpMkWwX0esz9pGI4tCjOHjvEqhh
         491vXku47HmQFcsWGbwhieS+yKN3pXUslzYv1RmWf8HXuzS8tUD+KqJmbxZayyjb8vKt
         n/mBXbcKcMP1zRRInORXgEUWLnJP81oEf4uRaX1TeAR+Kngz/eAL7QHVM7U19YfTVWQE
         t9Yg==
X-Gm-Message-State: AOAM5325JoWdIqcuu57jwH9AG27nMsdJOsDCLmHyNikZsQGmkPcL5QXj
        UIguNNR2c0sBPPrnN3yftJxnb/G6P78=
X-Google-Smtp-Source: ABdhPJyavai07WYgOgchftSef2eb9FYIDIHkTe4QrRGsmWEt5AaK+oGJ8NbZOTWv2gKjMzzjGgKlfw==
X-Received: by 2002:a05:6602:199:: with SMTP id m25mr12935210ioo.173.1635209894336;
        Mon, 25 Oct 2021 17:58:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t2sm5018453ilg.1.2021.10.25.17.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 17:58:13 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/169] 5.14.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2eded1f9-e4bc-fa26-3faa-e4193ec1364b@linuxfoundation.org>
Date:   Mon, 25 Oct 2021 18:58:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 1:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.15 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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
