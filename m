Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E47655D837
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiF0GrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiF0GrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:47:11 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4642F559E;
        Sun, 26 Jun 2022 23:47:10 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso5396886wma.2;
        Sun, 26 Jun 2022 23:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZckI0H76D4OeYEPIAeylVOws+YlPiyjDVF4Nbowj0c=;
        b=Yiloi0V2BsR0U0ChMfnBHilrCJQ64TEWM+l/bCmlCkxkp1yu+iv6Zo74EPqOujLRYN
         LZTMD1JdHNktabiRK6JCgTmF4J/SnosZVSUmTW06mHHs4UhmUweIezsRsAFMedwmOKeW
         3d3F7wDQHd8C6dfeXmB3l0EMKL0K4cPqW2fJjpdopO5Efna4b8ZqpKaaDShxzvsRurl1
         ufnSJ58ozBjO4QNLNx7Tzo7OSZJedlUK6ZputSwvNnt/S6ldrGnWSwG3WjiA0U55giV/
         stAdMa/ujrqDg/3Q3bNWKh4pn5vNKElZg7MsgsBdLsXpzqXmQIVryZfgIket9nfO8kZh
         9XYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZckI0H76D4OeYEPIAeylVOws+YlPiyjDVF4Nbowj0c=;
        b=QbcMGXqw00rZGItDtUA8cWpFUjXqYku6d/DACxNjh+EoZaIn4AwhyatHHfJrBDsdLl
         3ySUDqehOn6KSmuWvT2w/yv+GrI2J4i61J+yH/xDyE25Yhs0zMklVuqZqzGoTPRRmnxj
         pdvNq1BnPx2PueSxzymQfvdkZ+0nAWbsVawQXq2CuFpXSRuyCnoxQAVn/FD+ocW8w+PY
         8bXjSFEGem/x8BvxjLEnyYvCcLqvKNkbOmGAUhcr3YPn5RhiYrN5Tv/4boWxJBudLin2
         NOM0FyeQmtI8KELkSZNF470B1sFtF7fwlm42vBQEn70bOitBDIuht0DznLPTUGcELFIE
         xFqA==
X-Gm-Message-State: AJIora9OXh14AFhdfE2mBnY6r1fypYRf0o/PmfFnGQx2QKipHbGOIBAD
        7tCmZCWZaTy/xAxQt0Uiaco=
X-Google-Smtp-Source: AGRyM1tQ4lRMuVwUPP4VDKRJs6dW9CHSOx4gRdVX12qgyEeXpEVJHAXRZvcOm50sw9tOJ3D78RymTA==
X-Received: by 2002:a1c:f414:0:b0:3a0:306d:327c with SMTP id z20-20020a1cf414000000b003a0306d327cmr18217608wma.179.1656312428670;
        Sun, 26 Jun 2022 23:47:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm16460839wmq.26.2022.06.26.23.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:47:07 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 0/5] xfs stable patches for 5.10.y (backports from v5.15.y)
Date:   Mon, 27 Jun 2022 09:46:58 +0300
Message-Id: <20220627064703.2798133-1-amir73il@gmail.com>
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

