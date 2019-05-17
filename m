Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BAE2203C
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 00:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfEQWZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 18:25:23 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:44107 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfEQWZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 18:25:23 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hRlHn-0005rB-6T from George_Davis@mentor.com ; Fri, 17 May 2019 15:25:07 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Fri, 17 May
 2019 15:25:04 -0700
Date:   Fri, 17 May 2019 18:25:04 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Fabio Estevam <festevam@gmail.com>, <stable@vger.kernel.org>,
        <shawnguo@kernel.org>, <andrew@lunn.ch>, <baruch@tkos.co.il>,
        <ken.lin@advantech.com>, <smoch@web.de>,
        <stwiss.opensource@diasemi.com>, <linux-imx@nxp.com>,
        <kernel@pengutronix.de>, Marc Kleine-Budde <mkl@pengutronix.de>,
        <aford173@gmail.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] ARM: dts: imx: Fix the AR803X phy-mode
Message-ID: <20190517222502.GA1844@mam-gdavis-lt>
References: <20190403221241.4753-1-festevam@gmail.com>
 <20190513171826.GA18591@mam-gdavis-lt>
 <20190514004539.GG11972@sasha-vm>
 <20190514011606.GA18528@mam-gdavis-lt>
 <20190514020742.GJ11972@sasha-vm>
 <20190514152240.GB18528@mam-gdavis-lt>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190514152240.GB18528@mam-gdavis-lt>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha,

On Tue, May 14, 2019 at 11:22:40AM -0400, George G. Davis wrote:
> On Mon, May 13, 2019 at 10:07:42PM -0400, Sasha Levin wrote:
> > On Mon, May 13, 2019 at 09:16:07PM -0400, George G. Davis wrote:
> > >On Mon, May 13, 2019 at 08:45:39PM -0400, Sasha Levin wrote:
> > >>On Mon, May 13, 2019 at 01:18:27PM -0400, George G. Davis wrote:
> > >>>On Wed, Apr 03, 2019 at 07:12:41PM -0300, Fabio Estevam wrote:
> > >>What's the commit id in Linus's tree? I don't see it.

Finally:

commit 0672d22a19244cdb0e5c753125c1a55a120db5d0 upstream.

> > We'll happily take it once it makes it into Linus's tree and into a
> > release.
> > 
> > >Meanwhile, I wanted to let you know that v5.1.x is rather broken, in this
> > >regard, on i.MX6 as-is for now.
> > 
> > This would be something we can't do much about, but given it's an
> > important fix it should make it into Linus's tree very soon, right?
> 
> Yes, it will hopefully reach Linus's tree soon. Apologies for my impatience. :)

Again, apologies for my impatience!

TIA!

-- 
Regards,
George
