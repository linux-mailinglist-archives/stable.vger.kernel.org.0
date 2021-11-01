Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA9E442286
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhKAVXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbhKAVXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:23:16 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171E4C061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:20:43 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n11so9995216iod.9
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zoMevPyJdrYBIROPtkN6HOlKlyDL8HBD5E88Dm87gxk=;
        b=g2l9yeRFrB91L6CL9UO1GNm6NtPyLpKV/z/gFcEryoDYkJv9GG+rXYtAoiEDJ/8H9q
         1jQRpCYgLvQT3FWBlBVY13eWU0Il4UUegKs4+Wtv5kC68w1TUFuYwZD/pNwo0mh5oB0/
         iuRBeSRxhMdNQxbXc8Mn/HRushTOMYCDmuCOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zoMevPyJdrYBIROPtkN6HOlKlyDL8HBD5E88Dm87gxk=;
        b=5sFvlksNiALeVqsaWACwUHm9BuLldobDFG1WHt/3gNfoA15luqwYqnYb6nUtXnwYiN
         iPNrPwV8ieYYc60SuwxYyrZZdBRhHOxY0smE0VHlTi+1vA8ESXC38x3dZakCIlxig1DH
         2sB4wK/LYrdfQ40iV0OYaiGLS2z+VmLofUxFBxad2b4sAhH73A2lNdhXQamL6yuwmZCT
         uJvdegkvwv21Ih0pam806zdUvYf5by5phiRN+D/dQrrGqzb9kx/U/Kf6nSgUZmZW33pf
         agjIIUzKztmv4Qkbtf0Dk0jN/tJ+dYbRUGx/wVRmI+nyON1sGe9mYpdyOxP86si5jPlz
         1TLA==
X-Gm-Message-State: AOAM531SWWdTZwQVXg3N4b5LOFDAV0A0tQI110G58neukqre3zO2iSW+
        XNCevi7+DmZ3oLlHOV1mfDJVcw==
X-Google-Smtp-Source: ABdhPJw7BWG00UuE9Oq980SBDlh96drTz98spy25uqQpifDx/XGUzusdKNUs2p3xFEWFhCqNzus0/A==
X-Received: by 2002:a02:950e:: with SMTP id y14mr23122725jah.88.1635801642445;
        Mon, 01 Nov 2021 14:20:42 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r14sm8405817iov.14.2021.11.01.14.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 14:20:41 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/125] 5.14.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1abb2653-075a-f279-d997-7b8587ef9906@linuxfoundation.org>
Date:   Mon, 1 Nov 2021 15:20:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 3:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.16 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.16-rc1.gz
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
