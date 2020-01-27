Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1351E149EDF
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 06:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgA0F6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 00:58:08 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:43583 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgA0F6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 00:58:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580104688; x=1611640688;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=F38QfExE3sI0sRSKzMt2ygbLR566fBKkEw2imqnaJ9E=;
  b=g6WCEjzwhLAacRdrTKjKOZNC3ekfQYyjKz47j1Mtq/QPisYXxlugzo4h
   DG+ww8Rmtz1EiQJHtzEIMxh+oHRtkKCHpNath3sOOGWELu3q7iUW00rax
   ixegBu4o+7htx6nMa0OrO8qpF/6DdjOfguRKiqIEOWuaYzQIDPb4Y/c0K
   9XMqbL3H2HENp8zl6ovZsM+/z0lnJrWIMvP8euTZlhedsCpjSPMeNELKr
   +ex8iz6cWNf09fWmLIX+gsSzVihwOUpRgR6yNvOnosep/NVJyMOMVmOsx
   sDbNAECbVM/vR+rKKqj/w2QeA+9Pg/bMZzSmyAWs6Ku17YYn6kGDZNSfz
   A==;
IronPort-SDR: 35i19LyJuuOEsg5zj/rGxV+Q+v/ImRfGXtLnMcZjLhzS7Cb06o0TuAY9k0+vL984ShBQ2aZdXY
 YVtAdG49ILU0aZtxhlqDD7U+lxl37S9wIk7IL+6uA9QAB7FYtXewFqIk19aC27XZkjcyYGg9N5
 OGHSYK1RWDVabmduk4sKc2SXjaFKL+tHMmO81Tcv3Csxn2g8eARD6OZArnfcamyX5WyUx7Zgb9
 5TRTkAbuD4msefMIwz0EOhIh2tYmNhmV2dD1ndUppqlc3qPVs7FwHsP9IQnuLVrc/cfeOKFxaF
 JzY=
X-IronPort-AV: E=Sophos;i="5.70,368,1574092800"; 
   d="scan'208";a="230155162"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 13:58:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzbECoFBY4SGqS0nhAUqRm/RRjYpE4/QTcA07gwIjpLAqCUL/GYvgOHyjQobH8CSoWwTuIsJ2TlBN8MFTDWUJhNCLKfH4n+5s/pB980RP98ijRJ/M7rKFR286Kg/VYR1jYLEzNfFphN8Hj9GeTOZ+TBNnq2n5+njX8eQMC4eEDrqikQUsJekHUt4/Gb97dYtHo2Fs1/i5U8E9px7A5A5JL5XbXrFUvJHQLqE93QYpyTmcC+8u6yTHEkalVtD93Db+O38UFOPcFitfXZnDoiwYV0g8D8421SV2LiQjMyuPe7SwZcgVJrTVPdQHPArKqicNLQD5Oj5H9ejEgzDPzQYug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+Mresb7ilMhWXMtN4sxTAVKDCue9NgBlbB6PPdWDss=;
 b=CsjBdqEnF+ywi82NeHDtU3fnJWUtZfA758ZlmOlm4+3kFYMW+7mhy3Xe1ExWFe0EGi5SoA4h3WgSwNIIgaJym6SYca4HwzCVvO2j6m5LxXnkAx4T/IdCNDQrrQ2LwAKJd2+yZX9q/1Nx5+zUDPqevFK4PTmLGbvtwGZmXykmkkdHTNb5uKQeo+s1l7pizHSBs7zw0VusK8OEHsXUOo5hw0JfVVcorRziTyFVC88XQUepZF/bN07PKPck9IdDo437SYCzwP4mCC9vFem7SY51bJQVkGoXPVmkIbwIJao5JZCRT9l/7YDVEoAzZhCE/Soiyn6C1EUtD/Dve5AmFbqjwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+Mresb7ilMhWXMtN4sxTAVKDCue9NgBlbB6PPdWDss=;
 b=Rs3awx2Mre5fAsKYDFNez9MXhEhyM1vTY3qmmkT3fipTp4tvOdHi8vSGR+shHRT2chVTJucgI5fqHFKr4JfguNx2g6AsgQLxFxj+xHRtPkKvJuILBAcAuv+LLyoGLYEcI4R99reqTUyUbc5G4WNIPniFkGKdEpfXcoFJREmOGdU=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4904.namprd04.prod.outlook.com (52.135.233.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.24; Mon, 27 Jan 2020 05:58:05 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61%5]) with mapi id 15.20.2665.025; Mon, 27 Jan 2020
 05:58:05 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Masato Suzuki <masato.suzuki@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Fix REQ_OP_ZONE_REPORT completion handling
Thread-Topic: [PATCH] sd: Fix REQ_OP_ZONE_REPORT completion handling
Thread-Index: AQHV1M+5+VUZg9ITnESxwzK58PS9MQ==
Date:   Mon, 27 Jan 2020 05:58:05 +0000
Message-ID: <BYAPR04MB5816781F4588054DF9C31380E70B0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200127050746.136440-1-masato.suzuki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8263a787-f746-494e-507f-08d7a2ede0a8
x-ms-traffictypediagnostic: BYAPR04MB4904:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB49043626AFC792C34C8AC953E70B0@BYAPR04MB4904.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(199004)(189003)(52536014)(33656002)(6506007)(5660300002)(9686003)(8676002)(81156014)(8936002)(110136005)(86362001)(316002)(81166006)(478600001)(7696005)(71200400001)(76116006)(2906002)(55016002)(91956017)(53546011)(66556008)(66476007)(66946007)(66446008)(64756008)(26005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4904;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dd2F601fEBKAOD5GTmffBRBM4Kw3vaRHSkcKRHwCSaw0Vwe6aXyRAaWFMqja1PTTij45qBCuVsIR6HFUKgQLsUhmQe49gF6vipc7+ULTV1MnfjaH4kcXuBBGaAK5nYGEtN2ir1YA0I935Nqu0zwSzKhCiD8YlfNxzCvSnuZixzaeb2m3zpuiV+fX1qj+EXfXF6V2OsY813Hquf+ZZ3hKXsp5APSaOS65SGSSadSM22X0MIpcwYs0AdlYRyZDQw0HYVqjfCO7Ha7S1huGkhvs/O5J0VtayXI1VUge6e5ST07PghB7ahoqOYxanL+UZooOzhJzlupat4xpXnZfFWNhC7YHJmWZjeccXT++ESm3fE9t+5nb4HknUViHOECSCvf0cKUcOee7fIBNwW0KQjJOlY4H2KcoXwtI6BsU8E9VSW9SWtXc5whxDVQN8VsuNyTb
x-ms-exchange-antispam-messagedata: Pf10cRRuAyPTprqpRm09j0Qrn97krLoBfFhr0SARgSUFClQzoJYkWxLVQR5/0tpfTBaaLy6KKpyTFSU2RjwBtES5BBNnHsn4jBwzVFpX8TXvrvR0eUcznPnpY6Cs1OsQEcNwiDJr4NXop6Qo7KOpIQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8263a787-f746-494e-507f-08d7a2ede0a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 05:58:05.5061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7dYyFgc5EmgKxuAC4wfnCHBlKMGeLagvFBu8MZy/xU9ZrCBjktvxISw7yI7QKeRn1S+d8MwU1tUiz3lFIHQ2ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4904
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/01/27 14:07, Masato Suzuki wrote:=0A=
> ZBC/ZAC report zones command may return less bytes than requested if the=
=0A=
> number of matching zones for the report request is small. However, unlike=
=0A=
> read or write commands, the remainder of incomplete report zones commands=
=0A=
> cannot be automatically requested by the block layer: the start sector of=
=0A=
> the next report cannot be known, and the report reply may not be 512B=0A=
> aligned for SAS drives (a report zone reply size is always a multiple of=
=0A=
> 64B). The regular request completion code executing bio_advance() and=0A=
> restart of the command remainder part currently causes invalid zone=0A=
> descriptor data to be reported to the caller if the report zone size is=
=0A=
> smaller than 512B (a case that can happen easily for a report of the last=
=0A=
> zones of a SAS drive for example).=0A=
> =0A=
> Since blkdev_report_zones() handles report zone command processing in a=
=0A=
> loop until completion (no more zones are being reported), we can safely=
=0A=
> avoid that the block layer performs an incorrect bio_advance() call and=
=0A=
> restart of the remainder of incomplete report zone BIOs. To do so, always=
=0A=
> indicate a full completion of REQ_OP_ZONE_REPORT by setting good_bytes to=
=0A=
> the request buffer size and by setting the command resid to 0. This does=
=0A=
> not affect the post processing of the report zone reply done by=0A=
> sd_zbc_complete() since the reply header indicates the number of zones=0A=
> reported.=0A=
> =0A=
> Fixes: 89d947561077 ("sd: Implement support for ZBC devices")=0A=
> Cc: <stable@vger.kernel.org> # 4.19=0A=
> Cc: <stable@vger.kernel.org> # 4.14=0A=
> Signed-off-by: Masato Suzuki <masato.suzuki@wdc.com>=0A=
=0A=
This bug exists since the beginning of SMR support in 4.10, until report=0A=
zones was changed to a device file method in kernel 4.20. It fell through=
=0A=
the cracks the entire time and was caught only recently with improvements=
=0A=
to our test suite.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
> ---=0A=
>  drivers/scsi/sd.c | 8 ++++++--=0A=
>  1 file changed, 6 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c=0A=
> index 2955b856e9ec..e8c2afbb82e9 100644=0A=
> --- a/drivers/scsi/sd.c=0A=
> +++ b/drivers/scsi/sd.c=0A=
> @@ -1981,9 +1981,13 @@ static int sd_done(struct scsi_cmnd *SCpnt)=0A=
>  		}=0A=
>  		break;=0A=
>  	case REQ_OP_ZONE_REPORT:=0A=
> +		/* To avoid that the block layer performs an incorrect=0A=
> +		 * bio_advance() call and restart of the remainder of=0A=
> +		 * incomplete report zone BIOs, always indicate a full=0A=
> +		 * completion of REQ_OP_ZONE_REPORT.=0A=
> +		 */=0A=
>  		if (!result) {=0A=
> -			good_bytes =3D scsi_bufflen(SCpnt)=0A=
> -				- scsi_get_resid(SCpnt);=0A=
> +			good_bytes =3D scsi_bufflen(SCpnt);=0A=
>  			scsi_set_resid(SCpnt, 0);=0A=
>  		} else {=0A=
>  			good_bytes =3D 0;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
