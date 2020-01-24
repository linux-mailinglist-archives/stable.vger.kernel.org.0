Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DB614826E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403997AbgAXL2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:28:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404000AbgAXL2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:28:04 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E0020704;
        Fri, 24 Jan 2020 11:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865284;
        bh=/IaTLdBbuG6dKIy+ihp0raSu/rsim54qUzxtpXP4YDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxL7BY8zYh3x4WhpzAb65W+bqlTvM7KguG6hNH5QwuOSflC8CDPkFyeRtN1SzLh7I
         Vhod1sLb9edr1aZnR8Nisv1UdOXE+Db6JunjPnz6UP4aC+oclLQ8+OpDkxWXoEq0GC
         nd7fWxL4OFAfN2CzpMr3cb48Yzcy5tVuGDb0vzz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 504/639] ASoC: es8328: Fix copy-paste error in es8328_right_line_controls
Date:   Fri, 24 Jan 2020 10:31:14 +0100
Message-Id: <20200124093151.933033496@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 630742c296341a8cfe00dfd941392025ba8dd4e8 ]

It seems 'es8328_rline_enum' should be used
in es8328_right_line_controls

Fixes: 567e4f98922c ("ASoC: add es8328 codec driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20190815092300.68712-1-yuehaibing@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8328.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index e9fc2fd97d2f4..3afa163f7652d 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -231,7 +231,7 @@ static const struct soc_enum es8328_rline_enum =
 			      ARRAY_SIZE(es8328_line_texts),
 			      es8328_line_texts);
 static const struct snd_kcontrol_new es8328_right_line_controls =
-	SOC_DAPM_ENUM("Route", es8328_lline_enum);
+	SOC_DAPM_ENUM("Route", es8328_rline_enum);
 
 /* Left Mixer */
 static const struct snd_kcontrol_new es8328_left_mixer_controls[] = {
-- 
2.20.1



