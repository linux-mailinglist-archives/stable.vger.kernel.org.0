Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63E73F7D27
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 22:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242601AbhHYU1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 16:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbhHYU13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 16:27:29 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBD0C061757;
        Wed, 25 Aug 2021 13:26:43 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id v33-20020a0568300921b0290517cd06302dso507302ott.13;
        Wed, 25 Aug 2021 13:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I4Wq8WJx3klzBYKJjS7t7iugaF2AhtfV2IcFCk9/tuA=;
        b=NW+2V0vezCyAtXyzBR5q+niO/6tskrgAuVyHulBOFkfAo51fG6HMcaLKdXuZ9Xebt3
         iOJkfO+RDGUzD26MK6qaYEZZ72Pc5de5RaniqCpz4esv2GDjyz8uahyunQ5Vt1CBU75H
         nSTkhd18Mw5q1sFm5PoGGNlJw5/d6izOu+AZm3O4AnphEsOL3PYbPWhvtAe6lOY4Ldj8
         +NWIQrnXCkeOGlZvPKJVCSWQmmEe/VE9mIXPpGkwkFRjZfaxxc4TebOZZdxPsCezvIJ8
         fTqwMcci/zJR2oKwx8H37Kk4VJxiXbV2tXnFcyH6+EMN6uQzQ2VXpaYPUwS5BtUKxxF2
         HaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=I4Wq8WJx3klzBYKJjS7t7iugaF2AhtfV2IcFCk9/tuA=;
        b=bTiG8xyQCzHw76oUmAnY/SrZZBVsIofR9+lePWpfzU5FAILGLchNDqICb2r+Y9kq4s
         AjtZDbmfOHA3rfvE5rr7+lR6oosHktUw0mZYdTxAJMYAZd9rLwY4Jqmx5FtAxP4fMzk/
         oFb1PmiYHR0qY6JEoeQZCYKaej7dspgcbmEK/askm4Rzyxq7wZ2hcNXVmPQfid9FpZgJ
         xC2GNFdZcv/ONsARkRUYEk5zP5qDeAgK88A4ik4LIMTx/bdzu8/rsRIZxYmGzQaWW/TT
         Vvz2Kdy8LTEhU8bPEmUh7GUWSjhkyo+vzGwAA7kHiYmtBEZfOnbsH5eZbictUmb0j+ww
         b7rQ==
X-Gm-Message-State: AOAM531GQNk75F7+cJjbqjoclOHgGUpJ04hd69v7kLtYA0WDLP2GPQ1t
        kXEPO7/qYTqioZcr8FvwpLU=
X-Google-Smtp-Source: ABdhPJwo2pJwShPlXW5Sk4KUkzdtZ63zf5FoPImlo4dsy79sgFlTMMysGvnnMFkd2DTQPuFuTxdiHg==
X-Received: by 2002:a05:6830:1f54:: with SMTP id u20mr247132oth.320.1629923202736;
        Wed, 25 Aug 2021 13:26:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24sm165895otp.37.2021.08.25.13.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 13:26:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 25 Aug 2021 13:26:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 4.9 00/43] 4.9.281-rc1 review
Message-ID: <20210825202641.GF432917@roeck-us.net>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:05:31PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.9.281 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:06:11 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 393 pass: 393 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
