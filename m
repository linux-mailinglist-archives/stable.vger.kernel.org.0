Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0176469CD6A
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbjBTNtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjBTNtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779051CF69
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E3BAB80D4B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84158C433EF;
        Mon, 20 Feb 2023 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900929;
        bh=OwaiOCUNtR6BGeWL2NmI1fLiHrcFbzYl6cH+Mlt5gSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjA1lO1Udphp1xcWWia+DgedtKd5o/d2ihRzV1depbvXOWextZ4s5rOXa9q0jjnbY
         4DsgfGBVtFLij8hF3WCUekP1KG8jMdzPRsJaGneTW0Ij0KzW5YVP870grI9WmUDB+3
         HXgMRcv/6vLFqKYVJTqDmx+DHlaDuhGuO5Tw/DJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 104/156] xfs: remove the xfs_inode_log_item_t typedef
Date:   Mon, 20 Feb 2023 14:35:48 +0100
Message-Id: <20230220133606.856966033@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit fd9cbe51215198ccffa64169c98eae35b0916088 upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c  |    2 +-
 fs/xfs/libxfs/xfs_trans_inode.c |    2 +-
 fs/xfs/xfs_inode.c              |    4 ++--
 fs/xfs/xfs_inode_item.c         |    2 +-
 fs/xfs/xfs_inode_item.h         |    4 ++--
 fs/xfs/xfs_super.c              |    4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -592,7 +592,7 @@ void
 xfs_iflush_fork(
 	xfs_inode_t		*ip,
 	xfs_dinode_t		*dip,
-	xfs_inode_log_item_t	*iip,
+	struct xfs_inode_log_item *iip,
 	int			whichfork)
 {
 	char			*cp;
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -27,7 +27,7 @@ xfs_trans_ijoin(
 	struct xfs_inode	*ip,
 	uint			lock_flags)
 {
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (ip->i_itemp == NULL)
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2555,7 +2555,7 @@ xfs_ifree_cluster(
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
 	xfs_inode_t		*ip;
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 	struct xfs_log_item	*lip;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
@@ -2617,7 +2617,7 @@ xfs_ifree_cluster(
 		 */
 		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 			if (lip->li_type == XFS_LI_INODE) {
-				iip = (xfs_inode_log_item_t *)lip;
+				iip = (struct xfs_inode_log_item *)lip;
 				ASSERT(iip->ili_logged == 1);
 				lip->li_cb = xfs_istale_done;
 				xfs_trans_ail_copy_lsn(mp->m_ail,
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -781,7 +781,7 @@ xfs_iflush_abort(
 	xfs_inode_t		*ip,
 	bool			stale)
 {
-	xfs_inode_log_item_t	*iip = ip->i_itemp;
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 
 	if (iip) {
 		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -13,7 +13,7 @@ struct xfs_bmbt_rec;
 struct xfs_inode;
 struct xfs_mount;
 
-typedef struct xfs_inode_log_item {
+struct xfs_inode_log_item {
 	struct xfs_log_item	ili_item;	   /* common portion */
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
@@ -23,7 +23,7 @@ typedef struct xfs_inode_log_item {
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
-} xfs_inode_log_item_t;
+};
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
 {
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1934,8 +1934,8 @@ xfs_init_zones(void)
 		goto out_destroy_efi_zone;
 
 	xfs_ili_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
-					KM_ZONE_SPREAD, NULL);
+		kmem_zone_init_flags(sizeof(struct xfs_inode_log_item),
+					"xfs_ili", KM_ZONE_SPREAD, NULL);
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
 	xfs_icreate_zone = kmem_zone_init(sizeof(struct xfs_icreate_item),


