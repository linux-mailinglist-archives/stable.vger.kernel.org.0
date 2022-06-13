Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC465483AB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiFMJ2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiFMJ16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:27:58 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D814B18344
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655112474; x=1686648474;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=DfY0bUORqGEzdXfRO4b8Er3Z8UE+SpW/PX6wY3dfz+U=;
  b=c8WI2NMXpeMDubCR2m2nkhjvx31P3xUOKcLVT2OvTxfNZ6aJKXy/hVql
   C54B3yQT7Dpm2gq5zFwfBG0+jeLbFIUradqrnn1NK9gg2nvji7KYz7SO3
   OejZ5+dmjVlqZP79VrV7YAzcfJMZXjQEeqLijCgXY6wTvaIryi5NiFwKA
   gm+9bOhuaSZ7/VAY0cEeFftAYulc/ob6uTIyjIhS4kqlFzTmNzvH+oebp
   AXhBvU7ehcYnaqVu+B9H6SEq9KRdHpWIzwz9lVIGpCg3YsOQQs+tr6eTn
   HXve+JrL93znExBxiNNmjW0L6dYegeFs/hWz1ePzXefqXGu/9sHwYSk8O
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647273600"; 
   d="scan'208";a="207836058"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2022 17:27:54 +0800
IronPort-SDR: hKARHDbelpkAWk7t0C316o4/VqlJe74ns7sE2hawx77r2vwsBLt76AewMinYryekx3aU8cSMe5
 0twqtm58Qkd5YgEztLsrczHADCde7llcK+o8yO1mZjCpHpGVjQfh2kHHEBNxdetGaQ6ktV8x7f
 sjuD88lV/33RKZXzpnB4Vxyx61feT8HD7m3UskzlnlEsxpWsd4v7/L0bsguV8OKxoDp1ejSxQe
 DhKOsgyOm5C0hQzrBScwUpNTQDASVl0+p88eufgeD059NqOa67sdBbAP3cUH+wxin5YejLUVNY
 KcC1k7XkjF+B8LrfmNbirmnr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 01:46:33 -0700
IronPort-SDR: TjlrHuZepxp/5T/22LijLJN2vY1LCnSplHT4zMmywCdpkHcdAxDNjQCDxrO+hRagnBkWRd1KVE
 gvxkopkOYGHvs1x3vZXsffsmzXUJ78XTkeluKJIbJkNPPo2p2QsFu8GjTmOe9NtoQiSAmWfjSk
 2ekKdmu1kQkOcZZOGjTZSquEQCJ8xRysPHo8CYKNbDHR6VrYLW2iYZnrzekGTzNUAsFGK4dA/n
 Ytb8/YKTq7eVRYpCCAVW8heJJlE+7to/aH6bdQ2yTez/NMTyVjxYlle3VKOKlGULpJkLC7iPaY
 B/o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 02:27:54 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LM5p220L8z1Rwrw
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:27:54 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1655112473; x=1657704474; bh=DfY0bUORqGEzdXfRO4
        b8Er3Z8UE+SpW/PX6wY3dfz+U=; b=pe6J4IzkeIoK4jy24/h357h42CJo9taIMG
        F7qF7Il2t93lrqwdcDbUQTL17hrOiVWvnQN58bwc7demR3glO5/9aaT4ZZf+Pi3M
        h2bRXsb5ee/GN0bC7lVKAhK+pRnSGHRNna3ZL+Af4Mh1WRHESl0gOsWDbHkrz+PX
        E2jp/uouV7hdbjfyrt0g8l3D8tRPGgOOTYYSRNVUZlX1Oy+DLonIRe6OIlDvtyj1
        JgKr97qnpVjxQ3GJusw6MyWKN+x1bVr00gX16IUHJPgUOHFoHmVi+A0ZcWgSKFBU
        YR8Mb7N7VKACVGiyzpRqNNNZjL/xKngoMfMJDcPf0kaaPRGWb6vg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4rzrbnU6nL6G for <stable@vger.kernel.org>;
        Mon, 13 Jun 2022 02:27:53 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LM5p13f01z1Rvlc;
        Mon, 13 Jun 2022 02:27:53 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] zonefs: fix handling of explicit_open option on mount
Date:   Mon, 13 Jun 2022 18:27:52 +0900
Message-Id: <20220613092752.1200645-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165510578298165@kroah.com>
References: <165510578298165@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a2a513be7139b279f1b5b2cee59c6c4950c34346 upstream.

Ignoring the explicit_open mount option on mount for devices that do not
have a limit on the number of open zones must be done after the mount
options are parsed and set in s_mount_opts. Move the check to ignore
the explicit_open option after the call to zonefs_parse_options() in
zonefs_fill_super().

Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/zonefs/super.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index e20e7c841489..1c2ece961128 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1690,11 +1690,6 @@ static int zonefs_fill_super(struct super_block *s=
b, void *data, int silent)
 	sbi->s_mount_opts =3D ZONEFS_MNTOPT_ERRORS_RO;
 	sbi->s_max_open_zones =3D bdev_max_open_zones(sb->s_bdev);
 	atomic_set(&sbi->s_open_zones, 0);
-	if (!sbi->s_max_open_zones &&
-	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
-		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount opt=
ion\n");
-		sbi->s_mount_opts &=3D ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
-	}
=20
 	ret =3D zonefs_read_super(sb);
 	if (ret)
@@ -1713,6 +1708,12 @@ static int zonefs_fill_super(struct super_block *s=
b, void *data, int silent)
 	zonefs_info(sb, "Mounting %u zones",
 		    blkdev_nr_zones(sb->s_bdev->bd_disk));
=20
+	if (!sbi->s_max_open_zones &&
+	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
+		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount opt=
ion\n");
+		sbi->s_mount_opts &=3D ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
+	}
+
 	/* Create root directory inode */
 	ret =3D -ENOMEM;
 	inode =3D new_inode(sb);
--=20
2.36.1

