Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793115A8D9A
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiIAFto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbiIAFt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:49:29 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A971178F1;
        Wed, 31 Aug 2022 22:49:12 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so709312wmk.3;
        Wed, 31 Aug 2022 22:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=iiNLSCWLhtCWiCCcJz0yWTZ68ge6jNEThNiRP9eJfB8=;
        b=JDj+wJdZpRGnMuGNQitYlGrq7Zc4WbsD0CATrexZMwvDwa5Gp7JkQSIgGDCcH9vGr5
         LqjzWPy1P6+vaoPQ634cmAI9NId3DzsgAGXajND1CAckWwz2vC4nhGfNarSGA1CWhPq8
         HR7NLeMBYw73rfPRJShcAKCLgK8tu7TmH0dKNz7oVrKhbBHtYfcHoS2Iv/J0Q04CwrG9
         tmcfko1VZxqrlrkkxSnnlUTV8jd+wNkBUOMmSiSALPcSEid6WSirivwQM6rbKa0y33IM
         AmKNkVXkUEzccCQhxesou23DJ8GN8jsb2FGWa2ZapKfl85nSIJ/7dosFWGJrDhtHotPL
         O/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=iiNLSCWLhtCWiCCcJz0yWTZ68ge6jNEThNiRP9eJfB8=;
        b=re4yaHnROmIjAxp1Tw7u9MmWLcgxmmOCXFNgoija2XY7RSSBagcwRTJVFaZwUwglzL
         D4rYBKzY0ObdG9LqyvrxbOIv/Rlgw4fETLj/a4YdfmCMbG8iiZxnHxHBNXtqK51NKeZT
         iaL8lfFgm8oAdcJA+u0/E3WPcT+7Uggp6HQuMp8tKC30wsuWcE0W/vHVNGeI36La3AXz
         FVfNtY103T49t7M7JJLtoOpZc7yYQwPiAuVZQGWKbAYSCLTKTTaFQ+DYAWB0bjoqL8zd
         NY+yx9zP8x+RsSjupSAOl56vRtIX79My9R2vGnj6HTZqRXOOETHVP3+obwqCveVZHfbe
         Rpzw==
X-Gm-Message-State: ACgBeo1mIEwHomiHqD1ROyexvPzO5Mdu6WONXL41ajEM8KE+psZLRdar
        ywddX8WZ49UbaJNDC4yzR7p28RFizLY=
X-Google-Smtp-Source: AA6agR5+lSPFqp5iJOIOZEAs1O2kESYuLc97xb8SaHTh0dX8oXd5CUM309oET15LaHgUerRSSJrcsg==
X-Received: by 2002:a05:600c:2059:b0:3a5:92cc:19c5 with SMTP id p25-20020a05600c205900b003a592cc19c5mr3748475wmg.101.1662011341621;
        Wed, 31 Aug 2022 22:49:01 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id bg15-20020a05600c3c8f00b003a4f08495b7sm4447262wmb.34.2022.08.31.22.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:49:00 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 0/7] xfs stable patches for 5.10.y (from v5.18+)
Date:   Thu,  1 Sep 2022 08:48:47 +0300
Message-Id: <20220901054854.2449416-1-amir73il@gmail.com>
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

Patches 1-5 in this series have already been applied to 5.15.y in Leah's
latest update [1], so this 5.10.y is is mostly catching up with 5.15.y.

Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
I pointed Leah's attention to these patches and she said she will
include them in a following 5.15.y update.

Thanks,
Amir.

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

Dave Chinner (2):
  xfs: reorder iunlink remove operation in xfs_ifree
  xfs: validate inode fork size against fork format

Eric Sandeen (1):
  xfs: revert "xfs: actually bump warning counts when we send warnings"

 fs/xfs/libxfs/xfs_inode_buf.c | 35 +++++++++++++++++------
 fs/xfs/xfs_filestream.c       |  7 +++--
 fs/xfs/xfs_fsops.c            | 52 ++++++++++++++---------------------
 fs/xfs/xfs_inode.c            | 22 ++++++++-------
 fs/xfs/xfs_mount.h            |  8 ++++++
 fs/xfs/xfs_trans_dquot.c      |  1 -
 6 files changed, 71 insertions(+), 54 deletions(-)

-- 
2.25.1

