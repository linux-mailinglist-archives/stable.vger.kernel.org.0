Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32F2115552
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 17:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfLFQ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 11:29:38 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:36387 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726258AbfLFQ3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 11:29:38 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AE58B79B;
        Fri,  6 Dec 2019 11:29:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 06 Dec 2019 11:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=mMXwlZ/WV93zKt0d+PMc9Wn9V/S
        G6eIehfrT3pRxwsw=; b=eJYzTAgD+fX+eibIoDUISodnTBCab4HkcdS2jE2WTOv
        G2vXBjn+lbWwcNJgL5xfsjNoAjytoruUDSNkIR7bwEy0pI5kzVFyQsKdZoPmaFjJ
        cWFrditdXlE2+0N+qmrO3NlQw9c4EAH9oto+T3pcW149L3t/LizBG5JW6dv63qI9
        b5rg/2xvAaUddsMvdNB+JWeA10suUl2ftChoB5JezRm9ihbCLge7Gd0XSmUHj7Y0
        8/O1+WBqF2RzOVMMJTWQ7yBEIl8Mptc1JHzUxxnrv3FlH7pUERLX+Uvgau6q4Dvp
        d+j0yjm3Y2aLzygXQQECXm3JD1S6CL/De/YcAUlGIww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mMXwlZ
        /WV93zKt0d+PMc9Wn9V/SG6eIehfrT3pRxwsw=; b=a6+lF1FJIeL6SYADJ6KsUR
        vXaL1Tz7E5R9fck6hLwgws2Swe5RKjHO3e5NG2QHv87GX03QJ8cHl+j4ELQyJtS3
        d5Gs5rX1D6ayGQ5JmxtZQ1RiZSz2AX2MkFq1H4zz8Z2yowT/Uo8jMs0KprmTErT2
        wXyYmvRKWRPFnM/h2b6m8JX/VFutmQCSr/26xFFF36LItOvhasbbc3TbAJSwQqTP
        w+GEvAqsD67Nc2mr94xcGEmkWEiUklQYhmSLBBock0Rxx/Xma6rSzCkXzaVRf3Va
        d7BzyU/qKvUndRzEvfZ9CfLVfB4BF2L4eyQvI3hgrfAS/8yDsbkz8jTSzdtOko1g
        ==
X-ME-Sender: <xms:8IHqXe0mw5vT-4xKf4HWVQNApuTJDK8bovLojBWuGWaD4QeYlVlClQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekfedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:8IHqXbqOdn0wngpayUOiEvq9ojy-V_FJsOpgr6AJPwd3o9TZ7VFjjA>
    <xmx:8IHqXTfvTagTa8zBriilu2ffap7KMcpXUbbLSODc4sI-Z9fSU4RhqQ>
    <xmx:8IHqXSp6D5SQXli_-gehA-5xG6ow3MU4sovqTcVXSfhVXa1dtErGlQ>
    <xmx:8YHqXQ0sFxfa2YMyy-PBXbVnUg4F84miso-XQvk0pgRb7olodRbPgQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C9038005A;
        Fri,  6 Dec 2019 11:29:36 -0500 (EST)
Date:   Fri, 6 Dec 2019 17:29:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 09/15] ASoC: tegra: Add fallback for audio mclk
Message-ID: <20191206162934.GA86904@kroah.com>
References: <1575600438-26795-1-git-send-email-skomatineni@nvidia.com>
 <1575600438-26795-10-git-send-email-skomatineni@nvidia.com>
 <20191206070912.GB1318959@kroah.com>
 <6fef4ee1-0528-9f8e-cb25-4af126d33b99@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fef4ee1-0528-9f8e-cb25-4af126d33b99@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 08:19:26AM -0800, Sowjanya Komatineni wrote:
> 
> On 12/5/19 11:09 PM, Greg KH wrote:
> > On Thu, Dec 05, 2019 at 06:47:12PM -0800, Sowjanya Komatineni wrote:
> > > mclk is from clk_out_1 which is part of Tegra PMC block and pmc clocks
> > > are moved to Tegra PMC driver with pmc as clock provider and using pmc
> > > clock ids.
> > > 
> > > New device tree uses clk_out_1 from pmc clock provider.
> > > 
> > > So, this patch adds fallback to extern1 in case of retrieving mclk fails
> > > to be backward compatible of new device tree with older kernels.
> > > 
> > > Cc: stable@vger.kernel.org
> > > 
> > > Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> > > ---
> > >   sound/soc/tegra/tegra_asoc_utils.c | 10 ++++++++--
> > >   1 file changed, 8 insertions(+), 2 deletions(-)
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> > 
> > </formletter>
> 
> Hi Greg,
> 
> link says to option-1 is strongly preferred for for all patches except for
> submissions that are not in net/ and security related.
> 
> Option-1 is to add Cc: stable@vger.kernel.org in sign-off area and I
> followed this.

That's fine, but then why did you just email a patch to yourself and the
list?  Shouldn't you also submit the patch upstream to get it properly
merged first?

thanks,

greg k-h
