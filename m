Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0786E2DF1E0
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 22:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgLSVuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 16:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbgLSVuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 16:50:51 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052D8C0613CF;
        Sat, 19 Dec 2020 13:50:11 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id l207so7169546oib.4;
        Sat, 19 Dec 2020 13:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GFpPc+IZ7dHR3aZiEJ92+zgTFc7TCbwQCj1qlhhMk8k=;
        b=utl/dK8E23YyTLSCmAek9K6s+T73qvUyGDmyed/NPRCw9CcB9uGBkhF1UZHF8lWeBs
         KlGj3EbycuDjD6bSIdiERqjY4Iu/r50g4I4/r8A8NKZYPxLc4/vWSnQ91xIYvs5s7lBv
         +As9lFO2jAcVV0T/pE+QK1/dfLqbMXTENWUCj8SpO/ioHDNEjhhrcL+efO4A1PUPqTDk
         TTMklwFCGeFbdtcBi3QXXTBi92Hy5WhEqZ99WChWFJ7XdRuiyd+cGR+zNFQHVBA/z7Y6
         +PPptVcq/UlngJp0MMNmz3OHNMd29DqN7lQjurf35F+xIZijT6/GaGZ4HFtKn6j+it5Y
         SCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GFpPc+IZ7dHR3aZiEJ92+zgTFc7TCbwQCj1qlhhMk8k=;
        b=dARIKO/cmVj/BUWjAT+FwzxroQl2QXAbF9ROGBNjL+I8Psio3I4M2gCmdxbhFJfW+c
         U2Gc/CMkP9zjGro0Wc32QlovHuwHn5zpwm19Jbta4ItWD0h+Ta9mHY3SMKBwiSeBLHBi
         Pr/yPn30+qbslIeHTYwAO38UDGRU23H7+RbLMOSlpb91mnORmFGoHn3DnQRrnQ0w79WF
         +QikMVHJ9j8aFLG+yKhQe/O7Auf4Neip6Eyc0JNfEedjS+B5ifSVdBXK3BrF9hdj4B2T
         cs/gMSz2AtwwQhzaAaZrxw+GyEt7vaV8OL5RFeacHnCKti+fnC1laN79wNFaNob8U+6p
         JoKg==
X-Gm-Message-State: AOAM533ugbRdrr+YduQ2KfhKLhhSx99JwmkyWi7z4ZxVlX5DjUsIu1jr
        gbg/XCt61mdPKdqHs3VoM5A=
X-Google-Smtp-Source: ABdhPJwVunwWO4uHQGlfPqHuql/G2oKz00g5FPkuJuy/3TvMvM36vkeu9ibMsOtZZE8mssskGvXLWw==
X-Received: by 2002:aca:1917:: with SMTP id l23mr6847461oii.64.1608414610506;
        Sat, 19 Dec 2020 13:50:10 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v123sm2551099oie.20.2020.12.19.13.50.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Dec 2020 13:50:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 19 Dec 2020 13:50:08 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/16] 5.10.2-rc1 review
Message-ID: <20201219215008.GC22593@roeck-us.net>
References: <20201219125339.066340030@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219125339.066340030@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 01:57:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
