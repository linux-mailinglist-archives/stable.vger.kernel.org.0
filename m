Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660DA403220
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 03:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343877AbhIHBVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 21:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhIHBVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 21:21:09 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8915AC061575;
        Tue,  7 Sep 2021 18:20:02 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id bd1so970805oib.5;
        Tue, 07 Sep 2021 18:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U7TBQSlIL7vcOCE/9w+SqhfBtGngNAyhsDDw9xnD47M=;
        b=bR2a0qiTjfuk70NSLZoOvmT5teJchYpxU611B6gJBIvgqgnJWHsiURifCHl/r0z5FS
         L6DUv0weFvW/c9RlrB61hJ8zFPBaJINnzXg0VA7JRjHSpme2wzntkTxtJg79s3us/YEX
         nS/BL3R/qQBl/klrsSQd3E6jhoiVNqfjq/XDT0OctGPfMdpk/dtpmDAq+bxqS5FP7Zpp
         g07DHGpi5j1U2qHyP9uTz5IpDmplVXRtp/grZEMhorA6+oNMN2npO5uGCKva8jpE9RaU
         9mgVGlezdqSY9I8DPM+4I9G0ilfswLuANX5XOrmij6N2Jstd+Vfz6U3t8ONMqraqld1s
         9SBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=U7TBQSlIL7vcOCE/9w+SqhfBtGngNAyhsDDw9xnD47M=;
        b=qmyZ7QU0V6lut6fBJtEdc8VFAhVSW6VnN4JtjyCNVwcaIToJcACs8omhgP4MEHrPmu
         lwiTM/mzPmLUaTdPfCzpb1MizZvvXTAfLpegUlYGlp1CRkIhD5tv8Jgz4zx+YgZtlnT2
         bR4BGNb3pXwVht6baLsBkChDU3495JvoGvOKyIa2GCalsxNrchgPAn0i0sb1Z9IQOHu5
         m3nzE25aGfFlgcAB34PiUj2LvxZ9hsTKTcKLVLvQ5PHIV22AbzbXe+uLotHLTxaAFXdY
         Z9/BGngv30B+UJ17CUR9ot0NpMINuzMCpj/mQo+3BMtAoCZSjVAyT8E30bzgyiqMZfSX
         LuRA==
X-Gm-Message-State: AOAM530ljXPyhfqpgO9giE+83/+puJyYnbY0agTeLdLLU6k0me7WZkAs
        UKryrLp0BryxxX/nIzNGaUY=
X-Google-Smtp-Source: ABdhPJyYg/+aSztoJv5woEg9317wvMEbpe9bgA1xLt729/KmxqCNc76K2bLm8CtcYtbAuza9HaNpJA==
X-Received: by 2002:a05:6808:220c:: with SMTP id bd12mr745557oib.13.1631064001938;
        Tue, 07 Sep 2021 18:20:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j17sm144070ots.10.2021.09.07.18.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 18:20:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Sep 2021 18:20:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 00/24] 5.13.15-rc1 review
Message-ID: <20210908012000.GB2310006@roeck-us.net>
References: <20210906125449.112564040@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 02:55:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.15 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 464 pass: 464 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
