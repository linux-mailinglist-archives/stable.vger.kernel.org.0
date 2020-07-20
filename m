Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822CC227326
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 01:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgGTXiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 19:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbgGTXhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 19:37:50 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420E2C0619D2
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 16:37:50 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id a21so13652207otq.8
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 16:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2VapwMIKwhCwr2bWdb3iYIkjYLx7IHfthHZSlZWyQ6s=;
        b=ffXHysH0O/EB1jsyRGMtTayoZV1mwFQraJDX+Bwy6R6Dj7qnXYdn/xx4L8PvSYOe1A
         yk/zRbpPtIwz0myM8hFn153LgiMUGqbW06JoZ6TSglSXobH2WOo77sbBwUNWvUPR64oB
         BgCcQ4u/ei1vhs4dO7xhYT96PTwqs0iveHkHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2VapwMIKwhCwr2bWdb3iYIkjYLx7IHfthHZSlZWyQ6s=;
        b=caeykNDQiSC1O2hYOSAeRGjg6OBzis5bp0ulIaWUbAy68cBcAEjkr9jVF/mop8t4bf
         1/NC1VQmhXPrAceBhnNU1hLC7HqLh2xLmIp3CiK2E++SgdWu/VPtYXnHooloPfULvD2u
         l/YOAV7EgYOiTLDCCGV7f7ln//B4vyqUC1UrxP1W5+iyxJNiw48TzMGLlbMriVNo5C7N
         Tbx4GljkX5Sxw6RMgrsTK66zIoq/l30mO5c6zto5EEQP7PqZ8pkZmDJaiRAh2cwHcfag
         vtUTms1Y9oBDaABrFPtOfJOn/4QDhj4J9tyl5lVyljiKatSaZl4LwJdPRdWJD5iyBvdi
         GAfA==
X-Gm-Message-State: AOAM5317UOBMUZ6xXFHoquJk/9+I0dZR6ZSdEekJLaE1LtclynCvnyt0
        a+zGj99nrbP02DRVuYAThC4KwA==
X-Google-Smtp-Source: ABdhPJxOhm2h4JPCyqD2lRwaFXbuKKoJflI+RELIC7kdMXmosNTd9tZw66UaUlnnl6VpcV6UA4jURA==
X-Received: by 2002:a9d:600b:: with SMTP id h11mr21263893otj.263.1595288269634;
        Mon, 20 Jul 2020 16:37:49 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h17sm4717501oor.18.2020.07.20.16.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:37:48 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/243] 5.7.10-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200720191523.845282610@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8f328303-f1fa-e4b6-d6bb-a2817c7474f7@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 17:37:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720191523.845282610@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/20/20 1:16 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.10 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 19:14:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

