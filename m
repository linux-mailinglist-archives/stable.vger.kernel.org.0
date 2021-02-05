Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9223113FD
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhBEVy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:54:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233014AbhBEO7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:59:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D4265082;
        Fri,  5 Feb 2021 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534402;
        bh=donZ+VCelZesukOHHig0GP3GsiKZtmd+5K8MQrnxzHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wY1zzsdURhRexb7WJaKqkO7VoG4Z3HYcBgHp7BZjpOPaR6pOjEfe8bov+STf9bkZ6
         UORisdhmQmkGMYlHILEafBhM1EMvvpZqM9itVluVGYFSq+croLJSZoPnqF18EiFpa4
         QGI4Sa9EQ23OLBSS7oWhb6swkC7qiJNj2AkcFocM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/32] ALSA: hda: Add Cometlake-R PCI ID
Date:   Fri,  5 Feb 2021 15:07:39 +0100
Message-Id: <20210205140653.375387398@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>

[ Upstream commit f84d3a1ec375e46a55cc3ba85c04272b24bd3921 ]

Add HD Audio Device PCI ID for the Intel Cometlake-R platform

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>
Link: https://lore.kernel.org/r/20210115031515.13100-1-kaichuan.hsieh@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 5f515a29668c8..b3667a5efdc1f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2450,6 +2450,9 @@ static const struct pci_device_id azx_ids[] = {
 	/* CometLake-S */
 	{ PCI_DEVICE(0x8086, 0xa3f0),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* CometLake-R */
+	{ PCI_DEVICE(0x8086, 0xf0c8),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Icelake */
 	{ PCI_DEVICE(0x8086, 0x34c8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
-- 
2.27.0



