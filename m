Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC4E23D2A7
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgHEUOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:14:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36627 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726609AbgHEQVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:21:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 93A4B5C010D;
        Wed,  5 Aug 2020 10:33:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 05 Aug 2020 10:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=C
        R4YatWMpWxQKBesXUUIF5dUX3OG0y4jCv8eJKqFZWk=; b=odO86XUdUjtHKhRAc
        f1D70hSFiswPF8RAgyGwL8HN/PdtcA3zlWVuqlCfEPw4kkj5aoG/WIyIc75BgwWt
        J7nWxlgeDetyKZv9nxLdo4mHmNc8GQQ+rRXvpWD7l31/7QB0gfFIOfAEkljTCOBd
        JXgxb1URgCwf0Md+6rwgGc+TMngqG/I5GX3rcBbVcfABpBAWdQZkQfF+OAU0a3dX
        L7Mywwvi6Q1bTH/n/E8QSMeS4r9Sdxtp8emV+cxTFsgGsNkkGoAYTJNzqMTRZgGA
        P2COs7MYFNHKSf6Mkx7VcYhjls5xm4pNcRKVyRlZVBR+JTXjiPlCY6lm0PAi9ek5
        665rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=CR4YatWMpWxQKBesXUUIF5dUX3OG0y4jCv8eJKqFZ
        Wk=; b=s3q/MpcaBcwJEQ5wdhLBCbK6IYjcBNO7xDBUhqB5fPHHxtmIKa1vl05wL
        fU8z47oNJ+pXAw3cOXKIy3MzAZ7ilwHHzkA2zm50N4ITiCceeFg0r/PZU8R3sG/r
        VpLLZ9qjina8yPpRmixhH6YFWC8xrm7KrkQf7zG+OB7RCUEQScJMcmdJSra6sk2c
        WzTlxXFJ7o3hcDATdWHlWbrYdO6+KGh/lP4JeQ4St7pteXC1no5RHGoA48Nb+RRJ
        FPqdMDdmJfbnuJrPRSWjQVyiOgTEHQOXOJY+eY/TL5Y7GfX4MUgkbslDyVzoScMn
        5dZ+4TO05tlDlZLUdnFeXCenvZZZw==
X-ME-Sender: <xms:LMMqX-EpktiCLPHxtaGGMkWyt9ZO3naQYjp7IZulaI2mN4MI092UFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeekgdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevtdeile
    euteeggefgueefhfevgfdttefgtefgtddvgeejheeiuddvtdekffehffenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:LMMqX_UWPolgm27gWxkx9woKuquNbKkwsocDnEA4vBeSreZPJxqUNw>
    <xmx:LMMqX4I8TM-dJZRUs3O1AiP8Dl3BFdVosRv7xu6L5c_scaoEC4JHeQ>
    <xmx:LMMqX4H7jYpnJPEsSZS2_O3T8Rq6R8X1ZJkRX9IP0RZBybprbYwQxA>
    <xmx:LMMqX9enf7fHN3cQCTJD5vaGyLriyKPePKxOVoBC1gYXlwjO_RSTqA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96DFD30600B1;
        Wed,  5 Aug 2020 10:33:15 -0400 (EDT)
Date:   Wed, 5 Aug 2020 16:33:28 +0200
From:   Greg KH <greg@kroah.com>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Adam Ford <aford173@gmail.com>, stable <stable@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
Message-ID: <20200805143328.GD2154236@kroah.com>
References: <20200709121232.9827-1-aford173@gmail.com>
 <CAHCN7x+crwfE4pfufad_WEUhiJQXccSZHot+YNDZzZKvqhrmWA@mail.gmail.com>
 <86992356-b902-d7da-ffd7-e8b98f9252fd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86992356-b902-d7da-ffd7-e8b98f9252fd@ti.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 04:19:54PM +0300, Tomi Valkeinen wrote:
> On 04/08/2020 16:13, Adam Ford wrote:
> > 
> > 
> > On Thu, Jul 9, 2020 at 7:12 AM Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>> wrote:
> > 
> >     There appears to be a timing issue where using a divider of 32 breaks
> >     the DSS for OMAP36xx despite the TRM stating 32 is a valid
> >     number.  Through experimentation, it appears that 31 works.
> > 
> >     This same fix was issued for kernels 4.5+.  However, between
> >     kernels 4.4 and 4.5, the directory structure was changed when the
> >     dss directory was moved inside the omapfb directory. That broke the
> >     patch on kernels older than 4.5, because it didn't permit the patch
> >     to apply cleanly for 4.4 and older.
> > 
> >     A similar patch was applied to the 3.16 kernel already, but not to 4.4.
> >     Commit 4b911101a5cd ("drm/omap: fix max fclk divider for omap36xx") is
> >     on the 3.16 stable branch with notes from Ben about the path change.
> > 
> >     Since this was applied for 3.16 already, this patch is for kernels
> >     3.17 through 4.4 only.
> > 
> >     Fixes: f7018c213502 ("video: move fbdev to drivers/video/fbdev")
> > 
> >     Cc: <stable@vger.kernel.org <mailto:stable@vger.kernel.org>> #3.17 - 4.4
> >     CC: <tomi.valkeinen@ti.com <mailto:tomi.valkeinen@ti.com>>
> >     Signed-off-by: Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>>
> > 
> > 
> > Tomi,
> > 
> > Can you comment on this?  The 4.4 is still waiting for this fix.  The other branches are fixed.
> 
> Looks good to me.
> 
> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

I don't seem to have the original of this anymore, can someone please
resend it?

thanks,

greg k-h
