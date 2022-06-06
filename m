Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED98753E756
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbiFFOdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiFFOdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:33:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6192AE2B;
        Mon,  6 Jun 2022 07:33:05 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k19so20109636wrd.8;
        Mon, 06 Jun 2022 07:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DxI+KP/yP2c1dj72ZEf9XEZoYdpFMxSLMCxGwNL12Ug=;
        b=ZxjmAX1D1wGptVBPvIEy0WZ4RY48LUQLDudC+3I1cEwpRYGSLwv8N6C5DQi9BuiVRS
         I5rMYeFPtxm2N1gWgcZZUPgCm2yWgef718S03NaDH6Er7aVfmRK4Cdb3fE/HVSPW40lG
         Yh+vOPjiUTA2bwILsDfG/1tgo0O957E60vziSWS4rZXaj2t53I4pTJ7+qrIPSe133k2e
         k+ADnBZUBZYTDxBIPocWFfEchMk0cZuNBVqbqG+d9K/IXIs+dq7MGu6RNa5fql2xNG54
         8mEjD0rT9N6WnKcIsBlyj8XST8Y3ZqNj7chfVPZWry574690n3mNuoZ3zUgBuGf+MhNB
         UWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DxI+KP/yP2c1dj72ZEf9XEZoYdpFMxSLMCxGwNL12Ug=;
        b=ri6VUJXkDIAYCET0WcK3p2bmxFuO2XoMYeHY8ytXd6q7LDonC9KjQzOYw5t61MJkU1
         JY1WdSaVHN+bHNIVByjDdhDhvNFt6wGvsBTKwAl2fZZM9IhXNOs/g8+94bvGdHbF8+Js
         qewFfbMop5XAAmoCADtubelDi2WjBRBKrfA/wQX/Ph46lXbF7PF0ceaNSneDqLKLvJkb
         HcwZ0qzfP5tY2ALHJbuBibu+7nQPHo6J7AOvSwK6mt49P8ribM1iFihMRwe8iiM0ZWbK
         My9KC2JL4OkWkYGKs67cZ6t7Inku0XrVg2GmfybMv8GyVVTnM3GwuvI4lJwn6VAEBkoj
         Zsxg==
X-Gm-Message-State: AOAM530pkC8emzwPpU3l6vDWAralwNieawZNGVd4+A8+1DaVu5tkOXIE
        YuMHIdHMIPrEiD9knzlqrYdngQZHn/5VEA==
X-Google-Smtp-Source: ABdhPJzTFxpKysC6TNqNDsDdVcL7T/zwy7+pR645h6jq5TR47wKLIJGik98Me059nC7Q4wj1TVptpA==
X-Received: by 2002:adf:fb10:0:b0:207:af88:1eb9 with SMTP id c16-20020adffb10000000b00207af881eb9mr22351686wrr.238.1654525984228;
        Mon, 06 Jun 2022 07:33:04 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id h24-20020a05600c145800b0039c54bb28f2sm1622958wmi.36.2022.06.06.07.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:33:03 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Subject: [PATCH 5.10 v2 1/8] xfs: set inode size after creating symlink
Date:   Mon,  6 Jun 2022 17:32:48 +0300
Message-Id: <20220606143255.685988-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606143255.685988-1-amir73il@gmail.com>
References: <20220606143255.685988-1-amir73il@gmail.com>
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

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

commit 8aa921a95335d0a8c8e2be35a44467e7c91ec3e4 upstream.

When XFS creates a new symlink, it writes its size to disk but not to the
VFS inode. This causes i_size_read() to return 0 for that symlink until
it is re-read from disk, for example when the system is rebooted.

I found this inconsistency while protecting directories with eCryptFS.
The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
the symlink was created after the last reboot on an XFS root.

Call i_size_write() in xfs_symlink()

Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_symlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..8d3abf06c54f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -300,6 +300,7 @@ xfs_symlink(
 		}
 		ASSERT(pathlen == 0);
 	}
+	i_size_write(VFS_I(ip), ip->i_d.di_size);
 
 	/*
 	 * Create the directory entry for the symlink.
-- 
2.25.1

