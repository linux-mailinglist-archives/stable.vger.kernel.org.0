Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDF329D416
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgJ1VtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:49:05 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:42487 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbgJ1VtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603921742; x=1635457742;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Q14eeuR4boNpmbxQprtFqPRdAVTaOyZ2KnsPlQ5KLd4=;
  b=YQSJQ9rVKdmEXe7hIgJmsqC3LUOxIsDE8u1/HlpZplCRzCEsLdinh9Gz
   2JFgFOoVPcJXpAoWSNVjv1NfoO3MKb989UMI/jSC5WKS7zhI6pKOMYa0F
   h/fRdqGurykbk4Y7WAdQ9F0+knPbeSc9o23527uZq14zOMjs/MS3S2WxA
   My2cOsrjEBZYH87R15IH6KHs3ZMGIHW8OFZaziO2zNSJMW0oRmao+redO
   TJMsp9ZxLSg9DvMiX9T6DFKXlQSnWsBiq4NsGvn387OLXsYFCuF90IIm3
   FI0nCBzrsxlPuaSqXORXeSacMkATbHw27JR19lnX1/VWPuFhIxbGKKwgc
   Q==;
IronPort-SDR: F6zbqOICUAdKy9wH8vtuLKRyQO6f7D8HjWy/YpN9g3BTllQoUsbhHuUbvFYSB9XqwP2vISCx+S
 k+zVnCUeo5oIOWC9JOlyFVUZiyDjHP0bP8P1/wCLkEZ0xkbkHh75KaJ4R4ObuBwQP6oi3PuvYO
 0L0l4ZJdLA1nY5SPWnVvP2wmuJRqUFdGrZWwpAi8SRRR2jlfHPkOYRXy37Z51JuEAWHLBHQRyx
 9Xow/d4xCKjM4D8E5/Hj6/llwn9c5XCYp/Venuf+i1w5BDgF9gAWa8HZC6Vt49AU/hh2IN84Ni
 QVk=
X-IronPort-AV: E=Sophos;i="5.77,425,1596470400"; 
   d="scan'208";a="151136848"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2020 09:45:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAvuF2f38CliV1UbsJEHuXRBuFmgv8MH/zKGQwAIwyhsnnK2MOWGXbWEtPrHB3m5W/ZWxJukoDZnypCAVN9EFskC1zCNfoRA3V+Hcnhr4kzoJrsOshGAH9EfmTwCYC0Oviq89lBIx88aewyWEdBeXw/kOlRjTklbYV6fL6z2sacC2X/RY5s1lVkCMvdnX07Xf2UVn7t/M2O/UMVgz2Byqtnnx32+ZCQF6sQuN4MkhRTRGtE5p+rCzCU8Vk9OIihSdnLMAq1aMO94WgZjQmPPy4+WqkuFKHyDEQhlujnBbT0UqbiFFjK795RKDI5KfNOwNHNUHA13Xrz42SvHJi9ueg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtJFPJh2aaZtSYflfqkxXN+7Yh0kRZQfRuV56vsbw2I=;
 b=HO0uPlLfd556VU74ip0Ik8viBZV6N41SqMxAEdWIv/DMgBMoDnuIeflXO8T3HD5yxH5SP45WNDm0dTajeDq+tHQYHzHB5fQiFwDyjWZeyq0xLkWEq39c99sIeQjncg+fZ80pN97M90AVYmrHNKdoIYVcOQZbu2G5KDaAE3mWg5lZxCqtSGpr4RuXwdqLE8VrnMxEhNMUC5seAenMTQCHxALiQ/xlyfmaU75wIrN7GbWYSVwwP0WMkPSmR/qTYG60adaIxN3GDF66qdh6s8ng1UxxjyId8HuuRaINEkZD5JnWhwZF6Yrr4Vky9FyDWLFPojiUMFFAxtDJeGXTL6hx6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtJFPJh2aaZtSYflfqkxXN+7Yh0kRZQfRuV56vsbw2I=;
 b=wEHfLYZwTiXMpQKpiYTzatmDFqgGdg9prD82FqdIKGz6UK+EgT5aJFAOMHQqkqWYCAWMHCd06tmc+CdDE5oZNmBeuVr6ZvoK3Zdx/ilYtEuCeTvjRNvh/jkE6nsVuvxChgUaPfKqoQ0Pfgf4QE5nW7zFexeh/tRQTReguhhvbyo=
Received: from DM6PR04MB6527.namprd04.prod.outlook.com (2603:10b6:5:20e::9) by
 DM5PR04MB0890.namprd04.prod.outlook.com (2603:10b6:4:41::37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.28; Wed, 28 Oct 2020 01:45:10 +0000
Received: from DM6PR04MB6527.namprd04.prod.outlook.com
 ([fe80::bc32:8dc6:39dd:f827]) by DM6PR04MB6527.namprd04.prod.outlook.com
 ([fe80::bc32:8dc6:39dd:f827%9]) with mapi id 15.20.3499.018; Wed, 28 Oct 2020
 01:45:10 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 1/1] null_blk: synchronization fix for zoned device
Thread-Topic: [PATCH v2 1/1] null_blk: synchronization fix for zoned device
Thread-Index: AQHWlX4IaLdglWyy80qXrKErMeNvWA==
Date:   Wed, 28 Oct 2020 01:45:10 +0000
Message-ID: <DM6PR04MB652715459ACA71EBA758A1DDE7170@DM6PR04MB6527.namprd04.prod.outlook.com>
References: <20200928095549.184510-1-joshi.k@samsung.com>
 <CGME20200928095914epcas5p1beae8d5a201c35b598fde8288532d58d@epcas5p1.samsung.com>
 <20200928095549.184510-2-joshi.k@samsung.com>
 <CY4PR04MB37511C151D0F37DC62BB4CE6E7350@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:3dd3:d7e5:5981:e303]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eece3745-8416-472c-3f0b-08d87ae31b4b
x-ms-traffictypediagnostic: DM5PR04MB0890:
x-microsoft-antispam-prvs: <DM5PR04MB08909763C6C63824E101B211E7170@DM5PR04MB0890.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8DR82d0AQfQnygQtp347jd4wtLvkRZMoihehANgREXroicIja6GEldwpgMbcN/q56NfCPn+GhWkp2/FDFQtBdWxVSVLT5J5LV/K8aZFKhKrizlad13wG5nXJXq7SmCihaiebXeplVMVTLwFdZnRoTIXcamK5QoGzdf5I65x5zteEFgyD7el2hAom4pPlENDi39DC+/Uup9RILrH+qN18L3upgfAwN1BQ0Ls04bA2VZNLH2cg+31z/xEnkeg8xb9mq5p4+DFKB2JrCQnTh0XlEm+SBbaMYX6sunvZ9OQjQjxW9e6GnU4ZW5TvNPn+BCLYb7sbQMGYVquDF8vqNuslSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6527.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(8936002)(53546011)(6506007)(8676002)(2906002)(55016002)(316002)(9686003)(6916009)(186003)(91956017)(66946007)(54906003)(76116006)(86362001)(83380400001)(478600001)(66556008)(71200400001)(33656002)(4326008)(66446008)(64756008)(5660300002)(52536014)(7696005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7E5bB+QE0nKT4NF1npHh3WWWQpW/UqPilneiJoTcnGvjqGa9wm2zSX3jBk6t3lqz+CSNHtSQkPRba5Q8AYkfaew7EyWzNeTwFh9aNKnVX2RAlN8EM9xRV23SuV/F4WaALKMx8y0RpGu8xt26MEIeasMYwulp1sTkTj9jyYGdnuJBae3yE7aLiH0FnCK6lB+wiMk9xrR7lZHZPTx1tn5N4F9oGgzP1gmgVKejBWeXahRnJ+RIFU8pjyFHFHYxLnVQz+z8GIVCgbyahwjagkMaoqKj1AukrbkGRabrxUeIr2Y/j1KGx3xwcRSrDdEx+rIDGN7ASlxemjR22pK9LMyZEi6BWh8z6gCRw/V6MNEN/9FSPLqMv+vZCVvazu4ULktF7HUsJa/X3GdcJpFrxAxUOQOcYDgpIQJL5yDAprWMCmMRfFvXmgCSiKLKjG/in+4UzqfR3of+kfNHaHYgMbYufKlFuFPeecba6zDfcRZUjQTIIYGXw7zRVZgFgKg9VK/X91diKTOdUpCC/KKjDWZoOpeCzSkZ1ftKDbHyI6ooQagUlxQ09ktX3B9sy/dHq1UcFIW/AybnDiIrDQTNsJnDCzK2ExLIxSA62eWhpcqnwjjA1Kmo2ki0ybhp5RHxxijeNPdzNePxI73aecM2adysgwx/bRjo3JOa6ATFhnbY1Wd7EcF0cENFCOPfdnNl8DaXFmBcHE48cJmQrgwH1am/lw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6527.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eece3745-8416-472c-3f0b-08d87ae31b4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 01:45:10.6090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QqYDmfV88StqNgaW9KcSmTVZeuYM2bqCh9WRRUZ4q/kAxLOjNCYNLkggYC22gLWUCIyLq+pBrWhirgnpzrc4Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0890
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/09/28 19:12, Damien Le Moal wrote:=0A=
> On 2020/09/28 18:59, Kanchan Joshi wrote:=0A=
>> Parallel write,read,zone-mgmt operations accessing/altering zone state=
=0A=
>> and write-pointer may get into race. Avoid the situation by using a new=
=0A=
>> spinlock for zoned device.=0A=
>> Concurrent zone-appends (on a zone) returning same write-pointer issue=
=0A=
>> is also avoided using this lock.=0A=
>>=0A=
>> Fixes: e0489ed5daeb ("null_blk: Support REQ_OP_ZONE_APPEND")=0A=
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
>> ---=0A=
>>  drivers/block/null_blk.h       |  1 +=0A=
>>  drivers/block/null_blk_zoned.c | 22 ++++++++++++++++++----=0A=
>>  2 files changed, 19 insertions(+), 4 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h=0A=
>> index daed4a9c3436..28099be50395 100644=0A=
>> --- a/drivers/block/null_blk.h=0A=
>> +++ b/drivers/block/null_blk.h=0A=
>> @@ -44,6 +44,7 @@ struct nullb_device {=0A=
>>  	unsigned int nr_zones;=0A=
>>  	struct blk_zone *zones;=0A=
>>  	sector_t zone_size_sects;=0A=
>> +	spinlock_t zone_lock;=0A=
>>  =0A=
>>  	unsigned long size; /* device size in MB */=0A=
>>  	unsigned long completion_nsec; /* time in ns to complete a request */=
=0A=
>> diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zon=
ed.c=0A=
>> index 3d25c9ad2383..e8d8b13aaa5a 100644=0A=
>> --- a/drivers/block/null_blk_zoned.c=0A=
>> +++ b/drivers/block/null_blk_zoned.c=0A=
>> @@ -45,6 +45,7 @@ int null_init_zoned_dev(struct nullb_device *dev, stru=
ct request_queue *q)=0A=
>>  	if (!dev->zones)=0A=
>>  		return -ENOMEM;=0A=
>>  =0A=
>> +	spin_lock_init(&dev->zone_lock);=0A=
>>  	if (dev->zone_nr_conv >=3D dev->nr_zones) {=0A=
>>  		dev->zone_nr_conv =3D dev->nr_zones - 1;=0A=
>>  		pr_info("changed the number of conventional zones to %u",=0A=
>> @@ -131,8 +132,11 @@ int null_report_zones(struct gendisk *disk, sector_=
t sector,=0A=
>>  		 * So use a local copy to avoid corruption of the device zone=0A=
>>  		 * array.=0A=
>>  		 */=0A=
>> +		spin_lock_irq(&dev->zone_lock);=0A=
>>  		memcpy(&zone, &dev->zones[first_zone + i],=0A=
>>  		       sizeof(struct blk_zone));=0A=
>> +		spin_unlock_irq(&dev->zone_lock);=0A=
>> +=0A=
>>  		error =3D cb(&zone, i, data);=0A=
>>  		if (error)=0A=
>>  			return error;=0A=
>> @@ -277,18 +281,28 @@ static blk_status_t null_zone_mgmt(struct nullb_cm=
d *cmd, enum req_opf op,=0A=
>>  blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf=
 op,=0A=
>>  				    sector_t sector, sector_t nr_sectors)=0A=
>>  {=0A=
>> +	blk_status_t sts;=0A=
>> +	struct nullb_device *dev =3D cmd->nq->dev;=0A=
>> +=0A=
>> +	spin_lock_irq(&dev->zone_lock);=0A=
>>  	switch (op) {=0A=
>>  	case REQ_OP_WRITE:=0A=
>> -		return null_zone_write(cmd, sector, nr_sectors, false);=0A=
>> +		sts =3D null_zone_write(cmd, sector, nr_sectors, false);=0A=
>> +		break;=0A=
>>  	case REQ_OP_ZONE_APPEND:=0A=
>> -		return null_zone_write(cmd, sector, nr_sectors, true);=0A=
>> +		sts =3D null_zone_write(cmd, sector, nr_sectors, true);=0A=
>> +		break;=0A=
>>  	case REQ_OP_ZONE_RESET:=0A=
>>  	case REQ_OP_ZONE_RESET_ALL:=0A=
>>  	case REQ_OP_ZONE_OPEN:=0A=
>>  	case REQ_OP_ZONE_CLOSE:=0A=
>>  	case REQ_OP_ZONE_FINISH:=0A=
>> -		return null_zone_mgmt(cmd, op, sector);=0A=
>> +		sts =3D null_zone_mgmt(cmd, op, sector);=0A=
>> +		break;=0A=
>>  	default:=0A=
>> -		return null_process_cmd(cmd, op, sector, nr_sectors);=0A=
>> +		sts =3D null_process_cmd(cmd, op, sector, nr_sectors);=0A=
>>  	}=0A=
>> +	spin_unlock_irq(&dev->zone_lock);=0A=
>> +=0A=
>> +	return sts;=0A=
>>  }=0A=
>>=0A=
> =0A=
> Looks good.=0A=
> =0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
Jens,=0A=
=0A=
Could you queue this patch for rc2 please ?=0A=
We are seeing some issues with zone append in btrfs testing without it.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
