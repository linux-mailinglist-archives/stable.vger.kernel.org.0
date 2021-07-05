Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3C73BC36A
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 22:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhGEUlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 16:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGEUlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 16:41:02 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E476DC061574;
        Mon,  5 Jul 2021 13:38:24 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id m3so3091831oig.10;
        Mon, 05 Jul 2021 13:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jw1GtltodhVAdhPKWd2J6k3sMwDii/4fiGgKkOL7knM=;
        b=QHBDLz7RvFTKy+rxS7oowyuwdPrZP2+j0PiTPi/j0N2bQRGt2qLqmnjU7ux92cTyCn
         0h3+fKvRIMZtxBa9wBAYQ3BZvWwXDuwumLwjk93zIT42uiiCJguV7utmtiltxHpol8fF
         H2YINgOZQcaEgGiIpSYWc9FUveZM7hICBLKxSILbd1XWLyggg4Vm+UZ4go3elrmt9ibB
         LoSr157xWgShdeShSXTxq/VklpstLQ05JmwqJvjVnufJ8cc9QrL7D4K48Gy4EbKtr3Eg
         DmSDtFq5Wt/EUxD3YluOBnMzPRDDeYBtP+pJEleQPDOIxeHAOtzaifLfe9AjLKEHt+nM
         J1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jw1GtltodhVAdhPKWd2J6k3sMwDii/4fiGgKkOL7knM=;
        b=T4EknuxWzUiZBHxsJOVxORm5wa6q5FkYA5Rozkx57444/TWa5zyUDXekJaMN+edhY7
         212oiCZiFbyjT06O34G09480Yx3i77D53czwiaoMUGwf/KUrgTI1MHyJ8ltDOflfh5K7
         18SvhQARXKLWmfdUpWw+re8JnCXvmp7v79e7HSHjJuPrNTVKugFFcVJPqaRRTyeNkYmD
         rBvp36HsvYCLvcK96BgWC82s13hU6RDHGWiqbfz6Tzrb//H2JVRANcM4yOvhekffPMTF
         pPLg4Oq9sF7MB9rC5wWagm/X1uRgHT+o2OBBxpWfIa5vYQhL4sKyOL9tKi7U9Fqfy6+D
         iXTA==
X-Gm-Message-State: AOAM5339VQ6q8B9oHfgSRBTm6MzHxxfbmb01jv3R1MgF2wxJijxh1NcH
        WGGX1dZfi4vm9d/Y3t/z4jQ=
X-Google-Smtp-Source: ABdhPJxZJndyI6hwG9GifPViQMnvd55mAK/KH+aGTGmPAGW56L+YqNTLZfcLEr6nvmW2CWXxs7igbw==
X-Received: by 2002:aca:5c83:: with SMTP id q125mr711412oib.145.1625517504400;
        Mon, 05 Jul 2021 13:38:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f3sm2933676otc.49.2021.07.05.13.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 13:38:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Jul 2021 13:38:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.4 0/6] 5.4.130-rc1 review
Message-ID: <20210705203822.GA3118687@roeck-us.net>
References: <20210705110029.1513384-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705110029.1513384-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 07:00:23AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.130 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 11:00:14 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
