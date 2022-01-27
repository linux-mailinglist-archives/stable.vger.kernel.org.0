Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6349D9BF
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 06:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiA0FAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 00:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiA0FAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 00:00:50 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E87C06161C;
        Wed, 26 Jan 2022 21:00:49 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id o12so1637759qke.5;
        Wed, 26 Jan 2022 21:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Wmyn6ofFtgUE8VS5NHMHlmETpNke1oZSyRIsw7gBiZs=;
        b=DVjd9n8nE7UHC+A/iJ3TxYblLnl8Yr8hYvpdxiifIGoSsWuuPSgtMqcITtlfKgvZ0F
         C0lUd7LBVy6c7OI8FcEPQPL2mbpaPkIYM4aEcUmU4KQJJIHgAx/dtPm59unfs1Jo+HR/
         mTc7JV1Hk5+D8wrfveW6IBJOoizsNAJ2/svzs3CtXZ1G1guPjo53asZVAlX/CLDzLoRk
         k7wvc77BoN9/X7s0AXugFFMR4OauTMgcJ1dlm2ftF1Ct52vkxn+SUg0UE++9X6eDeWQO
         YDrApzeZitpr93CiUrFOVDL4uYEb62TcJAbzPY6M8gUv4LWjxSpqN2avEFQUJWn3e5vR
         N2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Wmyn6ofFtgUE8VS5NHMHlmETpNke1oZSyRIsw7gBiZs=;
        b=PXITkyMoclPmP31w7UUpfANcxO77eTIb270natUlOPE8I8ebqMuoN9LGUz2+mGx5yU
         O/X1yrHsEvPVVCZtUZ+vQpj1x30ptPsNNnQ0DSPC9XPKteVoYCC+iRURD6bxB3SqTN3e
         jZyjVsfl2ilfOzt86xgRdJ9111ELfFS5BXlqd/VxMP8NCDwgQEgYu3oYrA7/P09FFYiW
         zgnDfTb4s3TgUOgKtWejtPCwrKHzUuNaN54McRn1fP7x3AW2oV22hpJPakMwsrSFq8gq
         jZ6sStnh6oH+0ixSN9REV3Zg+AbVxs8L5ZDuRV6QoOqCuU60QttKSzM57ZPcRGz0ekLu
         mkrQ==
X-Gm-Message-State: AOAM531QceABg9yzi/5eArDMgcKK+LMsOovDv3FnlxvX3oe+lHHOYZj2
        pWsmMaw0aDapBGEMiC0BsVsjgnqtHVZuKw==
X-Google-Smtp-Source: ABdhPJyOCU9gBl7ID/FQ0HPNJuEIMLItV19HjRKqP+3nq3FLsYDKNdYgS8k3TKyslPrwGt0hrUmdiw==
X-Received: by 2002:a05:620a:1511:: with SMTP id i17mr1508785qkk.77.1643259648855;
        Wed, 26 Jan 2022 21:00:48 -0800 (PST)
Received: from ?IPV6:2601:206:8000:2834::19b? ([2601:206:8000:2834::19b])
        by smtp.gmail.com with ESMTPSA id 66sm715772qte.42.2022.01.26.21.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 21:00:48 -0800 (PST)
Message-ID: <693d1cd2-36c3-96a1-b15f-dc7f42074376@gmail.com>
Date:   Wed, 26 Jan 2022 21:00:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220125155447.179130255@linuxfoundation.org>
From:   Scott Bruce <smbruce@gmail.com>
In-Reply-To: <20220125155447.179130255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/22 08:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1033 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Build/boot/suspend all good on my x86-64/Cezanne laptop. I've run 
through a bunch of suspend cycle tests on -rc1 and -rc2 to look for any 
amd s0ix regressions and everything looks good.

Tested-by: Scott Bruce <smbruce@gmail.com>

Cheers!
