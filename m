Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B383015F3
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 15:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbhAWOgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 09:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbhAWOgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 09:36:09 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08295C06174A;
        Sat, 23 Jan 2021 06:35:29 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id f6so8112487ots.9;
        Sat, 23 Jan 2021 06:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lBtc+ISfQJa+rk6TEcSFSx0BhsV9Y5p2/9kSLptaCww=;
        b=smcqZ08gTvTS6qDwVAeayNnFYcIdiarRnuYZkNCZveBA+z3h14RXtl7jm/U2CDcOLe
         sfvfo/KV8UpRCTGPzGFunJuu07qO7p0wYFz5YjLGLNuenovAMrhHlFaEXwl/hqqutQi2
         2eAYLd7WUd36TEfcgt8sx3Oa3FbdJifjqbROJC9AEFYXQGc0s0rIzH7e1fr6shXKMEjA
         8IE19R498RfJS06Vb+44ttIFJBs3ILQYxbCxrRvffml0eQaia5LFCWbm/OOqzDDodUnC
         fbRVw8BPCcoO8982YRSY9JZBZxhHc86raVU4ZS0PnC6edQfxchEGt3w+Kdtz4iz+qj8N
         /i8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lBtc+ISfQJa+rk6TEcSFSx0BhsV9Y5p2/9kSLptaCww=;
        b=griv48X3pp2ex/KboLpq37Ya1A8TZecekKxYfUb4iyfkqnU8P+18w9T+txaS4voQsD
         RiEYFcgqziogWGcFeVfsCy8gPjo8G5afxJl1MQEG3cYGjHBSp67FNnIHgFCwyHLf2baw
         0Aq3RQOi8IRDF0r6Q8iUSdIx2301ejf+nWr2GjIJEX2X51xwGC1daa8HCAe00ZrR3A7z
         6vGiKX54OrFi6G4D+gOALglmF3IE1+2WWzVZjocEf6vQibbXg28SLgWASMyfTQ9xYF5X
         c6BcnP7EPo7uyttYj4p6wugkDfKrAV/Cp45p85rmBqVj6a67U7le1XKD2Z3X9tELdiAY
         1X0w==
X-Gm-Message-State: AOAM533q6Y/sWy8AuoBUkCCXB1Jwyl1ROaJxVG+eSoplyAQ1KC+NewjW
        iKuzwFpBl94zRGmnY0TTE3d4h83Wmig=
X-Google-Smtp-Source: ABdhPJwPB9c4mY2UK1gb56895ZYdkd0Abpq3sQRZHLTg5OSC1xSKSxx2cKWcb88O3gMtC+N3ekHANQ==
X-Received: by 2002:a9d:8f6:: with SMTP id 109mr7121901otf.199.1611412528504;
        Sat, 23 Jan 2021 06:35:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e16sm2331147oth.34.2021.01.23.06.35.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 06:35:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Jan 2021 06:35:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/33] 5.4.92-rc1 review
Message-ID: <20210123143526.GD87927@roeck-us.net>
References: <20210122135733.565501039@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 03:12:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.92 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
