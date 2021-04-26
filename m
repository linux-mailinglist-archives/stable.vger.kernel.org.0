Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F136B905
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhDZSfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbhDZSfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 14:35:30 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC7FC061574;
        Mon, 26 Apr 2021 11:34:48 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id r186so29555971oif.8;
        Mon, 26 Apr 2021 11:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B/wTUESWv+5zsnBtMWDJuvhja5vWYQeRDD8hkLWU3AU=;
        b=eQGRmV6rbmecDv7BxdOTnSS7DURFHVxbbyII+8FfeO6OPQ+e/jImG2Jyx9k9myd/Rc
         bzuQavAAUju8s46NchRXO3Wx67OI7n8ryEfGdjMdy9cAcIuRlGHDxQQRLf+NoI+ZlYj5
         Mko7n//oa3ZYJrf1zIXMmQEnJ+qCkfUKaXbEz+WKjaeZfxrj97jU83VGdTJzWz6499Vh
         dJvMkAQYBMt0zrkqShdmJKDuhCyyuFNdsrgLGQ3dRqfeGqApRNWMqXaQHcJEBzjH5bHj
         sTcJCijdaeBcbQJo4raKGTiJcsfAhfuf51BlUkkAtOIBZ5CYKD0pO/lMTtiYdYFGlJgG
         LSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=B/wTUESWv+5zsnBtMWDJuvhja5vWYQeRDD8hkLWU3AU=;
        b=F7NQLC8pptfQd+dj4Y7ND5MKOZd1pCexpgLqAT8lmUosdQdA+WZPDRo4tiRo10+K9i
         tGU43OzYeQeGmuv0IzfkD3lt91/S6sNbAbsmyvY+jQPKLK/avjVrwYMBH4oJvKrqyWYJ
         GqfildNeu/JtIt8S+g9AjFlhMoS+33S1MT120wrzstXoADHrYWNcHpJIer+zcSO2xT7P
         MAxRvTbmo4egal8/n2H5yKQUbQCbebEjczPQM41gYW9ojW+cRhRWdoHvtaR+C7DHxJTS
         kxVnn0y6lr7TLqvzvPP+2YIrBSMnL+odapYI5iLLdfelIn/HCO8THYsMYHe9Hie9CCjo
         ipPQ==
X-Gm-Message-State: AOAM532G6Exa8pUdsS7h/RljNXcBc82vlunYr2roLgWff1CFmoRBluJP
        F7STWUL/MzJOIpHwMNaJfPIIDYlV9Sw=
X-Google-Smtp-Source: ABdhPJzVIakmVMUGOxvxUhh/ycfh1PzSMuZXCGsZ4TUvizA0hNhDaE5aSROPauo//qrH/GKGyO8qyA==
X-Received: by 2002:a54:4498:: with SMTP id v24mr13259881oiv.31.1619462087842;
        Mon, 26 Apr 2021 11:34:47 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x5sm3635758ota.79.2021.04.26.11.34.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Apr 2021 11:34:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Apr 2021 11:34:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/36] 5.10.33-rc1 review
Message-ID: <20210426183446.GF204131@roeck-us.net>
References: <20210426072818.777662399@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:29:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.33 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
