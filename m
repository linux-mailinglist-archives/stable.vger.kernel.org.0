Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C02397EFB
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 04:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFBCZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 22:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhFBCZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 22:25:20 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA9AC061349;
        Tue,  1 Jun 2021 19:23:25 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id t10-20020a05683022eab0290304ed8bc759so1130168otc.12;
        Tue, 01 Jun 2021 19:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WisRZOMSe7gZp4rvPWMV14dWyx0DQxTbYmLA0BmBIeU=;
        b=CDoGe9l648tujSZCXsHp3ZeeuAa0WYmC8at//uXPg+/bYdDBl9ILmcpI8A+gQk8glF
         fP7Wu0986RszjSKvBbehR4Ps4636WCQKkhEOyCoYvzwxdeNfPO+SML+5ZGahxFAU2nF4
         re/MZ51k3IXxoECIjR1q/QSk+dFFDKSE3VIpmVzlVM7mdSiH4mQxwaxNSXcv13+2jSif
         vq4AhWSfy/T7GfN+sZ9P50gOH7OsSdTqoFqYaG2yL3ASUzfKk2KWknG7xPak70Ppwu1f
         D3ezZncm6EFBVvNQeukTsLEglTlk6u0GYghV1N+o5F8BKcv4aQ6j7JY7XTHT5RSYZRAQ
         LZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=WisRZOMSe7gZp4rvPWMV14dWyx0DQxTbYmLA0BmBIeU=;
        b=aU16KRhhXkexPHGpfHnabv1Y2RtzK9uWYZ89DnbYrulDl8TZC0FNkw8hS9vCc9FT0U
         Oz8f8odr7YQIdQPdGcC+zVJTBniUVpsOS4WZ+pSeqquWLPtxH2hB5fRzDdUs0nYPVuP9
         TP2/CJdfdktJqMy89HL2I6k+7JS7im9FEJQHZQ1wEGckSudmJGbV+XafMGcB+vLtai3I
         MJY03reBlF31KsFqAwPbypv+82n+swW/4Rh2gkxO8sYONfQHR4sr1kousKS8dHJ3dp74
         e/beh6I+xj+UqK5HAtT5smoUCIOag7MSxNXxMedK1dVOhe+O8RvNjTdIz6K6+e7SZsWN
         uP9A==
X-Gm-Message-State: AOAM532Vlyx+8N6qJPurKiRDric95YzKd0KY3Pj0WK6wH3zt/GHjvxy/
        pEL5VtybvjQKZ7jZC4pA5wU=
X-Google-Smtp-Source: ABdhPJxTAUdTk6XUmZ/1zT4KO0/0pwH8MsqMs3AAcyCHMOeYiGLGMDiD2IdCT3FyajbInkLciR/92w==
X-Received: by 2002:a9d:7987:: with SMTP id h7mr23763916otm.70.1622600604793;
        Tue, 01 Jun 2021 19:23:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d20sm11546otq.62.2021.06.01.19.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 19:23:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Jun 2021 19:23:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/116] 4.19.193-rc1 review
Message-ID: <20210602022323.GD3253484@roeck-us.net>
References: <20210531130640.131924542@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 03:12:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.193 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
