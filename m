Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AE835A552
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 20:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhDISKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 14:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhDISKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 14:10:21 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2670EC061761;
        Fri,  9 Apr 2021 11:10:08 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l76so4517263pga.6;
        Fri, 09 Apr 2021 11:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tbJlZpWRjDeZI4enqunevdZyznCdZANpEDZIY7Yi9+E=;
        b=OA9t5Wgr30FA6MFWcJ7nTMzsiOyOnYavKWcyo7jeu7G9BeWv3QS/Kl8gb0zO+0paVV
         NHJU9GQwT8JlmFVzBikZWpa6HtsU+6ib4wPevWbbrnFrDQQvszLU3ODTqQXo+vdmpJo6
         cY8ZY8kgTSC15+NHVpZw3COUT29fHtlwMo3nWztbQiVtjMTy4aIHx6HD877C2fsEycP7
         jhjfmoSEm06KpyTXzCWtfm1jezyqPNl1MgMYtsybub+7pgbdZg4eBwytvueVhdEU73nP
         2u4fXxeO7PMLrtcqnTnhcxvpAux+CTr2LotS4EJZgw1yLRuJry8iRkEVlBOrTzsz5SEJ
         2oXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tbJlZpWRjDeZI4enqunevdZyznCdZANpEDZIY7Yi9+E=;
        b=k+AXS7IJBG+1wDPBMBvz9goQZebbJjMLh2a3rz1fwgj5SyIzcQtBgjHzqm9LxdaEME
         xN6Dyv22AdXFwR1zRv7eNZ/iZs1/jzXV1+//oPIrGT3mshpkLYEuacZJ9EAhpBPqK6g4
         6OISzuhcd/GwPUGr0cZ5c68nZGGEKsVkMFugL98HUAG1QjEkqBT/T9V1EcgthQsypt8P
         MEV7u6MZv5leP7PkpnoNVzS+2sYLHMMkkEocuysRsrTlki5/DLshDXpoDq1bo1NmlPi8
         tPaCeQInu20dPz2iIV9mLxP0HsuVoKidO40xGALpDJodGULdIDtC9gmXe9XlbzL7qISQ
         6n+A==
X-Gm-Message-State: AOAM531kX+/CmTuOnKp/UFYY9QfV2Xd9wqlRfPLfFhF9rCWFWZDZ8LVV
        iFJD9HqP8cbgW0a9/i4PsCJDBHRX0L4=
X-Google-Smtp-Source: ABdhPJxCLgIVCvukjmR+5lWm+dnIC1KwXpSXANY826s/K6QI6An7cAHT0zXaazUPRDwEPdFux0aYQQ==
X-Received: by 2002:aa7:92cb:0:b029:1f1:542f:2b2b with SMTP id k11-20020aa792cb0000b02901f1542f2b2bmr13189833pfa.31.1617991807241;
        Fri, 09 Apr 2021 11:10:07 -0700 (PDT)
Received: from [10.230.2.159] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id q3sm3093248pgb.80.2021.04.09.11.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 11:10:06 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/41] 5.10.29-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210409095304.818847860@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <80994039-bc7f-fc11-ebe5-ad70e62fa39e@gmail.com>
Date:   Fri, 9 Apr 2021 11:10:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/9/2021 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.29 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.29-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
