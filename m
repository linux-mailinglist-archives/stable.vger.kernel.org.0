Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1083E1A7F05
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388556AbgDNN7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388513AbgDNN7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 09:59:43 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DCB620578;
        Tue, 14 Apr 2020 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586872783;
        bh=fFINDROxgiHKxx92P2pZaMJQJWiL2z3aI5A+SKWsmmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lVieuKoaxhrtyXLu+CFu07YGsuDgJSbocZ8LVuRDeZsyhKDzofZcLudfh8BlRBrk1
         tMXl1JiHjg8RGQ44D7ey/DdOqIXuJVH+5HrVAVhcocCw/0m8cXk0gDq20mlO5ZUjM2
         +FNLJvktRPOuXVH4GEQ/1KZuL8VZYV+K6W8gHEKE=
Date:   Tue, 14 Apr 2020 21:59:37 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx6dl-yapp4: Fix Ursa board Ethernet
 connection
Message-ID: <20200414135936.GH30676@dragon>
References: <1584434788-11945-1-git-send-email-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1584434788-11945-1-git-send-email-michal.vokac@ysoft.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 09:46:28AM +0100, Michal Vokáč wrote:
> The Y Soft yapp4 platform supports up to two Ethernet ports.
> The Ursa board though has only one Ethernet port populated and that is
> the port@2. Since the introduction of this platform into mainline a wrong
> port was deleted and the Ethernet could never work. Fix this by deleting
> the correct port node.
> 
> Fixes: 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Ursa boards")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>

Applied, thanks.
