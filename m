Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228B12AB81A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 13:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgKIMWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbgKIMWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:22:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93B44206CB;
        Mon,  9 Nov 2020 12:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604924551;
        bh=0oCpeoAK9GPbfiO+MZlHfj2qaTYiN2YNK9AtpkIx94A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rQx2idZW0wp3AQilK74LnUTym49o2kGAbGWKPm9AGuMvf4jPUIbBg5UHHBkdjw3n9
         RdeT9nWoHLyPjq/NifihDxHT4Upj0pWbwh32AfLpdPc1L7CwosH30FEWouJ7PLZriq
         yX37iktDIS1kkWoNOt1gENDQDdi57Hpn/6as7WQY=
Date:   Mon, 9 Nov 2020 13:23:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, a.heider@gmail.com, andrew@lunn.ch,
        gregory.clement@bootlin.com
Subject: Re: [PATCH] arm64: dts: marvell: espressobin: Add ethernet switch
 aliases
Message-ID: <20201109122330.GA1834954@kroah.com>
References: <20201104115209.1282-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104115209.1282-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 12:52:09PM +0100, Pali Rohár wrote:
> commit b64d814257b027e29a474bcd660f6372490138c7 upstream.
> 
> Espressobin boards have 3 ethernet ports and some of them got assigned more
> then one MAC address. MAC addresses are stored in U-Boot environment.
> 
> Since commit a2c7023f7075c ("net: dsa: read mac address from DT for slave
> device") kernel can use MAC addresses from DT for particular DSA port.
> 
> Currently Espressobin DTS file contains alias just for ethernet0.
> 
> This patch defines additional ethernet aliases in Espressobin DTS files, so
> bootloader can fill correct MAC address for DSA switch ports if more MAC
> addresses were specified.
> 
> DT alias ethernet1 is used for wan port, DT aliases ethernet2 and ethernet3
> are used for lan ports for both Espressobin revisions (V5 and V7).
> 
> Fixes: 5253cb8c00a6f ("arm64: dts: marvell: espressobin: add ethernet alias")
> Cc: <stable@vger.kernel.org> # a2c7023f7075c: dsa: read mac address
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Andre Heider <a.heider@gmail.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> [pali: Backported Espressobin rev V5 changes to 5.4 and 4.19 versions]
> 
> ---
> This patch is backport for 5.4 and 4.19 stable releases. From original
> patch were removed changes for Espressobin revision V7 as these older
> kernel versions have DTS files only for Espressobin revision V5.
> 
> Note that this patch depends on commit a2c7023f7075c ("dsa: read mac
> address") as stated on Cc: line and for 4.19 release needs to be
> backported first.
> ---
>  .../boot/dts/marvell/armada-3720-espressobin.dts     | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Now queued up, thanks.

greg k-h
