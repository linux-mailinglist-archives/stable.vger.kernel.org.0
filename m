Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B884ABC86
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382662AbiBGLhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359408AbiBGL2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361B0C033252;
        Mon,  7 Feb 2022 03:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36FCA60A6B;
        Mon,  7 Feb 2022 11:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D724C004E1;
        Mon,  7 Feb 2022 11:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233221;
        bh=9q3/IOuZ6+o3g3xGCTBih0kUoMO02HHzHtG+4luzBNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PT4aQI2mT1TuCcYOhBctJEX6UAw/ObzwEQrZ97Glfa57GSEDm1+DewHjUtBuut6F7
         A8hrdLHqrBfeI9h/r/1WFxvxieKVcexdVM5XsgwzUuGSMLyw3HsvgU8HEPxeijlItF
         z42q7fuz1a0iwxZ7v5FsWFRxOOZ//BUIf0CTs1PY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lachner <gladiac@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 014/110] ALSA: hda/realtek: Add missing fixup-model entry for Gigabyte X570 ALC1220 quirks
Date:   Mon,  7 Feb 2022 12:05:47 +0100
Message-Id: <20220207103802.750149389@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lachner <gladiac@gmail.com>

commit 63394a16086fc2152869d7902621e2525e14bc40 upstream.

The initial commit of the new Gigabyte X570 ALC1220 quirks lacked the
fixup-model entry in alc882_fixup_models[]. It seemed not to cause any ill
effects but for completeness sake this commit makes up for that.

Signed-off-by: Christian Lachner <gladiac@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220129113243.93068-2-gladiac@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2660,6 +2660,7 @@ static const struct hda_model_fixup alc8
 	{.id = ALC882_FIXUP_NO_PRIMARY_HP, .name = "no-primary-hp"},
 	{.id = ALC887_FIXUP_ASUS_BASS, .name = "asus-bass"},
 	{.id = ALC1220_FIXUP_GB_DUAL_CODECS, .name = "dual-codecs"},
+	{.id = ALC1220_FIXUP_GB_X570, .name = "gb-x570"},
 	{.id = ALC1220_FIXUP_CLEVO_P950, .name = "clevo-p950"},
 	{}
 };


