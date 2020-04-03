Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBBD19D35F
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 11:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389297AbgDCJSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 05:18:20 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:46277 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727854AbgDCJSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 05:18:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 9E43364E;
        Fri,  3 Apr 2020 05:18:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 03 Apr 2020 05:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=O
        7cqg0kFt1j+JAzxb2BuwvOOt9xAuYfjQutzNyUEm7U=; b=Y+HArtjqYmoUhqvXg
        E+LO/2J6pEpjvym3yLFY+d/HR08M2j0n5xglMlnbVkvP/xlrqU9a1GyJf0y7xJ5g
        RzsCLrczsSlWfACgUrPberk2Gjv5gA6R8qqGLYAC2tXjpLgU94p0vYS+qLBLPG/F
        08SzSe/gs0Gqy1mw7/70BXXEdfiTe8yq7eCDl4KBrUlbTxUggqhEjpzJWypMs4mI
        GiPmDK7QfyTzaAjEzZQLNyMHohnnd0qLMXNTvWJTkMcFGsq/TOW8l/88s0aLMSfX
        8tYyl00z10+afDUlPId77kCmaOgZ52gATxXi1B6NZ86dvbcSNg7pe5AowYKTOnu8
        YPuDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=O7cqg0kFt1j+JAzxb2BuwvOOt9xAuYfjQutzNyUEm
        7U=; b=gm+lAvT5mN2L1FTfxeWmslGbUMgJOokW/NTcTX+VADwr6gX6hRA6Vip9E
        FtGGkAm1jH83w64ggyiMnhhOxSXYSrhGf/vkUrr5O7v4EftOb0fKBTBrlAwiVbLt
        HIuvRPJAf1Y0sJi9qinbYn9/t+yODK8lJXlkqHJ12Df1hoPV0jrShKGM5E+DwA0N
        GHZOWKEAZnp72jUGV+oz6N2GqdKrCE/y9JnQaLk8bwYdga8EzItHHjsiGATSflP4
        sfC7/N5LcPMJjhDos8x9c4bC73YsEl6W7R5XCcC+UiWj5sZWa34Hpsklr+OG5Z3w
        ANQAmQxcthmrgctCMRYgyvcMuGwQg==
X-ME-Sender: <xms:Wf-GXsIU6cwZBBeVL4We5RvWZJnzA4BnBpQ0mMFyJl3GmLr1eun_Yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Wf-GXgYY4adXz3v_tBSiPVIh2aMu53G-l5zNIyv850O1dppq5SjnlA>
    <xmx:Wf-GXnuLn9GHD-TS8RnK1TNRtpLK4QdNWcERPutB-6ghx8VjyHI5_Q>
    <xmx:Wf-GXtvuoebC9awjSlZF9Fzoj4qAG7sh9p74IMrJWjNVrtx4K3bp2g>
    <xmx:W_-GXpaRoTLC6Y01KaLwbuBdWTfiq6jvMeBRUm6ua2zfSD8JDrLZIQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87BE6306CF47;
        Fri,  3 Apr 2020 05:18:17 -0400 (EDT)
Date:   Fri, 3 Apr 2020 11:18:16 +0200
From:   Greg KH <greg@kroah.com>
To:     Giacomo Comes <comes@naic.edu>
Cc:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] kernel 5.6: baytrail hdmi audio not working
Message-ID: <20200403091816.GD3740897@kroah.com>
References: <20200401225317.GA13834@monopoli.naic.edu>
 <20200402135203.GV13686@intel.com>
 <20200402145336.GA19483@monopoli.naic.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200402145336.GA19483@monopoli.naic.edu>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 10:53:36AM -0400, Giacomo Comes wrote:
> On Thu, Apr 02, 2020 at 04:52:03PM +0300, Ville Syrjälä wrote:
> > On Wed, Apr 01, 2020 at 06:53:17PM -0400, Giacomo Comes wrote:
> > > Hi,
> > > on my Intel Compute Stick STCK1 (baytrail hdmi audio) 
> > > sound is not working with the kernel 5.6
> > > 
> > > I have bisected the kernel and I found the commit that introduced the issue:
> > > 
> > > commit 58d124ea2739e1440ddd743d46c470fe724aca9a
> > > Author: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > Date:   Thu Oct 31 12:26:04 2019 +0100
> > > 
> > >     drm/i915: Complete crtc hw/uapi split, v6.
> > >     
> > >     Now that we separated everything into uapi and hw, it's
> > >     time to make the split definitive. Remove the union and
> > >     make a copy of the hw state on modeset and fastset.
> > >     
> > >     Color blobs are copied in crtc atomic_check(), right
> > >     before color management is checked.
> > > 
> > > If more information is required please let me know.
> > 
> > Should hopefully be fixed with
> > commit 2bdd4c28baff ("drm/i915/display: Fix mode private_flags
> > comparison at atomic_check")
> > 
> > Stable folks, please pick that up for 5.6.x stable releases.
> 
> I can confirm that the commit indeed solves the problem I have.
> It should go in the stable 5.6.x release ASAP.

Now queued up, thanks.

greg k-h
