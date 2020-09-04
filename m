Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DEC25E271
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 22:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgIDULM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 16:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgIDULK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 16:11:10 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB0FC061244
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 13:11:10 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id h4so8385549ioe.5
        for <stable@vger.kernel.org>; Fri, 04 Sep 2020 13:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gkfQj1LIg6HcRXXs9J86JWfLhD4SCmRsNf1G3tDBlx0=;
        b=P7IvLEAVnnH7d7vnGK7NWb+1RvHrAYDrHKvZhkU5OSYDcQEaxt8qKItOMfV1GjNGxu
         Co0nuOrCGxRVPPtMlR6AEuKWHzUSjWRXGhTWevrq/eP1hEAmxqKf3pPpqME39TYFH8n6
         KTZpuEq9EMeHCWRamfC4ZMmUyzyACfrNPh2oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gkfQj1LIg6HcRXXs9J86JWfLhD4SCmRsNf1G3tDBlx0=;
        b=gJxgSOb+1NbFnj8zScZkhy+DGoui1Gi7JhMO9Ai99cSEIY3cAfXJmbkT0tRsjk6Ho/
         2/A8RocQrnskujb409niaowxAOA/qNhukt4MD1rO7ov7rSuWWcA/yIgxJFRM2IJzZDkf
         YwwykpJ1bGgp4aGlpNUwBEatD4dCBKE7TrXlbXrx/MyQGLbNYORvFuJGaEKxu0Eh6U80
         OPI7R8HZt5tuNpEmS10Xfbt9rBCz0k903odPuoC5ezg5mHpSx9sa42yajJEXwkWp+q9t
         3g2tC15xkWQ3dLV397sl6xoz4Z0CPeZ5jjkCf1DkW2QimQin+8JZN/bhe8t436btYNcf
         oGeg==
X-Gm-Message-State: AOAM532mNB2m2lQK410lz2p+vDBF1SN9K7P2EE8gFXZ/PEM01oC3RYn3
        DG3Istw+wPHOp2JMejK8BOeERw==
X-Google-Smtp-Source: ABdhPJwS0WstSwUkafcH//c0oAjtxnJzWmxj/JrT3bbEFd4x5QUIjJRsFcdmMxtqKV7T2MpSrnDqug==
X-Received: by 2002:a05:6638:967:: with SMTP id o7mr10029350jaj.27.1599250269796;
        Fri, 04 Sep 2020 13:11:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u17sm3688254ilb.44.2020.09.04.13.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 13:11:09 -0700 (PDT)
Subject: Re: [PATCH 5.8 00/17] 5.8.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200904120257.983551609@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <46d98b44-ec5a-2f86-55ab-ac69e36c4c53@linuxfoundation.org>
Date:   Fri, 4 Sep 2020 14:11:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/4/20 7:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.7 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2020 12:02:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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
