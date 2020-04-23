Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4381A1B5E4A
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 16:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgDWOtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 10:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgDWOtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 10:49:47 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2A202074F;
        Thu, 23 Apr 2020 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587653387;
        bh=Squ984zlMZptzhAKjHKpCQpxxgGfSb8mS/6BuC0Lfj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0s6jtrPZ8SpTqOIBa477jl1u+6TkbWr/QsSmToSI3XJ2lNs9zZG+S7lza8M15CPbG
         WNcvR3Cz8op83Ex4DPw0Y6yti7HStFX64AnBYwGS/7jmG8ukQ4KEVJuYyIXx27LS/q
         Ojf/ig9FiZjvdwoY9wvHzUrXhQh/+8l60BMO+H6c=
Date:   Thu, 23 Apr 2020 22:49:39 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kernel@pengutronix.de, c.hemp@phytec.de, s.riedmueller@phytec.de,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1
 pinctrl entries
Message-ID: <20200423144938.GF9391@dragon>
References: <20200327133624.26160-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327133624.26160-1-festevam@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 10:36:24AM -0300, Fabio Estevam wrote:
> The I2C2 pins are already used and the following errors are seen:
> 
> imx27-pinctrl 10015000.iomuxc: pin MX27_PAD_I2C2_SDA already requested by 10012000.i2c; cannot claim for 1001d000.i2c
> imx27-pinctrl 10015000.iomuxc: pin-69 (1001d000.i2c) status -22
> imx27-pinctrl 10015000.iomuxc: could not request pin 69 (MX27_PAD_I2C2_SDA) from group i2c2grp  on device 10015000.iomuxc
> imx-i2c 1001d000.i2c: Error applying setting, reverse things back
> imx-i2c: probe of 1001d000.i2c failed with error -22
> 
> Fix it by adding the correct I2C1 IOMUX entries for the pinctrl_i2c1 group.
> 
> Cc: <stable@vger.kernel.org> 
> Fixes: 61664d0b432a ("ARM: dts: imx27 phyCARD-S pinctrl")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks.
