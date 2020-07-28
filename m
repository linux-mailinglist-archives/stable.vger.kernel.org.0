Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62E622FEF2
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 03:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgG1Bew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 21:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgG1Bev (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 21:34:51 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324A1C061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 18:34:51 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id l63so16035480oih.13
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 18:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qZuvweddU5J1p0ldIWDpQIeg9reANpSyYykBNpL31Uw=;
        b=N1H/5fG+ho1wfw1vPmaFLrfJ49foDv1nj7jiIop7PCQ2amb7rJBcDtfLN+psz8aDSX
         aHmj0Nhn7GJHSs1fZII7VYceefJYq7uSrd4A0AO4PxMPqiwmToxVq+dqlqZDt7yEfdqQ
         JRbXn0tKLEcB2bR+hEH7pViIAw+qWrXNAmzbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZuvweddU5J1p0ldIWDpQIeg9reANpSyYykBNpL31Uw=;
        b=aCBTCYPyquRdEARoEbW8C9GkU1qIvN6mNWlEeZlvN6IBkaxzqZir4+RoIErEVGHciT
         kfLQbMv4WOiyOJR+UT7UZaSePVqcanxfqrKoxppDv1hNesfgC40kBKcYNRUzWhZwL4cP
         BMpCLQ8PS4LzljNTh1y3AOYEB0hKxOpVf52kcYF3mHsMa5TklYOleIwHxsisu+lYDfkz
         P1ejQzp8ok0hprGSh186zBCIB7Id1u2ZCOtcUJaovom57qYGjfpG0fSeZPBj9nyjuZ0P
         sKxjTuYtFcqxqywPKyCAqSJqtqBCvChrDP/ZSHAaAQrUBtBq/2YZimUz3QoOFZi2YbD8
         iN9A==
X-Gm-Message-State: AOAM531fx5QRfG8DOh21Xxk0+ju4U2r9ioeKWmB/2eeRQfgTUXIb+0Iv
        hmY1H8kHcaQl/qyCFmz5T9AMDA==
X-Google-Smtp-Source: ABdhPJz1sITJi5IKCVov8wsHCStG/A7yy14dwSvPYj3vrFOMIzGhXvPbgBMYiVE4km5BpdFCQGCxIA==
X-Received: by 2002:aca:bcd6:: with SMTP id m205mr1712566oif.149.1595900090460;
        Mon, 27 Jul 2020 18:34:50 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q17sm3678462otc.25.2020.07.27.18.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 18:34:49 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/138] 5.4.54-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2ef9cd1c-9bcc-c199-cb36-656f2a8441c8@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 19:34:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/20 8:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.54 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
