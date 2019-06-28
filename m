Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29075A7CC
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 01:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfF1X4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 19:56:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59335 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbfF1X4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 19:56:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1AE1D21FC1;
        Fri, 28 Jun 2019 19:56:41 -0400 (EDT)
Received: from imap5 ([10.202.2.55])
  by compute1.internal (MEProxy); Fri, 28 Jun 2019 19:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=mime-version:message-id:in-reply-to:references:date:from:to
        :cc:subject:content-type:content-transfer-encoding; s=fm1; bh=Oa
        DVBcKJfCsMzRWtHv3C09/Abj/G6upXMBKiCQzcAKQ=; b=Jp1A+Cfid2vh2CYlsJ
        OJbYxjYzY9fiLYs3JNd5JMj3xeV1dnl+l25z1aZE+NL3KQ2b5XsBnT0+qcdagjXQ
        G4REtKO1nrRGjT14Iub67JdusVlkcJC4/ApmG718Pr+bkJUK6gPQM/jgMvHxbMlE
        WPaij12UNJf133u0ZROYRupjBr37S1ZP8Y2qosH7xtfThUdaSCCBumgALehighaB
        Nu17jbOTD59o3fY3YBg//6xxj8B7P1FBNyoLFBrc7vrJweERngdstFmilO2IUip3
        3TOHwXrCbnSb9c2BXygB+d//QjAefhhwcbc9z6BeaFQRX/Sgy1EM0cJWFB0egyeq
        X3ew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=OaDVBcKJfCsMzRWtHv3C09/Abj/G6upXMBKiCQzcA
        KQ=; b=SvnKLpQcUNxgpfbo+UJZqavhrEzu984NWIvXJi3N7El1PekCxgaKxQ9Gc
        cfmAPqdTeaN1LCZzTw+PmJpueH6eo/gcKR1nkWIL3ci/OALwLKZawXAqHGpslQ47
        164YV7GjOYq6rcNDO0oGAEL768enZZnkdSFeAcycYERfpXACSD4Nx6Fy53uHAdRs
        0Na7FLpzNc+l5V4UnUq9k21uGq4SfNdxr/E0AW9mypWXvsMQOS/d5wfcLnAmFTgX
        eDsfgQzN+hW4GIjWPlzXhEbwVINOoyvnwrN/k0J7ZxX6pfO1k2aiqxAf2IzjdAY3
        199b/ZMrDSOi3+UnQ8JcZoWVjOkGw==
X-ME-Sender: <xms:OKkWXd8VyNi6xZVvoNclCH-0wr5PUXry1QPXyt5HzknYbOk5sssl7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvddugddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdfvrghk
    rghshhhiucfurghkrghmohhtohdfuceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthh
    hirdhjpheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfrrghrrghmpehmrghi
    lhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjphenucevlhhush
    htvghrufhiiigvpedt
X-ME-Proxy: <xmx:OKkWXeCWFl66T3c9Lqlb6r95v--ANyCDrJdCLivlQzH_EoemXKJ-3Q>
    <xmx:OKkWXdyGqsBItckj0Bwm_LZwdKiFW81WTJW-KyiNiFJFPAxGaLjU2Q>
    <xmx:OKkWXTSzKDG6llV3arB_oHmkBwAJ23dW7WeV2mx7v3x6vRiAtnZXDg>
    <xmx:OakWXVsABz8H975Si-h8ynGysYoTJT70gTTYk73P3-D2dYlMaRc4BQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 15E2D5C0099; Fri, 28 Jun 2019 19:56:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.6-731-g19d3b16-fmstable-20190627v1
Mime-Version: 1.0
Message-Id: <14b3cbbc-3ea2-4037-9174-24bbf0ecd6e2@www.fastmail.com>
In-Reply-To: <s5h1rzd7m0b.wl-tiwai@suse.de>
References: <20190628052158.27693-1-o-takashi@sakamocchi.jp>
 <s5ho92i6qhi.wl-tiwai@suse.de>
 <bd65234a-9963-4e25-938f-1e79b053c4e1@www.fastmail.com>
 <s5h1rzd7m0b.wl-tiwai@suse.de>
Date:   Fri, 28 Jun 2019 23:56:33 +0900
From:   "Takashi Sakamoto" <o-takashi@sakamocchi.jp>
To:     "Takashi Iwai" <tiwai@suse.de>
Cc:     "Clemens Ladisch" <clemens@ladisch.de>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: =?UTF-8?Q?Re:_[PATCH]_ALSA:_firewire-lib/fireworks:_fix_miss_detection_o?=
 =?UTF-8?Q?f_received_MIDI_messages?=
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Jun 29, 2019, at 00:44, Takashi Iwai wrote:
> On Fri, 28 Jun 2019 09:34:00 +0200,
> Takashi Sakamoto wrote:
> >=20
> > Hi,
> >=20
> > On Fri, Jun 28, 2019, at 17:53, Takashi Iwai wrote:
> > > On Fri, 28 Jun 2019 07:21:58 +0200,
> > > Takashi Sakamoto wrote:
> > > >=20
> > > > In IEC 61883-6, 8 MIDI data streams are multiplexed into single
> > > > MIDI conformant data channel. The index of stream is calculated =
by
> > > > modulo 8 of the value of data block counter.
> > > >=20
> > > > In fireworks, the value of data block counter in CIP header has =
a quirk
> > > > with firmware version v5.0.0, v5.7.3 and v5.8.0. This brings ALS=
A
> > > > IEC 61883-1/6 packet streaming engine to miss detection of MIDI
> > > > messages.
> > > >=20
> > > > This commit fixes the miss detection to modify the value of data=
 block
> > > > counter for the modulo calculation.
> > > >=20
> > > > For maintainers, this bug exists since a commit 18f5ed365d3f ("A=
LSA:
> > > > fireworks/firewire-lib: add support for recent firmware quirk") =
in Linux
> > > > kernel v4.2. There're many changes since the commit.  This fix c=
an be
> > > > backported to Linux kernel v4.4 or later. I tagged a base commit=
 to the
> > > > backport for your convenience.
> > > >=20
> > > > Fixes: df075feefbd3 ("ALSA: firewire-lib: complete AM824 data bl=
ock processing layer")
> > > > Cc: <stable@vger.kernel.org> # v4.4+
> > > > Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> > >=20
> > > This doesn't seem applicable to the latest 5.2-rc tree due to your=

> > > recent refactoring.  Could you resubmit the fix for 5.2?  I'll res=
olve
> > > the merge conflict in my side.
> >=20
> > Mmm. Do you actually encounter any conflict when applying this patch=
 to
> > your v5.2 tree?
> >=20
> > This patch includes changes for `sound/firewire/amdtp-am824.c`. On t=
he other
> > hand, my recent work is mainly for `sound/firewire/amdtp-stream.c`. =
Actually,
> > the last change for `amdtp-am824.c` was done 2017-10-25.
> > https://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git/log/=
sound/firewire/amdtp-am824.c?h=3Dfor-linus
>=20
> It's not about file conflicts but the compilation fails after the
> patch.
> sound/firewire/amdtp-am824.c: In function =E2=80=98read_midi_messages=E2=
=80=99:
> sound/firewire/amdtp-am824.c:324:16: error: =E2=80=98struct amdtp_stre=
am=E2=80=99 has=20
> no member named =E2=80=98ctx_data=E2=80=99
>    port =3D (8 - s->ctx_data.tx.first_dbc + s->data_block_counter + f)=
 %=20
> 8;
>                 ^~

Oops, now I got it... I just checked its application but should have had=

compile test with old trees.

But I'm in short vacation. The revised patch will be posted next Monday,=

sorry.


Thanks

Takashi Sakamoto
