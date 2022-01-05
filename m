Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50525484C19
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 02:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiAEB3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 20:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbiAEB3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 20:29:04 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0755FC061761;
        Tue,  4 Jan 2022 17:29:04 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id t19so62112213oij.1;
        Tue, 04 Jan 2022 17:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HIHh+sUGeflBLomIavBIFXEOqt2GNmpMWRybbW5mJ7A=;
        b=lenDvkykoR7Si1pilJm3/1POnEDGNxEBqlCsYpeUhc8rry28X1pZf7ikaQjuk56jr+
         EQeZ4XcFnKsgWH2pAsqUIewPgqLDt2kX3SI7z6/yG3w6yK/96r4Vie8NsMPUWkm/D2P6
         kg8usMvcroJRtWPHxOEr+FHU3ynGXp+zHP7GPBZWgFXhNQijgV3vzkJUIepOqUKOrPjx
         b8gU4St4dQa2lbM9B6Y/hLRHYN82gBB9bwN6BUetV+dJ7W89dVesq2D2JJJd99HuLlBN
         2Qvjyqxlc+Mfl/kheyDkLBz8+dQvhuyrAyzZkpvH1rwuAfME7KW7klEbN6i0KQvjsIax
         dVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HIHh+sUGeflBLomIavBIFXEOqt2GNmpMWRybbW5mJ7A=;
        b=0ja8USunf5f2zyER9PJcwmaCLix+PPCe9Pek9C9KaLtnt/F9cpy40xlz2qNtje8uJb
         Cgq2mlMZRGVDc/deXrqOPoS1XzkPR8bx0bgZ0js+EY7sCivOpW1MF6yIOpR4kbEjPwRS
         Crhu6/FdSie9+UbaqAvtqRQTyWT+7VTsKThkR2JmpgPQvyc2u+LdHJjch0g/Y3Q5zbJM
         JEUUFvpChIRBQnenLgYhCmLjkeG5ciZaOr/5RKTfE+yQLxsehAK3zLEO5QMfp7KnvlET
         NQdGIowPAZRPpr4EIT3xaE+Am22ud1NioHSRQB0xWUZsE3+9nNOL6WA1dh2EcZ0qtVGa
         CC6w==
X-Gm-Message-State: AOAM533d1ftfRvnQgq4unVyLD65dQBaawQjQwQzEy5SV0dJjlSnjcsnc
        jsIScf/ydhDN90Wf8bqQfo0=
X-Google-Smtp-Source: ABdhPJz5Lzh+WQEckX+/ECoTcsY4v/oZi13rlHGmxIu2p3X8Zs9I2s/Yvkw2bnFFTxVY4CoR/cpk5Q==
X-Received: by 2002:a05:6808:1709:: with SMTP id bc9mr815546oib.130.1641346143417;
        Tue, 04 Jan 2022 17:29:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c10sm8614741ots.73.2022.01.04.17.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 17:29:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Jan 2022 17:29:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
Message-ID: <20220105012901.GB2729171@roeck-us.net>
References: <20220104073845.629257314@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104073845.629257314@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 04, 2022 at 08:41:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
