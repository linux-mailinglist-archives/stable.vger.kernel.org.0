Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140EA1381AD
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 15:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgAKOzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 09:55:03 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46854 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbgAKOzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 09:55:02 -0500
Received: by mail-pg1-f196.google.com with SMTP id z124so2431714pgb.13;
        Sat, 11 Jan 2020 06:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7A6TM08yhdwCzbB22XBkTlOh0QvoYvX1yy2apjyznsk=;
        b=mKF/bcZWLw8HaSVx6sXe0WL8Tyc5gbVmhSmT9OcEIM8SkZ7WqfxYGd+FXQBLuuh0uW
         fMr6ukd2tT6x8ysZ59aEX4sCzwfqfmdKQlXpEdQGnHOzbehs93K6Vh7tcaBUAIrAvAzH
         DnCoNXiG7VHTyZK9ItGsY088QoBcfs6VMg5Q39mqo4+5XOJd7ML/od0xvKnc8Vl15g1J
         lGzw6QcNlpFd1Hb3/oVgmM8WjmSlCPvRLBfivVaSOzwnaq8HY6grbEiq4A9S7noIgRNZ
         2j2O2HEHaUQZr048rsAQ6OnwgRvuimKNAsShjR57FNszsGOlqGraAym9euJRf8a6gIaJ
         d8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7A6TM08yhdwCzbB22XBkTlOh0QvoYvX1yy2apjyznsk=;
        b=laLDQd527TrwcAwAPfEK/omGPUcWUZp/GuSSoGyPuR6JHMcaotboD8gHShDMb9mjDJ
         d5DCsrV0ANDQjb0iRXwAa8SZYAh6HBXt4xFxzhFoKtK1SlInODyB5OrOIA/EgxL/sMzJ
         NTktXL8wqg9m9pMtKQ6LTLXtiiesT/i9VLiO35c5pexAxqFUpnL79QZnCsVAPls3Y+Lz
         2Ewy+Jtqnsw0ehQmrWxZEQ5R5U5BYNUPptNLdbyLosgYm+mZwC78ODpSrxG4TY6+J4Xd
         mCY3SiL2QZr9akmahmxzFfp3lffeqqF1qpi6w6BEIS67HP6MzuiN9mzd28TWhkuqWGQ9
         f9Kg==
X-Gm-Message-State: APjAAAWOrEKbmGOKmqoFjBzIofCm7KbJjXTUABSqMYYR6vKaU7wyRSV0
        iFhYqUbK0fN72BJBGCfTj6ONjben
X-Google-Smtp-Source: APXvYqwL8kKA/t7BXQEwEFOWv2HnNHRauPHjo9IIrviVvmKoZ7pE4c10WMyHsoZ80oW15aZFeN+GnA==
X-Received: by 2002:a63:5657:: with SMTP id g23mr11204107pgm.452.1578754501838;
        Sat, 11 Jan 2020 06:55:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u128sm7488449pfu.60.2020.01.11.06.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 06:55:01 -0800 (PST)
Subject: Re: [PATCH 4.14 00/62] 4.14.164-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200111094837.425430968@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8f2337db-80f6-b02f-9440-94ec887aba7c@roeck-us.net>
Date:   Sat, 11 Jan 2020 06:55:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/20 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.164 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 374 pass: 374 fail: 0

Guenter
