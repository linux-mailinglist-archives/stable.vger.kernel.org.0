Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C4A6BB1F5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjCOMbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjCOMbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D248A3A4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD65861D26
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4146C433D2;
        Wed, 15 Mar 2023 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883447;
        bh=rPtILoKWWoEcQJdETmkVJ7BPNe8f0QkGJY0nTXYW2Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPbF7w0vopxvSmtVsSxhWzJG1YdAhQe85OsQw/7mLLGoEmhY0Vzeexbxgj3f9fr68
         XIKC0hg2BNbl6OdzeFNCBDkBiyigUo1oZEwUSW5Ujaga8Qolthix3nOrOJ4fzv7J4y
         wVCs3nicB6CgFM2dCH+kxJYEFmBMVTMOwKuOMnm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.15 140/145] xfs: remove xfs_setattr_time() declaration
Date:   Wed, 15 Mar 2023 13:13:26 +0100
Message-Id: <20230315115743.538740594@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit b0463b9dd7030a766133ad2f1571f97f204d7bdf upstream.

xfs_setattr_time() has been removed since
commit e014f37db1a2 ("xfs: use setattr_copy to set vfs inode
attributes"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iops.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -13,7 +13,6 @@ extern const struct file_operations xfs_
 
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
-extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 int xfs_vn_setattr_size(struct user_namespace *mnt_userns,
 		struct dentry *dentry, struct iattr *vap);
 


