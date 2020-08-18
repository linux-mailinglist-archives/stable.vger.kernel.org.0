Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D277C249101
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 00:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgHRWht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 18:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgHRWhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 18:37:47 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ABAC061342
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 15:37:47 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id e11so17576413otk.4
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 15:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8JaudXSe47REaUhBRI37iwPCitU5RP8AxqGNR29qyYc=;
        b=fueNB182Ajr3jwXfkset+r8uY8pqzcomkZu0aa+JBLaEyLU/0P+jUshhm6DaKS6LFo
         vBU4mjE79artkabyqpPO2PvJRqyYsr7Xemog3FUpwcQB10Y/fCKquWHt4jZ7slULpJ5E
         2fGcbvJHufC06yUVbR8J1yI8pVb74qEGHt96Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8JaudXSe47REaUhBRI37iwPCitU5RP8AxqGNR29qyYc=;
        b=R61jUrUnzYtWbD1EAjgX6T50hu59exNxKSDRsTBXGUq5gcf3Tdj7kO1K+b/1igbvaN
         rr3ZYP6eBsa8l4g35PR/y6X9LDn5e0KEaUO+w2UdjYBNsA0yI8WYoIRmj3LjoRDArJqI
         dNi02nYNKkUlsrEx+RaSf/j99XSI9NXBHXqozn4A7oPN8Hl7rx6Q49x2SVOL+fIUaXQ9
         9XevqAQWzxkPqkr40w11r4KuIV7UvnGozko6fAoB1rp/xN45CviMZnwNnugjSFwiPsJb
         PcAb6nb4+wapJRq8Ju30yonz0MABVk7kRGvBmdDxFWaKY25H6FNTalwTEW5t7+xFPKfi
         Orsw==
X-Gm-Message-State: AOAM530GhIQInIe6z77VYJm7epQqHVz5LKTtNSQGdLc8MCmmn6db3TKP
        Ef5fvSZML5XP7r7h/sDk7ny67A==
X-Google-Smtp-Source: ABdhPJxmFl5OHIe1QUDJ2v3wnAfEGs7SgjF678e5Dbzdv0cpUPo73Vl4JiIIIBRuy/E+uVCBdG7Zvw==
X-Received: by 2002:a05:6830:1286:: with SMTP id z6mr15841798otp.240.1597790266813;
        Tue, 18 Aug 2020 15:37:46 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s135sm4212896oih.35.2020.08.18.15.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 15:37:46 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/168] 4.19.140-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <48c42513-7f3e-79be-f892-d716175dcd52@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 16:37:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 9:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.140 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

