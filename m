Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D01427288
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 22:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243238AbhJHUtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 16:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243224AbhJHUtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 16:49:49 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71863C061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 13:47:53 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id k2-20020a056830168200b0054e523d242aso3611019otr.6
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 13:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GtwT1rQHEgYwqcxPi6l15m6JEL8j0ymwX20loHsrAro=;
        b=UeZkW9HVB3+MWkiktseabHpXDmWswS0JrDgmr5j6XPFWbcg7BcuaE49WoUcwJI4BFi
         seHYL+e3aQiLp1quIBLh6SmKqP7i5wd2M1X4MR1VTeFIXQGtGMv1mbyEMVuKcOiRQDxy
         tLA8GCv5lqny8GdqBQy+PSjd1ISdzyGxsbJF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GtwT1rQHEgYwqcxPi6l15m6JEL8j0ymwX20loHsrAro=;
        b=n7T38DFCobQgtKRcWmPx1Ok/qlIb0Gi7T5O7wwzAmQIUGCq4iq+5pmq80H7sLDfsc7
         mQrnf2+R9S7lh9Bv962gAdh/43cDZY6gIyyxWW3kUMXTvk74GkUVTXe0ZxEU3css58bS
         CFQ25LspE3u1kKqF2ItpEa91xbnuMFtaqGGy1Ae39MXlN4+BJiGkZgNCxlSrNJSnSG+e
         MY898OcCHOUCgljVLhio835nB90aP6C7W30pIZAWeY1EXCCjTllM8FYsjSfZ7/s/Txqj
         tMSEEo4ZutY+SR5nM/qvrLocWcnrGSZdU0dkjtoyVTEknk6iWjfmC8/fPP0una/Orzpl
         rK3g==
X-Gm-Message-State: AOAM532FAQjkUyOn0dNHCR5/DSFGyCY224BsiesxiE9aJP8iNeEmU2vR
        90jHYRkxzKhq03tapCiQQ2A+Lw==
X-Google-Smtp-Source: ABdhPJxlAz3bo/EbjcKUpppN6y8wp8VYHRFWIb0eV9zb7Vk8weVZ/3yJf3VuzzhmeccVdOWulNe4mw==
X-Received: by 2002:a05:6830:2397:: with SMTP id l23mr490324ots.333.1633726072860;
        Fri, 08 Oct 2021 13:47:52 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w141sm119753oif.20.2021.10.08.13.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 13:47:52 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/16] 5.4.152-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f40006be-9d62-f1bc-947c-418a37547918@linuxfoundation.org>
Date:   Fri, 8 Oct 2021 14:47:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.152 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.152-rc1.gz
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
