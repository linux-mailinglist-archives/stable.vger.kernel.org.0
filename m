Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D6645046A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhKOMaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 07:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhKOMaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 07:30:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF8E660E75;
        Mon, 15 Nov 2021 12:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636979237;
        bh=F5xgtFrJKjVfMvCfA7QcAJ4dsZ16s3LT8k5CKGr/1PI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o1L9ZjDhBQk84fpotogO9VX6NQUvApXx8FP5J3ngm4nD0JAZDlls92/d76XlH4b0/
         9947OrVg1rGXZLqUwWmLj04FDD5L9RLt6nelgnExl6/iA6WdLEGyzp4+q4OfYuhxYa
         h7kImsHey1PTyj8c9k1w9YIkklxJllGA1aUaz6+k=
Date:   Mon, 15 Nov 2021 13:27:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Peter Geis <pgwipeout@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [stable-rc queue/5/15 ]: rk3568-evb1-v10.dts:10:10: fatal error:
 rk3568.dtsi: No such file or directory
Message-ID: <YZJSIvb3JF6dIsgx@kroah.com>
References: <CA+G9fYsZ_Zks32WTNgKjQg2gwRuqS4E92ttH+okUCdnPFdaNTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsZ_Zks32WTNgKjQg2gwRuqS4E92ttH+okUCdnPFdaNTQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 12:25:50PM +0530, Naresh Kamboju wrote:
> Following build warnings/ errors noticed on Linux stable-rc queue/5.15 branch.
> with gcc-11 for arm64 architecture.
> 
> arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
> (pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
> configuration space
> arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
> (pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
> configuration space
> arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
> (pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
> configuration space
> arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
> (pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
> configuration space
> arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts:10:10: fatal error:
> rk3568.dtsi: No such file or directory
>    10 | #include rk3568.dtsi
>       |          ^~~~~~~~~~~~~
> compilation terminated.
> make[3]: *** [scripts/Makefile.lib:358:
> arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dtb] Error 1
> 
> The first bad commit:
> --------
> arm64: dts: rockchip: move rk3568 dtsi to rk356x dtsi
> [ Upstream commit 4e50d2173b67115a5574f4f4ce64ec9c5d9c136e ]
> 
> In preparation for separating the rk3568 and rk3566 device trees, move
> the base rk3568 dtsi to rk356x dtsi.
> This will allow us to strip out the rk3568 specific nodes.
> 
> Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> Link: https://lore.kernel.org/r/20210710151034.32857-2-pgwipeout@gmail.com
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org
> 
> 
> 
> Build config:
> https://builds.tuxbuild.com/20wHY13986hVAE9j4Kwxq4C8JUX/config
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Now dropped, thanks.

greg k-h
