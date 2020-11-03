Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE782A5A98
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 00:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgKCXgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 18:36:39 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:4975 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbgKCXgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 18:36:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604446597; x=1635982597;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=tTahDpg6VEA9V2l2G2hIP9aHwSnJa3FXMjPbZG0KUN4=;
  b=EJc5SHVW8HjPxDRQI+JJizTHiguYgH3IaVQXxKpdRBlohOUS+nYU+mCM
   7S0BVrfm3ECk6LrnQxtN3G8WU2FgtEKqD6weCf9Gc1nGDG9jZrZXzuYZN
   GIn7i5004gEyyWIcgQsbBO35JpAHVn7f0pnFsykzQM8PL8c2anLpNgDzZ
   iVqbWDWXAEyEh3lj8Wuh2/WV1KolZ3hKos5NVlOYWuuDNEHLv5eoVGBv7
   bsAPBBmXdlU3+ba0jA9z7uokEl3hxLQAxpKTMoA9ziFRjOUFlAnG2b5wJ
   Tv2iStuB/dmzxdyD0YrI7U4/pgLJIlE1xSrzVFKM0QlJwZQ886nKie/d0
   A==;
IronPort-SDR: qwWxINDWcah5dH7YjLiELABEW8iVEUFMil4yrnmTzUvUDqyyw8/vlhhn5O86D8G7ihlpp/kfPg
 sTmMAZM3AjkWQc/+55/81TvUc9yyGUR04+chcTvO4gZMhmyI7KyH5KbCpST/5JjX1/X+Y3eQd1
 cH9x9FDhugoEyU9rUBTHGc66sUgWTxeRP6fS/kRACAQ13O/pcurzDN6uVMFohWtVIPf1ocYLp2
 sOQJIN3Qn6oQAh4tCoB9F/qIUWH/LrQi1j/2jKr4mxvtk9Nhv/sfFC81eqMY1IPttYQ1zKPccE
 q38=
X-IronPort-AV: E=Sophos;i="5.77,449,1596470400"; 
   d="scan'208";a="261706045"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 07:36:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8SubiF7357TADPEqOkzLo1rlY1wvhKlJvFNxhmBZpwGgZCRAuhxh61OZ0aeX0hkorq2RhlQ/Yznb7Xd0cC6ag1yq8K41ozk22KfuQWrB2wTCIUkAbS7uWwQ/z7Hn7DxenbPLDs4njlITnAWjR16lyY3mD3hevcK6s6nxOy4KgYEjQgsSjdpxOARwbfS84ZGofYj7zmpuku7LgL4kpFMqE1T5S5xYHyylQIEkBhvHZUb8XgxDal0PyL5XiAa+R3MDWuOwT8srWwwvj1NdnymYZVdKOUv4yCwIGTpXX4zOE3Y2gO8uJyzLaEzOQKb8YCtGCFbweDFXqLAVFL47Xz0Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jngdcrzi4FdCoMopa2w1JpYt1pZ740hLM6Pz65IS+U=;
 b=HXccFK3dj3xgY+BUiwtqEfJBdcoEWNdwy7LKm7uiCdmNX3xfQULjOuI7NtShS0P6HPcewVrOiOSk9Q7BSEUpbqWsekD+0hCRKLg8oiJUE4cSTpaYb6/P6xgxSc+1ttB6i0vU0hn3kbJRiSabi94qJH1g160M7ATgmO6VNXE8fRaAcGRIhdOQwFbJ/EVuRHPMXQ0+ZwKxUgs6psj8Rvbi6mDGijZl9eQZKVu072o6srwl2I+iGAWUCO8/PpVyyWFrAq9vdAaupL/ocOFXq9eE2Gl0zSPQ0v2GTomtxiH3qeJXuw8tyCzzSGA69/jpBvdO1dQ7DKsGAanFQwCukZs3Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jngdcrzi4FdCoMopa2w1JpYt1pZ740hLM6Pz65IS+U=;
 b=BoKzxDKDjOuYChWqtqL7MgJI58JrdbeyKNbvuRyHIRq9JMW3YEUSTSRsg8EDu6Pwgcsoze2bXsRuhUjfAjNt5en576h5XjvZSyB5miH6m120dtqpS7j6aO3FFYWgraQnQSdjwOGn3AHZc7ZgovAhQCtf5Ubb84OzcnTASxAkYZU=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6445.namprd04.prod.outlook.com (2603:10b6:208:1a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 23:36:35 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85%7]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 23:36:35 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.9 374/391] null_blk: synchronization fix for zoned
 device
Thread-Topic: [PATCH 5.9 374/391] null_blk: synchronization fix for zoned
 device
Thread-Index: AQHWsiM76BgMC3WbRkyxRh5dMkktVg==
Date:   Tue, 3 Nov 2020 23:36:35 +0000
Message-ID: <BL0PR04MB65147F17F20E4E4A77E35B38E7110@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20201103203348.153465465@linuxfoundation.org>
 <20201103203412.385651316@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:830:5e48:69b5:9288]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 028674da-f223-4a1b-5034-08d880514d77
x-ms-traffictypediagnostic: MN2PR04MB6445:
x-microsoft-antispam-prvs: <MN2PR04MB6445711B446F92BCFBE958CBE7110@MN2PR04MB6445.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kAmPP5rfesgXFG4TIBHRi4FJ3FkzoQKPVNJ0uzpCzk3/OaXWL1E9q/y82MlMlbyCxGLiL8NrbFhEECx7zDuo+wdn5ruO4U+gFzbeLQtwEavs94y+FqagXsyWPCTYrXXtzbHi0k64ufR3i2akBEpo0UkDDY+qZOyEkEFq2kQnItj4qFRgH3kNgP0p7zVDNLuCy4FMYaFf4TS+S7iII/TexWqZT//acwYgzjkJaI3j7DhSCrfxyG+XYOQWyRvnvfT9J01YtF/5K16c3Iq6CLLNHGwp5CzbYHeIlRjutLajzR0HrYNBWXlV2JdvcF4bCZlkK24ZKqoP/XD06TUtTrUHPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39850400004)(5660300002)(4326008)(316002)(66446008)(71200400001)(8676002)(64756008)(55016002)(7696005)(66476007)(66556008)(91956017)(9686003)(76116006)(66946007)(8936002)(86362001)(53546011)(6506007)(2906002)(83380400001)(478600001)(110136005)(54906003)(52536014)(33656002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /T6IG+9YBvdEo28fIxa6nT08aDraj0z9juZ7ns8IGYhURMDMjBgEe6KpsMuE2b1E6404UjdCgr7zP0V4m+p2ugpLOsX2LWfree5R4DuUvY+vJzp5u1ZUBe8/Pq+uFOsv94f8RgNsgCAsP5gJi0WRBuOr+sg8rSouYRzRLSamjqqLtMfvgaQlu0EPvchh9nNs9wPT9j1ohc1VQt+PJMoLsfqbEp91l6Yr2PHGvw4djUMeZVPDZ6O8mfAXHgEp1Uv8GDplvBvyuJlL9WERr9UUoRRUO0aM2S7QJvnNAK8jSHjk5IBUd7SdK9Zn7EyIxKoXZcp4B1WmRWU06xfiRVjsO/uCrP3mNsXmQaoS1LGpbZ0eteTFi8GWsaVXulYsQysZ5qeS1NE5GQoXaa8VhredMrbiiMK/zAadeWqyb8kiKEdWkXvURvnwh3AKpf+4bOO9lp2Nk4Bbz+cHB2ZssPxc2nkOUahk76dZzSgDFJ4c5twDJ/No6lp3Hx8KXfEHRYFGIjaMdXQ2hnpTCxpxD0CaZEiaUxs9VWzMbpZDMppdek58MetYMD9jEJ6G5ivshZORDgFwGvNkUv+ocjbU54NlC/L26tinKc1ywq6Zm2RHfToPUAtkcItPPOytAStNNOxNnUFqrdIdQOytJfr5fyiL12dFY5iJGNkjyt659gLgSTZcOEVIhoILdVt8krXG/oDrIfc4DGvGqQO05u9tq9+rng==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028674da-f223-4a1b-5034-08d880514d77
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 23:36:35.2007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BWWvrv2p5Qp9Vwq32s00lkVNB5PLCpeQR9mRY9ZUVzvQcIurXRkZVrfKZb7fOI5Ma8jMNv0EbA2EFI415qV9Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6445
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/11/04 5:52, Greg Kroah-Hartman wrote:=0A=
> From: Kanchan Joshi <joshi.k@samsung.com>=0A=
> =0A=
> commit 35bc10b2eafbb701064b94f283b77c54d3304842 upstream.=0A=
> =0A=
> Parallel write,read,zone-mgmt operations accessing/altering zone state=0A=
> and write-pointer may get into race. Avoid the situation by using a new=
=0A=
> spinlock for zoned device.=0A=
> Concurrent zone-appends (on a zone) returning same write-pointer issue=0A=
> is also avoided using this lock.=0A=
> =0A=
> Cc: stable@vger.kernel.org=0A=
> Fixes: e0489ed5daeb ("null_blk: Support REQ_OP_ZONE_APPEND")=0A=
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Signed-off-by: Jens Axboe <axboe@kernel.dk>=0A=
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
=0A=
Greg,=0A=
=0A=
I sent a followup patch fixing a bug introduced by this patch, but I forgot=
 to=0A=
mark it for stable. The patch is=0A=
=0A=
commit aa1c09cb65e2 "null_blk: Fix locking in zoned mode"=0A=
=0A=
Could you pickup that one too please ?=0A=
=0A=
Best regards.=0A=
=0A=
>=0A=
> ---=0A=
>  drivers/block/null_blk.h       |    1 +=0A=
>  drivers/block/null_blk_zoned.c |   22 ++++++++++++++++++----=0A=
>  2 files changed, 19 insertions(+), 4 deletions(-)=0A=
> =0A=
> --- a/drivers/block/null_blk.h=0A=
> +++ b/drivers/block/null_blk.h=0A=
> @@ -44,6 +44,7 @@ struct nullb_device {=0A=
>  	unsigned int nr_zones;=0A=
>  	struct blk_zone *zones;=0A=
>  	sector_t zone_size_sects;=0A=
> +	spinlock_t zone_lock;=0A=
>  =0A=
>  	unsigned long size; /* device size in MB */=0A=
>  	unsigned long completion_nsec; /* time in ns to complete a request */=
=0A=
> --- a/drivers/block/null_blk_zoned.c=0A=
> +++ b/drivers/block/null_blk_zoned.c=0A=
> @@ -45,6 +45,7 @@ int null_init_zoned_dev(struct nullb_dev=0A=
>  	if (!dev->zones)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
> +	spin_lock_init(&dev->zone_lock);=0A=
>  	if (dev->zone_nr_conv >=3D dev->nr_zones) {=0A=
>  		dev->zone_nr_conv =3D dev->nr_zones - 1;=0A=
>  		pr_info("changed the number of conventional zones to %u",=0A=
> @@ -131,8 +132,11 @@ int null_report_zones(struct gendisk *di=0A=
>  		 * So use a local copy to avoid corruption of the device zone=0A=
>  		 * array.=0A=
>  		 */=0A=
> +		spin_lock_irq(&dev->zone_lock);=0A=
>  		memcpy(&zone, &dev->zones[first_zone + i],=0A=
>  		       sizeof(struct blk_zone));=0A=
> +		spin_unlock_irq(&dev->zone_lock);=0A=
> +=0A=
>  		error =3D cb(&zone, i, data);=0A=
>  		if (error)=0A=
>  			return error;=0A=
> @@ -277,18 +281,28 @@ static blk_status_t null_zone_mgmt(struc=0A=
>  blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf =
op,=0A=
>  				    sector_t sector, sector_t nr_sectors)=0A=
>  {=0A=
> +	blk_status_t sts;=0A=
> +	struct nullb_device *dev =3D cmd->nq->dev;=0A=
> +=0A=
> +	spin_lock_irq(&dev->zone_lock);=0A=
>  	switch (op) {=0A=
>  	case REQ_OP_WRITE:=0A=
> -		return null_zone_write(cmd, sector, nr_sectors, false);=0A=
> +		sts =3D null_zone_write(cmd, sector, nr_sectors, false);=0A=
> +		break;=0A=
>  	case REQ_OP_ZONE_APPEND:=0A=
> -		return null_zone_write(cmd, sector, nr_sectors, true);=0A=
> +		sts =3D null_zone_write(cmd, sector, nr_sectors, true);=0A=
> +		break;=0A=
>  	case REQ_OP_ZONE_RESET:=0A=
>  	case REQ_OP_ZONE_RESET_ALL:=0A=
>  	case REQ_OP_ZONE_OPEN:=0A=
>  	case REQ_OP_ZONE_CLOSE:=0A=
>  	case REQ_OP_ZONE_FINISH:=0A=
> -		return null_zone_mgmt(cmd, op, sector);=0A=
> +		sts =3D null_zone_mgmt(cmd, op, sector);=0A=
> +		break;=0A=
>  	default:=0A=
> -		return null_process_cmd(cmd, op, sector, nr_sectors);=0A=
> +		sts =3D null_process_cmd(cmd, op, sector, nr_sectors);=0A=
>  	}=0A=
> +	spin_unlock_irq(&dev->zone_lock);=0A=
> +=0A=
> +	return sts;=0A=
>  }=0A=
> =0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
