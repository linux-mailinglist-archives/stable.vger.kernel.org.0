Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E472596AE
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbgIAQFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730107AbgIAPlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F4620866;
        Tue,  1 Sep 2020 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974872;
        bh=zqlxkH3Q4VQCcQyRUikAFrSKPx/FDhjPsglot8WfhGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0DB3yYN4xT/Nlkl4A5RJzIm+xZiOGlK4Ke7ZzgFGipGtFCn9sjd9eHB12AbuVdsh
         JNJrtiv1muQWZFJRpBZxzmuj7qxRtXLtlf8ertx0Bl8q7UOceSq9axbEHeQRRSIiz2
         mSpJz+IyJfLmtJqpsB8kfkd9RRv7wGeG/llHZHOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 082/255] PM / devfreq: Fix the wrong end with semicolon
Date:   Tue,  1 Sep 2020 17:08:58 +0200
Message-Id: <20200901151004.663705919@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

[ Upstream commit 27a69714450f5c9288cec2b20f1ae4f7ad34dacf ]

Fix the wrong grammar at the end of code line by using semicolon.

Cc: stable vger.kernel.org
Fixes: 490a421bc575 ("PM / devfreq: Add debugfs support with devfreq_summary file")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 46c84dce6544a..5f8d94e812c8f 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1690,9 +1690,9 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
 #endif
 
 		mutex_lock(&devfreq->lock);
-		cur_freq = devfreq->previous_freq,
+		cur_freq = devfreq->previous_freq;
 		get_freq_range(devfreq, &min_freq, &max_freq);
-		polling_ms = devfreq->profile->polling_ms,
+		polling_ms = devfreq->profile->polling_ms;
 		mutex_unlock(&devfreq->lock);
 
 		seq_printf(s,
-- 
2.25.1



