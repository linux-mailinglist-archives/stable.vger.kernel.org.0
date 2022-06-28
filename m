Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65BA55D3C0
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345425AbiF1MQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345436AbiF1MQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEE527177
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DFF7B81D2D
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2AFC341CB;
        Tue, 28 Jun 2022 12:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418596;
        bh=cskmIqtCN27ZB72fcShpY4v1xoqZx3aJM6iPNX5mJwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTXw/mU0xz1jMmqs01OpiNONr2sgSZSAUlHacQs11exx5fuOeFdwbn1yFjKzZbF4G
         NK9QTqHgdBO+FuXiYRk0WNnHzb0Y69/HEQ6d5MnaNG+eCTL2LI3/fCWQkTecg4iHQj
         aM16lQjFQMvPoishL84imLl33DuhWNklAAGbl3v1VyQyEncnUZrEUKZNyGstmih6bX
         AgfeyjZjEIeurag2OVtXsTiaBNkIyvrrXfMYQjcZdsVaxEEA0WfnjlaP99MkR6pzCm
         llyicWEeVirlkpVLqB7LFdQwj6fojC30CXC7FQFvjkvc2vTmQT7UWg7i5MSd2gGBsA
         qfEp49Sw0sM4w==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 05/12] docs: update mapping documentation
Date:   Tue, 28 Jun 2022 14:16:13 +0200
Message-Id: <20220628121620.188722-6-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4828; i=brauner@kernel.org; h=from:subject; bh=dNV6iTV4GZDCp1+msbDQ2sjReozynnSdKWdEEgc1HHk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+sj/i0HJu+7WB7kP2fcXmL2wfv2eoTg9IIeryK1987qZ m+b96yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIhi/DH74j9VJ+ph3rC+2zy3790E lwD9eaXzktIenlIYvlMfkZmYwMZxrPqmk/YTl5/K2A+wPGFUEZB2fkswqpRlrPvxxenS3IDAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 8cc5c54de44c5e8e104d364a627ac4296845fc7f upstream.

Now that we implement the full remapping algorithms described in our
documentation remove the section about shortcircuting them.

Link: https://lore.kernel.org/r/20211123114227.3124056-6-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-6-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-6-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 Documentation/filesystems/idmappings.rst | 72 ------------------------
 1 file changed, 72 deletions(-)

diff --git a/Documentation/filesystems/idmappings.rst b/Documentation/filesystems/idmappings.rst
index 1229a75ec75d..7a879ec3b6bf 100644
--- a/Documentation/filesystems/idmappings.rst
+++ b/Documentation/filesystems/idmappings.rst
@@ -952,75 +952,3 @@ The raw userspace id that is put on disk is ``u1000`` so when the user takes
 their home directory back to their home computer where they are assigned
 ``u1000`` using the initial idmapping and mount the filesystem with the initial
 idmapping they will see all those files owned by ``u1000``.
-
-Shortcircuting
---------------
-
-Currently, the implementation of idmapped mounts enforces that the filesystem
-is mounted with the initial idmapping. The reason is simply that none of the
-filesystems that we targeted were mountable with a non-initial idmapping. But
-that might change soon enough. As we've seen above, thanks to the properties of
-idmappings the translation works for both filesystems mounted with the initial
-idmapping and filesystem with non-initial idmappings.
-
-Based on this current restriction to filesystem mounted with the initial
-idmapping two noticeable shortcuts have been taken:
-
-1. We always stash a reference to the initial user namespace in ``struct
-   vfsmount``. Idmapped mounts are thus mounts that have a non-initial user
-   namespace attached to them.
-
-   In order to support idmapped mounts this needs to be changed. Instead of
-   stashing the initial user namespace the user namespace the filesystem was
-   mounted with must be stashed. An idmapped mount is then any mount that has
-   a different user namespace attached then the filesystem was mounted with.
-   This has no user-visible consequences.
-
-2. The translation algorithms in ``mapped_fs*id()`` and ``i_*id_into_mnt()``
-   are simplified.
-
-   Let's consider ``mapped_fs*id()`` first. This function translates the
-   caller's kernel id into a kernel id in the filesystem's idmapping via
-   a mount's idmapping. The full algorithm is::
-
-    mapped_fsuid(kid):
-      /* Map the kernel id up into a userspace id in the mount's idmapping. */
-      from_kuid(mount-idmapping, kid) = uid
-
-      /* Map the userspace id down into a kernel id in the filesystem's idmapping. */
-      make_kuid(filesystem-idmapping, uid) = kuid
-
-   We know that the filesystem is always mounted with the initial idmapping as
-   we enforce this in ``mount_setattr()``. So this can be shortened to::
-
-    mapped_fsuid(kid):
-      /* Map the kernel id up into a userspace id in the mount's idmapping. */
-      from_kuid(mount-idmapping, kid) = uid
-
-      /* Map the userspace id down into a kernel id in the filesystem's idmapping. */
-      KUIDT_INIT(uid) = kuid
-
-   Similarly, for ``i_*id_into_mnt()`` which translated the filesystem's kernel
-   id into a mount's kernel id::
-
-    i_uid_into_mnt(kid):
-      /* Map the kernel id up into a userspace id in the filesystem's idmapping. */
-      from_kuid(filesystem-idmapping, kid) = uid
-
-      /* Map the userspace id down into a kernel id in the mounts's idmapping. */
-      make_kuid(mount-idmapping, uid) = kuid
-
-   Again, we know that the filesystem is always mounted with the initial
-   idmapping as we enforce this in ``mount_setattr()``. So this can be
-   shortened to::
-
-    i_uid_into_mnt(kid):
-      /* Map the kernel id up into a userspace id in the filesystem's idmapping. */
-      __kuid_val(kid) = uid
-
-      /* Map the userspace id down into a kernel id in the mounts's idmapping. */
-      make_kuid(mount-idmapping, uid) = kuid
-
-Handling filesystems mounted with non-initial idmappings requires that the
-translation functions be converted to their full form. They can still be
-shortcircuited on non-idmapped mounts. This has no user-visible consequences.
-- 
2.34.1

