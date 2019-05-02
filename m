Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669E911286
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 07:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbfEBFP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 01:15:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35325 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfEBFP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 01:15:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id f7so1410880wrs.2
        for <stable@vger.kernel.org>; Wed, 01 May 2019 22:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=AfysjtlVKQZM/hiHS9iA8C8ubLk6xPLMqs6dI0UAgSs=;
        b=GFxR1W3jnTujBgrBVT/wt89CroTvmca3XzDeNVPU5WyU+DxZvssSuuxFprCmLczkS+
         yNXzw9aTeLp+RuQN1Bnkg99hYK8uISPWAxRYpMucpsaeor9vt5/yugx9boid4CemHj0/
         kIlY1lSnuVxh02NXclgIQa3RFvTQvFjX2/TNGAOBU8G+WHQwzjw22SqyCZ9yl9ODJj5O
         uxQKCYDOHXbaDa7+yWcWskfDXXeW5og9ZbkdZQ1Sk2Gaqnpwghb9nkR5pD0M8p3NNEeF
         mKnLgGF35//GVlndbC474cC9AjT7q9nIAsqUPyrEZpH9/PwL80gQEplRi9Hx4z6OLUx0
         ituQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AfysjtlVKQZM/hiHS9iA8C8ubLk6xPLMqs6dI0UAgSs=;
        b=rm9M/VyoKeDg1feqGk6eapa1CRWzUKgwdYZLSFS3YNguTzXKJ7r+DbQPTwkDvX8gXk
         2iC4upxK554D5gKm0rCmgWuMh2dqetnpX1iwSW0ETdc91vU68b1EbBVL+GBaxlZaIT9E
         oELF1YUZGIcml9/qwZJUe1FomcXlRmNxNkQ4J6Qj9ksd7XD4ArvwMLVIhyQF9Qj6cQAv
         15lYBpAiPMgRiK5JRjzHWYW9LsfS9KHFAPl7hqvyBAxjN3vrzdhO0xCBIZz2DZFt7I/s
         IODCq7/Nq0kRCdPNRgaw0XwjRLeOZhEAarfbJx/pwpm8B3fkppD7P/ooF4olrc3q0TUn
         eCNw==
X-Gm-Message-State: APjAAAVbWkC91Mpuguem2TYUrYkZ4IUymJk1oP//5HVZ0W2YXS9WcY2+
        f+W5ibN7Inhitly1xeEUTdmDXpwfVGb5rQ==
X-Google-Smtp-Source: APXvYqxu3tKNbcTJfzkaOSp3EXAoJsA4mKoKER0VIiRahAjBwoQPeUn9WUQ9e/PTQTVtR5nAMbx2lQ==
X-Received: by 2002:adf:dd12:: with SMTP id a18mr1197444wrm.188.1556774154467;
        Wed, 01 May 2019 22:15:54 -0700 (PDT)
Received: from hackbox2.linaroharston ([81.128.185.34])
        by smtp.gmail.com with ESMTPSA id z6sm21726719wrw.87.2019.05.01.22.15.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 22:15:53 -0700 (PDT)
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
To:     stable@vger.kernel.org
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 4.9] media: vivid: check if the cec_adapter is valid
Date:   Thu,  2 May 2019 06:15:46 +0100
Message-Id: <20190502051546.12515-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ed356f110403f6acc64dcbbbfdc38662ab9b06c2 upstream.

If CEC is not enabled for the vivid driver, then the adap pointer is NULL
and 'adap->phys_addr' will fail.

Cc: <stable@vger.kernel.org> # v4.9
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
[ Naresh: Fixed rebase conflict ]
Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
---
 drivers/media/platform/vivid/vivid-vid-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index f9a810e3f521..d380c2da1926 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -841,6 +841,7 @@ int vidioc_g_edid(struct file *file, void *_fh,
 	if (edid->start_block + edid->blocks > dev->edid_blocks)
 		edid->blocks = dev->edid_blocks - edid->start_block;
 	memcpy(edid->edid, dev->edid, edid->blocks * 128);
-	cec_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
+        if (adap)
+		cec_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
 	return 0;
 }
-- 
2.17.1

