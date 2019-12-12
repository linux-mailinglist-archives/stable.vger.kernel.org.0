Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FE611C20E
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 02:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfLLBUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 20:20:23 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:17814 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfLLBUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 20:20:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576113623; x=1607649623;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uF9I1R2LRffndPJU9z8bYrr8QsI0eBKCIIMEun6ej5s=;
  b=puSrdQL46/D5Z3YwHhaWebosZ9MWxxU7VEuOPzOrsW7jd10EWRKjZ+w4
   nr0SeitzJDt0uuP38uwRJcgSGVrFTQNs51eezlCh4BzB/xaHIROYdDq9O
   g+XKbk3EwEvJJtZqYG8FJ70mE3eFjbF0LDBGbo9g0jLXPTGm2qJVyYl+H
   G4I5EM+2TGxNK5B/uqIEwpBLNh1vuxbV40pL4qeEugD2+kzdD8lfPRTNy
   wtoAkAgBzxEzPtcfqc1+QmmMVE0tAQ/hIXlLFdzM+5F7p+Yl0/ZVfxO6j
   N8pAyRV2OEPNROjoYqfQHh38oRfgu0mu+MbAwYTeBv/C5fIK+dzBdbm+Z
   A==;
IronPort-SDR: 7D37mZdnMf48mjpsw8AFW9WQl6WPnSNFYlUchZWMEoJq0FEeH2aeiLPAJWiyz0Hw3V3ivxViCc
 mgq3X9/ZbGs7pNUAdu6yaMgJJJOUF/n4qH4v1/1xAuvUm7LO+WrrG2g5ZSLkxIuu5wcIF5+/6a
 zBk1fFE5ZpMkbW/1Idepu5keDOOf6LkioFrtoao8uovE7e09mxjDo3ZQ5EnlsmOnu9v0AdBGJi
 9nkHhTdrwwa8JjGA+uqJWGeDPuvxNLrnr/35DWq5bG8hyCQ35fKgN+jjfTCMZfTKCZHAahLgvj
 TJc=
X-IronPort-AV: E=Sophos;i="5.69,303,1571673600"; 
   d="scan'208";a="125922385"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2019 09:20:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDAmLflI5UEjWsIhgcJm6WE/LcgMMms6ALXNILzgIXzxFIA6K5W4p1B7SuvSvP658FTKF/7+uoaWZ2sbXvDO4wapVcxYIm6XUF3gYbgcmRDUTlOEHitFI8lbSDxlrRzQCUN4YjmJy7MxF3+/Jh3OaFNUZKrDG8tx31ZDpZRU54210mWuACgcSWY5bHh814NrJjrj0XaQU45miD4Ln2NkuHoR5Ky3j/CQHMS+lBNmo21D8nzPqp8HfU0Kl50U4yZOlVhfHGaMGbUwfwTwAFfCYyZ1OlmG/v+iN5L1LRQ28YsfsTBobC7jjjg2pv01+j0ld/O/ZN5QRd9eQSp1wvnrMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CM9PFGtVtJBNCf/PTHVlZLA7F/p7zXh0ppka+F476r4=;
 b=G7gab98QN+fTUglcF4asNMrjlrtLU/R8bP9kcLhtxPBN1Ns5V8Syzx6xGupHLA4vrjvjqoqSznFcE24lxIHYuL5pDH/si/qP5sghAzVO842X8m9URPqdTZQAEyRaMLK+NFNYYiqUPS4eOUmR/STObK1dNnokuflDuaup9mmT2o1pyN+y5Z44FU86vxV6kjPySt6TadfnE3x8cMuYycGBmE5fCyP2oqTQ73zXr1hPYSwCWr413c5fcuGku1mUnkqg3x7OesH0HdTfAf/KwwTWLuHBDQ2CG140YOY+BAPYdmHfTkaHE2IMyDe7IQpTD5/t5wj/XhNJUZqDK0VK+uAoag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CM9PFGtVtJBNCf/PTHVlZLA7F/p7zXh0ppka+F476r4=;
 b=SvBxOf3ddep0gDVTQglldZPyr9DLaWXpkL+p1eNBSSdeqgepaXbMMHcmh7zJu0jh5k6DiR94Ti0BpId4RCj/eefeE7QcGhZP8wuJEdmR7MvB6zAdtHnNVrRxbxPCDmkvs8zyzcxx1EEZZxk1ptphdtWwIHRh07nnL4YsSw9pszU=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4968.namprd04.prod.outlook.com (52.135.235.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Thu, 12 Dec 2019 01:20:18 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61%5]) with mapi id 15.20.2516.019; Thu, 12 Dec 2019
 01:20:18 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>,
        Shaun Tancheff <shaun@tancheff.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "y2038@lists.linaro.org" <y2038@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 03/24] compat_ioctl: block: handle
 BLKREPORTZONE/BLKRESETZONE
Thread-Topic: [PATCH 03/24] compat_ioctl: block: handle
 BLKREPORTZONE/BLKRESETZONE
Thread-Index: AQHVsGPTRc6cO3ylLU+5uVPBTMCZQQ==
Date:   Thu, 12 Dec 2019 01:20:18 +0000
Message-ID: <BYAPR04MB5816B23ACA82F26E7BC06F8AE7550@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191211204306.1207817-1-arnd@arndb.de>
 <20191211204306.1207817-4-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f82d2ff6-7dc5-402a-3d76-08d77ea17352
x-ms-traffictypediagnostic: BYAPR04MB4968:
x-microsoft-antispam-prvs: <BYAPR04MB4968AFCBBE8589F0AD6F5CB1E7550@BYAPR04MB4968.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(66946007)(4744005)(66556008)(64756008)(7696005)(478600001)(76116006)(66476007)(66446008)(86362001)(316002)(2906002)(54906003)(33656002)(7416002)(110136005)(4326008)(53546011)(8936002)(81166006)(6506007)(26005)(81156014)(8676002)(71200400001)(55016002)(186003)(9686003)(52536014)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4968;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GcVNygPNCRcWvoQQn7LuFuMf/PJTmqVxb9TYiI7G3cwBI1ukjbdKCtbmJWaQZaT0FwBzW88JenyNU1PMuog8ZtKiqPQeRF1DRhAuSOqQr/3tfu4/YWxoYFD3to/+1+zWPKiLqri8tPiWuCGUY1HcKLDMbThvoxRqvpt8hN/zikFZ2FQmq1Rxf4ShUrYb2SKr9bc58IhnOfEAmip3zVoW4EyteQLdvNjrbaePO2QiEKNSua2TFi4zGXIqHmMJSUgCpmycxrrm68eR3TKXQBwE2D+Y1G2wWRr1IYxQygEooV+DfY6Dl0j02A6WvdW9L6UG6o1ZrMZ+AV33L9l7NUnEEPbzmuWFVSt1rA7s7ad9+ZfKbytJJGBp/VBR/kMFK9ThEGRRCnmAasTBHDaQezerAxK6l+r05faHhospt3Fo5ppi8ANRwJ7FnxfPlWYnJ/d1
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f82d2ff6-7dc5-402a-3d76-08d77ea17352
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 01:20:18.3569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZUdg+O7dXilPGagt/xcQYEyDMTH2wC0zBHVX7THzMXjrcoCCZXLZz/OuB4yablmq4HEGf+Q/4W8+uwx3601ZXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4968
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/12/12 5:44, Arnd Bergmann wrote:=0A=
> These were added to blkdev_ioctl() but not blkdev_compat_ioctl,=0A=
> so add them now.=0A=
> =0A=
> Cc: <stable@vger.kernel.org> # v4.10+=0A=
> Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")=0A=
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>=0A=
> ---=0A=
>  block/compat_ioctl.c | 2 ++=0A=
>  1 file changed, 2 insertions(+)=0A=
> =0A=
> diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c=0A=
> index 6ca015f92766..830f91e05fe3 100644=0A=
> --- a/block/compat_ioctl.c=0A=
> +++ b/block/compat_ioctl.c=0A=
> @@ -354,6 +354,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned =
cmd, unsigned long arg)=0A=
>  	 * but we call blkdev_ioctl, which gets the lock for us=0A=
>  	 */=0A=
>  	case BLKRRPART:=0A=
> +	case BLKREPORTZONE:=0A=
> +	case BLKRESETZONE:=0A=
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
