Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEF9421ED8
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 08:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhJEG23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 02:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEG22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 02:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 132D5604AC;
        Tue,  5 Oct 2021 06:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633415198;
        bh=LeabsSKRoCCwiHF+8StZsPpO/wbGB9n95G0mwU1iFrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qJ3AADEmluygFB42luDKhrWPoW2GjmMJ5FHx3A4Dvqdtw9ct0vuqUiDsoiWU5amEd
         2xdN2oAlYN15FYy2u+62L0PsT/uHWgSrpZigN4TuxZcpBwbz4UEv6PwzEEcKPcdwek
         lRy2QpczNqzzSV14cbBcjY6vmGnzCoCrNsCB+W7NppzxMVSax1Ovk/wbZXrjBREHIB
         mKjCGLQZwWsCcyH/vm82aaT/72HcpcKExwLI+iYZDmqJ6ZI7fH/fPYgAwQjiMcWOMU
         XD4IIDMnxxTxRi0vnoXKpY62961eL/nRQVV28PAJIG0KYtvIXvgRS5it72phEAk5vb
         6f1TwU9a/ezcA==
Date:   Tue, 5 Oct 2021 14:26:33 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: imx8m*-venice-gw7902: fix M2_RST# gpio
Message-ID: <20211005062632.GU20743@dragon>
References: <20211004222341.27949-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004222341.27949-1-tharvey@gateworks.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 03:23:41PM -0700, Tim Harvey wrote:
> Fix invalid M2_RST# gpio pinmux.
> 
> Fixes: ef484dfcf6f7 ("arm64: dts: imx: Add i.mx8mm/imx8mn Gateworks gw7902 dts support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

Applied, thanks!
