Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D5F42AE9C
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 23:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhJLVTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 17:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbhJLVTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 17:19:15 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C7DC061570;
        Tue, 12 Oct 2021 14:17:13 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id g125so1009499oif.9;
        Tue, 12 Oct 2021 14:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yoEH61v5vYk3qtzTr+YMeoTPUI9uNoxvpnXmhJ9wC0c=;
        b=BkJiXtUJDuQKwzDEO8bpt9m9a4B6ipJVA+kTI7wdc987EvO3E9H3EegXsSwgMeEXYA
         9jm6cir3KIogoBpuzDESUaFNJ3UCtCytsCFc2d94dplRUO9X/CKmRDgSl/5xnG0CM66i
         TuhBSpR+cmCKJsCLaTFBIw2kNLawc95jPNB1Ix8c4TKrZqY8b7bSSVJHaG2bKTs78oHF
         lJrSy573NT/51JxvcUjmyNeukkQQfDgpxnb9s+hjx/TzCeAgd7H+EkmekvNb1+rbq8t1
         aLw3JuFsLxxNzdP4g2KRLZuEGH04H91+dZy3E1zVMnkNhSr05X0ttYDWnxALb4uVto8L
         J0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yoEH61v5vYk3qtzTr+YMeoTPUI9uNoxvpnXmhJ9wC0c=;
        b=HAmvcVVzic1nOFbkMD4kc1uFnl/fpO4aqDH4D2m2ab6XXV8TXxnrdktMVZLo2rbDi2
         bWdZeRqtBm/sLO3BWRjBeDsxmdq81cak62Km3tQBfz/pm7YPvBG2Vkp+zL6P2f4mXjod
         TMt5otsS7shRfYsdWURs/yibS8wr8/hn7nhT6pPJ7NAfvDLP9vwQgoNwXlOjAC5v83z1
         uK/fejDobK0zMAZU8JWVA08tPCAb1+axCWcN2ubLOcXt1WtA19jPS0815aL3L3i7hFhH
         hVOMGIaTH3h+oBkD94VvD+rciI+rUzPbXenEz6dCq2wvPQIw2sqrNC4EBIzTSAddhRM8
         lJnQ==
X-Gm-Message-State: AOAM5329KYQWfykr9/ZShV4vE27+hY7wGFt0N4EvL4eKUO5LEFdHukLz
        s0m56IxqYvJXLIumoHomGKChCmdCN/E=
X-Google-Smtp-Source: ABdhPJx4XNNJAcbMHkDSTfZ4JdpYn+AwhdY/oZcF8o1Xv7tIRcrwni1VyHa5oIyBexL3Uc87ifgdrw==
X-Received: by 2002:aca:59c4:: with SMTP id n187mr5433145oib.11.1634073433107;
        Tue, 12 Oct 2021 14:17:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w20sm1343053otj.23.2021.10.12.14.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:17:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 12 Oct 2021 14:17:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/51] 5.4.153-rc3 review
Message-ID: <20211012211711.GB646065@roeck-us.net>
References: <20211012093344.002301190@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012093344.002301190@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 11:37:04AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
