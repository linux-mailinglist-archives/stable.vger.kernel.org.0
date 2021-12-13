Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4A47372B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 23:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhLMWBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 17:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbhLMWBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 17:01:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3BAC061574;
        Mon, 13 Dec 2021 14:01:21 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so15682114pja.1;
        Mon, 13 Dec 2021 14:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=plxQ+0bT1KqtrjOceebLFJ1wzwbYVsjS/hfUBTuve5M=;
        b=e5r4l3AVZ7O99PEa/uHa5/8v+qKBGU32ANvstuuS/y3R7NhuGmU7OhNetXgAjazyY1
         3Vg76pg/9D0qeunchoUb+P0Pj9zHIX7fVPnKMGVo+mDtEi/j3yfcI/CRM/DosLhr+jeE
         HGC+ElaWkT9y0VE4hU5fPwGGTCq+petgtbiBtIOq5qoQaWrlyBPapo+phhPcThYD3TuY
         wcDfVoA+sdvVrTb4sTYzU4qhB5rz4ztaRlYxt8lkAVQpUWI+BB49kIlZhYbQbnq4lQ4X
         pAo6rxkGL1Y4SXzQB/in4T5T3KLK5i5eRO9rh0TIhyYh/vQDzZN5poMcjlUCdvUiKSnV
         eitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=plxQ+0bT1KqtrjOceebLFJ1wzwbYVsjS/hfUBTuve5M=;
        b=BM0pR80WGAkQpv27vyG5o5Xp5l6uTSPxxJHnhFQCp0oY4z54J7RtkddlS+RyRpQs9F
         zFqnOX4XsKqi2O9LYLqaTZDl4bmX/jthImwyGiN+9PWvv+a9577mTv24DeNfy7EkpDju
         PhvHSS2N9Fb2FtnTlGjHclP60lQxlFUT9PayfPmWnSWDELfOxapQXrLN+Cuc5+7mXpga
         kWdGbV7kb1VWS9LTOiW0cpLB3XJe+YgU4aO6gEvVDWeYAGYMf3zygFx7Yii5q4UNszdB
         WascWN9n06ANKlks8OnBjO8730tXpANA6RvJWg2W3huHXmW2kBt4zje6ylaUxcR/xkuA
         a5IQ==
X-Gm-Message-State: AOAM532VLxdZF6Fp+Z0WqwBm78LsQ0O/CBkEBTrHCcgN5EbPcBIC+oBm
        NqVtTMvO7yFCnlE57abJUgGILb85NQc=
X-Google-Smtp-Source: ABdhPJxf8x6jE0tJ8pBGU5ogCisJoFNLyIbxMoSR+mMDwxR1HTraQPz19nOVID3G4bYTB7jtjZfd7w==
X-Received: by 2002:a17:90b:3ecd:: with SMTP id rm13mr947957pjb.157.1639432880843;
        Mon, 13 Dec 2021 14:01:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e35sm10899179pgm.92.2021.12.13.14.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 14:01:20 -0800 (PST)
Subject: Re: [PATCH 5.15 000/171] 5.15.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211213092945.091487407@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d915b9d8-7ddd-5e71-1278-0e9c59eae2da@gmail.com>
Date:   Mon, 13 Dec 2021 14:01:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 1:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.8 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
