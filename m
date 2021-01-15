Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B822F874B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbhAOVOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbhAOVOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:14:07 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C7AC0613C1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:13:27 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id q205so10939734oig.13
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DS/wgirre7NaK0TzZMFF79cjJGDSA1mZl1Rm2cIIFm0=;
        b=Q3aZA16gTTV62EJQsAEB5xifS2dA3X0GFBQR0debjBrxqymblVxAkl01BanSJq316O
         z/ey47KF1DkpD7EuihxIeZPBTZbpJKh8ScixJUveKJlC90BH4O8y4iAi0sW3HM8BDE/e
         Z/eQcpta2KMR+fIbhqWO9VOMmAIRd1ah2vwjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DS/wgirre7NaK0TzZMFF79cjJGDSA1mZl1Rm2cIIFm0=;
        b=bMZ4He2cxVJzlk7fVGJFxapj9RnBiKZf2xmC31hIeabjDfmaIp3i/PvRlayLKxx+t6
         DSvW3hxP3Bfpq7mpw8CiOv62YsVYJUDz3Si9unuurO0zLE7r/rDGyx5ghVEgPouiC7cc
         7nvTKz4Znx5TH9Wp3jdixgxoCFQ2tX4y7+8O3yaRmF3w6AnB5dd8dCnxT2ZdgYACrZGm
         YSz0qtS5FRjFlC8TmHmyxWiXhz3WmZrRj/qjEofbvyrKaQLE4FJP0TF9pyqk91/nso9p
         j8zXU3HiQbjpb9M3C+DyYtNxi1t1R+xDdAN0cUQywZ6faLSCKhxDt+D7WQWxZnY/F+f3
         WbIg==
X-Gm-Message-State: AOAM533nUi/N0CcA+q4gxnWx6i7Y9qkyzVTM0N/s6s9F3VXDFvW9ktxk
        G+LnkfIXYsp47u6c8e1nwrUKYQ==
X-Google-Smtp-Source: ABdhPJwIImM70d8xTaZFoBIAZAZAynUPj1dipPtwfWPbAbtMuM5wsmbNWRm+dszp8jh8esP+Dr8yFA==
X-Received: by 2002:aca:5b08:: with SMTP id p8mr7046257oib.23.1610745207041;
        Fri, 15 Jan 2021 13:13:27 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z9sm2052530otj.67.2021.01.15.13.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 13:13:26 -0800 (PST)
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <64c441ee-1010-7db0-fcce-3483b2da1bf8@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 14:13:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/21 5:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.8 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.8-rc1.gz
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

