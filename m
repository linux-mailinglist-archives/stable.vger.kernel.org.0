Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F11481DD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391288AbgAXLXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391313AbgAXLXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:21 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC5072075D;
        Fri, 24 Jan 2020 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865001;
        bh=tggZ1F8OoNTZfPK3ifMiW8r68RNcaE+R62ynHkmwNx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdvRqrhA+ErB7cQ3hrSztF1aA1+rcdxxlB3xjyzbv4IONISl8DN1gQTgPUyvIBafd
         8dVLcLS1E5fpvs+tQ1JaMazX6l4gF6vdm1jcn7njFtHujzGCIMnqnf99072ky8VjSO
         ENzjYbbkRirWmimB/AwXtG1JN5y2OUbXfTdrv91c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 425/639] ASoC: meson: axg-tdmin: right_j is not supported
Date:   Fri, 24 Jan 2020 10:29:55 +0100
Message-Id: <20200124093140.261231234@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 47c317b786b6c1efc2cb3cdb894fd323422fe5ea ]

Right justified format is actually not supported by the amlogic tdm input
decoder.

Fixes: 13a22e6a98f8 ("ASoC: meson: add tdm input driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-tdmin.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/meson/axg-tdmin.c b/sound/soc/meson/axg-tdmin.c
index bbac44c816886..37207bbebb2a4 100644
--- a/sound/soc/meson/axg-tdmin.c
+++ b/sound/soc/meson/axg-tdmin.c
@@ -119,7 +119,6 @@ static int axg_tdmin_prepare(struct regmap *map, struct axg_tdm_stream *ts)
 		break;
 
 	case SND_SOC_DAIFMT_LEFT_J:
-	case SND_SOC_DAIFMT_RIGHT_J:
 	case SND_SOC_DAIFMT_DSP_B:
 		val = TDMIN_CTRL_IN_BIT_SKEW(2);
 		break;
-- 
2.20.1



