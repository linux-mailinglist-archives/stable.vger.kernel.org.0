Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1258B3DB6FD
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 12:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238375AbhG3KMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 06:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238450AbhG3KMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 06:12:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F0AC061765;
        Fri, 30 Jul 2021 03:12:34 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so3390889wms.2;
        Fri, 30 Jul 2021 03:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N/MCCg30Xeynt7z4zI1PDq0MPJma9ilr3kGKBL4lUsY=;
        b=mZLnpFM34Wx8nDNwIlSEFAXcLHABV3cCTTjwGW4dSAVlah6yjrJ89SGRMIoHgvg2gz
         Wg46laaFrwEjVijvsNIfqbKyaia0qo6Rknpzb1mWUC9wmR79zfVqF8iuTDbajdTxtXqB
         4ECVD5o6hX5L+2ik71lTlIUse16GnKG9IZjQTFXgh1MJ/zCUzHfSr6wRttH2dFFXo8n2
         H8+oFlV+sppGMuhjPDQTKMcNQTFtfdXsLcuDVI9ETZdaPs2QAyn7su8iDHhu1zruhtrq
         eIqxc58wUDuyZBFmVBmx/YURcu89LGM8iPAq9HbhFVfWylZ4J+ieedsh3qT12zeLbF/B
         dZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N/MCCg30Xeynt7z4zI1PDq0MPJma9ilr3kGKBL4lUsY=;
        b=MRt/324/gxdfekjwnrBoO2bZQLrTau4Y/Kg8j//BYljNCOdfyTnC3f7bPehNN9W1Mm
         5HM1eN0cNEPD+hDYDasBs83SDTVsEQMT0ZFOsPIz/ZWLIVuSokc/JevrmouRz9NghEko
         FgdANf4KqAG4J7mcBqnah89xz+J65Rn/16GA7MaR/AMLzzBcvAqJ1sSmx2XrBqENwpz3
         zSB5EOndeSlQXpAJuyILi+lwsEfuw73QvTLg2EkXmtzhcvFCFhdTCp8yJu2GGQNBH6b7
         xpqqmVgD0O8JSELcQfx1yXdA9aOtloNF9cXNbjOy83Eaq/NKipr94ZFQWpWPRecboKan
         XjcQ==
X-Gm-Message-State: AOAM531QGh6AfnAKdfvxI98ctPKWzcuLEFOEKHI11vVb7aimZSKrNeMJ
        dYPJPz/xT3toXOldx4mFLnr9ZLgNTZ43sg==
X-Google-Smtp-Source: ABdhPJwlfubSkGJ4x6+1NW8pSASiZ8x6eYvTWRMHAHe7J35QJWQdCaa7SBVkWYC/Ox8zgyvujmhJsg==
X-Received: by 2002:a7b:cb01:: with SMTP id u1mr2042972wmj.44.1627639952921;
        Fri, 30 Jul 2021 03:12:32 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id y19sm1348321wmq.5.2021.07.30.03.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 03:12:32 -0700 (PDT)
Date:   Fri, 30 Jul 2021 11:12:30 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/24] 5.10.55-rc1 review
Message-ID: <YQPQjlxNB1rIQ+hb@debian>
References: <20210729135137.267680390@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jul 29, 2021 at 03:54:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.55 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
