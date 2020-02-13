Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3D215C757
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgBMQJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:09:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbgBMPWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:43 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A0362469A;
        Thu, 13 Feb 2020 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607363;
        bh=rIHLUYSfXasaLl1fb12IkZaLdKyt8ASA0w+9L2oYfQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vc1o10VK2Ap64vs33aibVrhtbjLkUAnkgSd2m9emwTDk4fD3NbdmeKHtJEUBCNMkc
         K+Vy+XskSFNjcSC57lnltfOe05Z5uJT4Q19d7qsNyKrOrKR12XD+qkFrQyoAPHNZhi
         y7KLGKq9U27ptyXt9l7Sc1c3wPTyYBZe3859gz0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.4 50/91] ext2: Adjust indentation in ext2_fill_super
Date:   Thu, 13 Feb 2020 07:20:07 -0800
Message-Id: <20200213151840.984242435@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit d9e9866803f7b6c3fdd35d345e97fb0b2908bbbc upstream.

Clang warns:

../fs/ext2/super.c:1076:3: warning: misleading indentation; statement is
not part of the previous 'if' [-Wmisleading-indentation]
        sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
        ^
../fs/ext2/super.c:1074:2: note: previous statement is here
        if (EXT2_BLOCKS_PER_GROUP(sb) == 0)
        ^
1 warning generated.

This warning occurs because there is a space before the tab on this
line. Remove it so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

Fixes: 41f04d852e35 ("[PATCH] ext2: fix mounts at 16T")
Link: https://github.com/ClangBuiltLinux/linux/issues/827
Link: https://lore.kernel.org/r/20191218031930.31393-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext2/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1051,9 +1051,9 @@ static int ext2_fill_super(struct super_
 
 	if (EXT2_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext2;
- 	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
- 				le32_to_cpu(es->s_first_data_block) - 1)
- 					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;
+	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
+				le32_to_cpu(es->s_first_data_block) - 1)
+					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;
 	db_count = (sbi->s_groups_count + EXT2_DESC_PER_BLOCK(sb) - 1) /
 		   EXT2_DESC_PER_BLOCK(sb);
 	sbi->s_group_desc = kmalloc (db_count * sizeof (struct buffer_head *), GFP_KERNEL);


