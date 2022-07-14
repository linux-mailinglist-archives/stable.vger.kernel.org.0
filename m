Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C5857578A
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 00:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiGNWX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 18:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGNWX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 18:23:56 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2AD2A719;
        Thu, 14 Jul 2022 15:23:53 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f11so2810257pgj.7;
        Thu, 14 Jul 2022 15:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GrQV6iNLDMXH0QTlx2PYlgW6Uql4mzR+vgrBH9uEKwU=;
        b=QT/hoMZdj571rBQP0fsCs2fBzL+rqaxohLuAE76/cLJKwby5jm48NtA+6O+wBA4IRF
         /aqOlKdVVS025TuISb7gcnlHPYB6cjPdxOpyHCW99ac+kEfFJKcMXIuoyG3pdzKMVpEZ
         Pa7OEUJffo265WFuFZLHhAKpHMHFx7znQuB1fwW+s18Rjwm3KftX0ee4f7JqtOOL/AtZ
         MGEf1wek/8BoTn3Plmq/r7FZHuyuAxzr6qxNZGBwpkoiRF8R0jhPoILLAF9nx0LDo3v+
         E8iqUbjDCQuG3qUKKeFmJkmOl/0K2eaBe/8EoJy8kDdEQh1G3LpDXtIZojAmNjAB6ZY3
         aWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GrQV6iNLDMXH0QTlx2PYlgW6Uql4mzR+vgrBH9uEKwU=;
        b=uQ4LYEKv32f3rIZUqVFOEXA+GUtVHZtDlgkZsuki+wjtWU/33DYZBRzKjcJkRyge5F
         wT7KjgjSFnQ3k/A4DuxnSIxjiqruU0jfUrn11nmvSQudAjSYubqYMEppOP9xtg5e+MlV
         7bgEkLf3jub645Vr7Lovc+jScijUnmwnW9wbZcMcfcw0CzIV6nGayZieAyDHuSnliQg2
         XQ1Gq+0fLcowenqYbNJfpViPQNk/Jy1w9DsyBcpllfqUSmZp2YTR+TbXbWiURBP8w90s
         IBuv8M+ob0RugDjv1bIuvCJicxXDSV+C740bitfTnodcWgUijKoQmAC6H+1sLsuS6BBi
         AWvA==
X-Gm-Message-State: AJIora9agSreAMjW7An/t5PudFwO4htlkTuqspzFxGB1vT57a7iHg7Hs
        9rx28VXGdFKAhkdRGk9CZTretccKVUc=
X-Google-Smtp-Source: AGRyM1uZhNb6TPSVPYY1Tw/dzPU6tOduf/xXYcNhprbvfU61QRGl1J1Sd4srdYgNuuHQ6ac0roqZmw==
X-Received: by 2002:a05:6a00:2446:b0:528:5da9:cc7 with SMTP id d6-20020a056a00244600b005285da90cc7mr10670417pfj.51.1657837433187;
        Thu, 14 Jul 2022 15:23:53 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:4f72:1916:7fb3:18])
        by smtp.gmail.com with ESMTPSA id q25-20020a635059000000b0040c644e82efsm1884464pgl.43.2022.07.14.15.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 15:23:52 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 0/4] xfs stable candidates for 5.15.y (part 2)
Date:   Thu, 14 Jul 2022 15:23:38 -0700
Message-Id: <20220714222342.4013916-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
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

Hello again,

This is a 5.15.y only set of xfs fixes. They have been tested and Ack'd.

Changes from v1->v2:
- Added Acks

[v1] https://lore.kernel.org/linux-xfs/20220707223828.599185-1-leah.rumancik@gmail.com/

Darrick J. Wong (2):
  xfs: only run COW extent recovery when there are no live extents
  xfs: don't include bnobt blocks when reserving free block pool

Dave Chinner (2):
  xfs: run callbacks before waking waiters in
    xlog_state_shutdown_callbacks
  xfs: drop async cache flushes from CIL commits.

 fs/xfs/xfs_bio_io.c      | 35 ------------------------
 fs/xfs/xfs_fsops.c       |  2 +-
 fs/xfs/xfs_linux.h       |  2 --
 fs/xfs/xfs_log.c         | 58 +++++++++++++++++-----------------------
 fs/xfs/xfs_log_cil.c     | 42 +++++++++--------------------
 fs/xfs/xfs_log_priv.h    |  3 +--
 fs/xfs/xfs_log_recover.c | 24 ++++++++++++++++-
 fs/xfs/xfs_mount.c       | 12 +--------
 fs/xfs/xfs_mount.h       | 15 +++++++++++
 fs/xfs/xfs_reflink.c     |  5 +++-
 fs/xfs/xfs_super.c       |  9 -------
 11 files changed, 82 insertions(+), 125 deletions(-)

-- 
2.37.0.170.g444d1eabd0-goog

