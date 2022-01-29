Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E147D4A2ADC
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 02:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351970AbiA2BGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 20:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351969AbiA2BGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 20:06:33 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131F3C061714;
        Fri, 28 Jan 2022 17:06:33 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id q8so1121369oiw.7;
        Fri, 28 Jan 2022 17:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FTzyIcvk8nRPgnITJqzoXwuRwhNp+Tb8SXIaISvWsWg=;
        b=h+Hgfa7p7y1/3sNNkE3o2nUGJWA5Ij962vmPGrGwWuN8Q+veqcOhjehgmyE4BCrlXS
         DN7FcIYvRMVJyTl5R+vRHRihRXysJqQIrDWkuk8vEru8iDtpz8/Y88gcGEzPNprDp18e
         5zagb7xTF5MHMhT2i9VScS/ZksRtlv0M98b8ECI7QdIVZn1IzZXDsZEK31T6FSQ+YKL6
         HbbDxFYpW/Z6gNFlhAE3OSBtY4VOUKXBReWmA8v/J9PA17l6vYFQMoVESNsIs5ILVRPU
         5RHVDV+E12zDpvItwS88WuUdGVJBHiCwBN27BfYL6alVaPZezKp1UQGD14HGhymNhaGx
         szyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FTzyIcvk8nRPgnITJqzoXwuRwhNp+Tb8SXIaISvWsWg=;
        b=xraGoS1GUGFTp9G6UC8aJxVrhpIfh6y0mR9+O/zcpLl7Sfyc4Tfv/5fGG64RPSpYRi
         bkJqJpaEjMQOKZqEtNedDO/duh2fgVP2QEhPUPMHf9eSGdqOi1b1BNv5lB3P843xLfK7
         yRAcK3sDkY0fMP/Hmo2thex+R4MEItPJynXgdqn+K9aoR2PVUb08uudbMv3mjecE2wN/
         x1ne1y3KMAvhAHyVUcomLuTbJ6VlptW+aoI0ELbT8dNP8PZnkLVSzVR472mKxctJy3Xa
         2EmnKKVH0AHVpUzTjosoJAkYoj8BUBnNdpkZ0kaev0H4xcCBKqIg7Yu226s101eGp7ts
         O8Xw==
X-Gm-Message-State: AOAM532dy8v1+FOPbpZglIGmRZUCDzwgnV0Ww8mHqMwBkPssUNqiGozb
        1XoMVWvMRyuCTI2MiOMNUsk=
X-Google-Smtp-Source: ABdhPJw5HIHEYw7AOMbMa+FlaxshKoBrKKQZuJUp/oyciyD7vdHRL4tNWTikof+ZvRun78f2bj0CGQ==
X-Received: by 2002:a05:6808:1443:: with SMTP id x3mr10843954oiv.33.1643418392474;
        Fri, 28 Jan 2022 17:06:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d65sm6542450otb.17.2022.01.28.17.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 17:06:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Jan 2022 17:06:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.10 0/6] 5.10.95-rc1 review
Message-ID: <20220129010630.GE732042@roeck-us.net>
References: <20220127180258.131170405@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 07:09:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.95 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
