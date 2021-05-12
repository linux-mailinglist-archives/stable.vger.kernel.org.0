Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AAB37B9F1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhELKHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:07:10 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:44289 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230178AbhELKHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:07:09 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id B53D71322;
        Wed, 12 May 2021 06:05:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fzXuGt
        waU0XvczHQ76O3qmR7DcM1PLyqpiG/dAQOkqw=; b=iYcIWjv1XFTR5/4po81Izg
        bxYHwlRDtHk6Et8EIVjVJEja9b3ldXpCXmqia4UV0GfVdkPR1BdBaHCCp/ebr5f/
        7N6Zc1T2PPkRkW7I1ewteZDmpJkG8cfvsrimwjhET1j5PR2dVEsWKIaqJm+wwnsS
        9yMbcvnITDMgWjJ3nVinr7hRqXpVIouMuFP1E0jJICRVj/79jzNeCnFW3AnQw2Bv
        M309vWqOsAxQcJquc8Rz3TVy6FQARbVC79TB8hWpf37HUIWHUOz7MnLEqQmcybSe
        fvkagAOa+nO6lATEiUviZzgt7dxqnl6kAPZf/0L7C9Eu3C2AdSG18P241d0ato7A
        ==
X-ME-Sender: <xms:h6ibYAX-4-cmeqHlW5fciY8tgmtMjjfsfDIr0Rv-gWFaWzd6qZCuiQ>
    <xme:h6ibYEnC3VwSc8dbCfrU5NlFwpgnFA8juVIn8KOL8QE5LC7MoPoc8SCnmEGQ4C5-_
    zeyVEY5Qg8lJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptefhhffgjefgtdeihefgvdehieetuefgvefhgedvge
    dvgfdugfevgefgueeljedvnecuffhomhgrihhnpehlrghunhgthhhprggurdhnvghtpdhk
    vghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mh
X-ME-Proxy: <xmx:h6ibYEanpSco3Uqnafsl-hNsN_RrVsEquMW9V0KKMBcJKExWcmmM4w>
    <xmx:h6ibYPWIPONsDXbQ8YFyxGYlaHstIIC5K9vnAL4GDXjSbwe_97O54g>
    <xmx:h6ibYKky8helVlnr_ae86oujqGfsJv4xBR8v7cDUloukZceIpDtDIA>
    <xmx:h6ibYMgLqmLcV9FAAor7Jsc0NDZmcwDs8ui-8fNtVTcq_uk2jGrv5zP4FzU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:05:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/cirrus: Set Initial DMIC volume for Bullseye to -26" failed to apply to 5.11-stable tree
To:     sbinding@opensource.cirrus.com, stable@vger.kernel.org,
        tiwai@suse.de, vicamo.yang@canonical.com,
        vitalyr@opensource.cirrus.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:05:48 +0200
Message-ID: <162081394890214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0e853a9c3937caa9f13fdde547d6202f92457c2b Mon Sep 17 00:00:00 2001
From: Stefan Binding <sbinding@opensource.cirrus.com>
Date: Mon, 26 Apr 2021 17:37:48 +0100
Subject: [PATCH] ALSA: hda/cirrus: Set Initial DMIC volume for Bullseye to -26
 dB

After booting for first time on Bullseye, the DMIC is currently muted.
Instead, the DMIC volume should be set to a valid initial value.

Tested on DELL Inspiron-3505, DELL Inspiron-3501, DELL Inspiron-3500

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1923557
Reported-and-tested-by: You-Sheng Yang <vicamo.yang@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210426163749.196153-2-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 5d57096b3a95..a4f82f147ff3 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -2172,6 +2172,11 @@ static void cs8409_cs42l42_fixups(struct hda_codec *codec,
 			(get_wcaps(codec, CS8409_CS42L42_AMIC_PIN_NID) | AC_WCAP_UNSOL_CAP));
 		break;
 	case HDA_FIXUP_ACT_PROBE:
+
+		/* Set initial volume on Bullseye to -26 dB */
+		if (codec->fixup_id == CS8409_BULLSEYE)
+			snd_hda_codec_amp_init_stereo(codec, CS8409_CS42L42_DMIC_ADC_PIN_NID,
+					HDA_INPUT, 0, 0xff, 0x19);
 		snd_hda_gen_add_kctl(&spec->gen,
 			NULL, &cs8409_cs42l42_hp_volume_mixer);
 		snd_hda_gen_add_kctl(&spec->gen,

