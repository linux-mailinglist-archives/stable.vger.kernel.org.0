Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5743BA82
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 21:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhJZTSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 15:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238609AbhJZTSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 15:18:49 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7A4C061570;
        Tue, 26 Oct 2021 12:16:25 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 107-20020a9d0a74000000b00553bfb53348so215885otg.0;
        Tue, 26 Oct 2021 12:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1b2e5yKTRaNPPQy9Tgfi1r3LjEflH9QgtdhAc1tHJZs=;
        b=q6w6a30nUlpJhbgzOghThh9Ou/rMFYpxCl59eM/Aha483q7vQsWLIW+O+ke2iImYKA
         3+45p/84q0pSr39EfzHpalLtGR+xQ4yPKR1c61ke4caDa4+pxJD5JwJuYU3FQzxqwzsL
         WRutLTe8o9C1X/lpBJDXdP+XEEZjsAQ1ZAc62hSsO0ocpBo+Hyw+IAo198ac4VMUgrm7
         QTbDfbw6a8MuRSnX+DCRiLBaZa3mEldWbMAvlcnxXtmdp2ZRmBGLRkM/NUUh82ngOx/F
         KroQxQFea4uW1Rh1yePZv7tYP/IRmzBOrKf0l6Yixan+H+nyKCWnewX4ieUbB5slJ7F0
         JftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1b2e5yKTRaNPPQy9Tgfi1r3LjEflH9QgtdhAc1tHJZs=;
        b=XMTvsQkAc2s9WuSAQiVw5a6Y+BzLyby3C3LYCmM7KF8Y/F2bE+yOEIFRidf1YVzQEN
         0ZruYuKoCQt9qtS9tth3gLqYhCTb2v/8Rg/aCxse6yDOFI3jqaDopc1qzjtiOe1TF5Os
         J6tAxdcUb0oA2eE/liPVTSapNn97PpbZdXQXU46AFQtOSW1E0xQo39tBAfL0WKCUJVZ+
         k2jP0kbbknyIB/KZv99zLimuc1uMP3kf6Dj7BJkbZ/ALV8lSrLk52vI7dCso6C1iIPbs
         xWoQEt+IOrQOt9KjP5vANfXz2a5ejK/OGMPcMtpyZi1JlQj2c+2i8y9Vji9OXKwq4e4J
         c/rg==
X-Gm-Message-State: AOAM530tEBTdyZniQSC5yGK8DUcChCoKfGwb8ljCkfh2MB9QdNsjDbgb
        mtIm1IeE85FH+Q1mSsKrVAs=
X-Google-Smtp-Source: ABdhPJzawfz+4rFRtQKmy1MrBtdbFdWtEKoEhGNEoG/JJ1eGDS08i7KRnyafqTIkh4OyUVgJ9yRzdw==
X-Received: by 2002:a9d:220c:: with SMTP id o12mr21495093ota.250.1635275785336;
        Tue, 26 Oct 2021 12:16:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e25sm3985254oot.38.2021.10.26.12.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:16:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 12:16:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/95] 5.10.76-rc1 review
Message-ID: <20211026191623.GE2014125@roeck-us.net>
References: <20211025190956.374447057@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 09:13:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.76 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
