Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1A245A27F
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhKWM3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhKWM3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 07:29:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A514561028;
        Tue, 23 Nov 2021 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670370;
        bh=JN8bMYOmGz5IhvdUvVdNns68zcqb1ApaEo2OBE4caAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=edIBv4bcQVyymyGOMw9CY6ag72Z53/7RZhAPOtQj9c9q95VNipwAAj4ZWiXVj8Lt7
         hX2JeEDb4aS8Q3v4ZNOzZ32yiHOzZQoyH5kHROp7r+astQESCteF+uU0FstC/S3OL7
         ZoTNVFQCxkMJ7/UvTxMwLZwgNyLucsl/G5brXM+H7H2PC1EztTJiR2W+Q3ewm1Nvdz
         sUt4RAyi+YPaBRCxFk0Rz3/EIUve0q+Eer8E5Bj6D1D0F+VXQbyJqf1wSP8msLBJ5b
         ZF8EccmKuRRZJezTqhBYM+DDeB0TJjft917d2y2PVvb3gG1AAt/8JtxeBFV7bctChY
         ccnyhwVOnP6pQ==
Date:   Tue, 23 Nov 2021 20:26:05 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Mathew McBride <matt@traverse.com.au>
Cc:     Li Yang <leoyang.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: ten64: remove redundant interrupt
 declaration for gpio-keys
Message-ID: <20211123122605.GE4216@dragon>
References: <20211122025554.15338-1-matt@traverse.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122025554.15338-1-matt@traverse.com.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 02:55:54AM +0000, Mathew McBride wrote:
> gpio-keys already 'inherits' the interrupts from the controller
> of the specified GPIO, so having another declaration is redundant.
> On >=v5.15 this started causing an oops under gpio_keys_probe as
> the IRQ was already claimed.
> 
> Signed-off-by: Mathew McBride <matt@traverse.com.au>
> Fixes: 418962eea358 ("arm64: dts: add device tree for Traverse Ten64 (LS1088A)")
> Cc: stable@vger.kernel.org

Applied, thanks!
