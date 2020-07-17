Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1BD2231FD
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 06:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGQEON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 00:14:13 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:43494
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbgGQEOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 00:14:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUCt4T2mAOJqq2nfGGNwbxcTbsrT6ysf7LbpavEwbM764ZPgc0EE+52pLTwP7eyTLAtpnu3jUhB/sQOtN6QYI3oWIDtABBORg2+eIEvIkGXvCqnPbldtcq6jPruZmMDjBHZ7kWKRX2Z4NzqLuqszy1Lqg8GOmGhNYmNmCZSlXmAu6iGfTXr6o78Ke6yzmffwvXGSJ98cUr9OcvcFu89+wdDL1y4GyTacumUQYGyDNM5Qe0VQpDZdzq9zG1BKYnFYHLqQZlBoRrBORfYYNXxeBwbVUGJYiCNAlBNWjE5E+uTKPqtkF75UWWrzyeyKAnT8SKJIIny8/y8etwfVbd9Aag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxpFHtKNxGl+Ban9K+4fwV1n0rAVWCY6OTdfvh8zQ3M=;
 b=bJ9N0KuAHcKJM3qpKCz78PH1wlW/bYDq341PbBRtcJH3As2BiNs/LEWIJngYIf3S0TQblF0uNkiA6dF05iHkjCY6FenI4JBZdCzCUvUSX1wwY2rueDEttIghW8uhbwy0j0VgV4PRu4RercvttQeNs6yHQmMSg575AJjth30iqesdNSWdzwKwftPvTUaqmj+aJMZP5/z+AtISz+P+rIBxSciZCLejSat97oP5gvFaEEZzeoiIBQYgCDNXTuhc7aIRWijB7/lIQOvS1JkrijDR24pdD4l6JDGUmbq/7+3KaNcIvk0qRs81CblzJXQJnGh60kHdJF3gibX85H1Rtaohkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxpFHtKNxGl+Ban9K+4fwV1n0rAVWCY6OTdfvh8zQ3M=;
 b=r78Omc047T91+GjHMk0I6KqQKHRRJgjY0gjiQ6AdKuSYdc76IGknYR335dJPkmWdPHa5HIRvbGHh1rS0XI3Pj8t4l+uqHXB786dzuLufcZmDy9N0OltWf/ZZSe0T0RnzAVdWtQXp3PE0B96YPq5mZicYC8UJ5a4YYit7P5tqeVo=
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM6PR04MB4632.eurprd04.prod.outlook.com (2603:10a6:20b:1a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 17 Jul
 2020 04:14:08 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3174.026; Fri, 17 Jul 2020
 04:14:08 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: configfs: Fix use-after-free issue with
 udc_name
Thread-Topic: [PATCH] usb: gadget: configfs: Fix use-after-free issue with
 udc_name
Thread-Index: AQHWWzwrDCeJbXR+QUOUa8VdThQTA6kLKvMA
Date:   Fri, 17 Jul 2020 04:14:08 +0000
Message-ID: <20200717041406.GC17070@b29397-desktop>
References: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
In-Reply-To: <1594881666-8843-1-git-send-email-macpaul.lin@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56b7e20d-a623-476a-fff8-08d82a07da5f
x-ms-traffictypediagnostic: AM6PR04MB4632:
x-microsoft-antispam-prvs: <AM6PR04MB46321E525F2ED130F5A40D3D8B7C0@AM6PR04MB4632.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:411;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T4b3+In0q3SxzoKxmnvtGDqRzsyDNapfZ8xY7NyZKh+ofjgB1AiDZmn94McV/k0mWb/5/Y3md6jZmEtPVpc2UGg9z5kVVRzR48ZjLhlS7tpprfTSF2jQ/4yjqxxzyCWN3kJxsoYMt6XVcWCfzwx98GqoowIf/QNdY4focTLwpeP6XXOetg0vVCU0zdHsKshMd6bDQmQn0TduQr8QHQdnuiRpzoTsBZJmThX16xXFy0NhJzASTNjV8MdJz10b/NO1aKINnWFIIv4fOTkDsN54DbqIUIh1DiA4Dr0Of6Id45uGGkrg/AS7ZooMbFTQ0qQvhJY1hMHGYEr63Gq1SEbVsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(136003)(396003)(366004)(346002)(376002)(39860400002)(6512007)(9686003)(8676002)(54906003)(5660300002)(478600001)(4326008)(44832011)(2906002)(6506007)(53546011)(26005)(186003)(66946007)(76116006)(1076003)(33656002)(6486002)(316002)(83380400001)(71200400001)(66476007)(8936002)(64756008)(91956017)(66446008)(33716001)(66556008)(86362001)(7416002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZBYrE0DjpM76uSm/mNc9ASz02BcknLvn9y2ZOhxrwkphpSxYWe/hyODG0kUWTpB9D8EsZQMdZC0jneM1IZSpcz0hTNXT2cDoPzfRIFhWnNqePwiZZh3PNerY1qdiVmGaqIybjdzmNQfq8M3wvSb0pjRWCFpI7zIchDvxR+UL2M4RmqudgY5Jww9k7Lr01KkTALfyOlSOHgALTihCXlIlZoyKdUi/EmXvXgmNa7dJcVRncQemPggJmc95dISMaRkPqC3Kcq3RmlC6bbMfPcff/Sp92WwQSiM/5e4LD+d/yCWlkFDFn/s78lFgGF6g2PhsyCH1Xf0450L1B+RMEA0m5395Xi5stMFZRVbUjhg/V0Bu5MI5DeHRM0y+LCCwh4AxZCTTCfqzkcGe7lLTlvq0qch83+xKK7REdvi2/Qe+8bZzSbcfPru0UZOUJCS1xxbCjwXEMZk6/ip+/GjvWjROLLkCrQxUeHWThXBMEEuhw0w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D34A2AF1CF166648B0A3C3B04631F398@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7157.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b7e20d-a623-476a-fff8-08d82a07da5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 04:14:08.8373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /z53Y/NZnovCg2sec/u8C2zD/Op7ZRqBMlklTVMsPoDKMoyY7q/fjOqxqA7QASlWYvRLHPDVgwk7r0gg+D9JfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4632
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-07-16 14:41:06, Macpaul Lin wrote:
> There is a use-after-free issue, if access udc_name
> in function gadget_dev_desc_UDC_store after another context
> free udc_name in function unregister_gadget.
>=20
> Contex 1:

%s/contex/context

> gadget_dev_desc_UDC_store()->unregister_gadget()->
> free udc_name->set udc_name to NULL
>=20
> Contex 2:

The same, otherwise:

Reviewed-by: Peter Chen <peter.chen@nxp.com>

Peter

> gadget_dev_desc_UDC_show()-> access udc_name
>=20
> Call trace:
> dump_backtrace+0x0/0x340
> show_stack+0x14/0x1c
> dump_stack+0xe4/0x134
> print_address_description+0x78/0x478
> __kasan_report+0x270/0x2ec
> kasan_report+0x10/0x18
> __asan_report_load1_noabort+0x18/0x20
> string+0xf4/0x138
> vsnprintf+0x428/0x14d0
> sprintf+0xe4/0x12c
> gadget_dev_desc_UDC_show+0x54/0x64
> configfs_read_file+0x210/0x3a0
> __vfs_read+0xf0/0x49c
> vfs_read+0x130/0x2b4
> SyS_read+0x114/0x208
> el0_svc_naked+0x34/0x38
>=20
> Add mutex_lock to protect this kind of scenario.

>=20
> Signed-off-by: Eddie Hung <eddie.hung@mediatek.com>
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/usb/gadget/configfs.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.=
c
> index 9dc06a4e1b30..21110b2865b9 100644
> --- a/drivers/usb/gadget/configfs.c
> +++ b/drivers/usb/gadget/configfs.c
> @@ -221,9 +221,16 @@ static ssize_t gadget_dev_desc_bcdUSB_store(struct c=
onfig_item *item,
> =20
>  static ssize_t gadget_dev_desc_UDC_show(struct config_item *item, char *=
page)
>  {
> -	char *udc_name =3D to_gadget_info(item)->composite.gadget_driver.udc_na=
me;
> +	struct gadget_info *gi =3D to_gadget_info(item);
> +	char *udc_name;
> +	int ret;
> +
> +	mutex_lock(&gi->lock);
> +	udc_name =3D gi->composite.gadget_driver.udc_name;
> +	ret =3D sprintf(page, "%s\n", udc_name ?: "");
> +	mutex_unlock(&gi->lock);
> =20
> -	return sprintf(page, "%s\n", udc_name ?: "");
> +	return ret;
>  }
> =20
>  static int unregister_gadget(struct gadget_info *gi)
> --=20
> 2.18.0

--=20

Thanks,
Peter Chen=
