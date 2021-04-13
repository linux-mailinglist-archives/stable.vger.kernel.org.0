Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F4C35E239
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 17:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345550AbhDMPD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 11:03:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242462AbhDMPDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 11:03:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWKZA-00GUMK-8h; Tue, 13 Apr 2021 17:03:00 +0200
Date:   Tue, 13 Apr 2021 17:03:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334
 switch
Message-ID: <YHWypAVAv2Qkc3K3@lunn.ch>
References: <1618325157-5774-1-git-send-email-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1618325157-5774-1-git-send-email-michal.vokac@ysoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 04:45:57PM +0200, Michal Vokáč wrote:
> The FEC does not have a PHY so it should not have a phy-handle. It is
> connected to the switch at RGMII level so we need a fixed-link sub-node
> on both ends.
> 
> This was not a problem until the qca8k.c driver was converted to PHYLINK
> by commit b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of
> PHYLIB"). That commit revealed the FEC configuration was not correct.
> 
> Fixes: 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Ursa boards")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
