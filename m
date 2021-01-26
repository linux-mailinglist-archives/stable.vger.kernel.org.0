Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D8304C20
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbhAZWBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:01:06 -0500
Received: from mail-co1nam11on2128.outbound.protection.outlook.com ([40.107.220.128]:43584
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728712AbhAZUrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 15:47:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OE2544hGaELuMV+IQpggP0L0mwbjTRTjooxDfT8Em3eQ0AaKG/xuyz4dPnWPStTNK2ZtFJdUkuc9y4pm2kaSUSQ7bxXIqQ/WwxHwgHn/mgq2UU/VuooHLxDqUJn/Wx9oZ8tQFAcECNXOi+XN76m8Ns1TXdUCgFmNV0gg+06kS1VaL4nmAbBdd8+mAVBLSerh+B+3maeNf/nl2M23xU7zohDPdxBCkWoFCYSWKy16TghBjbE1nkj++PeShFTomm2W/clknJIElGF3oCnk2S5WtxJpj0GAzCjc5pWYhf8UQ3VxBZ1mh+V/FmAnubJOlMd8s8Mpk38w3DULVb4zAdfrfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dtEHMx2fIN+VpeqT2n7pvyUcK3rYeiuV6cuqlNeuJZI=;
 b=Y75BAlpe6HGxwpZXmExHU52e6mUJKIRNKgNFtqQ5S4qGlxnGrbhUcsuSandzqGaLry5NY7qovrdKhtPezWDU1Mq2FgpJHbTexvJ+RBs1NHcmxDluzAP10bljxbKGRoKVmILUS7ASPuLqoUF2kUXAHISiW1ToASPC1pBblKEsUYEklWJNkxzz+WVaH6tzDlbvMsGoUugHpiNKJ9we/GahYXAvE4KQd6ZaXHiPG6rbsyKtzeTET+pMe1LQQ15pv4Vddphg3OgjyMzrbrWrs1PwB1cL2cA3k5QOqBJk+iaem1kyOmRaHxZtxTUJtmRFm+u0CWlVeozgBmKuwYRmZJZdqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dtEHMx2fIN+VpeqT2n7pvyUcK3rYeiuV6cuqlNeuJZI=;
 b=EzbuJLbHbY5iouPjJaELbgL/73ZwwgwVAzgyCEBae52SJ4imeh/0gR/wBjg/ZThumO4UMDWA5RqH0sf9hPkE5Y+7F2CgxzZDihpI/viET4lVP5oCMP1T9h+SuUA36twPs+wdZPcI33VIuVnkHKhYR9EzIjiixxYUq+XnBQD+N1U=
Received: from (2603:10b6:805:4::27) by
 SA0PR21MB1899.namprd21.prod.outlook.com (2603:10b6:806:e1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.3; Tue, 26 Jan 2021 20:46:11 +0000
Received: from SN6PR2101MB0974.namprd21.prod.outlook.com
 ([fe80::79ec:7ff0:9f3b:7513]) by SN6PR2101MB0974.namprd21.prod.outlook.com
 ([fe80::79ec:7ff0:9f3b:7513%6]) with mapi id 15.20.3784.003; Tue, 26 Jan 2021
 20:46:11 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Steven French <Steven.French@microsoft.com>,
        Shyam Prasad <Shyam.Prasad@microsoft.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXTERNAL] FAILED: patch "[PATCH] SMB3.1.1: do not log warning
 message if server doesn't" failed to apply to 5.4-stable tree
Thread-Topic: [EXTERNAL] FAILED: patch "[PATCH] SMB3.1.1: do not log warning
 message if server doesn't" failed to apply to 5.4-stable tree
Thread-Index: AQHW3PyGmg9uBfPX+kKwfY/aU0hLwKo6jhaw
Date:   Tue, 26 Jan 2021 20:46:11 +0000
Message-ID: <SN6PR2101MB0974ADC3551085BD9DBDAD80B6BC9@SN6PR2101MB0974.namprd21.prod.outlook.com>
References: <1609148098104221@kroah.com>
In-Reply-To: <1609148098104221@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0a29d736-6d2c-4eb7-bad8-db1728b88fdd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-26T20:44:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [174.21.175.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d29663a3-be4d-4bc6-2d08-08d8c23b6a34
x-ms-traffictypediagnostic: SA0PR21MB1899:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR21MB18993925A217199F8077C1D0B6BC9@SA0PR21MB1899.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lwEceW2wpyu5pVSY4rE+ong7KCukW4LdnkMqdHJEgVH3WptoOUyEwoZ0wxnyNNrchZj0IB++achzAge87zyfu9TCAwzqIzTUuYyjY/W/Mca+TA0ipytygpIIO39w7legZVytz6J1TlajqVsW311a9RENDk9CVjN3QwzYnXTBZXKpu+xU5Sw4734EYW3fDZuugxhZ6vEZgAxVbTIcfSbJK9N0y8Ra15wuGBbf6JOdwEoTbrukohlVAjE0zEEj7tkO96yYCtnrqYp+ErL8+5IyQg0qYwiHUZ452W0v7QTlfPGcTOSyEoNp5k1u0ftCaiJXOge/SwY++jWZnYt6PpocyTjPSzvWjOqMRTnZ2sX90CJaHuIJkxHkPK5hguJ3jkXUBjalnatfbJTKBEYlCswxETr8G/XqQ/L/04c2ksCVe2JqQN9VaqIAglXFG9KDsV0Ig+HG/3glpjlfHpl4YxFk2Lc57U0IiXr7DSus13s7fHssjg9vE8mvSdgf8zAG1/gXynlDDpadalxiZhq9x3ctrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB0974.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(8936002)(15650500001)(7696005)(10290500003)(66616009)(2906002)(82960400001)(110136005)(83380400001)(66476007)(33656002)(316002)(52536014)(99936003)(186003)(71200400001)(64756008)(26005)(6506007)(478600001)(5660300002)(8990500004)(66946007)(82950400001)(8676002)(66446008)(55016002)(9686003)(86362001)(66556008)(53546011)(4326008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YbrVSdsmD27nsU5fD441oixNfSgCOsfiswWU0CtmfOlrgMJMmC6BqWx9EKot?=
 =?us-ascii?Q?EYPjbrnaTViKoyoACbKtT63MDvgR//6b4W1IUFrMopNTPr+TiOQZRny+zdhU?=
 =?us-ascii?Q?4KlFG/N5vYRRRtyFdx4NDdpm5SnKp+wdAcmshsEjkSD03R57Kl6NH5IvNJfB?=
 =?us-ascii?Q?PI13lIM5/Xc8WY/Yp/rOW3GIIEuY34fNsUuvO6AoRSg0wGNbSexG2vYNgUFa?=
 =?us-ascii?Q?4Qf/NhPWivdssFzb/9YMX8Jth2X4g+hpbu/qigp928kiNCv/HqokfcTN3ztk?=
 =?us-ascii?Q?IgTXAR2G51BddMODPcMSrJOwlf6bloKKB+fBO1j9GH9z5kyVhqD9BOejhlYe?=
 =?us-ascii?Q?rjsfOJeu5rIrp7QeH+27vyRrHHk/eSznfGbooOCTN9V26u+JiW2QrBZI3lsL?=
 =?us-ascii?Q?7o9ByXwLHnpgIs0Dom1mgQrUQcQVkJoa72iyq3BO5XJMAVkeH1dE3PArZt8G?=
 =?us-ascii?Q?S1F7dbuU96q+bgpJbxfATCiA3afzHruzXpYJuCuOdSQqQEwg7Y2R+mdkOWE5?=
 =?us-ascii?Q?03/dvyDB/jTgrzbJURYFCuvdV8J16tbvfeNfjnMjLfqNfnq1vyURyRFhGSRO?=
 =?us-ascii?Q?Nu1lhQqG7znDBayTJxy2JQzl2Hga3oyiPSePArpI3lgDnyr05yfY3X58P+ga?=
 =?us-ascii?Q?t8UtZ6ywfEiOeLeDenFBCaHzR/tsoeh3Jpg1NRpeY6XrSoiH/gvmpCMHkqvy?=
 =?us-ascii?Q?3UAVn6hV1EGe8n7eqiOlyI4zFQ0gdo3Ua3nP/IIJyXMbjYT0mAbabEqEM7fN?=
 =?us-ascii?Q?psqyFXQ85/p+3brERc/4jx8z83RDfwOmEDMaTXsbecxOZPEWMWfNc1+qOjjo?=
 =?us-ascii?Q?rA2zL3nwTjkiJHUpk/yY8X5ODcnYiwV2YD3VViFaub1uktMwYm8LrIIJdJoT?=
 =?us-ascii?Q?8sqG6pwBf+zxOHAC/1/UL3dlSmsQHr/Mxr4yIodtM8rGjoJTepyx9FG5Pz1K?=
 =?us-ascii?Q?jgeCQRjZ5rxXCJ4+uk7kgXUMbtxg0ulunrC9hsgkfX+KRlMClsg3yUyqiwfE?=
 =?us-ascii?Q?vQVG6f//dVWuY5r3OalWmz7hQN8dD3k8bxTYQ5QJoKlZj7YfiNee866Yxhra?=
 =?us-ascii?Q?ZSUOuSTT?=
Content-Type: multipart/mixed;
        boundary="_002_SN6PR2101MB0974ADC3551085BD9DBDAD80B6BC9SN6PR2101MB0974_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB0974.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29663a3-be4d-4bc6-2d08-08d8c23b6a34
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 20:46:11.2509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hGFpi7n9TNtHsKFYzaImFcXcHvhAhGV1IuPBqtcawfrDa2Y8/DKdDJ/NZRawsiE8JSNZuBnJQP83Tdi5bniSqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1899
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_SN6PR2101MB0974ADC3551085BD9DBDAD80B6BC9SN6PR2101MB0974_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Please find the backported version of the patch for the 5.4-stable tree in =
attachments.

Best regards,
Pavel Shilovsky

-----Original Message-----
From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>=20
Sent: Monday, December 28, 2020 1:35 AM
To: Steven French <Steven.French@microsoft.com>; Pavel Shilovskiy <pshilov@=
microsoft.com>; Shyam Prasad <Shyam.Prasad@microsoft.com>; stable@vger.kern=
el.org
Cc: stable@vger.kernel.org
Subject: [EXTERNAL] FAILED: patch "[PATCH] SMB3.1.1: do not log warning mes=
sage if server doesn't" failed to apply to 5.4-stable tree


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm tree,=
 then please email the backport, including the original git commit id to <s=
table@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7955f105afb6034af344038d663bc98809483cdd Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Wed, 9 Dec 2020 22:19:00 -0600
Subject: [PATCH] SMB3.1.1: do not log warning message if server doesn't  po=
pulate salt

In the negotiate protocol preauth context, the server is not required to po=
pulate the salt (although it is done by most servers) so do not warn on mou=
nt.

We retain the checks (warn) that the preauth context is the minimum size an=
d that the salt does not exceed DataLength of the SMB response.
Although we use the defaults in the case that the preauth context response =
is invalid, these checks may be useful in the future as servers add support=
 for additional mechanisms.

CC: Stable <stable@vger.kernel.org>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index acb72705062d..fc06=
c762fbbf 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -427,8 +427,8 @@ build_preauth_ctxt(struct smb2_preauth_neg_context *pne=
g_ctxt)
 	pneg_ctxt->ContextType =3D SMB2_PREAUTH_INTEGRITY_CAPABILITIES;
 	pneg_ctxt->DataLength =3D cpu_to_le16(38);
 	pneg_ctxt->HashAlgorithmCount =3D cpu_to_le16(1);
-	pneg_ctxt->SaltLength =3D cpu_to_le16(SMB311_SALT_SIZE);
-	get_random_bytes(pneg_ctxt->Salt, SMB311_SALT_SIZE);
+	pneg_ctxt->SaltLength =3D cpu_to_le16(SMB311_LINUX_CLIENT_SALT_SIZE);
+	get_random_bytes(pneg_ctxt->Salt, SMB311_LINUX_CLIENT_SALT_SIZE);
 	pneg_ctxt->HashAlgorithms =3D SMB2_PREAUTH_INTEGRITY_SHA512;  }
=20
@@ -566,6 +566,9 @@ static void decode_preauth_context(struct smb2_preauth_=
neg_context *ctxt)
 	if (len < MIN_PREAUTH_CTXT_DATA_LEN) {
 		pr_warn_once("server sent bad preauth context\n");
 		return;
+	} else if (len < MIN_PREAUTH_CTXT_DATA_LEN + le16_to_cpu(ctxt->SaltLength=
)) {
+		pr_warn_once("server sent invalid SaltLength\n");
+		return;
 	}
 	if (le16_to_cpu(ctxt->HashAlgorithmCount) !=3D 1)
 		pr_warn_once("Invalid SMB3 hash algorithm count\n"); diff --git a/fs/cif=
s/smb2pdu.h b/fs/cifs/smb2pdu.h index fa57b03ca98c..204a622b89ed 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -333,12 +333,20 @@ struct smb2_neg_context {
 	/* Followed by array of data */
 } __packed;
=20
-#define SMB311_SALT_SIZE			32
+#define SMB311_LINUX_CLIENT_SALT_SIZE			32
 /* Hash Algorithm Types */
 #define SMB2_PREAUTH_INTEGRITY_SHA512	cpu_to_le16(0x0001)
 #define SMB2_PREAUTH_HASH_SIZE 64
=20
-#define MIN_PREAUTH_CTXT_DATA_LEN	(SMB311_SALT_SIZE + 6)
+/*
+ * SaltLength that the server send can be zero, so the only three=20
+required
+ * fields (all __le16) end up six bytes total, so the minimum context=20
+data len
+ * in the response is six bytes which accounts for
+ *
+ *      HashAlgorithmCount, SaltLength, and 1 HashAlgorithm.
+ */
+#define MIN_PREAUTH_CTXT_DATA_LEN 6
+
 struct smb2_preauth_neg_context {
 	__le16	ContextType; /* 1 */
 	__le16	DataLength;
@@ -346,7 +354,7 @@ struct smb2_preauth_neg_context {
 	__le16	HashAlgorithmCount; /* 1 */
 	__le16	SaltLength;
 	__le16	HashAlgorithms; /* HashAlgorithms[0] since only one defined */
-	__u8	Salt[SMB311_SALT_SIZE];
+	__u8	Salt[SMB311_LINUX_CLIENT_SALT_SIZE];
 } __packed;
=20
 /* Encryption Algorithms Ciphers */


--_002_SN6PR2101MB0974ADC3551085BD9DBDAD80B6BC9SN6PR2101MB0974_
Content-Type: application/octet-stream;
	name="0001-SMB3.1.1-do-not-log-warning-message-if-server-doesn-.patch"
Content-Description:
 0001-SMB3.1.1-do-not-log-warning-message-if-server-doesn-.patch
Content-Disposition: attachment;
	filename="0001-SMB3.1.1-do-not-log-warning-message-if-server-doesn-.patch";
	size=3576; creation-date="Tue, 26 Jan 2021 20:45:00 GMT";
	modification-date="Tue, 26 Jan 2021 20:46:11 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1Yjg1MjZhMmI0YTlkNzgwYTk3MDFjZmQyNjMxZmVkMWI0OWRlYjAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgOSBEZWMgMjAyMCAyMjoxOTowMCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjMuMS4xOiBkbyBub3QgbG9nIHdhcm5pbmcgbWVzc2FnZSBpZiBzZXJ2ZXIgZG9lc24ndAogcG9w
dWxhdGUgc2FsdAoKQ29tbWl0IDc5NTVmMTA1YWZiNjAzNGFmMzQ0MDM4ZDY2M2JjOTg4MDk0ODNj
ZGQgKCJTTUIzLjEuMTogZG8gbm90IGxvZwp3YXJuaW5nIG1lc3NhZ2UgaWYgc2VydmVyIGRvZXNu
J3QgcG9wdWxhdGUgc2FsdCIpIHVwc3RyZWFtLgoKSW4gdGhlIG5lZ290aWF0ZSBwcm90b2NvbCBw
cmVhdXRoIGNvbnRleHQsIHRoZSBzZXJ2ZXIgaXMgbm90IHJlcXVpcmVkCnRvIHBvcHVsYXRlIHRo
ZSBzYWx0IChhbHRob3VnaCBpdCBpcyBkb25lIGJ5IG1vc3Qgc2VydmVycykgc28gZG8Kbm90IHdh
cm4gb24gbW91bnQuCgpXZSByZXRhaW4gdGhlIGNoZWNrcyAod2FybikgdGhhdCB0aGUgcHJlYXV0
aCBjb250ZXh0IGlzIHRoZSBtaW5pbXVtCnNpemUgYW5kIHRoYXQgdGhlIHNhbHQgZG9lcyBub3Qg
ZXhjZWVkIERhdGFMZW5ndGggb2YgdGhlIFNNQiByZXNwb25zZS4KQWx0aG91Z2ggd2UgdXNlIHRo
ZSBkZWZhdWx0cyBpbiB0aGUgY2FzZSB0aGF0IHRoZSBwcmVhdXRoIGNvbnRleHQKcmVzcG9uc2Ug
aXMgaW52YWxpZCwgdGhlc2UgY2hlY2tzIG1heSBiZSB1c2VmdWwgaW4gdGhlIGZ1dHVyZQphcyBz
ZXJ2ZXJzIGFkZCBzdXBwb3J0IGZvciBhZGRpdGlvbmFsIG1lY2hhbmlzbXMuCgpDQzogU3RhYmxl
IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIHY1LjQueApSZXZpZXdlZC1ieTogU2h5YW0gUHJh
c2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFBhdmVsIFNoaWxvdnNr
eSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0
ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCAgNyArKysrKy0t
CiBmcy9jaWZzL3NtYjJwZHUuaCB8IDE0ICsrKysrKysrKysrLS0tCiAyIGZpbGVzIGNoYW5nZWQs
IDE2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9z
bWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCBiZTA2YjI2ZDZjYTAzLi43YWRlY2Zk
MGMxZTk5IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJw
ZHUuYwpAQCAtNDkwLDggKzQ5MCw4IEBAIGJ1aWxkX3ByZWF1dGhfY3R4dChzdHJ1Y3Qgc21iMl9w
cmVhdXRoX25lZ19jb250ZXh0ICpwbmVnX2N0eHQpCiAJcG5lZ19jdHh0LT5Db250ZXh0VHlwZSA9
IFNNQjJfUFJFQVVUSF9JTlRFR1JJVFlfQ0FQQUJJTElUSUVTOwogCXBuZWdfY3R4dC0+RGF0YUxl
bmd0aCA9IGNwdV90b19sZTE2KDM4KTsKIAlwbmVnX2N0eHQtPkhhc2hBbGdvcml0aG1Db3VudCA9
IGNwdV90b19sZTE2KDEpOwotCXBuZWdfY3R4dC0+U2FsdExlbmd0aCA9IGNwdV90b19sZTE2KFNN
QjMxMV9TQUxUX1NJWkUpOwotCWdldF9yYW5kb21fYnl0ZXMocG5lZ19jdHh0LT5TYWx0LCBTTUIz
MTFfU0FMVF9TSVpFKTsKKwlwbmVnX2N0eHQtPlNhbHRMZW5ndGggPSBjcHVfdG9fbGUxNihTTUIz
MTFfTElOVVhfQ0xJRU5UX1NBTFRfU0laRSk7CisJZ2V0X3JhbmRvbV9ieXRlcyhwbmVnX2N0eHQt
PlNhbHQsIFNNQjMxMV9MSU5VWF9DTElFTlRfU0FMVF9TSVpFKTsKIAlwbmVnX2N0eHQtPkhhc2hB
bGdvcml0aG1zID0gU01CMl9QUkVBVVRIX0lOVEVHUklUWV9TSEE1MTI7CiB9CiAKQEAgLTYxNyw2
ICs2MTcsOSBAQCBzdGF0aWMgdm9pZCBkZWNvZGVfcHJlYXV0aF9jb250ZXh0KHN0cnVjdCBzbWIy
X3ByZWF1dGhfbmVnX2NvbnRleHQgKmN0eHQpCiAJaWYgKGxlbiA8IE1JTl9QUkVBVVRIX0NUWFRf
REFUQV9MRU4pIHsKIAkJcHJpbnRrX29uY2UoS0VSTl9XQVJOSU5HICJzZXJ2ZXIgc2VudCBiYWQg
cHJlYXV0aCBjb250ZXh0XG4iKTsKIAkJcmV0dXJuOworCX0gZWxzZSBpZiAobGVuIDwgTUlOX1BS
RUFVVEhfQ1RYVF9EQVRBX0xFTiArIGxlMTZfdG9fY3B1KGN0eHQtPlNhbHRMZW5ndGgpKSB7CisJ
CXByX3dhcm5fb25jZSgic2VydmVyIHNlbnQgaW52YWxpZCBTYWx0TGVuZ3RoXG4iKTsKKwkJcmV0
dXJuOwogCX0KIAlpZiAobGUxNl90b19jcHUoY3R4dC0+SGFzaEFsZ29yaXRobUNvdW50KSAhPSAx
KQogCQlwcmludGtfb25jZShLRVJOX1dBUk5JTkcgImlsbGVnYWwgU01CMyBoYXNoIGFsZ29yaXRo
bSBjb3VudFxuIik7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21i
MnBkdS5oCmluZGV4IGYyNjRlMWQzNmZlMTYuLjI0ODI5NzhmMDk0ODYgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvc21iMnBkdS5oCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5oCkBAIC0yNzEsMTIgKzI3MSwy
MCBAQCBzdHJ1Y3Qgc21iMl9uZWdfY29udGV4dCB7CiAJLyogRm9sbG93ZWQgYnkgYXJyYXkgb2Yg
ZGF0YSAqLwogfSBfX3BhY2tlZDsKIAotI2RlZmluZSBTTUIzMTFfU0FMVF9TSVpFCQkJMzIKKyNk
ZWZpbmUgU01CMzExX0xJTlVYX0NMSUVOVF9TQUxUX1NJWkUJCQkzMgogLyogSGFzaCBBbGdvcml0
aG0gVHlwZXMgKi8KICNkZWZpbmUgU01CMl9QUkVBVVRIX0lOVEVHUklUWV9TSEE1MTIJY3B1X3Rv
X2xlMTYoMHgwMDAxKQogI2RlZmluZSBTTUIyX1BSRUFVVEhfSEFTSF9TSVpFIDY0CiAKLSNkZWZp
bmUgTUlOX1BSRUFVVEhfQ1RYVF9EQVRBX0xFTgkoU01CMzExX1NBTFRfU0laRSArIDYpCisvKgor
ICogU2FsdExlbmd0aCB0aGF0IHRoZSBzZXJ2ZXIgc2VuZCBjYW4gYmUgemVybywgc28gdGhlIG9u
bHkgdGhyZWUgcmVxdWlyZWQKKyAqIGZpZWxkcyAoYWxsIF9fbGUxNikgZW5kIHVwIHNpeCBieXRl
cyB0b3RhbCwgc28gdGhlIG1pbmltdW0gY29udGV4dCBkYXRhIGxlbgorICogaW4gdGhlIHJlc3Bv
bnNlIGlzIHNpeCBieXRlcyB3aGljaCBhY2NvdW50cyBmb3IKKyAqCisgKiAgICAgIEhhc2hBbGdv
cml0aG1Db3VudCwgU2FsdExlbmd0aCwgYW5kIDEgSGFzaEFsZ29yaXRobS4KKyAqLworI2RlZmlu
ZSBNSU5fUFJFQVVUSF9DVFhUX0RBVEFfTEVOIDYKKwogc3RydWN0IHNtYjJfcHJlYXV0aF9uZWdf
Y29udGV4dCB7CiAJX19sZTE2CUNvbnRleHRUeXBlOyAvKiAxICovCiAJX19sZTE2CURhdGFMZW5n
dGg7CkBAIC0yODQsNyArMjkyLDcgQEAgc3RydWN0IHNtYjJfcHJlYXV0aF9uZWdfY29udGV4dCB7
CiAJX19sZTE2CUhhc2hBbGdvcml0aG1Db3VudDsgLyogMSAqLwogCV9fbGUxNglTYWx0TGVuZ3Ro
OwogCV9fbGUxNglIYXNoQWxnb3JpdGhtczsgLyogSGFzaEFsZ29yaXRobXNbMF0gc2luY2Ugb25s
eSBvbmUgZGVmaW5lZCAqLwotCV9fdTgJU2FsdFtTTUIzMTFfU0FMVF9TSVpFXTsKKwlfX3U4CVNh
bHRbU01CMzExX0xJTlVYX0NMSUVOVF9TQUxUX1NJWkVdOwogfSBfX3BhY2tlZDsKIAogLyogRW5j
cnlwdGlvbiBBbGdvcml0aG1zIENpcGhlcnMgKi8KLS0gCjIuMjUuMQoK

--_002_SN6PR2101MB0974ADC3551085BD9DBDAD80B6BC9SN6PR2101MB0974_--
