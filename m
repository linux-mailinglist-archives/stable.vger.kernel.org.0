Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CAD47C98D
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 00:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhLUXNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 18:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbhLUXNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 18:13:55 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14780C061574;
        Tue, 21 Dec 2021 15:13:55 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id t9-20020a4a8589000000b002c5c4d19723so219928ooh.11;
        Tue, 21 Dec 2021 15:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lv311zx/9bDDtbni/Ncz0Gv3KysVn7r9/WQpnLkSIuw=;
        b=JUsXKqfX0dBypcns4dypiKBAh+Ncfach4jc0tMYPgYb/6uCXW1A9yzbBSKI2UF8GwC
         Vb1CXOn0Zgiy0e7kX9GJ76vkJIn+1/qxmlMQ89TdV8xh9FgsEP9rGYqaCI3g8coT8GDk
         BQMgsMQBLzC6l06So899MtLCWkHGFFhooum+2uIA81aCCH1cBboOpEpC6sAuC2LVeD70
         6fMaz9uL13m5t1es133VEUfKNNKvwkEUg4jnarZAMtTAEzKo7R2iOusrpz2iY42f/hCN
         JvzchgakvUyFh6kM3JSBvA7AWNLlOwFBWocJbvY4Xy9NZxa//7cBoHvhTn1IcUgIMLHa
         2ytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lv311zx/9bDDtbni/Ncz0Gv3KysVn7r9/WQpnLkSIuw=;
        b=CtYsy2c0tb7/kc3enUQtCXOjszjQAd/o5DA2j8fGNjqZAF0KKJE1/QaABZioXX3lMz
         8e8xp4gX1lUSy7Y7PCJJ2CxJbALFHpC7Ph1WZ/A4hwjg2uisvaoj5b5NKCB6KTm4s00d
         oUco7Tfnlf0tGR43lOcmY1Hze6PB8sHgpZXy9GX/cv+LzC01YhBl8Wi2TIoTHIYx+I3j
         9KkX3KW4/fjLxDPRqXAlDMCangfcX8OaUZMOpKojZ35KNzBrmYSECxuWBddwjP6XCfWF
         P7O83e0+nZx+zcCSiOIsvOV7S7AEjtSIb/IodHXxcaYnJMzwmD6U00P0Vm+bnkVzwHyP
         HR7w==
X-Gm-Message-State: AOAM532wSGyoIww3JhGP4ONJDZpVZ9KRe8zugFWN2wt1ik7oAvJROA5M
        2HDDw5CZxsNVP7+3IdgPwnA=
X-Google-Smtp-Source: ABdhPJwAdgySLa8erYBB3QQF3oEKazkNrDMxB2/tAuT9nmQ5RAtC5PWh/47cs5WOfx1oCoQKbljJCA==
X-Received: by 2002:a4a:ba86:: with SMTP id d6mr340053oop.87.1640128434399;
        Tue, 21 Dec 2021 15:13:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l24sm75656oou.20.2021.12.21.15.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:13:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Dec 2021 15:13:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/99] 5.10.88-rc1 review
Message-ID: <20211221231352.GF2536230@roeck-us.net>
References: <20211220143029.352940568@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 03:33:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.88 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
