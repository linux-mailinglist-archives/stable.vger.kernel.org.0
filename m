Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185733549AB
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 02:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbhDFA3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 20:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbhDFA3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 20:29:16 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930EAC06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 17:29:09 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id p2-20020a4aa8420000b02901bc7a7148c4so3257795oom.11
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 17:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8JbhiHo6IOoY5iWGNqHOdb0xxqkEeapiHglvZ8VP2nU=;
        b=KkEGFAt+IZ8fJezAe+1XPvtNZb7bQJDD8C51ZRGBkDP8HiWT6/xm2jk7/Tn44f9x0q
         mPhOZRwHlBMSerJF0lFH19fvt18y6OIL2gnZ9VKsBVXg9dBSApe+4YsCYLufUYOs0yat
         wUISM7EJn89C+HQQ3S4+Ughm77lWaoiivXMuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8JbhiHo6IOoY5iWGNqHOdb0xxqkEeapiHglvZ8VP2nU=;
        b=EEuYL3NFKFfOCVwb+O+Xpcs1yyyIFkiApMDzZhcKalYcHVR4XPG5z24BNqx9v1XOVI
         2wzjtMkTiZw5yyBTuy4O0wrGNWduVt0oIRHPpqGLMyyAI/3XsNWaSq2S55fMoxtmzKAt
         B6hV//9y6+tiN7k7pqbfAm2aUiiWopRc4pIqSwOnZSdhgyqbkBXFIO8Tje49aW0o/ZJs
         ajVv1i12frm5jjEO5dARXiwtO67F/ZSBP4E6oDKmniR+ojAhOEpgLgPuc6D3QzgeX2N6
         65uN4tdbsxobgAPor3iE+TBZD8qbrEahQVlGYMx+J5T5XSyZTgOQ0h0HrMFzUEVYTAb8
         +nDw==
X-Gm-Message-State: AOAM532rdRj74Xy7X/yKMhfIo5Ybc4V8SNm01hL9MeC+YHRnGNOJm7oL
        X8yf0xU45+BEJI21tgMrDo6hgQ==
X-Google-Smtp-Source: ABdhPJzt562iP/S34/FifCpvqG4SSFrzwLtRQ4GL4tiNzhV6BTiiBnEwmGlUds5ZIrlOaLpl7VltqQ==
X-Received: by 2002:a4a:de56:: with SMTP id z22mr24202679oot.14.1617668949048;
        Mon, 05 Apr 2021 17:29:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x20sm3339073oiv.35.2021.04.05.17.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 17:29:08 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/74] 5.4.110-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <76b47745-2ab2-9bc6-2aa1-7cfa1244d57e@linuxfoundation.org>
Date:   Mon, 5 Apr 2021 18:29:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/21 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.110 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.110-rc1.gz
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
