Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A517D9F37
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394836AbfJPVxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437518AbfJPVxV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:21 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3DAC21A49;
        Wed, 16 Oct 2019 21:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262801;
        bh=aPLnSOzZT4loR5rK2tPSmqEFPGBuW5B8uEE8ucMTXuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1e267XH9brNl7DTdt8y5/sJCYCZiLBYFKuH5omlTxngHOsh34vavym+zRuGIxtJl
         MOpEsFuiqdocdyrlipbFrrAgmXpQiaH7JIVFDuiSe0wtgWJe4s/AznQ6RlfirH7MA9
         F84qrgF1kjVnWTNCUhoMGLOgoD/IzU7jDovrlZ6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 06/79] ASoC: Define a set of DAPM pre/post-up events
Date:   Wed, 16 Oct 2019 14:49:41 -0700
Message-Id: <20191016214735.229352934@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

commit cfc8f568aada98f9608a0a62511ca18d647613e2 upstream.

Prepare to use SND_SOC_DAPM_PRE_POST_PMU definition to
reduce coming code size and make it more readable.

Cc: stable@vger.kernel.org
Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Igor Opaniuk <igor.opaniuk@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20190719100524.23300-2-oleksandr.suvorov@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/soc-dapm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -335,6 +335,8 @@ struct device;
 #define SND_SOC_DAPM_WILL_PMD   0x80    /* called at start of sequence */
 #define SND_SOC_DAPM_PRE_POST_PMD \
 				(SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMD)
+#define SND_SOC_DAPM_PRE_POST_PMU \
+				(SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU)
 
 /* convenience event type detection */
 #define SND_SOC_DAPM_EVENT_ON(e)	\


