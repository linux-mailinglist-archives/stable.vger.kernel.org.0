Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8754839D0
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiADB3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiADB3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 20:29:49 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC98C061761;
        Mon,  3 Jan 2022 17:29:49 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id n3-20020a4a3443000000b002dad63979b8so9918466oof.4;
        Mon, 03 Jan 2022 17:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xEK4+dgSPjeAGAcC4alW9aACgp9j7AmDDVgtvg6eYDA=;
        b=bPA+o2UTK0NyUv2ViwxPgXNFs4sH/TUCFp+T1Ir25zOS9BtRb2Ppaloqboa6xeKo1t
         2S2TAaFsUj2W6y+7F0B12/8eLvEA+Q+aiQ0Os3SbtDpFAtfcE1rFF+BM5cfBOpa8sMXM
         Dt+3RgWFrbZ511QMU3/Kyta40IoPfO4k1qm3Vq2v8blyEbxx9Cl1gUU6W2StSM9VcWSD
         rVsuR900yiJJzCwf/+qN0N/ZbE3xaogFjcqliYiDBXtE6skBLQ7RI5T+64KATnwletWu
         djwCx7N04e5zQIjOOWDvF2MRXYpKaNBt4cZw4a+Juc83ZmPZtHw0PWjAn9UMo/ztpTjc
         FMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xEK4+dgSPjeAGAcC4alW9aACgp9j7AmDDVgtvg6eYDA=;
        b=MMp6B1IeAzglDCoSAc2CBR9kVNPk/ZLW03HFrXVYsC9z4yfSMbpvzgaQGC6TQZMgr1
         lZ+WJMI78CAnDoFalNle3A21soZTNPIZG/dig0ii+4HTN5VtZUqWUjuno+XYCzGZ6EYd
         35Vf+vVdlL2JW5WjcW1oZhWQaclllCMQ9F9eu9gDyKX/2+J3tDHsztGYlf+EoMwJtEdG
         0ao96xJk8I7pyRDLsjuxHz4FRyk9+MTV/3TJ1QnI811Cfmq7SnPCksX/my+We55zR7Qv
         nMLzqlpOWpKyiuvzd8QvReNHZWRucWtFsGNqDNsuVckTJVEH3ttZk3tiEEzilwTFoGwi
         hQHQ==
X-Gm-Message-State: AOAM5332FT54+EKAGJDZj6HHgEF+hRlKCJkSFWwHIFauHQUR9W2ZN6u+
        RZtyvdddnKPVsBhvNoeplsU=
X-Google-Smtp-Source: ABdhPJym5Ioc2J8CyEfSLX8l63JBZZbFJmJlmdJbX3Qf/J2cvelRxAvR2PPgsCEbYeawcUonXX7zNA==
X-Received: by 2002:a4a:3bd4:: with SMTP id s203mr30363308oos.18.1641259788898;
        Mon, 03 Jan 2022 17:29:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j99sm7581086otj.15.2022.01.03.17.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:29:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Jan 2022 17:29:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/11] 4.4.298-rc1 review
Message-ID: <20220104012947.GG1572562@roeck-us.net>
References: <20220103142050.763904028@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142050.763904028@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 03:21:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.298 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
