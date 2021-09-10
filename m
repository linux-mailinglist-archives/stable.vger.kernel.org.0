Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF437406E50
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 17:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhIJPjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 11:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbhIJPjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 11:39:20 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D15C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 08:38:09 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id o16-20020a9d2210000000b0051b1e56c98fso2751304ota.8
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 08:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4OUjSFwrRAGpDIFN9FxVyB2vtxW6RQqNyeROlw7s5xw=;
        b=XtXesZTZE9oStOCyi187c6EWHnxq2Kob/B6B4rEs9GkCAESVi2XkXkxgWhmdzhKi9p
         dRrfvGLHbOdfe7DI5+OK712gV3PPUsGgpsjPqXSgqbwPRkNSwhs25Lp5356l8LukBq++
         s2gAJEzqXkfJOS6pKdn7sW6U7oKEVR/ppQ9qY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=4OUjSFwrRAGpDIFN9FxVyB2vtxW6RQqNyeROlw7s5xw=;
        b=jaWblsVrn/4vleTp/kAg+OYmkhJq2dpUznQ4fB0CqtN+V/aT0VKfQeEyrYKWVEFZys
         iN6SwzhrX7i1tnMDvFUIhMgTVqNrFh9XOUfG18kGvX3PoRVFpoUVZeNndemzUHNr9Mcg
         O9+BvDElb9Q/Z62dMGYWiKOgA7HUTjDlmy5JGisVv6hdUhUHd+2zlSi6hi+L2owmQg4C
         hVNNEjdU/gyETCYGReXxDHPpKT/396cKqoZClLRw2LNfNtItJTJnxeiPdz7CRoJAOXQB
         jqBj8AXwIqclYU1mIVd07tsh0OIviXYnHoqwHqsjqm5JBGspS2qSVAErWXd/yln3lB6n
         G7lg==
X-Gm-Message-State: AOAM533NWRSJiaYxCO5LHruPyYsZrDFYZ24Z3rv0oNQ6VnUPLpQq9TYX
        HrRZfAeoBf0F4LQ0RpBU4YppQ0bnqVGTTg==
X-Google-Smtp-Source: ABdhPJyMPQ+VWuAr5ViOdXIFdQZ6OytfUc6/hD51gFGm7/x9XzcC2mqBe09FZanpw2Kz4iVt3ocbCg==
X-Received: by 2002:a05:6830:4090:: with SMTP id x16mr5182136ott.71.1631288287761;
        Fri, 10 Sep 2021 08:38:07 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id r31sm1330074otv.45.2021.09.10.08.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 08:38:07 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
From:   "Justin M. Forbes" <jforbes@fedoraproject.org>
To:     stable@vger.kernel.org
Cc:     "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha
Date:   Fri, 10 Sep 2021 10:37:35 -0500
Message-Id: <20210910153735.2791941-1-jforbes@fedoraproject.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
This works fine with the existing driver once it knows to claim it.
Simple patch to add the device.

Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210702223155.1981510-1-jforbes@fedoraproject.org
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 8dc1b8eecb86..61b2797a34a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -558,6 +558,7 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x2074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x4070, iwl_ax201_cfg_qu_hr, NULL),
+	IWL_DEV_INFO(0xA0F0, 0x6074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x0070, iwl_ax201_cfg_quz_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x0074, iwl_ax201_cfg_quz_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x6074, iwl_ax201_cfg_quz_hr, NULL),
-- 
2.31.1

