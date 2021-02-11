Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4520318E8A
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhBKP3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:29:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhBKPZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D1364ED7;
        Thu, 11 Feb 2021 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055843;
        bh=NOcRe0VCK/Dl7v9QBx5nOMkcdzVJUUGVG2DqpXFpPcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsweVNRQuHKlYbQP6YIKBiuPjIvU8R00PJmP2UFl0iTlo5DOxyb86dhD30xV9vS34
         gfpjDMNayT7oEJArwlrG0cpZ3wplzIf4+sB6xmU7r/lI2zFpyrgWUt5AuXlEV+fxa8
         yZQJi2g3OWM6VZP2pwbHt00acDHe4O/18WBSFhxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bard Liao <bard.liao@intel.com>,
        Xiuli Pan <xiuli.pan@intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/54] ALSA: hda: intel-dsp-config: add PCI id for TGL-H
Date:   Thu, 11 Feb 2021 16:02:12 +0100
Message-Id: <20210211150154.113601291@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <bard.liao@intel.com>

[ Upstream commit c5b5ff607d6fe5f4284acabd07066f96ecf96ac4 ]

Adding PCI id for TGL-H. Like for other TGL platforms, SOF is used if
Soundwire codecs or PCH-DMIC is detected.

Signed-off-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Xiuli Pan <xiuli.pan@intel.com>
Reviewed-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210125083051.828205-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 1c5114dedda92..fe49e9a97f0ec 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -306,6 +306,10 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0xa0c8,
 	},
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x43c8,
+	},
 #endif
 
 /* Elkhart Lake */
-- 
2.27.0



