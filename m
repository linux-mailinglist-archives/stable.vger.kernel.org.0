Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF733D7A83
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 18:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhG0QGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 12:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhG0QGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 12:06:05 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04F9C061757;
        Tue, 27 Jul 2021 09:06:04 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l4-20020a05600c1d04b02902506f89ad2dso2223002wms.1;
        Tue, 27 Jul 2021 09:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1IkDpFp10W4bEOQyy5DShzCeVcBVqiCv7erpcg3wPO8=;
        b=cmydKoiSFF9IJMqZr0KjAF/oOlRWHuhd45pwVGt/WbVv8kzIDY2Kid2WqV6ThHwpY3
         0BDFtZn6NOF/kgmGiV7H8X+PNhTD6Zt65PW/bL5KFEOdLjEy1Ojpfr4incIDz6QcWtfB
         O/3fUqbNhPrjpAHEST9RRVw7jYHCtNKSeY84yqfqtvIlB/uplaTDo5IE0XaxVz5VEpry
         2SaUrKoTXiQyAiqvLASfl8HdmTwHgLKgvtRL4QS7Ks33AAWNup+1tM+Q1yY0tK/LrZsv
         BX3XDVQBYzouT2esufR2i0bgHyHGN1u6N+IsLKJ421BZ0vwnYzIfFGQtecY2+FUEDxL7
         KF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1IkDpFp10W4bEOQyy5DShzCeVcBVqiCv7erpcg3wPO8=;
        b=kMwxMHccY3bWAIPLAnXfSgZNNZ/YYMIzDVIsc9VbfGCv1mjEPIyWiJpm3cG3GoV8/v
         aluKlRsePH6Dr15uhGOoRVUQ7Fdqq3Zzkx+FscuME97DtPgln9wHoA+Ep+MmYMq3/AKp
         GkuPfzNe9gUUi0Zgm72wiqL6PIwB+IIXBeNHpXaUFivcW/UWNsBp1V6DquluG+OpClef
         BiwjKYiRpwN6Sb4cKJ1DleFOdp4PzmHriwZrCCT8T8EdhEN2psDEvkVJcXkw3zRQZ2P/
         eRGb3Vg18hTXRcJZivmz3FubYnl9ivtgvdVeNDUF82qn7fqcVEl/I2rcokelOzKhT3ID
         ReOw==
X-Gm-Message-State: AOAM531OIQRlflkvLA57rQxrlPZ1qe0ryboJdzRyoJOKk9ScZQ3AG3mU
        ufTsqQX0e8uEsrfwM7sO/bA=
X-Google-Smtp-Source: ABdhPJwOhxTdU5cvv5Pz+8/8q7oSG2bu6fF4J4n2TsSdqG3lD9ayFXdVeOUikokQZlnPYkSHtAlX3Q==
X-Received: by 2002:a1c:a7d2:: with SMTP id q201mr5005431wme.61.1627401963550;
        Tue, 27 Jul 2021 09:06:03 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id d9sm3747063wrx.76.2021.07.27.09.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:06:03 -0700 (PDT)
Date:   Tue, 27 Jul 2021 17:06:01 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/108] 5.4.136-rc1 review
Message-ID: <YQAu6ebKn/I1YFGZ@debian>
References: <20210726153831.696295003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jul 26, 2021 at 05:38:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.136 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 65 configs -> no failure
arm (gcc version 11.1.1 20210723): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
