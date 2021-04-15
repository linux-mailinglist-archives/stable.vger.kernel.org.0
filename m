Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7505D3602FB
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 09:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhDOHLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 03:11:03 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:57084 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDOHLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 03:11:03 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5E0CDC0619;
        Thu, 15 Apr 2021 07:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618470640; bh=x8OYprnuDzBAzXqAKKwK7dCG+nyCizp4Wovx4gW2YEU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=b8eX0VIZS8sXgcGPVBb30BLB0xhQqUn0uDjiRn27TudTkRdOUVmECmpDp2XAGVHhU
         G3U0hqWaSOtAyBB2uitFupYb6K2ykAET3aaci5PFPYJ63fHO1qDNmMNfhK5yHS07XJ
         e2GZakG+8+/ldLpJT4KT24jNNparDJosVvT/7IffCf0JuB/eAk+Pwpr775tGV9u4I6
         RNEdXMVOiWxDwUT6J/MRNoWYZqmIPyOWRap7zm2zQjb3usnNTRMx0EPgAt/GHWVeCJ
         +lcYPpjDPTK6o5NJuyroSf+NoEeytynr89/UpH0J0RZD76abIVp6ryhxw8x3E1gH6x
         sTG8UiyVHDr6w==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id AAB77A00A9;
        Thu, 15 Apr 2021 07:10:39 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2057.outbound.protection.outlook.com [104.47.36.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 2185B8012B;
        Thu, 15 Apr 2021 07:10:39 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="WXEJiZkb";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8PV/qpwfP30CqzHc2fV51asEqY7DCIcBPwaCwajOabap26GtKf3cG78cWpWy6xSFQKk/9HhWI9uoYZTbZSZnwPi3aDYU06pjh+G4rk+2QDDP4YK6kNKSG+KAv57bygwIJBafzp7ZkCts1Pu9fZJF8ExDm6GrTnnaBvncGoR5c8HneQqN+ULN09P78MmiJHKuU0OdJhC0vdZ66U7GFIV2vP8IUApy3SDkTSv3eqh7jyUuVcVc2XWuPp2asU07pyG7HefyV97cjOpYNMp6IjwFsAxJBHaXpamDvR9atwNj8Md9vSzh248mL4OS890Bs2WAvtfcxdkN0mAq6a7AVUL5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8OYprnuDzBAzXqAKKwK7dCG+nyCizp4Wovx4gW2YEU=;
 b=XQd4nrztCJ99CdTzOWpTtOv7fHezJO/pGBTDhk1g5SFHbllcR9ZLdHA0DO1HODHXBd5cJv2rUmEMUXqPtrqtIJOj2gfXfR+hOJ3ciPjXYelRHqqHtqZtZNey+yvM0yJLaqQ1Nenozvljf0NDxUu65reU4Wa4gWvDRVz/FsWJj883Ii0oqgRCsWLeDOecz5aWpIEyeGAKxaM5PAjYlmxhqyHF1qwuXWXA00yRegPq2dxzZvWsYBdRhHbP4JxVuocnF8yWdYiGVnuGcWb1wgAjveJtGFYCBdHrgbnvZ7zXvXkaThhzxv+p8/q6AzDaaZFngUWoNhBABpwR9nGaPeXuJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8OYprnuDzBAzXqAKKwK7dCG+nyCizp4Wovx4gW2YEU=;
 b=WXEJiZkb2I1bJ5GR15lZ//cVu+/LN/br6siOL2OmckItPq0NJfiQ4Ug0zJwuR1QSd2UHSHAWlpZCW8NUnEgv/nKdZVL8fVeThUSqFa7gYXrNbjtzJVxGPNqjfpYC2wr+QvgvA2wXGFJrQcqhyo1kYxAKLb622SlxRftWi1gQFJ0=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 07:10:37 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.016; Thu, 15 Apr 2021
 07:10:37 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Remove FS bInterval_m1 limitation
Thread-Topic: [PATCH] usb: dwc3: gadget: Remove FS bInterval_m1 limitation
Thread-Index: AQHXMZAFKpdfCRvrWkC1TQQuwUUqH6q1HQ+AgAAMrgA=
Date:   Thu, 15 Apr 2021 07:10:36 +0000
Message-ID: <a75605ef-3fe1-fdd0-d3da-b6421f932621@synopsys.com>
References: <c2049798e1bce3ea38ae59dd17bbffb43e78370c.1618447155.git.Thinh.Nguyen@synopsys.com>
 <87pmywnjxy.fsf@kernel.org>
In-Reply-To: <87pmywnjxy.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed9a4f8a-2c99-4759-df5f-08d8ffdd91c9
x-ms-traffictypediagnostic: BYAPR12MB4791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB479170530E788751C436828FAA4D9@BYAPR12MB4791.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TPX+5JKco0R9X9hetB8+BC9h+cz9VdUoSQh0B0C2LNrjhRZl/YYTk0PyM9w0B10tLzAdmC49oHZFmfE6PE2ILj8OgFsDYStdrE3G/4ds1O/Sbwosp1res5jZ20diBxcvgA/Op/GukCy+ztWdPbdVcDoyCulBAaejUAaCmko2Zc74B9BzvehpuFz9iT4cVoBPYKQiNO0cv2HVL4Id9RSZWmzwiZ2c3AFVuuzmAcAi0vzsd8/VDTmzk/Xfe/QpTzMVgcKzg9iHJjXBBITVX1yJ4FpidOwkmH3r20RgpcbcDQME3F62OP9M25D5LGLUkIomab30zh++GzOhqH1QwP4KgqXykDrdN1K9cqU2GPHTk5k0FKvJbW6AuQV8HvLijt4xf/Sy4zCo6ZurDjlp2mFzmkm52mYu1t+Bb7Na1HYQZ/V4U/rf32f5u1q8iR6ZYotYrJS8TuBxKvP0lSbOw3SsRyBaxPyJHycrZo1je+8Ia7VSfN4x+7OP/JGGdNod3EsVNc11n8NttxyvUVdV2/sUSWTuXtsffgV01q7/wd/tc2joWr7nsV6M5SObOYVCq/VDrM861wVQwRpJUH7sHWwQXrm4ZQpjkLqyZkatKots1+fwMGAJmTziMP+dXUh2Xz4rfpnedjng8jvHu7j3yuUTBmxYd+U3EJyJqQU4ilNDoR8MX320gWbG2NhNoKYa9wiU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39860400002)(136003)(478600001)(31686004)(6506007)(186003)(71200400001)(8936002)(8676002)(4326008)(83380400001)(86362001)(36756003)(66946007)(66446008)(66556008)(54906003)(2616005)(316002)(38100700002)(110136005)(5660300002)(31696002)(64756008)(66476007)(6486002)(2906002)(122000001)(6512007)(26005)(76116006)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bXA1OGE0aU5wZjRQMnA2WnJwb2s0ekp3ckd2bXQzNUhBenl5ZnBXMEtXYTk5?=
 =?utf-8?B?cU9MMGxjdEUwUnlkVzlJZ1FxaTlCaWJKVWVBdnBMQWlxTGw5MndsakxJU3JG?=
 =?utf-8?B?c2FBbGYrMjk0VEQrUzNMbzg4aUxNUVBKeEliSnFOaWtwTHBuenNVeHRnY0Fu?=
 =?utf-8?B?M0h0eC9zQS9adFQwc0dwSHhTL3hBRUNoOE1oMS84ZXpMemxJUUFnQUZtenlL?=
 =?utf-8?B?L3ZpMVdVMm5aZmw3c2VFRDdJUFdIVXk1RzVPbnhlSFJJbkxlK0NDLzFuZ2Ez?=
 =?utf-8?B?aWR5UWU0bGN5TFRHVUV1aVZ3TUs3czd5VGJNZk80SlVXT1ZBU21Jd2VJd3hU?=
 =?utf-8?B?SStJRUdxZENZYlpJK0VJalBrcUF3enRxL3hORkthQ3E4MENnNkhzU1N4RUln?=
 =?utf-8?B?b3k1ZkRieUNPejhEeG5vRFpvUjNRMUNySXJPZXg2UUNoSkU5aTNFUFA2R1VH?=
 =?utf-8?B?blpocFZWYmNVOWlmdlpZTUtackRkckNBTmJHWi9oRWFMdUIyVDlEM0JRdlE4?=
 =?utf-8?B?QjBuTG5yTXZLWU1zbVE4KzA4MkxOdi93Q2Z2TlZ2SCtBd0REem16WmVBRUJZ?=
 =?utf-8?B?bGtEYk9EcVAya1VUNXB4YmZ0U05oRTM1aW5UamQxUjU2ZEEvMWJITmJHZHhs?=
 =?utf-8?B?ZUUwQW5pRlRYNWQzUjBIY3N3K0ZkUHFhZWdiN1JlQ2J6RUV6eldKOU03TDZ5?=
 =?utf-8?B?MGVoSkVVUnRyanJMdzZoRms2SzR2amJWbzNsbThoTXdlRU85VFY2dm5FU01R?=
 =?utf-8?B?Uk1vdG1OTWp2ZGpFUDAydXlXdTVJQVN4VnZDcS9WblMwUXdDTGVaVVNMWEpp?=
 =?utf-8?B?T2lyM25jVFNydTYwOUpZS3RzYkdjYUpGc0xmZEVGTFIxMnI0MXVrZlROdHI4?=
 =?utf-8?B?SjY4SjJMTXgrVVI3dVQ1RFBPdUtpbE1MMCs2NUNRNWxrby92NjhrWTM3dkUy?=
 =?utf-8?B?NGxDTmd6ZndHZVBNeHpMRCtrQS84VEFsZVZzbkdoTjFsYjVjWHJhM3hlbCt6?=
 =?utf-8?B?RmRZamJGSUw5Zzc5VVBVODErZm5UQXNNK01GRDJOZ3liWWNCd1dNNVVDMFI0?=
 =?utf-8?B?Y3ZiWE9BbyttTFo0WXhZMU9pWlJZRlNZdjdUWmZzS0lNTytEd0tNbHdLN3BW?=
 =?utf-8?B?V0J3T0dGMm9JcVRROUlTR09JRVdqT3pEZm5Nc1ZINHV3b1QrZW1MeUg2bndT?=
 =?utf-8?B?Q3JhT3Jkak8wZnFST0k0MitFcitjcUhMMFlBTld2bEdJMXMvTjJBVUdhbzMz?=
 =?utf-8?B?UnlZNUViVE5IdnNxTWFRZmZKNlpndjNHdVNmY29wT2xHQkJ2ZUFxYlVidGlH?=
 =?utf-8?B?UjljK2x0eUZ2aUxobFJhSFp0WmlEcUFuVThMZGNIVkw5bWVVWUR2eDFuTXA5?=
 =?utf-8?B?MlVQMUtJd0NxY3Z0Mk16K0I3STZ0UkU2d3JvbFJiZkpuYlRhQUN0R1FOdkNn?=
 =?utf-8?B?UEhMY3o2OFFON2JIYk1DcllSTTlJNTFjOHhZc1phWFBtbHZLR1BLYzhkTWd4?=
 =?utf-8?B?eDNKaEV0RzVDSjhCSzE2V2dhdW9adWlUaStLdWFIQWg1TjR6YXRYQ1hkNGxk?=
 =?utf-8?B?SUJzZVFyVmcySGo2TFBySGlzRjZCTEhqV0dxak5DWldxK3REalNvbjhzVnRu?=
 =?utf-8?B?enJqMVg3MExPemNuM3A4ajZ0azg2QWZNRk9TOUlJOUxGSkY0QTdWWWNLSi80?=
 =?utf-8?B?SlRPdkd0dVcvSWg4MlJyRytXcG9kamJWUmVjbjFFMktwcUNlNzBDMFVoSVVZ?=
 =?utf-8?Q?ZyQh4KgcurLcaqMrHPXSYtAqlZMRk3ZTp2t7aWh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0052A652A5241842B6755FFEE65EB069@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9a4f8a-2c99-4759-df5f-08d8ffdd91c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 07:10:36.9757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9vnpq8bFgOrrX5V2J2TPf4XK8gxYXbz81CmJWR5QCPWH7uelQEioFu/IeS6il095wviH1P18JkzAzmU+wQkZ9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4791
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RmVsaXBlIEJhbGJpIHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiBUaGluaCBOZ3V5ZW4gPFRoaW5o
Lk5ndXllbkBzeW5vcHN5cy5jb20+IHdyaXRlczoNCj4+IFRoZSBwcm9ncmFtbWluZyBndWlkZSBp
bmNvcnJlY3RseSBzdGF0ZWQgdGhhdCB0aGUgRENGRy5iSW50ZXJ2YWxfbTEgbXVzdA0KPj4gYmUg
c2V0IHRvIDAgd2hlbiBvcGVyYXRpbmcgaW4gZnVsbHNwZWVkLiBUaGVyZSdzIG5vIHN1Y2ggbGlt
aXRhdGlvbiBmb3INCj4+IGFsbCBJUHMuDQo+IA0KPiBkbyB3ZSBoYXZlIGFuIHVwZGF0ZWQgRGF0
YWJvb2sgY29ycmVjdGluZyB0aGlzIHN0YXRlbWVudD8NCg0KTm90IHlldC4gV2UncmUgaW4gdGhl
IHByb2Nlc3Mgb2YgdXBkYXRpbmcgdGhlIGRhdGFib29rIGZvciB0aGlzDQpwYXJ0aWN1bGFyIGlz
c3VlLg0KDQo+IA0KPj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4gRml4ZXM6IGEx
Njc5YWY4NWIyYSAoInVzYjogZHdjMzogZ2FkZ2V0OiBGaXggc2V0dGluZyBvZiBERVBDRkcuYklu
dGVydmFsX20xIikNCj4+IFNpZ25lZC1vZmYtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVu
QHN5bm9wc3lzLmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgfCA5
ICsrKysrLS0tLQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgYi9k
cml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+PiBpbmRleCA2MjI3NjQxZjJkMzEuLmQ4N2EyOWJk
N2Q5YiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4+ICsrKyBi
L2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4+IEBAIC02MDgsMTIgKzYwOCwxMyBAQCBzdGF0
aWMgaW50IGR3YzNfZ2FkZ2V0X3NldF9lcF9jb25maWcoc3RydWN0IGR3YzNfZXAgKmRlcCwgdW5z
aWduZWQgaW50IGFjdGlvbikNCj4+ICAJCXU4IGJJbnRlcnZhbF9tMTsNCj4+ICANCj4+ICAJCS8q
DQo+PiAtCQkgKiBWYWxpZCByYW5nZSBmb3IgREVQQ0ZHLmJJbnRlcnZhbF9tMSBpcyBmcm9tIDAg
dG8gMTMsIGFuZCBpdA0KPj4gLQkJICogbXVzdCBiZSBzZXQgdG8gMCB3aGVuIHRoZSBjb250cm9s
bGVyIG9wZXJhdGVzIGluIGZ1bGwtc3BlZWQuDQo+PiArCQkgKiBWYWxpZCByYW5nZSBmb3IgREVQ
Q0ZHLmJJbnRlcnZhbF9tMSBpcyBmcm9tIDAgdG8gMTMuDQo+PiArCQkgKg0KPj4gKwkJICogTk9U
RTogVGhlIHByb2dyYW1taW5nIGd1aWRlIGluY29ycmVjdGx5IHN0YXRlZCBiSW50ZXJ2YWxfbTEN
Cj4+ICsJCSAqIG11c3QgYmUgc2V0IHRvIDAgd2hlbiBvcGVyYXRpbmcgaW4gZnVsbHNwZWVkLiBJ
bnRlcm5hbGx5IHRoZQ0KPj4gKwkJICogY29udHJvbGxlciBkb2VzIG5vdCBoYXZlIHRoaXMgbGlt
aXRhdGlvbi4NCj4gDQo+IG1pZ2h0IGJlIGEgZ29vZCBpZGVhIHRvIHJlZmVyIHRvIHRoZSBzZWN0
aW9uIGluIHRoaXMgY29tbWVudCA7LSkNCj4gDQoNCkkgY2FuIHJlc2VuZCB3aXRoIHRoZSBzZWN0
aW9uIG51bWJlci4NCg0KQlIsDQpUaGluaA0K
