Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EDE2A133B
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 04:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgJaDCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 23:02:06 -0400
Received: from sonic317-21.consmr.mail.gq1.yahoo.com ([98.137.66.147]:39768
        "EHLO sonic317-21.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbgJaDCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 23:02:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1604113324; bh=R73TF0Zm2VExUeDVZshbWBh2g0cWxrDy5/hz+DGx2Ds=; h=From:To:Cc:Subject:Date:References:From:Subject; b=ER0TUqyMfObl3q7akR0Sw09dcaCPloAzpzTi/ue3zpDcXlvTJLH7F6jo9G4LhMvsRYOkLpR+Op7SIt/jbKc39WoJueFujW391Ny3uKH6B9ebf3wyxAJ5lU6zuj/MgSnEy3pLPODuFnBASCzV4c/O2txsbf5ShiUXfQ63e64mpKO3r2Z8LZRxuYSOJ++1vZdmvAkHcyV81H3/kICk1nkxP8O23pr2Rp/mq6sse/iYmcBeJCxKbdT4kzQxuNrUNbm3Fn/pwOHlxK2W45SfLCN8FG9/OMga4fWBFHyhf7R/KTWkTgLf+z4Yz+KbsvExNusXOTbdAPK5bxz8yM/0etAM1Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604113324; bh=6pqgcg1r7dlIzsBzsIaVJ8r3FjmRz6Bu9YKUuvn9YdR=; h=From:To:Subject:Date; b=ljuWHAJhgio8zibJXuHQ7sO+X591AGU6oyILWHDC2ihJoTr/Yxn5Z/DKInbKeDlnrlZ+ScjT38rnny3Nets4HjBeg4fqCy/xmaLnkbTvSY2kS+K74jDJCrehCJsjoqnq5jmsgZ7kW7HG38fKP3xjvKfwoEjduuJPyIGwaMpt6MRpstped4NdrfLK84BDW6cCHLZRPVvyNdTd83kgE8lxmnZ0zPoCkJYWAC8ImbI75QD14rvCANucMJK/o+X/svCdadkXXBBNoNyT3KgRQugCacMzWI6QoDRv9kxWz4qFWbh5/50YvycP243oz5GAcfjfLZM/syjYpQUGkETmMCJ91g==
X-YMail-OSG: V0frT4EVM1kp1Fx.fqP7bukaSkmqfrLHDWEAK1vtB7H7BC3jPH5u2C7rqrySysa
 xKRkgz87i0xrOfShcyQWSv2BaDca6aEPCl5q_HyFJTLQq9mk.Ay9OwzHT3e2TW4y5yxQ3mGaU7nD
 sQxfNnS_o2l4s_Vgs2uTb8v8AP1ZfbHzJ1LoE0SEZQSCXlW73FHHO50g50V5QZzhl4VFMdGatqa9
 sAF0ytnuw4sx..vn5Hs46JzG7weqwDPQ3d5rBNf.g2RxgDiZMCK7RCV7YlCsuPxbzBfSdz2gxW1c
 VVuQtd.vQCdcJ230gL5YmuIGsynvTfYMIyU34SkkD5n0dwSKmNaaW04RaFSp.tmjeSVGjZtjFXWu
 CHx.qJ8XvDTlVMAjVJpYLrINoL_obGaX73N9moDPbEDwS.vZQqGhy4uHaobaTXxWHaIHDaLtV8pS
 Zbt4sLTz3yIhUHZAgvYrRGNFX89H9TjBYOlvuv_xaw2dmt.c8WYs_w9YGOxmFpw0Z8dtdl_MQuGU
 q0cBFCXi24J_g8UMgCW1Em6ZMFhdjKKah_d7P5QPOG7paGHkkFFkwsSEQbXsuGWM6Zm6n9kPhfAC
 1jRFq1OB_w7bHKPSIGKef3oETGwRtUEeIDZz6V3_j9HZmRxdMcLg_RWJo2vi58pc0APqwATu05PX
 agZ6iq.hYmiJHRGrVoU0Yr3DPfkBwSKaPzy9IHMAra7b8asn4MsSeIG8Wl.klI_VhYMrSU2eJWM8
 ir0ZdyP7PRvye5iG.7vlQ_C7Wve3bOehaDM.ttExGnLJZ3xqVLJeUwLNKRTPhgSprkRDwjFcO9WD
 sQhuciMAaqbBdI4Q0giLXNW35J..SSxRE7ML3_QWoPXS.VBVynzQxq35TuVQc.huJ3iY7k6L9Zwo
 Eb0anWLIMIkvOTV7MxhuaVXU4eq.nrnXgJoOfaC5gXdFte7pYEkCMKAysUrMA0a2VYKW1KixW4xC
 iYbSjd_cv2GCv9P5Bf6HRQevBoNwtq0Mb0LOYRe6kA9kQSiMK.TbJwvMtz02g8twWwzA_yQ9v0GZ
 cmvXZd1kGc0MZaWOpcKamYSdm0mXlt9iS8ku8obVAEdBtW_GqoU.Jb9nZJmz6voom.Oh4mguwmJ2
 w_noUO7_nLBd9IpK0DN9r_vMZTZxHCxBB1NXPh_iZxw8pOaorbo7EoxgidbtKZBmjFd6kNjdjyD6
 Epn.qJ9GTqnRXs5YXxAK5BKztNvJAeKebna4V7xK8DurzZZFBmCO35ihhZcPnlrB.9xm.S7I2JIa
 qS30an70AND6u60H1a.L68cDIwrOda7gKfa0SV3p1ltgDLhqc1SRI38ms62XqN2oDG6N4LNqF.1l
 edYKHrWD2mVxYZAOun4WsAsZzYtTjHc9NKMLDpefSrZxrH9JzuLebS44EC_PhshkwbAtL.fT03yy
 pw4q932hqlsQakcmCN1SJn7N5bUygG67VtnDyvdqHA07zrr57nVH_HWSSPvMTpYtpZegVASHj6Ak
 xcAdMiZaHh36Sbv0QZ16qQdGDg1gxfPoj6uoRhGqJwgQNCL0hoSRYV2j9ncBSPdcaAdm0DsqpCja
 YZq3r6U4qAlCDSuh_Dlibru6S_chgnvlM5ghxprZ6gAZtjKI2.FmJux1GRgtPDi.3xASq5sZs95n
 WgrWa6u.SgJ5OaYHDlmeR8MBgKAth1YS7407zVbCeVw3.ie3XyHGVwHQyk8uw_LLZJncBnL53T5W
 4XGw8luaNKwhkbMmvNf.6AepGS1qdzm3rEkocTcG53CVR_0hDBoBInQQzwhCzQ.F0R18iqEWJF0u
 iYP.EwgK2JgCLAM1F7.WnXJsuMVGCZsD1FpUTE_OS92ETVxFK6akqW7pti5s1.J.29_ofcOMmdbr
 3SWnIIakzI_9Hlm02yrlRQfq0JaXdmQtMAn1k7lzMWIE_YwbMFAhHT6mwlJ_9e6miTF4V4HlUI_w
 fc_8bSA7BhuTi0XnFmghQ1gAZ0DooHvd4szyWBDXfoK8rDNxz7j0s7rCgxXvQGqh2ioI_26JxMHQ
 yLskmSvYlSOVsJipKmyjXoIHzOgNRkIp4eAYdOUGwrQNKKd2F5n1oI2kxvBnKIAkRr79dBMylY6E
 xNeRWJkO9TLSAfhgQW7J7sWBIdnxYtDU3Xm9vgBwVA4bG6PgREhY6jkmjJw12E30n9Kpgg6qWJj4
 9Z.3QR6YIyIXw.U400oFNlpUmzDLVENznZeZFcMKej08bhmubT3Wq.fRnMG7n631.qYAfj6QddTv
 w6qn9o_miIcU7SYl6q5jZc1CIqA5hK2siyZ2j74cqhxuQvhQ.FJGpQcAJNRYFbEA3Ka.yu9r046T
 5HtpevTkhRRtQ5Qn67uxGD.G1gN2Oa_U97XvDQiMfpdzDUblRpl63k6lyKbdyzdso1Nu_X6yysna
 rXH9QZMys9ir0MY_O58yYSSZVK2TBGEfsISBMw1lY3JLYhQrLhwhQqcQ033OCzZkIZ3YaVpRuxS7
 mYcMqul54F6MnlBQwUsUUauq6fjrI7gk7z7tKi4vtQ7UKUOg.FmUlrbXca0qH.P__v06mXrEfTMJ
 Kr5DHuMtMEJbMsetNY3IY_Et_qMC3v1ssEVA5rERosxxc7MsZ4bmIHTvpxhzqIH9tMkdqLTQdV6E
 ka0WmVXVVHwki6OEq_GN8DAiD02dxh2cTym._hlAi6KDAJBbW741nftHsYIoXusEPHnT7SBY3Jb5
 b10hlip9OMMGuU0gXPfs.8HO6Bv687p0TtuWWQ6JGc_ODXNTZpOl56hXVBNpuqYxWDlVIhKymL9b
 5skCFnTmEGR.YM1Nk2wlSWqf6NmOiHKvGG_hNMsh.wd3tOB7YIAq5XooWd_ZKyYGUb1BtAs3wPZv
 1kp9OYCxMW0jqhHx5tFfdCYpVf_.IeknD0TL19iiAbsc7fTUZYy1.y.ANDS7U63ysasnhU3dDpOz
 utr_GwQwUwX3PklEFcwH_QDB.VbKz81wgMBGF_ics5C6fmMEI471sDaCGCjDUu69kJEhioeV1qEW
 McCtRhpUcip1YOHNal6Rf5PHXHFpuMBrcyl.lsNDem.gKbJXZMcUHDBguMhHfHuOTaU_dk_1KNiQ
 Cjfe3EMc10W2Chw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.gq1.yahoo.com with HTTP; Sat, 31 Oct 2020 03:02:04 +0000
Received: by smtp418.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6282e59a6c5c255f5e355b6bbffc1fa5;
          Sat, 31 Oct 2020 03:02:01 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        Hongyu Jin <hongyu.jin@unisoc.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5.9.y] erofs: avoid duplicated permission check for "trusted." xattrs
Date:   Sat, 31 Oct 2020 11:01:31 +0800
Message-Id: <20201031030131.966-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201031030131.966-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit d578b46db69d125a654f509bdc9091d84e924dc8 upstream.

Don't recheck it since xattr_permission() already
checks CAP_SYS_ADMIN capability.

Just follow 5d3ce4f70172 ("f2fs: avoid duplicated permission check for "trusted." xattrs")

Reported-by: Hongyu Jin <hongyu.jin@unisoc.com>
[ Gao Xiang: since it could cause some complex Android overlay
  permission issue as well on android-5.4+, it'd be better to
  backport to 5.4+ rather than pure cleanup on mainline. ]
Cc: <stable@vger.kernel.org> # 5.4+
Link: https://lore.kernel.org/r/20200811070020.6339-1-hsiangkao@redhat.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/xattr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index c8c381eadcd6..5bde77d70852 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -473,8 +473,6 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
 			return -EOPNOTSUPP;
 		break;
 	case EROFS_XATTR_INDEX_TRUSTED:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
 		break;
 	case EROFS_XATTR_INDEX_SECURITY:
 		break;
-- 
2.24.0

