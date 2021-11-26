Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C26645F38C
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 19:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbhKZSOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 13:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbhKZSMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 13:12:44 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704E0C06175E;
        Fri, 26 Nov 2021 09:55:38 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id t4so8824370pgn.9;
        Fri, 26 Nov 2021 09:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=sYnlGAQUfRmwSAueCiT44Z+y3IqQsz7wzr550Y2uKk0=;
        b=UKhxKU20ypplLCJRWSoIIbrWnrUjRQNKqhEw3Q9VzNKBzFvtx9SkJQnZbFAVFJt5Ym
         ZGStfQ8kpKQydWLcSx+awb8+igTKOqr+Avy76WI/NUIuhFI83bkBTOB/0sn8YTDlsZv0
         doFFDEaDwPrc80J8FmJbaRXqdheqtZ7fPoCgNx1+jywDOCTWJHchYZHjmdYVv4pVA5OZ
         B+qK52ajPKjkrjslNeOnAkxh8ltQupXYjgnbSlMDvGcENYb9ZabFlOv/ZXnWXFeL2YE1
         rBybCYbGNVCNMwFdpa1/OTgy8uBpGlzn7yXZ07ivCKmpc5SB4jsPh24CwSZlLUnlfu+1
         L56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=sYnlGAQUfRmwSAueCiT44Z+y3IqQsz7wzr550Y2uKk0=;
        b=4t6cvPQkJTHaGi9umTtt1zF4MgT3Uu5A1cnLDHAKPI0Ouc40Li+tnc/wRxb4o1SATh
         4UpKA3QcaWv0UQdWSOr2REfMLGngtP0v0qpMi8fdimsJ6p9vdIqvScg4PC/LKjxozU/4
         eU95saeviLALTT4yj0KNoJrHzRakulljGoc5w2rjFyZF22AroeE0+4ddGTsXigo5dt2N
         JUs0+qQzpj9+j34H9Jp91Ds0zXo84Oq4BdqGqadMz7bJvQh6roHgZtcQaBv5AOeaOKS5
         ynvvzG6tHuCimMZ/NlVb4JltYIF3/BoRXhh+tTwtlT9UsRSWEkNhq4LOZR8MiNsRGMQM
         pGcQ==
X-Gm-Message-State: AOAM532Ao8Ae8mW0NamBOetDI0zP+dfioK80edkjT/Bex7LmQhd7iHeG
        5kw64eVeyClcMY5vII175dN59fNMHeDJJQ==
X-Google-Smtp-Source: ABdhPJx2Ci0B1e/R7bqC5deqZ4XEzkH1H+lPmb6mkQJ8WDNnTSd7mf2uFTLN/OB84Ls5jvPVS8RaDg==
X-Received: by 2002:a63:4244:: with SMTP id p65mr22504736pga.440.1637949337861;
        Fri, 26 Nov 2021 09:55:37 -0800 (PST)
Received: from [10.230.1.174] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 17sm5438290pgs.92.2021.11.26.09.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 09:55:37 -0800 (PST)
Message-ID: <ade173bd-7faf-9b59-820e-52b33d75716f@gmail.com>
Date:   Fri, 26 Nov 2021 09:55:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 000/204] 4.9.291-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211125160515.184659981@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20211125160515.184659981@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/25/2021 8:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:04:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.291-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

