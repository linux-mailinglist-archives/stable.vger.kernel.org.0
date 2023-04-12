Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D608A6DEA49
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjDLEUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLEUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:20:00 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57482268A;
        Tue, 11 Apr 2023 21:19:59 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id o2so10102134plg.4;
        Tue, 11 Apr 2023 21:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681273198; x=1683865198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8ka7wASQa6bD9G8OlzyRiuhCjD/awuI3EIhXrUDYlTQ=;
        b=YcWuV54Uh9IwWuTT/hgaeK61hl8QWUMz4BT0U2uqU/jiNF1pn+zvPNmLz3LWD6Oyiq
         1qMr0XfamrClVa28TUj6kNWNYMzpzySc4cOvSiyjsjWDv6mGIwImFykZ47LftHqhVxvJ
         bUOZKPk/IZ/cAj+gZKh0Cv0gsoExopZKj6Yg1RLAQiNhGsTfgBRWxJNNjDBWmZAQycxi
         NrElX8J8I6AY8n6vFiMjwBZjaoMmnlOI1tlV225MQ8zSCqNDLlpQ5N3YYeqdS8LxTDmH
         VLKsRLJtbrs7vYdi1itpSPLD4fSGLiA76avqlEDlFDXv8AZm2hEupVrG8oVWzfzx37UG
         Wjdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681273198; x=1683865198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ka7wASQa6bD9G8OlzyRiuhCjD/awuI3EIhXrUDYlTQ=;
        b=dAg7jVZ/qDuuyuiyUktzyK0CzZDdFB+KN8C0I4I9MFkhGlOmwpr3+hPhjyuEKGKFl+
         HDh07YFb49qkB6+Y+KMZihxeocS/NjjNWvgIP+mhi4K8ua3H+exZzQ5/sroTHEK+yj9j
         lc5GvWtgPlFdI9wFF5691hfUe5X25DONrrYjrH/Y8rbhKTGolUE610jUgLCkHpkixNuK
         FcTwnBfhOnENCXtqWWOLlcKw11EbNDmQ0gDVd/KCsh9mVJ6cJkdhbo1EHDWw5d490cuZ
         6DWwLyHS3bOydJ6BUOTaRcwQuaFGBmEHfdQuPulN0dZgYOFYjZeiVQbRN4aJzWZYf378
         +3pw==
X-Gm-Message-State: AAQBX9eFyAsKSMHfpPlyAkNESs63LWG/qdet99Mzr6bye3WfzSM+Qhs9
        SlC9tvB76UtU41UuqsJZ3RQpSzSfPqlYgA==
X-Google-Smtp-Source: AKy350YZqXYOks1hxpmdy0TtYtbflhrAw4uAsDJYm0P6wekKRhZAw4qmNKDwGUF8IgpiwoRmdg+Vig==
X-Received: by 2002:a17:90b:78b:b0:246:9957:6a07 with SMTP id l11-20020a17090b078b00b0024699576a07mr930653pjz.25.1681273198436;
        Tue, 11 Apr 2023 21:19:58 -0700 (PDT)
Received: from virtualbox.www.tendawifi.com ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709028c8d00b001a19196af48sm10412381plo.64.2023.04.11.21.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 21:19:57 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 0/6] Backport several patches to 5.10.y
Date:   Wed, 12 Apr 2023 12:19:29 +0800
Message-Id: <20230412041935.1556-1-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Antgroup is using 5.10.y in product environment, we found several patches are
missing in 5.10.y tree. These patches are needed for us. So we backported them
to 5.10.y

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

