Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADAED128864
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 10:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfLUJhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 04:37:03 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46120 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfLUJhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 04:37:03 -0500
Received: by mail-pf1-f196.google.com with SMTP id y14so6574224pfm.13
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 01:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dBfbMWcFUNEKkT+XF2R9Nkkk9o+9oNJd+GfuwIs7Eqg=;
        b=XMzzV+DAEvuYdFW2IfGN6hmRXpdab844QSY0A5VRxc+NobACDK2jR91Iwf4tibcBZu
         xGCw3Iqamn9piWvtKPO5+3yJQTknEB4iv+eCNJNDqorqX87ZVEtEHHEfsE+N22QC5l95
         ysoC/ddqlN8mV4ReuhgabiUGBi0/cIyX5olCFnn4A2+5K3HlVoY8ru+CwfodXcrYxnoz
         xmlGkmK5ddr6bSMLlJSvwS5sSYOa4mf5UeYeJf+LsA4+LHAY/o9eJtaMiEpJGt6zka5J
         3jVVHSMnXhtZVpeVOv6fqM6wbqcW96F3MTYHEkLyqWxQyesw4bhkMyalpeBDUekYfKK+
         qSrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dBfbMWcFUNEKkT+XF2R9Nkkk9o+9oNJd+GfuwIs7Eqg=;
        b=M6l0MX7XV1bG5+6croKUp9loarLUuoxZ2Hd1EyEQylIO1TT/162OVmUVgTQGNLWsei
         34ctT8yB/LGfWebeUn+1UFwZDj+4CXr4f6N2sxR5qC1wJ6nOoGXTtMcS9OnV9LvNg3F3
         f2t0QSgdSvPj8JeSNH+eo1wZkRGQrMzkrRaUigGuVZySrxd1TgMUqPRQ3prxEZBvzkKZ
         rSSfWVCzUKHsA3fuxsIpOh/f9Vsbmv7+zF2B9PKgmQEDWTd6xF5Xu7GEvpTFa/K4JR/4
         Eawgp/ogMOWVWhCt7+wtJ8lM2Zz27GMpAHPzM3dZAskxRdFg+UZYTF2ADMl1kvgG8kGf
         UIzw==
X-Gm-Message-State: APjAAAWeWr2IxTZAmgvNgEnAAMFN/FPbrAt88b1tFGFOWym9uGjLJr3A
        YpxY4cQq3XvEHDIrO7x26MaXfg==
X-Google-Smtp-Source: APXvYqwe52fEfg6Le59QSEbm8ez4P7w2lsQ8wg16M2bcDDfAtF9Q98KiRNqGdhKoyUWw/ShGp7iOzw==
X-Received: by 2002:aa7:8007:: with SMTP id j7mr21326091pfi.73.1576921022600;
        Sat, 21 Dec 2019 01:37:02 -0800 (PST)
Received: from debian ([171.49.214.76])
        by smtp.gmail.com with ESMTPSA id a17sm13182529pjv.6.2019.12.21.01.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 01:37:01 -0800 (PST)
Date:   Sat, 21 Dec 2019 15:06:54 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 00/80] 5.4.6-stable review
Message-ID: <20191221093654.GA2690@debian>
References: <20191219183031.278083125@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 07:33:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.6 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

hello ,

Typical kernel configuration on my laptop has no new errors from "dmesg -l err"

--
software engineer
rajagiri school of engineering and technology

