Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973C9424B40
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhJGApd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhJGApa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:45:30 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B772C061746;
        Wed,  6 Oct 2021 17:43:38 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id k11-20020a4abd8b000000b002b5c622a4ddso1405569oop.1;
        Wed, 06 Oct 2021 17:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f5pDhW+JKiv9X1sr1KO1MEidqfalvZ+8ofkaZ+lxdSQ=;
        b=aiZT+umFaDI50elvDZZCT/kfJBb0B6WKPopsGUDYk+sJQ583ud99MFu7ES0ox13L5z
         +cxakIcNxRVl5yenAjcTj1TaRJ5XwQUUtwCrqdaZMzj2GOeloA35g5EmYkwp/7LlL2Be
         DFddaBljRVDxK8OYf9sayXajGo3ijIogPrc/0GOq0SL9wXSW56QRqAsbN/vE5mRCcQ+f
         LETesD/54xWbZa1+kz+dizEWsS3fnwbv3gPH3Gm4N6uDeTJ2D15+EhJ/eTnXczpnPhxc
         mgOd3l3N05yR5wj2ovkxOGqll48Tu6h1PNRyqsZOVdR369ii3Cru1Zwt58itNsFfRx6Z
         bTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=f5pDhW+JKiv9X1sr1KO1MEidqfalvZ+8ofkaZ+lxdSQ=;
        b=OEc/R8leeBE51b+eJJ0C06WwCAJIxqoTeEfy4lLDD3caKa6jAaSlWP779c6RPDG5jH
         tBJizHdxrCCyCB9IhqEkNSYJEwhQFR9hvfx7SPXwXeltaM9iOH2b5CFbPyFvebXpsXTX
         EAJI79rs1S0j5Cu2svo43RMJy2wJgCOAEMH9Wvw4RmBZ4L6AfkdefumohSVuZV7GJwc6
         D+BAWlohZbHUVuZ3jPSB9SLWoMIS8/LKnguZUh2nh/QwtOLkjXrSoasgSe8Pnxz+ihcb
         ZrluwvnedNCRK7CgteN3OO1E7wxXeL4ccKNNXqfZY2PeymSLMyxLwCRDZEss0dMytLtL
         NMSg==
X-Gm-Message-State: AOAM533i0I984T15QloZW7O1j9BYvfV0EFH3/+GHvKk2DVOXHcTM0l3S
        3uudpExgMxWOXnjvyAkUmfN4NATqsKg=
X-Google-Smtp-Source: ABdhPJxJffVOqMSEki450tqZmMAMumS4LZmQ54aCGJbKAX3nv4TRGgN+UvIJFoFIenRieQHzs/LOjQ==
X-Received: by 2002:a05:6820:1504:: with SMTP id ay4mr1157537oob.34.1633567417629;
        Wed, 06 Oct 2021 17:43:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e2sm4311751ooa.20.2021.10.06.17.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 17:43:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Oct 2021 17:43:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/92] 5.10.71-rc2 review
Message-ID: <20211007004335.GF650309@roeck-us.net>
References: <20211005083301.812942169@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083301.812942169@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 10:38:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
