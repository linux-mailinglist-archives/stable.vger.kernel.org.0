Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D993FC288
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 08:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhHaGPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 02:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhHaGPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 02:15:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE3EC061575;
        Mon, 30 Aug 2021 23:14:47 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so1605837pjx.5;
        Mon, 30 Aug 2021 23:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHn1bKbgKWkWnpZZfeyzrlp2g8PdlS3oPFK4wibr8zM=;
        b=eXIjFmJAssVk3qum2qiXCLhVDT8BHwEP00acuPJC6D3sWtXepsNRzl7WSa6QoQy99y
         dUAJT/Gv/isjtGOA3E207i4Tsg3jM8j5lwtN9mQ5mIE1L4CtzGYd9e/zLEhVdXiEHfEX
         MK3cuuw+X9WOT70++OXU9foFpZmdwQL8+ub9sVd8DFGdh2I4LBOAdF3P8oABbUdS/Y54
         4Qjd1EndwTYPXWN/mnR2yMNqh9M9wuTMFPtmjSuKYEHNCteFwK4boUyHPOoTuD7my/aS
         UQusq/C0g8X0wUQzNjsJflhtzcsL03ZTs8shCqEgQNJ4GLN+7wm4QawSviE32FE7ZpHH
         +2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHn1bKbgKWkWnpZZfeyzrlp2g8PdlS3oPFK4wibr8zM=;
        b=EwWwjrdJmDsvQQ9LERTF8z/obLCjthiPm2o75GY2i15bDK2jnegDQXWiNZJaFAd/7e
         +xJjTUDUJkwHTRLKnQ91Tuuj5GSSSpqYd9nNVHWfsGT2LGshB01bdeoXiQq/cGvoAD2S
         YhyAyXr7BCiWlp5KwJhfebzj7cY142PHVsonvhIN53SezqpcLoJ/ePFdfJXU+hUI5rhZ
         LAYkBC6EtZqlf+8ln6hKYkD6o+2MrZ4fk6tyCNHkbswlu9EqxOR6lWpaA0A1EbGIbaPF
         aKOX/LoNUcN7iPWE75iOxPLCzb9JZLMXDH35eNZ9J6BDz/8gZEdoru0b1SepLGElwL+c
         UKew==
X-Gm-Message-State: AOAM533JqwDsKcuWM40rTlVWgfAFxmKS8ktK5XEVXg9FMjECtuYBskyf
        V3EyqftYV8pzj5aTYoKVDJg=
X-Google-Smtp-Source: ABdhPJzGmBXOz6okx6of+AFSntvusISTlHPl1xEvUsw8GRcQjM3xZQnn+uaj9N1kZDXhTmMeOXLoJw==
X-Received: by 2002:a17:90b:390d:: with SMTP id ob13mr3460845pjb.129.1630390486636;
        Mon, 30 Aug 2021 23:14:46 -0700 (PDT)
Received: from sanitydock.wifi-cloud.jp ([210.160.217.69])
        by smtp.gmail.com with ESMTPSA id z7sm1405724pjr.42.2021.08.30.23.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 23:14:46 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        sumit.semwal@linaro.org, christian.koenig@amd.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v9 1/4] drm: fix null ptr dereference in drm_master_release
Date:   Tue, 31 Aug 2021 14:13:45 +0800
Message-Id: <20210831061348.97696-2-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210831061348.97696-1-desmondcheongzx@gmail.com>
References: <20210831061348.97696-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

drm_master_release can be called on a drm_file without a master, which
results in a null ptr dereference of file_priv->master->magic_map. The
three cases are:

1. Error path in drm_open_helper
  drm_open():
    drm_open_helper():
      drm_master_open():
        drm_new_set_master(); <--- returns -ENOMEM,
                                   drm_file.master not set
      drm_file_free():
        drm_master_release(); <--- NULL ptr dereference
                                   (file_priv->master->magic_map)

2. Error path in mock_drm_getfile
  mock_drm_getfile():
    anon_inode_getfile(); <--- returns error, drm_file.master not set
    drm_file_free():
      drm_master_release(); <--- NULL ptr dereference
                                 (file_priv->master->magic_map)

3. In drm_client_close, as drm_client_open doesn't set up a master

drm_file.master is set up in drm_open_helper through the call to
drm_master_open, so we mirror it with a call to drm_master_release in
drm_close_helper, and remove drm_master_release from drm_file_free to
avoid the null ptr dereference.

Fixes: 7eeaeb90a6a5 ("drm/file: Don't set master on in-kernel clients")
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/drm_file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index ed25168619fc..90b62f360da1 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -282,9 +282,6 @@ void drm_file_free(struct drm_file *file)
 
 	drm_legacy_ctxbitmap_flush(dev, file);
 
-	if (drm_is_primary_client(file))
-		drm_master_release(file);
-
 	if (dev->driver->postclose)
 		dev->driver->postclose(dev, file);
 
@@ -305,6 +302,9 @@ static void drm_close_helper(struct file *filp)
 	list_del(&file_priv->lhead);
 	mutex_unlock(&dev->filelist_mutex);
 
+	if (drm_is_primary_client(file_priv))
+		drm_master_release(file_priv);
+
 	drm_file_free(file_priv);
 }
 
-- 
2.25.1

