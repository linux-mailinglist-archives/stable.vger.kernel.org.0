Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951EC2E6C26
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgL1Wzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729307AbgL1Tjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 14:39:49 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2393C0613D6
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 11:39:08 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t30so12368965wrb.0
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 11:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=tuxgCjWr2SCGe2c7kGptUhkBczAcIu2qPyCk7PQpq9w=;
        b=P6uG7lMz/lsq100xdnh1NfaaANHAmNQPIxyWLxvjgRHI9aL9+3BU2bsCES10KQH3Tq
         XSDx0U2nbDmmqYMOnwy7Q8w9fQ3J9C3olPoH8hdP/JPrJF6bjssgW06u/w1l4UIWmRc7
         r8XuOWh5ekNDUjbwFZDANzTDxz3X2mHPam8mt2oN0Mi9yFu/ASFxmRM8nDKeSTe50XLs
         87DrdhN6Vocdd0f9GANYtFty/kQFiBvWjhKb7eS9Gq/T87gh4QmK81WcbOOY1IrDXFp5
         bNgUrYQJhhfVH55x6YTRKPx8OWV1NfMrMU3aBMlzOBEj3WOzDdMP6lFAEBqCzOyMtCST
         ZMMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=tuxgCjWr2SCGe2c7kGptUhkBczAcIu2qPyCk7PQpq9w=;
        b=dXUcXHXY00CzR9nxBg+zaMqLi9QPIMxLPiKQLaVTk2PBTIo2spxxcqRvIlzSrG07QC
         LL88sgwDqwfJSx60hBm31xor3TBXsbexjjPlpRjpMynM6AoUp5RY0YmUB34t9dtaAZTA
         hnIlRbfdfJySv0KejSRdnbm3NiZFN7SZBgK1LFn22UkbPUR8roruZxmmnuz7m1fk+Mfk
         5gHOQovHM+Sa6nYw4g9DkkbsdLBR5ZvD/w2MI9eoQUw/PgARt3S+KLK+eS2iftpGDLOU
         ULmTi10v3+Pq9TOF9G5l+3HRgR/4c4tSt6iVzRuJYVJyo138vppkor5EhCAjKMmRYDp2
         ShFw==
X-Gm-Message-State: AOAM532gbK3gWnqJHdhyyE7J791Jnuwd1nPQI/G5v3K6wejoXYuLkjau
        Dy4nO5ETyBM/5/+CjMsfjTQMf0YXeJYeprvl
X-Google-Smtp-Source: ABdhPJxJ8DI63xy1Het14rv/RBegRE5ALP82YxjSWzx12voI0FllhB14sL6pJ7TORal6anIG06k66A==
X-Received: by 2002:adf:e511:: with SMTP id j17mr51867326wrm.416.1609184347323;
        Mon, 28 Dec 2020 11:39:07 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id h83sm431780wmf.9.2020.12.28.11.39.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Dec 2020 11:39:05 -0800 (PST)
Date:   Mon, 28 Dec 2020 19:39:04 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Alberto Aguirre <albaguirre@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Kailang Yang <kailang@realtek.com>,
        Hui Wang <hui.wang@canonical.com>
Subject: missing alsa fixes for 4.14-stable, 4.9-stable and 4.4-stable
Message-ID: <20201228193904.o625t6ex7b52rpkd@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xn6biy3bc7yrnvte"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xn6biy3bc7yrnvte
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

Few missing alsa fixes for 4.14-stable, 4.9-stable and 4.4-stable.

42fb6b1d41eb ("ALSA: hda/ca0132 - Fix work handling in delayed HP detection")

103e9625647a ("ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk")
only needed to make backporting of '5d1b71226dc4' easier otherwise the change
had to done in all the separate error paths.

5d1b71226dc4 ("ALSA: usb-audio: fix sync-ep altsetting sanity check")

fcc6c877a01f ("ALSA: hda/realtek - Support Dell headset mode for ALC3271")
only needed for the backport of 'd5078193e56b'.

d5078193e56b ("ALSA: hda - Fix a wrong FIXUP for alc289 on Dell machines")

e1e8c1fdce8b ("ALSA: hda/realtek - Dell headphone has noise on unmute for
ALC236")


--
Regards
Sudip

--xn6biy3bc7yrnvte
Content-Type: application/mbox
Content-Disposition: attachment; filename="alsa_4.14-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 0defe48ec6f646b7ce3de59de47ed8f6c68f81d9 Mon Sep 17 00:00:00 2001=0A=
=46rom: Takashi Iwai <tiwai@suse.de>=0ADate: Fri, 13 Dec 2019 09:51:11 +010=
0=0ASubject: [PATCH 1/3] ALSA: hda/ca0132 - Fix work handling in delayed HP=
=0A detection=0A=0Acommit 42fb6b1d41eb5905d77c06cad2e87b70289bdb76 upstream=
=0A=0ACA0132 has the delayed HP jack detection code that is invoked from th=
e=0Aunsol handler, but it does a few weird things: it contains the cancel=
=0Aof a work inside the work handler, and yet it misses the cancel-sync=0Ac=
all at (runtime-)suspend.  This patch addresses those issues.=0A=0AFixes: 1=
5c2b3cc09a3 ("ALSA: hda/ca0132 - Fix possible workqueue stall")=0ACc: <stab=
le@vger.kernel.org>=0ALink: https://lore.kernel.org/r/20191213085111.22855-=
4-tiwai@suse.de=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0A[sudip: adj=
ust context]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A sound/pci/hda/patch_ca0132.c | 16 ++++++++++++++--=0A 1 file chan=
ged, 14 insertions(+), 2 deletions(-)=0A=0Adiff --git a/sound/pci/hda/patch=
_ca0132.c b/sound/pci/hda/patch_ca0132.c=0Aindex 92f5f452bee2..369f812d7072=
 100644=0A--- a/sound/pci/hda/patch_ca0132.c=0A+++ b/sound/pci/hda/patch_ca=
0132.c=0A@@ -4443,11 +4443,10 @@ static void hp_callback(struct hda_codec *=
codec, struct hda_jack_callback *cb)=0A 	/* Delay enabling the HP amp, to l=
et the mic-detection=0A 	 * state machine run.=0A 	 */=0A-	cancel_delayed_w=
ork(&spec->unsol_hp_work);=0A-	schedule_delayed_work(&spec->unsol_hp_work, =
msecs_to_jiffies(500));=0A 	tbl =3D snd_hda_jack_tbl_get(codec, cb->nid);=
=0A 	if (tbl)=0A 		tbl->block_report =3D 1;=0A+	schedule_delayed_work(&spec=
->unsol_hp_work, msecs_to_jiffies(500));=0A }=0A =0A static void amic_callb=
ack(struct hda_codec *codec, struct hda_jack_callback *cb)=0A@@ -4625,12 +4=
624,25 @@ static void ca0132_free(struct hda_codec *codec)=0A 	kfree(codec-=
>spec);=0A }=0A =0A+#ifdef CONFIG_PM=0A+static int ca0132_suspend(struct hd=
a_codec *codec)=0A+{=0A+	struct ca0132_spec *spec =3D codec->spec;=0A+=0A+	=
cancel_delayed_work_sync(&spec->unsol_hp_work);=0A+	return 0;=0A+}=0A+#endi=
f=0A+=0A static const struct hda_codec_ops ca0132_patch_ops =3D {=0A 	.buil=
d_controls =3D ca0132_build_controls,=0A 	.build_pcms =3D ca0132_build_pcms=
,=0A 	.init =3D ca0132_init,=0A 	.free =3D ca0132_free,=0A 	.unsol_event =
=3D snd_hda_jack_unsol_event,=0A+#ifdef CONFIG_PM=0A+	.suspend =3D ca0132_s=
uspend,=0A+#endif=0A };=0A =0A static void ca0132_config(struct hda_codec *=
codec)=0A-- =0A2.11.0=0A=0A=0AFrom 4c17735761a8284bea106e07fe8b3683ccc9f772=
 Mon Sep 17 00:00:00 2001=0AFrom: Alberto Aguirre <albaguirre@gmail.com>=0A=
Date: Wed, 18 Apr 2018 09:35:34 -0500=0ASubject: [PATCH 2/3] ALSA: usb-audi=
o: simplify set_sync_ep_implicit_fb_quirk=0A=0Acommit 103e9625647ad74d201e2=
6fb74afcd8479142a37 upstream=0A=0ASigned-off-by: Alberto Aguirre <albaguirr=
e@gmail.com>=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0ASigned-off-by:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/usb/pcm.c | 52=
 ++++++++++++++++++++--------------------------------=0A 1 file changed, 20=
 insertions(+), 32 deletions(-)=0A=0Adiff --git a/sound/usb/pcm.c b/sound/u=
sb/pcm.c=0Aindex 6caf94581a0e..936235f828c3 100644=0A--- a/sound/usb/pcm.c=
=0A+++ b/sound/usb/pcm.c=0A@@ -324,6 +324,7 @@ static int set_sync_ep_impli=
cit_fb_quirk(struct snd_usb_substream *subs,=0A 	struct usb_host_interface =
*alts;=0A 	struct usb_interface *iface;=0A 	unsigned int ep;=0A+	unsigned i=
nt ifnum;=0A =0A 	/* Implicit feedback sync EPs consumers are always playba=
ck EPs */=0A 	if (subs->direction !=3D SNDRV_PCM_STREAM_PLAYBACK)=0A@@ -334=
,44 +335,23 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb_subs=
tream *subs,=0A 	case USB_ID(0x0763, 0x2031): /* M-Audio Fast Track C600 */=
=0A 	case USB_ID(0x22f0, 0x0006): /* Allen&Heath Qu-16 */=0A 		ep =3D 0x81;=
=0A-		iface =3D usb_ifnum_to_if(dev, 3);=0A-=0A-		if (!iface || iface->num_=
altsetting =3D=3D 0)=0A-			return -EINVAL;=0A-=0A-		alts =3D &iface->altset=
ting[1];=0A-		goto add_sync_ep;=0A-		break;=0A+		ifnum =3D 3;=0A+		goto add=
_sync_ep_from_ifnum;=0A 	case USB_ID(0x0763, 0x2080): /* M-Audio FastTrack =
Ultra */=0A 	case USB_ID(0x0763, 0x2081):=0A 		ep =3D 0x81;=0A-		iface =3D =
usb_ifnum_to_if(dev, 2);=0A-=0A-		if (!iface || iface->num_altsetting =3D=
=3D 0)=0A-			return -EINVAL;=0A-=0A-		alts =3D &iface->altsetting[1];=0A-		=
goto add_sync_ep;=0A-	case USB_ID(0x2466, 0x8003):=0A+		ifnum =3D 2;=0A+		g=
oto add_sync_ep_from_ifnum;=0A+	case USB_ID(0x2466, 0x8003): /* Fractal Aud=
io Axe-Fx II */=0A 		ep =3D 0x86;=0A-		iface =3D usb_ifnum_to_if(dev, 2);=
=0A-=0A-		if (!iface || iface->num_altsetting =3D=3D 0)=0A-			return -EINVA=
L;=0A-=0A-		alts =3D &iface->altsetting[1];=0A-		goto add_sync_ep;=0A-	case=
 USB_ID(0x1397, 0x0002):=0A+		ifnum =3D 2;=0A+		goto add_sync_ep_from_ifnum=
;=0A+	case USB_ID(0x1397, 0x0002): /* Behringer UFX1204 */=0A 		ep =3D 0x81=
;=0A-		iface =3D usb_ifnum_to_if(dev, 1);=0A-=0A-		if (!iface || iface->num=
_altsetting =3D=3D 0)=0A-			return -EINVAL;=0A-=0A-		alts =3D &iface->altse=
tting[1];=0A-		goto add_sync_ep;=0A-=0A+		ifnum =3D 1;=0A+		goto add_sync_e=
p_from_ifnum;=0A 	}=0A+=0A 	if (attr =3D=3D USB_ENDPOINT_SYNC_ASYNC &&=0A 	=
    altsd->bInterfaceClass =3D=3D USB_CLASS_VENDOR_SPEC &&=0A 	    altsd->b=
InterfaceProtocol =3D=3D 2 &&=0A@@ -386,6 +366,14 @@ static int set_sync_ep=
_implicit_fb_quirk(struct snd_usb_substream *subs,=0A 	/* No quirk */=0A 	r=
eturn 0;=0A =0A+add_sync_ep_from_ifnum:=0A+	iface =3D usb_ifnum_to_if(dev, =
ifnum);=0A+=0A+	if (!iface || iface->num_altsetting =3D=3D 0)=0A+		return -=
EINVAL;=0A+=0A+	alts =3D &iface->altsetting[1];=0A+=0A add_sync_ep:=0A 	sub=
s->sync_endpoint =3D snd_usb_add_endpoint(subs->stream->chip,=0A 						   a=
lts, ep, !subs->direction,=0A-- =0A2.11.0=0A=0A=0AFrom 7a263914302b5145e466=
4917b4537e54debc0afe Mon Sep 17 00:00:00 2001=0AFrom: Johan Hovold <johan@k=
ernel.org>=0ADate: Tue, 14 Jan 2020 09:39:53 +0100=0ASubject: [PATCH 3/3] A=
LSA: usb-audio: fix sync-ep altsetting sanity check=0A=0Acommit 5d1b71226dc=
4d44b4b65766fa9d74492f9d4587b upstream=0A=0AThe altsetting sanity check in =
set_sync_ep_implicit_fb_quirk() was=0Achecking for there to be at least one=
 altsetting but then went on to=0Aaccess the second one, which may not exis=
t.=0A=0AThis could lead to random slab data being used to initialise the sy=
nc=0Aendpoint in snd_usb_add_endpoint().=0A=0AFixes: c75a8a7ae565 ("ALSA: s=
nd-usb: add support for implicit feedback")=0AFixes: ca10a7ebdff1 ("ALSA: u=
sb-audio: FT C400 sync playback EP to capture EP")=0AFixes: 5e35dc0338d8 ("=
ALSA: usb-audio: add implicit fb quirk for Behringer UFX1204")=0AFixes: 17f=
08b0d9aaf ("ALSA: usb-audio: add implicit fb quirk for Axe-Fx II")=0AFixes:=
 103e9625647a ("ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk")=
=0ACc: stable <stable@vger.kernel.org>     # 3.5=0ASigned-off-by: Johan Hov=
old <johan@kernel.org>=0ALink: https://lore.kernel.org/r/20200114083953.110=
6-1-johan@kernel.org=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0ASigned=
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/usb/pc=
m.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git=
 a/sound/usb/pcm.c b/sound/usb/pcm.c=0Aindex 936235f828c3..ecdbdb26164e 100=
644=0A--- a/sound/usb/pcm.c=0A+++ b/sound/usb/pcm.c=0A@@ -369,7 +369,7 @@ s=
tatic int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,=0A =
add_sync_ep_from_ifnum:=0A 	iface =3D usb_ifnum_to_if(dev, ifnum);=0A =0A-	=
if (!iface || iface->num_altsetting =3D=3D 0)=0A+	if (!iface || iface->num_=
altsetting < 2)=0A 		return -EINVAL;=0A =0A 	alts =3D &iface->altsetting[1]=
;=0A-- =0A2.11.0=0A=0A
--xn6biy3bc7yrnvte
Content-Type: application/mbox
Content-Disposition: attachment; filename="alsa_4.9-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 85ba5f282e8d51a6f6ad799cf9b337d44fcc6c8e Mon Sep 17 00:00:00 2001=0A=
=46rom: Takashi Iwai <tiwai@suse.de>=0ADate: Fri, 13 Dec 2019 09:51:11 +010=
0=0ASubject: [PATCH 1/6] ALSA: hda/ca0132 - Fix work handling in delayed HP=
=0A detection=0A=0Acommit 42fb6b1d41eb5905d77c06cad2e87b70289bdb76 upstream=
=0A=0ACA0132 has the delayed HP jack detection code that is invoked from th=
e=0Aunsol handler, but it does a few weird things: it contains the cancel=
=0Aof a work inside the work handler, and yet it misses the cancel-sync=0Ac=
all at (runtime-)suspend.  This patch addresses those issues.=0A=0AFixes: 1=
5c2b3cc09a3 ("ALSA: hda/ca0132 - Fix possible workqueue stall")=0ACc: <stab=
le@vger.kernel.org>=0ALink: https://lore.kernel.org/r/20191213085111.22855-=
4-tiwai@suse.de=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0A[sudip: adj=
ust context]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A sound/pci/hda/patch_ca0132.c | 16 ++++++++++++++--=0A 1 file chan=
ged, 14 insertions(+), 2 deletions(-)=0A=0Adiff --git a/sound/pci/hda/patch=
_ca0132.c b/sound/pci/hda/patch_ca0132.c=0Aindex bf7593f234f6..c599730c7a3f=
 100644=0A--- a/sound/pci/hda/patch_ca0132.c=0A+++ b/sound/pci/hda/patch_ca=
0132.c=0A@@ -4443,11 +4443,10 @@ static void hp_callback(struct hda_codec *=
codec, struct hda_jack_callback *cb)=0A 	/* Delay enabling the HP amp, to l=
et the mic-detection=0A 	 * state machine run.=0A 	 */=0A-	cancel_delayed_w=
ork(&spec->unsol_hp_work);=0A-	schedule_delayed_work(&spec->unsol_hp_work, =
msecs_to_jiffies(500));=0A 	tbl =3D snd_hda_jack_tbl_get(codec, cb->nid);=
=0A 	if (tbl)=0A 		tbl->block_report =3D 1;=0A+	schedule_delayed_work(&spec=
->unsol_hp_work, msecs_to_jiffies(500));=0A }=0A =0A static void amic_callb=
ack(struct hda_codec *codec, struct hda_jack_callback *cb)=0A@@ -4625,12 +4=
624,25 @@ static void ca0132_free(struct hda_codec *codec)=0A 	kfree(codec-=
>spec);=0A }=0A =0A+#ifdef CONFIG_PM=0A+static int ca0132_suspend(struct hd=
a_codec *codec)=0A+{=0A+	struct ca0132_spec *spec =3D codec->spec;=0A+=0A+	=
cancel_delayed_work_sync(&spec->unsol_hp_work);=0A+	return 0;=0A+}=0A+#endi=
f=0A+=0A static const struct hda_codec_ops ca0132_patch_ops =3D {=0A 	.buil=
d_controls =3D ca0132_build_controls,=0A 	.build_pcms =3D ca0132_build_pcms=
,=0A 	.init =3D ca0132_init,=0A 	.free =3D ca0132_free,=0A 	.unsol_event =
=3D snd_hda_jack_unsol_event,=0A+#ifdef CONFIG_PM=0A+	.suspend =3D ca0132_s=
uspend,=0A+#endif=0A };=0A =0A static void ca0132_config(struct hda_codec *=
codec)=0A-- =0A2.11.0=0A=0A=0AFrom 0ee2cc6163ebfcfaa1a139f5b7d8b6c9ca6f6b7a=
 Mon Sep 17 00:00:00 2001=0AFrom: Alberto Aguirre <albaguirre@gmail.com>=0A=
Date: Wed, 18 Apr 2018 09:35:34 -0500=0ASubject: [PATCH 2/6] ALSA: usb-audi=
o: simplify set_sync_ep_implicit_fb_quirk=0A=0Acommit 103e9625647ad74d201e2=
6fb74afcd8479142a37 upstream=0A=0ASigned-off-by: Alberto Aguirre <albaguirr=
e@gmail.com>=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0ASigned-off-by:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/usb/pcm.c | 52=
 ++++++++++++++++++++--------------------------------=0A 1 file changed, 20=
 insertions(+), 32 deletions(-)=0A=0Adiff --git a/sound/usb/pcm.c b/sound/u=
sb/pcm.c=0Aindex 95d02e25a313..78826c3c50f8 100644=0A--- a/sound/usb/pcm.c=
=0A+++ b/sound/usb/pcm.c=0A@@ -324,6 +324,7 @@ static int set_sync_ep_impli=
cit_fb_quirk(struct snd_usb_substream *subs,=0A 	struct usb_host_interface =
*alts;=0A 	struct usb_interface *iface;=0A 	unsigned int ep;=0A+	unsigned i=
nt ifnum;=0A =0A 	/* Implicit feedback sync EPs consumers are always playba=
ck EPs */=0A 	if (subs->direction !=3D SNDRV_PCM_STREAM_PLAYBACK)=0A@@ -334=
,44 +335,23 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb_subs=
tream *subs,=0A 	case USB_ID(0x0763, 0x2031): /* M-Audio Fast Track C600 */=
=0A 	case USB_ID(0x22f0, 0x0006): /* Allen&Heath Qu-16 */=0A 		ep =3D 0x81;=
=0A-		iface =3D usb_ifnum_to_if(dev, 3);=0A-=0A-		if (!iface || iface->num_=
altsetting =3D=3D 0)=0A-			return -EINVAL;=0A-=0A-		alts =3D &iface->altset=
ting[1];=0A-		goto add_sync_ep;=0A-		break;=0A+		ifnum =3D 3;=0A+		goto add=
_sync_ep_from_ifnum;=0A 	case USB_ID(0x0763, 0x2080): /* M-Audio FastTrack =
Ultra */=0A 	case USB_ID(0x0763, 0x2081):=0A 		ep =3D 0x81;=0A-		iface =3D =
usb_ifnum_to_if(dev, 2);=0A-=0A-		if (!iface || iface->num_altsetting =3D=
=3D 0)=0A-			return -EINVAL;=0A-=0A-		alts =3D &iface->altsetting[1];=0A-		=
goto add_sync_ep;=0A-	case USB_ID(0x2466, 0x8003):=0A+		ifnum =3D 2;=0A+		g=
oto add_sync_ep_from_ifnum;=0A+	case USB_ID(0x2466, 0x8003): /* Fractal Aud=
io Axe-Fx II */=0A 		ep =3D 0x86;=0A-		iface =3D usb_ifnum_to_if(dev, 2);=
=0A-=0A-		if (!iface || iface->num_altsetting =3D=3D 0)=0A-			return -EINVA=
L;=0A-=0A-		alts =3D &iface->altsetting[1];=0A-		goto add_sync_ep;=0A-	case=
 USB_ID(0x1397, 0x0002):=0A+		ifnum =3D 2;=0A+		goto add_sync_ep_from_ifnum=
;=0A+	case USB_ID(0x1397, 0x0002): /* Behringer UFX1204 */=0A 		ep =3D 0x81=
;=0A-		iface =3D usb_ifnum_to_if(dev, 1);=0A-=0A-		if (!iface || iface->num=
_altsetting =3D=3D 0)=0A-			return -EINVAL;=0A-=0A-		alts =3D &iface->altse=
tting[1];=0A-		goto add_sync_ep;=0A-=0A+		ifnum =3D 1;=0A+		goto add_sync_e=
p_from_ifnum;=0A 	}=0A+=0A 	if (attr =3D=3D USB_ENDPOINT_SYNC_ASYNC &&=0A 	=
    altsd->bInterfaceClass =3D=3D USB_CLASS_VENDOR_SPEC &&=0A 	    altsd->b=
InterfaceProtocol =3D=3D 2 &&=0A@@ -386,6 +366,14 @@ static int set_sync_ep=
_implicit_fb_quirk(struct snd_usb_substream *subs,=0A 	/* No quirk */=0A 	r=
eturn 0;=0A =0A+add_sync_ep_from_ifnum:=0A+	iface =3D usb_ifnum_to_if(dev, =
ifnum);=0A+=0A+	if (!iface || iface->num_altsetting =3D=3D 0)=0A+		return -=
EINVAL;=0A+=0A+	alts =3D &iface->altsetting[1];=0A+=0A add_sync_ep:=0A 	sub=
s->sync_endpoint =3D snd_usb_add_endpoint(subs->stream->chip,=0A 						   a=
lts, ep, !subs->direction,=0A-- =0A2.11.0=0A=0A=0AFrom c84e7c55ad84787b2ee3=
24400c982de1a3656692 Mon Sep 17 00:00:00 2001=0AFrom: Johan Hovold <johan@k=
ernel.org>=0ADate: Tue, 14 Jan 2020 09:39:53 +0100=0ASubject: [PATCH 3/6] A=
LSA: usb-audio: fix sync-ep altsetting sanity check=0A=0Acommit 5d1b71226dc=
4d44b4b65766fa9d74492f9d4587b upstream=0A=0AThe altsetting sanity check in =
set_sync_ep_implicit_fb_quirk() was=0Achecking for there to be at least one=
 altsetting but then went on to=0Aaccess the second one, which may not exis=
t.=0A=0AThis could lead to random slab data being used to initialise the sy=
nc=0Aendpoint in snd_usb_add_endpoint().=0A=0AFixes: c75a8a7ae565 ("ALSA: s=
nd-usb: add support for implicit feedback")=0AFixes: ca10a7ebdff1 ("ALSA: u=
sb-audio: FT C400 sync playback EP to capture EP")=0AFixes: 5e35dc0338d8 ("=
ALSA: usb-audio: add implicit fb quirk for Behringer UFX1204")=0AFixes: 17f=
08b0d9aaf ("ALSA: usb-audio: add implicit fb quirk for Axe-Fx II")=0AFixes:=
 103e9625647a ("ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk")=
=0ACc: stable <stable@vger.kernel.org>     # 3.5=0ASigned-off-by: Johan Hov=
old <johan@kernel.org>=0ALink: https://lore.kernel.org/r/20200114083953.110=
6-1-johan@kernel.org=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0ASigned=
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/usb/pc=
m.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git=
 a/sound/usb/pcm.c b/sound/usb/pcm.c=0Aindex 78826c3c50f8..35594b3cd7c4 100=
644=0A--- a/sound/usb/pcm.c=0A+++ b/sound/usb/pcm.c=0A@@ -369,7 +369,7 @@ s=
tatic int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,=0A =
add_sync_ep_from_ifnum:=0A 	iface =3D usb_ifnum_to_if(dev, ifnum);=0A =0A-	=
if (!iface || iface->num_altsetting =3D=3D 0)=0A+	if (!iface || iface->num_=
altsetting < 2)=0A 		return -EINVAL;=0A =0A 	alts =3D &iface->altsetting[1]=
;=0A-- =0A2.11.0=0A=0A=0AFrom 0c4302d0c68ba128d23bfceb2edd296fdff0caf5 Mon =
Sep 17 00:00:00 2001=0AFrom: Kailang Yang <kailang@realtek.com>=0ADate: Thu=
, 29 Jun 2017 15:21:27 +0800=0ASubject: [PATCH 4/6] ALSA: hda/realtek - Sup=
port Dell headset mode for ALC3271=0A=0Acommit fcc6c877a01f83cbce1cca885ea6=
2df6a10d33c3 upstream=0A=0AAdd DELL4_MIC_NO_PRESENCE model.=0AAdd the pin c=
onfiguration value of this machine into the pin_quirk=0Atable to make DELL4=
_MIC_NO_PRESENCE apply to this machine.=0A=0ASigned-off-by: Kailang Yang <k=
ailang@realtek.com>=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0ASigned-=
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/pci/hda=
/patch_realtek.c | 16 ++++++++++++++++=0A 1 file changed, 16 insertions(+)=
=0A=0Adiff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_real=
tek.c=0Aindex 73acdd43bdc9..d39f79f63615 100644=0A--- a/sound/pci/hda/patch=
_realtek.c=0A+++ b/sound/pci/hda/patch_realtek.c=0A@@ -4896,6 +4896,7 @@ en=
um {=0A 	ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,=0A 	ALC269_FIXUP_DELL2_MIC_NO_=
PRESENCE,=0A 	ALC269_FIXUP_DELL3_MIC_NO_PRESENCE,=0A+	ALC269_FIXUP_DELL4_MI=
C_NO_PRESENCE,=0A 	ALC269_FIXUP_HEADSET_MODE,=0A 	ALC269_FIXUP_HEADSET_MODE=
_NO_HP_MIC,=0A 	ALC269_FIXUP_ASPIRE_HEADSET_MIC,=0A@@ -5199,6 +5200,16 @@ s=
tatic const struct hda_fixup alc269_fixups[] =3D {=0A 		.chained =3D true,=
=0A 		.chain_id =3D ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC=0A 	},=0A+	[ALC269_=
FIXUP_DELL4_MIC_NO_PRESENCE] =3D {=0A+		.type =3D HDA_FIXUP_PINS,=0A+		.v.p=
ins =3D (const struct hda_pintbl[]) {=0A+			{ 0x19, 0x01a1913c }, /* use as=
 headset mic, without its own jack detect */=0A+			{ 0x1b, 0x01a1913d }, /*=
 use as headphone mic, without its own jack detect */=0A+			{ }=0A+		},=0A+=
		.chained =3D true,=0A+		.chain_id =3D ALC269_FIXUP_HEADSET_MODE=0A+	},=0A=
 	[ALC269_FIXUP_HEADSET_MODE] =3D {=0A 		.type =3D HDA_FIXUP_FUNC,=0A 		.v.=
func =3D alc_fixup_headset_mode,=0A@@ -6267,6 +6278,11 @@ static const stru=
ct snd_hda_pin_quirk alc269_pin_fixup_tbl[] =3D {=0A 		{0x17, 0x90170110},=
=0A 		{0x1a, 0x03011020},=0A 		{0x21, 0x03211030}),=0A+	SND_HDA_PIN_QUIRK(0=
x10ec0299, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,=0A+		ALC225_=
STANDARD_PINS,=0A+		{0x12, 0xb7a60130},=0A+		{0x13, 0xb8a60140},=0A+		{0x17=
, 0x90170110}),=0A 	{}=0A };=0A =0A-- =0A2.11.0=0A=0A=0AFrom a496f4656b9fe2=
24f0fb41f4eec46f5d485ec9d9 Mon Sep 17 00:00:00 2001=0AFrom: Hui Wang <hui.w=
ang@canonical.com>=0ADate: Fri, 2 Mar 2018 13:05:36 +0800=0ASubject: [PATCH=
 5/6] ALSA: hda - Fix a wrong FIXUP for alc289 on Dell machines=0A=0Acommit=
 d5078193e56bb24f4593f00102a3b5e07bb84ee0 upstream=0A=0AWith the alc289, th=
e Pin 0x1b is Headphone-Mic, so we should assign=0AALC269_FIXUP_DELL4_MIC_N=
O_PRESENCE rather than=0AALC225_FIXUP_DELL1_MIC_NO_PRESENCE to it. And this=
 change is suggested=0Aby Kailang of Realtek and is verified on the machine=
=2E=0A=0AFixes: 3f2f7c553d07 ("ALSA: hda - Fix headset mic detection proble=
m for two Dell machines")=0ACc: Kailang Yang <kailang@realtek.com>=0ACc: <s=
table@vger.kernel.org>=0ASigned-off-by: Hui Wang <hui.wang@canonical.com>=
=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/pci/hda/patch_realtek.c | =
2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/sou=
nd/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c=0Aindex d39f79f6=
3615..8be404ff4b1e 100644=0A--- a/sound/pci/hda/patch_realtek.c=0A+++ b/sou=
nd/pci/hda/patch_realtek.c=0A@@ -6194,7 +6194,7 @@ static const struct snd_=
hda_pin_quirk alc269_pin_fixup_tbl[] =3D {=0A 		{0x12, 0x90a60120},=0A 		{0=
x14, 0x90170110},=0A 		{0x21, 0x0321101f}),=0A-	SND_HDA_PIN_QUIRK(0x10ec028=
9, 0x1028, "Dell", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE,=0A+	SND_HDA_PIN_QUIR=
K(0x10ec0289, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,=0A 		{0x1=
2, 0xb7a60130},=0A 		{0x14, 0x90170110},=0A 		{0x21, 0x04211020}),=0A-- =0A=
2.11.0=0A=0A=0AFrom 5b7f449afe48f36e545cf6583900862ddc56adee Mon Sep 17 00:=
00:00 2001=0AFrom: Kailang Yang <kailang@realtek.com>=0ADate: Tue, 26 Nov 2=
019 17:04:23 +0800=0ASubject: [PATCH 6/6] ALSA: hda/realtek - Dell headphon=
e has noise on unmute=0A for ALC236=0A=0Acommit e1e8c1fdce8b00fce08784d9d73=
8c60ebf598ebc upstream=0A=0Aheadphone have noise even the volume is very sm=
all.=0ALet it fill up pcbeep hidden register to default value.=0AThe issue =
was gone.=0A=0AFixes: 4344aec84bd8 ("ALSA: hda/realtek - New codec support =
for ALC256")=0AFixes: 736f20a70608 ("ALSA: hda/realtek - Add support for AL=
C236/ALC3204")=0ASigned-off-by: Kailang Yang <kailang@realtek.com>=0ACc: <s=
table@vger.kernel.org>=0ALink: https://lore.kernel.org/r/9ae47f23a64d4e41a9=
c81e263cd8a250@realtek.com=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0A=
[sudip: adjust context]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@=
gmail.com>=0A---=0A sound/pci/hda/patch_realtek.c | 7 +++++--=0A 1 file cha=
nged, 5 insertions(+), 2 deletions(-)=0A=0Adiff --git a/sound/pci/hda/patch=
_realtek.c b/sound/pci/hda/patch_realtek.c=0Aindex 8be404ff4b1e..720de64851=
0d 100644=0A--- a/sound/pci/hda/patch_realtek.c=0A+++ b/sound/pci/hda/patch=
_realtek.c=0A@@ -330,9 +330,7 @@ static void alc_fill_eapd_coef(struct hda_=
codec *codec)=0A 	case 0x10ec0225:=0A 	case 0x10ec0233:=0A 	case 0x10ec0235=
:=0A-	case 0x10ec0236:=0A 	case 0x10ec0255:=0A-	case 0x10ec0256:=0A 	case 0=
x10ec0257:=0A 	case 0x10ec0282:=0A 	case 0x10ec0283:=0A@@ -343,6 +341,11 @@=
 static void alc_fill_eapd_coef(struct hda_codec *codec)=0A 	case 0x10ec029=
9:=0A 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);=0A 		break;=0A+	case 0x1=
0ec0236:=0A+	case 0x10ec0256:=0A+		alc_write_coef_idx(codec, 0x36, 0x5757);=
=0A+		alc_update_coef_idx(codec, 0x10, 1<<9, 0);=0A+		break;=0A 	case 0x10e=
c0285:=0A 	case 0x10ec0293:=0A 		alc_update_coef_idx(codec, 0xa, 1<<13, 0);=
=0A-- =0A2.11.0=0A=0A
--xn6biy3bc7yrnvte
Content-Type: application/mbox
Content-Disposition: attachment; filename="alsa_4.4-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom bbd32080aa7a9dd69901fc82abbce72295d45f19 Mon Sep 17 00:00:00 2001=0A=
=46rom: Takashi Iwai <tiwai@suse.de>=0ADate: Fri, 13 Dec 2019 09:51:11 +010=
0=0ASubject: [PATCH 1/6] ALSA: hda/ca0132 - Fix work handling in delayed HP=
=0A detection=0A=0Acommit 42fb6b1d41eb5905d77c06cad2e87b70289bdb76 upstream=
=0A=0ACA0132 has the delayed HP jack detection code that is invoked from th=
e=0Aunsol handler, but it does a few weird things: it contains the cancel=
=0Aof a work inside the work handler, and yet it misses the cancel-sync=0Ac=
all at (runtime-)suspend.  This patch addresses those issues.=0A=0AFixes: 1=
5c2b3cc09a3 ("ALSA: hda/ca0132 - Fix possible workqueue stall")=0ACc: <stab=
le@vger.kernel.org>=0ALink: https://lore.kernel.org/r/20191213085111.22855-=
4-tiwai@suse.de=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0A[sudip: adj=
ust context]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A sound/pci/hda/patch_ca0132.c | 16 ++++++++++++++--=0A 1 file chan=
ged, 14 insertions(+), 2 deletions(-)=0A=0Adiff --git a/sound/pci/hda/patch=
_ca0132.c b/sound/pci/hda/patch_ca0132.c=0Aindex c05119a3e13b..366e0386e296=
 100644=0A--- a/sound/pci/hda/patch_ca0132.c=0A+++ b/sound/pci/hda/patch_ca=
0132.c=0A@@ -4443,11 +4443,10 @@ static void hp_callback(struct hda_codec *=
codec, struct hda_jack_callback *cb)=0A 	/* Delay enabling the HP amp, to l=
et the mic-detection=0A 	 * state machine run.=0A 	 */=0A-	cancel_delayed_w=
ork(&spec->unsol_hp_work);=0A-	schedule_delayed_work(&spec->unsol_hp_work, =
msecs_to_jiffies(500));=0A 	tbl =3D snd_hda_jack_tbl_get(codec, cb->nid);=
=0A 	if (tbl)=0A 		tbl->block_report =3D 1;=0A+	schedule_delayed_work(&spec=
->unsol_hp_work, msecs_to_jiffies(500));=0A }=0A =0A static void amic_callb=
ack(struct hda_codec *codec, struct hda_jack_callback *cb)=0A@@ -4625,12 +4=
624,25 @@ static void ca0132_free(struct hda_codec *codec)=0A 	kfree(codec-=
>spec);=0A }=0A =0A+#ifdef CONFIG_PM=0A+static int ca0132_suspend(struct hd=
a_codec *codec)=0A+{=0A+	struct ca0132_spec *spec =3D codec->spec;=0A+=0A+	=
cancel_delayed_work_sync(&spec->unsol_hp_work);=0A+	return 0;=0A+}=0A+#endi=
f=0A+=0A static struct hda_codec_ops ca0132_patch_ops =3D {=0A 	.build_cont=
rols =3D ca0132_build_controls,=0A 	.build_pcms =3D ca0132_build_pcms,=0A 	=
=2Einit =3D ca0132_init,=0A 	.free =3D ca0132_free,=0A 	.unsol_event =3D sn=
d_hda_jack_unsol_event,=0A+#ifdef CONFIG_PM=0A+	.suspend =3D ca0132_suspend=
,=0A+#endif=0A };=0A =0A static void ca0132_config(struct hda_codec *codec)=
=0A-- =0A2.11.0=0A=0A=0AFrom bc8ff87c5a896e67b24bee18af4b9bc7f9989bbb Mon S=
ep 17 00:00:00 2001=0AFrom: Alberto Aguirre <albaguirre@gmail.com>=0ADate: =
Wed, 18 Apr 2018 09:35:34 -0500=0ASubject: [PATCH 2/6] ALSA: usb-audio: sim=
plify set_sync_ep_implicit_fb_quirk=0A=0Acommit 103e9625647ad74d201e26fb74a=
fcd8479142a37 upstream=0A=0ASigned-off-by: Alberto Aguirre <albaguirre@gmai=
l.com>=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0A[sudip: adjust conte=
xt]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
sound/usb/pcm.c | 38 ++++++++++++++++----------------------=0A 1 file chang=
ed, 16 insertions(+), 22 deletions(-)=0A=0Adiff --git a/sound/usb/pcm.c b/s=
ound/usb/pcm.c=0Aindex 366813f1a5f8..a1f189c90d4a 100644=0A--- a/sound/usb/=
pcm.c=0A+++ b/sound/usb/pcm.c=0A@@ -324,6 +324,7 @@ static int set_sync_ep_=
implicit_fb_quirk(struct snd_usb_substream *subs,=0A 	struct usb_host_inter=
face *alts;=0A 	struct usb_interface *iface;=0A 	unsigned int ep;=0A+	unsig=
ned int ifnum;=0A =0A 	/* Implicit feedback sync EPs consumers are always p=
layback EPs */=0A 	if (subs->direction !=3D SNDRV_PCM_STREAM_PLAYBACK)=0A@@=
 -334,34 +335,19 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb=
_substream *subs,=0A 	case USB_ID(0x0763, 0x2031): /* M-Audio Fast Track C6=
00 */=0A 	case USB_ID(0x22f0, 0x0006): /* Allen&Heath Qu-16 */=0A 		ep =3D =
0x81;=0A-		iface =3D usb_ifnum_to_if(dev, 3);=0A-=0A-		if (!iface || iface-=
>num_altsetting =3D=3D 0)=0A-			return -EINVAL;=0A-=0A-		alts =3D &iface->a=
ltsetting[1];=0A-		goto add_sync_ep;=0A-		break;=0A+		ifnum =3D 3;=0A+		got=
o add_sync_ep_from_ifnum;=0A 	case USB_ID(0x0763, 0x2080): /* M-Audio FastT=
rack Ultra */=0A 	case USB_ID(0x0763, 0x2081):=0A 		ep =3D 0x81;=0A-		iface=
 =3D usb_ifnum_to_if(dev, 2);=0A-=0A-		if (!iface || iface->num_altsetting =
=3D=3D 0)=0A-			return -EINVAL;=0A-=0A-		alts =3D &iface->altsetting[1];=0A=
-		goto add_sync_ep;=0A+		ifnum =3D 2;=0A+		goto add_sync_ep_from_ifnum;=0A=
 	case USB_ID(0x1397, 0x0002):=0A 		ep =3D 0x81;=0A-		iface =3D usb_ifnum_t=
o_if(dev, 1);=0A-=0A-		if (!iface || iface->num_altsetting =3D=3D 0)=0A-			=
return -EINVAL;=0A-=0A-		alts =3D &iface->altsetting[1];=0A-		goto add_sync=
_ep;=0A+		ifnum =3D 1;=0A+		goto add_sync_ep_from_ifnum;=0A 	}=0A+=0A 	if (=
attr =3D=3D USB_ENDPOINT_SYNC_ASYNC &&=0A 	    altsd->bInterfaceClass =3D=
=3D USB_CLASS_VENDOR_SPEC &&=0A 	    altsd->bInterfaceProtocol =3D=3D 2 &&=
=0A@@ -376,6 +362,14 @@ static int set_sync_ep_implicit_fb_quirk(struct snd=
_usb_substream *subs,=0A 	/* No quirk */=0A 	return 0;=0A =0A+add_sync_ep_f=
rom_ifnum:=0A+	iface =3D usb_ifnum_to_if(dev, ifnum);=0A+=0A+	if (!iface ||=
 iface->num_altsetting =3D=3D 0)=0A+		return -EINVAL;=0A+=0A+	alts =3D &ifa=
ce->altsetting[1];=0A+=0A add_sync_ep:=0A 	subs->sync_endpoint =3D snd_usb_=
add_endpoint(subs->stream->chip,=0A 						   alts, ep, !subs->direction,=0A=
-- =0A2.11.0=0A=0A=0AFrom 7b069cd5ffb03e708fb6039478f0b0ae3e4e4721 Mon Sep =
17 00:00:00 2001=0AFrom: Johan Hovold <johan@kernel.org>=0ADate: Tue, 14 Ja=
n 2020 09:39:53 +0100=0ASubject: [PATCH 3/6] ALSA: usb-audio: fix sync-ep a=
ltsetting sanity check=0A=0Acommit 5d1b71226dc4d44b4b65766fa9d74492f9d4587b=
 upstream=0A=0AThe altsetting sanity check in set_sync_ep_implicit_fb_quirk=
() was=0Achecking for there to be at least one altsetting but then went on =
to=0Aaccess the second one, which may not exist.=0A=0AThis could lead to ra=
ndom slab data being used to initialise the sync=0Aendpoint in snd_usb_add_=
endpoint().=0A=0AFixes: c75a8a7ae565 ("ALSA: snd-usb: add support for impli=
cit feedback")=0AFixes: ca10a7ebdff1 ("ALSA: usb-audio: FT C400 sync playba=
ck EP to capture EP")=0AFixes: 5e35dc0338d8 ("ALSA: usb-audio: add implicit=
 fb quirk for Behringer UFX1204")=0AFixes: 17f08b0d9aaf ("ALSA: usb-audio: =
add implicit fb quirk for Axe-Fx II")=0AFixes: 103e9625647a ("ALSA: usb-aud=
io: simplify set_sync_ep_implicit_fb_quirk")=0ACc: stable <stable@vger.kern=
el.org>     # 3.5=0ASigned-off-by: Johan Hovold <johan@kernel.org>=0ALink: =
https://lore.kernel.org/r/20200114083953.1106-1-johan@kernel.org=0ASigned-o=
ff-by: Takashi Iwai <tiwai@suse.de>=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A sound/usb/pcm.c | 2 +-=0A 1 file changed, 1=
 insertion(+), 1 deletion(-)=0A=0Adiff --git a/sound/usb/pcm.c b/sound/usb/=
pcm.c=0Aindex a1f189c90d4a..24df26df81db 100644=0A--- a/sound/usb/pcm.c=0A+=
++ b/sound/usb/pcm.c=0A@@ -365,7 +365,7 @@ static int set_sync_ep_implicit_=
fb_quirk(struct snd_usb_substream *subs,=0A add_sync_ep_from_ifnum:=0A 	ifa=
ce =3D usb_ifnum_to_if(dev, ifnum);=0A =0A-	if (!iface || iface->num_altset=
ting =3D=3D 0)=0A+	if (!iface || iface->num_altsetting < 2)=0A 		return -EI=
NVAL;=0A =0A 	alts =3D &iface->altsetting[1];=0A-- =0A2.11.0=0A=0A=0AFrom 8=
2a0d38244b2c4b079cb61ce11a5ea5e49eed7a3 Mon Sep 17 00:00:00 2001=0AFrom: Ka=
ilang Yang <kailang@realtek.com>=0ADate: Thu, 29 Jun 2017 15:21:27 +0800=0A=
Subject: [PATCH 4/6] ALSA: hda/realtek - Support Dell headset mode for ALC3=
271=0A=0Acommit fcc6c877a01f83cbce1cca885ea62df6a10d33c3 upstream=0A=0AAdd =
DELL4_MIC_NO_PRESENCE model.=0AAdd the pin configuration value of this mach=
ine into the pin_quirk=0Atable to make DELL4_MIC_NO_PRESENCE apply to this =
machine.=0A=0ASigned-off-by: Kailang Yang <kailang@realtek.com>=0ASigned-of=
f-by: Takashi Iwai <tiwai@suse.de>=0ASigned-off-by: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0A---=0A sound/pci/hda/patch_realtek.c | 16 +++++++=
+++++++++=0A 1 file changed, 16 insertions(+)=0A=0Adiff --git a/sound/pci/h=
da/patch_realtek.c b/sound/pci/hda/patch_realtek.c=0Aindex df6f8e904eb6..38=
ef6346ca40 100644=0A--- a/sound/pci/hda/patch_realtek.c=0A+++ b/sound/pci/h=
da/patch_realtek.c=0A@@ -4848,6 +4848,7 @@ enum {=0A 	ALC269_FIXUP_DELL1_MI=
C_NO_PRESENCE,=0A 	ALC269_FIXUP_DELL2_MIC_NO_PRESENCE,=0A 	ALC269_FIXUP_DEL=
L3_MIC_NO_PRESENCE,=0A+	ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,=0A 	ALC269_FIXU=
P_HEADSET_MODE,=0A 	ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC,=0A 	ALC269_FIXUP_A=
SPIRE_HEADSET_MIC,=0A@@ -5150,6 +5151,16 @@ static const struct hda_fixup a=
lc269_fixups[] =3D {=0A 		.chained =3D true,=0A 		.chain_id =3D ALC269_FIXU=
P_HEADSET_MODE_NO_HP_MIC=0A 	},=0A+	[ALC269_FIXUP_DELL4_MIC_NO_PRESENCE] =
=3D {=0A+		.type =3D HDA_FIXUP_PINS,=0A+		.v.pins =3D (const struct hda_pin=
tbl[]) {=0A+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own=
 jack detect */=0A+			{ 0x1b, 0x01a1913d }, /* use as headphone mic, withou=
t its own jack detect */=0A+			{ }=0A+		},=0A+		.chained =3D true,=0A+		.ch=
ain_id =3D ALC269_FIXUP_HEADSET_MODE=0A+	},=0A 	[ALC269_FIXUP_HEADSET_MODE]=
 =3D {=0A 		.type =3D HDA_FIXUP_FUNC,=0A 		.v.func =3D alc_fixup_headset_mo=
de,=0A@@ -6194,6 +6205,11 @@ static const struct snd_hda_pin_quirk alc269_p=
in_fixup_tbl[] =3D {=0A 		{0x17, 0x90170110},=0A 		{0x1a, 0x03011020},=0A 	=
	{0x21, 0x03211030}),=0A+	SND_HDA_PIN_QUIRK(0x10ec0299, 0x1028, "Dell", ALC=
269_FIXUP_DELL4_MIC_NO_PRESENCE,=0A+		ALC225_STANDARD_PINS,=0A+		{0x12, 0xb=
7a60130},=0A+		{0x13, 0xb8a60140},=0A+		{0x17, 0x90170110}),=0A 	{}=0A };=
=0A =0A-- =0A2.11.0=0A=0A=0AFrom 0ed220aa7b3f0ea2fe9d559e1627a486603423ab M=
on Sep 17 00:00:00 2001=0AFrom: Hui Wang <hui.wang@canonical.com>=0ADate: F=
ri, 2 Mar 2018 13:05:36 +0800=0ASubject: [PATCH 5/6] ALSA: hda - Fix a wron=
g FIXUP for alc289 on Dell machines=0A=0Acommit d5078193e56bb24f4593f00102a=
3b5e07bb84ee0 upstream=0A=0AWith the alc289, the Pin 0x1b is Headphone-Mic,=
 so we should assign=0AALC269_FIXUP_DELL4_MIC_NO_PRESENCE rather than=0AALC=
225_FIXUP_DELL1_MIC_NO_PRESENCE to it. And this change is suggested=0Aby Ka=
ilang of Realtek and is verified on the machine.=0A=0AFixes: 3f2f7c553d07 (=
"ALSA: hda - Fix headset mic detection problem for two Dell machines")=0ACc=
: Kailang Yang <kailang@realtek.com>=0ACc: <stable@vger.kernel.org>=0ASigne=
d-off-by: Hui Wang <hui.wang@canonical.com>=0ASigned-off-by: Takashi Iwai <=
tiwai@suse.de>=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0A---=0A sound/pci/hda/patch_realtek.c | 2 +-=0A 1 file changed, 1 insert=
ion(+), 1 deletion(-)=0A=0Adiff --git a/sound/pci/hda/patch_realtek.c b/sou=
nd/pci/hda/patch_realtek.c=0Aindex 38ef6346ca40..d9408d394747 100644=0A--- =
a/sound/pci/hda/patch_realtek.c=0A+++ b/sound/pci/hda/patch_realtek.c=0A@@ =
-6121,7 +6121,7 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_t=
bl[] =3D {=0A 		{0x12, 0x90a60120},=0A 		{0x14, 0x90170110},=0A 		{0x21, 0x=
0321101f}),=0A-	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", ALC225_FIXUP_=
DELL1_MIC_NO_PRESENCE,=0A+	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", AL=
C269_FIXUP_DELL4_MIC_NO_PRESENCE,=0A 		{0x12, 0xb7a60130},=0A 		{0x14, 0x90=
170110},=0A 		{0x21, 0x04211020}),=0A-- =0A2.11.0=0A=0A=0AFrom 23a34247da67=
249742f7fc1662b0a2a6023b162d Mon Sep 17 00:00:00 2001=0AFrom: Kailang Yang =
<kailang@realtek.com>=0ADate: Tue, 26 Nov 2019 17:04:23 +0800=0ASubject: [P=
ATCH 6/6] ALSA: hda/realtek - Dell headphone has noise on unmute=0A for ALC=
236=0A=0Acommit e1e8c1fdce8b00fce08784d9d738c60ebf598ebc upstream=0A=0Ahead=
phone have noise even the volume is very small.=0ALet it fill up pcbeep hid=
den register to default value.=0AThe issue was gone.=0A=0AFixes: 4344aec84b=
d8 ("ALSA: hda/realtek - New codec support for ALC256")=0AFixes: 736f20a706=
08 ("ALSA: hda/realtek - Add support for ALC236/ALC3204")=0ASigned-off-by: =
Kailang Yang <kailang@realtek.com>=0ACc: <stable@vger.kernel.org>=0ALink: h=
ttps://lore.kernel.org/r/9ae47f23a64d4e41a9c81e263cd8a250@realtek.com=0ASig=
ned-off-by: Takashi Iwai <tiwai@suse.de>=0A[sudip: adjust context]=0ASigned=
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/pci/hd=
a/patch_realtek.c | 7 +++++--=0A 1 file changed, 5 insertions(+), 2 deletio=
ns(-)=0A=0Adiff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch=
_realtek.c=0Aindex d9408d394747..854d2da02cc9 100644=0A--- a/sound/pci/hda/=
patch_realtek.c=0A+++ b/sound/pci/hda/patch_realtek.c=0A@@ -330,9 +330,7 @@=
 static void alc_fill_eapd_coef(struct hda_codec *codec)=0A 	case 0x10ec022=
5:=0A 	case 0x10ec0233:=0A 	case 0x10ec0235:=0A-	case 0x10ec0236:=0A 	case =
0x10ec0255:=0A-	case 0x10ec0256:=0A 	case 0x10ec0282:=0A 	case 0x10ec0283:=
=0A 	case 0x10ec0286:=0A@@ -342,6 +340,11 @@ static void alc_fill_eapd_coef=
(struct hda_codec *codec)=0A 	case 0x10ec0299:=0A 		alc_update_coef_idx(cod=
ec, 0x10, 1<<9, 0);=0A 		break;=0A+	case 0x10ec0236:=0A+	case 0x10ec0256:=
=0A+		alc_write_coef_idx(codec, 0x36, 0x5757);=0A+		alc_update_coef_idx(cod=
ec, 0x10, 1<<9, 0);=0A+		break;=0A 	case 0x10ec0285:=0A 	case 0x10ec0293:=
=0A 		alc_update_coef_idx(codec, 0xa, 1<<13, 0);=0A-- =0A2.11.0=0A=0A
--xn6biy3bc7yrnvte--
