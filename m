Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B580CA22E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732031AbfJCQCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732027AbfJCQCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:02:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29DAB20700;
        Thu,  3 Oct 2019 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118558;
        bh=4LldhGcKaiWIRhK2s/OWpvADxLRNsZW2t/xA95AQhUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P09dm8yqaxjlWnaZmi+XDV0OyzuSLfKgFgNOnFo64j9HaJ6A25ZBwdFSIUh5K2NgR
         BPtS0aQEjWmQhf4Sr2+3l6ZXPXxZ2QAOPeITur/YAbVpEH7KjSQeIOaEDY/NXpf+6v
         k0FLe7uGMh2j6dc+Q4z93jH5VuEDrsNXDK/syojs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Vaishali Thakkar <vaishali.thakkar@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 054/129] base: soc: Export soc_device_register/unregister APIs
Date:   Thu,  3 Oct 2019 17:52:57 +0200
Message-Id: <20191003154341.843893098@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit f7ccc7a397cf2ef64aebb2f726970b93203858d2 ]

Qcom Socinfo driver can be built as a module, so
export these two APIs.

Tested-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Vaishali Thakkar <vaishali.thakkar@linaro.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/soc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index b63f23e6ad61b..ddb32c890fa6a 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -145,6 +145,7 @@ struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr
 out1:
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(soc_device_register);
 
 /* Ensure soc_dev->attr is freed prior to calling soc_device_unregister. */
 void soc_device_unregister(struct soc_device *soc_dev)
@@ -153,6 +154,7 @@ void soc_device_unregister(struct soc_device *soc_dev)
 
 	device_unregister(&soc_dev->dev);
 }
+EXPORT_SYMBOL_GPL(soc_device_unregister);
 
 static int __init soc_bus_register(void)
 {
-- 
2.20.1



