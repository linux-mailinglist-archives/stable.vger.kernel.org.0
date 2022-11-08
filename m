Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320EB621D05
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 20:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKHTa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 14:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKHTa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 14:30:26 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB3D6587B;
        Tue,  8 Nov 2022 11:30:25 -0800 (PST)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A8HjuI9031544;
        Tue, 8 Nov 2022 11:30:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=AFJAwAlVmJ1aSqKlgNEDHbPmhdCLioeGJV52+kWaj0Y=;
 b=qXiUH2EPGFlBBj2Xrfris1Ex+pO81aVjOIJtH8FncNnvLRATEMDi8npA3ZyXYrtuPjNh
 L1uAPzGTzYPHG9V0YaHOinb/LR9qSXXZXTWljEnYF87QvTZg+o5/Xj/7xgsDfTgk3JiH
 sFZpAT6/ArDuWMNCybfcQVIpSxKyRh4fznzP0xey9AGkw3merlPfurFPlYfX1r38TTzV
 68QNYCsRMIrGhGwRWz4ty20p9ml+PihiS7Rl3Ua/7MOmEDV3DV8zB9b4y1cY3Fp1CIUw
 e9aIIJjGLn7q5yQov4iaDcW8XfgtcQmP969Dwm8LJoHrrPp0HeD9WXTqj9wXwVdpfKg2 Yw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kq0mrsrbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 11:30:14 -0800
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0AEBDC09AE;
        Tue,  8 Nov 2022 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1667935813; bh=AFJAwAlVmJ1aSqKlgNEDHbPmhdCLioeGJV52+kWaj0Y=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=RL7gYExIeIgoF4thl/3SbeWmXB4igqJ8LPTWirjWFrpDdU8qy/PiTBLSgRNYPruuL
         8fh22J7n3eyIu8vi32KV3hweY1bi9q+U4iiJGEY8mXkzyfdr1C8E2nhd68ZFya57YF
         GJad9bSmzwF2SB6NRP7/qTG0F4sAZz2/4nFuaoT0f6+pjEMdojLq693BcKJrPSpWe8
         tob6XBXJBO2U6ynW0qBD99Iv3l6AEAzer6lfQoUuElOBM2aEjCNtvfB7u/6OY0BZMC
         +QCv2AsITwic4uUkfoGgI7eBOiCCplWl4dv+F9tm4OLpyqLSykChdxyUjUli+9F4Zg
         CZNAOfcKZX0CA==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id ABD70A00E5;
        Tue,  8 Nov 2022 19:30:09 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 0F964400D9;
        Tue,  8 Nov 2022 19:30:08 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="lfBOGHFh";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/qPKhwEnhv+9RNtiuwBW89J1mG9/ATQKQMumPssjT/jntKGl6ibjRueEa7/KM4wssKLOHojL8nlOEnK01+NBpJ0OsojF2z2BA1UCzWYeXvlio0s53PehR+we8HydVkS27wfU0Vd/Vi6Ze5gGmVVY9M2ynDWNZ27eBgRXbBRZFK3oamd4fHbIkg7D4UXS3uxAUnYHHPzU9jGcHw/IA6QN8htGWsFmaJavCyiMMyirDhZX7DlCg9cMGkfvrR7dKwwORVxZ3w30DtX+mPs8FtE7X3BR9x0L+vo/rhTUP0Ga/6wVHKabJN4FFa3LUj1lrfJ3lp+HHI1XChg9gsPsgh11g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFJAwAlVmJ1aSqKlgNEDHbPmhdCLioeGJV52+kWaj0Y=;
 b=F377nPg5MW69z6vVWVR8t+8ldlL8PGt3BM8MuJkzgcVJ5GgvzfAP6uCaMbBiYfVLRsgyJ3WR6isUwDuYv6DvjFFVNi/Um4XWcCMcMCe0HkyQJ3MbmxdNWlrZJMG9ZynRoBLkbMbGVFQ55wQznkR+8zN8Wj2DCByMsuSOG7tYlcEKB59Ak4T/LLdQWw2DmyQWyRiNT7/223hMPxOXVHWTV+7Kvcpc+3+U/7QnBBqrVj6GggAxPiq0LxRmQ+M9C1R95YXh/pApsXlDR2vH9DJBKqJ4PGOmWi0SgCktH4fAVq1BJRkoA3sI6pztlX9CL0ceOUG6YzUSZ7aHPfpfBIkgxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFJAwAlVmJ1aSqKlgNEDHbPmhdCLioeGJV52+kWaj0Y=;
 b=lfBOGHFhtQ3w+R3z7T+QV2s3+lbDdRnToYXTcVN4vUHYbrpYpR1eOJHnw1Zx7TXrTIkHrTWhbM84c1KzJwW6VLuq0TGs8uTeOJfpZSCxkjDsDRSHK5JT7jreKVsbdlvjCm9sZ46WI4HewN2v5O4mkQ/G4e6eEh1COXI5e10FMCE=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MW4PR12MB7165.namprd12.prod.outlook.com (2603:10b6:303:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 19:30:06 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::9f62:5df9:ad93:5a1f]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::9f62:5df9:ad93:5a1f%2]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 19:30:06 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: fix status value on remove_request
Thread-Topic: [PATCH] usb: dwc3: gadget: fix status value on remove_request
Thread-Index: AQHY86Znbhx9JIiu5UK1/AZN0+3fYK41aa8A
Date:   Tue, 8 Nov 2022 19:30:06 +0000
Message-ID: <20221108193000.zwvhk4boclycajsn@synopsys.com>
References: <3421859485cb32d77e2068549679a6c07a7797bc.1667875427.git.Thinh.Nguyen@synopsys.com>
 <20221108191445.2883161-1-m.grzeschik@pengutronix.de>
In-Reply-To: <20221108191445.2883161-1-m.grzeschik@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|MW4PR12MB7165:EE_
x-ms-office365-filtering-correlation-id: ab37f31d-fa0d-4b7a-8c0e-08dac1bfa40e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NFVU70LIfFlr1xHvv/8KVmEozKMKdpMjclnoGYUubGB/JcQFqqDfj9YbmE6sgYaGCh6AmNWCcWZv/MeNbYX+CPRn9UsDF+pxobZXEf8t9OslpG/CsvQHTivhNFr6VYRr3Q92e6YFgGQC0bFq7l9siitW2J0OvWjI0pncvU41Lqou4b5NsbqAUCXavkIzPnlJhP8DoDCLqgXXsNU63N2ov/v2NN1P1+bTkkQGdoH+hjs9tnXVm1eDO3gpCH28wfHnjIlPki2HdyrQxwrNMk0lO8AwknuaezHJx/McGsuDj6J1xyqN8FfzdqNJNveB4NM2GnH0RGpiktlgRdrH58wf8N1LL8eHm2eXwj/JS9QwRqnyItdVwYfmeiTA5iCRwjVjDnyoSQLUg1X7UllzQfuM6Pz+IEm73CsipxSLCROaFvkxocAw06A54F5IsDudHzaF+5mI+far1zMWXlv0zh6TOP1mmHQN2vMhxxmzjVBgfTrYIlpQRlp4PfeKx/UlFA7mLMSEfZ/D8b2AtI/ligzOwV1V5TXLBVJWvdM9ykbgSbI3K48a2f4YNa62JUrYcOF2bYgGxN4MrOXapFWrRs8iPpUK8Bd+bRYWFDoJ6f7ZDHNjU9vI/s9Uv7C1eWNQgElVtMLwHaHCa46bh6qqYTXl/JvwrdVGgxFmd1jkf1ODHgR+4Xe1v19R84c75k2hQyfv/mOt3uUdYIwrKIQIyzMKkOKec8Ir7MezYduYwJqFBQufWxzq8RHyJ8X474ef/YNtDje31Qg15LpVEordMeTgWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(8936002)(38070700005)(41300700001)(76116006)(66946007)(8676002)(36756003)(66556008)(66446008)(64756008)(66476007)(4326008)(122000001)(26005)(6512007)(54906003)(6916009)(38100700002)(6506007)(86362001)(316002)(2906002)(83380400001)(1076003)(186003)(478600001)(6486002)(5660300002)(2616005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVhWcnlPY1RLa1VXYnVITitkRytrc3pRMkY4RDRYWGZ1WWg5UTNMb2pIR0sr?=
 =?utf-8?B?QSt4TXA0REF3NHE2WThNaWNwNXUyN2lFM1YzVjBER3ZxTGkwT0hxdnRXUDBj?=
 =?utf-8?B?ZlczZnVnMkY4SExHTC9ad1Q1a3U4R1FrZjBaMHRITzN2aW10cVp0bVV6eWtX?=
 =?utf-8?B?QUFxbEwxOTArR1dBdk0wUExGd1ZETDNpUWt5Z2tWT2IrZHZPSDV6N2ZnTjZl?=
 =?utf-8?B?OEFEVXo1aXRBNm9UTW5lYjJVMnEzcGpVaFhLcTd2czBkS2p3RGZXNytFU2Jw?=
 =?utf-8?B?LzhWNkNtdytGYUlUQ2NaODJrTUdWaFpObWFrbmZlVHFWQjB3SnNkSTNPNklY?=
 =?utf-8?B?dWtxNUcydzY5Zzk3c2VjREgyL3JZeitqOWMrTGMzKzd2ZXBhUXdtbitncW1Q?=
 =?utf-8?B?K0lNRUlHZnNSeFYvQjJMUitiWU1nZXpDUGVTcW4ybnV4WWRhUCtPeThOQVBk?=
 =?utf-8?B?dHVBQWc2RGJQVDhQZ2Q4enAwZWtMRmNEMUF5eUJ0ekZHdkd1RFpsYTZDV1ow?=
 =?utf-8?B?VTJKRzJ4cWRWaEpKK2pwSFhhYlVSWG8zNnNreDdnN2R6NVRHL2VLSUxBL2ZO?=
 =?utf-8?B?a3dUNzdySXo1S3c3Zy8zN29jMEhOT01oaXBnV1JRYVd5Q2dLSVpUOHpIV0N2?=
 =?utf-8?B?R3h2ZVl0ck1nejlYVng2WUVNaTJhWGMwa1JVaDk0Z3NKa0xDL3drN2dHcWFz?=
 =?utf-8?B?TERnaEZxeUlXRjJncENSbUdJbUdCaC9iTUM4Y1VmOXluaFRiN0x6WHkzZE5l?=
 =?utf-8?B?QWtXc2V3QXlGZ1JDdmdiRDk5SzExSnlzYUJvYzVHRGhoMnNuRWJ5QVhBc2pp?=
 =?utf-8?B?ekY1bEhrS3lkQ253L01PZGIvTjFjaVRwU3kzT2pESU9TS3JhREY0UGNzNnJW?=
 =?utf-8?B?SzYvb0l2NjhEOGpaNlM3UmIvdlliY0NqS1RzZWg4cldHbFN3bzFpNlFwYkN6?=
 =?utf-8?B?UWsvL05nS0JaQnRPWi9BemhGdmcvV2x0UDFrZVRzSmd1MlB5K2srcDNOZVh3?=
 =?utf-8?B?NkdlMnNUMmFmT2IxY05WNzJ3VFRpZ3NTUmZPdmRya3g1MWpsK2t5UE1Md0FZ?=
 =?utf-8?B?UUlBN2Rpeng0RWFNRnhhWVpRWjM2REhLYmw4bnJyZ1krc2xkTkNDL3Vac005?=
 =?utf-8?B?S3RRY3I0eDI5L3A0WDd2MDFKY1RnSHFkcFFyVkNHckhtYXFKdVZKTncydSt2?=
 =?utf-8?B?NEZCL1BVWHJJMnRXMWttcFlvak1NM1dxTmYyR3pDUHRIb0ZUUk9WRkRnOVh4?=
 =?utf-8?B?QjhRUkFNbHBHRjduQmVqcGxyZEJvekVidzhVZWgxVXlnSVQ3M3dDbWJGMVU3?=
 =?utf-8?B?aFJ1ekwva2EwMkZnS1gwcW40cVIxbjNpemZhalFlT0RaYStjSVMzMlNGQ0ZD?=
 =?utf-8?B?NEkxaWFac1hxcEZTMjN5UkM2M0s0Z2pqRlZzN0JmM0lsR1hhbmRjKzNZUTZw?=
 =?utf-8?B?SWo0cG5aTjJhQ1U1REVkTjJERDM4NVV5VTV1bU5hbkljVXlPekpkSnZVOTln?=
 =?utf-8?B?RjRaZi9KSVhIeCtvTXpTbjkvcjNuWlhnemxsbWFhS1p4TnhPRk5Cc2lVSTAz?=
 =?utf-8?B?SHRYanc3YkpoRnVRMHlBMEJuT0hqRVRqb1Evek1kUm9JSDBseTlKdjNlZ3FT?=
 =?utf-8?B?akc1c3RCM1J0M0RSNmJ3ZWxwcTBPSjRQeE9VRWw1MEhuRlBpb3JJMkZtZ2xT?=
 =?utf-8?B?SExlUVVMbThhcWNPUXlZM2ZwT1h3Ti9EeVBERC8xemlOMjRBOGNZN0NkNm1s?=
 =?utf-8?B?TjUyRjYvSzZKZGhNdnorYis2aUU2TkV5bTN5LzRwdEpDckFNMngyc3dSYVBO?=
 =?utf-8?B?RGZaaEFPamJBMDJTSW14OWFtTzBHeXJvVlVQeVBHOGhVSGc5bzBTZXZMUDRy?=
 =?utf-8?B?NFJQQWt4Wi81VHN5L1Yrcy9HSENRc0ViM0xzWDkrN3V5cHZLSnNyK3hHa0Qr?=
 =?utf-8?B?OHJYTUFpYk5XOHRMWUtxVnV2eGNyQlU0bWFyZm5od2I0ODd5NDFQUDh4cFBK?=
 =?utf-8?B?b2R1Q2tTZXByVk10cmdSbUczY2piSWZtUHhMTVVMTFhwWjdIQng4SnV4cVRr?=
 =?utf-8?B?R1k2dWFkeCtZRjdxbWZGem1OQU1vb0tTMmYwVmVRZTUvN2lkYXJmc3hiSEJS?=
 =?utf-8?Q?jUeb+jWye1KYMz9RZIfHUxa18?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA8974A4F7F0274AAD436A7365060327@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab37f31d-fa0d-4b7a-8c0e-08dac1bfa40e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 19:30:06.1208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PjpzbkcW2eV6+DZu+q+rzj6mLwfZ1hyIjiTQgo35MH/7H9rTdVIinhcUWdtxRd1VSsYppX2r2dKJmDMqpBPiNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7165
X-Proofpoint-ORIG-GUID: e-TUhnI4l0lSP8z0Ei0pihKKOcMr8usk
X-Proofpoint-GUID: e-TUhnI4l0lSP8z0Ei0pihKKOcMr8usk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=884 suspectscore=0 spamscore=0
 adultscore=0 clxscore=1011 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211080124
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBOb3YgMDgsIDIwMjIsIE1pY2hhZWwgR3J6ZXNjaGlrIHdyb3RlOg0KPiBTaW5jZSB0
aGUgcGF0Y2ggYjQ0YzBlN2ZlZjUxICgidXNiOiBkd2MzOiBnYWRnZXQ6IGNvbmRpdGlvbmFsbHkg
cmVtb3ZlDQo+IHJlcXVlc3RzIikgdGhlIGRyaXZlciBpcyBub3cgcmV0dXJuaW5nIGRpZmZlcmVu
dCByZXF1ZXN0IHN0YXR1cyB2YWx1ZXMNCj4gaW4gZGlmZmVyZW50IGNvbmRpdGlvbnMgb2YgZGlz
YWJsZWQgZW5kcG9pbnQgYW5kIHN0b3BwZWQgdHJhbnNmZXJzLg0KPiBUaGUgcGF0Y2ggaG93ZXZl
ciBoYXMgc3dhcHBlZCB0aGUgYWN0dWFsIHN0YXR1cyByZXN1bHRzIHRoZXkgc2hvdWxkDQo+IGhh
dmUuIFdlIGZpeCB0aGlzIG5vdyB3aXRoIHRoaXMgcGF0Y2guDQo+IA0KPiBGaXhlczogYjQ0YzBl
N2ZlZjUxICgidXNiOiBkd2MzOiBnYWRnZXQ6IGNvbmRpdGlvbmFsbHkgcmVtb3ZlIHJlcXVlc3Rz
IikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogTWljaGFl
bCBHcnplc2NoaWsgPG0uZ3J6ZXNjaGlrQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gDQo+IEkg
aGFkIHRoaXMgcGF0Y2ggcHJlcGFyZWQgYWxyZWFkeSwgYnV0IGZvcmdvdCBhYm91dCBpdC4gU29y
cnkgYWJvdXQgdGhlDQo+IGRlbGF5LiBUaGFua3MgZm9yIGNhdGNoaW5nIHVwIG9uIHRoaXMsIFRo
aW5oIQ0KPiANCj4gbWdyDQoNCk5QLCBJIHdhc24ndCBzdXJlIHlvdSB3b3VsZCBwcmVwYXJlIGl0
IGFueSB0aW1lIHNvb24uIEl0IGJyZWFrcyBzb21lIG9mDQpvdXIgdGVzdHMsIHNvIEkgd2VudCBh
aGVhZCBhbmQgcHVzaGVkIHRoZSBmaXguIEdyZWcgYWxyZWFkeSBwaWNrZWQgaXQNCnVwLg0KDQo+
IA0KPiAgZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYyB8IDQgKystLQ0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPiBp
bmRleCBlY2RkYjE0NDg3MWJlYy4uY2Q1YWNlNDM4ZDQwZWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gKysrIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0K
PiBAQCAtMTAyOSw3ICsxMDI5LDcgQEAgc3RhdGljIGludCBfX2R3YzNfZ2FkZ2V0X2VwX2Rpc2Fi
bGUoc3RydWN0IGR3YzNfZXAgKmRlcCkNCj4gIAkJZGVwLT5lbmRwb2ludC5kZXNjID0gTlVMTDsN
Cj4gIAl9DQo+ICANCj4gLQlkd2MzX3JlbW92ZV9yZXF1ZXN0cyhkd2MsIGRlcCwgLUVDT05OUkVT
RVQpOw0KPiArCWR3YzNfcmVtb3ZlX3JlcXVlc3RzKGR3YywgZGVwLCAtRVNIVVRET1dOKTsNCj4g
IA0KPiAgCWRlcC0+c3RyZWFtX2NhcGFibGUgPSBmYWxzZTsNCj4gIAlkZXAtPnR5cGUgPSAwOw0K
PiBAQCAtMjM3NSw3ICsyMzc1LDcgQEAgc3RhdGljIHZvaWQgZHdjM19zdG9wX2FjdGl2ZV90cmFu
c2ZlcnMoc3RydWN0IGR3YzMgKmR3YykNCj4gIAkJaWYgKCFkZXApDQo+ICAJCQljb250aW51ZTsN
Cj4gIA0KPiAtCQlkd2MzX3JlbW92ZV9yZXF1ZXN0cyhkd2MsIGRlcCwgLUVTSFVURE9XTik7DQo+
ICsJCWR3YzNfcmVtb3ZlX3JlcXVlc3RzKGR3YywgZGVwLCAtRUNPTk5SRVNFVCk7DQo+ICAJfQ0K
PiAgfQ0KDQpUaGF0IGRvZXNuJ3QgbG9vayByaWdodC4gV2hhdCBhYm91dCBzb2Z0LWRpc2Nvbm5l
Y3Q/IFdoYXQgY29uZGl0aW9ucw0KdGhhdCBkd2MzX3N0b3BfYWN0aXZlX3RyYW5zZmVycygpIGlz
IGNhbGxlZCB0aGF0J3Mgbm90IHN1cHBvc2VkIHRvDQpyZXR1cm4gLUVTSFVURE9XTj8NCg0KVGhh
bmtzLA0KVGhpbmg=
