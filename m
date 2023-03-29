Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A0C6CD79C
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 12:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjC2KZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 06:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2KZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 06:25:53 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF874233
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680085551; x=1711621551;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=HCeyZXLvVc6r8bavJEzag8k+YIR0m6a+Nh5jr0Kw9fg=;
  b=mhf1AGPnTu+RsoMgTH2+Q5AHRq1Alx/g9+wGg70S3CTQ+/1BXQU0xEa9
   piMOo87mIFTDfhlKgWSw2M24CaI/3EnkFM1otH+YvuXttzN8tDwKCpLtk
   CdgOcifEigIwbG9dbpCObBYLpNl7JT2Zxs7dtxqm/THMI948mBaf+Y/ny
   1OpMc/WAZLhokNg3PQKoSwoQUIsB9SOlhtKITVuS321F455ygEJ5TFjB+
   VYBMfXjQAXjdmEW5h0yLhC3Lir+NAidzObk2jYU/aD30O2AfyWHVt99QQ
   RLxllHLE5E44fUmzkjuOqskomB+luBLCLD5ojTFdqH2mFhrgMVsEoy9eb
   g==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; 
   d="scan'208";a="331220638"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 18:25:48 +0800
IronPort-SDR: 56TfAr2y4DtbPSvqq+AW/SmQ0bqooSF+q+BDH2rGtz+YY+9b+cKmzo0XsdsGFIRJiEd7KTRdBc
 ANpMWr41tXBqhayiFHUD0RHZw2yM0G9M/SfvVd/ki/3bZ4Dg/TNz9UUKU4RmtGjSw0mp8cFCCZ
 q04TKmG1moFy1aU9XuzeBXu1r1GPbrMCK2ylrAZpIkys68Y1a954Q0GTu6JEyxYtn9kYFF3WMw
 2rHD3auNZ7lR87rDU4BJHnlt9+zFfeDDEJYperfWyPn3A9M7FKzM7AyBtSWYJGUBxwSab7OVUX
 p2I=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 02:36:14 -0700
IronPort-SDR: VGB+D2/g2tpCtkd6ihlzh+O7Q+SpG16cDyaWCuyo0vWT7lh/2h7w6aCvx3oAnoJrnqOZQmdHZr
 P2rPUdq/M38PgmX1VIhD2hWhq0y5aUtirNmX7LvlEve3ONlzH94BAIZic1qm6LcWVIrvD66J+6
 zfFkH9zb8rlhFIsdnhaBxjZLPIcvm7v1ygQJ9Ik833KWtGfEu0LNQYYn1Z8g6pEKIfhKMjll3v
 f1IzuT9554eGJfRt4UlI5b//zYbbkoMNt3Tqv+AazMH/8+BNBKiHrutqJMXxfTUqnDJoShTzfi
 JKU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 03:25:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PmjPP0v6Qz1RtVn
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:25:45 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1680085544; x=1682677545; bh=HCeyZXLvVc6r8bavJE
        zag8k+YIR0m6a+Nh5jr0Kw9fg=; b=Si+p22qjYYg0H98bIHQikmLYBOxSzXkK8E
        BAfXmUwCS2rbJYGs+k0kKYubrrSwTrxsTwtR1VSFPMTJ/SmdgjqwjDz0QjK6jEoH
        DvpoIsG2KMA3vmlX5LGpt3imBVf+KTx9YkdsUn4aBbrzZhhex3nxc+icSfNUfFdL
        U20yhEZIATTQrSkBX1Jy3zZVLhttRpF+V8MsQtOUzWeFEhcjdb7yArY3/j5ms5Cj
        acM3W57gREs2t+wEZf/OPq7XIVtl/jBfBOGa/1bdBxGlFqYI+cZ7GBtXAUvWvMzL
        jYAiekIGvjkVNF3HwOAL/r6ZJ4pf0JlHYzTc4klOSVzx7KiTNTXQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ePJaVHTkJ3Vl for <stable@vger.kernel.org>;
        Wed, 29 Mar 2023 03:25:44 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PmjPN3Kp5z1RtVm
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:25:44 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10.y] zonefs: Fix error message in zonefs_file_dio_append()
Date:   Wed, 29 Mar 2023 19:25:42 +0900
Message-Id: <20230329102542.1757470-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <16800036329137@kroah.com>
References: <16800036329137@kroah.com>
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
index 66a089a62c39..b9522eee1257 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -789,7 +789,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *i=
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

