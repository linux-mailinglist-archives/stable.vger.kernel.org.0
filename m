Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355033A0C63
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhFIG1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 02:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232540AbhFIG1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 02:27:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 277DC61108;
        Wed,  9 Jun 2021 06:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623219942;
        bh=mjHrDiYoZueqHAe0iTTos1E3/o1ALed9Tgb3Z6VUdt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nMcsbs3RDFUW67UHgXLZhlHXnMl6VKMcZCjOaIdwIBgzdPDzDsnkDrrIdf1aP9Unj
         kFFNb6ZZ5HwyiaVpr/sby8FpXHi81EMJmr/4ISsO0WUn7/a/6mi5ckEKcEY+Vw3OF2
         JRe+oGqYWiGRTFV76eoy2h4ZcLTLWeDEC+oH8a3c=
Date:   Wed, 9 Jun 2021 08:25:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 4.19 28/58] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5
 regulators
Message-ID: <YMBe5GZxm1JytsfU@kroah.com>
References: <20210608175932.263480586@linuxfoundation.org>
 <20210608175933.214613488@linuxfoundation.org>
 <YL/ATP6MBeYlclSx@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL/ATP6MBeYlclSx@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 08:09:00PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, Jun 08, 2021 at 08:27:09PM +0200, Greg Kroah-Hartman wrote:
> > From: Marek Vasut <marex@denx.de>
> > 
> > commit 8967b27a6c1c19251989c7ab33c058d16e4a5f53 upstream.
> 
> This is causing build failure with error:
> 
> Error: arch/arm/boot/dts/imx6q-dhcom-som.dtsi:414.1-12 Label or path reg_vdd1p1 not found
> Error: arch/arm/boot/dts/imx6q-dhcom-som.dtsi:418.1-12 Label or path reg_vdd2p5 not found
> FATAL ERROR: Syntax error parsing input tree

Thanks for the report will go drop this now...

greg k-h
