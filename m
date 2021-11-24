Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0440845C912
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 16:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344608AbhKXPqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 10:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242137AbhKXPqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 10:46:36 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C822C061574;
        Wed, 24 Nov 2021 07:43:27 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso4974141otf.0;
        Wed, 24 Nov 2021 07:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YVXO4fbRTlfWYLu6eRVmnfdhw5giw8T/JxOheQthiDA=;
        b=qIgTyuD4rTnRMqMYVFA/p9eYwrWCkG8Gzq1F97UBZjq7vyJtj3eAqZkF8uj3Y7Qopm
         zC2aTk3LA7oiP9AKYKNOI3JGDkPxaf4XUG9dCV5xlA28txygC3w4SWyaltwsk5IPKOJd
         eTgxv9DantbcWhp+SuzibcDVUzKfZY5zoVwvigAa6ObDAebnGpZQQWSyC65oWt0YUYZk
         0r5geqDIFdBDoAYsB0JnA2w33+dmlklcLdgf11tCTG6QoEUrb/RYp9JEbgoG/2fwxWul
         7ewOUhZMNoD1MOB/l8g65XyoDLvtDqu5Gx5F0iu8wfUIWiwCF84lVLvcpy770vrBH9iv
         0nNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=YVXO4fbRTlfWYLu6eRVmnfdhw5giw8T/JxOheQthiDA=;
        b=K/4RKeNM7fqRmJR1spUbQTrEZL+vAL/e2lHCo/9A5PUDVi4IwxaoN7ys4A3pi8FQc/
         QGW4pZ0dseZMV6KjfobI6ZexnBmaQaJh4AWVnlq1K729M5lBa8yFpWJZqjprNLddIyZY
         xcofcWRXM59NdbyYWgHjKb2ZMewTIoCJWxwUxie33Ox/W2nbzpgM9ZJe+4/aHmOP2R6o
         IwyWEGnoh014ywt7mxL/VnXTrQ4E8UxsLp/U2c+Ul+NxpsTRE1s1hhjVCn4wEcl0pKW0
         cy5R9F4m6MdiGi8Qqhac0tFneUdLpTDKdwpcu5ANogHfxShTMoxMxPKzfTCStjdcOBGV
         tFXQ==
X-Gm-Message-State: AOAM5301TtzbMMuprlgJ7Cnp2SwZUenMYADCSoBKJysPvJ2/rwqDhEnG
        USDp85NpSnVBrLoXVN0EBlY=
X-Google-Smtp-Source: ABdhPJyE4wZqTFIH4aAd8nUeoeQQrklevDPyeYTbDk2vQAmEmh/E/atGULT7kqC5++kemSudnhI2HA==
X-Received: by 2002:a05:6830:118a:: with SMTP id u10mr13949738otq.194.1637768606609;
        Wed, 24 Nov 2021 07:43:26 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2sm37178oic.35.2021.11.24.07.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 07:43:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 07:43:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/207] 4.9.291-rc1 review
Message-ID: <20211124154324.GC1854532@roeck-us.net>
References: <20211124115703.941380739@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:54:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

sh:dreamcast_defconfig:

mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3415:25: error: implicit declaration of function 'tlb_flush_pmd_range'

Guenter
