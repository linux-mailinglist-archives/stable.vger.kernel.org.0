Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294EF623B5B
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 06:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiKJFjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 00:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiKJFjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 00:39:03 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A073A19B;
        Wed,  9 Nov 2022 21:38:58 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AA4BcPh018883;
        Wed, 9 Nov 2022 21:38:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=Qa+6jVPUCrsjSgBhbktGCjmZa+UzXqniB+cz9bwsY5o=;
 b=M1tHbSFJzOBfNRN42tLM6RC9WjUJC7WxgNvmVPV5oN9KFyfitA/TwKdGofgIBp45s4se
 Z/9ESRzT+s3QRbyi54zSW7ssl0Mhv+L8PUjAegom2sWw4s33X1bWK3fGbtJLZITGYeos
 xMQI8d+rauBkDYJ6w0ikMH/ECWz/umTvNx3tFeVowiuPULp4Ra1hRPPk4P+5vmoW7LAQ
 Z0RKKn/cn4B18pXXr1+O/gEZbjvW58Mx2zl1X2VhAm4BamUdDxafuTRc2lE4FlPchvvF
 8ilkSFm+WNk+X4WsgzQTml7gsiQDOIubxf8bqa8LrY0BUEfdasRRHeb09YswOdzi7LzB vA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3krs1xgkmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 21:38:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFaP50umR7faZHdJi55ESCshY4INhvY/N/dCdGdUxWDdgirCRrgfsFaPZOFu6MPgZQGCNo89bLc/rTeP4dnO9z+2lBTPSRBYHFNFOJlaF3BIQQISeAogLvqBTTgoUOFeJAE+5TJfiwvRcAdAiknyAe29NjaON7r+3Pi/mkYvykyFuDqeXcgpzvut1UAxLkxIBuLkNl+WianRFbh5eJodeRHfWnaBMNwFC5hiQJ88OlALG5k4QGDcE7H3lqR8wW4S0/RReMeYA0qgyjRbAcsthaMMDsWWh8EAtfIWOr1QfVRxalniA6LRsIn5x2h6yy+1Cg7MKZv/vdud8GyqNzsSBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qa+6jVPUCrsjSgBhbktGCjmZa+UzXqniB+cz9bwsY5o=;
 b=TtjTZemJYU2RhQpGwgNbcAlE7DFUr/mAO48a9RDAGYQxZj18Kse5txlLSXFQf0TG+uT25juUkcFkegctpseGuHI8AtksefO9VacdbVZnikQR8/leAs6+Etc9FVjw0xh09JP1MNrN2pdJjpqeb0yEq/NGFsZLBrPPO0p9CTSd333kDsO+FbbVNEu+ZMmXcp37OPiTkRWPDTSKRqR8OQUFOxDVQu/hVvdG8n3He1gFlW7daVd/cIXbtdBLKVNRpQLzBEGzT224cDr5F50k7/WIANr+ipCtPeWQEFUi1tOPbbz++F2W0BwhKyCP/FM8lPQeUaOoIC8jhm4FpfKqrSe0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qa+6jVPUCrsjSgBhbktGCjmZa+UzXqniB+cz9bwsY5o=;
 b=4W1dXhx3HG7fbqoUUkMDvVnxQ5IodWtE3xNyHmppoiuX+iiMRnIzYpSqFwNQKfoQyBEh5+kj9OLg4vexqJrZQzd2NdkDEk/PH17FhpF1Xg65j7TE5KDV1P+5DPK1YSTDikuVNGZsfNzhjtivMm3gVJ6PZGO6w41bWtPV0B7PtNs=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BYAPR07MB5607.namprd07.prod.outlook.com (2603:10b6:a03:a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 10 Nov
 2022 05:38:43 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 05:38:43 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <hzpeterchen@gmail.com>
CC:     Peter Chen <peter.chen@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY57Ge68RMVQuhaUeO0fOrXMci/K4h2uCAgAAVsiCAD7z/gIABUoKQgARwzACAAEix4A==
Date:   Thu, 10 Nov 2022 05:38:42 +0000
Message-ID: <BYAPR07MB53818794749C701BD908D112DD019@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <1666620275-139704-1-git-send-email-pawell@cadence.com>
 <20221027072421.GA75844@nchen-desktop>
 <BYAPR07MB5381482129407B849BA9A616DD339@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20221106090221.GA152143@nchen-desktop>
 <BYAPR07MB5381CD42617915D95122D56FDD3C9@BYAPR07MB5381.namprd07.prod.outlook.com>
 <CAL411-qttOGNyZH28bURje0Y3_zVF4XuzVS1zQh2DgPNN0smWw@mail.gmail.com>
In-Reply-To: <CAL411-qttOGNyZH28bURje0Y3_zVF4XuzVS1zQh2DgPNN0smWw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctZWRhNjk3ZmUtNjBiOS0xMWVkLWE4NGMtMDBiZTQzMTQxNTFlXGFtZS10ZXN0XGVkYTY5ODAwLTYwYjktMTFlZC1hODRjLTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iNTU2MCIgdD0iMTMzMTI1MzIzMjAwNzY2ODIzIiBoPSJaWGVRSjVsTjJxUzdvZnRRSzFJM0xnSHNnWEE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|BYAPR07MB5607:EE_
x-ms-office365-filtering-correlation-id: a1970d9c-25e5-430c-77d8-08dac2ddd42b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xE7+ZZ1826wuByvD3qgDY8dgHaYmiS389oP4xC88ItOqw9DQrML7DG91XaOA59VF7BjYD2xIEIXOVPCRDUVxgSIUGmZJfIs2Oot5bKBRWrSCehnJZeTa2o7OjecmMONMopPwA6MzyVGYsRwdkWQGIqELyMXoklp+rKTc/rrZ36LXoII11IikEFZtxbHPOLLGPl51Jc4FHVpH825mB3stPOjmVEKGUkrhCqvE9iu9hwES578I1M3vLTvFn8PVgaBzWRH4+iiaK0EnYdbR8zwt497zFCU7P18HiMan2y1k97TKrxg3Zcz7B07ELGvlHKQ52x6eHQlXXOTm6lsvZrxaV69GDU//Ylx3sBkuu1+SpDpoeQIelkhAS7A8izU4+XZtVm2i2sNd1b3hkJS4bjxvv2Fe0OlcjA0IcYz/Glj7aY1Wh3y6E8tBRSNvllHE/J/GxEUlLXLftOzNvgPkhsiJeMEJG/xzl9su3xrARdPU0shNinstWs4KxhnmqIrFIGSq7/lK7m6UgnGwnDXyhe6gSM8QBZySOfD87r4AvYFhaO2XJgPML7DUbMLQlhcitJf2PfkY9E5W9ZmsU28AhHCwk+/Nm7MPAoZmiwWYAd+qPhghkB1gfzQAqZ+o0Lw/Gab/H+uJ9jm5GZAXH1N5F9AE4LemiTDEPxqraancIzERZzgoea05Q+GLGlaY7Iw985TifNvWybrDG+99J33LkERS3WE6p/CK1EbQSqQY63w7YEXx1brM2wQCjEq9WpUor3OVvCI4IKG8lrN+QsJuRTlmbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(36092001)(451199015)(38070700005)(86362001)(122000001)(7696005)(76116006)(55016003)(2906002)(5660300002)(26005)(186003)(6506007)(9686003)(38100700002)(83380400001)(66946007)(33656002)(6916009)(8936002)(71200400001)(64756008)(66476007)(66556008)(41300700001)(52536014)(66446008)(8676002)(4326008)(54906003)(316002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dE9kOFNON2hEbXFVd21lNy8vUWJaTkN4ZFZERmRIWUQwNG1GOU5qc0UvTWp1?=
 =?utf-8?B?ZzBhbVFadVFXdnV6SmZEa3Z2b0pTanI3MDVMMmZMZ3hPOWF5RTh3TUk1LzR2?=
 =?utf-8?B?QzBxdGhsSkVqdHRlSndDUEpVeFZkeVFha2lLVnd4Z0MrOXA2eDNpbDZZZThv?=
 =?utf-8?B?TEw4SGJYWnRERUQ0NXc2UFF1SzRrQ0lpUTlJa3MxRDZxSHFPRzIrSzZKb1Ez?=
 =?utf-8?B?Mi9YOWtFamt5b0ZvdjVXamRkbDdwRzN1ZUs5UDNyYmxhREZSWDZaVkZMcVRl?=
 =?utf-8?B?M2Y1RGMrVDRENWdNTHJjd1k4QVRlUHhVT0hZRHpDbWJQbWJNSkFsY0djRkEx?=
 =?utf-8?B?YUxOc044RUtOOUtteEZZY0VZamppT2VsUUJPQ241alpVWWovdFYwNFVBdGhr?=
 =?utf-8?B?cEpDMG8rRkRRTnFsV2RSR1R1eEVQUkhjeW56bU8vTGhCb3hUYnphQThua0N6?=
 =?utf-8?B?QXk5TGdtZWVBb2JDR0IxNCtlcnlSWFZwN1RxSmRtS3BzRUp4OGhrTnBSOVlN?=
 =?utf-8?B?UVhIZXlzdDVkbWJBaERHTjVXdnBPOEdCRC9vYUcycjc3T0hTcm1Pb2toUlcx?=
 =?utf-8?B?MW95QWREWU9VOUQwZk1VdEQyY0cxZlZhZFFXV2RFWElUZkVaZ3NwcjA2QVRJ?=
 =?utf-8?B?QVBxSkl2UnkvZWlKd2g2VXR4Z3RZbnBiRGxzU1VITmUzUVFUK2QxOGd0TGxw?=
 =?utf-8?B?dVZPbVNpWXFGVnNaT0pha3oycVJmRGhhUDIyUE5YTERzSi9BSUttdHRWM3Zv?=
 =?utf-8?B?RVNMVEZkSXc2a0dKWXhOMThIaWRYTXZkNjZyT1VUdFlsci9FRlpMRE91QzRN?=
 =?utf-8?B?WEZKT211RFJQaHlrRkwvVHc1cjVSY1hKbHViMXFvbU9NeFgySXBXS0NCTy8z?=
 =?utf-8?B?REdDdWVBYXJ4YlV3TVVQTmxKbnhpVkFxbEZxWkszZnNHeVMySWFYcVBGZEw5?=
 =?utf-8?B?ZWhWM3RiQWtrUWNVdEpxYTBwNjhXRkJUdlhZMkNMQUVJNm5oNEtqMndDc2Rl?=
 =?utf-8?B?TkpwbmR3Z1pkUVBWdnBBeWU0K05PSG1RTlJ3cnBOSlB3ZnVlM2F2dzduSTAv?=
 =?utf-8?B?RTROSUd4ZWk3QmJ4YTdiQmFTQ2hYeU1qSUFvaUtlcndUVTB2Qk5XS242ZUli?=
 =?utf-8?B?dWFOclZQc085bVBjVWhETlprQzdOdG1Kb3NQUGx2Sm92NC9aT1FMZ01jTExu?=
 =?utf-8?B?NU8vb00wamJrTzRFWnZNWjFsaDd4S2JpYmVtTlVzV2pMOXI5aXIwUlVCaHVn?=
 =?utf-8?B?c2pQdW1lckg1ZFNNUVZtZ2ZmQ2c2emxQMjZKUnBVdDFTSm5mTWliOUNHWU5o?=
 =?utf-8?B?N1ZXdFFYK1BrZjJjQ3YwNmFaclhONXFLOW5XV0lVcU9mbnV2eVcwTWg0QU4r?=
 =?utf-8?B?cUJpL3lSbE1SNEMrRkVaanduRmRoenU3cDNka0xoTnhIWk9aYXBSYS9tTzNl?=
 =?utf-8?B?RlFOQmpwZ2dmUGt6ak9FdFdJeTZjYmw5Wms3TmYrMU1qZGVRZVFSMHRHMjNp?=
 =?utf-8?B?b2JvejFMSzhOUEtrSURnR042T2prdm1vNnFxRzIwOE8zdS8wdkxlN0V2RWhX?=
 =?utf-8?B?MWNINUFSVDQwUko0dis0a0xlR0d2emhkc2YyYUYzWEJIOXRGcCtVVmQwM1RS?=
 =?utf-8?B?bVZERmdzU2liWVhZSWdoQjRnSitUSmd4OHlaaTJSZDV3RDAxNnY4cHIzUmVm?=
 =?utf-8?B?bk9uQVpYcXJKYTN6ajRBQ1FLanBTaGxsQUxoa2RXdmZQY2RUbDB0NEVRaVY4?=
 =?utf-8?B?YmtaTlRiVTdOT2plRjUweFVnNzdvWW4vUlgvQkFBbUtab29EYlVuNkwySnBs?=
 =?utf-8?B?NFB6NjVJNDRKMi9JdE5aZGdnS093NWQrbk1yS1ovZ292ZCt5eGNPWWo3SjZE?=
 =?utf-8?B?WGpLYytEMWFJYUdtQkNCZlVHVXpLNDE0b252cUc5QWNPYVlleU9PN1ZRSWRK?=
 =?utf-8?B?ZmwzYTR2eWdCamhsTXRWYkJ5RGplRWR1MkduUDBpUEFIN2xGaDYxZnBCSmZw?=
 =?utf-8?B?bmVqbzdzQVBWYmtrYXpCWHh0QXhRTmhpalVGU2ZMbzR6c1dzTEdMWm56Vko2?=
 =?utf-8?B?SSsvbFVUd25nTTRsK0U3cGpqcDRERk8xTmpUeVB1dEdzOGRRM2R5U25kcTdO?=
 =?utf-8?B?UjA1ZTVDbEx3STF2ZnFSRzdIMHhMZ3JENzViSmNTRG9kUEZHeXhPeVovdHFQ?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1970d9c-25e5-430c-77d8-08dac2ddd42b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 05:38:42.8901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EP/mLfXOOyT7hkMYzwhyGF0S5Grm5iLdqiBXyG+X4khYbIrtrITWQGvFVXAkC16+609PqcbyuB6ylpQMUQPL+7TAHY04N6NT/ymkwd34MHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5607
X-Proofpoint-GUID: P-Yv4y74GLwRfuXsT09g-W1-7J-46YyL
X-Proofpoint-ORIG-GUID: P-Yv4y74GLwRfuXsT09g-W1-7J-46YyL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 impostorscore=0
 adultscore=0 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 clxscore=1011 mlxlogscore=458 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100041
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pk9uIE1vbiwgTm92IDcsIDIwMjIgYXQgMTozOSBQTSBQYXdlbCBMYXN6Y3phayA8cGF3ZWxsQGNh
ZGVuY2UuY29tPg0KPndyb3RlOg0KPj4NCj4+ID4NCj4+ID4NCj4+ID5PbiAyMi0xMC0yNyAwODo0
NjoxNywgUGF3ZWwgTGFzemN6YWsgd3JvdGU6DQo+PiA+Pg0KPj4gPj4gPg0KPj4gPj4gPk9uIDIy
LTEwLTI0IDEwOjA0OjM1LCBQYXdlbCBMYXN6Y3phayB3cm90ZToNCj4+ID4+ID4+IFBhdGNoIG1v
ZGlmaWVzIHRoZSBURF9TSVpFIGluIFRSQiBiZWZvcmUgWkxQIFRSQi4NCj4+ID4+ID4+IFRoZSBU
RF9TSVpFIGluIFRSQiBiZWZvcmUgWkxQIFRSQiBtdXN0IGJlIHNldCB0byAxIHRvIGZvcmNlDQo+
PiA+PiA+PiBwcm9jZXNzaW5nIFpMUCBUUkIgYnkgY29udHJvbGxlci4NCj4+ID4+ID4+DQo+PiA+
PiA+PiBjYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+PiA+PiA+PiBGaXhlczogM2Q4Mjkw
NDU1OWY0ICgidXNiOiBjZG5zcDogY2RuczMgQWRkIG1haW4gcGFydCBvZiBDYWRlbmNlDQo+PiA+
PiA+PiBVU0JTU1AgRFJEIERyaXZlciIpDQo+PiA+PiA+PiBTaWduZWQtb2ZmLWJ5OiBQYXdlbCBM
YXN6Y3phayA8cGF3ZWxsQGNhZGVuY2UuY29tPg0KPj4gPj4gPj4NCj4+ID4+ID4+IC0tLQ0KPj4g
Pj4gPj4gQ2hhbmdlbG9nOg0KPj4gPj4gPj4gdjI6DQo+PiA+PiA+PiAtIHJldHVybmVkIHZhbHVl
IGZvciBsYXN0IFRSQiBtdXN0IGJlIDANCj4+ID4+ID4+DQo+PiA+PiA+PiAgZHJpdmVycy91c2Iv
Y2RuczMvY2Ruc3AtcmluZy5jIHwgNyArKysrKystDQo+PiA+PiA+PiAgMSBmaWxlIGNoYW5nZWQs
IDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4gPj4gPj4NCj4+ID4+ID4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3VzYi9jZG5zMy9jZG5zcC1yaW5nLmMNCj4+ID4+ID4+IGIvZHJpdmVy
cy91c2IvY2RuczMvY2Ruc3AtcmluZy5jIGluZGV4DQo+PiA+PiA+PiAwNGRmY2FhMDhkYzQuLmFh
NzliY2U4OWQ4YQ0KPj4gPj4gPj4gMTAwNjQ0DQo+PiA+PiA+PiAtLS0gYS9kcml2ZXJzL3VzYi9j
ZG5zMy9jZG5zcC1yaW5nLmMNCj4+ID4+ID4+ICsrKyBiL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnNw
LXJpbmcuYw0KPj4gPj4gPj4gQEAgLTE3NjksOCArMTc2OSwxMyBAQCBzdGF0aWMgdTMyIGNkbnNw
X3RkX3JlbWFpbmRlcihzdHJ1Y3QNCj4+ID4+ID4+IGNkbnNwX2RldmljZSAqcGRldiwNCj4+ID4+
ID4+DQo+PiA+PiA+PiAgIC8qIE9uZSBUUkIgd2l0aCBhIHplcm8tbGVuZ3RoIGRhdGEgcGFja2V0
LiAqLw0KPj4gPj4gPj4gICBpZiAoIW1vcmVfdHJic19jb21pbmcgfHwgKHRyYW5zZmVycmVkID09
IDAgJiYgdHJiX2J1ZmZfbGVuID09IDApIHx8DQo+PiA+PiA+PiAtICAgICB0cmJfYnVmZl9sZW4g
PT0gdGRfdG90YWxfbGVuKQ0KPj4gPj4gPj4gKyAgICAgdHJiX2J1ZmZfbGVuID09IHRkX3RvdGFs
X2xlbikgew0KPj4gPj4gPj4gKyAgICAgICAgIC8qIEJlZm9yZSBaTFAgZHJpdmVyIG5lZWRzIHNl
dCBURF9TSVpFPTEuICovDQo+PiA+PiA+PiArICAgICAgICAgaWYgKG1vcmVfdHJic19jb21pbmcp
DQo+PiA+PiA+PiArICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4+ID4+ID4+ICsNCj4+ID4+
ID4+ICAgICAgICAgICByZXR1cm4gMDsNCj4+ID4+ID4+ICsgfQ0KPj4gPj4gPg0KPj4gPj4gPkRv
ZXMgdGhhdCBmaXggdGhlIGlzc3VlIHlvdSB3YW50IGF0IGJ1bGsgdHJhbnNmZXIsIHdoaWNoIGhh
cw0KPj4gPj4gPnplcm8tbGVuZ3RoIHBhY2tldCBhdCB0aGUgbGFzdCBwYWNrZXQ/IEl0IHNlZW1z
IG5vdCBhbGlnbiB3aXRoDQo+PiA+PiA+eW91ciBwcmV2aW91cw0KPj4gPmZpeC4NCj4+ID4+ID5X
b3VsZCB5b3UgbWluZCBleHBsYWluaW5nIG1vcmU/DQo+PiA+Pg0KPj4gPj4gVmFsdWUgcmV0dXJu
ZWQgYnkgZnVuY3Rpb24gY2Ruc3BfdGRfcmVtYWluZGVyIGlzIHVzZWQgYXMgVERfU0laRSBpbg0K
Pj4gPj4gVFJCLg0KPj4gPj4NCj4+ID4+IFRoZSBsYXN0IFRSQiBpbiBURCBzaG91bGQgaGF2ZSBU
RF9TSVpFPTAsIHNvIHRyYiBmb3IgWkxQIHNob3VsZA0KPj4gPj4gaGF2ZSBzZXQgYWxzbyBURF9T
SVpFPTAuIElmIGRyaXZlciBzZXQgVERfU0laRT0wIG9uIGJlZm9yZSB0aGUgbGFzdA0KPj4gPj4g
b25lIFRSQiB0aGVuIHRoZSBjb250cm9sbGVyIHN0b3BzIHRoZSB0cmFuc2ZlciBhbmQgaWdub3Jl
IHRyYiBmb3IgWkxQDQo+cGFja2V0Lg0KPj4gPj4NCj4+ID4+IFRvIGZpeCB0aGlzLCB0aGUgZHJp
dmVyIGluIHN1Y2ggY2FzZSBtdXN0IHNldCBURF9TSVpFID0gMSBiZWZvcmUNCj4+ID4+IHRoZSBs
YXN0IFRSQi4NCj4+ID4NCj4+ID4gICAgICAgaWYgKCFtb3JlX3RyYnNfY29taW5nIHx8ICh0cmFu
c2ZlcnJlZCA9PSAwICYmIHRyYl9idWZmX2xlbiA9PSAwKSB8fA0KPj4gPiAtICAgICAgICAgdHJi
X2J1ZmZfbGVuID09IHRkX3RvdGFsX2xlbikNCj4+ID4gKyAgICAgICAgIHRyYl9idWZmX2xlbiA9
PSB0ZF90b3RhbF9sZW4pIHsNCj4+ID4gKyAgICAgICAgICAgICAvKiBCZWZvcmUgWkxQIGRyaXZl
ciBuZWVkcyBzZXQgVERfU0laRT0xLiAqLw0KPj4gPiArICAgICAgICAgICAgIGlmIChtb3JlX3Ry
YnNfY29taW5nKQ0KPj4gPiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDE7DQo+PiA+ICsN
Cj4+ID4gICAgICAgICAgICAgICByZXR1cm4gMDsNCj4+ID4gKyAgICAgfQ0KPj4gPg0KPj4gPkhv
dyB5b3VyIGFib3ZlIGZpeCBjb3VsZCByZXR1cm4gVERfU0laRSBhcyAxIGZvciBsYXN0IG5vbi1a
TFAgVFJCPw0KPj4gPldoaWNoIGNvbmRpdGlvbnMgYXJlIHNhdGlzZmllZD8NCj4+DQo+PiBGb3Ig
bGFzdCBub24tWkxQIFRSQiBURF9TSVpFIHNob3VsZCBiZSAwIG9yIDEuDQo+Pg0KPj4gV2UgaGF2
ZSB0aHJlZSBjYXNlc3M6DQo+PiAxLg0KPj4gICAgICAgICBUUkIxIC0gbGVuZ3RoID4gMQ0KPj4g
ICAgICAgICBUUmIyIC0gWkxQDQo+Pg0KPj4gSW4gdGhpcyBjYXNlIFRSQjEgc2hvdWxkIGhhdmUg
c2V0IFREX1NJWkUgPSAxLiBJbiB0aGlzIGNhc2UgdGhlIGNvbmRpdGlvbg0KPj4gICAgICAgICBp
ZiAobW9yZV90cmJzX2NvbWluZykNCj4+ICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4+DQo+
PiByZXR1cm5zIFREX1NJWkU9MS4gSW4gdGhpcyBjYXNlIG1vcmVfdHJiX2NvbW1pbmcgZm9yIFRS
QjEgaXMgMSBhbmQgZm9yDQo+PiBUUkIyIGlzIDANCj4+DQo+DQo+VGhpcyBvbmUgaXMgbXkgcXVl
c3Rpb24uIEhvdyBiZWxvdyBjb25kaXRpb24gaXMgdHJ1ZSBmb3IgeW91ciBjYXNlIDE6DQo+DQo+
IGlmICghbW9yZV90cmJzX2NvbWluZyB8fCAodHJhbnNmZXJyZWQgPT0gMCAmJiB0cmJfYnVmZl9s
ZW4gPT0gMCkgfHwNCj4gICAgICAgICAgdHJiX2J1ZmZfbGVuID09IHRkX3RvdGFsX2xlbikNCg0K
Rm9yIFRSQjE6DQogICBtb3JlX3RyYnNfY29taW5nID0gdHJ1ZQ0KICAgdHJhbnNmZXJyZWQgPT0g
MCAmJiB0cmJfYnVmZl9sZW4gPT0gMCAgLSBmYWxzZSAtIGl0IGRvZXMgbm90IG1hdHRlciBpbiB0
aGlzIGNhc2UNCiAgIHRyYl9idWZmX2xlbiA9PSB0ZF90b3RhbF9sZW4gLSB0cnVlIA0KICBzbyB3
aG9sZSBjb25kaXRpb24gaXMgdHJ1ZS4NCiANCiAgQmVjYXVzZSBtb3JlX3RyYl9jb21taW5nID0g
dHJ1ZSBzbzoNCiAgICAgICAgICAgICBpZiAobW9yZV90cmJzX2NvbWluZykNCiAgICAgICAgICAg
ICAgICAgICAgICAgIHJldHVybiAxOw0KcmV0dXJucyBURF9TSVpFID0gMQ0KDQpGb3IgVFJCMiAt
IFpMUDoNCiAgIG1vcmVfdHJic19jb21pbmcgPSBmYWxzZQ0KICAgdHJhbnNmZXJyZWQgPT0gMCAm
JiB0cmJfYnVmZl9sZW4gPT0gMCAgLSBmYWxzZSAtIGl0IGRvZXMgbm90IG1hdHRlciBpbiB0aGlz
IGNhc2UNCiAgIHRyYl9idWZmX2xlbiA9PSB0ZF90b3RhbF9sZW4gLSB0cnVlDQoNCiAgQmVjYXVz
ZSBtb3JlX3RyYl9jb21taW5nID0gZmFsc2Ugc28gZnVuY3Rpb24gcmV0dXJucyBURF9TSVpFID0g
MCAgZm9yIGxhc3QgWkxQIHRyYi4NCg0KUGF3ZWwNCg0KPg0KPlBldGVyDQo+DQo+DQo+DQo+Pg0K
Pj4gMi4NCj4+ICAgICAgICAgVFJCMSAtIGxlbmd0aCA+MSBhbmQgd2UgZG9uJ3QgZXhjZXB0IFpM
UA0KPj4NCj4+IEluIHRoaXMgY2FzZSBURF9TSVpFIHNob3VsZCBiZSBzZXQgdG8gMCBmb3IgVFJC
MSBhbmQgZnVuY3Rpb24gcmV0dXJucyAwLA0KPm1vcmVfdHJic19jb21taW5nIGZvciBUUkIxIHdp
bGwgYmUgc2V0IHRvIDAuDQo+Pg0KPj4gMyBNb3JlIFRSQnMgd2l0aG91dCBaTFA6DQo+PiAgICAg
ICAgIGUuZy4NCj4+ICAgICAgICAgVFJCMSAgLSAgbGVuZ3RoID4gMCwgIG1vcmVfdHJic19jb21t
aW5nID0gMSAtIFREX1NJWkUgID4gMA0KPj4gICAgICAgICBUUkIyIC0gIGxlbmd0aCA+IDAsIG1v
cmVfdHJic19jb21taW5nID0gMSAgLSBURF9TSVpFID4gMA0KPj4gICAgICAgICBUUkIzIC0gbGVu
Z3RoID49IDAsIG1vcmVfdHJic19jb21taW5nID0gMCAtICBURF9TSVpFICA9IDANCj4+DQo+PiBQ
YXdlbA0KPj4NCj4+ID4NCj4+ID5QZXRlcg0KPj4gPg0KPj4gPj4gZS5nLg0KPj4gPj4NCj4+ID4+
IFREIC0+IFRSQjEgIHRyYW5zZmVyX2xlbmd0aCA9IDY0S0IsIFREX1NJWkUgPTANCj4+ID4+ICAg
ICAgICAgICBUUkIyIHRyYW5zZmVyX2xlbmd0aCA9MCwgVERfU0laRSA9IDAgIC0gY29udHJvbGxl
ciB3aWxsDQo+PiA+PiAgICAgICAgICAgICAgICAgIGlnbm9yZSB0aGlzIHRyYW5zZmVyIGFuZCBz
dG9wIHRyYW5zZmVyIG9uIHByZXZpb3VzDQo+PiA+PiBvbmUNCj4+ID4+DQo+PiA+PiBURCAtPiBU
UkIxICB0cmFuc2Zlcl9sZW5ndGggPSA2NEtCLCBURF9TSVpFID0xDQo+PiA+PiAgICAgICAgICAg
VFJCMiB0cmFuc2Zlcl9sZW5ndGggPTAsIFREX1NJWkUgPSAwICAtIGNvbnRyb2xsZXIgd2lsbA0K
Pj4gPj4gICAgICAgICAgICAgICAgICBleGVjdXRlIHRoaXMgdHJiIGFuZCBzZW5kIFpMUA0KPj4g
Pj4NCj4+ID4+IEFzIHlvdSBub3RpY2VkIHByZXZpb3VzbHksIHByZXZpb3VzIGZpeCBmb3IgbGFz
dCBUUkIgcmV0dXJuZWQNCj4+ID4+IFREX1NJWkUgPSAxIGluIHNvbWUgY2FzZXMuDQo+PiA+PiBQ
cmV2aW91cyBmaXggd2FzIHdvcmtpbmcgY29ycmVjdCBidXQgd2FzIG5vdCBjb21wbGlhbmNlIHdp
dGgNCj4+ID4+IGNvbnRyb2xsZXIgc3BlY2lmaWNhdGlvbi4NCj4+ID4+DQo+PiA+PiA+DQo+PiA+
PiA+Pg0KPj4gPj4gPj4gICBtYXhwID0gdXNiX2VuZHBvaW50X21heHAocHJlcS0+cGVwLT5lbmRw
b2ludC5kZXNjKTsNCj4+ID4+ID4+ICAgdG90YWxfcGFja2V0X2NvdW50ID0gRElWX1JPVU5EX1VQ
KHRkX3RvdGFsX2xlbiwgbWF4cCk7DQo+PiA+PiA+PiAtLQ0KPj4gPj4gPj4gMi4yNS4xDQo+PiA+
PiA+Pg0KPj4gPj4gPg0KPj4gPj4gPi0tDQo+PiA+PiA+DQo+PiA+Pg0KPj4gPj4gVGhhbmtzLA0K
Pj4gPj4gUGF3ZWwgTGFzemN6YWsNCj4+ID4NCj4+ID4tLQ0KPj4gPg0KPj4gPlRoYW5rcywNCj4+
ID5QZXRlciBDaGVuDQo+Pg0KPj4gUmVnYXJkcywNCj4+IFBhd2VsIExhc3pjemFrDQo=
