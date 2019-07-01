Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9DA5BE19
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 16:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbfGAOXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 10:23:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43133 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727064AbfGAOXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 10:23:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E6ACD201E3;
        Mon,  1 Jul 2019 10:23:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Jul 2019 10:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=H1pZkxGJxT7YEDKGRkgZyA111gn
        1xcFQ7CDnOQ8M8OE=; b=eiJ5ldC9P5yOyQ8gOP4ZENf7SalJzJ9qxRt1JZVER/R
        ZErg6ZDcqIf7Jk8Oaz+ZsE9tCFZi9Bm4zuODdwg3hCetNMqoFkLUD7AIsSVns+ez
        d1E2BNtDUnrUmVrMROMLS0/vHrRTINZCyqzf7RJGMkqUxYoM+jVfqUT8bCzv1JKN
        l959hYzwXRI2VOkseQeH6z7NeTa5+nFlr98Md4rAcaz2eM0UiabeBkbOy8iEtDtN
        IjJvlhLePEZ1eobQmLaDifSfpKPRScb9IjE/mnhWS6vtrP35hfGq19fj6OG8VuNV
        TSrlpt14JkDjF/cjEUP3TGRJkqKLb8cT1ScktB0liug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=H1pZkx
        GJxT7YEDKGRkgZyA111gn1xcFQ7CDnOQ8M8OE=; b=IG6z0MeHfn96dN0qdqneJi
        tjOyECiBaGeRJoNTaayd0HnwadI2dkc0TvFt7SqI3swlK80POlsIdIpdW2k8zzPp
        f/likBQ76elgGuK9JRegKGW8fd/qM/yFoU/bnb7Dp4tzjxJJo5pEweD75nONxNBx
        ko3Ukh04r0UZfalRCHNPD44btdKWOZErA+eh8kjFnUEhV8PA81EupOe3Tbhamho7
        /uTg8gw96ehircoEg0hFY3RV+ZFrQqH2oCBNb/gLBWs+sZWZMTa+BoCmz5an9k55
        QFcZlXP1fPaVvKHqK86Ls5SWXLETQ/e8MXfPh5rSwrc6kg0NuUbbNuPaLHEy1WjQ
        ==
X-ME-Sender: <xms:TRcaXTQNzMJzeKD3x-xsHee8sD3MZH2XUkHRlLr0_TbHoJGyYocUgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefvrghkrghs
    hhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdrjh
    hpqeenucfkphepudegrdefrdejhedrudekudenucfrrghrrghmpehmrghilhhfrhhomhep
    ohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjphenucevlhhushhtvghrufhiii
    gvpedt
X-ME-Proxy: <xmx:ThcaXUXuVSicVPVqAKINrzuUbjPiOm6TvRwn3YWTV3i9YKqClwxFMw>
    <xmx:ThcaXfTBxI1UyD3yMxupCkIokY9CRnvTZcTWoBBXn_nkKzxp9WvJKQ>
    <xmx:ThcaXSmbwwmVVpuJimsMtrWCcVKpbqzutZu7jQgXmN_6w3ohetFK8w>
    <xmx:ThcaXeAqP3ThUyZYLk0zPvMALPfPBawiR2S93Rn6EjU7DAy_kTUszg>
Received: from workstation (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2514A38008C;
        Mon,  1 Jul 2019 10:23:07 -0400 (EDT)
Date:   Mon, 1 Jul 2019 23:23:05 +0900
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: firewire-lib/fireworks: fix miss detection of
 received MIDI messages
Message-ID: <20190701142304.GA18769@workstation>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>, clemens@ladisch.de,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20190701105927.13998-1-o-takashi@sakamocchi.jp>
 <s5hk1d16dw5.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk1d16dw5.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 01, 2019 at 04:14:02PM +0200, Takashi Iwai wrote:
> On Mon, 01 Jul 2019 12:59:27 +0200,
> Takashi Sakamoto wrote:
> > 
> > In IEC 61883-6, 8 MIDI data streams are multiplexed into single
> > MIDI conformant data channel. The index of stream is calculated by
> > modulo 8 of the value of data block counter.
> > 
> > In fireworks, the value of data block counter in CIP header has a quirk
> > with firmware version v5.0.0, v5.7.3 and v5.8.0. This brings ALSA
> > IEC 61883-1/6 packet streaming engine to miss detection of MIDI
> > messages.
> > 
> > This commit fixes the miss detection to modify the value of data block
> > counter for the modulo calculation.
> > 
> > For maintainers, this bug exists since a commit 18f5ed365d3f ("ALSA:
> > fireworks/firewire-lib: add support for recent firmware quirk") in Linux
> > kernel v4.2. There're many changes since the commit.  This fix can be
> > backported to Linux kernel v4.4 or later. I tagged a base commit to the
> > backport for your convenience.
> > 
> > Besides, my work for Linux kernel v5.3 brings heavy code refactoring and
> > some structure members are renamed in 'sound/firewire/amdtp-stream.h'.
> > The content of this patch brings conflict when merging -rc tree with
> > this patch to the latest tree. I request maintainers to solve the
> > conflict by replacing 'tx_first_dbc' with 'ctx_data.tx.first_dbc'.
> > 
> > Fixes: df075feefbd3 ("ALSA: firewire-lib: complete AM824 data block processing layer")
> > Cc: <stable@vger.kernel.org> # v4.4+
> > Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> 
> Thanks, applied.

Thanks for your application, however I found my mistake in this patch.
Would you please reset your application if possible?

diff --git a/sound/firewire/amdtp-am824.c b/sound/firewire/amdtp-am824.c
index 4210e5c6262e..4d677fcb4fc2 100644
--- a/sound/firewire/amdtp-am824.c
+++ b/sound/firewire/amdtp-am824.c
@@ -321,6 +321,7 @@ static void read_midi_messages(struct amdtp_stream *s,
        u8 *b;
 
        for (f = 0; f < frames; f++) {
+               port = (8 - s->tx_first_dbc + s->data_block_counter + f) % 8;
                port = (s->data_block_counter + f) % 8;
                b = (u8 *)&buffer[p->midi_position];

Just inserting the above line has no meaning itself...


Thanks

Takashi Sakamoto

