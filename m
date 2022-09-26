Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39F15E9F38
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbiIZKVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbiIZKTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:19:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72E24B483;
        Mon, 26 Sep 2022 03:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B984760A55;
        Mon, 26 Sep 2022 10:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92A8C433C1;
        Mon, 26 Sep 2022 10:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187355;
        bh=munZIzQQkDhs8L7R9gyhmxZA9OetOMIQz9854htNsxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/romFfDAOZNw2BFsXsFBcRkk6RKhzvVLesVE0xw+hKLEGYZ65V3xFA+wAWVQY5Z/
         tB4O3jHbj0d7XZvN12EeN2Y7HzS9i6Zlf6wGPlBze+rprVuEonvVOy3LP3UvC4bO38
         5GAZAzPDrRqORfKP30pw2/W7h4tC7RDUdzRNB/d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 21/40] ALSA: hda: add Intel 5 Series / 3400 PCI DID
Date:   Mon, 26 Sep 2022 12:11:49 +0200
Message-Id: <20220926100739.061363112@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
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
@@ -2567,6 +2567,8 @@ static const struct pci_device_id azx_id
 	/* 5 Series/3400 */
 	{ PCI_DEVICE(0x8086, 0x3b56),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
+	{ PCI_DEVICE(0x8086, 0x3b57),
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Poulsbo */
 	{ PCI_DEVICE(0x8086, 0x811b),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },


