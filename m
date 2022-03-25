Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0594E7627
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245487AbiCYPLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359755AbiCYPKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBAF65AF;
        Fri, 25 Mar 2022 08:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D04B61C12;
        Fri, 25 Mar 2022 15:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1519BC340E9;
        Fri, 25 Mar 2022 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220882;
        bh=outLncT7N3XRfvkdWvXWmkHr2duV+VqjWJmMM9eA8rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZIbwA2SfZX1/uGJLyYFJRU+NIQvOuKRxUhdK0dZbpXBmipQfxLr3Q3eBYDYCibGK
         lw9zZ1wVznbrlNLeDXAne/wpYFlUej2ELOvF4o5i6ClslCGDQQ+Rn9ZFUkyhjiD2V5
         034eqRdP6RP9oHbtBfCkCFNq6AjYwaiTk88nKAWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Zheng <jasonzheng2004@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 20/29] ALSA: hda/realtek: Add quirk for ASUS GA402
Date:   Fri, 25 Mar 2022 16:05:00 +0100
Message-Id: <20220325150419.168648795@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Zheng <jasonzheng2004@gmail.com>

commit b7557267c233b55d8e8d7ba4c68cf944fe2ec02c upstream.

ASUS GA402 requires a workaround to manage the routing of its 4 speakers
like the other ASUS models. Add a corresponding quirk entry to fix it.

Signed-off-by: Jason Zheng <jasonzheng2004@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220313092216.29858-1-jasonzheng2004@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8183,6 +8183,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),


