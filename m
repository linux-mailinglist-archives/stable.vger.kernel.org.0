Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02233450E7E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbhKOSP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:15:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240254AbhKOSH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B182E63260;
        Mon, 15 Nov 2021 17:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998242;
        bh=RHZhCKqopg0/kn8Ha4aSCuMewYbiJVQjlJ6xHIGv4iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGC/8EV2//Z7eNJWJxfUD01LJ/dhasKzVy8al2ddwjzlZZjQC9XyYZf4XMO9mEowu
         1vvnMkPW3/L2Kllm25pt25zfSMWhul3/1vvC/dcvDi/326KhXIpLUvgnGiJn+nlTTr
         yCya7XaxCqqEEQoqyVzeRR+iv945gNYBgvspGwiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 440/575] soc: qcom: rpmhpd: Provide some missing struct member descriptions
Date:   Mon, 15 Nov 2021 18:02:45 +0100
Message-Id: <20211115165358.980948642@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 5d16af6a921f5a4e7038671be5478cba4b7cfe81 ]

Fixes the following W=1 kernel build warning(s):

 drivers/soc/qcom/rpmhpd.c:52: warning: Function parameter or member 'parent' not described in 'rpmhpd'
 drivers/soc/qcom/rpmhpd.c:52: warning: Function parameter or member 'corner' not described in 'rpmhpd'
 drivers/soc/qcom/rpmhpd.c:52: warning: Function parameter or member 'active_corner' not described in 'rpmhpd'

Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-arm-msm@vger.kernel.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20201103152838.1290217-22-lee.jones@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmhpd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soc/qcom/rpmhpd.c b/drivers/soc/qcom/rpmhpd.c
index c8b584d0c8fb4..e7cb40144f9b1 100644
--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -24,9 +24,12 @@
  * struct rpmhpd - top level RPMh power domain resource data structure
  * @dev:		rpmh power domain controller device
  * @pd:			generic_pm_domain corrresponding to the power domain
+ * @parent:		generic_pm_domain corrresponding to the parent's power domain
  * @peer:		A peer power domain in case Active only Voting is
  *			supported
  * @active_only:	True if it represents an Active only peer
+ * @corner:		current corner
+ * @active_corner:	current active corner
  * @level:		An array of level (vlvl) to corner (hlvl) mappings
  *			derived from cmd-db
  * @level_count:	Number of levels supported by the power domain. max
-- 
2.33.0



