Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DAD144F56
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbgAVJgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:36:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730573AbgAVJgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:36:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FFA72467B;
        Wed, 22 Jan 2020 09:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685809;
        bh=6iiW+6cKKI/kGdLzzH3K+plX8sGlQdE7VetFRoAKqLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ov7ws+feAI/zu8PTU0wUrc6YFDx+I3lAxLQVtQwjjc6Pgj7zXmS8zGjEswHIejqD9
         S7Wvf5xP5deZV+jsNvAASM8BWzhSk4kKqAcDkthJM5eOoUrjMSufMIJWe0ko9gCE17
         HR/NcXgevyu3sjrstahKCihOBUaajMLp834hMwds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 4.9 87/97] xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk
Date:   Wed, 22 Jan 2020 10:29:31 +0100
Message-Id: <20200122092810.259748100@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 589b72894f53124a39d1bb3c0cecaf9dcabac417 upstream.

Clang warns:

../drivers/block/xen-blkfront.c:1117:4: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
                nr_parts = PARTS_PER_DISK;
                ^
../drivers/block/xen-blkfront.c:1115:3: note: previous statement is here
                if (err)
                ^

This is because there is a space at the beginning of this line; remove
it so that the indentation is consistent according to the Linux kernel
coding style and clang no longer warns.

While we are here, the previous line has some trailing whitespace; clean
that up as well.

Fixes: c80a420995e7 ("xen-blkfront: handle Xen major numbers other than XENVBD")
Link: https://github.com/ClangBuiltLinux/linux/issues/791
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Roger Pau Monné <roger.pau@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkfront.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1104,8 +1104,8 @@ static int xlvbd_alloc_gendisk(blkif_sec
 	if (!VDEV_IS_EXTENDED(info->vdevice)) {
 		err = xen_translate_vdev(info->vdevice, &minor, &offset);
 		if (err)
-			return err;		
- 		nr_parts = PARTS_PER_DISK;
+			return err;
+		nr_parts = PARTS_PER_DISK;
 	} else {
 		minor = BLKIF_MINOR_EXT(info->vdevice);
 		nr_parts = PARTS_PER_EXT_DISK;


