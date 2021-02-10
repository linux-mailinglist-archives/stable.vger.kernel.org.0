Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2A5315C49
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 02:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhBJBbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 20:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbhBJB3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 20:29:04 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B962EC06174A;
        Tue,  9 Feb 2021 17:28:24 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id q5so380963ilc.10;
        Tue, 09 Feb 2021 17:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gOU01AyjgydkPNGUzMi6IsAR718Mx6OY413SF6O7Ahw=;
        b=JV08UY41DRLn4S8dzLaZe5iGEsLRVmYqZNM+IlPevJajjWIRGZF3d7xGXZbE7LBm7E
         tj2ECmFPv76h010UeEBk8oc1Y1qEeELt0O4/r5Yp3ZfC4CPMU3/rtkLpYChMMaTTqhRX
         vl4pivgCZ39kxDpqP2iVJXcOMgy/0sGubBLzsyQdjTRyLRHbTfUshXT3r3zxv9r+ZrFc
         yTw0IB60P12oTjiZhV4IIV04r2JTDul2Q0prJzta59RG3Spv5bq1SbkTyn7CYbFaT0Lu
         0RvG6DC3vkHM7u2MnkIlRBvPF/JTRUusqNPGGMFRr6OU8nd5RLeicDzytHtqv1heaNXi
         f/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gOU01AyjgydkPNGUzMi6IsAR718Mx6OY413SF6O7Ahw=;
        b=UTcgggqxldGB3nhs90ubz50M8QkzU5WfwgpVrCmvpwPI++pTSigtsQn86807jCheQF
         NL09OF0AW3R9A5lRP5o1hYlu30S6Z4/pDqAYw2KvLoTJV0xYpaqKMKr3qvpqmehrnfhT
         e2rDWSrf0VAi8/cG2DhbHKSOQvxkhn4eXr59eCofrANPUfJgg01tPRJV5Tzf9bXM/3hp
         YJywMb26CsyFmLBetAmcJXCBgEPA4RdFo4685MQT2dz+zMcucpe0QuvcESLyOtLo1PMf
         ZRv0Kx7cOn3OCMeNRVcPmeMr0w9G7qCDNZOHYHbohn3LdP3kPP3yBJETYWBCYzQPSQpL
         9rOQ==
X-Gm-Message-State: AOAM532E3vnbrVfjA7+qZSYpK68A89jsgbUhHVHrLg6wld4Rn4Qa9Bgz
        0qaXNlSvBvsON3+4IU6pHA0=
X-Google-Smtp-Source: ABdhPJzECW6xUQNEZ+4cLqNM5rhhSbcTPns6+dI9ocPEprYWFJxM/Sqtxut9gcc9rVDnEu38CF6KBg==
X-Received: by 2002:a05:6e02:152f:: with SMTP id i15mr667325ilu.183.1612920499399;
        Tue, 09 Feb 2021 17:28:19 -0800 (PST)
Received: from book ([2601:445:8200:6c90::d0e5])
        by smtp.gmail.com with ESMTPSA id h13sm206119ioe.40.2021.02.09.17.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 17:28:18 -0800 (PST)
Date:   Tue, 9 Feb 2021 19:28:16 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <20210210012816.GC5618@book>
References: <20210208145818.395353822@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 03:59:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.15 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
