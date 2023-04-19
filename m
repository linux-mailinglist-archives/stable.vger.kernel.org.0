Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BFF6E76D4
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbjDSJyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjDSJye (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:54:34 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA202103;
        Wed, 19 Apr 2023 02:54:33 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso2254256b3a.2;
        Wed, 19 Apr 2023 02:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681898072; x=1684490072;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sn8DC1a+4oEP4fiEhmaj5iHyEJtTI9FfNP7JPjQuiDY=;
        b=j8m+YE/A0/smvJYIZ/kppW4kuvk3JEEmwr0xHyBAU6F2KqtgXFztHwR66rQ6aqVHfB
         mHbsLbO3mNuugcpRVJ+HI0E+or/CLmSfK2e7YmQNosKEfjv5f28emZsA5a7SAwm4cPmQ
         d9L1kRgVLwdGP9YuFR64bI1Asi3/BX+1TVPHyztrp2zNqSrYCqIxqESDRvfcC3bHSuOy
         Etpc9ybPJnILEivPwDABhHITmDZCRlmxNKFXoBbbrqKMFB+smSzW/UFF69ZKw2bxVZdO
         miKh91pkTts/vih4F+nxHgK4j2E8lJG2WevRxpmS3wwvFF0+l/5gnwoLpQDZ9uKl3DCb
         FCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898072; x=1684490072;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sn8DC1a+4oEP4fiEhmaj5iHyEJtTI9FfNP7JPjQuiDY=;
        b=SP29zuQj2I7IZL6Z/kJ/ol6f88CaYHDUgwoNNQW3Y4Tzu+tt19eyOARm5582Rrj/7a
         nbBdiarlHo5Rq+2P++GH394Ug9BAU7sFRCnjU/ynoa7xRDnu44Bx1nKzEYhvlm0jOHjj
         KeudzzacPB2j3zF8sS7BSTp0tOqfaXmVWVQX8tpIlhnUaP30CknqEzkPKwCN1yUFPIBf
         8/fx0tPZT4ayVElDV9Sz0GwBcfEQjNqYpWh51Z3KrrTZC8UXqaXxyf6+kPU27qZb0zxC
         NAzb8brzE/Q0FGSWU6TzDTHVhUXamIU4mtin2XMZ3w+3nzsvY9kCc4sYgAP9SnGGdPzX
         gq2Q==
X-Gm-Message-State: AAQBX9fUpyPH+BpoU/nku6fZ4yqYDD6dAluqCYYDD6HTBGdGjnh4Ah0T
        YfSCtCwNZUkdNiRk6c5FsA/rMT8jZIJPRA==
X-Google-Smtp-Source: AKy350YvGej2S7/mIHMNE4yC8W+UwPTFUgZlKEp29Ed3QMkuANd1wp7Eq+s1H6oh1uJhv8ntIqrkeQ==
X-Received: by 2002:a17:902:d4c6:b0:1a6:523c:8583 with SMTP id o6-20020a170902d4c600b001a6523c8583mr5496874plg.68.1681898072090;
        Wed, 19 Apr 2023 02:54:32 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f7cc00b0019f9fd10f62sm11108357plw.70.2023.04.19.02.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:54:31 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 0/3] Backport several fuse patches for 5.15.y
Date:   Wed, 19 Apr 2023 17:54:21 +0800
Message-Id: <20230419095424.51328-1-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Antgroup is using 5.10.y in product environment, we found several patches are
missing in 5.10.y tree. These patches are needed for us. So we backported them
to 5.10.y. Also backport to 5.15.y and 6.1.y to prevent regression.

Jiachen Zhang (1):
  fuse: always revalidate rename target dentry

Miklos Szeredi (2):
  fuse: fix attr version comparison in fuse_read_update_size()
  fuse: fix deadlock between atomic O_TRUNC and page invalidation

 fs/fuse/dir.c  |  9 +++++++--
 fs/fuse/file.c | 31 ++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 15 deletions(-)

-- 
2.40.0

