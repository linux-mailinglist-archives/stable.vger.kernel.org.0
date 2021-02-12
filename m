Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF5F31A4ED
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 20:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhBLTD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 14:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBLTD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 14:03:27 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91BAC061756;
        Fri, 12 Feb 2021 11:02:46 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id j5so248944pgb.11;
        Fri, 12 Feb 2021 11:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+rTz26vnYC1fotvas8j7PrVOHMU8dZmXWqxuNF7AEdQ=;
        b=sWb/f+VeYcBuxE8KyGryN0dGxT4JolGR2ALwoDfPjToVvK20OomqPL6WVc9IFN1544
         rX2J0IERmJcIiPxAGFC61ISedk0u93meTehf1Q3kf0b1A9apR+h6TQtsetCRCNGNmO5D
         4i+ZAOfKjufYGlGT1dy4gUeD3B6IjiYcSCirEpzAUJJGxzeP180hKOd4NOSMJZmPuFuZ
         AdusP31EH7ykePvjgkIZ6EzrXGb89rIF8Hq275+KqVA5PqDdlK3aFujABx/WPrEjIkbf
         ypGjKOkXPAs+fElvYj3gYgBVZIdAZ6RWoA2Pwcxfpr38jr+HbL0XKYM49LaRcPttyGvn
         7V7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+rTz26vnYC1fotvas8j7PrVOHMU8dZmXWqxuNF7AEdQ=;
        b=FAzjqpjP56RRonB8N8p8iqL/Bf++/Bw/k8T0X0ZPcY56FuT2d/UYIi8XoAydLhsttA
         WvWwhtl+KOO1CiVQAuc92MkUD8wu1ygtFV8OmG015A5+E+oHqDmjEfMXDa2vbOjcbN3g
         B195wnHNZP1tTbWWmWypf/gYRnmY9FKFIiJqAjVp+oBW8BFOhs+K9c6Owb6uVj4ImVJY
         vOftdHSOLhg08ONyAhJRQwzVELqawhWUuJgnoI36lk/urKLIj2p/bNREQv1sNVDM4cqF
         BE5t2Jv+8W1empWWymSb+jysl25G0vybkUJ5+qFKBflXsJOxZ6xGLRKOQxxm1efrOurM
         k7Qw==
X-Gm-Message-State: AOAM531hb/PAzgxlhjcjdFLt9V8+Rk0rVNjFNhKM8p/emFvOG9lkeZZn
        L8tqYa8RO00neX+8mw3zgnH36rbv2rY=
X-Google-Smtp-Source: ABdhPJyT4PlVF0GMJ8exTobaR2IbCESakNk1QQ9E0ZKxgn0hWz96WBqc/YRGnu8aUTkBM9RhA0L90Q==
X-Received: by 2002:a62:8fca:0:b029:1a9:39bc:ed37 with SMTP id n193-20020a628fca0000b02901a939bced37mr4116532pfd.61.1613156566074;
        Fri, 12 Feb 2021 11:02:46 -0800 (PST)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y9sm10091297pfr.192.2021.02.12.11.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 11:02:45 -0800 (PST)
Subject: Re: [PATCH 5.4 00/24] 5.4.98-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210211150148.516371325@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b56a46f1-4d7f-d3b9-89d6-603c153116cc@gmail.com>
Date:   Fri, 12 Feb 2021 11:02:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/11/2021 7:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.98 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.98-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

On ARCH_BRCMSTB, 32-bit ARM and 64-bit ARM:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
