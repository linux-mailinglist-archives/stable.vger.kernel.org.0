Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1DE4800F1
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbhL0Pvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240880AbhL0Pt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:49:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76529C07E5C2;
        Mon, 27 Dec 2021 07:45:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41E72B810BF;
        Mon, 27 Dec 2021 15:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A910C36AE7;
        Mon, 27 Dec 2021 15:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619928;
        bh=Osa7qlVxrrZs95JwsQZvgOSKNgX79z7gM72ndAJbfUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSkilstCM3VnXZ8b85RmZRD6b/RQ+iSopgYpaOTrqHrQa1L8DjpRox5qAwXH06vYX
         p0aFx+3e8nKHcZ1X0+3NOfUXnmrw2TwMuQb22wxiefQbXsPG1ALihtfZtcp/PHxNuq
         JCbShqAK2S8giyv9jwfWEs1vrn5+bIO14GYFxEsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 117/128] ASoC: SOF: Intel: pci-tgl: add new ADL-P variant
Date:   Mon, 27 Dec 2021 16:31:32 +0100
Message-Id: <20211227151335.426314870@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit de7dd9092cd38384f774d345cccafe81b4b866b0 upstream.

Add a PCI DID for a variant of Intel AlderLake-P.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20211203171542.1021399-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/pci-tgl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -117,6 +117,8 @@ static const struct pci_device_id sof_pc
 		.driver_data = (unsigned long)&adls_desc},
 	{ PCI_DEVICE(0x8086, 0x51c8), /* ADL-P */
 		.driver_data = (unsigned long)&adl_desc},
+	{ PCI_DEVICE(0x8086, 0x51cd), /* ADL-P */
+		.driver_data = (unsigned long)&adl_desc},
 	{ PCI_DEVICE(0x8086, 0x51cc), /* ADL-M */
 		.driver_data = (unsigned long)&adl_desc},
 	{ 0, }


