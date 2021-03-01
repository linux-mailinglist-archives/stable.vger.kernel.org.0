Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCA33294E0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 23:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbhCAWYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 17:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238255AbhCAWV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 17:21:58 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A8BC06178A;
        Mon,  1 Mar 2021 14:20:25 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id jx13so538432pjb.1;
        Mon, 01 Mar 2021 14:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QyhqjTlxoSSk41wiXpwJuRRVyS45yKpxp8nVn0TLNOw=;
        b=U5TEeez0jTqEyQE/yN/t/KYGeiA+pvW14Lw600tClHo48aYvvvWYa68LDKv+ywtxRf
         nuKhm7BmYvKNe1lO1ANXa9SWPQa3TEoLxbHIeYCDwg1VYiFEICnPybWkt6nqHL2FPwWf
         +XrmFZ/txFotxtmUGLxm6UZpUhkmyyTYqHeoN6BMnpAtXaeXEn2zgOKAy76r0RpB9qff
         CkikOEDe49/8DMXumqhtXWfMdHlJzMO+pQoK7z96s1jXiiXFb6tXYhozx031rDTrSlRX
         WuuG5Kc/N3ONRZuTAWKecQZbdbqAx5hG/zMO/l1mfBmA9My6gY0phUR34QClicJDC2Hr
         0F8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QyhqjTlxoSSk41wiXpwJuRRVyS45yKpxp8nVn0TLNOw=;
        b=Q8qrARwnMYJ4iVmrOleR7/Ozktz6EIcPubr84ChD41QdyXW8fG1Ay7PxwYKFIpFC8Q
         9a2mal+C+HFl5auyO5XpdVtaP2n3bi47yiGvha1LK5S6eZq5wqpdBSR32PZwSiUgKjT7
         CJWK/ZwLIqPd8AGlJUCgPfKb0jO9Aw1v8XCZUolLQWGdpUYJY31TXZZfwUyErFhPJwXA
         bvuvQtxA3mXTYmHOX+niMNV7fzMRqLFcqEkRh99XbG91cz1hV+aJiQ41vXGvpASUMTlg
         CsWruhilhV+R1CRgLMoIzyqCsLJLrK3WgXw/BY4nF9DuDl5Xi3A7LkhLLK9nohaKJKx+
         ApqA==
X-Gm-Message-State: AOAM532+tn+u2BlEQinf12ih4aPE+LY8mTfHNMBhv5Gf1DBtPqgsTbnJ
        EAClSxt7ta+DiKQg8y2Cv57UR+ZyPkg=
X-Google-Smtp-Source: ABdhPJzBGBWVLOegGgD/wbmxmMaVCyxdBA2Sic6cMlt3fgbtbwEQx21C3bElubsX4c8TAWz/ZltUvA==
X-Received: by 2002:a17:90a:7141:: with SMTP id g1mr1030654pjs.150.1614637225015;
        Mon, 01 Mar 2021 14:20:25 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id iq6sm431103pjb.31.2021.03.01.14.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 14:20:24 -0800 (PST)
Subject: Re: [PATCH 5.4 000/338] 5.4.102-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210301194420.658523615@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ef02a144-343a-dbbf-a650-a90d179e74ad@gmail.com>
Date:   Mon, 1 Mar 2021 14:20:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301194420.658523615@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 11:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.102 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:43:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.102-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
