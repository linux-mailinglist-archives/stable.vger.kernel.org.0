Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF75F37F1BD
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 05:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhEMDsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 23:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhEMDsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 23:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10F59611AE;
        Thu, 13 May 2021 03:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620877648;
        bh=p6xrZ3JTKsWDJtrDHXmvV7dSY9P2McoHF8Qq23N2Hy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RiOJMHOw7QFqZMpitICnAEodKuvl9bO6LqkcTIank8kD4vMgQXKutx5MQQIjJeD23
         tEsNAoFtjyrBU0eZ1ImCY3Q1Mlj79a0vCuhGI3ur3N26xvwsPmuixwsZ9B/xOLUVgl
         kfP79D3HhAmDuzXTbs7P3Uqq4DZEOY/L17oXj5nSLFZoQ6ELq4yXx3mKykuvB2CmFj
         QNfZUIThbOnbdGm3vIP/E8IYbMUFRYlMrGtzjMNctzSStqiLbfy6fUGLiQWg5HJ57V
         Rb0FmsdZimyEX84vZMNq0iugQhPpJ3zLjcJ+wI5ggElXzpq/z8iW0qVweiihQpG7Rr
         0ZP5qvVHQoFaA==
Date:   Thu, 13 May 2021 11:47:23 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334
 switch
Message-ID: <20210513034722.GN3425@dragon>
References: <1618325157-5774-1-git-send-email-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1618325157-5774-1-git-send-email-michal.vokac@ysoft.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
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

Applied, thanks.
