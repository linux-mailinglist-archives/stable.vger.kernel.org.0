Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F06E424B3B
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhJGAom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240053AbhJGAol (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:44:41 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5595CC061746;
        Wed,  6 Oct 2021 17:42:48 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id o4so6522870oia.10;
        Wed, 06 Oct 2021 17:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sTsgBtmsm9AteCMlgNfGMOTf/vWdyns4PjV0/8nTTdw=;
        b=Kkwvjjt4SwwfI0yUQrTPTCGMKnpHvyYFoaBIlAisFzSzV7WAv2/zvxVwJoMcSALdQN
         YwWQnqjRLMNBR5hwCpd5a5h18ZFn/izU3/Lw0FxFp1xyFZocfQSXhezWyxHG7vMJZzIs
         i8hdKCFuNRRk4bbK7VW1XRIp8gqrQKGT4drjkj1me5klbHIj+nb/x9q+M9xGo4y2vEjE
         3bK3VZ/kiSXgSMT7SOpZlDXywYJKAKlmJYkdH2vBvRDCLQLkSuIaa3Xax9zpy0zOo01+
         6vURj3xHjeUI3SbGEGqTxs0QlpxQxvAK7hNoz1eBIpdWFnf1tJjWOuniSkNffbGEmXf4
         gtKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=sTsgBtmsm9AteCMlgNfGMOTf/vWdyns4PjV0/8nTTdw=;
        b=PGULHiL6Y729levwh9XzxAFsY9UOwrqjQAptBzO5+q+jK0OoCwgYYZdmMxU6vYXvmY
         U8wdP9+SYUiKEmKKRc/E/bk8r9apSuBpc7SLym2SVd2T4sromZpDcN/qFQf7XRsCyvqU
         Ll/B2lJDXVPI4pbYDQvlvbZPLEaMUYKOe6FPzhJO53gsP4y1BTzLJz/kldWYlTt2wXOg
         OtSGZRD0/V2sXc12vycRzVsT93tmM3PTniaPiQK76YaCk2QuIc6hLt82gUsjLRCsyb/H
         v07fHfPnwhrbi6TNXcSi20kZPZQe++DzLTPMefDDkT7sWIwu8gr4Pg8OwpXn3uGESFIL
         wSiA==
X-Gm-Message-State: AOAM530002a4qwl7CifMG+DsWtsXMo9rBNWVSDsmDbDzLpT+52mK6qRG
        H6HB5QPb2J01VEd6/WN5isA=
X-Google-Smtp-Source: ABdhPJyM2fZOiv9hXBv1ctMzy1USBjxK/5WAza+eUX9+3/ywNEh8oDNAnpXTRP6oyL00S0mFuDkQHA==
X-Received: by 2002:a05:6808:a06:: with SMTP id n6mr966654oij.86.1633567367809;
        Wed, 06 Oct 2021 17:42:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 15sm399313otf.14.2021.10.06.17.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 17:42:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Oct 2021 17:42:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc2 review
Message-ID: <20211007004246.GD650309@roeck-us.net>
References: <20211005083300.523409586@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083300.523409586@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 10:38:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.209 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
