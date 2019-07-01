Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530F45BE4E
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 16:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbfGAObU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 10:31:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34209 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728336AbfGAObU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 10:31:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id ADA4D22015;
        Mon,  1 Jul 2019 10:31:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Jul 2019 10:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=9b4duh/uvKh++eDW41sXnja/4R3
        uhnmB1qzSWWoYpJM=; b=Ad/LD/mFhp5VbsOVNkuznGBH91CUjbbsZr1yF1hbj2m
        6iAU+mOrJAfGk15ybtym/8qFzngJnMzEHVktB+g+zYgPhXZZAeF1M8VAjJJ9TPh5
        LUgKPJEfI3/23U5y8yL05BCvCi9V51bI6GmGuXV8Ryo9dtCGTUnwppqp67/fjWRp
        Ya6vw4kcpVjQNhiX4DHI5HbXkW32UeVxIEwJ+KdQ6gN/LPR5eBvWAOFeO1F+D9eO
        6ZrWHmpK5FPRrre5KByQjTIPbr2RpVk9W+9Kv0PHMPxU90hhJAijP3pVTiEbDw6C
        wmtHTrjJJO7UTjUd6pjH/3m46CrCmh5vvj2tJRjEi7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9b4duh
        /uvKh++eDW41sXnja/4R3uhnmB1qzSWWoYpJM=; b=1DRAUWhI/B6+t1wsejz0Fm
        87nOvBV0y78DY7dPCOzLvl3kHtUfk4erxCb3L5gRWOa7cl05df5EDol/URqr/PBZ
        UPSqq1p2Omn7PsWbJIq1B2LUxwZevkzE4LFTaDbmSd+uT3QpvH3CIKSNqbcLqvzw
        FPitZSxIizQ+n/NYpkkFLL87YMx6S1O1R6QadlWgeopH1TV+o7E0q1xvo2qATx4+
        uKzywtEcr/U54VUIzfyOiOzTyN/lw/H0mY7wk+jbZlRILcXsfyAO3PWBfILC3MrE
        gmCg6s9lMfOxFi4LPk48nSVPQu3HrLcVSiiUB3W9apyCcBpVngToF6mh8emtLvGA
        ==
X-ME-Sender: <xms:NhkaXXxchu1qZWLFwJTGgDJTYgsw0n0_3PADOXx7G-K_UaHIdCzQmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefvrghkrghs
    hhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdrjh
    hpqeenucfkphepudegrdefrdejhedrudekudenucfrrghrrghmpehmrghilhhfrhhomhep
    ohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjphenucevlhhushhtvghrufhiii
    gvpedt
X-ME-Proxy: <xmx:NhkaXfs7R9cBoIgz16NH9RZQWFxR-MGbskDHRSGU6VG9cK_sIH6OjQ>
    <xmx:NhkaXRF8f_8JLVELfjiEkcFK3h2CezOyMjYHH5iBLKKIjjWRDXQ96A>
    <xmx:NhkaXd7o_Mas3cs2yTRrJ1ZzckrJOb7lbtCYAtrX4ta7JLqCKrcOgQ>
    <xmx:NxkaXZX49vzX3FlyJnoIIPgmfvhh1twb2qI0JBpGzoW_P5iMKngUbg>
Received: from workstation (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id B483280076;
        Mon,  1 Jul 2019 10:31:16 -0400 (EDT)
Date:   Mon, 1 Jul 2019 23:31:12 +0900
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: firewire-lib/fireworks: fix miss detection of
 received MIDI messages
Message-ID: <20190701143111.GA28103@workstation>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>, clemens@ladisch.de,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20190701105927.13998-1-o-takashi@sakamocchi.jp>
 <s5hk1d16dw5.wl-tiwai@suse.de>
 <20190701142304.GA18769@workstation>
 <s5hh8856das.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hh8856das.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Jul 01, 2019 at 04:26:51PM +0200, Takashi Iwai wrote:
> On Mon, 01 Jul 2019 16:23:05 +0200,
> Takashi Sakamoto wrote:
> > 
> > On Mon, Jul 01, 2019 at 04:14:02PM +0200, Takashi Iwai wrote:
> > > On Mon, 01 Jul 2019 12:59:27 +0200,
> > > Takashi Sakamoto wrote:
> > > > 
> > > > In IEC 61883-6, 8 MIDI data streams are multiplexed into single
> > > > MIDI conformant data channel. The index of stream is calculated by
> > > > modulo 8 of the value of data block counter.
> > > > 
> > > > In fireworks, the value of data block counter in CIP header has a quirk
> > > > with firmware version v5.0.0, v5.7.3 and v5.8.0. This brings ALSA
> > > > IEC 61883-1/6 packet streaming engine to miss detection of MIDI
> > > > messages.
> > > > 
> > > > This commit fixes the miss detection to modify the value of data block
> > > > counter for the modulo calculation.
> > > > 
> > > > For maintainers, this bug exists since a commit 18f5ed365d3f ("ALSA:
> > > > fireworks/firewire-lib: add support for recent firmware quirk") in Linux
> > > > kernel v4.2. There're many changes since the commit.  This fix can be
> > > > backported to Linux kernel v4.4 or later. I tagged a base commit to the
> > > > backport for your convenience.
> > > > 
> > > > Besides, my work for Linux kernel v5.3 brings heavy code refactoring and
> > > > some structure members are renamed in 'sound/firewire/amdtp-stream.h'.
> > > > The content of this patch brings conflict when merging -rc tree with
> > > > this patch to the latest tree. I request maintainers to solve the
> > > > conflict by replacing 'tx_first_dbc' with 'ctx_data.tx.first_dbc'.
> > > > 
> > > > Fixes: df075feefbd3 ("ALSA: firewire-lib: complete AM824 data block processing layer")
> > > > Cc: <stable@vger.kernel.org> # v4.4+
> > > > Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> > > 
> > > Thanks, applied.
> > 
> > Thanks for your application, however I found my mistake in this patch.
> > Would you please reset your application if possible?
> > 
> > diff --git a/sound/firewire/amdtp-am824.c b/sound/firewire/amdtp-am824.c
> > index 4210e5c6262e..4d677fcb4fc2 100644
> > --- a/sound/firewire/amdtp-am824.c
> > +++ b/sound/firewire/amdtp-am824.c
> > @@ -321,6 +321,7 @@ static void read_midi_messages(struct amdtp_stream *s,
> >         u8 *b;
> >  
> >         for (f = 0; f < frames; f++) {
> > +               port = (8 - s->tx_first_dbc + s->data_block_counter + f) % 8;
> >                 port = (s->data_block_counter + f) % 8;
> >                 b = (u8 *)&buffer[p->midi_position];
> > 
> > Just inserting the above line has no meaning itself...
> 
> Ah yes.  OK, will reset the repo.  Please resubmit the fix patch.

Thanks for your accepting the reset. I'm ease to hear it ;)
I'll post the revised patch later with enough pre-check.


Thanks

Takashi Sakamoto
