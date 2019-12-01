Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0F510E111
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 09:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLAIlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 03:41:02 -0500
Received: from sonic302-20.consmr.mail.gq1.yahoo.com ([98.137.68.146]:33528
        "EHLO sonic302-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbfLAIlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Dec 2019 03:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1575189661; bh=20PCjo9JU3Dbavb/3Bs50RDjpnVfQ55gM0PpKbtAZKw=; h=From:To:Cc:Subject:Date:References:From:Subject; b=hv/UedqKxnnbIWUmNyPa/jK9iZ2WTEskWopWv+sj8QgG9u+MeK1FsWO2mq5vSlXnOiu2SACHkxmgZdWJOtutSqDxt/2nh1qcgh9w17QDReba6SE/RoAJkkCv/99tb6pfjw1n3kGXGSzQOTiiLtj5HMrifKr+SQ/TWICNeHnqChziTVr5LyewrsI6J3OcP1fRBHpf5U1I5aRNFUYJ03XqVgK4YtvnJgYO+X+SMX+CPCVjsS2IoDhgntfcyAhwKA36+cLqpiANnqwqRwKZTALG8u2hN7YEyMUm7gj0fBDD7jON2xWuu55RsBOez/L0VZ3xM+FxEMOaP3JMy+LYBHwk0w==
X-YMail-OSG: Qrj31G4VM1npeJnzm6hxNS.pUPN9c6Ic5eFuTgZvtIPMWnP.9I_m1zNKb8U9B3M
 Kfx1wP2YM4Wx1iswr6O0kUC2nKp1noVsK8tGxSN4uaBwW8ewaKg_PoYocEDIfhSBGasOZ6HPAQbW
 0hKtdWxxw5QHgWY.lV2V_Apreypb_LtfsHU83ZXN.b5boe8CJ8jOWGZbaPwjeqVluRjoQlXes5uV
 dcy.sE0gfuuYIN_DXz.DEyX2S8tKVJHEoUxaMBDwpFXypu6Wk7WdpPMRmTbVxO7jRd1tSGQKHvQc
 Fbm2QORDlLnjw7SuMsZ7qVjC5TZue98ZiMP9bq1ZKm9IM2Q9.kVWYrkpRMMZPbMOqLklDAheTCH.
 F0wAqYOym56nKIcV9j7Gav8tHqHRlWCLGQcX9p6o5lIY6c.poClt9MPJv92H6Zwf98oJTzi0ifuj
 hsO8P302KT4aYi9UnJM.tWaXcRTjwGRj3sD.caDUrzdhhfyaXijrvTVpfdZ6QX6RoCYRIt8kAau_
 QO2nL45k3Su8aMNDqOcgdtPLS7hvQr.E1OYAd2YLQyhRE_vtv1b1HeNEm1ZeZwc4BKasscMdOGjl
 K1oGKUXKQQRt6KvnndJPNo_nsgc9II1Cl8fmGOSOJD8jwA4ZZOycne8pdrUs.jMrTBny1E8bgB1J
 Evcr9ZUDeVXNjV8ByPzIf6YzYJ6w41S0Kwb0_.7TgXwJzzEk0B3tCiP_GQpyzhKKYsksvYR_Sdhc
 DwZCVUrKDuv9q8ctK3Q4jmvTL.xREN7hb.KgiITwQl9r_xaIZoE663fkdOXouPRpjY8MQc_3U33_
 YrEkXMK69JZVkWfafztc7dRvfXx3erkvwI.nPxyUh.2JJqneMrS5AiXNgzmWlgo1pWIse81mFpyi
 xYJp3ajmgA0IVhhEXAf7aqNpN.axpHc6hwDoU3AqCiLM.QfVwtd8zu3D.scUbM6t3CAHKs624haF
 cMAsGoS7Ov540C7hVQ3bVJisOzvJeTqzfwL3pOKXTHTfeXQ52ULP9p0jZQS_YYjO43P5b3BNM6Vo
 Lc.O8GBE7XrnEHnMQtDwaWGsN8uh2KdZNtwQCQs1ILJIivk_hyF0ZHNTEWwbYtCbbcLff4C.Naf.
 D6as6drlAcY1ooFRMfs9nURjLHduFj93HP0Trff.jvNNecoFqE8uG6gYssgzHlOsNnS8b7Q5hHQh
 e29R69Lp0nIvqQWNHDKlU2xOy2dJ1VcK.C9dbSRLgE9iny8_FzlQ1VEYe3OcuVaaR1Z_zqJm.oxl
 qamABURZ2wER8h_0dJwZrpBxSWy58q8S8geXbHUSqdGBeNvRMo0RHf7Mi6SLj4Ca5hTRYqkCEDIP
 VXXcaivjZx8gmxBdRIac675gSuISCx1Rl5qGr5oW96UvQhJHEtC_xocKwkR_0FBcabZ2MdEamXVX
 2VXaZVdA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.gq1.yahoo.com with HTTP; Sun, 1 Dec 2019 08:41:01 +0000
Received: by smtp419.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID d0565019c54eecb6cc19d6eb884efcb1;
          Sun, 01 Dec 2019 08:40:57 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     Chao Yu <yuchao0@huawei.com>, linux-erofs@lists.ozlabs.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Michael <fedora.dm0@gmail.com>,
        Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        Wang Li <wangli74@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>, stable@vger.kernel.org
Subject: [PATCH] erofs: zero out when listxattr is called with no xattr
Date:   Sun,  1 Dec 2019 16:40:40 +0800
Message-Id: <20191201084040.29275-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20191201084040.29275-1-hsiangkao.ref@aol.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

As David reported [1], ENODATA returns when attempting
to modify files by using EROFS as a overlayfs lower layer.

The root cause is that listxattr could return unexpected
-ENODATA by mistake for inodes without xattr. That breaks
listxattr return value convention and it can cause copy
up failure when used with overlayfs.

Resolve by zeroing out if no xattr is found for listxattr.

[1] https://lore.kernel.org/r/CAEvUa7nxnby+rxK-KRMA46=exeOMApkDMAV08AjMkkPnTPV4CQ@mail.gmail.com
Fixes: cadf1ccf1b00 ("staging: erofs: add error handling for xattr submodule")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
 fs/erofs/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index a13a78725c57..b766c3ee5fa8 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -649,6 +649,8 @@ ssize_t erofs_listxattr(struct dentry *dentry,
 	struct listxattr_iter it;
 
 	ret = init_inode_xattrs(d_inode(dentry));
+	if (ret == -ENOATTR)
+		return 0;
 	if (ret)
 		return ret;
 
-- 
2.20.1

