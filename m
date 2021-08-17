Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871F03EF2A9
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 21:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhHQT3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 15:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhHQT3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 15:29:37 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89309C061764;
        Tue, 17 Aug 2021 12:29:04 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id l36-20020a0568302b24b0290517526ce5e3so18745162otv.11;
        Tue, 17 Aug 2021 12:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M85CTWUa6ck0UL5HiHoZ1838UanWxZ4XpbV39GJY1x8=;
        b=JsDChAM9++sqKQUOyUJpTio4P/ElcDi+wKIbpSxd5hNPChpMn1zU8JsqS8iqAT+psL
         eEY4oOgH4bhmzOu9D2SmplIlaUjo3QvLgMP5X9DlIHDqXDw/SkNwCDtvQbawzF0e7tNQ
         0iO5vPBKjyzB5LRi74VuGM7y3TyK76BlXNHtY+N6H9FMUW21xPhv3fducK0edclDPPsl
         fwy1I9lAXXtFn6aUzgZxHj3Xmth2qgzNjRHRdDyo9qRMjIKwQT6TPHVHywSi8Fdbtxid
         AiPiGvvYhPsXzTz77+DXkdsmuLVDPWhIvGeK4km5JeCg/0A0urdQejR9Sbb1dW29oPZD
         px/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=M85CTWUa6ck0UL5HiHoZ1838UanWxZ4XpbV39GJY1x8=;
        b=tbNhcs36dB7RwFosPPKU2dKa9JDrqQJ/iSmsONpODdYazGUh5hdsjw/RrvKD2ungoZ
         RGOBcr20FVHVK0iCX2LKW5vcqLdaGApHwfYWLYFL5H81A05Wfs+OY5wL7yXFrnhxJpiW
         RlM249inyydMhjr+tPZFPYPqXNJ+8Q4KhqwRcgNJPKRrXBX/UPKgBZ86VP0ZNkOpRTCT
         xPeMezMlLNSiR7dSWnveGZkC/iOn+jAdXPE6EaYYSTPf6vh7p/mK3QrS37oN7uRwwILO
         qZiGgLOHWxQJz6m0EV0IXv+2TwgaSebUqoUjW9cza2hdSpJMvRe9vyFodZ/hNlXoiVen
         w2QQ==
X-Gm-Message-State: AOAM532j+klBcXr8h1QXWoE8zej4HFNMDq2Ieu9WNja8YhMRdsgSAKvx
        Eo8dZBIrOvHW3fDRYvz4hA0=
X-Google-Smtp-Source: ABdhPJx/nBzztmXlyyg/uocG5vTebdOrAE2mwt5YhkGAVdBpFpanTO6f49NlQ6LWycQBvtw42KbJuQ==
X-Received: by 2002:a9d:206a:: with SMTP id n97mr3736084ota.247.1629228544007;
        Tue, 17 Aug 2021 12:29:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 4sm664136oil.38.2021.08.17.12.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:29:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Aug 2021 12:29:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/153] 5.13.12-rc2 review
Message-ID: <20210817192900.GC412158@roeck-us.net>
References: <20210816171414.653076979@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816171414.653076979@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:15:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.12 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
