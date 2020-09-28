Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD927AB90
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 12:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgI1KMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 06:12:02 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14008 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgI1KMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 06:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601287922; x=1632823922;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Jvww9mfAPeQqATEYnXqp9bzQtb/hSplg4cctvkYJj9E=;
  b=aQs2M36TSgiMgwW45HHy4wM9teapzugAfStCpb/KVVkK5ECZBJ18nhRv
   OgR+HokciZ/Ji3cxWO1afO0AqZg1b7ikdK5+ofhz/5fua65NT8TYMSsrv
   sNSMwxfaRB46hT4gHaPdArDqCp7IewN+fSctGnTGMvVyEkCDYff8T3hUs
   UGb1cQlnMQpHkXp95k5I0PPn1nsyHV+V2H0BnhQiwMUI2V2GAkp6Cgc17
   N5u9XmyxNr/hbDBLwTGmLK3HVrG3dSNU/wZrdYKJET8PyCJ/TNIkblOdO
   0KLPQH15EKKX2AeeA789mqVTsnCdsSd5UhGGWPyL8T8CsfcBOmEXN6dwb
   g==;
IronPort-SDR: Z14eaFcGH99rOUTDeArLataOAYr/c6sc/5jidefN90lyk2m1xKY+BxMFDyJPuyquHZLxm1gOC5
 2PcLlfdPFI87qRYQN1+3CzGVy/3ZTdRwA+jUlpUQ03Y3t5+93jQYl3MvdpjytHp6BFD1n+f2mH
 jRhgSKUZmcBHVqhQymGmyc+Ho2fFlWwJO9gb+MHGn/jYo1MtTki/aZ/4r/ynxxjlorX4iI9PsI
 KYZttSSFVepzKkPetBSqtOW8eoJxbag7afTTTjKNBSJJV6XM2kkrdLQlppDuXZIK57J8s7bCPL
 Pfo=
X-IronPort-AV: E=Sophos;i="5.77,313,1596470400"; 
   d="scan'208";a="152798716"
Received: from mail-bn8nam08lp2048.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.48])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2020 18:12:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A99btcbALIoSWqJAJk0gr7dmwvOn6J2FczBgX+3GApdT7BOCEdjhG0iNWGv/HFZ25gvoBwyukCFZGsfctdkeKU1zaEeTDitrlvFUmFXn2pbtlilZ8I2Xhtv4RhT9g4lOHzqqRKTv4vTUFAhkggvnUzcYzVes9DBJSJJAkAW9HtHTxtMPr/OFyVjVT2qyaCyPf1WX8l5DfQMDSJzKp32x/BeoujxAh7YIsjlE6uwr4h3OMrDA+3DAUB+rkHCjoQpA99AaHKWgc0oh7sJ8CPTXf5gr0os0gf8SndzuPy0nQl4vun3jXqWPIEWL5Dkd8dqr2UrehTQEgWP8zEaFzgrVrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jPfxcHa6iTWq9WXm+WSc5oJJypqOCZ4GVMz5uodCt8=;
 b=h6nBAVufUARBAbbNUEV8kSYcgqlyXYeaFm8xZDdNFa2HonKm5MQ4H1gH7Wj7AQL7dUJP+cBYsocggFN90NJ5fDGmpNK7ntue9SuOKXO9D3rTIxkQnMPvM35qxqZJwDxroYmpV577w/4yJNAZqjR7up6NYQC0+CrrwPPb0OnbpWQdsze6OONg9kepPMH5wVPPLNl2IDgyVqxcJf9H59Bw7Qft2dZ8PAKKiEKwgy/ccBxYCWHcUaebULKbWB45xjf++pdERdnQLb9ndrNviPFLInqL8rzHubH2wDdlpd1KF5tmp0XK59bm84rFhaMnwhZUGKgEe7VTW/1ETc0Gy+EaWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jPfxcHa6iTWq9WXm+WSc5oJJypqOCZ4GVMz5uodCt8=;
 b=h1goPYvWIsBeSlLSkL0cj7Opp3qgfp+xg0LAj8eedFw5InJl0Q4aqljz176Nzsz9voEgU3EIH0smrfGaH5pfOgHZ2jYavr77pJwqF12uwAvhRjEe5lj5cIkYOhZK2pd70Tss2434Ik5gPYcvA0iNKI/KaPuk+Z3tRQ2UhmkH1zA=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3633.namprd04.prod.outlook.com (2603:10b6:910:94::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Mon, 28 Sep
 2020 10:11:58 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 10:11:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [PATCH v2 1/1] null_blk: synchronization fix for zoned device
Thread-Topic: [PATCH v2 1/1] null_blk: synchronization fix for zoned device
Thread-Index: AQHWlX4IaLdglWyy80qXrKErMeNvWA==
Date:   Mon, 28 Sep 2020 10:11:57 +0000
Message-ID: <CY4PR04MB37511C151D0F37DC62BB4CE6E7350@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200928095549.184510-1-joshi.k@samsung.com>
 <CGME20200928095914epcas5p1beae8d5a201c35b598fde8288532d58d@epcas5p1.samsung.com>
 <20200928095549.184510-2-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:809d:4e2f:7912:1e64]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5562aceb-aa40-40af-2fba-08d86396ef18
x-ms-traffictypediagnostic: CY4PR0401MB3633:
x-microsoft-antispam-prvs: <CY4PR0401MB36332F348A65151DF2A5D60FE7350@CY4PR0401MB3633.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E74JP0ZDjlz2zPZoY+4IxNRr4mon5QohLw7Ajsu/SyL2dv2cY7RA0V6iyfn6Qv9YXL/GZuM8pehC0/z2OzhXDYiZpGDFJP9HlYwl8gpi+v1f58CdOiPZakpkYqlqxSpBD/JeQn/iPbteaiEDxWsA68kQNSw/Ee78woL3Qr0KH141ssPveHdqgBYzbyhnn5ifMmDzC4DTfGzgx2rtfe1gVblerk8mlRZ3H8SmjYQBMQqqB6/GLn95fOK0HJR30VP0FfhB5trpdIZ2gSdR8SxDqltt80hacuKNNnzpG1PYXvGhA61l9oTyu6p224Rl+Jd+dSs520X0qM3WW9Rb5IGNa2tlgFBNWd7zLjD1R3SiugV6F11+5WsBmOOm+dA6DNOf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(66446008)(54906003)(4326008)(186003)(316002)(110136005)(2906002)(478600001)(8676002)(8936002)(55016002)(53546011)(6506007)(9686003)(86362001)(33656002)(7696005)(52536014)(71200400001)(66476007)(64756008)(76116006)(66556008)(91956017)(66946007)(5660300002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PFzfwDaJAppLdE1OJ/c5LjlWTOUjCV37BIcKALM4JZBvrD8LFm/YP4+l7lZ0MO3V9B50ZStVn+G+g/I4ieBTFev5oliVqgLe/Xi0TM9e2U/wmgZ0Ekypv+/NQRAJ/srQiFZJ+2lUAnjCzwnCKgCNhQHoIrXim3mkDuGmEE/CtuHgk+xWF97TPsfWXqj+tNVYyE7W9iimVBLzUlMAqApew/CcvcMpQZgbG8+TOX/una8YN4JXmJkH26ozoaicWMIDLoc/69bQKm70uLqhl3hBnRR+lIibvLo7OhuuuJlypEEmhpE3U9PIpItOmLU4vQEFJAp6Zy6Yi6vyZTO1uDuO/bJO5jjY4N//TIqTYcgPs5IdFFUatMMvTYrEhz7SOeIrQWCll2G5efXClXtvDQ84bi3SPs/zziuP7aDE6Jlnn0UU9cFKhurHMzMVyR+Wxdq3XVrdSD3AzQ7MpeHn1L96FZTfLGHrgpV7ABoBFkfpL4LvL1/wiLH4xsYJGCl1C2zzhe+uTZNzG4QtmuOKYlMh2HQp14a+FXS/6WXwdl3aOGk1Z15zE6xIjS0iVppN6BOWjoHw55Z1O+fg5PltxmR+j+95AKMKpvcxDl+L+ZKBDdF62fMNv3cJAUwxXzH9YhQJePhnF6thdHKDjtGvotj8pDnCYxVjKJX1qP4FscROdnigpmYXNAU+CrrTucdFv14m9x3RyxYXvrqpFaKrYM5iDw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5562aceb-aa40-40af-2fba-08d86396ef18
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 10:11:57.8530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68CeXxX9Ne7/kImQN7VoFBFPSdmgTT2S+dpnYYb06NXP4PK0PxcaoTK3AUA2I16c+RBMVc1g0+mDn3ha30l9ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3633
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/09/28 18:59, Kanchan Joshi wrote:=0A=
> Parallel write,read,zone-mgmt operations accessing/altering zone state=0A=
> and write-pointer may get into race. Avoid the situation by using a new=
=0A=
> spinlock for zoned device.=0A=
> Concurrent zone-appends (on a zone) returning same write-pointer issue=0A=
> is also avoided using this lock.=0A=
> =0A=
> Fixes: e0489ed5daeb ("null_blk: Support REQ_OP_ZONE_APPEND")=0A=
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
> ---=0A=
>  drivers/block/null_blk.h       |  1 +=0A=
>  drivers/block/null_blk_zoned.c | 22 ++++++++++++++++++----=0A=
>  2 files changed, 19 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h=0A=
> index daed4a9c3436..28099be50395 100644=0A=
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
> diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zone=
d.c=0A=
> index 3d25c9ad2383..e8d8b13aaa5a 100644=0A=
> --- a/drivers/block/null_blk_zoned.c=0A=
> +++ b/drivers/block/null_blk_zoned.c=0A=
> @@ -45,6 +45,7 @@ int null_init_zoned_dev(struct nullb_device *dev, struc=
t request_queue *q)=0A=
>  	if (!dev->zones)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
> +	spin_lock_init(&dev->zone_lock);=0A=
>  	if (dev->zone_nr_conv >=3D dev->nr_zones) {=0A=
>  		dev->zone_nr_conv =3D dev->nr_zones - 1;=0A=
>  		pr_info("changed the number of conventional zones to %u",=0A=
> @@ -131,8 +132,11 @@ int null_report_zones(struct gendisk *disk, sector_t=
 sector,=0A=
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
> @@ -277,18 +281,28 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd=
 *cmd, enum req_opf op,=0A=
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
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
