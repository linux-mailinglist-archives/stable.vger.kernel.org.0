Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE2A6CD7A5
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 12:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjC2K2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 06:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2K2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 06:28:45 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCC61717
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680085724; x=1711621724;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ZfiAFX8XaZ4Y2SnEwE3frv4lf93lUmWwveHL0oa12/w=;
  b=jTTtHAvH9Fy3XeDib1VxpqwGTzAJO53ybq3AMfF7iaqE1SKpm5injzLH
   J0Er8iUGokMaXS6MwnwDhRyEfBNQcMngfe1af4Wampp+hfWTVeLLCgKBv
   naine8hEKKLh6qA2dpTcoaNCwM3SUQRy+mlkX6y5sOiMoNJFfuoAZ4XUh
   Wk2Y8ZWTtJ6NP5Wx9oMUSOk65Hm7po87PJgn4KFs2OW/Rj9re47gP7GyZ
   9cCx0FJUtZ/kr5oiV4FiC2YdKlYiRemGLWPYj8OxqCpdk7L7tqG8Yi5i+
   b+pviLwvddhSWGeDckbfVXl2UJSIWmcOFxoF0SF6MmBR0siakV4Q/8ED0
   g==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; 
   d="scan'208";a="331220768"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 18:28:43 +0800
IronPort-SDR: 9njwa9wZRvNY/sJOYNkeR4n7+JJoroSz4HN0WjNulgeVhVxNlbfg7a0F592v2N5mHBqm3mUp0D
 JkSTQY+h92GPsXuDQq+oI/NbqV/vpsc5vS2+KgViENkmNfAp7Rjbam5n/MH8VGge/lkt7EVhgi
 QWRjzUoUUxVjqXhqcNyR0HrwT1MtBbeEP3OM3cgecI5fMXjOkH5SZx7mOayxD14w9nXATuLd+X
 aXBKKmf/dbmH8M+j0gSQAviqefvBX2n9hJOwR3Xg0J6aETjPbHdN1pvh8CIplujmW8/iHEq1Nq
 DUE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 02:44:52 -0700
IronPort-SDR: tOFsJwIZYrAJA9HqVTgD3RloGpBxb7dXj3iwGQCF6AU+SvXoQPuZXQbSCeaKdDPHz68lO1ty0U
 e9heKUIveQDW0TUj9VcHyOUDlu7Qopn0UcEOvxqQRNu+K6M3Itz9fapD1ym/zTKhBQEg8Kd3w2
 mCUvUXkER9vrVO97t7pY2rmp8PucXAsadQldMM0h6gu2cPTPgtCJlNSavCckdy4Hk1XT/CZgsR
 SdE7i9MHO0k3zt7lxJdpCi9xU4glmOBGLizI9ZH8wzwcmFnrVjqfrXIcBhaGlBuDMXgzljcbsp
 NxI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 03:28:43 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PmjSq3gDVz1RtVn
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:28:43 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1680085723; x=1682677724; bh=ZfiAFX8XaZ4Y2SnEwE
        3frv4lf93lUmWwveHL0oa12/w=; b=OBe+BZCskE/qAKoNsaD3Kt2e2vVmzU3k+w
        S8SPGUHwuKQOnMFYK73n8xtzJspn+1xX8DEoMaUb9gizqJ+/hp9IXNb9afdaY9aE
        GsUo4u5LBpsOUmsAxI3txZyM63L2+ry7zjTyjTvZli+KU/26ofAtkZawS97e8fmH
        9tCJLvwuqenlX2KQJWAc3jjpH0v0kanOnaCFWCI+Qlu/AffsYl9yxBOa8qxseXAE
        lL2v/O02vEXqEn95odijkfkg+3BhGmQdD2lhZDgJm/JG+cZTEE9CnhshtnqA+dH6
        +Xyos5xI0oesa0Eh0bCxEI0eQBbCRew9kRKfJfKwwT6OCYsNiSFA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FNveGywzxLKF for <stable@vger.kernel.org>;
        Wed, 29 Mar 2023 03:28:43 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PmjSp6JCpz1RtVm
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:28:42 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     stable@vger.kernel.org
Subject: [PATCH 6.1.y] zonefs: Fix error message in zonefs_file_dio_append()
Date:   Wed, 29 Mar 2023 19:28:41 +0900
Message-Id: <20230329102841.1782441-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1680003630102245@kroah.com>
References: <1680003630102245@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 88b170088ad2c3e27086fe35769aa49f8a512564 upstream.

Since the expected write location in a sequential file is always at the
end of the file (append write), when an invalid write append location is
detected in zonefs_file_dio_append(), print the invalid written location
instead of the expected write location.

Fixes: a608da3bd730 ("zonefs: Detect append writes at invalid locations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 fs/zonefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index a9c5c3f720ad..2d9027eb48a9 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -822,7 +822,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *i=
ocb, struct iov_iter *from)
 		if (bio->bi_iter.bi_sector !=3D wpsector) {
 			zonefs_warn(inode->i_sb,
 				"Corrupted write pointer %llu for zone at %llu\n",
-				wpsector, zi->i_zsector);
+				bio->bi_iter.bi_sector, zi->i_zsector);
 			ret =3D -EIO;
 		}
 	}
--=20
2.39.2

