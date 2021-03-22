Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB51344FD6
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 20:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhCVTYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 15:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhCVTXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 15:23:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E343CC061574;
        Mon, 22 Mar 2021 12:23:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g15so11729980pfq.3;
        Mon, 22 Mar 2021 12:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9AAvPymr4tpxLm42SP+faWQoSpFLg5bCR39CG7uClTU=;
        b=dhYnWef16fQzTrRovO69AmJc57Lqox4zXfAJOf8aXF8xOscoSSadbX/Vp7qub9XbZA
         XqukvkGCm5RZ9agcs9Ph3voWXyms00ChFJOz8h7DxbUNlvbBmnn6gZW8BVDu4RuQQR/H
         P4hamiOtb/N31RqpYC5s1AE0AK5Jp70i0VZCd7Vco2ZhXBobu9+IExElICUBAIPVfiSi
         Bpm7lm7yrsbzhfQjILDK+tciuQQ0LzzPJW70SJyxohMYCA1uKM64pcxbxB7EWaF9UdQh
         2jkpNGj3EAaSPvP2PtaG5DKjNg5Qrt0bKp0o/5TbIFDo35rWKM5yzMQuH4QDI9R9LqRi
         9TFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9AAvPymr4tpxLm42SP+faWQoSpFLg5bCR39CG7uClTU=;
        b=V3xI+N2ME+5rHcfAhxQ/SgqKe+l1lxPe87IAThVQ6MDRNGNI5ZWKJkpENke8S338KW
         qzRq6YZ3s6QccDpUJtBFnZKbQG8WRre4UC3Sj2oWBbZStUhdMwvxxh4ZzOIOpWWAcXie
         f6ESGDOiZUuIA+FfgSsWl+9O1VyKdMU+m5aeuEKc/o4SioT+HrUvXqh1M0NPDX0gn0ES
         QeAai5Z2dBB87RzdDeClvrG6viMy8QzgoGHRP0YtJlKTCk8lTRhsP4MDSrbE+FuY+n4C
         GEInVqvTt1PffjUJg3KkuRZyarQf+vGAxr3uVENs9Rerf5ZiWB8Z5qVXQiP37jylxYIF
         kP4g==
X-Gm-Message-State: AOAM5311GFonPnvtD0ClvLQ2yrDHJfPCQupDMisFtwqUiiU+r2VQfrEU
        DG75DazdVhi0+EIBm82Hu/bmCqtqON8=
X-Google-Smtp-Source: ABdhPJzkFm0eGT/pbtjmM4D4ugGoya1rao2bnk8amAOwEc2h3j6nGtCvkgYCmAZgLiXQ9pOgkWdp3w==
X-Received: by 2002:a63:7d4:: with SMTP id 203mr920447pgh.423.1616441025904;
        Mon, 22 Mar 2021 12:23:45 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt22sm201455pjb.35.2021.03.22.12.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 12:23:45 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/25] 4.9.263-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210322121920.399826335@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <15ee2cf7-9d8c-f043-859e-f9b979b5c084@gmail.com>
Date:   Mon, 22 Mar 2021 12:23:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322121920.399826335@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/22/2021 5:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.263 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.263-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Still seeing the futex warning reported before, I will try to zero in on
what we may be missing this week.
--
Florian
