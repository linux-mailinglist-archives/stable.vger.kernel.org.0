Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F324095DC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344114AbhIMOpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345210AbhIMOoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A901619F8;
        Mon, 13 Sep 2021 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541436;
        bh=ANSZm/YMwfk0poU72HLtVbd0e0As2YxubIEnQqmiRCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPc9oQDe+aC18YVzOJf+hlt+WjO8tXaVgJqfEjzRTRuQkAKTi2m8MreDPt5u19uLD
         ZkgMza1G2jM005+8ZNYGP/ENs7VNAQ4PeGJlD3kRS0asr2+VnYUG78nOJjD1TPhaIj
         X4fnGCmDoW6avsZLW7N2O3OQcJ4jAH5/MUSIc3cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.14 296/334] iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha
Date:   Mon, 13 Sep 2021 15:15:50 +0200
Message-Id: <20210913131123.432947970@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin M. Forbes <jforbes@fedoraproject.org>

commit 2f32c147a3816d789722c0bd242a9431332ec3ed upstream.

The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
This works fine with the existing driver once it knows to claim it.
Simple patch to add the device.

Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210702223155.1981510-1-jforbes@fedoraproject.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -558,6 +558,7 @@ static const struct iwl_dev_info iwl_dev
 	IWL_DEV_INFO(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x2074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x4070, iwl_ax201_cfg_qu_hr, NULL),
+	IWL_DEV_INFO(0xA0F0, 0x6074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x0070, iwl_ax201_cfg_quz_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x0074, iwl_ax201_cfg_quz_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x6074, iwl_ax201_cfg_quz_hr, NULL),


