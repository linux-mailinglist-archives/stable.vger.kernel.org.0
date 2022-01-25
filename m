Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D4849BA57
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243310AbiAYR2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379299AbiAYRZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:25:21 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20791C061751;
        Tue, 25 Jan 2022 09:25:21 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w190so14217574pfw.7;
        Tue, 25 Jan 2022 09:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ArBnn73lX7kXsDhqA3RAHKvNxpah/qQgV41F/pn/EHQ=;
        b=IMwfTBx4M1jJDUOC9wpdtjP+1Jfhx9EciOPBb83rkBVluVKZtQM5bABYqh88h16iKd
         bo00Iv8GHJIn+mjxa3lx02yARS3fGhkuCKZu4QSq8xCdpHCQrGolriDYxjcKpjxKHhXR
         Y5KarRmcbUoif8oOHcXxCqvmZe5IK0C9Ay0lLLiAg4zhAa+sEwODT447S3o/wJx2VwoL
         tVI3ytSqcqjCdBWLLm6SWxDoHwIJRHmwyrurF0x5iZx/3MnzsXRhL2Gk9TnAxIPSyCqd
         9Pd1KrkBgjq+D3DbbnUcqa2+HoKPvhEZHFhD8AotOxvGllwkkROEiDtY6lJ/C3bmxHS3
         MmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ArBnn73lX7kXsDhqA3RAHKvNxpah/qQgV41F/pn/EHQ=;
        b=Uo2OTxp8jmO5niSwbNZjWAQuTClHj+Rwz/C5lArENotUR20/+L2yj+11afEJrPzDNp
         Q5zikj6Z7sAFdKuJn0jfU1Fta/ft6J6qGaYAfuHJc1mlcK5yoeI9+GmHcPKhAW2oTSfZ
         jJmlTk6e416+69ZQIFsi9PFgDGdKl4EjCh2YwNuekT1Q/VAEbB6oUutggvrR+svDPeDu
         SOfupo36XR8y7wGoMUYOw0+/fgawDHFCJRlV6NdwNHb1ME1xBYWkS7HvvNG0gk9dsSzH
         NJf9bACYNi42sRLkAJ8Bthcpi8L3ocySRk97r4okAOnC0pYCTYT4CZXgp0bweoYRFsh0
         mMRA==
X-Gm-Message-State: AOAM532u9b5DYlBkCUrnEsJqKEq57NnRIG2fa+/d2GkalCtnlGnI9IW9
        PiCjs0GMbuyhsynsJVpzIH0=
X-Google-Smtp-Source: ABdhPJxj6XNFvCAgoxLH7/rz2PuA8ulsluXKzXhZ/4d7yvVvniaF+BXfDyqhrJB/PVWkZ8SaxzpBOg==
X-Received: by 2002:a05:6a00:1aca:b0:4c2:8d43:8539 with SMTP id f10-20020a056a001aca00b004c28d438539mr19634554pfv.37.1643131520521;
        Tue, 25 Jan 2022 09:25:20 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id mh1sm948556pjb.29.2022.01.25.09.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 09:25:19 -0800 (PST)
Message-ID: <296f70ea-42e7-9a55-01f3-5720b51479cc@gmail.com>
Date:   Tue, 25 Jan 2022 09:25:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.9 000/155] 4.9.298-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
References: <20220125155253.051565866@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220125155253.051565866@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/25/2022 8:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.298 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc2.gz
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
