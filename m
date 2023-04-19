Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDFA6E76AB
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjDSJtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbjDSJtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:49:14 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C475D4C15;
        Wed, 19 Apr 2023 02:49:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63d4595d60fso5697372b3a.0;
        Wed, 19 Apr 2023 02:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681897753; x=1684489753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OuVCkulnYwljhm5+j4k0UbJeX1zXqWjkxukNgFx+ljw=;
        b=VU+W7x1ib7bYP+HbRnYrIxGFPlodga7JXUUsXs8O3sT3oV9TDlpNEyUndGshRrI5Hh
         BKECcftnPdWs3hxg7VNqcTaHn4IaWDOygLlwc/ESNXTM4N4lSJJDBx04n9FyiWjVL3Dy
         IA1+FWRkAX5z9mKgv/j+9XRXWy7+No4NIDhNq3jRoJgGkXtRgLoirvD6tngnmBGpWQ3A
         tgMXjC3kqDR2MJo1GhaKuqAlz7gUdnfvJhu1Y/raFnnVixA/v4W8Gr2jAl9RtnV+4VeR
         5C2CtnBYAfpkobnrdXwocAx0ggGN5TURTquhNV4PNurYfadUOWdD6aSevc3yaHVQGNeo
         fGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897753; x=1684489753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OuVCkulnYwljhm5+j4k0UbJeX1zXqWjkxukNgFx+ljw=;
        b=EZ/CDfN0Z+UKPseKiJLWJlQXNmZemHsehLZHvRCVTDTtXUegJtvxnSbto8djw71bRz
         u+gVjqEvDN9eMxzv1m3Nxwu3pnPQdzF6yQ60hHqW2FLdVrm9KiOsukHVy9RNbrI1ZEct
         VPnxheDwTHKg9u4esneB5cSliMmg5pEdh8jIhC3pcbtJr4PiLSyTeR6DGx0SmXnCOY7E
         i9ugSnkepU3d2oARFzCJ391grYv0eSsi84Ox5kADJt34TckpgHV+8uBMTmQ59WBBGLY2
         d3Om61t5o/OpZ3kAsDfOBKyYyGnxzpnxRA34Z1QV5PHLcf5mkxAtT7GZvmoTPvY6cCjR
         BGMw==
X-Gm-Message-State: AAQBX9eGZItIIr4GE4hxwypk6oHi0+MHFYqwGamqHH9gmy01Bw4GPRr9
        SGkrtiJHZocrqyuq4EDQzXtQTjvhBxiRDg==
X-Google-Smtp-Source: AKy350Z+6La1WVdFbMHdEdy7F6ZHK6UZJWf8V7Hn6+6qMS0SrfyVWod2g2ve3RIS5xTp5pQaiP690g==
X-Received: by 2002:a05:6a00:2291:b0:636:e0fb:8c45 with SMTP id f17-20020a056a00229100b00636e0fb8c45mr2294138pfe.16.1681897752903;
        Wed, 19 Apr 2023 02:49:12 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id g15-20020a62e30f000000b0063b86aff031sm6231207pfh.108.2023.04.19.02.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:49:12 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 0/6] Backport several fuse patches to 5.10.y
Date:   Wed, 19 Apr 2023 17:48:38 +0800
Message-Id: <20230419094844.51110-1-yb203166@antfin.com>
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

Connor Kuehl (1):
  virtiofs: split requests that exceed virtqueue size

Jiachen Zhang (1):
  fuse: always revalidate rename target dentry

Miklos Szeredi (4):
  virtiofs: clean up error handling in virtio_fs_get_tree()
  fuse: check s_root when destroying sb
  fuse: fix attr version comparison in fuse_read_update_size()
  fuse: fix deadlock between atomic O_TRUNC and page invalidation

 fs/fuse/dir.c       |  7 ++++++-
 fs/fuse/file.c      | 31 +++++++++++++++++-------------
 fs/fuse/fuse_i.h    |  3 +++
 fs/fuse/inode.c     |  5 +++--
 fs/fuse/virtio_fs.c | 46 +++++++++++++++++++++++++++++----------------
 5 files changed, 60 insertions(+), 32 deletions(-)

-- 
2.40.0

