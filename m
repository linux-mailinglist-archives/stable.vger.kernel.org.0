Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946372FBAB1
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 16:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbhASPDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 10:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404644AbhASOnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 09:43:12 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CBBC061573;
        Tue, 19 Jan 2021 06:42:32 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id i30so7045207ota.6;
        Tue, 19 Jan 2021 06:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6s6p4pDHkkLqoUcwAE/Gs0qu3ka7GAPQ3KWyhGIeZZA=;
        b=ORiPEJwfGdAqg5W+1MJwj5Z7teQ0DlUazpnkU9LRyjuB0jOHYix6ZmKYPI1wJXV9vM
         E6mHi0Z5eygblmCXupQ7K5+xlwfTLxJWJaLC0fmCW8TmiP2xyveg3nv2CbuAVxW65JIm
         VJesu1LPZppPs0rVw/ggBQtBT5k4h0jQLQsT3PM09ZLKXN5nfaVDDvSpSYlsry0J5Ifi
         IKZjAxGRCKQOkfcVPecOxPKSMGNIN7iSu9pY8yexZ8iVX6+OyqLY1pMxAu/EzudZOmOs
         JpWLqPYIhd2D7Jx2ONbizRCvT0EdSIdPL9pQi8SJYklnqjqOR1P7nSSSV8jyUaMkjX9m
         9g1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=6s6p4pDHkkLqoUcwAE/Gs0qu3ka7GAPQ3KWyhGIeZZA=;
        b=mK/H9tycUFu3erI6eRn8w9X7eINzhW32elx9X084QVXousOX1Ri5Zug2av77jEHPI1
         2NZ/Ex00Tl5vi29eL4UCAh0UMvdx/5U8kZOje8bYHky07xX6mG3qYNyk+Ttn9LhY6SeF
         BN8Wc30pS5vYcDfzowTw1xTYzYTrzNmBpTLz2erJBWASjMu705se35euknfZoFTu70+r
         vLa9DX2pkGyZq0st4QNorhxendxUQIuco0lUH3PUtIIe2tqUjHC0v2esDJmNXI/2iQGG
         6AF7dXGUpNNIKoSJaSHzGgGcCLuIg5sy3pFz2fnATB2Yu2FhAQYxK4KZB/rJTElKi0/Q
         P23A==
X-Gm-Message-State: AOAM5314eG0QZQjIpVqe9szeIf1LjaWP5GB+dBCUYhBOq8yciIpa0hJx
        GlNVOIP8wnA1E8xZee/qLqPcYfEh5sA=
X-Google-Smtp-Source: ABdhPJwzh9wZAK+64qEZty7TUQnxAvPQ00ypeEoI7j4gzY6Bo0Tp3/tCoFFTbvxUiPaMRYJEsIrHag==
X-Received: by 2002:a9d:3e85:: with SMTP id b5mr3787985otc.8.1611067351486;
        Tue, 19 Jan 2021 06:42:31 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l8sm2153724ota.9.2021.01.19.06.42.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Jan 2021 06:42:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jan 2021 06:42:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/152] 5.10.9-rc1 review
Message-ID: <20210119144229.GC54031@roeck-us.net>
References: <20210118113352.764293297@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 12:32:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.9 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
