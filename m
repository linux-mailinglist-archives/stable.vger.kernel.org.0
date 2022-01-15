Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F13048F7EF
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 17:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiAOQkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 11:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiAOQkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 11:40:23 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09529C061574;
        Sat, 15 Jan 2022 08:40:23 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id a10-20020a9d260a000000b005991bd6ae3eso475336otb.11;
        Sat, 15 Jan 2022 08:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LUysGRDK4tfCXrSANW1gz+YTxfq+kG6zs3IFEBfiEVM=;
        b=mXFnMkE1zzKcdvtSeS5nu8D4VU82n5amDtb5yMoihZFIvGK9Oz/WfZdWBoGxTpZi/G
         GDOHh6cijQAkYC8psP9B2z8V6bkva5OaGEwi8MkO+zab/L2jYvsnN9oX0Rhr4SFdxkv+
         L3kGK68yk7b/OIIrK/6mAerJX6kBDLUGRizRL0eRUC71MEsePA/RSVYdesKSoprHlIKo
         QEHx3M4ZnMzJSgZ7hGlhNnlPHD2xr8WiTyykdRHp3q4lW2Vy9Vc1h5MMJ66MuwVE1Q5T
         nks+fmajieL8eBH5OyO+5JKeZ6TiEigx7OC7kVYFAEMXfgM7gtpz2FrBCQf72sIzDHWT
         5yqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LUysGRDK4tfCXrSANW1gz+YTxfq+kG6zs3IFEBfiEVM=;
        b=tIvJIy1EybLfZqJWVre65ELeKuDKs0xK4t+9hq9g4orlJPlkKZY1WuXlV907fD025+
         zmAObOAK7sdK441WHqSVpxnWow4UGy+kqSzCz2IuOBnmxJaaHzj/+wM1PRhnKZbHoIWL
         VaWF+1FodZMLslokkhEEzLGkUaQm8ybeEl+MVUYMS/7oL5kJAjAgMyG5irwOTECu8c3i
         aqRL4S/p59fbleG++2xD6OzL/dEteWQayQwTy9p+bUhbO9y/nSmAfk6q1sR0C1Dzmkts
         jvs2dI1ciILCZNielNxIF+U7Jqn+fK4bRHsgJkWsLHeXMovnrk0t8CCyw8vz94pvQ7ga
         IoBw==
X-Gm-Message-State: AOAM5335oEpUs0kqCRW1XXmUic2qflEMXmgXYjEcyT/leGHV8oXM01zv
        fxgvS4Zkd5wW/Icf+AWNOd8=
X-Google-Smtp-Source: ABdhPJyKnLDLqnJI3V2DHL0pPuw2XKQ62onlbGXbbuJBZk6FVIMjdaPp8yvGWG+T6t9SeDbZP0qkqQ==
X-Received: by 2002:a9d:897:: with SMTP id 23mr11163980otf.181.1642264822430;
        Sat, 15 Jan 2022 08:40:22 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w19sm3645357oiw.29.2022.01.15.08.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 08:40:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 15 Jan 2022 08:40:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.16 00/37] 5.16.1-rc1 review
Message-ID: <20220115164019.GD1744836@roeck-us.net>
References: <20220114081544.849748488@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 09:16:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.1 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 476 pass: 476 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
