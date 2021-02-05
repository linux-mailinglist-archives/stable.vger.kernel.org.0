Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DAD311101
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhBERjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233272AbhBEP51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:57:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2F6365083;
        Fri,  5 Feb 2021 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534408;
        bh=byT5am75vna2ySvWbxeD5qPVxeMMVYztJNDFDpLwQJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4oSAJk4Pk0R8lUCUKCQ+SP0IZoNm5lWY31V/qT7cmcaCbl19VdiFYqQV/rDj5kyw
         ygT2/3ecpIjomMKASyliqScMTF9nLERUiRxmb5thRkJ6bpfiE9ph3EGk80rdqSMwgJ
         AdSG/FUHMVYXAahCj5XI9sVbK1HASTVS7NzIWQfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnold Gozum <arngozum@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/32] platform/x86: intel-vbtn: Support for tablet mode on Dell Inspiron 7352
Date:   Fri,  5 Feb 2021 15:07:31 +0100
Message-Id: <20210205140653.032402575@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnold Gozum <arngozum@gmail.com>

[ Upstream commit fcd38f178b785623c0325958225744f0d8a075c0 ]

The Dell Inspiron 7352 is a 2-in-1 model that has chassis-type "Notebook".
Add this model to the dmi_switches_allow_list.

Signed-off-by: Arnold Gozum <arngozum@gmail.com>
Link: https://lore.kernel.org/r/20201226205307.249659-1-arngozum@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 37035dca469cf..d4fc2cbf78703 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -203,6 +203,12 @@ static const struct dmi_system_id dmi_switches_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Switch SA5-271"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7352"),
+		},
+	},
 	{} /* Array terminator */
 };
 
-- 
2.27.0



