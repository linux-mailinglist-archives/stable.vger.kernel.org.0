Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E8D59E553
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 16:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239409AbiHWOt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 10:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242050AbiHWOtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 10:49:02 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264E097B22;
        Tue, 23 Aug 2022 05:12:01 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e20so16261771wri.13;
        Tue, 23 Aug 2022 05:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=eqIxAdh3dxFeLaUkN++tdLeHyp4STzJsLqgAOtnS4QI=;
        b=Uew4XV48eTVsDHlZMqlCrgy6k950xz6HtnpTlxlVNJHtvxm/6C2KVvzr8YLoBqeEy9
         E8zxZ8XqTD0VeEw0tgo5ydcilKsoIMJrKzJuni6u8Kb1jyBJck71bZVKDlTWeSUE/XQM
         4duLaq2REeRir7bXeOta1Lujmh8Ccsrd7/iigak9AygUt3KS/WkMIc7FTDrddYTOLuDA
         JsNw2kUlpiwcXpHBmIMBrTr1MFlPyAp92Zz+DkqMztW44FzF7b9aHklPsl1puY/ORYKR
         ReIM9SYZ9oFth4loehl3XSjkry4gcdeC2ge447BgNJKw6uh0q4VFqZRjHMIaW/dBoQJW
         PN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=eqIxAdh3dxFeLaUkN++tdLeHyp4STzJsLqgAOtnS4QI=;
        b=SRjrURL/F0cTrxEwen0tvSQbNzWxoXx7ks/hjjk3rXbXWQe6Q636uhek9cMJhdoI0D
         qoV9VSQL77bVnRKaRVWDoL8wyVsP8N8IcS2M+HVW3GVklqM7yTy6hitiJnh0eOIuIxxo
         TsWCk9PF77Nff3NfykESddElvxGpKyoSSk0C5vGsQ4z9jN6sbXXVrPWrjPCIavfSoAm4
         HvXoqaOJnLRqn+kl72xSM4hze7kkHbFCpoJWA8Eg9O76XG6yTnv4TMHC5QZWNIm8xScJ
         bcSBVtGE+N1jzep1q+jVz6+HJMvAAbqP+RKqwOS/H6RbgMA72W8v7AwdpDmYNsNH59U5
         esTw==
X-Gm-Message-State: ACgBeo3VEZYSozqS0IbmOy9igGM102pdACPxw4l6r0KNxIN/HyI1FjkF
        nIoNKC3gxhOilTChj/Y5L3I=
X-Google-Smtp-Source: AA6agR4Ljs9ujt+NoH0NcFNiygWGSGrQ+Li/lF1TE+XTv05PFgyPEdQKUCetCyLUFwaQT+e7llmMng==
X-Received: by 2002:a5d:4882:0:b0:225:3148:9f85 with SMTP id g2-20020a5d4882000000b0022531489f85mr12484592wrq.224.1661256701938;
        Tue, 23 Aug 2022 05:11:41 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm24681879wmq.6.2022.08.23.05.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:11:41 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 0/6] xfs stable patches for 5.10.y (from v5.17)
Date:   Tue, 23 Aug 2022 15:11:30 +0300
Message-Id: <20220823121136.1806820-1-amir73il@gmail.com>
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

This 5.10.y backport series contains fixes from v5.17 release.

All the patches in this series have already been applied to 5.15.y
except for patch 2 which you have queued to 5.15.y yesterday [1].

Yesterday's 5.15.y series contains mostly fixed from v5.18/v5.19.
The applicable fixed from that series will be included in the next
5.10.y series.

Thanks,
Amir.

Changes from [v1]:
- Added Acked-by Darrick
- CC stable

[1] https://lore.kernel.org/linux-xfs/YwSADLkBPNe7hZQs@kroah.com/
[v1] https://lore.kernel.org/linux-xfs/20220822162802.1661512-1-amir73il@gmail.com/

Christoph Hellwig (1):
  fs: remove __sync_filesystem

Dan Carpenter (1):
  xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Darrick J. Wong (4):
  xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
  vfs: make sync_filesystem return errors from ->sync_fs
  xfs: return errors in xfs_fs_sync_fs
  xfs: only bother with sync_filesystem during readonly remount

 fs/sync.c          | 48 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_ioctl.c |  4 ++--
 fs/xfs/xfs_ioctl.h |  5 +++--
 fs/xfs/xfs_super.c | 13 ++++++++++---
 4 files changed, 40 insertions(+), 30 deletions(-)

-- 
2.25.1

