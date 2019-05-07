Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36415A5C
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbfEGFmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbfEGFmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:42:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895C3205ED;
        Tue,  7 May 2019 05:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207741;
        bh=eyHWK7PpS073w44Gq74gPMB8ySdEnmpLLuS0So+nWHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vf8Cuyifg0lfHocSSgdBB+lPoPhws785u8JVmtDOmEaNAlaidQir7A5dAZIZ4YPwj
         m6AnKvpWQVPhCmrITO8T4sEdHiSRxdtcwE/frpvJcARyfZqCW4wfzdrsAV+sgKyG/t
         cecvQQA8QjOsrPkbzYNnaChKomqbKhkaMg1GX8Wo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/14] HID: input: add mapping for Expose/Overview key
Date:   Tue,  7 May 2019 01:42:04 -0400
Message-Id: <20190507054218.340-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507054218.340-1-sashal@kernel.org>
References: <20190507054218.340-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 96dd86871e1fffbc39e4fa61c9c75ec54ee9af0f ]

According to HUTRR77 usage 0x29f from the consumer page is reserved for
the Desktop application to present all running user’s application windows.
Linux defines KEY_SCALE to request Compiz Scale (Expose) mode, so let's
add the mapping.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 8d74e691ac90..01b41ff43056 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -913,6 +913,8 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x2cb: map_key_clear(KEY_KBDINPUTASSIST_ACCEPT);	break;
 		case 0x2cc: map_key_clear(KEY_KBDINPUTASSIST_CANCEL);	break;
 
+		case 0x29f: map_key_clear(KEY_SCALE);		break;
+
 		default: map_key_clear(KEY_UNKNOWN);
 		}
 		break;
-- 
2.20.1

