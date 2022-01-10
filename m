Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1483748A3EB
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbiAJXtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243045AbiAJXtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 18:49:07 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB2EC06173F;
        Mon, 10 Jan 2022 15:49:07 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id o3-20020a9d4043000000b0058f31f4312fso16901046oti.1;
        Mon, 10 Jan 2022 15:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pLTZV79naRuW+/BdBafAYHyvtDhBnSiQhctUgd5ZWcY=;
        b=DMoYepuJYPUV14ksuLVnkqAkh9g4K6K3XK3wao1AGDVkh7BZUxtvMcjR2VyGX4MxFI
         tDjqBxNrTAd3AxrJ0m5/RMftJzF3JYVWdNW8SSWLE6Et1wZP/D/f04L4KczvQqthlZre
         uColGqmnzWPEsY44G/8deiyhab/0ZHzuNft6KUZGCpYvyNgdqL6QG4P9NpRISmttVqQ2
         Y+UL1LgsaGlPtdEJnfYw1OxYF5f4vGbHEE1GswVRGf4a73Cv/Ph/qT+xz4C/jj9hGZMx
         o2bpVliKTmLm/DI61ZcnVHH5hpARpl7OR2G4CbO17LlbSk1NRjHuiywZt0AxmqmkvhZq
         KCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=pLTZV79naRuW+/BdBafAYHyvtDhBnSiQhctUgd5ZWcY=;
        b=w4heJAaAvtxO4C+K23J0aampcbqRNX9CnjLg4KPP4nAARNvoVJw75cgWSmojsI0OLI
         QC2XO/aJlAWDdLPoq+kBPmDWF70efPM8S0d6CDTLntKm/vNDNFYJAta+TjJXTXGmrpid
         7ZMcKB1wJhgtQa0dnxTj0lR5kCUJBZcHA7Odi6BhI5/lwAs23+fvcsS/EyivIUen3WtK
         dg0m7z/BqDszwZ7nFgWdsBBh3r0YP58ADxxIhCTVZ+vJAgyn9gXC1t8vK664kTDK/ABy
         uYm8hcy8Zr2Qv8ukf97A1PL2fjU/aNv3ueOISudPlwefeFQ2TZAgZc53p3FWQJKzQhjU
         7o8g==
X-Gm-Message-State: AOAM533gZy1pKH3oWAabJ9dDrYE0pFtHqPDkLYvG48TrBes8IsVqyzs8
        I3tZarIcf9PKL+6bc/0WmuA=
X-Google-Smtp-Source: ABdhPJySdnbO9DjTnBXGCT5YpzfOWsy6fiju7/OgURNS4vTHRrQvoNqmZ/2Yy17SwrYzGDwIeAVkcg==
X-Received: by 2002:a9d:de5:: with SMTP id 92mr1683328ots.217.1641858546666;
        Mon, 10 Jan 2022 15:49:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j13sm1408877oil.42.2022.01.10.15.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:49:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 Jan 2022 15:49:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/22] 4.14.262-rc1 review
Message-ID: <20220110234904.GC1633615@roeck-us.net>
References: <20220110071814.261471354@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071814.261471354@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 08:22:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.262 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
