Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858F35A23BB
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 11:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbiHZJI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 05:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbiHZJI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 05:08:57 -0400
Received: from mx0a-0039f301.pphosted.com (mx0a-0039f301.pphosted.com [148.163.133.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5F6D5EBF;
        Fri, 26 Aug 2022 02:08:54 -0700 (PDT)
Received: from pps.filterd (m0174677.ppops.net [127.0.0.1])
        by mx0a-0039f301.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q7vUbP014249;
        Fri, 26 Aug 2022 09:08:16 GMT
Received: from eur04-he1-obe.outbound.protection.outlook.com (mail-he1eur04lp2057.outbound.protection.outlook.com [104.47.13.57])
        by mx0a-0039f301.pphosted.com (PPS) with ESMTPS id 3j6d18t84y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 09:08:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+lBCX+K76r1gj86Vxv9aUPG8VBISZ/RzKFvyxC3QLYduO8chi4K+qmq56zBuUdcvTOn0yEshfYQMJlT/S/hcneR/L967mJ7pyB3h3dltAF34t5C4SB8qENfo3SyQ1ky4oAsE/an+qBF4imSyhK9IHwrmOdLfbnAWOere6VB0gYTu66eaZqcUiCRseRqjZJfFXw3PrEPG2PaRP+EX4ccl3zC/qJ9Gd5nuSh9Vx/hpO3Aj+KpSvjLwZXBHH5mhPohJrDuWZPmMpuGCLqH7bxidwTW3x45rr5F1TXI8T5H4AI+S++tt30uX5pDq7YYCRIBVUI661xKCjB6YCqi1IqjRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+v6F7o1w8tZ0293ls0TtvsGKk5yh5v4EQ8kxpZt+3E=;
 b=TdUO1D89CxRp/Yj1K+awk1tqYFL0KciHAvr90K3Z7DGAEXfKBcKiNIOk/YgSri2CkKKWxiQWX96ENyfOZvBP/Xy4mMEWTFMnQiwQupCj12ag8nhSEzq1bWo5SqVuV3sbtH6mk7T5bDxPUtj2coCQwkYSQT0FY/kBmoRz+DE3WHwCOCVDX9fMk6dCgWZEE5mhTDikh8RoD73xb332fVc5K72eYMnLdy2xYfwxZWqulg+AKqCyflAaB0I5/+wvsrO95TlUCYVw431nVdrM9MunObxaLbLf1wMaQJvsJEluKZ8nTsa8xJ3znCZEWIW8Yd++2x/68gE0GRoICeeWXKkLXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+v6F7o1w8tZ0293ls0TtvsGKk5yh5v4EQ8kxpZt+3E=;
 b=WbXT9htnImU64tvevHo9IQ4d0p0EEti12GwKCqP/FQkuqu4DK8/0RpDNLz9x7D7OanIcn7IhunGa9BHthViggmYJtHG4/JhKqlOU7iPSC7zWu78d1rDHDtYSwMrFenl1SzN3dOGof/ikJzt8gt92AI2Fbnj6549g0ANSVXiJlcdc+PpKgLBgZezRJzQuemP5pdAvDXWBZW/ZLzjGnYXE9OjOcYYieL6d3RnCS6IjDyqBLUMMwjvDDRhV9naJ3HACTAIeqRgFbctyTxfTXR0fGu9/Apluez+DrrLEbGqDYRnCIcwaCNTGCjOeGArDmYlYn++LylZ8IhqDpGOdD/H51w==
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com (2603:10a6:10:ed::15)
 by AM6PR03MB4167.eurprd03.prod.outlook.com (2603:10a6:20b:c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 09:08:12 +0000
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::f575:76e9:4a40:7387]) by DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::f575:76e9:4a40:7387%2]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 09:08:11 +0000
From:   Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
To:     Juergen Gross <jgross@suse.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Stefano Stabellini <sstabellini@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rustam Subkhankulov <subkhankulov@ispras.ru>
Subject: Re: [PATCH v4] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Thread-Topic: [PATCH v4] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Thread-Index: AQHYuI2vvcV5ZmaCZ02coOJc6eyXM63A5Z4A
Date:   Fri, 26 Aug 2022 09:08:11 +0000
Message-ID: <5e749d5e-08d9-81c9-0f46-a06be2d752ce@epam.com>
References: <20220825141918.3581-1-jgross@suse.com>
In-Reply-To: <20220825141918.3581-1-jgross@suse.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46d43a07-18b9-4e19-ebec-08da87428034
x-ms-traffictypediagnostic: AM6PR03MB4167:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WGmNOb1e8MXpgZnLPHIKXD5XCv83b2nZwvbcvnjLp4v0m/w5bOxtKg63UFTXjx+AQsWtud6rIvOPjZTIXkwpA2+5SL0o+ri2dhfwmPMpgaxIdflIeS2A8O3JRQAULx4Tx1ZhJbnci7fOYrkiKcbs+YUdLlf4yeOYRhIdlS1Kmv7sdncDSfth9HPWssUO0u8qcmTzlMhaZSfId2GrNd/9GKiJmrdaIJRKcDjNtL1wQBqiU8fRgcwbEefSIbIxJAxdDs3JZiUrdOIrUB2hmW63aNu0wSl+0iG9pbQ57WIaYqq5MRBuQX138H2hL29BVLhSTJnPl3rV2yftoESUtZWJm8//gNFcFq/p3vxUXFyU6Un1dDn5KSYZvaOCWO1qR2Sbr5/8v0xK/ELqvgZycwoTg4RHKM9f4moWSweoNPONK+5O8WwYlQd/ZzPVD5Y/lL/rN3+cPjZsshPxCquY0W9Ry8RemplFvrbc5BysxYpubaY+yTabUjBSVaZAGK2FFTUVFKhdpYVrLKmaaH9dForAhVrye0BeTpwjdQy0yrBsiZ4FGPpJmHlYhRWm1ItXtZbsUQYgntkS+6HmaWdc/16e3t1R1/REk2p1/E/QblFwx/y6ToDIDw6+h89GgoTuW966MfsIPOCWlNW/zKnv7rnfeQO5DDCVY2VU+ETqNAgQABSr3M1djh+NaVivz4PQlxivsHiatCZSpMu6W9Epdb3B/dtYVT0JEJxeyKpvFopPu3BNovhA3tfXdKzYjJpzBI48C5fTYIZw29m4gVKTNOrJ2amUgmIPtbbrazePlo+gY/0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR03MB6108.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(5660300002)(66556008)(66946007)(66446008)(31686004)(316002)(66476007)(38100700002)(110136005)(122000001)(4326008)(91956017)(8676002)(64756008)(71200400001)(76116006)(41300700001)(478600001)(54906003)(8936002)(6486002)(36756003)(26005)(2616005)(31696002)(55236004)(2906002)(6506007)(186003)(6512007)(53546011)(83380400001)(38070700005)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlNrbllMVzVIOXpTTUZaWlJjSkU4ZFo2RHdEcWV5eTFoazE1VWpVNTRqT2Q2?=
 =?utf-8?B?MGhwOWI4L2tZS25uaVA2NVNWc0hpOVNVUzdkYldWSnYvQXZZb1JUQkYrNFBz?=
 =?utf-8?B?anFrcldlOUU2U1NIcUpqNklWY0FLRFc4SlFKa3pPbmg3dkZJWXhUbnV0KzB0?=
 =?utf-8?B?V0tYdU1QOUVkRU51aWNBdUEyZDFlbUlwaXRBNElValhnMTRBbEUvdXJtcXFJ?=
 =?utf-8?B?MEhFeTRtVEZOekFkRk52eHBhMDA0YU4wYXFwT0RLTXVlWVFJVzYwejFtQnJI?=
 =?utf-8?B?K3JjcURGRE9GNGlXT3F1aXZPRVJVZTBMNVEwS2U2Um9teEo4ZXdLVVR5MDhS?=
 =?utf-8?B?UUM1bWpZVURtbG4ycGwvYk56Qm5NVWhjazRWdU52RDM1cFdCUnFsTUFGMkEy?=
 =?utf-8?B?MnJWd3pIV0tLN2dTUVNZZlZSNVBZR2VCZFZLT2xFN0RKVUlTUkNZYWNZWnN5?=
 =?utf-8?B?MkowWEJIY2x3YmxvWVE2RXFHcGl2Z011L0c1ZmNlSU93NC8wcFVUKzhydGlY?=
 =?utf-8?B?Rk5PVHBmMUNsd25FTTdkRjBUazE0c1d1TDBwVUFBYmVEU01hdWlaaWJEdmFt?=
 =?utf-8?B?cEpBWFM4cjFGenRYZXNLN0lPQVFQNnJiaW9nY1FSQnMxeEE0bnF4VTIybTV0?=
 =?utf-8?B?a0d5cURBZDg0VDhNQSt3M0NodHQ4SnZDVnNiKzlGU1dkdGZJaTR2blB0Y0VY?=
 =?utf-8?B?TWRtTHJFSy9QZ3AyUjd4RFFkSzZHR0dYS2xSTXRES0RuZjZKNit1aCtna1Bm?=
 =?utf-8?B?N3h6dDlEMStodFdiaU0ybVJsbFRkMFF0QWVSQkdLWjIwSUZablJlSE1tVEpu?=
 =?utf-8?B?bFVtMWVxbEVmY20xb2ZpeG04TEZ6cjRSRlVtUUZ1UTlEaEhldnZOY2hRZThz?=
 =?utf-8?B?Rkx6UFZkZHlWa0Z4d0R1bVV6dWppaUNkK2JZRGJmTmVoTTRXSGpKZVdmaEM0?=
 =?utf-8?B?RVhoSCtzSi81OHg4Qmp1bjN5TWgvQ3pFd2R4OTM2TVpuSXlCcXNmVHJlSlhG?=
 =?utf-8?B?bURrczlCeHRmcVdEeVkxaC9lVC91STk5Vkpna3FLVzZ4TnFRUVhEWFhGNVdo?=
 =?utf-8?B?Rjk0dUduSURmbmZGaEMzQXR3dW5LTnA1RjJZM0pEN01WTnVNNVVNempGNFlW?=
 =?utf-8?B?c1BHdlZUSktvRjUwN2FxMUd4RTI1VWttWjZqMlRocDJvZUJIc0NzdHlSVGtt?=
 =?utf-8?B?ZXp1cm5VOUpsUzN2TjhXM0RZRlNJaHRkL3RPWlNuTkg4TnZJdWkxOFZoc003?=
 =?utf-8?B?MUFiU0JZTWs4eUhpQkhZK0ZQUG8ybXpDK3JrSEp0TnllSThINm9oNnFwZ2ow?=
 =?utf-8?B?bnN3cnNaOVFGdDBZK2o5QzM4ZE94dTVSNkx5SVMvUVB4ZFJ3UzNURDZVR3NT?=
 =?utf-8?B?U25lRWMwTkZoRFZYYU11Q0s3MXFBMnZLVWwvZGtld3hyaU8xTkltd2hZbmgy?=
 =?utf-8?B?ME9PaGRWWTJsK1dORnVnTkVJOEUvWDcxcW9vNGIrNmw4QlhuYVV5cUJYY3M2?=
 =?utf-8?B?RHlOMXhQcWlVNmk5dDBBT3UyVkZWVVhQbWExaENaNzFLdW5seTBmY2VJcGlz?=
 =?utf-8?B?QWZFNHNRTXRDQ0tBRUNjZHFnMHlWaUVWVDZxYURqT0NsdkFqMDRWbDFxZzE1?=
 =?utf-8?B?Yi9Qa3BPZlNQSmJkcC8rcmp4VXNNaVg4bWRwZWxnMFZpWkZiNTN2eEowNXlz?=
 =?utf-8?B?THVCaGFXVHV4L0Jyd2lmQldRbWx2a1h0Vm1KY1hlNk9wNC9JK1kxb3gzc3Z0?=
 =?utf-8?B?UndqdXdrbFNhNGZQVzNpUGt3QmxjbDBGSVU4Y2RSUkFDMFF5ZVQxTGZQNVlN?=
 =?utf-8?B?UXllZGQxVDhsWERTSm9xczJoMWQ3ZE9lSnZEajBvTEhNVW9CV1NIM2hGVEg4?=
 =?utf-8?B?WXRjSXdiNVNmVTV4eHcwYThrbHVTaHB0Qi91NEw5cHhGTG1Pdk9QUjJwM2k3?=
 =?utf-8?B?MFo2SVMyQVIyb1YzR3lVR3N5RUxud3BHdGgvbm1Id1RjbnE0eG9KcHBvUDRK?=
 =?utf-8?B?YmtFbU80bTFiUHAyMXc4ZmlOQzNBb0VGb1kzMXZKSEhDeHlxYjlXMXBkT0ZC?=
 =?utf-8?B?cDNvTVozcWVXd0l3Q3BkdjVwaERtaHFSNllZa29zUmVqZWFnZFp2eDVXUWln?=
 =?utf-8?B?YTJXR0x4aXZVdG5kYy9rVUhKYTl5ZUUrTHFhcXI0K0RzdGtWaHdudXVJcm5a?=
 =?utf-8?Q?/+v6+yvqbbqDlVe+tPTq6Bo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34495C8E6CAF4748A67A82ED599BA9FA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR03MB6108.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d43a07-18b9-4e19-ebec-08da87428034
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 09:08:11.4733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YKBeVOt41cUJofHr0TpryZQJ/7jQjOwhnIa7TbSHZQafVobbg1NmgOlfZyHjW95fBMeLwrDYr0hTlF09/jNCGjm6ugD2BkUCMi5aDUXL2yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4167
X-Proofpoint-GUID: IAEABwg7PFarVHJLh8kgXK89RxMT2wzU
X-Proofpoint-ORIG-GUID: IAEABwg7PFarVHJLh8kgXK89RxMT2wzU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260035
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiAyNS4wOC4yMiAxNzoxOSwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCg0KSGVsbG8gSnVlcmdl
bg0KDQo+IFRoZSBlcnJvciBleGl0IG9mIHByaXZjbWRfaW9jdGxfZG1fb3AoKSBpcyBjYWxsaW5n
IHVubG9ja19wYWdlcygpDQo+IHBvdGVudGlhbGx5IHdpdGggcGFnZXMgYmVpbmcgTlVMTCwgbGVh
ZGluZyB0byBhIE5VTEwgZGVyZWZlcmVuY2UuDQo+DQo+IEFkZGl0aW9uYWxseSBsb2NrX3BhZ2Vz
KCkgZG9lc24ndCBjaGVjayBmb3IgcGluX3VzZXJfcGFnZXNfZmFzdCgpDQo+IGhhdmluZyBiZWVu
IGNvbXBsZXRlbHkgc3VjY2Vzc2Z1bCwgcmVzdWx0aW5nIGluIHBvdGVudGlhbGx5IG5vdA0KPiBs
b2NraW5nIGFsbCBwYWdlcyBpbnRvIG1lbW9yeS4gVGhpcyBjb3VsZCByZXN1bHQgaW4gc3BvcmFk
aWMgZmFpbHVyZXMNCj4gd2hlbiB1c2luZyB0aGUgcmVsYXRlZCBtZW1vcnkgaW4gdXNlciBtb2Rl
Lg0KPg0KPiBGaXggYWxsIG9mIHRoYXQgYnkgY2FsbGluZyB1bmxvY2tfcGFnZXMoKSBhbHdheXMg
d2l0aCB0aGUgcmVhbCBudW1iZXINCj4gb2YgcGlubmVkIHBhZ2VzLCB3aGljaCB3aWxsIGJlIHpl
cm8gaW4gY2FzZSBwYWdlcyBiZWluZyBOVUxMLCBhbmQgYnkNCj4gY2hlY2tpbmcgdGhlIG51bWJl
ciBvZiBwYWdlcyBwaW5uZWQgYnkgcGluX3VzZXJfcGFnZXNfZmFzdCgpIG1hdGNoaW5nDQo+IHRo
ZSBleHBlY3RlZCBudW1iZXIgb2YgcGFnZXMuDQo+DQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVs
Lm9yZz4NCj4gRml4ZXM6IGFiNTIwYmU4Y2Q1ZCAoInhlbi9wcml2Y21kOiBBZGQgSU9DVExfUFJJ
VkNNRF9ETV9PUCIpDQo+IFJlcG9ydGVkLWJ5OiBSdXN0YW0gU3Via2hhbmt1bG92IDxzdWJraGFu
a3Vsb3ZAaXNwcmFzLnJ1Pg0KPiBTaWduZWQtb2ZmLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NA
c3VzZS5jb20+DQoNCg0KSSBoYXZlbid0IHNwb3R0ZWQgYW55IGlzc3VlczoNCg0KUmV2aWV3ZWQt
Ynk6IE9sZWtzYW5kciBUeXNoY2hlbmtvIDxvbGVrc2FuZHJfdHlzaGNoZW5rb0BlcGFtLmNvbT4N
Cg0KDQo+IC0tLQ0KPiBWMjoNCj4gLSB1c2UgInBpbm5lZCIgYXMgcGFyYW1ldGVyIGZvciB1bmxv
Y2tfcGFnZXMoKSAoSmFuIEJldWxpY2gpDQo+IC0gZHJvcCBsYWJlbCAidW5sb2NrIiBhZ2FpbiAo
SmFuIEJldWxpY2gpDQo+IC0gYWRkIGNoZWNrIGZvciBjb21wbGV0ZSBzdWNjZXNzIG9mIHBpbl91
c2VyX3BhZ2VzX2Zhc3QoKQ0KPiBWMzoNCj4gLSBjb250aW51ZSBhZnRlciBwYXJ0aWFsIHN1Y2Nl
c3Mgb2YgcGluX3VzZXJfcGFnZXNfZmFzdCgpIChKYW4gQmV1bGljaCkNCj4gVjQ6DQo+IC0gZml4
IGNhc2Ugb2YgbXVsdGlwbGUgcGFydGlhbCBzdWNjZXNzZXMgZm9yIG9uZSBidWZmZXIgKEphbiBC
ZXVsaWNoKQ0KPiAtLS0NCj4gICBkcml2ZXJzL3hlbi9wcml2Y21kLmMgfCAyMSArKysrKysrKysr
Ky0tLS0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMTAgZGVs
ZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9wcml2Y21kLmMgYi9kcml2
ZXJzL3hlbi9wcml2Y21kLmMNCj4gaW5kZXggMzM2OTczNDEwOGFmLi5lODhlOGY2ZjBhMzMgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMveGVuL3ByaXZjbWQuYw0KPiArKysgYi9kcml2ZXJzL3hlbi9w
cml2Y21kLmMNCj4gQEAgLTU4MSwyNyArNTgxLDMwIEBAIHN0YXRpYyBpbnQgbG9ja19wYWdlcygN
Cj4gICAJc3RydWN0IHByaXZjbWRfZG1fb3BfYnVmIGtidWZzW10sIHVuc2lnbmVkIGludCBudW0s
DQo+ICAgCXN0cnVjdCBwYWdlICpwYWdlc1tdLCB1bnNpZ25lZCBpbnQgbnJfcGFnZXMsIHVuc2ln
bmVkIGludCAqcGlubmVkKQ0KPiAgIHsNCj4gLQl1bnNpZ25lZCBpbnQgaTsNCj4gKwl1bnNpZ25l
ZCBpbnQgaSwgb2ZmID0gMDsNCj4gICANCj4gLQlmb3IgKGkgPSAwOyBpIDwgbnVtOyBpKyspIHsN
Cj4gKwlmb3IgKGkgPSAwOyBpIDwgbnVtOyApIHsNCj4gICAJCXVuc2lnbmVkIGludCByZXF1ZXN0
ZWQ7DQo+ICAgCQlpbnQgcGFnZV9jb3VudDsNCj4gICANCj4gICAJCXJlcXVlc3RlZCA9IERJVl9S
T1VORF9VUCgNCj4gICAJCQlvZmZzZXRfaW5fcGFnZShrYnVmc1tpXS51cHRyKSArIGtidWZzW2ld
LnNpemUsDQo+IC0JCQlQQUdFX1NJWkUpOw0KPiArCQkJUEFHRV9TSVpFKSAtIG9mZjsNCj4gICAJ
CWlmIChyZXF1ZXN0ZWQgPiBucl9wYWdlcykNCj4gICAJCQlyZXR1cm4gLUVOT1NQQzsNCj4gICAN
Cj4gICAJCXBhZ2VfY291bnQgPSBwaW5fdXNlcl9wYWdlc19mYXN0KA0KPiAtCQkJKHVuc2lnbmVk
IGxvbmcpIGtidWZzW2ldLnVwdHIsDQo+ICsJCQkodW5zaWduZWQgbG9uZylrYnVmc1tpXS51cHRy
ICsgb2ZmICogUEFHRV9TSVpFLA0KPiAgIAkJCXJlcXVlc3RlZCwgRk9MTF9XUklURSwgcGFnZXMp
Ow0KPiAtCQlpZiAocGFnZV9jb3VudCA8IDApDQo+IC0JCQlyZXR1cm4gcGFnZV9jb3VudDsNCj4g
KwkJaWYgKHBhZ2VfY291bnQgPD0gMCkNCj4gKwkJCXJldHVybiBwYWdlX2NvdW50ID8gOiAtRUZB
VUxUOw0KDQoNCltub3QgcmVsYXRlZCB0byB0aGUgY3VycmVudCBwYXRjaF0NCg0KSSBqdXN0IHdv
bmRlciwgd2hldGhlciBkcml2ZXJzL3hlbi9nbnRkZXYuYzpnbnRkZXZfZ2V0X3BhZ2UoKSByZWFs
bHkgDQp3YW50cyB0byBnYWluIHRoZSBzYW1lIGNoZWNrPw0KDQppbmRleCA1OWZmZWE4MDAwNzku
LjQ1ZTE2MDMxMjA0ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMveGVuL2dudGRldi5jDQorKysgYi9k
cml2ZXJzL3hlbi9nbnRkZXYuYw0KQEAgLTc0MCw4ICs3NDAsOCBAQCBzdGF0aWMgaW50IGdudGRl
dl9nZXRfcGFnZShzdHJ1Y3QgZ250ZGV2X2NvcHlfYmF0Y2ggDQoqYmF0Y2gsIHZvaWQgX191c2Vy
ICp2aXJ0LA0KIMKgwqDCoMKgwqDCoMKgIGludCByZXQ7DQoNCiDCoMKgwqDCoMKgwqDCoCByZXQg
PSBwaW5fdXNlcl9wYWdlc19mYXN0KGFkZHIsIDEsIGJhdGNoLT53cml0ZWFibGUgPyANCkZPTExf
V1JJVEUgOiAwLCAmcGFnZSk7DQotwqDCoMKgwqDCoMKgIGlmIChyZXQgPCAwKQ0KLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCivCoMKgwqDCoMKgwqAgaWYgKHJldCA8
PSAwKQ0KK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldCA/IDogLUVGQVVM
VDsNCg0KIMKgwqDCoMKgwqDCoMKgIGJhdGNoLT5wYWdlc1tiYXRjaC0+bnJfcGFnZXMrK10gPSBw
YWdlOw0KDQoNCg0KPiAgIA0KPiAgIAkJKnBpbm5lZCArPSBwYWdlX2NvdW50Ow0KPiAgIAkJbnJf
cGFnZXMgLT0gcGFnZV9jb3VudDsNCj4gICAJCXBhZ2VzICs9IHBhZ2VfY291bnQ7DQo+ICsNCj4g
KwkJb2ZmID0gKHJlcXVlc3RlZCA9PSBwYWdlX2NvdW50KSA/IDAgOiBvZmYgKyBwYWdlX2NvdW50
Ow0KPiArCQlpICs9ICFvZmY7DQo+ICAgCX0NCj4gICANCj4gICAJcmV0dXJuIDA7DQo+IEBAIC02
NzcsMTAgKzY4MCw4IEBAIHN0YXRpYyBsb25nIHByaXZjbWRfaW9jdGxfZG1fb3Aoc3RydWN0IGZp
bGUgKmZpbGUsIHZvaWQgX191c2VyICp1ZGF0YSkNCj4gICAJfQ0KPiAgIA0KPiAgIAlyYyA9IGxv
Y2tfcGFnZXMoa2J1ZnMsIGtkYXRhLm51bSwgcGFnZXMsIG5yX3BhZ2VzLCAmcGlubmVkKTsNCj4g
LQlpZiAocmMgPCAwKSB7DQo+IC0JCW5yX3BhZ2VzID0gcGlubmVkOw0KPiArCWlmIChyYyA8IDAp
DQo+ICAgCQlnb3RvIG91dDsNCj4gLQl9DQo+ICAgDQo+ICAgCWZvciAoaSA9IDA7IGkgPCBrZGF0
YS5udW07IGkrKykgew0KPiAgIAkJc2V0X3hlbl9ndWVzdF9oYW5kbGUoeGJ1ZnNbaV0uaCwga2J1
ZnNbaV0udXB0cik7DQo+IEBAIC02OTIsNyArNjkzLDcgQEAgc3RhdGljIGxvbmcgcHJpdmNtZF9p
b2N0bF9kbV9vcChzdHJ1Y3QgZmlsZSAqZmlsZSwgdm9pZCBfX3VzZXIgKnVkYXRhKQ0KPiAgIAl4
ZW5fcHJlZW1wdGlibGVfaGNhbGxfZW5kKCk7DQo+ICAgDQo+ICAgb3V0Og0KPiAtCXVubG9ja19w
YWdlcyhwYWdlcywgbnJfcGFnZXMpOw0KPiArCXVubG9ja19wYWdlcyhwYWdlcywgcGlubmVkKTsN
Cj4gICAJa2ZyZWUoeGJ1ZnMpOw0KPiAgIAlrZnJlZShwYWdlcyk7DQo+ICAgCWtmcmVlKGtidWZz
KTsNCg0KLS0gDQpSZWdhcmRzLA0KDQpPbGVrc2FuZHIgVHlzaGNoZW5rbw0K
