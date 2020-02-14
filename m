Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D672215DD8E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbgBNP73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387741AbgBNP71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9337B24676;
        Fri, 14 Feb 2020 15:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695967;
        bh=sftqDrVedCNgEQstcp7pxI39xqd6ochty3mZXmQW/+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIgIGirBHcBO2S4/tjgIfL7JoDeFSK/D/tzKv5MduL7ADnkMCL5mTR/a6JHJ25O4H
         5xQxJeAvY5UK0cIvVcaNuhLcDE4qeRVAOOQ8MdulkOfcGGBxWfVDUBXh0zKtonMplP
         7ioVJOwnu5XRRXTKX4WMQ2z8RvP/LQaB2SQgV6Qw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Jean Delvare <jdelvare@suse.de>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 495/542] docs: i2c: writing-clients: properly name the stop condition
Date:   Fri, 14 Feb 2020 10:48:07 -0500
Message-Id: <20200214154854.6746-495-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ceresoli <luca@lucaceresoli.net>

[ Upstream commit 4fcb445ec688a62da9c864ab05a4bd39b0307cdc ]

In I2C there is no such thing as a "stop bit". Use the proper naming: "stop
condition".

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Reported-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/i2c/writing-clients.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/i2c/writing-clients.rst b/Documentation/i2c/writing-clients.rst
index ced309b5e0cc8..3869efdf84cae 100644
--- a/Documentation/i2c/writing-clients.rst
+++ b/Documentation/i2c/writing-clients.rst
@@ -357,9 +357,9 @@ read/written.
 
 This sends a series of messages. Each message can be a read or write,
 and they can be mixed in any way. The transactions are combined: no
-stop bit is sent between transaction. The i2c_msg structure contains
-for each message the client address, the number of bytes of the message
-and the message data itself.
+stop condition is issued between transaction. The i2c_msg structure
+contains for each message the client address, the number of bytes of the
+message and the message data itself.
 
 You can read the file ``i2c-protocol`` for more information about the
 actual I2C protocol.
-- 
2.20.1

