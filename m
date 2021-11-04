Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67129445BC3
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 22:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhKDVoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 17:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhKDVoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 17:44:15 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4663C061714;
        Thu,  4 Nov 2021 14:41:36 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g18so2310758pfk.5;
        Thu, 04 Nov 2021 14:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kmLtEtmTHK7GcZwFr4QBZiF7wAp8VtcoID96wW3kINQ=;
        b=UQtzFOD8KneDPlCIMrINbLuUKJCexhBDs3tvxvcUO+5CtGeGVRjX5nKg8sU6EbwY65
         94HCFl1TBp7dyLt/gO5G8MtVYIC2xHSaKXItWFF9vz3oLo6MjO0gRuSuEfJcZex+awjj
         k5twdLkXZcZdYDQGnxiocZAQJ+qIcW9Dk8zD56hsz1cRgrcRYV1IvGG6de2A7//7+S+4
         CLwf++mq1A0kMOmskWMDb9FAbp3jIrCeQ1O9FFj8NVofNZsrVGXSfPLmzgLv46TbXicx
         9ndffZQltleo3qCK6Cbo6rOlQzhE3pWBuMYkiQgFkBl9KyRyyiTtXtSJrmTa6exEi9dC
         H8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kmLtEtmTHK7GcZwFr4QBZiF7wAp8VtcoID96wW3kINQ=;
        b=5yUXuI4Zn+QUCWcdYqj0kKUbaBZ4kaQcbf5/djvslxabplC1F30Rc+vTxfr9j2Y32V
         Joehr+Azh3LtypXr5keqMuu6heYdJShTMTzFDTj1Noe4FSn3ZtUiAr+N/vKlZMRb8AHv
         hY3LWyGupt0GE9WLoaHtAhpQNTI8D0pBeFBWxcdeEC/8mmp2EJUl72GPEHybeXWcRPhW
         ZPwrO24rUa5dYAg1bb37bzwzpMDRYaV0VXAyOm+rP4pHEdznJnstuDNV3ApDQ9n+LVjn
         2rFzL7ATZdTrS0kS63m0HUZ7VPJN5UTBrUJ7sTwfwN/2W1NUzm6QLzUO5eeuTJM4kZSZ
         jd2g==
X-Gm-Message-State: AOAM5313Fy8O58RWD4jq/gWg44USrLwWoH+ATlIKTsStl5S1MUVuvqc0
        Yp5LTr/94jOgJ48DPMQYcDxF1xUsePk=
X-Google-Smtp-Source: ABdhPJzFnrxEWns8jSggv6HwnscgTf+IqwOAEgkEUTV8Lo7N9bnLkcCtRvbcUZ5yAThw3/UJIRYnYw==
X-Received: by 2002:a05:6a00:1254:b0:481:29f7:398 with SMTP id u20-20020a056a00125400b0048129f70398mr21227942pfi.33.1636062095723;
        Thu, 04 Nov 2021 14:41:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mr2sm4768731pjb.25.2021.11.04.14.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 14:41:35 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/14] 5.10.78-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211104170112.899181800@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0348f327-5b57-cc76-575e-c509ad8f734c@gmail.com>
Date:   Thu, 4 Nov 2021 14:41:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211104170112.899181800@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 10:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 17:01:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.10.78-rc2
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add Audient iD14 to mixer map quirk table
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table
> 
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     Revert "wcn36xx: Disable bmps when encryption is disabled"
> 
> Wang Kefeng <wangkefeng.wang@huawei.com>
>     ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "drm/ttm: fix memleak in ttm_transfered_destroy"
> 
> Yang Shi <shy828301@gmail.com>
>     mm: khugepaged: skip huge page collapse for special files
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "usb: core: hcd: Add support for deferring roothub registration"
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "xhci: Set HCD flag to defer primary roothub registration"
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()
> 
> Yuiko Oshino <yuiko.oshino@microchip.com>
>     net: ethernet: microchip: lan743x: Fix skb allocation failure
> 
> Eugene Crosser <crosser@average.org>
>     vrf: Revert "Reset skb conntrack connection..."
> 
> Erik Ekman <erik@kryo.se>
>     sfc: Fix reading non-legacy supported link modes
> 
> Lee Jones <lee.jones@linaro.org>
>     Revert "io_uring: reinforce cancel on flush during exit"
> 
> Ming Lei <ming.lei@redhat.com>
>     scsi: core: Put LLD module refcnt after SCSI device is released
> 
> 
> -------------

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian
