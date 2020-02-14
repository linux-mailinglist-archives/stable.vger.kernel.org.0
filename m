Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C5B15D689
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 12:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgBNLaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 06:30:06 -0500
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:55790
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728864AbgBNLaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 06:30:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYlPx2EJlS+eFPzXH/GjTzbnAYgcJOULirq8tZG5hfl1deYvvL/lmhzFvDI1dJfn/tkduVkNC9CKK6+6sUiLMFc/EVUPlCDrO1GUopV/W7rPOjVO46KIJFx0P6j+290ieNrTSCYwZUXlXdxJPqTsN/m/sC3MgGJ+aaVjedYGS/Ida0bnwtsHK2vB8xF7jM+uK9dBVwfKZ6CekNI8pDCA2cBUnSLkBjuLTdZpzcgSBzlpZTdjaDqDmzMnzfzb+PYkOsNZLPUf8fMFG8zuqF0/s3DXT/15+0jE9zE3qqj0cnx6It+G5DKP7ZyfF/YUAjoGo1LXnSQrLLSrYgaoqdFj4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoDoHWytFW8KlPewj6mRrwRzqpCXDyBvswbhIZGJ1fg=;
 b=IGaI7abQ9DB1uYfOB97Luvczq9ttor1QrkWA79LXUEhhHh1kuqSEwS/aGpdlcz7G3AR3qcXYcz008UDnTQHW1R7YthsYxAyDfiZI9Zj133xmUu6mXLjndkSOBGZNNzfyz/9YcRtMIouVYQ4fqku1aGU9szGKEGB3TKmKO9vNQRvnjFN45MALl7nzZ3eT6qUT6NBbKrVwauUi0pSeCgVq5tR+aINJ29h9QUXCJUPKlE2S2jSe8K8HnA6XMyCdkix8XkyBljtvygy9yGdVopbj6NxJBWmhz6WJBIOmqTAaZWUOVbqu6njW1Xp1tCencXVpQdZdnscYNPayWveTX+go9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoDoHWytFW8KlPewj6mRrwRzqpCXDyBvswbhIZGJ1fg=;
 b=EPYmTEpbPba9diviCqLcTMGlp4a6uVuwEQhFQnqmZhxMkbw8D5sjI5AHah9Xfn/Atcx3YrIqg5Dz/omchbFaTWstT4qm/NsFNdpehCFxTmbQn3Hjnp98u3kvXM9fhcnU8PiU0S4kR7sAMhV11VLK5B1KAI/lucxZx9mYAAaawxE=
Received: from MN2PR02MB5823.namprd02.prod.outlook.com (20.179.86.19) by
 MN2PR02MB5967.namprd02.prod.outlook.com (20.179.98.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Fri, 14 Feb 2020 11:30:02 +0000
Received: from MN2PR02MB5823.namprd02.prod.outlook.com
 ([fe80::c438:427c:f078:d336]) by MN2PR02MB5823.namprd02.prod.outlook.com
 ([fe80::c438:427c:f078:d336%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 11:30:02 +0000
From:   Sai Krishna Potthuri <lakshmis@xilinx.com>
To:     Joel Stanley <joel@jms.id.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: RE: [LINUX PATCH 2/7] Revert "jffs2: Fix possible null-pointer
 dereferences in jffs2_add_frag_to_fragtree()"
Thread-Topic: [LINUX PATCH 2/7] Revert "jffs2: Fix possible null-pointer
 dereferences in jffs2_add_frag_to_fragtree()"
Thread-Index: AQHV4ykCYMUnLZDDOUKF8LSJJcPVDqgajZXQ
Date:   Fri, 14 Feb 2020 11:30:02 +0000
Message-ID: <MN2PR02MB582351F8098EBF82A825A61DBD150@MN2PR02MB5823.namprd02.prod.outlook.com>
References: <1581679051-17534-1-git-send-email-lakshmi.sai.krishna.potthuri@xilinx.com>
 <1581679051-17534-3-git-send-email-lakshmi.sai.krishna.potthuri@xilinx.com>
In-Reply-To: <1581679051-17534-3-git-send-email-lakshmi.sai.krishna.potthuri@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lakshmis@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fa0f8648-9b54-4558-ae2a-08d7b1413b74
x-ms-traffictypediagnostic: MN2PR02MB5967:
x-microsoft-antispam-prvs: <MN2PR02MB59678FCEAD775B8FE9D36D40BD150@MN2PR02MB5967.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(376002)(346002)(366004)(136003)(396003)(189003)(199004)(478600001)(7696005)(8936002)(6506007)(81166006)(2906002)(186003)(53546011)(26005)(8676002)(110136005)(81156014)(86362001)(316002)(9686003)(71200400001)(76116006)(52536014)(66946007)(66556008)(33656002)(66446008)(64756008)(5660300002)(66476007)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB5967;H:MN2PR02MB5823.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rEmWqe9+kxpBDROxt/fwve170fWpZbSkEXDw/NWw/Qgb0s2Qy4UGT9ES36mcZcqZKNCXsof3lziXXYWKVqvd9938807GVKzCnrMQJJ28IEUDkDn1W8sxD+bHrxolIhB6LUlHd6XWsJhids3SRwsNHmFk6HF388fVybBLEqFzUOakolqFkY0C952b8XNYZGLX3/cwSWL6/NVo594tdw23vx2lULKP2OReThuyrWSPpGU1kmoIOsPjlt3BMdbhyzHeMkPHKYlbCdyWcDs65tjF0Gse64nno4v55vIgxs+8hH4XdGaTMXoynqiAIB85fGm1DpZF/40Sjjbt8csqyVX/aPfNV6gY1+TbPVKu79b4PI1LP66JSYnvPWkRzUvbMH9pvx3gZ74FeBEffnJsBtg6TbqKJa6wNFKbnvUjyPFlz8u4BSfS86nFnrSByZ0LitPp
x-ms-exchange-antispam-messagedata: n32gzAlXd9ihDm+w9gcCDr+lKOC0kIM7yXKZ8mLUdQdhAijHnUVYYh/8D4cmCkNS2IIcu4Gw0crmgWvrCROEQ5L04p8jkfJrQfNyeQtOFGrdISsgB+/NjbPIf+1Ag/8lNrBSY00zRSOkuqCKON+z6A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0f8648-9b54-4558-ae2a-08d7b1413b74
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 11:30:02.3838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fqle8jx1gNocKcZKG1PAUF+kdlu/sQZ4HFmRh5W6Y+kAKATOnnbV3WjI/TGX1R/ifxFlCbueVkdOQJulgZesNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB5967
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Sorry, Please ignore this.
I am pulling this patch for testing.

Regards
Sai Krishna

> -----Original Message-----
> From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
> Sent: Friday, February 14, 2020 4:47 PM
> To: git-dev <git-dev@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; Joel Stanley <joel@jms.id.au>;
> stable@vger.kernel.org; Richard Weinberger <richard@nod.at>; Sai Krishna
> Potthuri <lakshmis@xilinx.com>
> Subject: [LINUX PATCH 2/7] Revert "jffs2: Fix possible null-pointer deref=
erences
> in jffs2_add_frag_to_fragtree()"
>=20
> From: Joel Stanley <joel@jms.id.au>
>=20
> This reverts commit f2538f999345405f7d2e1194c0c8efa4e11f7b3a. The patch
> stopped JFFS2 from being able to mount an existing filesystem with the
> following errors:
>=20
>  jffs2: error: (77) jffs2_build_inode_fragtree: Add node to tree failed -=
22
>  jffs2: error: (77) jffs2_do_read_inode_internal: Failed to build final f=
ragtree for
> inode #5377: error -22
>=20
> Fixes: f2538f999345 ("jffs2: Fix possible null-pointer dereferences...")
> Cc: stable@vger.kernel.org
> Suggested-by: Hou Tao <houtao1@huawei.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.=
com>
> ---
>  fs/jffs2/nodelist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/jffs2/nodelist.c b/fs/jffs2/nodelist.c index
> 021a4a2190ee..b86c78d178c6 100644
> --- a/fs/jffs2/nodelist.c
> +++ b/fs/jffs2/nodelist.c
> @@ -226,7 +226,7 @@ static int jffs2_add_frag_to_fragtree(struct
> jffs2_sb_info *c, struct rb_root *r
>  		lastend =3D this->ofs + this->size;
>  	} else {
>  		dbg_fragtree2("lookup gave no frag\n");
> -		return -EINVAL;
> +		lastend =3D 0;
>  	}
>=20
>  	/* See if we ran off the end of the fragtree */
> --
> 2.17.1

