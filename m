Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B7D221DC
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 08:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfERGi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 02:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfERGi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 May 2019 02:38:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638EA2087E;
        Sat, 18 May 2019 06:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558161506;
        bh=2LLwg0/5cQYv9Vcr/G7BBkP5kOFgZkGQpwMneedf788=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A4QfEuLJ6rV4yxzjDwFIC5j5KQPz9WG+dk0DG3dE4gf5bHuSeLWniP0H34ZLtHROi
         v4AewFfcJJmIIp7NkvdCKleWOUkrlYK3jELjeRHSt+AtK5uezvEJePsZ/6oHMUxH+G
         c4NG7MtOtZaORfrHVej2NVWLxTv4TbpM5UtUZyPg=
Date:   Sat, 18 May 2019 08:38:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "George G. Davis" <george_davis@mentor.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        shawnguo@kernel.org, andrew@lunn.ch, baruch@tkos.co.il,
        ken.lin@advantech.com, smoch@web.de, stwiss.opensource@diasemi.com,
        linux-imx@nxp.com, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>, aford173@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] ARM: dts: imx: Fix the AR803X phy-mode
Message-ID: <20190518063824.GC26163@kroah.com>
References: <20190403221241.4753-1-festevam@gmail.com>
 <20190513171826.GA18591@mam-gdavis-lt>
 <20190514004539.GG11972@sasha-vm>
 <20190514011606.GA18528@mam-gdavis-lt>
 <20190514020742.GJ11972@sasha-vm>
 <20190514152240.GB18528@mam-gdavis-lt>
 <20190517222502.GA1844@mam-gdavis-lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517222502.GA1844@mam-gdavis-lt>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 06:25:04PM -0400, George G. Davis wrote:
> Hello Sasha,
> 
> On Tue, May 14, 2019 at 11:22:40AM -0400, George G. Davis wrote:
> > On Mon, May 13, 2019 at 10:07:42PM -0400, Sasha Levin wrote:
> > > On Mon, May 13, 2019 at 09:16:07PM -0400, George G. Davis wrote:
> > > >On Mon, May 13, 2019 at 08:45:39PM -0400, Sasha Levin wrote:
> > > >>On Mon, May 13, 2019 at 01:18:27PM -0400, George G. Davis wrote:
> > > >>>On Wed, Apr 03, 2019 at 07:12:41PM -0300, Fabio Estevam wrote:
> > > >>What's the commit id in Linus's tree? I don't see it.
> 
> Finally:
> 
> commit 0672d22a19244cdb0e5c753125c1a55a120db5d0 upstream.

Now queued up, thanks.

greg k-h
