Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BBF148D10
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 18:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390396AbgAXRh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 12:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390106AbgAXRhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 12:37:25 -0500
Received: from localhost (unknown [84.241.198.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6920E20709;
        Fri, 24 Jan 2020 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579887445;
        bh=vrdwfmKJ2vX5fqIQG0Y3KARRAq9BP/c6YUKg9aIfqTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FczvMkuEuP7nQmcVd13gtxE8xghLrdhBR8p3GrjbhnPq/1pKfs/rhej6y4ihS5hmb
         SWiBxTkr3VPG+t/YJ2iInwIRiPxAbBFY6zjZOnuIdkWi3X1f3g8TzUBghhU027Di0v
         26Lcr0ZeVD9nJJGUCQUCePdmE80SXF2H4OIvfaDI=
Date:   Fri, 24 Jan 2020 18:36:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 016/343] regulator: fixed: Default enable high on DT
 regulators
Message-ID: <20200124173640.GC3166016@kroah.com>
References: <20200124092919.490687572@linuxfoundation.org>
 <20200124092921.766134559@linuxfoundation.org>
 <CACRpkdYJZoQpTCdTikQTu62EuxbUG5A=h3CV2xfHfra=TbD+eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYJZoQpTCdTikQTu62EuxbUG5A=h3CV2xfHfra=TbD+eQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 02:46:45PM +0100, Linus Walleij wrote:
> On Fri, Jan 24, 2020 at 10:44 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > [ Upstream commit 28be5f15df2ee6882b0a122693159c96a28203c7 ]
> 
> This exploded on v4.19 so please drop this one.

Sasha dropped this, thanks.

greg k-h
