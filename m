Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338703C191D
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhGHSXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhGHSXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 14:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED9CC61457;
        Thu,  8 Jul 2021 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625768433;
        bh=8xG9gHqGRLfRuPcY82CKORqrkFPQV2/AkTgxQeEJLdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZRC6RON4gFFEtXb90/HN72N8j8XQ57iHpkGhNVEabGOq7zshKQI8JHvzYCgE2o6qh
         810FDfZ9K/Hir2OerW2xn3h0ArZDoKvdqqXw18fVdZyZambQf5hwrns0FS6Cv0s4XU
         aeuyDywb0tT3NWjYjgVnES3esuJJKqvZvzX01Fmg=
Date:   Thu, 8 Jul 2021 20:20:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH for 4.19] ARM: dts: imx6qdl-sabresd: Remove incorrect
 power supply assignment
Message-ID: <YOdB73tCGlTCfw5P@kroah.com>
References: <20210708091941.342219-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708091941.342219-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 06:19:41PM +0900, Nobuhiro Iwamatsu wrote:
> From: Anson Huang <Anson.Huang@nxp.com>
> 
> commit 4521de30fbb3f5be0db58de93582ebce72c9d44f upstream.
> 
> The vdd3p0 LDO's input should be from external USB VBUS directly, NOT
> PMIC's power supply, the vdd3p0 LDO's target output voltage can be
> controlled by SW, and it requires input voltage to be high enough, with
> incorrect power supply assigned, if the power supply's voltage is lower
> than the LDO target output voltage, it will return fail and skip the LDO
> voltage adjustment, so remove the power supply assignment for vdd3p0 to
> avoid such scenario.
> 
> Fixes: 93385546ba36 ("ARM: dts: imx6qdl-sabresd: Assign corresponding power supply for LDOs")
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 4 ----
>  1 file changed, 4 deletions(-)

Applied, thanks.

greg k-h
