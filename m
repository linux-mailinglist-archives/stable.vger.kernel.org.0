Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDF171B9D
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfGWPbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 11:31:13 -0400
Received: from mail-eopbgr710067.outbound.protection.outlook.com ([40.107.71.67]:46010
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbfGWPbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 11:31:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHXrY5SCaEsYt37kh6z1b5JMAEGwU9GWO1g6QWeN0U4YCMWR4XG9qvSOhlnLhk4fj5CG5CAP3aujs/UggzXUe/GDOd64gwV6j7s+EICA7pxIVQj54SG4fzIeHG/n7tcYRZbP7N6GUhRnrbYlmUJ5nrK1yDrzYZawWWlYKuFkbL1tQw1kM9rEt300ItItZXh5gIaQ5DaURMRuof0WwRGd/PWtvA8DAslsBp4xA7UmVYB0+NhGT/fzgFj8BVFru0FDocTJGWtGimAg8o/Ug4YX5xlAfsnOW4iZOCbFhMIeDIBn+/5A0NmdEDQJCyJ7145yNunFZ/1CoVrSDhQ9u2v1rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBhMHLbU1T+1GgSLuyERYu8H6RxPsJypk4ieBbD4weI=;
 b=GaDbDNJpyza7+vCO0bf5tGb34x3qXJqxzAGxcfzNG/f3E/wJmjsqXuOwvlbZvm/fxyVw7UIZwBU0i235J6uRq7SljSOpgpWoFAz1Jxriba1k/c+OmrVosP6XPxUubTiq9RPu2iRgvN4wx4BHE5dpLm7vrcsv+bAAwFKMSh+cykNLuB17ju4IoF8ANFT6OaYKN0easHFRLM8ufoiXJ5b/iXzJM5K/8ye26S9HhLlw08GbFX/dwpP0bPa7TK3x2/U3eAWNQ5Sem3Zyl3iWW2wamzuZ6kau+chDm8zE59d08N791dMW9pn+nTi3nDlMlxf61jToS9mNOw5fCt5z0P9JCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBhMHLbU1T+1GgSLuyERYu8H6RxPsJypk4ieBbD4weI=;
 b=X00zCPZrTZHkeOnzB7bHWxbC12gPTu3Zx/Odiwv7kQkdX+mffjl4uzBOCiG3cPrI6nG+MtbJt8so5lgO/LWoAcZd02JrJS0hzJMmvQ6oAzuMp0B1jcqMeJX0FCe4j8U9wCPYpJP9qIXdYIrvTzw6RBKJAVf6S8Hje/2uMATK/GM=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1690.namprd12.prod.outlook.com (10.172.40.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 23 Jul 2019 15:31:09 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::3874:39a2:49ea:433a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::3874:39a2:49ea:433a%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 15:31:08 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] crypto: ccp - Validate the the error value used to index
 error messages
Thread-Topic: [PATCH] crypto: ccp - Validate the the error value used to index
 error messages
Thread-Index: AQHVQWumwV4N6L6NekOn5qv7zsLXTw==
Date:   Tue, 23 Jul 2019 15:31:08 +0000
Message-ID: <20190723153059.3987-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR1401CA0014.namprd14.prod.outlook.com
 (2603:10b6:4:4a::24) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1cec948-669d-4aff-2e74-08d70f82c8e4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1690;
x-ms-traffictypediagnostic: DM5PR12MB1690:
x-microsoft-antispam-prvs: <DM5PR12MB1690DD6CB8F95E53042BED09FDC70@DM5PR12MB1690.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:212;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(189003)(199004)(2616005)(14444005)(256004)(478600001)(3846002)(6116002)(186003)(1076003)(1730700003)(6916009)(305945005)(81166006)(316002)(15650500001)(8676002)(81156014)(5640700003)(7736002)(8936002)(476003)(5660300002)(66066001)(2906002)(68736007)(6512007)(36756003)(25786009)(66946007)(66476007)(66556008)(64756008)(66446008)(486006)(71190400001)(71200400001)(52116002)(6486002)(2501003)(14454004)(2351001)(86362001)(53936002)(50226002)(6506007)(26005)(386003)(102836004)(6436002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1690;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JLkO4rAN6bD4QQosGyA1W8B6lg1/iUT18r/9ysagKTqJ7sFy82SbYHM1ZpvrXWbuCTkX6yTSgJmfR3VGrAI4MlqEwFqxaoMEB73BcAs3lFltgBMz9g/mIY6GrVf82vkCg7qje+4zkSN41KuxI+HRhim54y668oBjZbaCxVbuE/sHKOLNHxMW9bccmtw1dXN0QSv8QZmrG19TpBsUvuGv+fh6pcySCoNL8RyTUWxT0Ebh2uPwiY6Nu4phCu+MggFlW2jpng0ICwO0Hr6TnXw0O1ynVvENsAXSPMd1M2E8SgOkNjXjL1z/BFqF77EW1RiDQe3dPrBgkgnA/f+G5UM8SX5SYXnvS/e63Es71+vBSf0g7KVhZ8zkm5aSkVNf74FZW8EzEObdiJVV3ZxrTfZ9Rb9PM9OQ/SOk/WTpGR4+ZNI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1cec948-669d-4aff-2e74-08d70f82c8e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 15:31:08.8168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1690
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Content

Backport to 4.9-stable for upstream commit id 52393d617af7b

The error code read from the queue status register is only 6 bits wide,
but we need to verify its value is within range before indexing the error
messages.

Fixes: 81422badb3907 ("crypto: ccp - Make syslog errors human-readable")

Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c | 102 ++++++++++++++++++-----------------
 drivers/crypto/ccp/ccp-dev.h |   2 +-
 2 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index f796e36d7ec3..46d18f39fa7b 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -40,57 +40,63 @@ struct ccp_tasklet_data {
 	struct ccp_cmd *cmd;
 };
=20
-/* Human-readable error strings */
-char *ccp_error_codes[] =3D {
-	"",
-	"ERR 01: ILLEGAL_ENGINE",
-	"ERR 02: ILLEGAL_KEY_ID",
-	"ERR 03: ILLEGAL_FUNCTION_TYPE",
-	"ERR 04: ILLEGAL_FUNCTION_MODE",
-	"ERR 05: ILLEGAL_FUNCTION_ENCRYPT",
-	"ERR 06: ILLEGAL_FUNCTION_SIZE",
-	"ERR 07: Zlib_MISSING_INIT_EOM",
-	"ERR 08: ILLEGAL_FUNCTION_RSVD",
-	"ERR 09: ILLEGAL_BUFFER_LENGTH",
-	"ERR 10: VLSB_FAULT",
-	"ERR 11: ILLEGAL_MEM_ADDR",
-	"ERR 12: ILLEGAL_MEM_SEL",
-	"ERR 13: ILLEGAL_CONTEXT_ID",
-	"ERR 14: ILLEGAL_KEY_ADDR",
-	"ERR 15: 0xF Reserved",
-	"ERR 16: Zlib_ILLEGAL_MULTI_QUEUE",
-	"ERR 17: Zlib_ILLEGAL_JOBID_CHANGE",
-	"ERR 18: CMD_TIMEOUT",
-	"ERR 19: IDMA0_AXI_SLVERR",
-	"ERR 20: IDMA0_AXI_DECERR",
-	"ERR 21: 0x15 Reserved",
-	"ERR 22: IDMA1_AXI_SLAVE_FAULT",
-	"ERR 23: IDMA1_AIXI_DECERR",
-	"ERR 24: 0x18 Reserved",
-	"ERR 25: ZLIBVHB_AXI_SLVERR",
-	"ERR 26: ZLIBVHB_AXI_DECERR",
-	"ERR 27: 0x1B Reserved",
-	"ERR 27: ZLIB_UNEXPECTED_EOM",
-	"ERR 27: ZLIB_EXTRA_DATA",
-	"ERR 30: ZLIB_BTYPE",
-	"ERR 31: ZLIB_UNDEFINED_SYMBOL",
-	"ERR 32: ZLIB_UNDEFINED_DISTANCE_S",
-	"ERR 33: ZLIB_CODE_LENGTH_SYMBOL",
-	"ERR 34: ZLIB _VHB_ILLEGAL_FETCH",
-	"ERR 35: ZLIB_UNCOMPRESSED_LEN",
-	"ERR 36: ZLIB_LIMIT_REACHED",
-	"ERR 37: ZLIB_CHECKSUM_MISMATCH0",
-	"ERR 38: ODMA0_AXI_SLVERR",
-	"ERR 39: ODMA0_AXI_DECERR",
-	"ERR 40: 0x28 Reserved",
-	"ERR 41: ODMA1_AXI_SLVERR",
-	"ERR 42: ODMA1_AXI_DECERR",
-	"ERR 43: LSB_PARITY_ERR",
+ /* Human-readable error strings */
+#define CCP_MAX_ERROR_CODE	64
+ static char *ccp_error_codes[] =3D {
+ 	"",
+	"ILLEGAL_ENGINE",
+	"ILLEGAL_KEY_ID",
+	"ILLEGAL_FUNCTION_TYPE",
+	"ILLEGAL_FUNCTION_MODE",
+	"ILLEGAL_FUNCTION_ENCRYPT",
+	"ILLEGAL_FUNCTION_SIZE",
+	"Zlib_MISSING_INIT_EOM",
+	"ILLEGAL_FUNCTION_RSVD",
+	"ILLEGAL_BUFFER_LENGTH",
+	"VLSB_FAULT",
+	"ILLEGAL_MEM_ADDR",
+	"ILLEGAL_MEM_SEL",
+	"ILLEGAL_CONTEXT_ID",
+	"ILLEGAL_KEY_ADDR",
+	"0xF Reserved",
+	"Zlib_ILLEGAL_MULTI_QUEUE",
+	"Zlib_ILLEGAL_JOBID_CHANGE",
+	"CMD_TIMEOUT",
+	"IDMA0_AXI_SLVERR",
+	"IDMA0_AXI_DECERR",
+	"0x15 Reserved",
+	"IDMA1_AXI_SLAVE_FAULT",
+	"IDMA1_AIXI_DECERR",
+	"0x18 Reserved",
+	"ZLIBVHB_AXI_SLVERR",
+	"ZLIBVHB_AXI_DECERR",
+	"0x1B Reserved",
+	"ZLIB_UNEXPECTED_EOM",
+	"ZLIB_EXTRA_DATA",
+	"ZLIB_BTYPE",
+	"ZLIB_UNDEFINED_SYMBOL",
+	"ZLIB_UNDEFINED_DISTANCE_S",
+	"ZLIB_CODE_LENGTH_SYMBOL",
+	"ZLIB _VHB_ILLEGAL_FETCH",
+	"ZLIB_UNCOMPRESSED_LEN",
+	"ZLIB_LIMIT_REACHED",
+	"ZLIB_CHECKSUM_MISMATCH0",
+	"ODMA0_AXI_SLVERR",
+	"ODMA0_AXI_DECERR",
+	"0x28 Reserved",
+	"ODMA1_AXI_SLVERR",
+	"ODMA1_AXI_DECERR",
 };
=20
-void ccp_log_error(struct ccp_device *d, int e)
+void ccp_log_error(struct ccp_device *d, unsigned int e)
 {
-	dev_err(d->dev, "CCP error: %s (0x%x)\n", ccp_error_codes[e], e);
+	if (WARN_ON(e >=3D CCP_MAX_ERROR_CODE))
+		return;
+
+	if (e < ARRAY_SIZE(ccp_error_codes))
+		dev_err(d->dev, "CCP error %d: %s\n", e, ccp_error_codes[e]);
+	else
+		dev_err(d->dev, "CCP error %d: Unknown Error\n", e);
 }
=20
 /* List of CCPs, CCP count, read-write access lock, and access functions
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 347b77108baa..cfe21d033745 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -607,7 +607,7 @@ void ccp_platform_exit(void);
 void ccp_add_device(struct ccp_device *ccp);
 void ccp_del_device(struct ccp_device *ccp);
=20
-extern void ccp_log_error(struct ccp_device *, int);
+extern void ccp_log_error(struct ccp_device *, unsigned int);
=20
 struct ccp_device *ccp_alloc_struct(struct device *dev);
 bool ccp_queues_suspended(struct ccp_device *ccp);
--=20
2.17.1

