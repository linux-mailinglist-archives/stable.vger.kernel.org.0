Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8256311C212
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 02:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLLBUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 20:20:31 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:37834 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfLLBUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 20:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576113631; x=1607649631;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=grSQM9vSaTAtMRJoF4Z8/t4WTRhPtxt2XVPx6n0C2D4=;
  b=XFyu0Q6y6QVIO1RvBpr/rEMLteoz08Qpxtr2yi5KzGKyvwHSfZVNMu6M
   Y6xhJKz3Gj3IGvNdeV5LDUdxArh5q9OMgBesJz63azwM/+DOy2l2M7Dh/
   s+3MBXIFZl9MgLbCzs4AQUQg6YNaSieFtN4Q1OpwToxKv0ZPmeaaP9l5t
   x9Y83n0dIGMYk9Nu5c2p3ZOYN7DxwOrPJztlo/ZCEkqms15P9ZxYfZGm5
   ChsgzJF27DbsXjXbk0y70kkOaaz6pPYYwreD2MTF7e2CG3HuDKs7LskPn
   p7uK9sI6OOBKUchK5nF2Pus15WuCOiOspqWWOcNqSjDxXUS5s0u+JrtRZ
   A==;
IronPort-SDR: c2Oaoef9h6h2mHlG/I5kPmq8U3hEqZN/IXsTNqE5sia8JtvbXMmt4bm5ps5fTQm1N+MsPYwq7S
 2FH//WRB/zg3+JBQHU9+4ygcNv2YFPbTL3GSps2Bw+navZGBCooHIM4nOkpzAuW02Yb7pWLjHY
 xjycsbeEsEpuOnLr9QnauKKd/l8XdYNmyQhvpFrBhkusD+3EjwEx7bKh8V3UxpacfY+sIUz9Ed
 w4NpcGTxEm8IxoljXBmPK6YmcIH+ddSJpv2Q7QqtJF4kDc8p/itpMOYjaYKzcPE6g9t2exq7YV
 e3Y=
X-IronPort-AV: E=Sophos;i="5.69,303,1571673600"; 
   d="scan'208";a="232700932"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2019 09:20:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFp/Okvj0fydflLl6HFQPGKTnXJplltooz+PTcY/LDcIGkKOh0uWFRw3ACBdr13QOHNYWfw4bxsB5g1VyickFHJEnX5TeF2XXo5ZvKncsJSnyK3sN+zZ2ICR6BgfvJrKa17T5N1AhGHXpxINRlKBBuYD0h/MvYhZWCKlheNUXr6Gpw9+a2aLiYExdMynh1OHTcipEmpOJd7adr7TjPPjD9qgTIljc9icFfTocqgvjoV0iLXRHkOUmfE4/2xFdMTVo2hCJ8GkRhh4BTRxyA1Ua07rjf+FHqmvbhghYiLCxnn2SW98Bnol/TcyhW1RP7AAjASTu5+KPYYo3/sSnmz6Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79mo8jiooXDfTR1b4jJR9O/5Py4YTLOzaK+o+W0VpMY=;
 b=U5RWOZOpkm6TndakMlQb+hHHNL7Po26E+b0jaY6Nvnzadvh3W84iyv0EOdHrsy9JRaeHUO9ASTNqp/weDknwuv3zMhBlRVsX/zJTbiND2jQHxgHbPgNDqtguGDoMOiE+3ac7JByMNlydBOY00SpciOPiYRBpMPi8ws08kj8YyT0BnBILEt0pH+Ka4Ej1zXKnDpyFEI1EknBFo1rrXP8XNo/AfQMS2tY+OHJRmNJSmMv276XLXDogjQY0JPN5fjUG67I9iyMEzmsExSao39RVAhr0yLr+Pc0BESY/WiNPDir9GoaNZ0jLHP05lY6NdRgN2S4/8G5NX5My6A3JUqLAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79mo8jiooXDfTR1b4jJR9O/5Py4YTLOzaK+o+W0VpMY=;
 b=TdJW05I+uKbdk6KKyERS+7MKnscrQxGtXGtOxdcFw0qt31QFNHhqUQtuqAlPDEGWzDEeH6FryjG82V/psfAqa/9+ko67MxeiwUNs/bWcpmLbX2IXX7Bl/r7y5WITcGv8XtjXNx1FYjmouIMgcc0USag9+Il166XvCb+XKh6v4N0=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4968.namprd04.prod.outlook.com (52.135.235.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Thu, 12 Dec 2019 01:20:28 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61%5]) with mapi id 15.20.2516.019; Thu, 12 Dec 2019
 01:20:28 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hannes Reinecke <hare@suse.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "y2038@lists.linaro.org" <y2038@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 04/24] compat_ioctl: block: handle
 BLKGETZONESZ/BLKGETNRZONES
Thread-Topic: [PATCH 04/24] compat_ioctl: block: handle
 BLKGETZONESZ/BLKGETNRZONES
Thread-Index: AQHVsGPT1gLB5y0IiEqmi8ihreZMNg==
Date:   Thu, 12 Dec 2019 01:20:28 +0000
Message-ID: <BYAPR04MB581623E3658444BAC6E703D6E7550@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191211204306.1207817-1-arnd@arndb.de>
 <20191211204306.1207817-5-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 77198279-8ca3-4507-c31a-08d77ea17979
x-ms-traffictypediagnostic: BYAPR04MB4968:
x-microsoft-antispam-prvs: <BYAPR04MB4968A1B59163B962019D62D6E7550@BYAPR04MB4968.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(66946007)(4744005)(66556008)(64756008)(7696005)(478600001)(76116006)(66476007)(66446008)(86362001)(316002)(2906002)(54906003)(33656002)(7416002)(110136005)(4326008)(53546011)(8936002)(81166006)(6506007)(26005)(81156014)(8676002)(71200400001)(55016002)(186003)(9686003)(52536014)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4968;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YEOzNkeZA/B3sobXdndl0+LAacZux6nNkMXXRIkZrVj5JT7C7gbEVG83NhSIqtILNR8yhmI2n0PVkY/uJKSQqdeiS7377kDUi0c3TAEIlAaVHJXZfhDqZsFfeN6p6NEXl1VvWsL2l5EwdGaYfv5TX/ibnuEbPmrseDNlU51RRbextKsmQWDIsueHOtJxT7C8STVo2Br/G6qHPT7l513b2Q2QcL3itzFlgP8pdhIsmYBAM1M3aGJhBct7R8n6Zxi424+Rs4/FN7EMBmFgb/L/3KoUd5r06ofPcxQHanShGmMJuvzjVVMKlIe/iPi7xkMWpsP+iBny3pd8E7oFM7qzdvwxzJx8MFpT6bzGWWiL5NkQ2d7aBd90ywEx2IaNmY/UuMgWk5oZDtrfTNgnU6bqB1v9mDIF7mJfuls+OMB0V2iuBBASffiUCvEnbmCI/GKV
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77198279-8ca3-4507-c31a-08d77ea17979
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 01:20:28.6703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vdeQtUuv3NICVZT22eL75NPHKPOkG8FONJUkuSfp5/GgrR04MGz0+jUYT1hD5Zmd+MTMQfpISk8P8+SPZPZPHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4968
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/12/12 5:44, Arnd Bergmann wrote:=0A=
> These were added to blkdev_ioctl() in v4.20 but not blkdev_compat_ioctl,=
=0A=
> so add them now.=0A=
> =0A=
> Cc: <stable@vger.kernel.org> # v4.20+=0A=
> Fixes: 72cd87576d1d ("block: Introduce BLKGETZONESZ ioctl")=0A=
> Fixes: 65e4e3eee83d ("block: Introduce BLKGETNRZONES ioctl")=0A=
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>=0A=
> ---=0A=
>  block/compat_ioctl.c | 2 ++=0A=
>  1 file changed, 2 insertions(+)=0A=
> =0A=
> diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c=0A=
> index 830f91e05fe3..f5c1140b8624 100644=0A=
> --- a/block/compat_ioctl.c=0A=
> +++ b/block/compat_ioctl.c=0A=
> @@ -356,6 +356,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned =
cmd, unsigned long arg)=0A=
>  	case BLKRRPART:=0A=
>  	case BLKREPORTZONE:=0A=
>  	case BLKRESETZONE:=0A=
> +	case BLKGETZONESZ:=0A=
> +	case BLKGETNRZONES:=0A=
>  		return blkdev_ioctl(bdev, mode, cmd,=0A=
>  				(unsigned long)compat_ptr(arg));=0A=
>  	case BLKBSZSET_32:=0A=
> =0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
