Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F7641AEC4
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 14:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbhI1MVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 08:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240565AbhI1MUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 08:20:49 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DA6C061575;
        Tue, 28 Sep 2021 05:19:10 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id b192-20020a1c1bc9000000b0030cfaf18864so2596495wmb.4;
        Tue, 28 Sep 2021 05:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y7EsGw0xRIicYnP8V+DBSn9Fl4HBM2CSq7aEwAse8AY=;
        b=KEpxriya3Hrjxs9oo3/sNw4Z/ILUMJAc9DoNGULapbjYZGVNIv05DnZkCM1eT9nSph
         ThWyYVvxpRz4/yVQ2p5JDf/tndOLkhbYtyirUI+FQbx3nE2NxdtKLwOaUX5czP5uDS0y
         TbJXIB6YbHQ6qGOGV3wTG0cOVNVtGmdN1QqnvCtdon8UaM6F4tVWzqMUWzJU8rgLtYNN
         J+4quvrraqH27cZN9QJn278XdjBbf1eOLvm/dZj9qstUo6d+baRnN6xPgn7lMogK+3pd
         Bo5bixsvqflyFDgpDf6Lma9+bwLKHh7TqLv4YDT/zQUjhQP00yPZlJHdvyvbcIAdNDUP
         DhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y7EsGw0xRIicYnP8V+DBSn9Fl4HBM2CSq7aEwAse8AY=;
        b=36VgLhM2QRamywzZS9Q66GVhDsNmmIlK51jMvRVgen4xyk5B+2sD8wq0JHhpolGsvj
         bbAP+3M97dwpGTNcYbHgbnKUIhMAioXr6SA1Dw6ppYzH0ALDtZm440VFSqvqCi5fkYmh
         Hqkl2TZZZievbdukKgaLsRWH9ZchX3lbpMuvoGVOsQt5b9YlhY+B2pPGUrBt0VSf/wPv
         va1xRBElhhQgC2Og5JpZk87oPStq5l8WtuswqRcTAzw3JP510dl5SOfkipunSUbSf4Up
         uZIt+KKAjz0frymOnn+/KbwkOCCsrjE5gIPoyo1ye5b7QY5sG8wtW0fRGaKUy05G7KbA
         DqQw==
X-Gm-Message-State: AOAM533HEjLEmuR41oCLncbN+294LO4S2EVpAJBRL9d3iksmGiPPdo4h
        0jU072vCzjYQrZlQUVlLElM=
X-Google-Smtp-Source: ABdhPJyO9bfA2J2kzp0zhGZ/3u6TR4DoewHjk01bGukI6zkAiZ2o6TvRu/pIDCRmZDW5TkCuWDUmPA==
X-Received: by 2002:a05:600c:4ca2:: with SMTP id g34mr4332059wmp.193.1632831548679;
        Tue, 28 Sep 2021 05:19:08 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id q7sm20792074wrc.55.2021.09.28.05.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 05:19:08 -0700 (PDT)
Date:   Tue, 28 Sep 2021 13:19:06 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/68] 5.4.150-rc1 review
Message-ID: <YVMIOja0mWU2o/DY@debian>
References: <20210927170219.901812470@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 27, 2021 at 07:01:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.150 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20210911): 65 configs -> no failure
arm (gcc version 11.2.1 20210911): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20210911): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/198


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

