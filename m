Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B2F38B9D0
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhETW4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhETWz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:55:59 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1523C061761;
        Thu, 20 May 2021 15:54:36 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so4157298oop.12;
        Thu, 20 May 2021 15:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UKy/4EOqX34+btYJVJguAt3+TaDG0hsu7L4ycydPMrk=;
        b=mVbw1Cv4vucFekYoIn2YMiaHsmhAsLB/eCNqE1NPgAW4Gf35PISLc7mFM/JOl1Rr+u
         LQ9eRoG3nn/eYb2kSGzJFMHAgPDjFFxvFuEB1tccENR8izox8Yj6MEbyif+u0vuN64oA
         K1EMniT10NAoUvzr2ZK0AqPJnKEBcllAqjaM1ISVWrIVozFOmNUIBE+ar/3BUhDcJLbF
         XRMutxyYD9i0XCmWhUhmSHpV9yMRhgh//KLuKWbcYUy0B6kJd/4ZeME2z5cA9brdDF7Y
         8QrkLpPP+2BuXM7jgoTZ9nkB9KrfhEFjiKCh5Jp2p84Fog0GV6pRA4sIlZ1r8l+p03gp
         tziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UKy/4EOqX34+btYJVJguAt3+TaDG0hsu7L4ycydPMrk=;
        b=JXtpsRBMBmzmXerlH6MrCNULl0wEcebwkhZnC75vFvJQNGQIgB1ZvrXs9EY0B/bnCh
         DK0HYkcmv1WeNTrEONWDxN61BdaFb6fv7Zs8CO7eyWA69s/n+6okDDYFpHkTuwgbNvuF
         yFr40NozQ9o/xZ1InHtsizGnKVr7G/l44bdYwnjBRzwn3NxbMuFtiuFuOZLSg51zK6Pu
         HFPMowuwF6bT0ciSTTCiuwCpudpbm7YTtIXI7TNJ1Dyao7/bdhJd/83GL9xHNzEUk3UW
         pZGZiM2wTkWDObBpJRShbOKw97vxdxbuhMBTH8YhSW0XW6/+QsE3UhB8rIO6izhnmh1S
         rqGg==
X-Gm-Message-State: AOAM533hYqrJcAn1GOaQ6k6HW9jUv4kufxFhpxo7FUPPymcfMTrvpzGu
        fEVkSuvhtY0smbSBtHMO6n4GT5H+iXc=
X-Google-Smtp-Source: ABdhPJzU6jIxTAOQ16KWAZumpt28z0s8Wsm3A/Jq3fyfUPEHt2q9I05YZQXofU2zYo+tI7/lxWLHJg==
X-Received: by 2002:a4a:4581:: with SMTP id y123mr5449166ooa.33.1621551276344;
        Thu, 20 May 2021 15:54:36 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 73sm399087oty.40.2021.05.20.15.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:54:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 20 May 2021 15:54:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 00/43] 5.12.6-rc2 review
Message-ID: <20210520225434.GF2968078@roeck-us.net>
References: <20210520152254.218537944@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520152254.218537944@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 05:23:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
