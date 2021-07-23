Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E0B3D3974
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 13:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhGWKrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 06:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbhGWKrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 06:47:39 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172D4C061575;
        Fri, 23 Jul 2021 04:28:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id w12so1919539wro.13;
        Fri, 23 Jul 2021 04:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sND+KookjI/QWXdXaqJQ/mqZiVlgkXsyRcvcp/RwyvY=;
        b=CAXJDTBX8Wh8KdVWOqma6FPbtt61veTJbvHv0G8VpvdK9F899t9cPmKC+KdvmFg7iT
         Ewm65+9m3omS9/mLeYTjxgUveS1XaKNXgbpYXbRV99WpnfUNyrXZUGtWZV88HocpM7OO
         DU0JeIs37UzH7Cj9/LglKH/1XRu8a2nXUOvoOcWIDVMEtqhxwwS/X8bt7vForBhIdtHc
         uSYredGfxU4VvD39p3zZwOAGrzEy7KoeuWWGm20y+AVQaXFkDrH2+moDrLc1PxwIlzxb
         AxKZ8o9Ki1zTQXK7wpqOOStEppHA6ObRop07HQjcogGMmXRXbdDlTCuO7jaXFuRm1tS3
         Oc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sND+KookjI/QWXdXaqJQ/mqZiVlgkXsyRcvcp/RwyvY=;
        b=J/IIe8Tg9oN6z76W/tGuAlTK2k7x20nk/h1pqp4sYCmKoCxHptLdygxGtGpEgmEIN3
         /Rtux/RWyL3X2tOrNEpvSbirRCmegkQ6t7/PuwEj7Vuz9Eg4LKVuJRNHKM+qsY1zfKTL
         teqBN/6JcvpE2nlv5SmWrMTEBM97IYN25ZdcnovBJj9A+cJJ9l/oduY6M5Rx+0/r7ByN
         /QbBNhR6Hyui25bsE+1jbzk+vDAmdCTOMZQJTxwQkzRxVlT9ik6IGdesNVO2annNCs3X
         0auTmuQQCGR4UNSaOte7aDZpaFugPSmshSCyG73jYHM9AWBlLId4pHtUBwPHaOTB3cEY
         IsjA==
X-Gm-Message-State: AOAM5313g+oklqQIad4vKuflR1ErHZMzduaGSFqf7kTz1bztyGk+xHe6
        T71PiQqHAzyQXaCRy34rFUw=
X-Google-Smtp-Source: ABdhPJz0fdlAGTIcvigt15qs8t9+66ARM4QrYQVkW0tFI/Yjs0wnBI9q4r1DnxZ9DA4FRgCJ0hGomA==
X-Received: by 2002:a5d:4a85:: with SMTP id o5mr4796501wrq.410.1627039691688;
        Fri, 23 Jul 2021 04:28:11 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id p11sm32991320wrw.53.2021.07.23.04.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 04:28:11 -0700 (PDT)
Date:   Fri, 23 Jul 2021 12:28:09 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/71] 5.4.135-rc1 review
Message-ID: <YPqnycJLQEoR9YxJ@debian>
References: <20210722155617.865866034@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jul 22, 2021 at 06:30:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.135 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 65 configs -> no failure
arm (gcc version 11.1.1 20210702): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
