Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6782B3549B2
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 02:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbhDFAaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 20:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhDFAaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 20:30:15 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4EEC061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 17:30:07 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so13056203otn.1
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 17:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9wPz/0R6k2Ggjgt8hXGO+XHYLGtpOuoz08N3wBP9Tk4=;
        b=MvtUmQyBN2iQk0LBkOnoUnvI6LZqkMVgd/prDR6zylDuXZuyFQezD5QuX/UzCEldc5
         5kKc9TRxX4mh1iIolZse5QcYN9Q7p+oZUIfrWQp8JC/BCoKTIbxM6pdDW2LKALdHFBNw
         6duj7FkSrJ7EYlI4RSDVzBWzadLV+ymjEiJyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9wPz/0R6k2Ggjgt8hXGO+XHYLGtpOuoz08N3wBP9Tk4=;
        b=WvgrYyuFaCzIpsA6TiviLXAm+UTZKNCZHi9k+UUi6FmR+Gdw7AOlQx0wcIkBz71Bs/
         3nkALu5Dneytde2qaDfZCzzGw0tWmo9pwg1xsiUaGGMBN/7YBakMiOYx8zENz/puAFNa
         TDErRpw252lL1KhbxIUBYq/VYCZ3dZvYyigVBemwAPY3MGSehcdB8IRXFV6TYaV3uwLR
         LTMDfgdCMmLeMpFxgBUnV4cBDF0EWj9I/tYuvlmedQXwVp67LTRNQN6z3VbI3WLxAuo6
         qays3e7G2v0TrsCIKyx6o2nTGutTIgo1IA0ItLvjsN2CvvsI5cegnxrG4QuYk9TxtKtV
         2wxw==
X-Gm-Message-State: AOAM530KK4dOCIwebpppAALT7j0mUshIXaRFmTCSfJFGy3MorHSKxGBt
        1AoHbHfZol6XFlBwy3MchH9QWg==
X-Google-Smtp-Source: ABdhPJxpYM2UV/i+c3ooZd4Y6u6kdBfEJM3VdDfNSWq+pxePP0wlP/cYguomdy0FENHIHxQcvvg25A==
X-Received: by 2002:a05:6830:2336:: with SMTP id q22mr24576682otg.346.1617669006501;
        Mon, 05 Apr 2021 17:30:06 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p64sm3430963oib.57.2021.04.05.17.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 17:30:06 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/28] 4.4.265-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210405085017.012074144@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e022cc60-efb4-815b-279f-c0278c9cfa6f@linuxfoundation.org>
Date:   Mon, 5 Apr 2021 18:30:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210405085017.012074144@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/21 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.265 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.265-rc1.gz
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
