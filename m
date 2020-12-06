Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C092D0252
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 10:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgLFJuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 04:50:16 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36993 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgLFJuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 04:50:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 306615C0174;
        Sun,  6 Dec 2020 04:49:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 06 Dec 2020 04:49:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Es1Q0eP0V2RUbWXDDzXmKGvBLVV
        rVtGdWx6WIbwME1g=; b=BClCqPrmifs0QL/Wl7bfFQmqp+THU3h7SPH7jKChWRw
        8JrHqhyjUPWjw68hKash931RViSnJIZmCx3y6x9VEWTKqEd0DPbV/tp8HPy5U34Y
        eKTiD90TVIZh+uX4ia7oeiBZAcgyivboZvOI+wv9lFIba2mDB5iwT/HnpJVVllmg
        MfVmHEfddUYren9lIeyZta8DjktV5N2V5KCl/VX6CrlGhnmMwkx442uECOIS1mto
        ep8o1ZNIsIqzXhFMgTJiWc0yX4VkeTF70j66O2BBP+2ooRqxIFBVpo5l04YP69kD
        7Hz9059Py4AKDTxgCaM10tM8lTv05YIRikVAzZPeeHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Es1Q0e
        P0V2RUbWXDDzXmKGvBLVVrVtGdWx6WIbwME1g=; b=kcy9TmkFmuRKIbMj5+Sv8O
        ebB2lwSC7sbTgviB9hsM/SkMjn2HqRjbMQDriRs/caRPm77dUx3ZnorLv9Qjqgcu
        Ngibe9/8Ictjnr3jOkPGIwAP9qIlls80FC/qEFS5vlDJeVPNQWbmqzKEQj9FN2+u
        8pqjrKFmpHx3x32QzLo36mm+Wn88+Gp6kiVs5DFbQLdvZnIQ7dchI4JTqYrqcNQu
        SG0noOTIDFc7IKcRkO2F7DIXnIjQT7BhDOltfjfVPpdRweR6ulPnIZwgJ8yNgRZc
        HaybS6jtGEV2If+y/UMB4JUxCX6cuytienk4JW0SLcNpVqoNfj/yyJ0f+NB8hh8Q
        ==
X-ME-Sender: <xms:KKnMX07VieEafi04Ey6ppLFr31aDZcBbKUaI5Up6wuJS1EJgR4cuUA>
    <xme:KKnMX14CMm2LDjeQLRVIcHliI3-5kC-wS76wvPRpLBQ0F_nyJiAnzsiOZksu6Qiwb
    f-m845m8L-psg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejvddgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KKnMXzfOcxYgd_QMt6Z5fItOA0vZSoLXa6FxH7P3qshHAk15Fg157A>
    <xmx:KKnMX5KjK6wq3f5WOm-n8HAdo3ZeSzV3MMtPtACGWaDAyr2DNru-sw>
    <xmx:KKnMX4KVZSaXWx0IYB7xKf7VhKaT5sfphVcR-BLsVdiyuAEYfRzXAw>
    <xmx:KanMX9GXwV_bR_7p30rx9wY7B2nClBoM-5J7vit_IudNtgXNOOQ7vg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 511AD24005A;
        Sun,  6 Dec 2020 04:49:28 -0500 (EST)
Date:   Sun, 6 Dec 2020 10:50:41 +0100
From:   Greg KH <greg@kroah.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Michal Suchanek <msuchanek@suse.de>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Stop exporting __clear_user which is now
 inlined.
Message-ID: <X8ypcZnTF3U3aCxD@kroah.com>
References: <20201204232807.31887-1-msuchanek@suse.de>
 <87y2ictt80.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2ictt80.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 05, 2020 at 09:58:23PM +1100, Michael Ellerman wrote:
> Michal Suchanek <msuchanek@suse.de> writes:
> > Stable commit 452e2a83ea23 ("powerpc: Fix __clear_user() with KUAP
> > enabled") redefines __clear_user as inline function but does not remove
> > the export.
> >
> > Fixes: 452e2a83ea23 ("powerpc: Fix __clear_user() with KUAP enabled")
> >
> > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > ---
> >  arch/powerpc/lib/ppc_ksyms.c | 1 -
> >  1 file changed, 1 deletion(-)
> 
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>

Now applied, thanks.

greg k-h
