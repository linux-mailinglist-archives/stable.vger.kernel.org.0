Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36AD3AF009
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFUQqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233112AbhFUQmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2F4861449;
        Mon, 21 Jun 2021 16:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293084;
        bh=s3Sx6HFfbj/xDoJQAsWIo6+vWziz620qNYjm/K82GfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCO1U5sUJdBEFTQSMn+4/Xoz8mYAo76SD2Nz69GLnxs+OdxrOJOUClhsLwNNFRJbT
         +IQoPVYkb+x9DctemG4CCJB1OvW6Og5FSBuwzWgl3JmKNdRcE/sjRMn7CdhsUcCpa4
         NZsqtMTO/+Hw7KGNlwG/BWwR/s078lb0mH7FTGUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Til Jasper Ullrich <tju@tju.me>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 091/178] platform/x86: thinkpad_acpi: Add X1 Carbon Gen 9 second fan support
Date:   Mon, 21 Jun 2021 18:15:05 +0200
Message-Id: <20210621154925.805402091@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Til Jasper Ullrich <tju@tju.me>

[ Upstream commit c0e0436cb4f6627146acdae8c77828f18db01151 ]

The X1 Carbon Gen 9 uses two fans instead of one like the previous
generation. This adds support for the second fan. It has been tested
on my X1 Carbon Gen 9 (20XXS00100) and works fine.

Signed-off-by: Til Jasper Ullrich <tju@tju.me>
Link: https://lore.kernel.org/r/20210525150950.14805-1-tju@tju.me
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 61f1c91c62de..3390168ac079 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8808,6 +8808,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('N', '2', 'O', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (2nd gen) */
 	TPACPI_Q_LNV3('N', '2', 'V', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (3nd gen) */
 	TPACPI_Q_LNV3('N', '3', '0', TPACPI_FAN_2CTL),	/* P15 (1st gen) / P15v (1st gen) */
+	TPACPI_Q_LNV3('N', '3', '2', TPACPI_FAN_2CTL),	/* X1 Carbon (9th gen) */
 };
 
 static int __init fan_init(struct ibm_init_struct *iibm)
-- 
2.30.2



