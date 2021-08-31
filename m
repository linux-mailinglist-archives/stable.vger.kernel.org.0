Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4363FC3AB
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239937AbhHaH0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 03:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239941AbhHaH0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 03:26:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ECBC06175F;
        Tue, 31 Aug 2021 00:25:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so1319339pjr.1;
        Tue, 31 Aug 2021 00:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHn1bKbgKWkWnpZZfeyzrlp2g8PdlS3oPFK4wibr8zM=;
        b=pMjwOP/19qT52lkjXq8sDWHfx7YGZ8eUQGoIKFiBmpYZXRbATElia9k4erKkY4o+gx
         bPv9Q+ALqfj6l0g/7NXoYBsBaUHHT+6gpUJC0TZZA35oV6yJRINlv14SbH4wmA+hWnld
         A5j6PaQ1FR2HPB1VVcngEVYOmhQ+NpLjrks7l/GQz3GiD/Ij6t9cbltGAt9Ghki/8W2G
         8wonwnJqSZ31sN7su4nbQ9ehq6UPI2UCarkMqTB4TAcyt0O3UBFAOrpejOLa2u2DFQOG
         seyxkNmsGWqWrmFUoPEtoV5VSb1OXPvizXaVppaQ4FJhDNDk0jkvQTAQjwiWAZ/5FHb6
         r8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHn1bKbgKWkWnpZZfeyzrlp2g8PdlS3oPFK4wibr8zM=;
        b=k1g4kjnFhN1uCtP6XDZmgz7GnL5q5sH9JdHNWjnb5sPxySZVw1xLEhD4iXnxjo1JCd
         umgUlI12uAHVDJH0rR0NqnJw2WuPRAl+jfgvzR853YHGkMEbfCIJlOXtcFdBrPClNGVl
         VqKRuEu8EF4S1ylT+/umcGG+9NRderhNMe+bt86y3VAJo1u9IKVuUM8QnFZTvkEnG5Ai
         WIK5CqzT1xN2oMwar/WkJA4Tuw5YrItP9YjNHsObjHUob93SidzRiPitGQ+Qx581ob51
         CnKry5kEtcWQ6sk08pGgnc/Wqi+D651LN43WBbkH6My9KaFUCCLN3lHHePaRJz9wRdmK
         ie8w==
X-Gm-Message-State: AOAM533s5v8KJCXrXVmjpTs0lvvoUBgsS8lzuFnmxkEe6FikhGOyPyCK
        vWO4phWKY5omocU+Z1trsPY=
X-Google-Smtp-Source: ABdhPJzpV2t1yFkjJNCWkF5oIEd1fc2kRhKJQqIj82vlMWjQvXBEEUimnllxLVlQqW5CEZE3+9QHpA==
X-Received: by 2002:a17:90a:2e88:: with SMTP id r8mr3698988pjd.169.1630394737112;
        Tue, 31 Aug 2021 00:25:37 -0700 (PDT)
Received: from sanitydock.wifi-cloud.jp ([210.160.217.69])
        by smtp.gmail.com with ESMTPSA id m11sm1720724pjn.2.2021.08.31.00.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 00:25:36 -0700 (PDT)
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
Subject: [PATCH v10 1/4] drm: fix null ptr dereference in drm_master_release
Date:   Tue, 31 Aug 2021 15:24:58 +0800
Message-Id: <20210831072501.184211-2-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210831072501.184211-1-desmondcheongzx@gmail.com>
References: <20210831072501.184211-1-desmondcheongzx@gmail.com>
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

