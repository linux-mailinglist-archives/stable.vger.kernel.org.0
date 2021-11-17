Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C94453F32
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 04:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhKQECb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 23:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhKQECa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 23:02:30 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E310C061570;
        Tue, 16 Nov 2021 19:59:33 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso2257042otf.12;
        Tue, 16 Nov 2021 19:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8go9cqygme1rgKkRU54MN0kI17XS2NsQal3QlwdMSyk=;
        b=Yy8zzkRzZDNQaFibUFUVmneHOkmT9WN5/47nAK4a/3ZWr2GtrmGo5NknsGoVB59K1E
         Yywk/zqHR9ggMDwRzzLmNBH9CgYem4E6+Mqw2CrccVdyC6tyB/RaBZiAYO3tUArm+19U
         F1JO1JYlpLvJRV5jYDnKIbciZY0evJKDgz5rpFMrf+P+KBJ9wZnTW7gTTnkHSWu2CkaB
         dMMYV0CfgBaoUeYD1asQz4dt4hhYIOI8iCSeKfGDVfBf/C7qQPGbfcBVE+PyG5npVomZ
         A62GtmqFlq+2gLaGqN7R5fsq3WnJYEMVjeEEAhyDug9f/9B/FLuKQSkc4AbyxB2LBA9D
         nfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8go9cqygme1rgKkRU54MN0kI17XS2NsQal3QlwdMSyk=;
        b=I9gQTTn/yjM55IJGipPFMH//hzg4+uQYCGbwWjgCOWcYBV5K8EvtfmxhzQ9GnHidAt
         OYPtp0gdWpyzOtD6knKL+KyQzayaaNvII0W/wUCk++6GncLHs6WOfUL803y8Da2fTx+B
         Z/F5wQSinMePQHz+Yp7t0v5a9Nej+6aeb8zmIoLnRvyLctwunmxt58BIeSkPFDdLmFnm
         2SosByJ3F6/ZOtzKshFv3nx+kNTHKT5DDeCEPeflc5bnhLOQ3H5XTZjd66t4ymBsjSp9
         dI/ctwb/2+ymXYExYTGhEi+DPJEROHm/3pbyioia6LieQ/pcXhqhuw0gKUBJlmKVYfSs
         KL+g==
X-Gm-Message-State: AOAM532pff8PoC3UXs12VOL0u3EecICto7mO4izxyyuFNKar9t+pRd4s
        eKCeFRiQj1ItjgoaAVQ8DwQ=
X-Google-Smtp-Source: ABdhPJwKwiyYIcc66TB7j3stxwtBv6DZs8ojMmTItMhg2pOW7xJEmzzuDjspuaVbQP6kSnj0xFbgLA==
X-Received: by 2002:a9d:4b19:: with SMTP id q25mr10525265otf.186.1637121572498;
        Tue, 16 Nov 2021 19:59:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u136sm4393695oie.13.2021.11.16.19.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:59:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Nov 2021 19:59:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/353] 5.4.160-rc2 review
Message-ID: <20211117035930.GA212153@roeck-us.net>
References: <20211116142514.833707661@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116142514.833707661@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 04:00:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.160 release.
> There are 353 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
