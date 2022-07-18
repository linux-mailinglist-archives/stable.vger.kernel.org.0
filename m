Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637D55783AE
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 15:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiGRN2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 09:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiGRN2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 09:28:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2060E140EC
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 06:28:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y8so15283647eda.3
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 06:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekNoOMr2FaZ8ZTxXyfqrfzfR8fZlgO4RZ1M5Jfu1l9A=;
        b=LkvaunAyiPVsdytM2I3zOiWcXbUrer+vjaWvltBTHhRnrznNznSWUK+WTQTuzOGLjK
         4GVc7tskGAz5DrpI2pGcQ9kVoTQZOR7k7uHcfIp3KAhWPr/0FWEKBgTkQ5tG9Rjs9XM8
         BeNZWZUTMbLMXOVxrcpwF/s5XoR5uYJDkr/FvSpemJ/Hk5erExuN3JCVdmMdRLQJhsNL
         CMT0+vPRoJTEsL1ghQ5uyYxbgCn3zY7yN2M73iteh87tGRFLPrx5ewDReJBDOd4q3F+w
         Jt4zPSklCfFB4/gj/LDR1T7GgaFmWB+U3kq/eAvukMgGbPKVwSsIZaT9G1QFM3i34J3h
         6Ejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekNoOMr2FaZ8ZTxXyfqrfzfR8fZlgO4RZ1M5Jfu1l9A=;
        b=Rt/fQSp3yd0mkP3XOIyydYYbieLbGc2PibN2rYQCce7oRsUFQosQUeH81XI1r3snYs
         43MBsmk+baCBxLp4E6Jb/tdT0gJ16hYDPZUgEjJQwMaemwo0rOMGjj+g8a4AisQmW1DL
         hJX7UbR/N9g9F1UsxRsLukSIOvyw3hyaKcvAjmuRrPy4Ca8sBc/bYD9H7nSIubbgguP0
         6uUbKcOBnsM2WDwRCneKbJn/sP+BktxYiDiJ1hrj9EFb8ZGKee2j9Om2NDTBEEimPwqx
         DZLYeJmriSINo53XGMM06OURYyEcLgQ4Woy9UnojfEhhLhrH7OxWmnCuKpL3/sPGOPKN
         jnpQ==
X-Gm-Message-State: AJIora/dpAbqqveITs0kWbDgRfb1QQAGxRwuU3vn86RTI2PhQeLkhknv
        LqRqB5sC64XxWEsTOOglpftYCQBkED0=
X-Google-Smtp-Source: AGRyM1t7Sa46g5J7POKtPfYEGV1IH3sjYBMWiT65E5QQR7ES793Fyr4TvvE94bruQ3kqrDUibiik/A==
X-Received: by 2002:aa7:c2d1:0:b0:43a:997:c6d8 with SMTP id m17-20020aa7c2d1000000b0043a0997c6d8mr35793012edp.161.1658150879171;
        Mon, 18 Jul 2022 06:27:59 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id s5-20020a1709066c8500b0071c6dc728b2sm5490219ejr.86.2022.07.18.06.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:27:58 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH v2 5.18 0/2] Backport support for Telit FN980 v1 and FN990
Date:   Mon, 18 Jul 2022 15:27:09 +0200
Message-Id: <20220718132711.393957-1-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
these two patches are the backport for 3.18.y of the following commits:

commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2
    bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revisio

commit 77fc41204734042861210b9d05338c9b8360affb
    bus: mhi: host: pci_generic: add Telit FN990

The cherry-pick of the original commits don't apply because the commit
89ad19bea649 (bus: mhi: host: pci_generic: Sort mhi_pci_id_table based
on the PID, 2022-04-11) was not cherry-picked. Another solution is to
cherry-pick those three commits all togheter.

In the following days I will send backport for longterm releases.

Thanks!

v2:
- fixed my email

Fabio Porcedda (2):
  bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
  bus: mhi: host: pci_generic: add Telit FN990

 drivers/bus/mhi/host/pci_generic.c | 79 ++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

-- 
2.37.1

