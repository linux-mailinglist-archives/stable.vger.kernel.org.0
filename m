Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B043A9F66
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhFPPhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234851AbhFPPhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D6EA613B9;
        Wed, 16 Jun 2021 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857704;
        bh=Q3E8xfbjM05RzuhyWwvnswFZjcREW9jah/3PPBFnvEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6JT6GLFZ4nUkjkzooLEW7jFUSbSNz6zmjDlYG3nrzkZjS0iFAias5nY+XNuVjok6
         PXBpjL+D+DH7ingqFxjeY/u6eSlnwfv/bATx7J18Z4Y0FdN+7IbGfDT6+KuRpaG/pC
         52ZbYsl+3UsXDCTveMYfSVfetMPsXdhrQDGfCS2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bolhuis <mark@bolhuis.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/28] HID: Add BUS_VIRTUAL to hid_connect logging
Date:   Wed, 16 Jun 2021 17:33:18 +0200
Message-Id: <20210616152834.385130125@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bolhuis <mark@bolhuis.dev>

[ Upstream commit 48e33befe61a7d407753c53d1a06fc8d6b5dab80 ]

Add BUS_VIRTUAL to hid_connect logging since it's a valid hid bus type and it
should not print <UNKNOWN>

Signed-off-by: Mark Bolhuis <mark@bolhuis.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8d202011b2db..550fff6e41ec 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1998,6 +1998,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	case BUS_I2C:
 		bus = "I2C";
 		break;
+	case BUS_VIRTUAL:
+		bus = "VIRTUAL";
+		break;
 	default:
 		bus = "<UNKNOWN>";
 	}
-- 
2.30.2



