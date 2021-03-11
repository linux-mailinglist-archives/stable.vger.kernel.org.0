Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2AF336B2F
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 05:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhCKEeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 23:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhCKEeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 23:34:11 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D6FC061574;
        Wed, 10 Mar 2021 20:34:11 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id v14so5942367pgq.2;
        Wed, 10 Mar 2021 20:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+8rnDD+npq7/NwG6/NmcCjJaQ72jp/+rirKVpBestBY=;
        b=riB3bmDplhOig2dJbkrRoCqRGe7JnO3/7ZSFB4Aw4B6orOD9A/zNkSM/GmJ1wiQiXv
         8vQtf6481zjSIRcrWXHEiujmbc2TmZGhlx42HPWyLpVK7H+LCVUD3yhYPITNNegMM8wf
         pR5QiCTb/2B6y91f1FyPz1j6dw8+yE/i2WRwMzmsDqBH+Gv8j3h8qTaR9lWsOGzAHfYH
         P5f68GKkbWkrp1Svp6dfyF0NnDnxmuAEnpfVA/fPb1EqJVij02SOIfGALzPrHaIAkGCj
         rlizexTJH0NvQ+ZFX+98xPGuZtTxP9RbKDbZchgaS/J3rkd6Xqd28sOLkRIGrI0e4QJ5
         qBSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+8rnDD+npq7/NwG6/NmcCjJaQ72jp/+rirKVpBestBY=;
        b=esNgIIkRvK/ER87Y20q95ijUIrfFwCkF6QFopIbPNoAwpXYoLXMRvVxeg71FawAZED
         LBQ7muWnxsJTXQ6giJkiYJ+rEFHn5VoQeBMsbxZvYSwUGVpYQAGcWcdkHq4dtAfBjWs/
         xPapGivEafvY5NU2U61q9xz7rHm7uJ11iN2KAAKNw7fNSvZEkLgMKQ81jxEl3pOwDPGT
         cDHEFxnkKs9q7OFADvZ4dAnS13fEeqjnhORknU29uf3YN6bCFLS7Y1MKJbdOEGKXYXK0
         BalY+p8HCbGTbGPj7wI91IQ1UM45YuwQzqoakiqYRd/pRPgaToI5BJeX5RIr9XtRrpa3
         vseA==
X-Gm-Message-State: AOAM531btLy94EHohG9wwwcMPn+LihMNOGoAkcJWj/qHozP5HK5fMTq5
        gzNygbCOpVo+pYlWlcNsEgnuhBwRtYE=
X-Google-Smtp-Source: ABdhPJz/k51TtzkHEJkKTI9J0inCetQDuY2UnF5cop/6uWIsf2zoq/3C8udzpmCYZVtlM4IAXf9RIw==
X-Received: by 2002:a65:6a44:: with SMTP id o4mr5584204pgu.312.1615437250349;
        Wed, 10 Mar 2021 20:34:10 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g26sm928947pfi.38.2021.03.10.20.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 20:34:09 -0800 (PST)
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210310182834.696191666@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <70e77e00-15c0-74d8-052e-deeb61c67538@gmail.com>
Date:   Wed, 10 Mar 2021 20:34:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210310182834.696191666@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/10/2021 10:29 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.23 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 18:28:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
