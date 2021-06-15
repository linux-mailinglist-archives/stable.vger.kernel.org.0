Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905C63A84AA
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhFOPvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhFOPvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C87B8615A0;
        Tue, 15 Jun 2021 15:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772153;
        bh=57/uMMEeMR9p9mCBxGKJPQGCdTcaBRY23AecR/wg6mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GX9snzPX20uA7/D0ziaPlKCAVdJ/iCDVZQje7cqo97UH+ebx9oTj/oUqk51mAN/LC
         vFto6dcDm7EvN23Hhc209ZlxZLGmXzYoQwGTIiJEtmwa6czP9B+bx47hrM1Hbu/+xQ
         ggow9qo1ZABOupRzZupug1bwpU7z6OFt4gI7BSdaK/ApueXNJFSHFs0mWSZiMcIzN7
         rJs4ORo7heAt2bQc50dVKN+gSFK6GhgiPBCteQhnIWZtrUcdRY58lyyMEQHulvSZEO
         Qy0IfBrryLH1Etgng72Dii71SZc0k8ORW50zm7D9L5lTwpJZl+NlJnrqSmIp1l/gm0
         NkTOCjYbgGtzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Til Jasper Ullrich <tju@tju.me>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/30] platform/x86: thinkpad_acpi: Add X1 Carbon Gen 9 second fan support
Date:   Tue, 15 Jun 2021 11:48:41 -0400
Message-Id: <20210615154908.62388-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1c25af28a723..5c2f2e337b57 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8806,6 +8806,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('N', '2', 'O', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (2nd gen) */
 	TPACPI_Q_LNV3('N', '2', 'V', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (3nd gen) */
 	TPACPI_Q_LNV3('N', '3', '0', TPACPI_FAN_2CTL),	/* P15 (1st gen) / P15v (1st gen) */
+	TPACPI_Q_LNV3('N', '3', '2', TPACPI_FAN_2CTL),	/* X1 Carbon (9th gen) */
 };
 
 static int __init fan_init(struct ibm_init_struct *iibm)
-- 
2.30.2

