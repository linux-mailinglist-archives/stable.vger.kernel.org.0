Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E455EA287
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbiIZLJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiIZLJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:09:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C5613E83;
        Mon, 26 Sep 2022 03:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F299B80957;
        Mon, 26 Sep 2022 10:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A46C433C1;
        Mon, 26 Sep 2022 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188493;
        bh=oJcafgBQMzecYzChnClopOigfqz6r+eNTeZ7rf2LWHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyiCcAGxQTcjSuEd/tld64BGfpCuYY8pbp74b1rK6IwXgnj9wIYCLItwQ0nPBNuoq
         HkxGtWFcc6b0UkzfZdEP89LeodfrI4UAO14FAKlFXx7bKyes4lCIm090x95lf1Yxy1
         2hrJExyF7GwFo54GHW7Gdwr62H85hIXPvNno7tSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 026/148] ALSA: hda: add Intel 5 Series / 3400 PCI DID
Date:   Mon, 26 Sep 2022 12:11:00 +0200
Message-Id: <20220926100757.062853151@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit 4d40ceef4745536289012670103c59264e0fb3ec upstream.

Handle 0x3b57 variant with same AZX_DCAPS_INTEL_PCH_NOPM
capabilities as 0x3b56. In practise this allow use of HDMI/DP
display audio via i915.

BugLink: https://gitlab.freedesktop.org/drm/intel/-/issues/2751
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220912183716.2126312-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2519,6 +2519,8 @@ static const struct pci_device_id azx_id
 	/* 5 Series/3400 */
 	{ PCI_DEVICE(0x8086, 0x3b56),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
+	{ PCI_DEVICE(0x8086, 0x3b57),
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Poulsbo */
 	{ PCI_DEVICE(0x8086, 0x811b),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },


