Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC762AC93D
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgKIXWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgKIXWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:22:46 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC565C0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 15:22:45 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id s10so11696522ioe.1
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 15:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lIJ9fsLLrleJPYucRcLlYzMbfCfXHu/EfPR04Z2a4NE=;
        b=GVBXeeZvzbrdkbPUhUvxfFjW1sy6QovFYoTOONSwnHaH/5G+LgXqR6Ss4CwE6ezUi0
         ASavW9yXuiRUdVY0M+a8ZDaEaZ1wk5dnx/zPV3PisUOy2eFk7qA9uQEouIcX7NHDGwyE
         ITt58E7Jc8j5Ap9X6A+f733CnFE1XSuFqKBag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lIJ9fsLLrleJPYucRcLlYzMbfCfXHu/EfPR04Z2a4NE=;
        b=OVutgjPs5DHdi3sCuRlzPG/mDCpY5a3qDIwvnishjoeBU2ZDLaJraK1C2u6P9WuMBc
         +XzofcCu+WYYCDLS+wV0/JxxwXIK3E4zA0H0t6GGKznJ/1qjOIDB01SE1Kj4gCq22xuy
         64LqJsAuQCuOsetuozutg4yMyeEU/lJ7TOX+hQ0qmKITupgzndsvrHLpP2tslhOegO7C
         8f9ZO48kCyItAPSraaWbIpumyt4uGT3c21GJpjJWW70EkTd9Tz7ApfGPDvuV2mFAdSfn
         97HUjr3f1v0OOndnnYrYkZUQlSoBokGc+XEwuMJ1IvmxAOOEWid/eH1FZDWEmZTbbxqg
         CsmA==
X-Gm-Message-State: AOAM531fYu6mho6AIV957Mh6R/3/jD5O/gnpftT15ozAK35iGaTXPHTK
        f3cubRZieYPmQzBx3sxlqpGXJg==
X-Google-Smtp-Source: ABdhPJy9dFysYFTgBCBTSjzGzKTD+ASuF4sLH+chLBqow/3dnMjQP/mPguvioWwFqlAM5zkhyvGhEw==
X-Received: by 2002:a5d:89c6:: with SMTP id a6mr5523778iot.69.1604964165297;
        Mon, 09 Nov 2020 15:22:45 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o8sm6251066ioo.20.2020.11.09.15.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 15:22:44 -0800 (PST)
Subject: Re: [PATCH 4.19 00/71] 4.19.156-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2f6a5141-b143-ea30-0330-2a591dbffc6e@linuxfoundation.org>
Date:   Mon, 9 Nov 2020 16:22:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/9/20 5:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.156 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 


Compiled and booted on my new AMD Ryzen 7 4700G test system. No major
errors/warns to report. This is the baseline for this release.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
