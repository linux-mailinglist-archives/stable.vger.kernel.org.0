Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADC71853FF
	for <lists+stable@lfdr.de>; Sat, 14 Mar 2020 03:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCNC0u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 13 Mar 2020 22:26:50 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:2936 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726414AbgCNC0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 22:26:50 -0400
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E2OxBd011703;
        Sat, 14 Mar 2020 02:26:47 GMT
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        by mx0b-002e3701.pphosted.com with ESMTP id 2yrkyx0p3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Mar 2020 02:26:47 +0000
Received: from G1W8108.americas.hpqcorp.net (g1w8108.austin.hp.com [16.193.72.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g9t5008.houston.hpe.com (Postfix) with ESMTPS id 0238362;
        Sat, 14 Mar 2020 02:26:46 +0000 (UTC)
Received: from G2W6309.americas.hpqcorp.net (2002:10c5:4033::10c5:4033) by
 G1W8108.americas.hpqcorp.net (2002:10c1:483c::10c1:483c) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Sat, 14 Mar 2020 02:25:20 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (15.241.52.11) by
 G2W6309.americas.hpqcorp.net (16.197.64.51) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Sat, 14 Mar 2020 02:25:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaVx1OFAVIzyYXYR/WtCTyvCTAAtPrEOdKCtaiU7Y0sWwLfzdeMs3EOXLC3wxtiM6cU8vgQQwpGd3XaGu4PUKlbnNGYJNujOnTZgWK8hGaiJDMgWA1Ept5ygHB0QDh8pW8hTP/cH1ySGO9jU7R9rF5CxVFFOuR5ZUUmSHnz4Qsi+ZlZM189WuOFq4SOWIsV92jKcCuYKHK3rieQPqRC3BNZHx7t9hpSXIlww77qzthnPpJChyL3Ved8SImb6IMaAiOg+Od79hyTLc9At74OVMKd+vvudnQ9bnWM31X2l9Snkt5zLzNCnuZuJZUXkaISKyALQTMyhBZYME6CtQ3juTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/l57HIB7iQ4dhzbQpXVH0s3f16kglr7wr9k236Ag7nI=;
 b=nHQiwHnENjY3pgccecsydRRxsGlzwne+CvfjlCAPiOKHd97lqS6m+vQsGcNj8inDxsMrWiJSMwTMpdhoi5KrkzD0+DRcrKRZE99JB0Gi986Veft8VHqKPJ6ozOis5Xgv/0qsVK8hxxdCBpSEdRt9CbQW4jOfrYel9APIfqGbCxDkcjGwlpboBbS7ywo1H44uoXctl7gcSiBwDl0PvpMaqeXgv2OMFXe3hq3iJcUqCsY/h/o6YNTAQvkRp44yf4qyqBqimof/rXOxQvmMYsKZ0W00NZJL/f3OZPB0G4Vx12CVpQtNxoQUP7NnJeMGT2Pxa0hOyRA8QNIi8dy4+Sg33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7613::16) by DF4PR8401MB1178.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7611::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 14 Mar
 2020 02:25:18 +0000
Received: from DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::97d:4683:6c97:19f2]) by DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::97d:4683:6c97:19f2%12]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 02:25:18 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amit@kernel.org" <amit@kernel.org>
Subject: RE: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
Thread-Topic: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
Thread-Index: AQHV95Eelm8i6f9q4U+J7lkCvZ3HDqhHT4kQ
Date:   Sat, 14 Mar 2020 02:25:18 +0000
Message-ID: <DF4PR8401MB12415ADC9760286F3930DBE4ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
In-Reply-To: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.211.195.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 898ca563-99b8-4971-07dd-08d7c7bef06a
x-ms-traffictypediagnostic: DF4PR8401MB1178:
x-microsoft-antispam-prvs: <DF4PR8401MB1178B8E7D229E1718C17A46DABFB0@DF4PR8401MB1178.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(136003)(39860400002)(376002)(199004)(2906002)(55016002)(9686003)(33656002)(4326008)(64756008)(71200400001)(52536014)(26005)(6506007)(5660300002)(66946007)(76116006)(53546011)(66476007)(66556008)(66446008)(478600001)(110136005)(86362001)(54906003)(316002)(7696005)(186003)(81166006)(8936002)(81156014)(8676002)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:DF4PR8401MB1178;H:DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mzmW1UzLc+BIsGlLh8TE9DqmrqIq9mCky+nzfNfwRsTVe7PsFOtPSrPZlkAsL3S+76GAr0cYDtC8B/9LpTNK3lS4bt5I06Ua1IocT7CNOREBuSDtNtnLaW0++1ZRHI1pWrz+Y26kgQEZa9CGiUopd5nKPrQcAU8OYx9jcNI5qXnhjTfHRai9kCe91CWxgf+qdw87XtNbJr+joGuIlHgWRyESjlmXTQctUUtGsP8CB72i2NkuY643P2ssmEm/fCrBzX3L7XPGNBBqgAHTGsX1X6TP8DSGhtEXhyxzIMxoAhltn8AvUIBlZvwRXzttunHbEwa/6VsNhYihUxTfuxfNC/Up10s32b49h1YS9AxtcCR4VhgfySFcoFUfRCNPZylkPMld59Zs1VVqF/UflMaB1MssGD7YliA/XUrQdeUdrl14p0RmRQXpEr01wpnj0I946Te8YjxIEvvdO4RLyGsmsR09Y9rLmkMv/bfZ5lGoyW6YPBDfLChMke+bGK6y+uoO
x-ms-exchange-antispam-messagedata: zZmzuiuidqVKMmgVf+tgnwWtHncRlwm2+G6ZBTBRRrZkXyc8FhrFrGdQXS1mqvwXXhS7sV1FrZ1YoGVVBYVnTxXTbfkr1VTgjWImDkU3JkEItWKH3F8/4BngJw/NGnonYJWrp5eUsNm0ux//u1xlkg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 898ca563-99b8-4971-07dd-08d7c7bef06a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2020 02:25:18.6269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RKnIaLK3LKErmjS31X/b3h6fLwC4m3IJ6FjYEXa48p/kCuQZoh344lLCT7uxuZId
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DF4PR8401MB1178
X-OriginatorOrg: hpe.com
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003140011
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-
> owner@vger.kernel.org> On Behalf Of Sreekanth Reddy
> Sent: Wednesday, March 11, 2020 5:37 AM
> To: martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; sathya.prakash@broadcom.com; suganath-
> prabu.subramani@broadcom.com; stable@vger.kernel.org; amit@kernel.org;
> Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Subject: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
> 
> Generic protection fault type kernel panic is observed when user
> performs soft(ordered) HBA unplug operation while IOs are running
> on drives connected to HBA.
> 
> When user performs ordered HBA removal operation then kernel calls
> PCI device's .remove() call back function where driver is flushing out
> all the outstanding SCSI IO commands with DID_NO_CONNECT host byte and
> also un-maps sg buffers allocated for these IO commands.
> But in the ordered HBA removal case (unlike of real HBA hot unplug)
> HBA device is still alive and hence HBA hardware is performing the
> DMA operations to those buffers on the system memory which are already
> unmapped while flushing out the outstanding SCSI IO commands
> and this leads to Kernel panic.
> 
> Fix:
> Don't flush out the outstanding IOs from .remove() path in case of
> ordered HBA removal since HBA will be still alive in this case and
> it can complete the outstanding IOs. Flush out the outstanding IOs
> only in case physical HBA hot unplug where their won't be any
> communication with the HBA.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 778d5e6..04a40af 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev *pdev)
> 
>  	ioc->remove_host = 1;
> 
> -	mpt3sas_wait_for_commands_to_complete(ioc);

Immediately removing the driver with IOs pending seems dangerous. 

That function includes a timeout to avoid hanging forever, which
is reasonable (avoid hanging during system shutdown). Perhaps the
kernel panic was happening because that function timed out? 

Reporting a warning or error and doing special handling might be
appropriate if that occurs. That should be rare, though; the normal
case should be to cleanly finish any outstanding commands.

> -	_scsih_flush_running_cmds(ioc);
> +	if (!pci_device_is_present(pdev))
> +		_scsih_flush_running_cmds(ioc);

If that branch is not taken, then it proceeds to remove the driver
with IOs pending. That'll wipe out all sorts of ioc structures
and things like interrupt handler code, leaving memory mapped forever
(no code left to call scsi_dma_unmap). That might be better than
a kernel panic, but still not good.


