Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8980726AF29
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 23:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgIOVGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 17:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgIOVGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 17:06:16 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69619C06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 14:06:16 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id a3so5542806oib.4
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 14:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KcpSM7PS7PsvIaDBC6wC/2fRLEAM7h6XtduMyEup08A=;
        b=SmESRUV/vjDH3aGyqxFESW8tMhQ/WVwKedSfeQ4gzz0yApBKny/LpXh3LHgo9N6nZn
         DpfgvTFlqNAZP9bh2hIOBIqapYxs8uLqnca0k4PF2D84twFwlznQj5mIRAuyb4NiAmTu
         RtCHGrVtZqLcaLvKqIQ8VDIoz2kM08zM9MxT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KcpSM7PS7PsvIaDBC6wC/2fRLEAM7h6XtduMyEup08A=;
        b=Q3P7BNq29O4NCkOk43NrsLSzkJy5TjKiUalk2DfDB+RbIChMoZhGN6ZVKQTlCmUfBB
         FrGve/XjS0BPgBqODQyZ6lYT72GbYo3Vx0mUly9c/ePSV4fv4kD6ubMG2MpSoERA0qIH
         S4sq8Ebu34rCFtNiVNcatTZHgsGwNbDSTw/lQzaxuTV78oNX/seljy2a6amX5wkRpVeK
         8/+5nOJTh1I2nt2UD7509YY1cOXPgtiYhwQznEEY853HvV6eiE/7HjXu4qHU20SJ1Wyx
         0CWpaPC9SRhkTbCbY+c6u6cZnM0S+1VrBNjy345wyHVrxRH7K/MHw06TNjhna8DFwMpI
         zE4w==
X-Gm-Message-State: AOAM533EGt1NskD0JBfuXIxlZPwE4Lz1YOsEs15vVDc6tJDBfyUjF3ze
        w8a/YqaeK8dMEBiCyDj9zk1JfnEFuFGiiQ==
X-Google-Smtp-Source: ABdhPJwGhiao15MvmOslBePDNbz8gaYFGBb/X0Etx0vmLG/fr0rwly57smkVtd+UgPoe9WuDN1ZhYQ==
X-Received: by 2002:aca:5f89:: with SMTP id t131mr987228oib.32.1600203975819;
        Tue, 15 Sep 2020 14:06:15 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h135sm7403746oib.50.2020.09.15.14.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 14:06:15 -0700 (PDT)
Subject: Re: [PATCH 5.8 000/177] 5.8.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b94c29b3-ef68-897b-25a8-e6fcc181a22a@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 15:06:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/15/20 8:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.10 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted fine. wifi died:

ath10k_pci 0000:02:00.0: could not init core (-110)
ath10k_pci 0000:02:00.0: could not probe fw (-110)

This is regression from 5.8.9 and 5.9-rc5 works just fine.

I will try to bisect later this evening to see if I can isolate the
commit.

thanks,
-- Shuah
