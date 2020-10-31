Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6712A1A4E
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 20:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgJaTvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 15:51:21 -0400
Received: from sonic303-25.consmr.mail.gq1.yahoo.com ([98.137.64.206]:45219
        "EHLO sonic303-25.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbgJaTvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 15:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1604173880; bh=Y3+Vr/7VfjoQve6rX9Ou7rfg3kCgfxLd0wjV4hIjteU=; h=From:To:Cc:Subject:Date:References:From:Subject; b=WK9FE9kMmxwDjyvub1HmPSXZ5ayOYWE+W8OVc1S0lQqd1DnLegCRdfbOKkEwzB5aS4gE5Z3X/1TPj2OpdhkCL8Jan35aQJUVGg2Asgl/aMs27Wbi2FZqxibb82oDl1/Xk6zhFvv7/rDL5R1UoyXAy2fa89oKOdsFL7dmEAzlsiCN2W3nTnLybt+ejETUNqgDrgeT8bAtwIPFFRwECyrma6f7++CSvhNZ24s9bSBGdYVRAX6VJpHIa1KltCQsSoOrmjeWeNiPCFI6iOP9M9suZFkPoxGvSth1Lth6i1f/VrsLnIERbrm13mDEDvntlxXBwIH/q6i0BUpey6fN6YCmNQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604173880; bh=xRHW7MtCvNUC1k2z3iMUjR1ahI55MbvrPqNxwQCr9ot=; h=From:To:Subject:Date; b=MgzmM2N7m+QYvzeNFQv6Wx3g6/67pxgTNwgmQ2PQjDv7B5lmF8VyMOyXx8px89TqCKB+OmbS2ACpNk+0ivVrzlx+QBqmTfyRYZERDpOrXooOCyM6cS5d0j2+rULLESNieH1yzOhBECNVMc/hSiXOiQx9mQo7MvWtJM7/sfVPF6a7nwbn/rksOYVVSADYAH/UlwVqlirQQP1P8L1nO4uSt8kx3JbngzQ9c6bMi3ZMi0t/tw7m9Da9NKNJ9agfHH2O521nM7QoMfdAK0PQBQd9Rpjo9ehbSN+KegYcwQE+Q4CYjNHxCWdkuem1C5vlacfbvweeo5knDc1I+10ztFLB3w==
X-YMail-OSG: t63H_IgVM1lrkxT3BjOR9jzV.zlO3BhHr4NL8F7Ou5JvQf9xnEH5wvBBTyF3Liu
 pzwmSYHfUHs_NrpW0VPNvIcmtn8usIBGr7p8YS2vOzVZqQeuPafwoFUqsyJPABJcvHPk1MdRLctX
 zYLgzAdiplc9puuWJYU3Qafol.gacyLX5GEHlzW1NJCcrRLoK2jqcQZluLnuJ8NhrBGWBDXe8tPA
 c_yDOcYn3tWwD9OSK0l8vsohQ9HIEJ35GAh1byviIxpd5C5CIUffXisyNSsVtwufVFI6hkItfsKS
 CzBj1YjOLd7EWnQ2E5bih09ADr9FjrCcBC7v4Q1jfufYDFouBghQWR3Qeid2pe8C6Nc4TAhxMbzh
 MNRfy3mDnNbu8Mx3OIULV55DQ0U3arvGp82P8YB7p9lvjQcRR99a9HIHy9fbXO4tJG56Je5tzC1s
 iJcgHLqmu6K4AiD7AjBVTdQJ4KFVrI6nN7FyEDkA2rWY5sO18tjhPjWXzIgYhAbVuOABApBz9zZS
 uflqG0olwfYyUK4EUfgfNV.9WyhVfmyoZs9yEfLFLMOjM_IlP_hRrounlaNmUw9K8JNWZwwVGdAV
 RMW7FvClNOdLUYK.sdLR7J9deYn0p6acAaSlqdPkupzzycMLy5.VGm3RYcv5DU5Yi3Ll0eu1odIj
 piwoEyXGo7yivljEXnC1lMhdQYw46a597DvYQuN4O1bw4tAa3_vFPZvRp0uP18zSGrXJy8X04WyH
 6Ns6gDjRLAAlvXC6IZmW4nMher5iHxTYEKyYhljgu94AMBi7Si7xpUmtkhooWTgnaQX11TBwH.nx
 wPqmneGwnWSjrS1JcUqbj_wP9iybtjUUn4G.4A1607yCxYPmfsBkWJ15dWGSL8Gl82hGVElhiH.q
 FUv72v9FOoq0jCfa4URVXUfGxzISA2EwasyMGMUrmcHVaaWRF4TQIfNaEpRVhWZDTehglM2cz0ED
 xDCsM_APB0vropDmhI_DyOUvDlIQRoeeQF0v3z1ykisAUUKCv4JRgC9ii647cuHPaUZWKGYVT6mY
 8KQQH6EPY3QckWKPK3pDHse313OP7s4y91AMPJkgNioZkWtr2djEQo9CR6G1LxqiplAfdTVK0loh
 gtXf_hHeKbpE0ncHuJxI75qs87UJKhKfXnyhuAO2Ynp2ITaFhKm0EVKKdQ6pIDULItwXxNSi0HG.
 qlSNEzU78Z_2JVCT_Zt9WDwoVAIxfnbbUnF1FNwX5gPwedSh3GvNwssW9JD75W_BSCXxS.SHD66I
 CnK2udMezSz8hquRFSiqUCb.cHnWEptYWgNMo0KrFxXKyHBeMLj8v5tcQs7gAwKobAzvNBFIUwE0
 RMPtjSUqYYrzYGjDM44GA9r0jofnUmhFZBEe8LpJ0z43XG06kuhXjW_0duGUYEKCC49cey7I_FlT
 D6covBgrLcJn.I57UGvQtYd3fL3KYT3Vv2eyv6ew.pUz55jZ7WLt46FneiCgjpM4yVaOIzn_jDAk
 6B3hwoIqrlP8Og1W1I41RltZC7qteB_Ta2KVcV4biDKzkrXRwq_RFl.DjYiDmbGOTrsTUoCg_oCo
 su2z_fPRK8SgbH_x67Zu7.CcKmsGzeeFCrOSY_gzRLt.u8trk94mAf7lD9mg6stfeMm5dkSyob_j
 Bmww2Z__nVOMU21PPyRqRtkwAqMFSZZ0GHJmcq6x7StxTb.dWWjkmmCaZSktEryAIl1tl9B7yw4O
 Y4kHduepx9B6u0MIAdl5jChHqqehkugii.VbI9wYazKzyVzPz9nRcUBmV8q3iXHJlmC7aiKb.RcQ
 l7tQKz3uTDfXwSO5uRN.mIB3Fajj_M_FsMsAFl2wo4WswkvbfmvYZThLbRq8xiVStXz7FWnfD6X1
 h.Yos6UEZvP.eYs__ssZs3RlckUjmALPLpq9lgYKuZtPn1sjzeTTiARSOcrh22KtgFl.qj_3K.8v
 fvVw0or6BzE0a2dTbDXtq7IIdSUicvixXC4dcVUqFK4_tFCJszQ.nv6DVQv6EA6EC0aIY3WjGzc6
 2XJm_qQXw4Tw8ADYXLvnnHnYiuITmT97K.JX7VBqaCqo6rxuiDSTg_uCNFZaJ7oQkMq339x4.JlO
 35XakCptqdWMfATuR09axc7XUb2kag2dGTyrgYbrQWwyFNxII1Q.7mgq6iE.QoZR.eajX7TIj8ea
 rEVMQvEzq_tnYYDzBuB4prXGglgi8Ad3pi0cmxR6fZbogp77DSVBB91n52bdSLhbARjD.lL7P8HY
 _8uKxfV0mtAh7cLt0vrgafi0KB5F6xUMv19fZclKjuDTrmwBdsnsXDEAF7di62LPjuzVSEyQTa9J
 Km482dhiWxk_plPrpP.dft4hG.F4UT62q4IquJ31SF0NPxMXzm8NSaECOeRk6aJ.37gaduoG8Woj
 nEKDiBblckKEJ1Ex_zFOHZD1ASDo1rXwg3HLBdlHhEKVxgAJa7oG.jSTj1tMi1TeidyhLoTkbvGx
 UzBQ0fDOkmOgh1dyBuztlqOq0DYz4kcbY.6PWHUInVAKX.GCjHcrxRllfPK00wwRTVn5pxsESD9U
 UfwF9rGUwp.no1BlKKK9CkmfYYu4qzpNXxWwDNKraHH8qsKSwEJebvQr6fcyiOqpOogs3YIumTzs
 8Lv_ZmgkH23LXeW5SwtFQx5rJ_j6EBAScH7VdT1FOFAdvaqlGAN8ajFqaHSJvFdkqLIu904V7KM8
 qH94HP03m3dgYxtccFsLdCrxaPP13bXJh_WqVwJenN7mYa26t9DUmkPgsQQNrG.cGR6m4SRrMAkw
 5wsDsGxI3j.2vIIm.A9WtucGe3xSssylo0oL9jxouaG8vB41c5hGFhEfOx0zhK8rERGswO_mneAx
 M6mJu.sAEf0pxXFmyF73mIchpBtCky1bEEJcgfmODG6CqSf1FcM4AQFF3I64UaecBwrN_GE24AJZ
 aQewVKCjcBOUdfDW6casg9Ie0R2rbMNTC0iCh5BaUfMknsUIOzY5r6hQL3DSdOXwGTQA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.gq1.yahoo.com with HTTP; Sat, 31 Oct 2020 19:51:20 +0000
Received: by smtp401.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 96f200b13834f92880e94edd3139f03c;
          Sat, 31 Oct 2020 19:51:15 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>,
        Chao Yu <chao@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>, nl6720 <nl6720@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] erofs: derive atime instead of leaving it empty
Date:   Sun,  1 Nov 2020 03:51:02 +0800
Message-Id: <20201031195102.21221-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201031195102.21221-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

EROFS has _only one_ ondisk timestamp (ctime is currently
documented and recorded, we might also record mtime instead
with a new compat feature if needed) for each extended inode
since EROFS isn't mainly for archival purposes so no need to
keep all timestamps on disk especially for Android scenarios
due to security concerns. Also, romfs/cramfs don't have their
own on-disk timestamp, and squashfs only records mtime instead.

Let's also derive access time from ondisk timestamp rather than
leaving it empty, and if mtime/atime for each file are really
needed for specific scenarios as well, we can also use xattrs
to record them then.

Reported-by: nl6720 <nl6720@gmail.com>
[ Gao Xiang: It'd be better to backport for user-friendly concern. ]
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/inode.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 139d0bed42f8..3e21c0e8adae 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -107,11 +107,9 @@ static struct page *erofs_read_inode(struct inode *inode,
 		i_gid_write(inode, le32_to_cpu(die->i_gid));
 		set_nlink(inode, le32_to_cpu(die->i_nlink));
 
-		/* ns timestamp */
-		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
-			le64_to_cpu(die->i_ctime);
-		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
-			le32_to_cpu(die->i_ctime_nsec);
+		/* extended inode has its own timestamp */
+		inode->i_ctime.tv_sec = le64_to_cpu(die->i_ctime);
+		inode->i_ctime.tv_nsec = le32_to_cpu(die->i_ctime_nsec);
 
 		inode->i_size = le64_to_cpu(die->i_size);
 
@@ -149,11 +147,9 @@ static struct page *erofs_read_inode(struct inode *inode,
 		i_gid_write(inode, le16_to_cpu(dic->i_gid));
 		set_nlink(inode, le16_to_cpu(dic->i_nlink));
 
-		/* use build time to derive all file time */
-		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
-			sbi->build_time;
-		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
-			sbi->build_time_nsec;
+		/* use build time for compact inodes */
+		inode->i_ctime.tv_sec = sbi->build_time;
+		inode->i_ctime.tv_nsec = sbi->build_time_nsec;
 
 		inode->i_size = le32_to_cpu(dic->i_size);
 		if (erofs_inode_is_data_compressed(vi->datalayout))
@@ -167,6 +163,11 @@ static struct page *erofs_read_inode(struct inode *inode,
 		goto err_out;
 	}
 
+	inode->i_mtime.tv_sec = inode->i_ctime.tv_sec;
+	inode->i_atime.tv_sec = inode->i_ctime.tv_sec;
+	inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec;
+	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec;
+
 	if (!nblks)
 		/* measure inode.i_blocks as generic filesystems */
 		inode->i_blocks = roundup(inode->i_size, EROFS_BLKSIZ) >> 9;
-- 
2.24.0

