Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E43849D4CA
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 23:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiAZWEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 17:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiAZWET (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 17:04:19 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958D2C06161C;
        Wed, 26 Jan 2022 14:04:19 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id p203so2267775oih.10;
        Wed, 26 Jan 2022 14:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nCLt4Lp0eE2sf4ea3rGtIJIHPXsmFpZsxbjnyrthQAw=;
        b=ea7wJ1Kf5wwGECDiTVsJrUXJyHDseZ6N163ra/SjSwHss7yx3OC8c8C7SPJ9vwbxBh
         TkunKXnKo9B/gkXZKz6i6YRkpvHeSAajThQFQjW1L08HP1ZY4h3mk6So6CaBOCRM0L9i
         NM1F+D6J8w1PjQj/OFxudvhP6Td9SmzTx44QJ/9OKzXg2rhHm13UAMIOKtuj2P5o4kG2
         Lx27Cu/bo1mOOgArTYucLU6gKXZUxHZkK+UOwuW3WsAIMYnoFzxuqEUAfmTP19OeWdFY
         t4CRs+nd5nmrFm097A7HozHzV21xJAUrPjyGzslHg3xr/qk56+3mRCYd4D3Oh8MoT+nH
         GqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nCLt4Lp0eE2sf4ea3rGtIJIHPXsmFpZsxbjnyrthQAw=;
        b=6drgUYK94SUj793vAWckd0MhRXvlmObJq3SxMLwQSC6NkE7DasRhBPA+W2rP7viD13
         s6vwAw/9bOToIaOz8mW3smr+z+1E1eM6kI0pGKTglMHQOCHZKwvqEeeQ/x1+HEVcJHi3
         qO1ZJsOwYt0ZJkehvxd5zF47nOeVBhG4yHIBmuhgBLCZLamrTpRzHVqx1hAz4JRiFvdK
         iHh3x9nzxTG0oOCCntWTxbE6+gpiaRw6pjvNmTr0PtP2FYFsM3UqC4QTRY2vSluTgOcM
         /gv3YCAsd/PdevsOb345b7gb6vKYvGeh9NUOxRhFqwQem5HW+F/H7cnm5TArjqZIYKNY
         86rg==
X-Gm-Message-State: AOAM533L6Mn5Uljai8hotKVQpDc1Rd4C5vItRVLZBHuv4jVDPciSzESC
        4DglfPG2W277iSG+kARPAsM=
X-Google-Smtp-Source: ABdhPJyYn8OgR64Gy5a2Tnm/YsQT5Hpq97lsC0b7pi0JMzP+ARSoD5d3Y78/IDBDU2Je28jU050jXw==
X-Received: by 2002:a05:6808:11c6:: with SMTP id p6mr445269oiv.50.1643234659022;
        Wed, 26 Jan 2022 14:04:19 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x16sm7427877otk.0.2022.01.26.14.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:04:18 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 14:04:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chen Wandun <chenwandun@huawei.com>
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Message-ID: <20220126220416.GA3650172@roeck-us.net>
References: <20220125155447.179130255@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155447.179130255@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:33:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1033 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 488 pass: 481 fail: 7
Failed tests:
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:mem256:net,nic:net,nic:imx6ul-14x14-evk:initrd
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:sd:mem256:net,nic:net,nic:imx6ul-14x14-evk:rootfs
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:usb0:mem256:net,nic:net,nic:imx6ul-14x14-evk:rootfs
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:usb1:mem256:net,nic:net,nic:imx6ul-14x14-evk:rootfs
	arm:mcimx7d-sabre:imx_v6_v7_defconfig:nodrm:mem256:net,nic:imx7d-sdb:initrd
	arm:mcimx7d-sabre:imx_v6_v7_defconfig:nodrm:usb1:mem256:net,nic:imx7d-sdb:rootfs
	arm:mcimx7d-sabre:imx_v6_v7_defconfig:nodrm:sd:mem256:net,nic:imx7d-sdb:rootfs

As reported separately, the failures are due to

Chen Wandun <chenwandun@huawei.com>
    mm/page_isolation: unset migratetype directly for non Buddy page

and reverting this patch fixes the problem. The problem is also seen
in the mainline kernel.

Guenter
