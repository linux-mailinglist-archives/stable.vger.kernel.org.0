Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1C23A8ED2
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 04:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhFPCbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 22:31:15 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54442 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbhFPCbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 22:31:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623810550; x=1655346550;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uRvI6yhSlHi3dVTJQx80L5FuXusf/9XP7REGjfYQ2h0=;
  b=SLb9u3FgGlXMWwJz9Ecwp1IWtcTfToOLpk7AqbT2aRz07EoJ+X1JCY6v
   YlTtFNztGx+hyncV8koAD/3FLmc9oEwQSgY6j8aHWa5TiEoPzKIri0Jn0
   2R2QSYZnU5fHl679CDuKmi3CgVd+9kQDfUE51lKvldDe+XHb0H8cQYyuc
   Eq4DVbXYNSOgL5n6GeNAMti9xZfusEXupYXYUQB4H/HbP1CBlUP9PhY5q
   3MZZ597XXfcNPmH/w15n6HiqCQPWDntCWUHuAzBmNq9luPvR7WScdLaMH
   pA3Pylxumo88Sodl708hCwVr20N8hJnKHZ9AmE+tQow9OloE/X4OuMXrJ
   w==;
IronPort-SDR: oDCSGRZyiaH3xsRuRKFRavApx4SASg4QeakbaPMwXyM8YjKaSaIDk5HKnpkqrYzaNrwSIpZwFU
 iyWrzuLV6AFEcc2N2zQG3LHZmUDwh2JORPGihttuXfxHPupzaOeZ6X/GTvlQv1Y2yWjOTd8oee
 ATmEi8zLntk4JGgjP1PHucaY+DzDrMVJrnneIOH6CjvCNRNk9lwPjo0FUR0DWLKBZlI/eLtOq0
 4usNcHE9lC9DEmgEovQwnuHzn3/3dcEd2shMjlG14EHXcGgFZZERuaiK3KpeM+CQ9CzwjTRRaL
 nDE=
X-IronPort-AV: E=Sophos;i="5.83,276,1616428800"; 
   d="scan'208";a="172611156"
Received: from mail-bn8nam08lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 10:29:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjZlsI9FOnrfsQdKs241d/meUuTK5zR2FL37sNEbcjssbqNKHLGUHHSIFHkho8pMt5Xz6aKTpjMCNmG8cNTdzPGNF1jq3rIwCGl/B1yE6vHcKD999H0PUn/MDBm8UrzH2jyocYoFoTJI27YdPfQt0Ff6AxTG6234mJ88tXKt2ynn/jt7uTn6uiXs0KAkF9yefjJ4SpEpCMa6Piho2L5UQ0F+B6Vi5N89yeeECQWkpscwNQZyPueclXC0LL+RW5LuqG/8rNIysF8O5NBkS8/JOk2fboTuzHFpxQrLa5RBwuEx0DnubzihrWsuJocHrGiFPebzIovsD2e9FaKS7Om3wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AZ4upH2xFg1fses5xXwaBL52F7KUo75EG88/re2Ec8=;
 b=hq9eMb+MFEkWMet8leqhjIyWqf+K1c7azA37aOZvGNVkGv47lNpOZ5jcjI4It9NyxuWtuX4RgDnVFcD2I+8A/Zr1hiSwg0uP/o0l1NaAnNb2TffrXF4grUCVBWRizkqj5JHWzCZAeLscLIL0QhnOfS2wC3B8dqdL49wRSF7Xr9V+O7flHOvkCdnOkRQHuuBP2ositLsZnzob+lYXFfx9Gc+G8DmEB7O3TmjVpUyh/ewP0cj2E2kfRTvT8ldBODWU1CEMUOxttELYKu6Q6FCwgDTwadFdiZFWOiLV/8dz8tnZ/qnZhWXYJ//luzDQcNxF7btSWEdJjx4EvlGg5RWaag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AZ4upH2xFg1fses5xXwaBL52F7KUo75EG88/re2Ec8=;
 b=BsFouh4kP8f3aowXOUZXISjGVeOHjFnpbNGgb8Yv11Hl7ZQXC6oErz/m/cHU0x7tTWb3zgKEBo3FRqe9MekpDjbgKy7YOpda7AjCWkrUGs1aK7GTyW8HFAYBxTYJMVts8bh39ydLECDUlBd7IAdNnYcd9nkE3LiHNhu8qQJzkvY=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6859.namprd04.prod.outlook.com (2603:10b6:5:244::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 02:29:07 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::a043:568a:290e:18bd]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::a043:568a:290e:18bd%7]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 02:29:07 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaun Tancheff <shaun@tancheff.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Topic: [PATCH v3 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Index: AQHXYRgSjUhXBDQMDEqRjMXRF8VrOQ==
Date:   Wed, 16 Jun 2021 02:29:07 +0000
Message-ID: <DM6PR04MB7081B123680E5D318688FF26E70F9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210614122303.154378-1-Niklas.Cassel@wdc.com>
 <20210614122303.154378-3-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:258f:73d9:efae:5b62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58a8e2a7-5a03-4b5e-c160-08d9306e8465
x-ms-traffictypediagnostic: DM6PR04MB6859:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB68592DF81178343B39E0CD05E70F9@DM6PR04MB6859.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: stlUYWYzXvVYMFW9hw7enUBZO/7c9nWnZQFaMVUlC+P17BWJMAGUafhAh5hFRKmaAs8CiOiIWQ9ugwNLkWDuo296ClYR05fEdE0BuCdALLPp8XCAJj70uKu3xhP+IinWnNhgbUQ/tGO5P0s2ec6MqggToEodLCQ7zvGPoVNBA4lSxnC/6NdnYoki1kz2brvAiKPjyaPwiDpO2VarCTqTPAYQwEA3nbvLtmdA/2qAuscx5+fqfuE89aHzsWoCl+3BQThcMFDhbLcjAGWzFzT6xpNf3GElTfH458U8HTC+awtfnoZ3SXW94aFRwOT+IGqAhiwc9MJGJJjP0EEY7JtO8X2EE3bu6koTCPDSytIdsSv2NaV4+cJerVErfsugr5oTyZbEarjz6vLwK5pONYGY5b5KV2qsSOA9Le9OnScIPhwSGO+OubQsTXwCE6rcnTiBpYXsy7wUtOzFB3dUanLFHLB4fsSCUgtMfFAsndbM6eA1peqxNhi51MR+ubXM4S4RUwFNBc07mBkPQG0ULZT3s4CzPZCXB/noeE9m2wvsFquy5MLQA8zQlVt8taVE8IUV3dmiQz/a5sdAK6ufMc8bojR1oY0yLzeLjrmJH2zEGVc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(316002)(55016002)(52536014)(8936002)(86362001)(2906002)(91956017)(83380400001)(9686003)(186003)(54906003)(7696005)(33656002)(5660300002)(110136005)(66476007)(4326008)(38100700002)(6506007)(76116006)(8676002)(53546011)(66446008)(122000001)(66946007)(66556008)(71200400001)(478600001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: R6fBIHeW8TmXU0V4Bf9BQkh53tCNOC3yKvOO7SVJzAJiPD6sDjkHJRIJzJvGAbJePh5i1oU7UWZzMF5hEIGo/f39j3YD5Pa6Efb9z6dZPu8tHSxCzXkkw+seNo9h66ACpJvhkZNUYl5XLmWNrmI04+/a0oJWjG36fSkRmyM2oarQXLE96uI7Y5iXVHUeZsnnjgVB8T7X+Adyq8R+F/XyWpnzFXwoCICPiLoIPGg/apKMgd9AT8m3cF/L2gDxwcm4B6Vpx0qPG8VFxpeKO03UPuahJ922Qvk1SoRIQhUDY5cTzEgy5yYu0HbbBcRwDsQP5HuwIWNKVrlGEH1HRyrmREYz7Vs+9KwJ8cJ4ycty2vGG+MCq7rQYKTZE0SZI5jwmYnOJPfW1niUq0CvYulpWdjlfOJSk+FRFuH84hjKQNqEk5+Ms95qSmFMYywhYGOBxKLX3gyb1osGsn1zX8QKjlbjLKO/QC9MlXzNW7tB1zRkl5D/5QvoF5Q9DhcRaecL9Ydugrh5wNzZ5yRJPohS2uGxd8Tc2eUUiKoyz9BP62bzeNhzGMFgKlM7NDsCMZTHDyirWaWg0hwAFURpV2iYc4qRdm0vvOecWyn9TveRsUbUVcUrn0c+4ZEmGrCIJoe2EFRbdIwWw/OPydi//kXCYYSRw/bRSVPYEjpMyyfKXKsAQc+DD4SYvmDASLvx3SR0AT2DRshhXbAhsmPxkFuw7A9X1rjiK2m/CxZW9lLmZRATPVoVy1xDacr+M5sSB2PYc00SNeXksCkF+LGYNYpCujmLqfPJK3RwpMPabQ4ZrUN1rSi8JgXyg6xLQShK5UzojAtpKtG1iQiAmnFSyTBHHWA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a8e2a7-5a03-4b5e-c160-08d9306e8465
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 02:29:07.3730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cGZSHIIzG7iP8e/lQ61/cXkikoTIjwfhyll5HCTAAt7NEr19aQ+GxZZw1LWn5AygRsupXS0sMsIgiUNEVQCC2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6859
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/06/14 21:23, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> A user space process should not need the CAP_SYS_ADMIN capability set=0A=
> in order to perform a BLKREPORTZONE ioctl.=0A=
> =0A=
> Getting the zone report is required in order to get the write pointer.=0A=
> Neither read() nor write() requires CAP_SYS_ADMIN, so it is reasonable=0A=
> that a user space process that can read/write from/to the device, also=0A=
> can get the write pointer. (Since e.g. writes have to be at the write=0A=
> pointer.)=0A=
> =0A=
> Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")=0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> Cc: stable@vger.kernel.org # v4.10+=0A=
> ---=0A=
> Changes since v2:=0A=
> -Drop the FMODE_READ check. Right now it is possible to open() the device=
 with=0A=
> O_WRONLY and get the zone report from that fd. Therefore adding a FMODE_R=
EAD=0A=
> check on BLKREPORTZONE would break existing applications. Instead, just r=
emove=0A=
> the existing CAP_SYS_ADMIN check.=0A=
> =0A=
>  block/blk-zoned.c | 3 ---=0A=
>  1 file changed, 3 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index 0789e6e9f7db..457eceabed2e 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -288,9 +288,6 @@ int blkdev_report_zones_ioctl(struct block_device *bd=
ev, fmode_t mode,=0A=
>  	if (!blk_queue_is_zoned(q))=0A=
>  		return -ENOTTY;=0A=
>  =0A=
> -	if (!capable(CAP_SYS_ADMIN))=0A=
> -		return -EACCES;=0A=
> -=0A=
>  	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))=0A=
>  		return -EFAULT;=0A=
>  =0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@dc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
