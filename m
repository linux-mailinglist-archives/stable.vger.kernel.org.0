Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723E638BD64
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 06:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbhEUE0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 00:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbhEUE0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 00:26:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247EDC061574;
        Thu, 20 May 2021 21:25:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso5858253pjq.3;
        Thu, 20 May 2021 21:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YInGmwtN+gHNeJbff1aTTrGySsHgiB3luVCQXcJiocE=;
        b=eooEX9XzMsFo2wFwyUbiJ7EqLcn/KI9iwBubbiPU5/io7tbF40Lpy41Tk+AXOPjRtx
         rV7+uyeLtcpwYQWaBatboLYzfKsNW4gpv7MQxsHJJ/bvLeAJcqMa/ex4ezUbixZuJiCr
         sNK+ZDpmR0qIUhY9mZc36fD+erimiTZKittAZyByV+kwbdlBlYAvnQZ4N1+3rqM1/mP5
         AnQfqOEQNgRKgRUERLFG0Z2Y9kUX0bntYcWdyUZMj4xUdft+hMwbJSchz7EuojpB+seB
         mZbgmDCV5RPPiaLKA22Tkuvmj9C98BsbvBVMQt842zaqjec0VhUw2NoG2RxINsVG6Ps7
         xMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YInGmwtN+gHNeJbff1aTTrGySsHgiB3luVCQXcJiocE=;
        b=VvO36OQWi6o+P0Y/oT8YQCGpW+yguqC4XJaDAc+MXqMbXTydT3lk7UYuUMB3VX35hu
         j1voU9UccMwbOdfy3qRDawvA5P+xdT5GBiIU1dJXsa85WZ7VJdltPP6dKLnO8G8AXTMO
         tidb/gDNCR5Z1Hux64oiJchD8k6p0SoJ/PMgvPDJ0+aZcWQHedA6BG8Ia1PyRI8/bU2O
         2YBYGzuF5YioUjoxvyj+PeF8ig5G56CL47KSQwBUuTe8aEJnUWtN+e8RxAe0Zhe25cFy
         bRSKBmt7/PwNI1cD4QOxdkAPPgNZzEg5qLzXe2mNRhEEucVUii+zn4pyI2DUZg3D3AdH
         Z0Fg==
X-Gm-Message-State: AOAM533uz9yyrd4sIDHPR4WAz3GmrrP3Qyra3LVQGvraX0iKiRoESlZP
        4PYkoVYE7L3LGj7drzIOZquHKekRmTw=
X-Google-Smtp-Source: ABdhPJy3WVmBg/Pmc6soyaj0LyXC1lCfl1Ib70RaJcjTjM+fHasJMUCl93dfwFdPhcg1WKids4aL6w==
X-Received: by 2002:a17:902:cec3:b029:f6:276b:a2b1 with SMTP id d3-20020a170902cec3b02900f6276ba2b1mr6447568plg.71.1621571115269;
        Thu, 20 May 2021 21:25:15 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o24sm3155878pgl.55.2021.05.20.21.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 21:25:14 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/45] 5.10.39-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210520152240.517446848@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <28a13d4c-4d44-d051-f201-c5e0547e3e23@gmail.com>
Date:   Thu, 20 May 2021 21:25:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210520152240.517446848@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/20/2021 8:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.39-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
