Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED55C5E9FC6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbiIZK3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbiIZK0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:26:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7CA3FA12;
        Mon, 26 Sep 2022 03:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EE0DB80930;
        Mon, 26 Sep 2022 10:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEAFC433C1;
        Mon, 26 Sep 2022 10:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187503;
        bh=Tbxxrcgh3NePnoXuNMJDxvg8ntbWKR5LUqSxLZ3lIHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNWxOJXYGLWyEtVvoc0/Q17o2PI5bnr56L9ABJU0i1aGVa82+KwEUo8O7O4ts9Xqo
         LKuOAXiE+zo0hmPiopcdGDeZ1ac0UrCnVi82aikVRie2SXdGCbhDpTcV1ss1zcEg4l
         IBYYFxi3wmU67qqJOT9fFnVCC27QCDS/5alkcn/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 29/58] ALSA: hda: add Intel 5 Series / 3400 PCI DID
Date:   Mon, 26 Sep 2022 12:11:48 +0200
Message-Id: <20220926100742.529655798@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
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
@@ -2634,6 +2634,8 @@ static const struct pci_device_id azx_id
 	/* 5 Series/3400 */
 	{ PCI_DEVICE(0x8086, 0x3b56),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
+	{ PCI_DEVICE(0x8086, 0x3b57),
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Poulsbo */
 	{ PCI_DEVICE(0x8086, 0x811b),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },


