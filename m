Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C5F8BAFD
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 16:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfHMOAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 10:00:40 -0400
Received: from mail-eopbgr730079.outbound.protection.outlook.com ([40.107.73.79]:52770
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727724AbfHMOAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 10:00:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daEQOa2nNmSBtpJtQcYXP6Z6qMBZf+I8bYNJdvHl18PGcvkb8KFQilwN8EOPxV7xUxihKJidpP4ulgEDtEQVH7eAiBE7J6uWNWEATjBGdE1Kd8Yi6Zy+wx2RQq5D92eH0a+bfsPIcDrk+eCLEtV2J5xph0jk/rbnaJPL+R0pQy7z8ojah+elt+nMdAEKQlGI2oRQlsarb36l+mZ+lgthp6VvEZ4oP+5sxQo81nBUtJRJQyGadw1D4e0ETi1WTPXn6mcCkMxzk+SJI+MzEkdQqxT/ziQSmMhaleUVPOt+apmEy1pdqUjucmM851UrXm9Kz/MtCMIeFIgsbfsGHYyGRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYLkkP8+dbm4kjG9uEIr2DY4cDvs88pd2PQaPm9WB54=;
 b=LD11FSCOZwc95Dn6UNayC40C8VK1m7zk0nflv4p3zo676yo2DshQMuDdOK3hB6y21g3ULP7MO3RTwuPNEQeIZjbvkWzf8utO1URJlfYslTJ00BsBfhtv7RARDUKWY9lkyAaFp0Cc+wdSU5CQbcQqXoRvR9/sfuokrYAvTSSGr7u3wJ/YO29ketG2Gbp1LdoD+gie90ebUVeR3Qlkii1hTv+3R1zCgw8CHyNcg+W67zvvfmHxyYAmEKN4cGuOMBzRsQDLfYDlD/oMUJeonTSdSJ1ZkuuH6ixt9fox9CeIMhc9Z1l4THkI3QOCxqPGqn5i2sMrxlmTgI/WlCsck99RKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYLkkP8+dbm4kjG9uEIr2DY4cDvs88pd2PQaPm9WB54=;
 b=a16X0K9W/6jL1BxEFCuLhxlYUHgwinXsba/DHrUmsW6baJjINssDxb6m4ED4u52SHHgt1TdxUawyn4XpzJwXB5G/EoKybkhqOd9M5esBo0AAS4dFooBuTkDblDn8kLd5rxhiVXf7cmzxwdz6mhBPeYe0DZ4y7OfsBIwU5lp/vxQ=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1386.namprd12.prod.outlook.com (10.168.238.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Tue, 13 Aug 2019 14:00:36 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f9ec:92b6:9a0f:30ca]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f9ec:92b6:9a0f:30ca%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 14:00:36 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] crypto: ccp - Add support for valid
 authsize values less than" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] crypto: ccp - Add support for valid
 authsize values less than" failed to apply to 4.14-stable tree
Thread-Index: AQHVUFT+GRvE15e99EyvL7H9nzAzFab5HaUw
Date:   Tue, 13 Aug 2019 14:00:35 +0000
Message-ID: <DM5PR12MB144907F9F3D95886640325F8FDD20@DM5PR12MB1449.namprd12.prod.outlook.com>
References: <15655353989018@kroah.com>
In-Reply-To: <15655353989018@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abb89d10-ea86-4c0b-df2b-08d71ff69d82
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1386;
x-ms-traffictypediagnostic: DM5PR12MB1386:
x-microsoft-antispam-prvs: <DM5PR12MB13866184C4CFDBBB4F4A06B2FDD20@DM5PR12MB1386.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(189003)(199004)(13464003)(2351001)(14454004)(6116002)(8676002)(2501003)(3846002)(1730700003)(52536014)(81156014)(81166006)(76176011)(74316002)(33656002)(9686003)(7696005)(6436002)(66476007)(5640700003)(66556008)(7736002)(446003)(66946007)(66446008)(86362001)(64756008)(305945005)(99286004)(53936002)(55016002)(478600001)(14444005)(71200400001)(256004)(4326008)(66066001)(186003)(11346002)(316002)(2906002)(229853002)(102836004)(486006)(6506007)(53546011)(5660300002)(76116006)(6916009)(476003)(8936002)(26005)(71190400001)(6246003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1386;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZO/Zf6VGRIwQBiuQOme0h6WFkwKRVCDNW5UEaMscVIdl9p+v79dQcRKQohk3P7XfnLpIUiPFyVNVuZspcG0lFdrUs16ZybWJ4UG5Prs76h9nK80zRP6Jud/yZHHE/FZeyaqGMg8w5gbmWDUwN4T+qp/NDBeI6wqTvmi8hNe9pLMWUo7BWyHTgwe/6JwGaJr6aC6e9DnxMVYG1LDj3jU6usEZlvnNIhFeZuLsYBW0q/kGlZV7So25S1yjiIuzEL2K3Lp8ufRrR2Vrw76Eo7d9Ss3UX+ianAgHABpbliTeduA5NFgoCeJk8oQ8qjr2R+FR251NwNo2UuSU7xfxL5s+piEUhXDZ+KDEKKdzNGIKmKM6bWSicZ/V8FTpA6tjHI/iN5rUdgvYyJGrbF9Qv953h7n1Ib3N3kxvuHej5tcJnm0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb89d10-ea86-4c0b-df2b-08d71ff69d82
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 14:00:35.8811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tQoeLSToRfJNpge3/nnHUEW9n6/snSFcB8NRGFFxDVBPbQDfttptBsb9GXaTajB0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1386
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It turns out that this patch has a pre-req that wasn't properly marked as "=
Fixes" for 4.14 stable.

If you first apply b698a9f4c5c52, then apply 9f00baf74e4b6, then this be cl=
ean.

Mea culpa,

grh

-----Original Message-----
From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>=20
Sent: Sunday, August 11, 2019 9:57 AM
To: Hook, Gary <Gary.Hook@amd.com>; herbert@gondor.apana.org.au; stable@vge=
r.kernel.org
Cc: stable@vger.kernel.org
Subject: FAILED: patch "[PATCH] crypto: ccp - Add support for valid authsiz=
e values less than" failed to apply to 4.14-stable tree


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm tree,=
 then please email the backport, including the original git commit id to <s=
table@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9f00baf74e4b6f79a3a3dfab44fb7bb2e797b551 Mon Sep 17 00:00:00 2001
From: Gary R Hook <gary.hook@amd.com>
Date: Tue, 30 Jul 2019 16:05:24 +0000
Subject: [PATCH] crypto: ccp - Add support for valid authsize values less t=
han
 16

AES GCM encryption allows for authsize values of 4, 8, and 12-16 bytes.
Validate the requested authsize, and retain it to save in the request conte=
xt.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs"=
)
Cc: <stable@vger.kernel.org>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/cc=
p/ccp-crypto-aes-galois.c
index d22631cb2bb3..02eba84028b3 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -58,6 +58,19 @@ static int ccp_aes_gcm_setkey(struct crypto_aead *tfm, c=
onst u8 *key,  static int ccp_aes_gcm_setauthsize(struct crypto_aead *tfm,
 				   unsigned int authsize)
 {
+	switch (authsize) {
+	case 16:
+	case 15:
+	case 14:
+	case 13:
+	case 12:
+	case 8:
+	case 4:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
=20
@@ -104,6 +117,7 @@ static int ccp_aes_gcm_crypt(struct aead_request *req, =
bool encrypt)
 	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
 	INIT_LIST_HEAD(&rctx->cmd.entry);
 	rctx->cmd.engine =3D CCP_ENGINE_AES;
+	rctx->cmd.u.aes.authsize =3D crypto_aead_authsize(tfm);
 	rctx->cmd.u.aes.type =3D ctx->u.aes.type;
 	rctx->cmd.u.aes.mode =3D ctx->u.aes.mode;
 	rctx->cmd.u.aes.action =3D encrypt;
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c in=
dex 59f9849c3662..ef723e2722a8 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -622,6 +622,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cm=
d_q,
=20
 	unsigned long long *final;
 	unsigned int dm_offset;
+	unsigned int authsize;
 	unsigned int jobid;
 	unsigned int ilen;
 	bool in_place =3D true; /* Default value */ @@ -643,6 +644,21 @@ static i=
nt ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 	if (!aes->key) /* Gotta have a key SGL */
 		return -EINVAL;
=20
+	/* Zero defaults to 16 bytes, the maximum size */
+	authsize =3D aes->authsize ? aes->authsize : AES_BLOCK_SIZE;
+	switch (authsize) {
+	case 16:
+	case 15:
+	case 14:
+	case 13:
+	case 12:
+	case 8:
+	case 4:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* First, decompose the source buffer into AAD & PT,
 	 * and the destination buffer into AAD, CT & tag, or
 	 * the input into CT & tag.
@@ -657,7 +673,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cm=
d_q,
 		p_tag =3D scatterwalk_ffwd(sg_tag, p_outp, ilen);
 	} else {
 		/* Input length for decryption includes tag */
-		ilen =3D aes->src_len - AES_BLOCK_SIZE;
+		ilen =3D aes->src_len - authsize;
 		p_tag =3D scatterwalk_ffwd(sg_tag, p_inp, ilen);
 	}
=20
@@ -839,19 +855,19 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *=
cmd_q,
=20
 	if (aes->action =3D=3D CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
-		ccp_get_dm_area(&final_wa, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ccp_get_dm_area(&final_wa, 0, p_tag, 0, authsize);
 	} else {
 		/* Does this ciphered tag match the input? */
-		ret =3D ccp_init_dm_workarea(&tag, cmd_q, AES_BLOCK_SIZE,
+		ret =3D ccp_init_dm_workarea(&tag, cmd_q, authsize,
 					   DMA_BIDIRECTIONAL);
 		if (ret)
 			goto e_tag;
-		ret =3D ccp_set_dm_area(&tag, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ret =3D ccp_set_dm_area(&tag, 0, p_tag, 0, authsize);
 		if (ret)
 			goto e_tag;
=20
 		ret =3D crypto_memneq(tag.address, final_wa.address,
-				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
+				    authsize) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
=20
diff --git a/include/linux/ccp.h b/include/linux/ccp.h index 7e9c991c95e0..=
43ed9e77cf81 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -173,6 +173,8 @@ struct ccp_aes_engine {
 	enum ccp_aes_mode mode;
 	enum ccp_aes_action action;
=20
+	u32 authsize;
+
 	struct scatterlist *key;
 	u32 key_len;		/* In bytes */
=20

