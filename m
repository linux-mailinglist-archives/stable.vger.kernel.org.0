Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9935059A554
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349711AbiHSSPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350228AbiHSSPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:25 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253BC13D66;
        Fri, 19 Aug 2022 11:14:38 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d71so4264560pgc.13;
        Fri, 19 Aug 2022 11:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=k8VR6LyMQ/VASaTeiHHeMXj88ybif2kViyX94kiK/Yo=;
        b=qWnblMxBWEnees4ZfIIGldm0NscZCNzVkKM77GXScvcBV63nIEOGoz6mz/sBVJXoET
         9mdEvPyPDH6mZbQcja3mvPewiblARZRTRNb72YCo0RAd3ppaY50M0WdyxlO5ljwaAPLJ
         lUexeUnxcVOOwV+/J5gEOarL2l+0gSZXM2HO4AGpS4Sig4r3Hsj42A2Q46QlDNFlTbNy
         xUJTDZP6MTIWsaVFd/lUYp6Mfj//XrZs9GN/gf9+qwyF24MA+15JOSp4dVzY6w2rJ9Zi
         B3n4k4khypKn0V99ubWj4fvfWZAE3icPx9SMDG4yLMxNOSJGxe3Uf9gs6lsqRNS6zms/
         RALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=k8VR6LyMQ/VASaTeiHHeMXj88ybif2kViyX94kiK/Yo=;
        b=WMQco8oQM3Vrb6lg2qfU62DsUxViHGipP7n68vzvdkZjBkqMNTSfBa81pA1NuvwXTc
         ydvkPbBfIR+jhHgkTLHPZi1CH2W+G2V0eayxMjxgOtyl2tnUzQaHCn+NNwiPHo84ft2A
         M6z61dW31DWAJoIRd0BDsr5FtSg0PgDwquaRpPtzTMywz9clctmrphBDgKtfaH7a27+4
         yh4ayTQHe6BWFQLAYH5O3FLPbqrlydXtJ9mSIYzgv8iHLuinWlPKukrHWmz3PWkORBFA
         gwSt89mAbnLSGf4al4oJK7+zu1TmVArhswzRWgUMJHLgQXp/9HcJHo4u3Me8eLDshHNI
         ubww==
X-Gm-Message-State: ACgBeo1OTfKzLRQvyc5kXnGc/hnYKbSD4JYRkur5iS90Z9l6W0VB/jEk
        KgRi2DsB4Bq3uGN46J8+FIvAZuKZKv8=
X-Google-Smtp-Source: AA6agR6RHO4+oksh3EnhF2gI+NSQZiJIcibZoRXYqgWQce0FhbMgn7y3SptXcsHeKpcC6yULbjrTwA==
X-Received: by 2002:a05:6a00:804:b0:52f:43f9:b634 with SMTP id m4-20020a056a00080400b0052f43f9b634mr9060395pfk.62.1660932877331;
        Fri, 19 Aug 2022 11:14:37 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:36 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 0/9] xfs stable candidate patches for 5.15.y (part 4)
Date:   Fri, 19 Aug 2022 11:14:22 -0700
Message-Id: <20220819181431.4113819-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
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

Hello,

Here's another round of xfs backports for 5.15.y that have been
through testing and ACK'd.

Thanks,
Leah

Brian Foster (2):
  xfs: flush inodegc workqueue tasks before cancel
  xfs: fix soft lockup via spinning in filestream ag selection loop

Darrick J. Wong (6):
  xfs: reserve quota for dir expansion when linking/unlinking files
  xfs: reserve quota for target dir expansion when renaming files
  xfs: remove infinite loop when reserving free block pool
  xfs: always succeed at setting the reserve pool size
  xfs: fix overfilling of reserve pool
  xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*

Eric Sandeen (1):
  xfs: revert "xfs: actually bump warning counts when we send warnings"

 fs/xfs/xfs_filestream.c  |  7 ++--
 fs/xfs/xfs_fsops.c       | 50 ++++++++++-------------
 fs/xfs/xfs_icache.c      | 22 ++--------
 fs/xfs/xfs_inode.c       | 79 ++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.c       |  2 +-
 fs/xfs/xfs_trans.c       | 86 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h       |  3 ++
 fs/xfs/xfs_trans_dquot.c |  1 -
 8 files changed, 167 insertions(+), 83 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

