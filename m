Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7D2378590
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhEJLAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234407AbhEJK4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A2A61999;
        Mon, 10 May 2021 10:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643543;
        bh=sYpZrDLWsBaqLbdLyBqJS4m0VovNNfk2eF+ggSfCLbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXvblT4qXu07YkIsDcq6eAiNALGaRhIbzTllc8yP+yZvL8ObizyX9aZnOGZ1+V+E8
         XGRuRlkCWJKYA+bkS3F9fPz+tnjz56yM+dbMqDsZ6zDdUss4WQFThfGYPWp+GP5MNA
         gZHvfg0Rdqfi0BAzPohbXwNvznyvHyswhcLG/nWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Quinlan <jim2101024@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.11 022/342] reset: add missing empty function reset_control_rearm()
Date:   Mon, 10 May 2021 12:16:52 +0200
Message-Id: <20210510102010.840368548@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Quinlan <jim2101024@gmail.com>

commit 48582b2e3b87b794a9845d488af2c76ce055502b upstream.

All other functions are defined for when CONFIG_RESET_CONTROLLER
is not set.

Fixes: 557acb3d2cd9 ("reset: make shared pulsed reset controls re-triggerable")
Link: https://lore.kernel.org/r/20210430152156.21162-2-jim2101024@gmail.com
Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v5.11+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/reset.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -47,6 +47,11 @@ static inline int reset_control_reset(st
 	return 0;
 }
 
+static inline int reset_control_rearm(struct reset_control *rstc)
+{
+	return 0;
+}
+
 static inline int reset_control_assert(struct reset_control *rstc)
 {
 	return 0;


