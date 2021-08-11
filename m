Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78D43E9953
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 22:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhHKUBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 16:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhHKUBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 16:01:20 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92C3C061765;
        Wed, 11 Aug 2021 13:00:56 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id m3so1853081qvu.0;
        Wed, 11 Aug 2021 13:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eu42UCR+xc4e2lhU7ja0MgDX034KYJebqltOZ74ChIs=;
        b=rLIx+mcNEu5QvaP02pdOCTSqR4fhiH4H/nXCceDPDYzQsfaaQ37wv9l9YMDxv2WZW/
         AfcSzJbKb4Ym4uVDMwBXlWPHvBK2IYequEmSwrn2l5lB7zPoaa9Xc4HHp1UCNiJfPSDA
         NigSJMaCkt+eMVm7bepCmbRW++PRQgBe7fls1TLI/RYU/F4hxIdYlBDcMlSzRQ9H6jHQ
         KvFZmtXkA1OlysE1xYyJmwmnKazhf1U6ds/wvb58zszvPJFYRfGKWl/yoTqXtTxQ245Y
         XRa+t/822Gh86A23tY0cds8K9oemTQ2h7uqFyJiouo5xFptSAekrOM4W1ZptEhh2I0Rb
         TDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=eu42UCR+xc4e2lhU7ja0MgDX034KYJebqltOZ74ChIs=;
        b=smpejV83BZEMGaOImt/2Vb6LIuelK1qBv/LmZbBYEJsCg92RT8j3p9XD4O1Hj+Usuk
         PUHGPJsnfPI2aE3TMcIxF8HnhHwP3pv9nIQapF+28p2gQwGwkIeyGu9rfgB5xLlBZU41
         aPRgRR3RbBXEg3qI78LWK4kl69GziBj/4tK5XoMMMCFfr/YUZ9vBh3S6s/GAd/6KKiLb
         NrcXDfxk5Y8OFU5Nsj54jnGSfcVNVCTiwHlJ6sgMxaAO5+k8XeG+2YpuNfqSYCEeMilY
         4+3NsCu7lbt7Qv4WOFYEGBEFGwfNEK2G12+D4zyF3JKKTSBFUNTN58eKCd67gTkbFs8c
         0YYg==
X-Gm-Message-State: AOAM530MrXPZf20cNqSXG8ql33eAcyOx+BXpwkrv3ZrdHtk4sR7PVo8n
        7bQMVYmwyTOvldEZJVEw1AA=
X-Google-Smtp-Source: ABdhPJzZfUh2ZEIFzVwnUMX8eBXyL3Qb8g9CWgdQm8qavjIW/1C0yjAiMmek12WFteKMPdalIvjk8Q==
X-Received: by 2002:a05:6214:c6f:: with SMTP id t15mr449015qvj.52.1628712056177;
        Wed, 11 Aug 2021 13:00:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x25sm98861qkj.31.2021.08.11.13.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 13:00:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Aug 2021 13:00:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/175] 5.13.10-rc1 review
Message-ID: <20210811200054.GC966765@roeck-us.net>
References: <20210810173000.928681411@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 07:28:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
