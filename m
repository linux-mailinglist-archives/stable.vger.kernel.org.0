Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE192513CA
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 10:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHYID0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 04:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgHYIDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 04:03:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AEB32065F;
        Tue, 25 Aug 2020 08:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598342604;
        bh=qPHOpUVg5lYKFkIZ3ZCBYs3jVSUWzeEfRbkF5eSCCkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wk/xwLGmmyP0J6RCaiPuQFmv0erGU8LjLAnUpJ8SlyNz4ogfUVrx/kPx83eyPwGRg
         GyAr3ge4IvgjNRP6LtOFtrWiCE211SPAI1Gi1E1FA4Jf5meRVbn19+HXnhnYGQBnrY
         DoOmrE7QA1jLCgXL76YAZEa9c59+iLFgHqKPltL8=
Date:   Tue, 25 Aug 2020 10:03:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zhenwenjin@gmail.com, sernia.zhou@foxmail.com,
        yanfei.li@ingenic.com, rick.tyliu@ingenic.com,
        aric.pzqi@ingenic.com, dongsheng.qiu@ingenic.com, krzk@kernel.org,
        hns@goldelico.com, ebiederm@xmission.com, paul@crapouillou.net
Subject: Re: [PATCH 1/1] MIPS: CI20: Update defconfig for EFUSE.
Message-ID: <20200825080341.GA1332886@kroah.com>
References: <20200825075239.17133-1-zhouyanjie@wanyeetech.com>
 <20200825075239.17133-2-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200825075239.17133-2-zhouyanjie@wanyeetech.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 03:52:39PM +0800, 周琰杰 (Zhou Yanjie) wrote:
> The commit 19c968222934 ("MIPS: DTS: CI20: make DM9000 Ethernet
> controller use NVMEM to find the default MAC address") add EFUSE
> node for DM9000 in CI20, however, the EFUSE driver is not selected,
> which will cause the DM9000 to fail to read the MAC address from
> EFUSE, causing the following issue:
> 
> [FAILED] Failed to start Raise network interfaces.
> 
> Fix this problem by select CONFIG_JZ4780_EFUSE by default in the
> ci20_defconfig.
> 
> Fixes: 19c968222934 ("MIPS: DTS: CI20: make DM9000 Ethernet
> controller use NVMEM to find the default MAC address").
> 
> Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
> ---
>  arch/mips/configs/ci20_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/mips/configs/ci20_defconfig b/arch/mips/configs/ci20_defconfig
> index 0a46199fdc3f..050ee6a17e11 100644
> --- a/arch/mips/configs/ci20_defconfig
> +++ b/arch/mips/configs/ci20_defconfig
> @@ -131,6 +131,7 @@ CONFIG_MEMORY=y
>  CONFIG_JZ4780_NEMC=y
>  CONFIG_PWM=y
>  CONFIG_PWM_JZ4740=m
> +CONFIG_JZ4780_EFUSE=y
>  CONFIG_EXT4_FS=y
>  # CONFIG_DNOTIFY is not set
>  CONFIG_PROC_KCORE=y
> -- 
> 2.11.0
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
