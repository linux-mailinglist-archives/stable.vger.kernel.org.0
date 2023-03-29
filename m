Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270166CD7A3
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 12:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjC2K1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 06:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjC2K1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 06:27:39 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A3E421E
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680085656; x=1711621656;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=P++I255Wn+ale9M6M0XbAJoD+abE/ZUd3Y1PXHt0WQQ=;
  b=X2ukmoGY5AbBcEEQJkgotHEVOuxtyCNw+d5GdCpBBA5/EAUq0EBdTcYE
   rnEerZHqIz4Rp0Rr1eIpcXyw1nf/F7EwytLg2gNsjL986A8HEgrI/XC2n
   JT+B//11Sy2rgrasroPFJ7x3ImNjPBFZA9z4WZD97dDp/sDOegpZQk3sd
   rxMu34tXZWbFDaM5Z3Kre8iDtlrNKSql7MVqY3dShRi0zKsoyeTSvW0a4
   YpxIIIX16GvUkvzsBCMfwXu7UoNLRa3cLX7ykkBRbuUVyWE+Wpnau+tcP
   yDhKhVTz9iEJBSh/I0MzmEcCMEflQEtFMX40DVsncQocZwg0p+lkB2a1d
   A==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; 
   d="scan'208";a="226596639"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 18:27:36 +0800
IronPort-SDR: HjP47AHaCv9fiM40OeZ7O9ssfAeympZsUtMBIeqtHnTrswGKFUGgM8VOkRIh6urUrNMZngUREi
 V6xJAoArhkwDuzXmn3p3KzBg89VEDJLS3QT1c24ZghXQM/CilKAFAPrX4OEwXxPrEYOMVoQCjm
 phs19c5RyGUBTZk4xPfj4ky++ZE9CspKcqcdFqRhDZDE13thCMzZJJH/HDIlj43IguYJXdxz0g
 DpbHnAnN2drW1SA03nyC1s7ZWmnbZPn8YxYXOsDANQFiVeSyuljnPN4trfIj+sFXVDvBOASeAL
 lFA=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 02:38:07 -0700
IronPort-SDR: Z7ROd/yuJtMoLtgQ3L56LtFwFJn1FxpVr87w4EJ88aoZt2kCLeeq74OXswPnQ0KURe9sEY+8rs
 Y/aapfleDf9MctMf+rHSYJuJ3wdStOZeD54+PXEp1xjoW9GpWDqNFW5SPOaXrV6lszuEfg6dor
 ePcYQZ01PPVfgfefi+0tMUAfUYOlRxJtBWfDmBk6fGoqV/gMji5NMKt7vMWB73deG75bgHB61k
 n+pzqYc9/WewjLJuINNkVJY2ORRxaAU0Vz4Z9KAhHwCp7q/5dIJMghWKSbHsURdMtZOc80gJLI
 TzI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 03:27:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PmjRY5bXWz1RtVn
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:27:37 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1680085657; x=1682677658; bh=P++I255Wn+ale9M6M0
        XbAJoD+abE/ZUd3Y1PXHt0WQQ=; b=NOg8k6+ypk/Lh12SpYzvVGPKj0ZLUa2niq
        ly2OomcRS+LkmBx4vuYckC9jN0G6Msqn6ARL46Ru9UT8cpvSXmk/q5wcwQvkZ7aS
        pKCEZLde9hadE1rSeH8q8t2wJiJZjQ29oHpi9DAX7yMPd1CTEm7FjxnDB27mn6NG
        iXd0kj1Ln1p+YWEw7YEnqdZQG20St8M7cie4lLr4/BzBjTjHf3RKOeriw3RT9oG+
        zbToHQxGb7L4iWgxUXdHVGqc95JErA05FKoscl4nfd0dh3ik5jvnTVdH3oyz/J8g
        LpAjRai12PpeyP5tPFwrmADgxwoqjTDOA6sjktVKtZwHgOHyib+g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3a2Ua_B_OCoq for <stable@vger.kernel.org>;
        Wed, 29 Mar 2023 03:27:37 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PmjRY0vCQz1RtVm
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 03:27:36 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15.y] zonefs: Fix error message in zonefs_file_dio_append()
Date:   Wed, 29 Mar 2023 19:27:35 +0900
Message-Id: <20230329102735.1770292-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1680003631103149@kroah.com>
References: <1680003631103149@kroah.com>
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
index d3e182c1a128..ffb2f3fa386e 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -782,7 +782,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *i=
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

