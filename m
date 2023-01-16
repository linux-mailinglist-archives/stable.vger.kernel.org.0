Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4731766C992
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbjAPQvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbjAPQvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:51:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708DC4B1A2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:37:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 344F4B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99163C433F0;
        Mon, 16 Jan 2023 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887019;
        bh=Hhaael2frZSe6Jse1qUuGwLB43dKPfzxCToi/yJM1MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaTdEfElhZ3Of7iLcU5QEt1X45oKcFbJRutGrbMIB4stSYMEzoLgr4PV7OPPHa0cN
         uww/iWOPOOhcIuCY+swmzE8p0RlYVY/c9ijp0dRIj74Sb5lM0vudzW1WzOwelzJdra
         Sv0L/ncqAFUe8CH0cuok4xhwq2992hwFfvVM6JR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Chan <adchan@google.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 609/658] ALSA: hda/hdmi: Add a HP device 0x8715 to force connect list
Date:   Mon, 16 Jan 2023 16:51:37 +0100
Message-Id: <20230116154937.360880386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Chan <adchan@google.com>

commit de1ccb9e61728dd941fe0e955a7a129418657267 upstream.

Add the 'HP Engage Flex Mini' device to the force connect list to
enable audio through HDMI.

Signed-off-by: Adrian Chan <adchan@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230109210520.16060-1-adchan@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1821,6 +1821,7 @@ static const struct snd_pci_quirk force_
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),
+	SND_PCI_QUIRK(0x103c, 0x8715, "HP", 1),
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
 	{}
 };


