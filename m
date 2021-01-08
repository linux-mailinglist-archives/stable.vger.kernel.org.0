Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67CB2EEAD0
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 02:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbhAHBON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 20:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbhAHBOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 20:14:12 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B263C0612F6
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 17:13:32 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id r9so8160614otk.11
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 17:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/5oVjFgVep5FAMpxMvOf0cQ2ipnfcqntMeat9CC6JrE=;
        b=WyuWKoqHOeUGpyNAMbINW2ehrIrTzyqPd9u5fHLBS8+EFX9HpAH0A9UEgJ32AqktFn
         XKE3bqysYInT7w4C3o84sERF3NB5vfhGhOzpI8LaxRrP1TV2fS/hhufT2K33EOyp6Rb/
         L9m9Pk6rt+tU0b2zTPG4DKdW3EW55Dbm1fi2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/5oVjFgVep5FAMpxMvOf0cQ2ipnfcqntMeat9CC6JrE=;
        b=rdZoIeYpPwGUHukjf/r5vWerMFlNB9ymWm/hOpbohhZMwnfeGjewttm0oiN9HQkmfk
         xXYZuJZV4IDAGFiUKKoPpYxxCEOdJsMwdL9CQNiAZQRmb8L6M5R8nqi9pVQzeVFwURTo
         Hw8bdlE2eieQoUvMMuWVaR/tWrqHLmikFnBD1R0kz1rr/g7mZavaHwtlVKvOoncwfkzw
         y54q9jKmzaQOReP1c4ge1h5SulyGL3XUWh/ZxwFrxY+8jLKEkUGKGdjWZ1GKAQfZnYz0
         QR4JbuaYSEUPK1rtWiKzt6ygjHYdLyrdMGuRTU/fPqmzFOHf/ndZVNSUgIFjx3pePexr
         wcyg==
X-Gm-Message-State: AOAM533+XIK9/+hN8FbEOftJ6GW5faQ9li3xbFL+92wNDWbdPEtNtvbF
        933s5dUtx0de5kJWL7rq4buV9A==
X-Google-Smtp-Source: ABdhPJw2WXmOy7CQd39757Ch9Gplx3g0zYmu20ue/MOH5mKdB4b7GXrETs03LDjoXJjP60Ndbir/eA==
X-Received: by 2002:a05:6830:16d9:: with SMTP id l25mr932576otr.314.1610068411904;
        Thu, 07 Jan 2021 17:13:31 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z1sm1717351oib.54.2021.01.07.17.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 17:13:31 -0800 (PST)
Subject: Re: [PATCH 4.4 00/19] 4.4.250-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <31074bbb-2da2-b576-4576-0dc18cc5cb12@linuxfoundation.org>
Date:   Thu, 7 Jan 2021 18:13:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/21 7:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.250 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:08:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.250-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
