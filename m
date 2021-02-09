Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADB6314FCB
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 14:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhBINIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 08:08:02 -0500
Received: from sonic311-23.consmr.mail.gq1.yahoo.com ([98.137.65.204]:39891
        "EHLO sonic311-23.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231175AbhBINH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 08:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1612876010; bh=T/SFAyzoQajj7pmg3F6mRFmbgFjMMOgJpnlk5kQAz24=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=CUundgL6ZLPtqEoL9i9w4Dc3MEP9HFeI8gOfIrZ6T2Rb8YgMDf/Cw9hQvxutuaNTTpLIeYXxEZenI2dKrafvuoBVbcp8v4W/gUqONLMndK4CxyhWf9TsVdXDLx9x5d+vKNBXdbuzS3EkIp43WSqL+go4apfNADQXg//5ZV+C6LXDI1wyt5oHGqUfyfR3HScndj8W4uaLhTrDqHq6cL5q/TRToc9DmBzBAZf9Yk1nMVdhP7HE8eBsfCCF/AQu9ww7SDayxqAny7iEPBqCIB/EIfx6g7OwIijZscPx/qcZxljGMLI3xhYhbbmxdU3TDDg0CeHMt4QoVTg/SZ0q0zm2FQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1612876010; bh=u69q4lXNMHn7rpe4nC/X3pqpD1UHyZXHCG976ocyHJ0=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Ax+6AtmjdYhtnPet2zQ0p4PdmT8K3HDFvkTQh8ZRFBHs4ke+45vQhtExk1OKzM4RBlIMGtK7oZ/dsGniFvNkOXA5AV3EleeODFOucUJ+Z85+DkghKrkn1U2S/YgRThAFI58VfxQSeeL6GMEj4zyDKVlhQrrkgjZdyidaUgpJNwHGxz/amUnqA6r+e+pv3/bCcMDNPQs+FL8t9j1DSugjI9jBJ7GVGcH/vJxCMd66zjgvwRAGtqRF4+NuidXn5F82ogZz1mEaREiaJZ3wxqs2HH5o5Coi/YqtjRwOsuf8NcOBag0LzZkMaIkaA5RSXC5nnBZO5K8mcT+JLSioOHFa2A==
X-YMail-OSG: ZAROcn4VM1nb.IwTrqwoFcL2MIUhCmvdVLA837m8WqghSwRxJKZ4TClJw7l1JyB
 65YnixG5PVber2HhDtWpk1Qz7grfH02SKMNPoj5jkAfcm7muW47uZPiKT.vjODAn1PABu2sH_7k0
 bY1FiaY7cf0NZk1E9pZoQy48GigJbfOiENvaRcqYZZaL6T9iaWQZQaFYcWrCc5YdWTDn83rYPppt
 sCXzzhq5q71Xia5BORKdvJslqSQXWk8c6JwUJi0N0GN4AsvOVHX_ZhaVat6c1aZ0lHkmY2vnQUg0
 zsk3.exsYVirWtZ.BQDQEdK7HeJS_gN8c2UuWU1cdHYQ_vj3xRsl0dlHXt4EeoVulJuTCa0MAwRI
 uqeCDPu6nRrImNyZ06pGaJ1qSDOZri59J4p5OwNnvx.Mkf.9lUTWUBydhke6fibyeBsrNwqHDlN2
 Dw8kMBqKR0aU.KbnrvEzEiw87Dz6K6sSOcdqD1IQ4sspBwLnt.ko8_3Y2N56jeuXHHfWlA0wnbOA
 wrycaDumxRQmYASPn2FhWOuPtMsGvEG1Wzw4VliNPEehyHk7FPVWFw4axQIKNOS0pHlulOW0leAY
 O3s_dTj6ULI9xSL3_FB1h7DAxNuvkelG3.Wgvr_V_z9PjYcbraL7F0zkNy9JhW6knbBTfONNXfPd
 DcPF525hryycfgj7bMX39i5kJoclnEGAYV7nkJMqhmnXHSLe8vF6gNcanH59EO6TfoIAT741QKeN
 MzYmyKftNMy1WZdbodbVflZU6D8hwmLHJDrwrnJmLq9ICdyiL.s7aqIxjZpMgCiXljosXGRaZiC5
 JkfFjgi6DR6cvHFty9VRzByEmx1_9bAaCVGM0MxL5whKHMokzdHrKTQBbu7nHOC4kvFAIMvDMj9F
 xmD59s5.B7MxtlSzRbzzDig8EoZkqhMJ_pUbqk8muTcINDVf0479fPVCmv1dWR7AIEJwachr9oe8
 HgdnYiSzKhCwOVMsYnosIP5mru1tUhg0UGV74J2keloZJ8skd7HS20DKjsXOLZ5ikQJixc3Lxbts
 lf_mkkia.Z3ID835FpEKI6v.x3cg07t7frDKA2ZUjF206WxdHeShWgrDE5YENHJTCl8YCuOHwZCX
 7hyProw9R7fgXKf1f9op00EfINYD_g_h0pR6qMWIJocAYM.s9SMQUL.odvh7fQB.bmKDQlk3ONCQ
 F8amTODwRniHTzd9daOY21FbGz42RH1.988hchlFNkEeFc2gPLiAlWK_IyrtCPZgw.bqX2MIBwsQ
 6a.OvQCl_BMqaC5caAkzGXYaQ2Yf_AmEvMr0F4ojSm_vzM1LN5UPNDxCkqwAbyFNUJyFYhZigwed
 4QdONAOz6bTJesmeNcNE_N3XftzZlf1Ryi.POI2avJGTXAZfAAtp_uHm1ni91ZdySsKoke6xkXqj
 XNusCxecYNrTcxZliiC6C81xPSV2LLeGnBsIjvNiL.DOeVXGaLLlbnqaIUCPYS8XpsLVlKUOcJ9C
 wFKZqHDb.GjGTUIFZ15aadE.2unuSMoWSFkiwDIGQJz4YQlP2oPx7JMYxygNdycWEIdHWgJgLICY
 Q.aYnwBf3Yr9O8PPP3rEFi373hFduWO7A2Rst3aDxMK.PA_ZWJnJvCcbOyfU9alnB3kvjyWgpgYb
 EiQ6V3vHfoBWUVkWvEyaj5AMh9tadkjUC2MIFadbBRcnM.BTbUTOUe37p23kbJf1o0f5JWRCqnCF
 kVXCbhBykTlgIUfTA1rdV4AzSLwPJpyKmhb8uOuo2GTz.0sRSSXhKYnEX1AFl52ttCix4HGBpNLJ
 mJZ06oIZtUDudYDoYmpPf4wknLLFr4qnPA8MnXRk3NFrSXVAKvdrZIEX5FTalMYflyx02lt26phS
 CE1sx2uxl0ZsVcYL9wkDCEAm4GIVGnkZ1vNuOuXl2Jae4ukhXmgnQ.hKEVgOayKptPNC0VfNPEiv
 kJxSWU1IEcIA4JzjqzPdPnihSliqy.NZg8ju8Olv8VAcg_dbaCFfqUmaYLrbWIkbMtzfLuNEjP3i
 lcPFi.GXcjIsfwEeTeMK_x4layLuDizg3hxrbd1t9ja408gHON_K2rT7s.4qrKWQOXmCiVKv66z7
 nC2qWlaVpHY3b7U2B5EVwXpp0OnyTPRoMJCRG8eHg_qM875bGeL4NPRe7QdrDTh80dJ_ChdMmFnC
 br8cS.XmH91Q2VANC6RRSTSr9QAhEcj2wPowKCkEafJZE4wW7NSFsaDZ7l872BmpMrC0Gbq7zE3m
 G.CC7lhVXprHEVaSJks0_ItAIp5AQ4oGfBt7nsXlpRiqsneyNkKwA9jM8HCIxPxGusq2yrtE_WkV
 qwrfsXfPKZkJ2P7uX_luRD7Uhhaw942MhmYyoH5_kSPAZ60L7FA9eJgQsaCLniiVa5UmWSqeE.JR
 mQZNDPWNevqLbMizX_rPFvhkJ33alJ8BT6Q6yUPgWjUYy9BFypzisjctX3W.NI8i.xvZWvGBiKyg
 ZRjlZV4aT0OfTE2BIGIC3gKP9cyDHU5hJK.At6wcMreORX8_EgSH17MvuUaYs8PrrFibyiV8yMGG
 EB6pXwBgMoDH_yfAT6cfc7_Bmo3f.JpR.W5pA_J6Jd8_vZCqdwxwIGURRcf.cV6ON7YlSDSj9Msz
 16EqYhizp.ZQpROm5qPbFjppyVrzQCs7LnRhXSPsGoBmij9_MMBUTonVWo_h56DAXI1BF_p0bImY
 1AUm4esbj_00MCr.sH_2CyUsW1Z8AyZa44LD4fjbxmdn1mUZqmeN6sa9L5nOmcsY8
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.gq1.yahoo.com with HTTP; Tue, 9 Feb 2021 13:06:50 +0000
Received: by smtp408.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 5ddfd49f5fe95523731af90341f94f5d;
          Tue, 09 Feb 2021 13:06:45 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-erofs@lists.ozlabs.org
Cc:     Chao Yu <yuchao0@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>, stable@vger.kernel.org,
        Huang Jianan <huangjianan@oppo.com>
Subject: [PATCH] erofs: initialized fields can only be observed after bit is set
Date:   Tue,  9 Feb 2021 21:06:18 +0800
Message-Id: <20210209130618.15838-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20210209130618.15838-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Currently, although set_bit() & test_bit() pairs are used as a fast-
path for initialized configurations. However, these atomic ops are
actually relaxed forms. Instead, load-acquire & store-release form is
needed to make sure uninitialized fields won't be observed in advance
here (yet no such corresponding bitops so use full barriers instead.)

Fixes: 62dc45979f3f ("staging: erofs: fix race of initializing xattrs of a inode at the same time")
Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Cc: <stable@vger.kernel.org> # 5.3+
Reported-by: Huang Jianan <huangjianan@oppo.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/xattr.c | 10 +++++++++-
 fs/erofs/zmap.c  | 10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index 5bde77d70852..47314a26767a 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -48,8 +48,14 @@ static int init_inode_xattrs(struct inode *inode)
 	int ret = 0;
 
 	/* the most case is that xattrs of this inode are initialized. */
-	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags))
+	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags)) {
+		/*
+		 * paired with smp_mb() at the end of the function to ensure
+		 * fields will only be observed after the bit is set.
+		 */
+		smp_mb();
 		return 0;
+	}
 
 	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_XATTR_BIT, TASK_KILLABLE))
 		return -ERESTARTSYS;
@@ -137,6 +143,8 @@ static int init_inode_xattrs(struct inode *inode)
 	}
 	xattr_iter_end(&it, atomic_map);
 
+	/* paired with smp_mb() at the beginning of the function. */
+	smp_mb();
 	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
 
 out_unlock:
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index ae325541884e..14d2de35110c 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -36,8 +36,14 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 	void *kaddr;
 	struct z_erofs_map_header *h;
 
-	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags))
+	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
+		/*
+		 * paired with smp_mb() at the end of the function to ensure
+		 * fields will only be observed after the bit is set.
+		 */
+		smp_mb();
 		return 0;
+	}
 
 	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_Z_BIT, TASK_KILLABLE))
 		return -ERESTARTSYS;
@@ -83,6 +89,8 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 
 	vi->z_physical_clusterbits[1] = vi->z_logical_clusterbits +
 					((h->h_clusterbits >> 5) & 7);
+	/* paired with smp_mb() at the beginning of the function */
+	smp_mb();
 	set_bit(EROFS_I_Z_INITED_BIT, &vi->flags);
 unmap_done:
 	kunmap_atomic(kaddr);
-- 
2.24.0

