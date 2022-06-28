Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7319055ECBB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiF1SkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiF1SkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:40:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9582D22B10;
        Tue, 28 Jun 2022 11:40:15 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id c6-20020a17090abf0600b001eee794a478so6163724pjs.1;
        Tue, 28 Jun 2022 11:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=396F1jQCQ6ldeIv3PdYmbEsKKjTSdu1R76gP5395cC8=;
        b=Uqp9cnj1dA/mU6CnRCMnnu3ENIQ6wCQhNa+2OW65YQKSc/fkvBUCS0jsA5oinrStTO
         SFRElAi7Kl0UeK156w07YHHk/Pqp1tHHFWwXKDefiJqRCZZftvI5YcSrAmw/LGQqk1RM
         jVyFryPGIY/P6vwwGYsOkumWlbw3IhGbxVd9TWRAbzzETKv2Rv5M1Q3Jr3XnHnX9S5q9
         sBTcVEOvnaz8lrvRoSaaFBRz/jrD2sbPPe0RLMOQrwNvEP4CMFin23PYJorfiNegtH4K
         pM9LKhp4JGXQS9ssfBS69sWY/5twgvKrUaZkbAQU4ziu0pZcPfjdezGtIZPt3e78yih9
         66pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=396F1jQCQ6ldeIv3PdYmbEsKKjTSdu1R76gP5395cC8=;
        b=lcA51PO+i1TVhZx3ac0WHmkCdRo655DMJqIM2H2NucpYGwJC4/rYyaSna4a60pn3og
         ZuQGYuwfhl0u5xsOnV2OZUtuW7QIWDbqplcIE09SUJT9gHL+9XWOqK6Nj5QfJUFVaC3w
         U2qFIqJcECXhXvCpwZPoAFrQ3K8vTMWm7DZdxIZcVXKYKM0sSOdvDlIgwqyIBVlhN90V
         QWvCFCeLJpVP/xaOzPbBExfo5Cv2A0LrutpkXgW8FIpQceMBVyY3pbUS/8yfFosX5CHQ
         5Z5xRiH8yhf9PKbFaMxPe6iVrV3rHhXQpK0c+2oYD1G9iEcyghRPjTzUfgTHcq8ld7Pg
         Pr4w==
X-Gm-Message-State: AJIora+qgOKwa1ybzUHtapdqtBD3uuE3ihDEES+yl0/N+NznO8pOG0cE
        cNeNfVKjbgGqoQSZth22XzOrwMM+uqs=
X-Google-Smtp-Source: AGRyM1sDAfA8PpZNDkJLKJd3HE0RnvZ/hmfswmZkJvaoAVt361Z2jKTuQ8icq/qNXfdf9l3bdHZ9wA==
X-Received: by 2002:a17:90b:38c6:b0:1ed:431f:3793 with SMTP id nn6-20020a17090b38c600b001ed431f3793mr1127364pjb.166.1656441614866;
        Tue, 28 Jun 2022 11:40:14 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:1d5d:7791:41a3:902a])
        by smtp.gmail.com with ESMTPSA id a20-20020a621a14000000b005251bea0d53sm9743498pfa.83.2022.06.28.11.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:40:14 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v4 0/7] xfs stable patches for 5.15.y
Date:   Tue, 28 Jun 2022 11:39:44 -0700
Message-Id: <20220628183951.3425528-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
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

Hi Greg and Sasha,

This is the 5.15.y series corresponding to the 5.10.y set that Amir
recently sent out [1]. These patches have been tested on both 5.10.y
and 5.15.y with no regressions found. This series has been ACK'ed by
the XFS developers for 5.15.y and are ready for 5.15 stable.

Best,
Leah

Changes from [v3]:
- Post to stable

Changes from [v2]:
- Drop SGID fix [2]
- Added Acks from Darrick for remaining patches

Changes from [v1]:
- Increased testing
- Reduced patch set to overlap with 5.10 patches


[v1]: https://lore.kernel.org/linux-xfs/20220603184701.3117780-1-leah.rumancik@gmail.com/
[v2]: https://lore.kernel.org/linux-xfs/20220616182749.1200971-1-leah.rumancik@gmail.com/
[v3]: https://lore.kernel.org/linux-xfs/20220623203641.1710377-1-leah.rumancik@gmail.com/

[1] https://lore.kernel.org/linux-xfs/20220627065140.2798412-1-amir73il@gmail.com/
[2] https://lore.kernel.org/linux-xfs/20220617100641.1653164-12-amir73il@gmail.com/


Brian Foster (1):
  xfs: punch out data fork delalloc blocks on COW writeback failure

Darrick J. Wong (3):
  xfs: remove all COW fork extents when remounting readonly
  xfs: prevent UAF in xfs_log_item_in_current_chkpt
  xfs: only bother with sync_filesystem during readonly remount

Dave Chinner (1):
  xfs: check sb_meta_uuid for dabuf buffer recovery

Rustam Kovhaev (1):
  xfs: use kmem_cache_free() for kmem_cache objects

Yang Xu (1):
  xfs: Fix the free logic of state in xfs_attr_node_hasname

 fs/xfs/libxfs/xfs_attr.c      | 17 +++++++----------
 fs/xfs/xfs_aops.c             | 15 ++++++++++++---
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_extfree_item.c     |  6 +++---
 fs/xfs/xfs_log_cil.c          |  6 +++---
 fs/xfs/xfs_super.c            | 21 ++++++++++++++++-----
 6 files changed, 42 insertions(+), 25 deletions(-)

-- 
2.37.0.rc0.161.g10f37bed90-goog

