Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03B42A1334
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 04:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgJaDAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 23:00:46 -0400
Received: from sonic314-21.consmr.mail.gq1.yahoo.com ([98.137.69.84]:35551
        "EHLO sonic314-21.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJaDAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 23:00:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1604113245; bh=oWKfhRZ3KbL7jvWL4nMK3yuX+COyNstAmZAUTY6mFWM=; h=From:To:Cc:Subject:Date:References:From:Subject; b=T3B733UnSycUrYXOKRsDIq8KNx0ZCVHxSe2eJHf5q4UJBQIkwk+tb1FGO1tZ2h3EaSwvOc7gg24EIB5NyiBNEZWhIw3SH/M79V5UmZ+e3bCvlLvibQMPVJFBvQfdACJFAd0H1YmRUZnKw7C9kuLaZKqu8FkGzFjJBT7Ds11phU03zh/bwUCPpayPqhv8z/ovK4Mmk7XyexzVE8BETmZ+sf/EyCdAtoXNtSaa0I63RRJ0m/eN5PNTUdqLEmOXU87Z+6WF+myOtkjmc+WANTRfneuN54YyuJ0GCs+JAdru2VudiRwdNFx8RmgCZhxk4DwegYIxbr0sOITg7+cR5UFvmw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604113245; bh=iIFp5/xM7b1xFkw9V5nkSXL6HshpOgZ+YC9SKSlXxFo=; h=From:To:Subject:Date; b=YzhQ0O8fLipUtLE6joDw1ccsMoGmQAVQoOupEbuZWnYuvC6vrRtc5VdzygNSrlSoBqqGQYXES5E0+F5lS6GurnwgZrIDOkma3xoVEci0+VFTaNKQP7oskviyaJ4xkD4YF2c30en7EG99ZAJFbv4oolcPnILD7z3ZWQwBe5Gl/MkBYZsvtvI7w1nNeMODOUjBzybtXMVZB5DDDStOKMLrYpgI0W/AIt+GWtkK9+opaWHh+vMM2SdTGlw3oBXJD+vSF3R/noPY+H2pgkvHg29OOSirpg/z2LndrPFWxF2TXBJRcNZS1dZ+Sct2ZiYcHComW632ZNLcw9iKhtjzP9/KFA==
X-YMail-OSG: 5G3_4LIVM1neueXD0R352rkFCB9wcOiKlpOb46qEU.X1t6IdV3G7Rk9KY7tYPc2
 rPnUGctoMTuV3H_v_H5LtAyT6PgET0YLqz1PWBqjXb02eABDgZor.XwmVWl2w6yHTItFO5cfFIK8
 ert72I3D7pTQEjG3S0JBFjZFfy1LOBbVAGELyzdKwbPZiYXTWxoQxdcXhHe1JjKDnaO4kCgtGDXy
 cdqgREVIXqjifE8iNfaPTn6.4wZqggW0JQr7YrfO.eaZqcjV0AJNba9S_KZjyKLEBB4.XC8vGgyr
 ipAFaVyEgoyS703NVfybeRRaEzEcgjeMm_Q9FSWeFuJMsm9pFOiCe1mIy.rO85QhVC0UMW6gA7Zv
 AcCIFeykIaltkoUoDjGV6AvMZlfLB90JNdIXAsJFR65VvYWcBwcdt8HA86Ps_Exq7Ps.xXEsXWlw
 FWEOrUTWlLfQ1JbpEGaUBysxgFVqQ6SF8slHX7m5U_TSPtrYq3n4UjuLspwMcmzb5SZOE5xFDt6M
 nkP4d1Xv.45bbNDpYS9xL.ttFIsK5ulecX.Me05Oc8O5LAia0mEIQF_I9bPu9QCoyileFQ9neSqk
 udBrGFQYfLI8OtXZXy36NYkAFBoekoLUu8Jav34C.HB0UW7eTJ7bXb9OEAwcHN5dueXr0NRL_jIl
 B7md8Mq6McqIYRXK8z0DQ2rybbCqtmckgb.zk_RSU6rmc7g1SK_w1_uRZ1TqfDyNFgfixU.6dX10
 GnYMBmtxDXUUFbxEmwyNjSV_sNLLl0_UmkFqCYW8iCoPyoUgg8T6fe3fGVtocooa3NiAcs0zwGtQ
 MliBuMuhRkvalLUNe6nDqjOUPDP1wn5FZTrzRad4tBser2t3vwpXelXqvyXIylin7urBPwkGMBsi
 PTi93er7tLgRLUyLP2uDRtGiS9foFgc9xhs_OEaScXk17RqvwNMWPjmAsKSNC7nxsOrS8H2L6qZF
 0dS8Mf6GgnQtZbfwOynaNMAyuLidPvPrfm3fLZJ8A_R5NzbzDyGTjjRBiotr3m0jSaJcQ71IMmqy
 7N95fD3gnqKEwXQsN_Vfh1ALtiGq0tmI90Feo2Ij4MWcFmH59YEa9EvM5e7eNE0b6M.CcKoiroEk
 G6EYPOQpeUZb5LVp9wlOZSgDo29M4YoXcxmUySLEtXgUrFpBepmqtS42Ovet9hgqvQn0tScIghfm
 ytjHcPt90LoFkeWt80xzVWrLJUo5DrAANvxuGZFbbf.OjdsciAoNjZkSeEzKPVtiUZ7PsGgeWgrB
 KWEfkw_m7MQycwY0luITlVlhSdMe6nzhtPAXPe2k82WFcrVCt1MrNH8BLPu8P6vNtvQy7iyo.FIs
 JuSrYl9EhDTlV9vnflOLP4V88THpvVlTh2oJCERDsQ3ytgYIKl3KuC0eGF_p.M.WqY8rvpDPSbUw
 BeSrtEn12gSDADdm_w3Gv7wxEtRyh9wMaDdqx4CyfEShKfiuq81OehiOil9lInzUzPPkZI.uGVGr
 CYtbvCCNaw.ihJSNqaYwpRMDtBqrQzP4iiMij8uyP5yx6VUdVtFPDcbzCqsbgHIGuRTxfZJqQMPD
 JDX85P5.JG1m7DD_STdSQSw2DVruei8ETumFcoz3w4YvOTKqNOhwSuiF91eW7vwY3LioUn96FpJi
 1Z7yMN8fXFJcuvYNR1bVvM50Lf0NXOzshjLHZc7RGwlYwbupmlmtux_AiJVh4lUo2K9oL_xTq_lO
 IGRcDCIp4OhKk5g5vFj9IgSQSSei.62hy.tsH6IMZlH1j5kUO.BlQMxf54Yd6gGGe8zYDyDLeODJ
 7tpy2KvtZ910RBBf8PWbZZpeD19wAXFlqjXBt9QzFWuaQYhOEQN6pFJAt4fNqN3TQ5ETg9pkKwem
 rROirPe64DV7eXbFXnowLHBL9xGkXkPsa5kSexV7RIz.ScOqskNAbjlpX4RhKauhNZvb2Sop4mPO
 6GmPnygjFtSuG1oo4lAbNU.u.9Ed2bA83YCK7YTg7Ya6mEnurf7AmLo.kNati9l5JNOw4rAsjVUS
 k7tFkUvFiSVeza2ClX6iXDTYaiVbHi7vEo1o7oikK6by5uk3Mj92TntsoLisiwWK7hxDmpaqDYK4
 d7xU5Nk3SlIjcUKszUPoX5d.Jrn_QLwIDsfYad1_jY4rRvOJ6pfAfyYS48qFi3n7sJN4tlOr0308
 Glt7Mj83GQfLiZjSlkZGIp6bdLBG8kwGKkVdx9yWiHDhCw9rFDPuf3.kDSkukBym2PsqRS0rmUoe
 mTT.WjdCDkWa0tPFahwvjzXNKlWsaSDSVreBqJdAN3wzn.MDvH8oHh3BtKFUGpa1Z9C.21ZUudK2
 LrODBo0sga8UUD5OE_XvxYBNHIxOsUp0CFJbaGtD1wqobuKr69allSyY_D.W05CxvTHJ.QJtzS7q
 S_OQatrwIaaqbfjA2q05RG.iAyqbWIm3AdCjU5Fn1PaXLzxG0aFIWaMd_PRK7Mgbaa1601MS0Ylx
 JDoTCp0AWQ9t8sJ.Vgp.8Rgf7bp_dtg5Pv.tVdDGg4h7sLmJfDhwvjIeh_TMqKq_73dJA2fL8i2z
 ESxW4XLd.m7.4MZisTFyAp7mYNnuuDlJuwhE3q.0tPKhSqSqiBJ3Boijxx7hNyVwP8eppaD_kFHd
 F8IoTVj59_nB9RauPi6ItdfKsMN3LQQXTp6hAeV8L64_1qtUcqmFXy131k70rVPh966fhFhMKJpc
 EKR06Zt3XhB4lpEW9TTG5I6ETSSHo.dgrNe1zlvOgdGhstEkvZEtn3fefVUlddcdkA1oD0irUCwl
 IBUqWmpe2YCXIpb5qBoi.g1TfIWSe7h6E3qE2PKt2UWRQ9NnQ_Co0QGuCv2Z41TV3EZLO.Dt5qVY
 WGqtM_1fFfpR7ZUTZjPGMTegCWOwm9S4sFeBinsgPql8Cq_3JgbkIbhrEWJTwE9JujMNzZ5uSql5
 nO06LDh326Zpc5Q6o3p2z3I8DQuCiwbfnd61.5izku54hxnyZRuhf3EWr9FEOU7Eus5bc32Ze6jE
 A2lBvqMSqMZylLpMSZ5.SPdRFfCWuc30CMNyqTpOkwpzD301.548Bb6Q207b56cBu4F1U0Nq_uE3
 iq1J5K6A-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.gq1.yahoo.com with HTTP; Sat, 31 Oct 2020 03:00:45 +0000
Received: by smtp423.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID dfd422814a7ab1b56d64b85b4cd385e6;
          Sat, 31 Oct 2020 03:00:38 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        Hongyu Jin <hongyu.jin@unisoc.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5.4.y] erofs: avoid duplicated permission check for "trusted." xattrs
Date:   Sat, 31 Oct 2020 11:00:18 +0800
Message-Id: <20201031030018.645-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20201031030018.645-1-hsiangkao.ref@aol.com>
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
index b766c3ee5fa8..503bea20cde2 100644
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

