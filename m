Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A153362B2CB
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 06:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiKPFfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 00:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiKPFfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 00:35:54 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C9E2F015;
        Tue, 15 Nov 2022 21:35:51 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFMbKNA020720;
        Tue, 15 Nov 2022 21:35:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=SX1kuL/30GPkJa6EGonsSv7xc7stNM/4mC44baZ/wOw=;
 b=CjHMTMrrFVGU+6gUUw2179d+DA5bYFldLh0gCySgBBOmQ03FI3wP+rPPLLtXMJzqihEE
 UViR19lCIF9teQdCKmkK0uG11+G7/WrYImsCkZ1cUyQhm+Vv+2l5ui1xwsSA+GXmhFVs
 Dj+DRDnr7PrObxwxvlZQGhAxVF9/5LwxvJKSck4pp2ZbawGq2b4G4BUxU6dWSlX/x4TY
 u5TFLufS5khWCZXd4DyvdD0ZIlnth5rdmVq3+QYHa+4tx0jgX+7kubZJyc/hh7zKmwan
 UYV9n6umwtINjOv0XnpLSHQdmzhxHgvhreeqn7rgp/B2/YMpTGMP9T+IkulAiSTW4upL JQ== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3kvkqq179m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 21:35:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaD28d3uAYhPeSXCED6IQB/wfKxv4MxBc+BiVaWJrcy/xZuhe0f3hOLehMvLPZYeLSOja1fbWmykQgj8/4u4O0v2Pju7SvGqAa5DAbOi+j8HKaWihFVuh/DJ9cAjknEIRFXYnYfwoRxYS7F+OrjhEOJupFX+tPUUuBjnDFSCt6e42GazgBKxWfTrmH+YrPcZFrpvFsO3GN1rohHAW8WuY+IMT1O/30t4hMuLcjBzs4GeBmb0VVeJHYkxPXuA1Vz/wt2JwxHAE7Rmoujy2YqrrQAHTUQAKCWImm/NzD8oD6R9Xlc79KbUbWByBTOgYblZBdAsIsyZWnRwsbeEcyFExA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SX1kuL/30GPkJa6EGonsSv7xc7stNM/4mC44baZ/wOw=;
 b=aApljyUWpoTB8MZGocBpxdxlZcYiM+f7E2mBT6FswOtQAOWoQsOR3b7Q4fOCigmb6SGE2MV89SE7W9H/Y7MPpDTxlyCS9vk1x11RLq8RMAufbVQF5ugCGEFwhQEyShXnXU3NVxQWVJXjq413t4sTYUmx9YxXuPYTRnJP7KxtotQkSiygZuTyA55x5bgP62pG1QvnCGyelvuHUpH4JmOiZ4gChwugX7gVaBQDAjmUrueaVl9+zqvVwiiDUOjO+u8qUaIazPSCc1MWiIvgQhIFuB3EBs+FH0qu4TtVeW8Q/z615kYK0JvIiu9O8nCL9ddhwPZTnnTt5FKZ57QczJVSLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SX1kuL/30GPkJa6EGonsSv7xc7stNM/4mC44baZ/wOw=;
 b=31f06oj/clmNZKm89Lxi/QOy+PrZ/HxFFJjbXKN8ehbsiQkmZlIT4QivXLk84b+Op9+MN7Hubd74KDr753J1ZHVND7Gibhqh1Wbaj2ggaiE6cGbxWDaxNUxqz7aVbB5QhiNpmnu8OqKQeeHSoR05K66A81DoJX3XUejqegxRZL8=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by MW4PR07MB8538.namprd07.prod.outlook.com (2603:10b6:303:bf::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 05:35:37 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 05:35:37 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     chao zeng <chao.zengup@gmail.com>
CC:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY+NPNw+7GZd89V0WFB5xoxMG5aa4/60AAgAEaUXA=
Date:   Wed, 16 Nov 2022 05:35:36 +0000
Message-ID: <BYAPR07MB5381EC4893D325AB9B464C09DD079@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221115092218.421267-1-pawell@cadence.com>
 <CAGzEXPZKbBX1AGnC9fq-TNFoWmC5Y2+ZfvRLWkz==J2wnn8EHg@mail.gmail.com>
In-Reply-To: <CAGzEXPZKbBX1AGnC9fq-TNFoWmC5Y2+ZfvRLWkz==J2wnn8EHg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctN2QzMWIzM2YtNjU3MC0xMWVkLWE4NGQtMDBiZTQzMTQxNTFlXGFtZS10ZXN0XDdkMzFiMzQxLTY1NzAtMTFlZC1hODRkLTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iNDg0MSIgdD0iMTMzMTMwNTA1MzM5NTcwNzUzIiBoPSJDbTllQUxOTDd1UXhNUy9lR0MxMWFCUnZyeUk9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|MW4PR07MB8538:EE_
x-ms-office365-filtering-correlation-id: 70e6c162-3937-4f03-c0b8-08dac79463c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +cOGmD4rwK9eeU3gKn0VDU1K0nqgkKvNwKE9xWUnFVpSKnaMXDE5Apiy1UjDbWhOS8JezB9mVgcpJljs/vyZ3qHAnbUt0cEOyVoHRU2w6Du9eZyJw2EdcmSGejYgQJkRnk+52GtMn/ewQ7yYypjF2tTlzQZxZDRYNfVomLQ1vCgR8mS4bVL8AJOOTOr0mSi2tqI2D3EGt/8+aSxP8RQtmq+F0r6f4nA87mggbWjuRzy+M0btq49VdZDpZ2Ii6Yz6NKhg+cNfrxCSSSkKKwXK3xiWkJkhTk6BmnnOHUKm0UWGuXaNAuz0npyLc3tuYumeWnhTzokKvs5ERTdJkal6OtUdBdsXcNIIN28TNujSCT+bsvHTnh2WDsbW5oVHnjZ8meTyNtJ5PrO9VDJhYfqX9wg4eFO2CP3dYnu38Hi/vJmJVAgBbN3gIsiLkixEhDK6XSz79aT93+rlzDZsFSNVJlPXJKvBl+pemmfQUwocni746GPK+7LhWGuLNjA/ATYf/YnKwveErpv5R5rqyLOgb6+FzOX0eEfEZ+FON1wF9WaMcEYcT2SL6GOVOw1CoCfTNsPWzpFQZHB4nyY1Q8AQIqr4LKgdTbYDPYaVKrQ5IH2f0VUoADi0bhZo47LNpy0UXSm3I8oTO9QRkhLiaz90kPpprls7kDNMuZb/NIsJrpv/bsEiZSaA+QFgXVZ5O7EDE7bOJJpAtbio0ZP65qyfskXvIs5BhYZvX0Q+4gYAepVsrNElOz2nEbbULYZpuGcYk3m0TY0ampIRg5H7t+IhMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(36092001)(451199015)(186003)(7696005)(54906003)(6916009)(71200400001)(6506007)(33656002)(38070700005)(38100700002)(55016003)(86362001)(122000001)(83380400001)(9686003)(26005)(41300700001)(8936002)(52536014)(478600001)(5660300002)(2906002)(66446008)(76116006)(64756008)(4326008)(66476007)(8676002)(66556008)(316002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0UxNXdIdVRUYm5CWWJHOWpnQ3dVUEFKWTFZb1E0eWFYbDAvdWRPZGlQR2pl?=
 =?utf-8?B?c2pDQzBvVklwdyt6YWQwMlVhQlRaTUdtZng1ckxpL2tXQjdweFNBeGsxZGVU?=
 =?utf-8?B?M1VoTkFBRmNGT2ttc3grdDY0UmFUMk9mMWZ3eDR4b0NQVHB6K2RqbWwzRnFD?=
 =?utf-8?B?UjBtd29IeFZVSUVmUzRwN2twTTBmWmo5eVU2eCtIZU9uMVJZNnlHcmI0WHBF?=
 =?utf-8?B?Y1orVlh1WU9iTVBzeU51ZXBJV3A4VWJOQ0tpdDFPYjFzekxaZ0xXSEZmNU0z?=
 =?utf-8?B?NUlNeStKcUdnbFkzWTV2VnJUUG05SGhJTDdxU3dtRXhKK2t4cXA0VmFBRzll?=
 =?utf-8?B?dVdqVlFVclcrUnZ3cXZ4ZEFwSnpVY05BN0Z3TU0xY0lvaWc3T25WaXhvS0dx?=
 =?utf-8?B?SnU0Vml2MU5laS9vTUpOWG9uNjJDREFaZ1BEV3hCamxGSUh0ODNSc0U5ZWMz?=
 =?utf-8?B?VzdzOC9zT3lWSnQwTm80RkJyeHB4T0MwSCtkZTlLZ3lNb1JsdzZhRjIzbEtl?=
 =?utf-8?B?U1FNMzBFZmdSTkZYQnRja2hXTlY2L0RYNjhQWEwzZXhIOFZib1dQRXNwVWNj?=
 =?utf-8?B?TXVIZ3hyQmpFamhGanh4UzNOUmJXV2JIbnlqVUFBU2FwM3IreldQV1dPUEZI?=
 =?utf-8?B?TCs4NCtvMGtQNEVEMkMvN2RnL01yR0JobXlYSFhOSzBUZ3JUUUZ2Rjd1Y3hL?=
 =?utf-8?B?M2JzR0V1dW1OdzBKK3NMYzhwREJWRnBHSllISTV1cjFtelZwZDZDajlIaExJ?=
 =?utf-8?B?TG54cUJNcUoxWXFCODJNUWxkdUVyZzlLeEZKdnRoaFp1ZnlKSGhtVmhIOWl1?=
 =?utf-8?B?Wk5wNm1XWXIyOGxvU0dGeWsyT3dlN2kxdStLalg4NmVXbEJEOHVQdythZlI3?=
 =?utf-8?B?ZDRhK29VMXJNRi8rZVh1VHlPZGRrQThDUTRCenFyWnVwQXlXNVlvUm1wV1o0?=
 =?utf-8?B?djFobXd4OURxU0graXBnS2tHTndGd05HMTMvRUhYcnl1SUp4c01vc3JtSVdN?=
 =?utf-8?B?cklha2FwZ2t6QTlMY1JCVzI2ZXpsY2dML0JCZnVLWlNDbU9hU0syckNuSUhz?=
 =?utf-8?B?NHovdFhZN0N5cXYzM04xcHhQOVBkS1VoZDR1R1JUcW9yZ3V0eEJON210YXc4?=
 =?utf-8?B?eHRFNldDZkFmK2dacjJQTWM3MERlSHdqQks4RWtzWVdTZ2p1MmNsOHBvUDc0?=
 =?utf-8?B?RmR5WWJQN1ZCcVlGSXllWFdsNXhpd2w5TGZJa2dMVjFtczMyRzFrV2VqeFJW?=
 =?utf-8?B?bSswd09vR0ZkVkpCWDVNK0FMeHlreERxRjZJaXc2V256OGthVUE4SGZqRTcz?=
 =?utf-8?B?akpXWHRZMlB2SXYvK0JiSWxnajNHZzlJSkpzZkc5VXQvVU45QTBmMWZZcFI5?=
 =?utf-8?B?V0dtVCtvL2d3VnB3MDRZVkVZalJkSmt1SWpsYm93cHRNZkxzOTNSalhtVzBQ?=
 =?utf-8?B?ZUFidmxoMmc0N1dObUg1bEhVck1WanJhUEtTU2h0bUMwd1FRVU00aUFQZ2dP?=
 =?utf-8?B?NXAyKzZEV2Z5bnFVMzQ4dGx2NmVMTm42TTQ4QVY5R2hWY0pyaVhyeGxmYzhY?=
 =?utf-8?B?cTgvVHFWWllLUXh1V2ovd25TeGtBUi9VKzJhN2FJaWw5by9JTXVIVFF6eFlO?=
 =?utf-8?B?bTJLYW9qMmNONHZVZHhtU2NOUmVZQW8yMXBIVE1NWGZkN1R3VVVROXVUN1ZR?=
 =?utf-8?B?bEdvSzQvV0h0N3JCWDMzejhWRVBFTHUreTB0VDloRlA5NDJHdzUzOHhBeXk1?=
 =?utf-8?B?MGpKdkUzcFJ5MkYraElLWnF2RFRqb29vYVJ0UjlCdWg4V0RjV29iaFI0NVNk?=
 =?utf-8?B?YWp6MEJSTEdGWmpLOGdEcFZwSUlncG10SzgvaWtSK0wxTlZnM045UmhUc2tG?=
 =?utf-8?B?NVkrZFBrMW5iTnowZFVpWWtKbzZYZXdCWnlQbHYzMlorSm14czdMZmhhdVY0?=
 =?utf-8?B?L2lJSjBuYUQzTzRxNEpMbTBPZG1LWCtVei9aVkZmdlRNc0E0dTRwekpNVVYz?=
 =?utf-8?B?STluV1dVd2dhV1FTbWx5dkhGZjRkaWtQR1oybFNIZi9CUTZZdXNuWjlVbjNa?=
 =?utf-8?B?M2N6RHFaSE5QUHNPdWVSZlFhdlh2RS9tSG54SmphTHhHRmdWVFF1M2VkejdD?=
 =?utf-8?B?eE5kSHJIWHdGYkxkdzYzcTJXUE95Smh5YlJqYkhjdFlNYTExWDl2UDFKU2lD?=
 =?utf-8?B?THc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e6c162-3937-4f03-c0b8-08dac79463c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 05:35:36.8763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S5yaox8mx+HAEgA1kPOw0CxZBqYhA2V74lDdly3IDBn4wlNAoEgY9NfHMBRRsM8CEJQrWrRS39BKj4w//cl+nW/N+B6b9YRJDbWfTBedDu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR07MB8538
X-Proofpoint-ORIG-GUID: _ZDuG3fQvzyuikKVKxvZXm9D3NEHk1fe
X-Proofpoint-GUID: _ZDuG3fQvzyuikKVKxvZXm9D3NEHk1fe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1011
 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=803
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160040
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pg0KPkhlbGxvDQo+DQo+ICAgSSB0aGluayB0aGUgcHJvYmxlbSBpcyB0aGF0IHlvdSB3YW50IHRv
IGhhbmRsZSB0aGUgemVyby1sZW5ndGggdHJiIGFuZCB0aGUNCj5vdGhlciB0cmJzIGluIGEgdHJh
bnNhY3Rpb24uICBidXQgd2hlbiB3ZSBjYWxjdWxhdGUgdGhlIHRkIHNpemXvvIx3ZSBkbyBub3QN
Cj5jb3VudCB0aGUgemVyby1sZW5ndGggdHJiLiBzbyBtYXliZSB3ZSBjYW4gc29sdmUgdGhlIHBy
b2JsZW0gIGFzIGJlbG93Og0KPg0KPg0KPg0KPi0tLSBhL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnNw
LXJpbmcuYw0KPg0KPisrKyBiL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnNwLXJpbmcuYw0KPg0KPkBA
IC0xOTYwLDcgKzE5NjAsNyBAQCBpbnQgY2Ruc3BfcXVldWVfYnVsa190eChzdHJ1Y3QgY2Ruc3Bf
ZGV2aWNlDQo+KnBkZXYsIHN0cnVjdCBjZG5zcF9yZXF1ZXN0ICpwcmVxKQ0KPg0KPiAgICAgICAg
ICAgICAgICAvKiBTZXQgdGhlIFRSQiBsZW5ndGgsIFREIHNpemUsIGFuZCBpbnRlcnJ1cHRlciBm
aWVsZHMuICovDQo+DQo+ICAgICAgICAgICAgICAgIHJlbWFpbmRlciA9IGNkbnNwX3RkX3JlbWFp
bmRlcihwZGV2LCBlbnFkX2xlbiwgdHJiX2J1ZmZfbGVuLA0KPg0KPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZnVsbF9sZW4sIHByZXEsDQo+DQo+LSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtb3JlX3RyYnNfY29taW5n
KTsNCj4NCj4rICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1v
cmVfdHJic19jb21pbmcpICsgKG5lZWRfemVyb19wa3QgPyAxIDogMCk7DQo+DQo+DQo+DQo+ICAg
ICAgICAgICAgICAgIGxlbmd0aF9maWVsZCA9IFRSQl9MRU4odHJiX2J1ZmZfbGVuKSB8IFRSQl9U
RF9TSVpFKHJlbWFpbmRlcikgfA0KPg0KPiAgICAgICAgICAgICAgICAgICAgICAgIFRSQl9JTlRS
X1RBUkdFVCgwKTsNCj4NCg0KWW91ciBwcm9wb3NpdGlvbiBtYWtlcyB0aGUgc2FtZSB0aGluZyBh
cyB0aGUgdjMgcGF0Y2ggYnV0IHYzIGNvbnRhaW5zIHRoZSBleHRyYSBwYXJhbWV0ZXIuIA0KSW4g
bXkgb3BpbmlvbiB0aGUgcGF0Y2ggd2l0aCBleHRyYSBwYXJhbWV0ZXIgaXMgbW9yZSByZWFkYWJs
eS4NCg0KRGlkIHlvdSBmaW5kIHNvbWV0aGluZyB3cm9uZyBpbiB2My4gSSBoYXZlIHRlc3RlZCBp
dCB3aXRoIEVDTSBjbGFzcyB3aGljaCBtYWtlIHBvc3NpYmxlIHRvDQpmb3JjZSBaTFAuDQoNClRo
YW5rcw0KUGF3ZWwNCg0KPg0KPk9uIFR1ZSwgTm92IDE1LCAyMDIyIGF0IDU6MzEgUE0gUGF3ZWwg
TGFzemN6YWsgPHBhd2VsbEBjYWRlbmNlLmNvbQ0KPjxtYWlsdG86cGF3ZWxsQGNhZGVuY2UuY29t
PiA+IHdyb3RlOg0KPg0KPg0KPglQYXRjaCBtb2RpZmllcyB0aGUgVERfU0laRSBpbiBUUkIgYmVm
b3JlIFpMUCBUUkIuDQo+CVRoZSBURF9TSVpFIGluIFRSQiBiZWZvcmUgWkxQIFRSQiBtdXN0IGJl
IHNldCB0byAxIHRvIGZvcmNlDQo+CXByb2Nlc3NpbmcgWkxQIFRSQiBieSBjb250cm9sbGVyLg0K
Pg0KPgljYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgPG1haWx0bzpzdGFibGVAdmdlci5rZXJu
ZWwub3JnPiA+DQo+CUZpeGVzOiAzZDgyOTA0NTU5ZjQgKCJ1c2I6IGNkbnNwOiBjZG5zMyBBZGQg
bWFpbiBwYXJ0IG9mIENhZGVuY2UNCj5VU0JTU1AgRFJEIERyaXZlciIpDQo+CVNpZ25lZC1vZmYt
Ynk6IFBhd2VsIExhc3pjemFrIDxwYXdlbGxAY2FkZW5jZS5jb20NCj48bWFpbHRvOnBhd2VsbEBj
YWRlbmNlLmNvbT4gPg0KPgktLS0NCj4JdjI6DQo+CS0gcmV0dXJuZWQgdmFsdWUgZm9yIGxhc3Qg
VFJCIG11c3QgYmUgMA0KPgl2MzoNCj4JLSBmaXggaXNzdWUgZm9yIHJlcXVlc3QtPmxlbmd0aCA+
IDY0S0INCj4NCj4JIGRyaXZlcnMvdXNiL2NkbnMzL2NkbnNwLXJpbmcuYyB8IDE0ICsrKysrKysr
KystLS0tDQo+CSAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMo
LSkNCj4NCj4JZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnNwLXJpbmcuYyBiL2Ry
aXZlcnMvdXNiL2NkbnMzL2NkbnNwLQ0KPnJpbmcuYw0KPglpbmRleCA3OTRlNDEzODAwYWUuLjg2
ZTExNDFlMTUwZiAxMDA2NDQNCj4JLS0tIGEvZHJpdmVycy91c2IvY2RuczMvY2Ruc3AtcmluZy5j
DQo+CSsrKyBiL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnNwLXJpbmcuYw0KPglAQCAtMTc2MywxMCAr
MTc2MywxNSBAQCBzdGF0aWMgdTMyIGNkbnNwX3RkX3JlbWFpbmRlcihzdHJ1Y3QNCj5jZG5zcF9k
ZXZpY2UgKnBkZXYsDQo+CSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCB0cmJfYnVm
Zl9sZW4sDQo+CSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCB0ZF90
b3RhbF9sZW4sDQo+CSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBjZG5zcF9y
ZXF1ZXN0ICpwcmVxLA0KPgktICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib29sIG1vcmVf
dHJic19jb21pbmcpDQo+CSsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJvb2wgbW9yZV90
cmJzX2NvbWluZywNCj4JKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYm9vbCB6bHApDQo+
CSB7DQo+CSAgICAgICAgdTMyIG1heHAsIHRvdGFsX3BhY2tldF9jb3VudDsNCj4NCj4JKyAgICAg
ICAvKiBCZWZvcmUgWkxQIGRyaXZlciBuZWVkcyBzZXQgVERfU0laRSA9IDEuICovDQo+CSsgICAg
ICAgaWYgKHpscCkNCj4JKyAgICAgICAgICAgICAgIHJldHVybiAxOw0KPgkrDQo+CSAgICAgICAg
LyogT25lIFRSQiB3aXRoIGEgemVyby1sZW5ndGggZGF0YSBwYWNrZXQuICovDQo+CSAgICAgICAg
aWYgKCFtb3JlX3RyYnNfY29taW5nIHx8ICh0cmFuc2ZlcnJlZCA9PSAwICYmIHRyYl9idWZmX2xl
biA9PSAwKQ0KPnx8DQo+CSAgICAgICAgICAgIHRyYl9idWZmX2xlbiA9PSB0ZF90b3RhbF9sZW4p
DQo+CUBAIC0xOTYwLDcgKzE5NjUsOCBAQCBpbnQgY2Ruc3BfcXVldWVfYnVsa190eChzdHJ1Y3QN
Cj5jZG5zcF9kZXZpY2UgKnBkZXYsIHN0cnVjdCBjZG5zcF9yZXF1ZXN0ICpwcmVxKQ0KPgkgICAg
ICAgICAgICAgICAgLyogU2V0IHRoZSBUUkIgbGVuZ3RoLCBURCBzaXplLCBhbmQgaW50ZXJydXB0
ZXIgZmllbGRzLiAqLw0KPgkgICAgICAgICAgICAgICAgcmVtYWluZGVyID0gY2Ruc3BfdGRfcmVt
YWluZGVyKHBkZXYsIGVucWRfbGVuLA0KPnRyYl9idWZmX2xlbiwNCj4JICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmdWxsX2xlbiwgcHJlcSwNCj4JLSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtb3JlX3RyYnNfY29taW5n
KTsNCj4JKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtb3Jl
X3RyYnNfY29taW5nLA0KPgkrICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHplcm9fbGVuX3RyYik7DQo+DQo+CSAgICAgICAgICAgICAgICBsZW5ndGhfZmllbGQg
PSBUUkJfTEVOKHRyYl9idWZmX2xlbikgfA0KPlRSQl9URF9TSVpFKHJlbWFpbmRlcikgfA0KPgkg
ICAgICAgICAgICAgICAgICAgICAgICBUUkJfSU5UUl9UQVJHRVQoMCk7DQo+CUBAIC0yMDI1LDcg
KzIwMzEsNyBAQCBpbnQgY2Ruc3BfcXVldWVfY3RybF90eChzdHJ1Y3QNCj5jZG5zcF9kZXZpY2Ug
KnBkZXYsIHN0cnVjdCBjZG5zcF9yZXF1ZXN0ICpwcmVxKQ0KPg0KPgkgICAgICAgIGlmIChwcmVx
LT5yZXF1ZXN0Lmxlbmd0aCA+IDApIHsNCj4JICAgICAgICAgICAgICAgIHJlbWFpbmRlciA9IGNk
bnNwX3RkX3JlbWFpbmRlcihwZGV2LCAwLCBwcmVxLQ0KPj5yZXF1ZXN0Lmxlbmd0aCwNCj4JLSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwcmVxLT5yZXF1ZXN0
Lmxlbmd0aCwgcHJlcSwgMSk7DQo+CSsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgcHJlcS0+cmVxdWVzdC5sZW5ndGgsIHByZXEsIDEsIDApOw0KPg0KPgkgICAg
ICAgICAgICAgICAgbGVuZ3RoX2ZpZWxkID0gVFJCX0xFTihwcmVxLT5yZXF1ZXN0Lmxlbmd0aCkg
fA0KPgkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFRSQl9URF9TSVpFKHJlbWFpbmRl
cikgfCBUUkJfSU5UUl9UQVJHRVQoMCk7DQo+CUBAIC0yMjI1LDcgKzIyMzEsNyBAQCBzdGF0aWMg
aW50IGNkbnNwX3F1ZXVlX2lzb2NfdHgoc3RydWN0DQo+Y2Ruc3BfZGV2aWNlICpwZGV2LA0KPgkg
ICAgICAgICAgICAgICAgLyogU2V0IHRoZSBUUkIgbGVuZ3RoLCBURCBzaXplLCAmIGludGVycnVw
dGVyIGZpZWxkcy4gKi8NCj4JICAgICAgICAgICAgICAgIHJlbWFpbmRlciA9IGNkbnNwX3RkX3Jl
bWFpbmRlcihwZGV2LCBydW5uaW5nX3RvdGFsLA0KPgkgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHRyYl9idWZmX2xlbiwgdGRfbGVuLCBwcmVxLA0KPgktICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1vcmVfdHJic19jb21p
bmcpOw0KPgkrICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1v
cmVfdHJic19jb21pbmcsIDApOw0KPg0KPgkgICAgICAgICAgICAgICAgbGVuZ3RoX2ZpZWxkID0g
VFJCX0xFTih0cmJfYnVmZl9sZW4pIHwNCj5UUkJfSU5UUl9UQVJHRVQoMCk7DQo+DQo+CS0tDQo+
CTIuMjUuMQ0KPg0KPg0KDQo=
