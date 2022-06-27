Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF68055CA8D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiF0GwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiF0Gv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:51:59 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F3926C0;
        Sun, 26 Jun 2022 23:51:58 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d17so5932927wrc.10;
        Sun, 26 Jun 2022 23:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W2M5s8x1+ee/Z4Z/TSY9grj1WlnFFDH9hAqBXY+Zc8E=;
        b=ogsjoIc2+xHLJTNLCFQ5nlz9Klx5579x/DIWsH6SLNdcCydwJtcwD0JiGTSBTPR4qQ
         zn8w6CmoGQv6IPPlj1GUu4yOdKC0nEbxsJ6epnerOqy8l6pBWKC54sNyxHJaDvXKM+8J
         gc3LWxlPdNqIBc8NjSkCF/m4aVV26RyRsmFUFrpf/YUZigefLZIpC62pFHFzn+oANsAX
         Qf/sMl7fYPXqe5rFd7WY+KGowKSnDdFii5r5e0K7T5DLPVqk4LM9ZW1SzDKjTiTbT+dB
         5XIZujIhsNFM/R8vVHZVaR5kfdqjj1XVJntYZlGWO3KoixdQXOJchKPpV+ll84lkIa7L
         f/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W2M5s8x1+ee/Z4Z/TSY9grj1WlnFFDH9hAqBXY+Zc8E=;
        b=pzbXabs2NOH9cL/X9hma2HEkQArE+fWDG72XjTa26ooUp9H4Lp5GE31cSew1CDpdqp
         cj/tCRhq8sCYeiZCnICVyravhHmqAWqc4nepWw9wK8UL2H6fu71kb/Raz1K59mhI94Fs
         LqgP+B3jj6OcEr05h5O/dBXRX5zbU0wBUisQGv/oFfdz6U7KClJrNfo1Tx6GwlVSrQrV
         mwne+Gmwxd/XcWfesooVfpJ3l6ZCS7QSNmHQzZmW8MeA/xnTM8Jk+W/8UMzdZ9m98gbF
         OyJtRm54LX6yNbnoVo5aCOVed48noJjKXgproS0H7aRt898op9YSOQmKe7oQ3DsRqBU0
         fp3g==
X-Gm-Message-State: AJIora86xPmaP1Hq2LlbVGf03zNKDmyMcJ/Lnn2gI8+T71UTmK7bE4xW
        Jw0K2cwsyqGXUBhfm+586xGlYm7fiFw8Ug==
X-Google-Smtp-Source: AGRyM1tJsaTJ+JQWY+7QrVCY1/k8rXEqv2ryljZuiQsIrJMVcKjsdkKRdSgw49mX8p8r17kBkcpbgg==
X-Received: by 2002:adf:f245:0:b0:21b:c705:8b1 with SMTP id b5-20020adff245000000b0021bc70508b1mr5955614wrp.282.1656312717413;
        Sun, 26 Jun 2022 23:51:57 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id e10-20020adffd0a000000b0021a3dd1c5d5sm9415076wrr.96.2022.06.26.23.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:51:56 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v4 0/5] xfs stable patches for 5.10.y (backports from v5.15.y)
Date:   Mon, 27 Jun 2022 09:51:35 +0300
Message-Id: <20220627065140.2798412-1-amir73il@gmail.com>
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

[resend with PATCH 5.10 prefix]

Hi Greg,

We started to experiment with the "xfs stable maintainers" concept that
Darrick has proposed.

My focus is on 5.10.y backports,
Leah's focus is on 5.15.y backports and
Chandan may pick up the 5.4.y backports.

This stable update is the first collaborated series for 5.10.y/5.15.y.

It started with a 5.15.y patch series from Leah [1] of patches that
specifically fix bugs prior to 5.10, to whom I already had tested
5.10 backport patches for.

Leah will be sending the ACKed 5.15.y series [2].
This 5.10.y series is a subset of the 5.15.y series that was
ACKed by xfs developers for 5.10.y.

All the patches in the 5.15.y series were backported to 5.10.
The ones that are not included in this 5.10.y update were more subtle
to backport, so the backports need more time for review and I will send
them in one of the following stable updates.

I would like to thank Darrick for reviewing the backport candidates.
I would like to thank Luis for his ongoing support of the kdevops [3]
test environment and Samsung for contributing the hardware to drive it.

Thanks,
Amir.

Changes since v3:
- PATCH 5.10 prefix

Changes since [v2]:
- CC stable

Changes since [v1]:
- Leave 5 out of 11
- Accked by Darrick

[1] https://lore.kernel.org/linux-xfs/20220616182749.1200971-1-leah.rumancik@gmail.com/
[2] https://lore.kernel.org/linux-xfs/20220623203641.1710377-1-leah.rumancik@gmail.com/
[3] https://github.com/linux-kdevops/kdevops
[v1] https://lore.kernel.org/linux-xfs/20220617100641.1653164-1-amir73il@gmail.com/
[v2] https://lore.kernel.org/linux-xfs/20220624063702.2380990-1-amir73il@gmail.com/

Brian Foster (1):
  xfs: punch out data fork delalloc blocks on COW writeback failure

Darrick J. Wong (1):
  xfs: remove all COW fork extents when remounting readonly

Dave Chinner (1):
  xfs: check sb_meta_uuid for dabuf buffer recovery

Rustam Kovhaev (1):
  xfs: use kmem_cache_free() for kmem_cache objects

Yang Xu (1):
  xfs: Fix the free logic of state in xfs_attr_node_hasname

 fs/xfs/libxfs/xfs_attr.c      | 13 +++++--------
 fs/xfs/xfs_aops.c             | 15 ++++++++++++---
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_extfree_item.c     |  6 +++---
 fs/xfs/xfs_super.c            | 14 +++++++++++---
 5 files changed, 32 insertions(+), 18 deletions(-)

-- 
2.25.1

