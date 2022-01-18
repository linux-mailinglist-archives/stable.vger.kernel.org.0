Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C28A492A92
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347471AbiARQL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:11:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40912 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346903AbiARQJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:09:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13FA8612B5;
        Tue, 18 Jan 2022 16:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AACC00446;
        Tue, 18 Jan 2022 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522192;
        bh=J3iXzUqLeP5YkWfIgk8j4YszItzziECauTG8JYpvue4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DxyRYQUD7wVTcLJ4XOy9B3DZLo+x/Hjn0GKbQsw8oemZiKlGEtyl8iZGDTfi9YSm
         aYy4+7i8qFhhSkN1FKiYNyTwdR3GIq0+pGNlRb5r8LRHXveAaVyj0VauPz/oXg1LKg
         v1Jjsr9Xf+CG43fhsFz2n+yJD/BWpfP6Zb5PDc3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 11/28] remoteproc: qcom: pas: Add missing power-domain "mxc" for CDSP
Date:   Tue, 18 Jan 2022 17:05:57 +0100
Message-Id: <20220118160452.253523622@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit dd585d9bfbf06fd08a6326c82978be1f06e7d1bd upstream.

Add missing power-domain "mxc" required by CDSP PAS remoteproc on SM8350
SoC.

Fixes: e8b4e9a21af7 ("remoteproc: qcom: pas: Add SM8350 PAS remoteprocs")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Cc: stable@vger.kernel.org
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1624559605-29847-1-git-send-email-sibis@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -661,6 +661,7 @@ static const struct adsp_data sm8350_cds
 	},
 	.proxy_pd_names = (char*[]){
 		"cx",
+		"mxc",
 		NULL
 	},
 	.ssr_name = "cdsp",


