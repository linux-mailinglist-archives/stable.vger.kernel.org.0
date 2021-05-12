Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD9337C8B0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhELQLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238943AbhELQGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:06:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 324C061CFC;
        Wed, 12 May 2021 15:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833719;
        bh=tGCX8tslhtr2FUexM+5GSfcEhS4W6t6okDswa7G7v7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiH5fcfKUWJYOR2qWhXCXANF9OkKecWwIKYgsOAFcuteM8AbyPIhkJKBlLBM8nwY0
         cEXkEArJqnWIemVAqXhvG9WwvZ8voda0X+jy3aSgBrSZu6FF1ta/2OVOoxKFSW9VCH
         bTSIab2+agoDM0W7lqFbKT3eCRaX1LAd2TUZlDkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 254/601] PM: runtime: Replace inline function pm_runtime_callbacks_present()
Date:   Wed, 12 May 2021 16:45:31 +0200
Message-Id: <20210512144836.188833423@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 953c1fd96b1a70bcbbfb10973c2126eba8d891c7 ]

Commit 9a7875461fd0 ("PM: runtime: Replace pm_runtime_callbacks_present()")
forgot to change the inline version.

Fixes: 9a7875461fd0 ("PM: runtime: Replace pm_runtime_callbacks_present()")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm_runtime.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index b492ae00cc90..6c08a085367b 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -265,7 +265,7 @@ static inline void pm_runtime_no_callbacks(struct device *dev) {}
 static inline void pm_runtime_irq_safe(struct device *dev) {}
 static inline bool pm_runtime_is_irq_safe(struct device *dev) { return false; }
 
-static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
+static inline bool pm_runtime_has_no_callbacks(struct device *dev) { return false; }
 static inline void pm_runtime_mark_last_busy(struct device *dev) {}
 static inline void __pm_runtime_use_autosuspend(struct device *dev,
 						bool use) {}
-- 
2.30.2



