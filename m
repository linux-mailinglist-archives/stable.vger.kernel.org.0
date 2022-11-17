Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE0962DACB
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 13:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbiKQM2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 07:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240178AbiKQM22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 07:28:28 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655EA193C3;
        Thu, 17 Nov 2022 04:27:48 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHAifR4020701;
        Thu, 17 Nov 2022 04:27:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=fT5hjkjVrrHgP+ujEmrh9UYfHTwLpxayp8XC+ZjVgnc=;
 b=XfDdQtvUwB60MTOTJPtpFnJpVQgqJQS3rjGUF2OpyF7mWvGD4ZNLweLJwHhNNaPt5AqV
 /8be3l1EFBthQgVoeXOxIIIQDBHHFcVTSULBxkTF40KUWKD8rYiIpovABeGGWbvEpoeP
 NvSZez2MQ/S2w0Uj2wf/8zJRMovykxxpuSZNikOdgcNohlRoEwlkRQouzShW/Bplf4/s
 ZdYsVKGWJeN4SyLo2az6O1aVaHEknkFCKPa7k3ux71jivfZA03+yrFgm5Hj+5w3LGuLP
 5uNqR5HXGjCF2L8ofJf9xZoPo73v9WKjYQuJkTu6ZJw4JSdnX8FKLIsM9Qm/w+PSW3XP WQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3kwkfn8ctv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 04:27:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkKukOhKczuRxzTJUVZ0+Yb3kY+VKjmPK183MYsZdv8yykWL82Fr03TCJ2u8t76gesoJRQhaSXK5eGe7j5+Q3NLPD14Lb5gReL8S0mQ2N6DRlVL/iwmxs/Cq+xpbI02iOrlAKmt0zykLkMQoxycMTpPtPB29HFal+JINin5MfjlU9tkpVGkXfvgK4UDqgaDVelNbe+SyJ5EFxaBhwDYFSNVCW7yrPZGNcyH+7t+YaGEMU2gUxctPXtCJKySELKj3ueDtsxNWTONK0D8t2KUKearQlZC/O5EsUhfUEgj+NkrMJcBi6K+KvXBgtmVYjiwf8DP1LkMOwg7seZwgVXLtRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fT5hjkjVrrHgP+ujEmrh9UYfHTwLpxayp8XC+ZjVgnc=;
 b=COyW5n3lJskVb9ZToAfD5dWBUavKsaxzC6b988khp8cRLLNOSNONm/+21LAysCnQlBQ8mbfUsAbJDkKfMpQXVbyOhdkZA+gieR1LoxEAQMIVrUn53OVK+/sDfvlNvvzenNNTWDOAdREt3EFRjWQ3ZOHd5RUA62wlDi0wgHJcfuL8zZUnEVD74E1/Xy6pk8e3sVTGozpy78cs7FLqMxbxREYKVtzW18wxsFlmRlLNFoHE1IPx9AiaqwsIa1vRUuerIXNOkjc+EPpYpuz4+pKoQwQLR3/+JKva7s49p41TTd2gSYuk5QdUxXCU/OjuGiRCB1QRP1LaaOePHpsDmOV3uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fT5hjkjVrrHgP+ujEmrh9UYfHTwLpxayp8XC+ZjVgnc=;
 b=WvGBtSZxhzLmAYTuoYFoGdMfxVh3hAD1DFTTl5PTQlv403eGCy4EbS6rWjCUJ3u6kUKPK1jNtQ+8rYoTIdQWkDt3Ci5YJWFP9/HLoNwb+jcWFhXpeinw631rY1eQhkWofF6KCleDBoOslYQkn6jBvOh3eFA/fJSyjAiIcHVxFrc=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by MN2PR07MB6736.namprd07.prod.outlook.com (2603:10b6:208:168::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 12:27:37 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 12:27:36 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <hzpeterchen@gmail.com>
CC:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "rogerq@kernel.org" <rogerq@kernel.org>,
        "a-govindraju@ti.com" <a-govindraju@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdns3: remove fetched trb from cache before
 dequeuing
Thread-Topic: [PATCH] usb: cdns3: remove fetched trb from cache before
 dequeuing
Thread-Index: AQHY+Nk1O9kuBWtXZk65xRZeSi7JF65DBooAgAAAr4A=
Date:   Thu, 17 Nov 2022 12:27:36 +0000
Message-ID: <BYAPR07MB5381AE961B59046ECB615C65DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221115100039.441295-1-pawell@cadence.com>
 <CAL411-o4BETLPd-V_4yR6foXbES=72-P4tq-fQ_W_p0P_3ZqEw@mail.gmail.com>
In-Reply-To: <CAL411-o4BETLPd-V_4yR6foXbES=72-P4tq-fQ_W_p0P_3ZqEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMzY2OTZmYTUtNjY3My0xMWVkLWE4NGQtMDBiZTQzMTQxNTFlXGFtZS10ZXN0XDM2Njk2ZmE2LTY2NzMtMTFlZC1hODRkLTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iMzQ5MSIgdD0iMTMzMTMxNjE2NTQ5NTEyMDc4IiBoPSI4RjNQQnFwRTc0UmdJTXBhTlBZUk53V3dJYm89IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|MN2PR07MB6736:EE_
x-ms-office365-filtering-correlation-id: 5d3bb903-5fbb-476a-c6f6-08dac8971c3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P7B2w7SLPjsoWjU1gAQJHkVipufaMAx5tl1Fxf6f6eMvHdVcZg15zqyobnNL/foXoTl2yBfT4/k/ES0GQ1X58pmETiHY+trgPo2tny5eV8/zgtABHbj9pKXXoXQSJi7V8ZVIkEMfa11QKVfRNJpoqN0+oscx6F9l80pdo2iiBaUqq56OIHGGvFkIT7dcHCQ+otx2DLeV1bWGLbuhbcxdCua8Mn4XRIlD67hFD0SwFt/vqD91TxlEMa8PDg25N4r9Yi/iD17BHFok0oElfF5Jth55nAUmmLMg1GLoLE34wivBOVLz1HmznZJUZ7p6vJjJ8B3FdacPYdnQVSaC2VNiMgvgrTz9/A/GdOoxUHaETjQhxOwreHpLIodx2SLA0Gwt7qvw83OSMlFxCaA04/aNx41c97TAyvrs7obaOgevy1cWdHcqzLI6pXe2qrJCfDK08MbxpEcnyg3BcOH7ROzhU2d6jwaFijZRbojbFmVBdU015uHKJNFRxSqg5vJucQJbl/i/4DdniumqxFMGTR8dhnIVAEmGsm+38SP9UzsS7nMvummVY6gKgnfJpKIe+ZK9lQOhTcrHIJnPXO0sfQC/4M1Xj9z61IrJxxTIU/y3rI3UBkdC/3JnygKzaEnmIo2kUzHFQRId3KfHrk3kCIkJqsJU1jTgRR/nLN2PTS+ezySfxgcbEvjJ6Xr8yvL06NvIU6SLR6XjtwSnAZoAO4PlwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(36092001)(451199015)(478600001)(71200400001)(316002)(6916009)(7696005)(6506007)(4326008)(66946007)(66476007)(8676002)(66556008)(66446008)(64756008)(186003)(8936002)(5660300002)(41300700001)(76116006)(26005)(52536014)(2906002)(83380400001)(55016003)(38100700002)(86362001)(33656002)(38070700005)(54906003)(9686003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFN5NCtUU1Q3QUh1Y1J3bzVlQ0NRUmQzTjJpbjNndVdiOVE1RDdUK0lNOWN3?=
 =?utf-8?B?c2J3b2pONjVZVXRxM3JiQkZzYy83YVVLMVpsejhDZTJ5bFdFWVJ3WVR1OWZS?=
 =?utf-8?B?ak5uYzJMK3RjOXdCekVTa29zbDZUREdyeUtzVk9lRi9WdGV2ZXFtYkdCRllN?=
 =?utf-8?B?ekJIWkxzSjFyZ2JaNEFyS1BHZ1NTdldGaHdSLzRMS291TXByWkd4OGtNVzQ3?=
 =?utf-8?B?NFBJMXhzRFNvNzNDVlliZWxhVnBaNGNNT2pSa1dqdzJ3OEFnUGNGdndjbk5q?=
 =?utf-8?B?TmVHNHNMNGNkSWFxUFRGTlJlVUlESXl2aUkwN29oaDlXUlNyNjlZT1BxQitB?=
 =?utf-8?B?QW1lZEZ0aTBjK3M3OGU1K2N1VDg1UWV4eWxzZkF0RlRnRUpWV1ZIL0N3Y1Q5?=
 =?utf-8?B?QVUvK3RHRHNOa1BZWEF6S3gvZjBuWWNub2ZGOE4yOGFsdjFXeWdQRW0wRWpD?=
 =?utf-8?B?NTA0a05lZG9HUndZekJwL0luVGllVUtjNWJINEZ5djNBSlpnWEE0SmE4TmFa?=
 =?utf-8?B?MHNieXlWNzBUbXJrTG54YnJ3OEdoaHhTVlU5ejgzRTF1R2NqOHV5OFpqdnBi?=
 =?utf-8?B?OTRSb2dXL0Jsb0RJOEhua3c0UmJ1bUhWNW9pZjBhV0RsMGY4d0VpQ2RsZXdR?=
 =?utf-8?B?VjVseGdVQTZhWVE4MDR3TFhVaU05TFJvQm02NW5TVk41c3pYSHR5STZLWGt4?=
 =?utf-8?B?STIycnJheEpscTF6VHFYcUVTZFB2bkNNQVBJV2VRYzVjSjBvZDk3UnhHd3dh?=
 =?utf-8?B?MzlvU2xlbEZFQ0U3Zi9LcWJpUS93RFVIVHRxZVErR0Y0NXE5Y0ZQaFFqSXR0?=
 =?utf-8?B?Z2h3UkFFRlNHUHFPOUpUbGZYTmNXd2puVldIZHhXUXBXMFVBdjhoU0ZCSTlG?=
 =?utf-8?B?aEVDVXpOVDFZZm5oRHVrVjBhVWZjZ3I4ZzREbElqKzdwYTFSU09yN21CNFZy?=
 =?utf-8?B?OWdOTFcvUXNzQmcraXRwZStpZVBYeXFBMXBLQXpLN1Qxa0Q4OFRhYVNaOHB1?=
 =?utf-8?B?eWtPcVRQejBuK245RUw2c285bHJKcDRLcVY4bFNzeFRsLzlGL0Z2aUg2aGJJ?=
 =?utf-8?B?NG9VTDdmOWJ2R3NYRXhUSmRIVHlvMDFzejZjUDJFVVhWa3EzM29MUVBNYlYz?=
 =?utf-8?B?Rm9nQnRMdHRGMDFaMVVhUXp5a1U4QjhjM2d2bmhjNm90SW5sdnViNWllTmVD?=
 =?utf-8?B?eVZTSStpN0ZlM1hxU21VNWRMZHFsV21GMkx3bWdMbFYyVmpZQTBiR2VJbDRv?=
 =?utf-8?B?empnbEIrbE56L3ZzdkRsYytwT3RiUFhBbG5YZzg2bkJqZFRwSFB6Vk01dTBW?=
 =?utf-8?B?amhZOHFpVmZSTUhLM1BXMmRMWnZBSGtlR0NLYW85T3cyTDZxREROVzhYUWFD?=
 =?utf-8?B?YmhNVWwvNnVDeDBzRGhiLyszK2dWOXFrY1BCcktTYmZqY1NZakhlcStoUTRE?=
 =?utf-8?B?RER3SnZ2WVRtcEFSNUhHV3BPM2lqVDRqUDAwVGp4OGpqelNiZDRUZndSKzFI?=
 =?utf-8?B?MWNqRC9rUjZQYmxsUmpma2liekk3NGFhU0tIQ0dvL1QreSs4Mnp5SmNQSVFI?=
 =?utf-8?B?Y0g5QW5YdXpVMDJMMFFvSE5ZSWRyM1U5TVU1SzJjMElwZjZPRHF5S2ZiWDdS?=
 =?utf-8?B?aExzR0wwMk9jSVNjMDA3SkY4ZU4wdzFCTEl4OFBzN0xjWFFlN2lDS2lPOWZ5?=
 =?utf-8?B?ZnpEa3hlU2xjdVV0aGszek9zcnJFTDlPV3lRbGphVXN3SG92ejVUV3R1VXU5?=
 =?utf-8?B?c2pRYXJRd1Q3QjdyRTAyV0ZsOVRkanR6Z3BZSGVuMkRpbVBpbnBVOXorazMv?=
 =?utf-8?B?ejNGMEdtN3lyb0V3cHFQbU5kVjN3RlRDYW1UbHd3YUNPUTkrUXZIRmEwck5Z?=
 =?utf-8?B?Y0tyblg2c2VkQzB4MzNtWFVaR1JWRjNBREVtMm45eTNRNVdDc3NKdVM0Z0xm?=
 =?utf-8?B?Y0xXUy80a0NUUERRMzdLdGxOYXAvZ1dKdUpiOU5melM3UG9VakZuSlY0cnZB?=
 =?utf-8?B?MzZjY1BGUEhlemRBNDU2bnVTeFMrU1lHbzArUTVTN3E3WVF5dHA1eFJ1dU41?=
 =?utf-8?B?dzcrUjZadXlUOVRCdklXSUdxTE9BMUlFem1nT3RldXJCOFpiQmE2UDRTRGMy?=
 =?utf-8?B?U2tCWE5nVHQ5ayswNk9aOEdsM2FveWZSUmJhUjc4R3doV3lPWVRJMDFhcjVI?=
 =?utf-8?B?NlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d3bb903-5fbb-476a-c6f6-08dac8971c3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 12:27:36.5370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: roJ60gw5Pn4WrsYXmZLVtuLK/4Vg2Ff0JIGimAj/NYXaRqH4A5RnaTrv6rPKnu3QbqkGIsLh4seDPBa+GtFFJyCLyjNPJu/3LHiEgKSVdoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6736
X-Proofpoint-ORIG-GUID: tp8rfPJGXXEhBpHakCP49gS-mkANTITx
X-Proofpoint-GUID: tp8rfPJGXXEhBpHakCP49gS-mkANTITx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 impostorscore=0
 clxscore=1015 mlxlogscore=663 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211170095
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pg0KPk9uIFR1ZSwgTm92IDE1LCAyMDIyIGF0IDY6MDEgUE0gUGF3ZWwgTGFzemN6YWsgPHBhd2Vs
bEBjYWRlbmNlLmNvbT4NCj53cm90ZToNCj4+DQo+PiBBZnRlciBkb29yYmVsbCBETUEgZmV0Y2hl
cyB0aGUgVFJCLiBJZiBkdXJpbmcgZGVxdWV1aW5nIHJlcXVlc3QgZHJpdmVyDQo+PiBjaGFuZ2Vz
IE5PUk1BTCBUUkIgdG8gTElOSyBUUkIgYnV0IGRvZXNuJ3QgZGVsZXRlIGl0IGZyb20gY29udHJv
bGxlcg0KPj4gY2FjaGUgdGhlbiBjb250cm9sbGVyIHdpbGwgaGFuZGxlIGNhY2hlZCBUUkIgYW5k
IHBhY2tldCBjYW4gYmUgbG9zdC4NCj4+DQo+PiBUaGUgZXhhbXBsZSBzY2VuYXJpbyBmb3IgdGhp
cyBpc3N1ZSBsb29rcyBsaWtlOg0KPj4gMS4gcXVldWUgcmVxdWVzdCAtIHNldCBkb29yYmVsbA0K
Pj4gMi4gZGVxdWV1ZSByZXF1ZXN0DQo+PiAzLiBzZW5kIE9VVCBkYXRhIHBhY2tldCBmcm9tIGhv
c3QNCj4+IDQuIERldmljZSB3aWxsIGFjY2VwdCB0aGlzIHBhY2tldCB3aGljaCBpcyB1bmV4cGVj
dGVkIDUuIHF1ZXVlIG5ldw0KPj4gcmVxdWVzdCAtIHNldCBkb29yYmVsbCA2LiBEZXZpY2UgbG9z
dCB0aGUgZXhwZWN0ZWQgcGFja2V0Lg0KPj4NCj4+IEJ5IHNldHRpbmcgREZMVVNIIGNvbnRyb2xs
ZXIgY2xlYXJzIERSRFkgYml0IGFuZCBzdG9wIERNQSB0cmFuc2Zlci4NCj4+DQo+PiBGaXhlczog
NzczM2Y2YzMyZTM2ICgidXNiOiBjZG5zMzogQWRkIENhZGVuY2UgVVNCMyBEUkQgRHJpdmVyIikN
Cj4+IGNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4+IFNpZ25lZC1vZmYtYnk6IFBhd2Vs
IExhc3pjemFrIDxwYXdlbGxAY2FkZW5jZS5jb20+DQo+PiAtLS0NCj4+ICBkcml2ZXJzL3VzYi9j
ZG5zMy9jZG5zMy1nYWRnZXQuYyB8IDEyICsrKysrKysrKysrKw0KPj4gIDEgZmlsZSBjaGFuZ2Vk
LCAxMiBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NkbnMz
L2NkbnMzLWdhZGdldC5jDQo+PiBiL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnMzLWdhZGdldC5jDQo+
PiBpbmRleCA1YWRjYjM0OTcxOGMuLmNjZmFlYmNhNmZhYSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZl
cnMvdXNiL2NkbnMzL2NkbnMzLWdhZGdldC5jDQo+PiArKysgYi9kcml2ZXJzL3VzYi9jZG5zMy9j
ZG5zMy1nYWRnZXQuYw0KPj4gQEAgLTI2MTQsNiArMjYxNCw3IEBAIGludCBjZG5zM19nYWRnZXRf
ZXBfZGVxdWV1ZShzdHJ1Y3QgdXNiX2VwICplcCwNCj4+ICAgICAgICAgdTggcmVxX29uX2h3X3Jp
bmcgPSAwOw0KPj4gICAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPj4gICAgICAgICBpbnQg
cmV0ID0gMDsNCj4+ICsgICAgICAgaW50IHZhbDsNCj4+DQo+PiAgICAgICAgIGlmICghZXAgfHwg
IXJlcXVlc3QgfHwgIWVwLT5kZXNjKQ0KPj4gICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFM
Ow0KPj4gQEAgLTI2NDksNiArMjY1MCwxMyBAQCBpbnQgY2RuczNfZ2FkZ2V0X2VwX2RlcXVldWUo
c3RydWN0IHVzYl9lcA0KPiplcCwNCj4+DQo+PiAgICAgICAgIC8qIFVwZGF0ZSByaW5nIG9ubHkg
aWYgcmVtb3ZlZCByZXF1ZXN0IGlzIG9uIHBlbmRpbmdfcmVxX2xpc3QgbGlzdCAqLw0KPj4gICAg
ICAgICBpZiAocmVxX29uX2h3X3JpbmcgJiYgbGlua190cmIpIHsNCj4+ICsgICAgICAgICAgICAg
ICAvKiBTdG9wIERNQSAqLw0KPj4gKyAgICAgICAgICAgICAgIHdyaXRlbChFUF9DTURfREZMVVNI
LCAmcHJpdl9kZXYtPnJlZ3MtPmVwX2NtZCk7DQo+PiArDQo+PiArICAgICAgICAgICAgICAgLyog
d2FpdCBmb3IgREZMVVNIIGNsZWFyZWQgKi8NCj4+ICsgICAgICAgICAgICAgICByZWFkbF9wb2xs
X3RpbWVvdXRfYXRvbWljKCZwcml2X2Rldi0+cmVncy0+ZXBfY21kLCB2YWwsDQo+PiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAhKHZhbCAmIEVQX0NNRF9ERkxVU0gp
LCAxLA0KPj4gKyAxMDAwKTsNCj4+ICsNCj4+ICAgICAgICAgICAgICAgICBsaW5rX3RyYi0+YnVm
ZmVyID0gY3B1X3RvX2xlMzIoVFJCX0JVRkZFUihwcml2X2VwLQ0KPj50cmJfcG9vbF9kbWEgKw0K
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgKChwcml2X3JlcS0+ZW5kX3RyYiArIDEpICogVFJC
X1NJWkUpKSk7DQo+PiAgICAgICAgICAgICAgICAgbGlua190cmItPmNvbnRyb2wgPQ0KPj4gY3B1
X3RvX2xlMzIoKGxlMzJfdG9fY3B1KGxpbmtfdHJiLT5jb250cm9sKSAmIFRSQl9DWUNMRSkgfCBA
QCAtMjY2MCw2DQo+PiArMjY2OCwxMCBAQCBpbnQgY2RuczNfZ2FkZ2V0X2VwX2RlcXVldWUoc3Ry
dWN0IHVzYl9lcCAqZXAsDQo+Pg0KPj4gICAgICAgICBjZG5zM19nYWRnZXRfZ2l2ZWJhY2socHJp
dl9lcCwgcHJpdl9yZXEsIC1FQ09OTlJFU0VUKTsNCj4+DQo+PiArICAgICAgIHJlcSA9IGNkbnMz
X25leHRfcmVxdWVzdCgmcHJpdl9lcC0+cGVuZGluZ19yZXFfbGlzdCk7DQo+PiArICAgICAgIGlm
IChyZXEpDQo+PiArICAgICAgICAgICAgICAgY2RuczNfcmVhcm1fdHJhbnNmZXIocHJpdl9lcCwg
MSk7DQo+PiArDQo+DQo+V2h5IHRoZSBhYm92ZSBjaGFuZ2VzIGFyZSBuZWVkZWQ/DQo+DQoNCkRv
IHlvdSBtZWFuIHRoZSBsYXN0IGxpbmUgb3IgdGhpcyBwYXRjaD8NCg0KTGFzdCBsaW5lOg0KRE1B
IGlzIHN0b3BwZWQsIHNvIGRyaXZlciBhcm0gdGhlIHF1ZXVlZCB0cmFuc2ZlcnMNCg0KSWYgeW91
IG1lYW5zIHRoaXMgcGF0Y2g6DQpJc3N1ZSB3YXMgZGV0ZWN0ZWQgYnkgY3VzdG9tZXIgdGVzdC4g
SSBkb27igJl0IGtub3cgd2hldGhlciBpdCB3YXMgDQpvbmx5IHRlc3Qgb3IgdGhlIHJlYWwgYXBw
bGljYXRpb24uDQoJDQpUaGUgcHJvYmxlbSBoYXBwZW5zIGJlY2F1c2UgdXNlciBhcHBsaWNhdGlv
biBxdWV1ZWQgdGhlIHRyYW5zZmVyDQooZW5kcG9pbnQgaGFzIGJlZW4gYXJtZWQpLCBzbyBjb250
cm9sbGVyIGZldGNoIHRoZSBUUkIuDQpXaGVuIHVzZXIgYXBwbGljYXRpb24gcmVtb3ZlZCB0aGlz
IHJlcXVlc3QgdGhlIFRSQiB3YXMgc3RpbGwNCnByb2Nlc3NlZCBieSBjb250cm9sbGVyLiBJZiBh
dCB0aGF0IHRpbWUgdGhlIGhvc3Qgd2lsbCBzZW5kIGRhdGEgcGFja2V0DQp0aGVuIGNvbnRyb2xs
ZXIgd2lsbCBhY2NlcHQgaXQsIGJ1dCBpdCBzaG91bGRuJ3QgYmVjYXVzZSB0aGUgdXNiX3JlcXVl
c3QNCmFzc29jaWF0ZWQgd2l0aCBUUkIgY2FjaGVkIGJ5IGNvbnRyb2xsZXIgd2FzIHJlbW92ZWQu
IA0KVG8gZm9yY2UgdGhlIGNvbnRyb2xsZXIgdG8gZHJvcCB0aGlzIFRSQiBERkxVU0ggaXMgcmVx
dWlyZWQuDQoNClBhd2VsDQoNCj4NCj4+ICBub3RfZm91bmQ6DQo+PiAgICAgICAgIHNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJnByaXZfZGV2LT5sb2NrLCBmbGFncyk7DQo+PiAgICAgICAgIHJldHVy
biByZXQ7DQo+PiAtLQ0KPj4gMi4yNS4xDQo+Pg0K
