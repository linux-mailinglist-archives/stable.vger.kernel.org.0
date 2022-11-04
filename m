Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80144618D95
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 02:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKDBY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 21:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKDBY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 21:24:58 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1CC1C430;
        Thu,  3 Nov 2022 18:24:56 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A3N9V1b007594;
        Thu, 3 Nov 2022 18:24:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=5rPk98mYk0xMISeO91qsS0RNCxvbXkLx6tXXLUtpzDg=;
 b=SA/Aic7mdgmDykz6oLZIWpbcq0j4RU+SXBeGYNIaML0/PoXAUcWUYDBiFtNdfjTBISXA
 VeE56TpTOKmyeD3k/rdR0fiNa4fg2IRz7eFhrhA4VkDloCdPcWMbEprL83fygVcje/XW
 lqmtk/yLK48pEfoj4UPU0eKXuA/gfyGpcu6l4xs4lRYg4PaWpglQMMe28IT+L4MT6Ks0
 UGZnzbiZL464UtZkCBWDLzSs5nODhW+PgKgs+YeEBp1Z3g/neMYl0fPpnv3ePu51t3td
 7XHvpmk3Yw/2O5rHQz1Z05L/oNZ+juBs+LY6+JYhzhNNNd2LM6+maDerxlciQtpCcvtF CQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kmq25ggee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 18:24:38 -0700
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7D9D8400E5;
        Fri,  4 Nov 2022 01:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1667525077; bh=5rPk98mYk0xMISeO91qsS0RNCxvbXkLx6tXXLUtpzDg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=l6QykfJRWyEJClTD/mcQw8iX15ogGLbRr8P6+DxGPjN7hvqDMSeZVbvChZOBMESkd
         WggCkE+41nUxnpf2+uno0YXCBpxjwoVx/B4rGuLYaMG6WJYglhM+YapyvIUxea8tBe
         3JO/DO8GHZ0vm7SgpSv9SGQf4JYTC1RwzFPTYPIXbepYr3vp63EmWSTSxAHa0CGreU
         q11W+OicWKhyJ7nro94sbytrm+UBgvNddXWRRNVCO/GZsIOKBt+EzG7b/kqeaxic7E
         Eg/MJYDIlA283eBpTbMvlCWpLdNAGo6ewL1UCuX1QzuxLs4bqFKwNrh6+DNy2IjSMa
         QnBhL19WW6jhw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 9B8D9A0082;
        Fri,  4 Nov 2022 01:24:36 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id DA04B4006B;
        Fri,  4 Nov 2022 01:24:35 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="kilSQmwE";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ED62kRWcUwu2Dhbl4DhMyoNu/FBxC3XiS5E/xy0CQkmy+z+pmYyGyUM9VDBl4ECca5veBCq+oz801wU2AphPwjnp5duSU0KlrSMsx/LfoR/Fwvf2lWtLEareXsIuAaO7tge89eP1SGLfcsMyvGDsydb3fI2Qjek25i6CI521yY822JUBcRwCTWNayl9+Tz+/gY8XqwAev2Wiya/LYL4AKGWa6zF/huFVc3CwZeOarLe3h3zI+ZS/VSsxtU+4oob224MAwuoLG5IJpoZlMlx75MxAKGiar2DLOHapCJYIu9/CW2d4+sNrF9M3r5gI0l9PE13vJTyqtwAIDbhtfhS3Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rPk98mYk0xMISeO91qsS0RNCxvbXkLx6tXXLUtpzDg=;
 b=mDn9GojgBhmBxYTrx+S5ZhXLk4JdFaNqBqPb63E8ZwAcVPamfW3mb+Bns/J1a1tf/mZRlFWq6XvFnzW/wpLueHZ/6F1imW4G+AD1qA43SI3FcZ4E3XK7aQpwG7f4acn2JRyS17I6IpkPjaE63A4z5F6c6qOBLYu52/KJuGt5y1xPm7KoDiIaOi0f2mM3f63bWhEo3bSLobJgKglF6KxeSuaQdLYllWMp7vJxpBT/vNIGDkLWQ+Fsn3dURU2wjR4VYDpr/6AR2IuPcPBv4wedEYAsP0YplcCTeT4IhRyYLR0UXmiCZBCSKgZrGBO1mXZir0OV4xacpU4ESaz3jl5WcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rPk98mYk0xMISeO91qsS0RNCxvbXkLx6tXXLUtpzDg=;
 b=kilSQmwEIieNDjd9f1oU5rV8WDytvl7lIkMn8nbAZ2BrZTsDAucoqzIBMmZJvVpDho0LtLydx1kt6evv8JzxeLZKlbWakcfc/knEX2H1sL8oVaI/mYO1PMwxNZGNcSV+OA+b81oVNeLkL5vA51jHWvf6Mke5rTeW3lbYNijPGwY=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MW3PR12MB4556.namprd12.prod.outlook.com (2603:10b6:303:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 01:24:30 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::9f62:5df9:ad93:5a1f]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::9f62:5df9:ad93:5a1f%2]) with mapi id 15.20.5769.019; Fri, 4 Nov 2022
 01:24:30 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Johan Hovold <johan+linaro@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "usb: dwc3: disable USB core PHY management"
Thread-Topic: [PATCH] Revert "usb: dwc3: disable USB core PHY management"
Thread-Index: AQHY75MvgyWArbpEZU+cBS0NIaHYP64t+SeA
Date:   Fri, 4 Nov 2022 01:24:30 +0000
Message-ID: <20221104012415.zgasv5hu5l5imslc@synopsys.com>
References: <20221103144648.14197-1-johan+linaro@kernel.org>
In-Reply-To: <20221103144648.14197-1-johan+linaro@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|MW3PR12MB4556:EE_
x-ms-office365-filtering-correlation-id: 6182764e-7030-4a9e-bcc5-08dabe035272
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n/sUHt9yAFChNRUFA3boE06jLFdWujCs8ml8D4Pqn2aUyovQKGr40wmh3dthM0FvJue2/nHLfoFECYgAdZIetgJ4xitkyCRCCw+XNzohycg2PLhRlvQX43KEH4KXD5vYgc1QP1O2XxxZsyDZTosynIbzTAj74osPwd+xU/6lY8Aoc7JXCfusjUR7wwnJ/DQDJe9h1BhaqOsXOQ/JFPv3Zq4F1utV+srZZbxRdvU/bBKaVp0etPMrr3IjSbwmZHjlUh+C0T4H33P2KKaT6WnaoY76PXtIIaVFnr8cE7mDF5w/6PdS7m6lp5BaITApkKcNsj3x57HzVnVOXmvbPtNBYTsx0iefzWIRHbPR6jqjw5EANDJsnsuRk/r90BsJdWcrEX+wJ8NW4cLqrTgsPDGzVc6KIY/f4sR9/bJCKxIlW7KLMhAAmGtsba4Jiy8PJ+cOQGiYXFdKEB34g0fJjYN+sFVbDLTCglAENkiGiRnNTS0Mx3xmVVqOHBMM1Nj65ZZXkVZjijDxQGA5fW54Ipf4DKXiopsVBmT4CQx5H8OwbzjxczIR2JjRIYPqdFgERhD9AIi5ZFVGBxwuqyz31W4elfHjyz0Q/O7xZBlSZ0l4gmki+Of0+Iu0nMd0mJGtrdKRy0qp16hStAV4zzWE9KJe6Iv7ksrFucOH1ugR0nqosFnjS1FH2n4IDAeAa3R4S3IURp6Mn1oBp+039z8owlfpa1NqZvgqEErXQErKK6W2e8ro9oW04Diuwe4mYyJwnumQqs/b0lLvtBvIDJ1WrcM3NdSjsq3N7u42hP+Ho6XFhWo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(186003)(86362001)(4326008)(1076003)(83380400001)(122000001)(38100700002)(38070700005)(2906002)(8936002)(41300700001)(5660300002)(966005)(6486002)(6506007)(2616005)(71200400001)(6512007)(8676002)(76116006)(478600001)(26005)(64756008)(66476007)(66556008)(66446008)(66946007)(316002)(54906003)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkRwbVdTQ1RNMGJoZ2JpS2VRenRwRnd2S1N6UHcxOFhLNEU2UmVPcFpqc1ND?=
 =?utf-8?B?czZWajBUT0E5YjhwM200cnRsOHpSdmMxMm5hOHRMTXVSbUhsSlkxSHEzK2xF?=
 =?utf-8?B?VVZIejNhVjFLK0dDTVczdDNwUVlHeVV5cmdyeTZjK2x1Ky9LWGtrdlRtNnNu?=
 =?utf-8?B?aTgrMGtZdm1YY1dkTkpWUHBxS3hpWkZQdjhxMisrZFUrWkFHazJjdjQ1S2hK?=
 =?utf-8?B?bE9ZSVdEWEpYNURkQ0xzbWRDMEhiaHJnb1kyYTZObWY4d3EwMjk2L2pBYVlC?=
 =?utf-8?B?MWoxY25mMktoNXpMc2ZWWTJjVDVtME1KcUdNOXc5U3VGc0tGNlFnK3JaRk96?=
 =?utf-8?B?RW5sY3pudzZ1T3QraUVtQ2FLOXdBMVJLSlgzQjlkNWhyamF4RDU2NnF3M3BO?=
 =?utf-8?B?U3lZaXJUQTE2L2MvYXlJY0V2ajhHUEpmK2hySThLZnlZOVVhSW81L3lEK3J0?=
 =?utf-8?B?R1NuQ0hrYzZnQ2pHc3dyUGdhKzVsWWlhS2ZCOHkrOVNEVlJBTE1EQzhrcnQ0?=
 =?utf-8?B?WjZKdmhjOXk0V1pyRXlYejBud1VzR0liU2pDVDBja1d0b3dFcTFJNHAweTQr?=
 =?utf-8?B?WllMOVdJaTZjZzQxckZRV2I3ZktUOFcxeHZibmZjQ0VEWlpLcEFOaTcyWXdq?=
 =?utf-8?B?OURscTFpV3hoUk9STDREbWgxblBLR1hoNXRON2J5bEZiWnhWRXBhcEl3bFdU?=
 =?utf-8?B?MGUyUnpBdkF4VEEveWdncTRyM09YOFNMeVhpTXBJL215bVc1VHM0b1N1dTB3?=
 =?utf-8?B?WUhtdUd1TENic2IraEZCN2Q3d1FFUUFvcmUzZ1VQTFM3YW5JYWY4U290NmFz?=
 =?utf-8?B?bWJGSEtpSjNIdStCa2xIMGtEMHdHMml4TWN1NU9zbWRJb1dmSDMrM2VkaXZ0?=
 =?utf-8?B?ZzFhRDdmbXl6NkM2NTlVRHN5OVdSUlRjdWM5QTVoaUk1eVJDMjQ3R2UrUGpp?=
 =?utf-8?B?eGJGQ3pzRmpDcTFNazJCS0ZlNE4wckdObVJaajBPZ1RVTGxGT1hXWktPaHBj?=
 =?utf-8?B?TlRGQ1pSUjM2ZFdnZUpLNEV2QVR4VTVuMk5Fd2ZhV2lnY0FOUzZzWDZLaW1o?=
 =?utf-8?B?cTcyZWdkc3RNRnc2Q0QwSllKODg1M2E1NkZzdVR1Mmd0eVorRUhjR2xreGNF?=
 =?utf-8?B?b3BIQUludSs2cFFpTVUzZCs2dHpCY29aSG1LNEtwNHlQL1k4NU1JbDBYa0FC?=
 =?utf-8?B?U2JXZyt6SWVTMC9Pb0lJU3RMcXQ0K3ZCSUhiWWZONFRIcFNsWXdHZHFVRm5G?=
 =?utf-8?B?M2puc1JEZEh2bXhSd2gwM0s5R3VOaUdqZExzNXVaV2cwckR4cHJIdGNQNGxH?=
 =?utf-8?B?WTNQejNiZ3dJVU9uRmVGM2tUeGtUMHRrN0pjRElmZzJGVWlyczlVcmt1M04z?=
 =?utf-8?B?dTJBUWlBY1lZVmQyaFo4WGsyWnJLVW0rQU5lYnc2RXhtM2NhQ1pwSVhGNzlz?=
 =?utf-8?B?aGZ4ZDJJRm50azB6N0x4Qi9lM0huUkR4RDVIcTRnK2NKWDNzNmo1WDdkOUFF?=
 =?utf-8?B?UXlGZE10bnlGYkRPUkZwZ3grSFp0Nyt0T25YV0xNMERIVXBMV1A5NUFNQ1Uw?=
 =?utf-8?B?MmxhWnZ6bVdhVDhscU5uSGdEd2RlczBmWG1rdkdVUWpmNWd6bXh6TDNqVVVq?=
 =?utf-8?B?aVdMZHVRMnczdCtBWmI1K0pmOGR0dnNsS2kySzlSd095b1BxS2NCNnFZTHUr?=
 =?utf-8?B?MGlnbDNYTEpucGlqODRRc21vb3ZTenVrc1FjRWpHMnhYTEZ3MGgrdVVuNk9k?=
 =?utf-8?B?WU4zcnpYWnhwRUNJUjF6aUdUTUd5a0N1d2pKZUcyMVc5RDJLcTUwbElLUnJy?=
 =?utf-8?B?Q3lzZk1uUElvd1ROY3FnYUloU2lrTVQyaWNCYVBXd3BVR3hDMlgxWExMT1hR?=
 =?utf-8?B?SFRRQzh6cHdjSExYekNhRmNmdTFKdkJrVVVkYTA0emdVZFVLRzMvTFRyelpC?=
 =?utf-8?B?cnp2R2JkbmJ0M3hnQnEzbnNQbWpzaEhHYkxNQ1FUUUJHcXNyKytaTDd2R1dK?=
 =?utf-8?B?OFNSWDMrRzdJdjlKdTVzMFpuSDFWVm9LRXd1bDQxRFBMbUs3bklocWxSYTM5?=
 =?utf-8?B?MTY0UmRjQ1RHdTE4WGZBOE1rOVBFaG9iSFRpVURVOTBEcnJpaFVWSmVUNlVZ?=
 =?utf-8?Q?zV37jDPzjWqqFZQnenaVk/yxA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87D030BC7C7ACF478A6A7A3B822330E7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6182764e-7030-4a9e-bcc5-08dabe035272
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 01:24:30.3152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TKW3TyWi+SJGElEEzUWfdkTG5Eja6tSOeCF2GSoW1/RgmlWS81gRuTZqnwxl7FUJrddfkXdY7AwX3HfFAoHiOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4556
X-Proofpoint-GUID: rVX1Ol2spwYVJ-a1FS5RX3-QcN0Nj0b6
X-Proofpoint-ORIG-GUID: rVX1Ol2spwYVJ-a1FS5RX3-QcN0Nj0b6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_01,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=653 bulkscore=0 clxscore=1011 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040008
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBOb3YgMDMsIDIwMjIsIEpvaGFuIEhvdm9sZCB3cm90ZToNCj4gVGhpcyByZXZlcnRz
IGNvbW1pdCA2MDAwYjhkOTAwY2Q1ZjUyZmJjZDA3NzZkMGNjMzk2ZTg4YzhjMmVhLg0KPiANCj4g
VGhlIG9mZmVuZGluZyBjb21taXQgZGlzYWJsZWQgdGhlIFVTQiBjb3JlIFBIWSBtYW5hZ2VtZW50
IGFzIHRoZSBkd2MzDQo+IGFscmVhZHkgbWFuYWdlcyB0aGUgUEhZcyBpbiBxdWVzdGlvbi4NCj4g
DQo+IFVuZm9ydHVuYXRlbHkgc29tZSBwbGF0Zm9ybXMgaGF2ZSBzdGFydGVkIHJlbHlpbmcgb24g
aGF2aW5nIFVTQiBjb3JlDQo+IGFsc28gY29udHJvbGxpbmcgdGhlIFBIWSBhbmQgdGhpcyBpcyBz
cGVjaWZpY2FsbHkgY3VycmVudGx5IG5lZWRlZCBvbg0KPiBzb21lIEV4eW5vcyBwbGF0Zm9ybXMg
Zm9yIFBIWSBjYWxpYnJhdGlvbiBvciBjb25uZWN0ZWQgZGV2aWNlIG1heSBmYWlsDQo+IHRvIGVu
dW1lcmF0ZS4NCj4gDQo+IFRoZSBQSFkgY2FsaWJyYXRpb24gd2FzIHByZXZpb3VzbHkgaGFuZGxl
ZCBpbiB0aGUgZHdjMyBkcml2ZXIsIGJ1dCB0bw0KPiB3b3JrIGFyb3VuZCBzb21lIGlzc3VlcyBy
ZWxhdGVkIHRvIGhvdyB0aGUgZHdjMyBkcml2ZXIgaW50ZXJhY3RzIHdpdGgNCj4geGhjaSAoZS5n
LiB1c2luZyBtdWx0aXBsZSBkcml2ZXJzKSB0aGlzIHdhcyBtb3ZlZCB0byBVU0IgY29yZSBieSBj
b21taXRzDQo+IDM0YzdlZDcyZjRmMCAoInVzYjogY29yZTogcGh5OiBhZGQgc3VwcG9ydCBmb3Ig
UEhZIGNhbGlicmF0aW9uIikgYW5kDQo+IGEwYTQ2NTU2OWI0NSAoInVzYjogZHdjMzogcmVtb3Zl
IGdlbmVyaWMgUEhZIGNhbGlicmF0ZSgpIGNhbGxzIikuDQo+IA0KPiBUaGUgc2FtZSBQSFkgb2J2
aW91c2x5IHNob3VsZCBub3QgYmUgY29udHJvbGxlZCBmcm9tIHR3byBkaWZmZXJlbnQNCj4gcGxh
Y2VzLCB3aGljaCBmb3IgZXhhbXBsZSBkbyBubyBhZ3JlZSBvbiB0aGUgUEhZIG1vZGUgb3IgcG93
ZXIgc3RhdGUNCj4gZHVyaW5nIHN1c3BlbmQsIGJ1dCBhcyB0aGUgb2ZmZW5kaW5nIHBhdGNoIHdh
cyBiYWNrcG9ydGVkIHRvIHN0YWJsZSwNCj4gbGV0J3MgcmV2ZXJ0IGl0IGZvciBub3cuDQo+IA0K
PiBSZXBvcnRlZC1ieTogU3RlZmFuIEFnbmVyIDxzdGVmYW5AYWduZXIuY2g+DQo+IExpbms6IGh0
dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzgw
OGJkYmE4NDZiYjYwNDU2YWRmMTBhMzAxNjkxMWVlQGFnbmVyLmNoL19fOyEhQTRGMlI5R19wZyFh
bEhvSUNLUUlHZzNSZWxELXRYT3N3Zk5CR3kzUXRMVTRlOWphemZYc2hYajFXZVlGOExNZ3liYnFI
RHJmc3pheko5eXdhMUJkVlgwaThnZXdMVW1ydnoyX214WCQgDQo+IEZpeGVzOiA2MDAwYjhkOTAw
Y2QgKCJ1c2I6IGR3YzM6IGRpc2FibGUgVVNCIGNvcmUgUEhZIG1hbmFnZW1lbnQiKQ0KPiBDYzog
c3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbiBIb3ZvbGQgPGpv
aGFuK2xpbmFyb0BrZXJuZWwub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvdXNiL2R3YzMvaG9zdC5j
IHwgMTAgLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGRlbGV0aW9ucygtKQ0KPiAN
Cg0KQWNrZWQtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5bm9wc3lzLmNvbT4NCg0K
VGhhbmtzLA0KVGhpbmg=
