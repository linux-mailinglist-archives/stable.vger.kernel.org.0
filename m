Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8969F5A98FE
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiIANgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiIANfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:35:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611EAC1C;
        Thu,  1 Sep 2022 06:34:04 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so1463558wmb.4;
        Thu, 01 Sep 2022 06:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=TmG3Y1AHEuP0q6JfKuETQ8G7rdqHcScavC2s+SiEzdw=;
        b=hDI8z1n2jZtHmJtCNAv3SifMKHQUComiwHmCb3znQuMAoO4HaUzzNYnmapnZXPKiY/
         KdFKHZc/gtCauiEY8+RIuaE7VdCkMuGVIDzNzKxkozM7aP8RvP8DGbzSIw0xk+6P3JWz
         9q8St2xUhaDpBN/g86x68G4rxWlGoVExMajM/YTmoJWU7sgvwFfwusDpk4TWFwTiHSci
         q99CORDmDyMjBR/WbTdXWyteLUrefnqDJsuMcf+vI9K2vMbEvb+Q4bOx8Rg7syXLFQb9
         ukWTxU1G3piXjxgTfIc5UTVz50IYq2Eq2tuOVDNC9CKATYiA8GWvZthsn9E712h2s4vb
         ap8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=TmG3Y1AHEuP0q6JfKuETQ8G7rdqHcScavC2s+SiEzdw=;
        b=h5AsLlNyf4G4F4ZgCs6tJWElGaXkvFotpaXDkgJLgeYXyHzk2T5DZBZg6FmlUB6BgT
         D/wpYtC44y3oaEGq8T6TBfUFZGmrIdDsDaz7lZtYqaUKctnHcE19LpTC6iW9Xh098H+E
         hqtB6rtUogJrweNoiYKDX7doAokpn+Um4LoS+M6RO48Ud6vSH05NRyzaJ20ToRiUs9in
         q+2kgZUS9K4zBJZ+LkPZB6r77ZRlgx+bVhO5caFhnsS+3xYDaOyfS03SDPJAuHYGvX+Y
         uljcWHus1SguZPctQQ7tLm+0VyiRfPBD1lAW+Y+Sm+4z8letVBQTq+fLwVz8vPHqBAOt
         Ip6w==
X-Gm-Message-State: ACgBeo1/255XsPNG+79mzlFML8a7911pNqVotuaO0qUc5AF2afqiIn+f
        taMQiBKH4Dumvo7THvNNjurErFzAbLY=
X-Google-Smtp-Source: AA6agR6VjbCu6/GGg/LkE1McQKS7Vd2Uv9qFP0kwRdnaY4kYaF23dykIIQgvWz4a8IJBkZIH+kxppA==
X-Received: by 2002:a05:600c:1992:b0:3a6:23f6:8417 with SMTP id t18-20020a05600c199200b003a623f68417mr5024869wmq.14.1662039242851;
        Thu, 01 Sep 2022 06:34:02 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b0022529d3e911sm15516390wrb.109.2022.09.01.06.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:34:02 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v3 0/5] xfs stable patches for 5.10.y (from v5.18+)
Date:   Thu,  1 Sep 2022 16:33:51 +0300
Message-Id: <20220901133356.2473299-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This 5.10.y backport series contains fixes from v5.18 and v5.19-rc1.

The patches in this series have already been applied to 5.15.y in Leah's
latest update [1], so this 5.10.y is is mostly catching up with 5.15.y.

Thanks,
Amir.

Changes since v2:
- Drop 2 patches not in 5.15.y yet

Changes since v1:
- Added ACKs
- CC stable

[1] https://lore.kernel.org/linux-xfs/20220819181431.4113819-1-leah.rumancik@gmail.com/

Amir Goldstein (1):
  xfs: remove infinite loop when reserving free block pool

Brian Foster (1):
  xfs: fix soft lockup via spinning in filestream ag selection loop

Darrick J. Wong (2):
  xfs: always succeed at setting the reserve pool size
  xfs: fix overfilling of reserve pool

Eric Sandeen (1):
  xfs: revert "xfs: actually bump warning counts when we send warnings"

 fs/xfs/xfs_filestream.c  |  7 +++---
 fs/xfs/xfs_fsops.c       | 52 ++++++++++++++++------------------------
 fs/xfs/xfs_mount.h       |  8 +++++++
 fs/xfs/xfs_trans_dquot.c |  1 -
 4 files changed, 33 insertions(+), 35 deletions(-)

-- 
2.25.1

