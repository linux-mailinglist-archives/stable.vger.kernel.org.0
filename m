Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A0D47B36E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 20:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbhLTTGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 14:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240685AbhLTTGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 14:06:33 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26FDC06173F;
        Mon, 20 Dec 2021 11:06:33 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id t123so8164519pfc.13;
        Mon, 20 Dec 2021 11:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dhDktgf3Ok8ulF6z3cGgYxFOTlFBqiX9R2kAwUoEizk=;
        b=B128Ia8P310A3Y4+SUu/SjGu8LcK+GILihC8fQ1Cxxbc1nASPX2nauamlBmPRy94P1
         bqYZsyAFvZhyiT/u+q+IKqp8z0df/tt2CAhxBHuNamz3fxwGO05DTFo5VmlLgRTqqp6w
         p6XC6jGRKKV9bGtwbpAdvSZrQ2OvwnVGb5a/pPa0r/64AlZgyhkGuoJlIlFIX9ysbSy7
         NicwwH/+GiI2MeDZkoYOTRwVtDveWof6Xav1JroUfudn0ZALWjoBFjNU0SKRWd98hYUF
         gjdmK3vFpGf1KnbsnXRpuw40FqqDLD12145RSwwF/pI5a6nmA1ZdoydHTH7llMRYN/k+
         T0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dhDktgf3Ok8ulF6z3cGgYxFOTlFBqiX9R2kAwUoEizk=;
        b=sjtnQGZd2OJbpSTH3Wiqq3IKC3gXFSc3f75uQldNqJn5BXCcKouqUcm2k/oh+alKKw
         xhBULJpSnHrleQ/s2qrMX93Ceh8A3joqhXxrllEMKyNcKVsIZ73y4uX8icIxQDvAfW9q
         OOf88W/8MgPOaErwrPWrkQzGs4KlcCWuEJrHlHosJpwptZm/SAF16WfYaVreUBwMLTgW
         kmw2HAN3tRaAWjTq1dbfxF8Mro7lFyj6h25p2xNhwUbvZ+cxzCkC2lt1fkNcvTarDY9V
         8U8OEoTsfNXP4xa90nw8X4DZ0U1hcxhllJMV42e9uSgYSGKDNfOp9MoGJws8yDnyEbXf
         9eaQ==
X-Gm-Message-State: AOAM532wyxhd2O6HpczJJOilDsY4HPoWZz4nK10f1ZPNSUgzyqKwABcE
        iC0+DcjHNWMb1vpDAOC/G1M=
X-Google-Smtp-Source: ABdhPJz36HoQ54nzT6/hUqsvBtgVNHfM8N/LjUfdgN+c400FjDoB10d03ODuPflezWMXnxwu814vmQ==
X-Received: by 2002:a05:6a00:1305:b0:4a2:75cd:883b with SMTP id j5-20020a056a00130500b004a275cd883bmr17484867pfu.44.1640027193130;
        Mon, 20 Dec 2021 11:06:33 -0800 (PST)
Received: from [10.1.10.177] (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id u9sm19891200pfi.23.2021.12.20.11.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 11:06:32 -0800 (PST)
Message-ID: <41484876-d360-3107-873c-9cf781efc946@gmail.com>
Date:   Mon, 20 Dec 2021 11:06:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 5.10 00/99] 5.10.88-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211220143029.352940568@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/20/2021 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.88 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.88-rc1.gz
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
