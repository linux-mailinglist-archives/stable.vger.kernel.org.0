Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99283421C89
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 04:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhJECWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 22:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhJECWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 22:22:03 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0557BC061745;
        Mon,  4 Oct 2021 19:20:14 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so24100285otb.1;
        Mon, 04 Oct 2021 19:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W9F9XvQYc2sk6rM6fAFTyrb+hU92djBBrnaDeNOEzcA=;
        b=mSCoV3FqJrx3oSQi2QOe6pdEmSXOAZ+Ff5IQIJV3m3XY4hH0ia9H4HCQu6MnxVOvlj
         ZI4dE/M2nmb2ZUcjYmgLBDN9IRx3iHnSeBh0dlPdUg6syqMG4TP4v0bUbxt4ubHcfOl/
         E4aqVR+M6wCYK03vni8edwLWlPy9O8nAzFRQDetLId8YJVADh3MvsR7LFPR4BNa47XXs
         O0gyEaZ7lSZ2MhAP6dicK6uOdB9BOm6ldXkXxfzBJ1WG8wasboVaeJxwY6AFjP1Kaf4/
         vIVofVuLp/9ah8gtm4m1LwcCILDXuw7pI8cjrMxvHHWvskJsVyTsEq+kDC7mE9J89sRa
         ygZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=W9F9XvQYc2sk6rM6fAFTyrb+hU92djBBrnaDeNOEzcA=;
        b=dMucpgfesGd8cYw3EVUtkjHno6a+d2JfQB3S02aG41PYckmbq7W48cwJQgxGG5oK78
         PrX4WMDRxzFFfNVQatK1lo2bLUix3QNs1cLGuFxuhTY5jk6Lu7Q24oniSdtx8f6f0OBq
         xF0jklFf0Ww/ppxRebKKhADQI76lIa2CyQEcWtb7tudW0iowjeuSXpCUEkLqmYmLRRxb
         z5HvvHFJmTQtNwws03Jm6PWuIMUiiHic6MPXN+/LMRMZ+WonGpylXMBID23JCgefLm5A
         b53iz5tuTqMhHqlPLNpy6idHZbSpoN/BaqZzooxCqQww3CubNoDe6xd34Nv0hmB6cfIA
         XW9w==
X-Gm-Message-State: AOAM5338QkQBqMm56thwc6fu/KcamoqMOosH5Mzcs4hf5iciXUQdL33R
        BRPR89wUJE9mgdXZRP81keBOV+HGizY=
X-Google-Smtp-Source: ABdhPJw831OeHClHxNWwkORBwAOYwRFtXCoArt1bbBuVRfyc7XfER8UQ8jx0z5hbvs3f/IpUMRgLbQ==
X-Received: by 2002:a9d:75c2:: with SMTP id c2mr12353818otl.230.1633400413435;
        Mon, 04 Oct 2021 19:20:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h1sm3361328otm.45.2021.10.04.19.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 19:20:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 4 Oct 2021 19:20:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc1 review
Message-ID: <20211005022011.GF1388923@roeck-us.net>
References: <20211004125044.945314266@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 02:50:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
