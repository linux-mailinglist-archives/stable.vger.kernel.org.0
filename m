Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5F3AB1D1
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 13:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhFQLCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 07:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhFQLCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 07:02:38 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744ADC061574;
        Thu, 17 Jun 2021 04:00:30 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f2so6231635wri.11;
        Thu, 17 Jun 2021 04:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4PYymUzmy116DuPsenydXPZISGQWCoP3FrStayWVf4E=;
        b=uWACo9J4p32zQEh3kk1gZ0JF0ZLPENV1ZYdsNew1kjWO98FVZQiQtygmIRWgz2ue0F
         BoJkhMcn7/zPY1HiHoAK7oV/j/DEhwjO+WaprUbEkss8BAGiloJbqtuJ/d08haleIH+N
         YtnA5gqO5HZdQa/bwix06j5MtvUtl0NfcgLhUWO8Icj/AtIkT3JCc4Tfv6qqwaKqerzi
         rINnKF0VZR3S2gVZR1j2HZooxkNBn2KG6OzE0Z6q6ihAbrTW347I+rwLEPlYNpKICTLu
         eek1U8O86gh40CkqY7mJx94K2YGEwxI60ycS27kUd8hrZEtCsR69exC5p48pyJqbC7j3
         6VLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4PYymUzmy116DuPsenydXPZISGQWCoP3FrStayWVf4E=;
        b=RZCTC+6AJEGwkAU81JCajkhVsaJfsoDigsQb/Y0vBrxmKwaJtiw7dS8U8MnW6KVEGY
         rhwDaPJRNe7PCkTWDiFX7A6Vh5hIQGl+9cezb1unRbxF005MgYteZ7ekirs9GCz56Tgb
         lONWkSul1WtKSaa4W0uM/+7sf6+Apsf6sXEQ5lB2pMb0sGNnbvV9VrGnBcCvRv3DPpOx
         E1GChcOCg/Lq4FNXlggCbI2XGKBaKqVO8Rnnz/fazoAjPw8qQpYCVnlmk6H3Ti+uI/ya
         g0LuU4Xg1uBhrhzTjcRrFR1Rtgiy0/ABlHLzwDM/Sia1BDEnQZ1v5Y63sye9oe8O/H5W
         9YBg==
X-Gm-Message-State: AOAM533RgRW+YFIguhekvVJut0xlMJciAc5dzRuznDeG+IrQjuk3bYFN
        O6ENtrfFPH+YLXtGP841+jCZ34ACKMzfZQ==
X-Google-Smtp-Source: ABdhPJxckIL/vwSiayYDANqk2+qo+5boEYAEdDPRi5+77A4YKjvjTeTTiNpi1srXk2cAzNFYLFR/hg==
X-Received: by 2002:a5d:4fc6:: with SMTP id h6mr5064242wrw.1.1623927629127;
        Thu, 17 Jun 2021 04:00:29 -0700 (PDT)
Received: from debian (host-84-13-31-66.opaltelecom.net. [84.13.31.66])
        by smtp.gmail.com with ESMTPSA id u20sm4207058wmq.24.2021.06.17.04.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 04:00:28 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:00:27 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/38] 5.10.45-rc1 review
Message-ID: <YMsrS0Sded98xi5y@debian>
References: <20210616152835.407925718@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Jun 16, 2021 at 05:33:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.45 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210615): 63 configs -> no failure
arm (gcc version 11.1.1 20210615): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210615): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
