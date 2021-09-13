Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30751409002
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244069AbhIMNsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243726AbhIMNqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:46:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BFAB61130;
        Mon, 13 Sep 2021 13:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539923;
        bh=1Tc804IjHjM3IJCMC6Sly5GFibfF3XT6xZsmlbERyGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLkAkl05cR1mRZlzcDr2vnOWNODwhpR/s8+UkQXLsoAoLrevPCqO7UzKQP2oYqEVa
         4SwKzl2I5hAMx6CC+V7ePGPoajF00KgzFQgAXNx1RYbLlPaxXVuha9qjjtf0aG2mc2
         Yygidk65pfenx2ywX4ePgKtH+VZaonELm4HjPQGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 216/236] iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha
Date:   Mon, 13 Sep 2021 15:15:21 +0200
Message-Id: <20210913131107.712241840@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
@@ -646,6 +646,7 @@ static const struct iwl_dev_info iwl_dev
 	IWL_DEV_INFO(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x2074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x4070, iwl_ax201_cfg_qu_hr, NULL),
+	IWL_DEV_INFO(0xA0F0, 0x6074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x0070, iwl_ax201_cfg_quz_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x0074, iwl_ax201_cfg_quz_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x6074, iwl_ax201_cfg_quz_hr, NULL),


