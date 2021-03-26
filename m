Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0196834A8C8
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhCZNq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:46:57 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:45012 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhCZNpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Mar 2021 09:45:54 -0400
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 545A5C0186;
        Fri, 26 Mar 2021 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1616766347; bh=0FoFJwVf97wkNndyAIt0gCI96C4YmLzjpgRCJVi7eak=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=OGx6rnsl5XbjNgMlSTn4KDiJR20LqGJwQnquYsU18oXVejbcy4yiTGmHYKdI4ijoy
         I8vwYmXyvcffKa5NaASwHlwACPbozKNz42XCFsXOd6iC0DZdWKNF4IgOPfOw3KHHxT
         2FV5OXCwEBExtf9A5NSQMTNQQ2x5AJRKtlFd6Y4D2Q919WcMqnw6zVTcn/bHBH3Szq
         2jU+gsMS2YxaItGxbgq7XCOjHKDb2XuG0NGeZA9cVSzOXtr8ih9lNUbC0IW6uuk1WF
         1Zh3IKpi8ZPBuwpmrtGqZwXAvT0dRxTMGlJc7i3TFQcYEKzvkX5ixag/J8K0l+cAoT
         Hum0ngyGFGuYQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 4C2C2A007C;
        Fri, 26 Mar 2021 13:45:45 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 7B9BD400CC;
        Fri, 26 Mar 2021 13:45:43 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=arturp@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="GhKMO9f2";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4lmZoucJTiEJU7UbzlUHI20Ol8EOLPlBIbSH7VgRgSCSew4R4fxfYDTZjFVV54pHqQ9ajJupJt/luVVFNU1QMor/QO68tVY4xhSpiK8s+vf/jidXUsGdq+Vz3aKlUblLuXimVAmYFF2CsprFM7K+yIqHT/3IpDycXPKnW1+hIUFSZ2T6Q+MBcNHHfN50IBYqzmdAFPLZTI4kt9dWzW6/wDBupJ+G8sSA/sNRqn0oibHD2Sc24D7IxulF29dBTCeo5VJrRMn/0vWuol5YOC2fQ6M4982g2hnq6Y+lQlZFW3016LEnZmFrEZ39DDgI9YBdRQ2G2ELtOovrs6vKuva4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FoFJwVf97wkNndyAIt0gCI96C4YmLzjpgRCJVi7eak=;
 b=EU1dy6GF+roy6PYK/4NV4txxo61Q6mTVXJWW+qF5Sk1DT6txB6nna9pSkeDUlhJpuYl+TaEzjTyho4/H+Kqi82vUFoBLGXjwuW8LdnwCJxRxLhuBE4ZDFBfESFzlSljpoittRhov6WxBzIW6kFPnV3bGxBsNB43rC+GYRsb3a0w3dFqlq9ABJAhLrXpe/Z/NGJq48hyNB5mOrRQ7UBS8qkUjSXHz1pKO6aCl5tMK1TSatgolwKwWcW6nRP29A2YF7vjiXMDN6bRSM8jo1TEHvcOnAW4kVKvE7G1XrJJGXt6K1jzaYD5VbguoDuGsB7mQrY6AhA7m4YDSDEUQlSl6dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FoFJwVf97wkNndyAIt0gCI96C4YmLzjpgRCJVi7eak=;
 b=GhKMO9f23vVbSw3We3jBQbm9O+lebK3ZUF//grdnqZCAF/+9N+CVmUO7ZSwpqRbkecFRLEsmEW2tgnevlFQHmouZ/XJDaDRLYoj0CjkFuigFMKlQiOHXiMJEISn8stvpZ+EoeIBpkigNY1oQIApFqKJJYNg1DoZZGCk7nNSxDcg=
Received: from MW3PR12MB4428.namprd12.prod.outlook.com (2603:10b6:303:57::15)
 by MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 13:45:40 +0000
Received: from MW3PR12MB4428.namprd12.prod.outlook.com
 ([fe80::f555:1286:c942:61b2]) by MW3PR12MB4428.namprd12.prod.outlook.com
 ([fe80::f555:1286:c942:61b2%4]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 13:45:40 +0000
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Felipe Balbi <balbi@kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        John Youn <John.Youn@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "#@synopsys.com" <#@synopsys.com>,
        "4.18@synopsys.com" <4.18@synopsys.com>,
        "5.2@synopsys.com" <5.2@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH 0/3] usb: dwc2: Fix power saving general issues.
Thread-Topic: [PATCH 0/3] usb: dwc2: Fix power saving general issues.
Thread-Index: AQHXIiomF2QLdyhAzUCp5rMw1ILac6qWRLYAgAADkoA=
Date:   Fri, 26 Mar 2021 13:45:40 +0000
Message-ID: <d8f33c04-8632-ee13-a056-5f7b706fdcd3@synopsys.com>
References: <20210326102400.359EFA005C@mailhost.synopsys.com>
 <YF3ihMf3cHESK0cq@kroah.com>
In-Reply-To: <YF3ihMf3cHESK0cq@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=synopsys.com;
x-originating-ip: [46.162.196.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: daa74107-a4b8-4693-21e7-08d8f05d71d2
x-ms-traffictypediagnostic: MWHPR12MB1248:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR12MB12481BAC17B16859CCC13FDCA7619@MWHPR12MB1248.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Om5W+KKOuoA1EuY8+khW2cAj9wJ0AT8ypRnW+UlaZ2JRrS0BcXvDrSuzQgwIfQrM0u7yvaKlqwSppdTOcZgYVyg6kRPkduhTMbJA7kWs0Fr/DxQPQJol5qU0deMRalUr0Zp3dhgc3F9UjXhf2ron7Zx/zeEe9+o5q/tCq7i14ULhBuK6167jQ3wGRLmou0CI+VFdcM8EzlDz20VRFKgIIK/czfiT3v3cxug3mkjtKrhx9GwgorMlpYqdMx8/rxDu7vLh1oSmRxjxQMgyes8s/29E0cC7nAzdFudTdCphFtMnjT5AA+OVhCOwR9h5WS2J0Q1FOkhn+RSEHrePclO/TrI1vy1XfnghZ34LwI+iJTISG0LHYpKHrnySSQsiSCVLBZZ0ytXMfV/iYiB60CkphN0BMpARmZzeyELctP0Y+LMCHe9Rj3LdW4ZSQ7Tz2pdMGeJVBnLsMWSlOxSiGjZDx1oEhAH3kozzUoV1gI0UMOwA0Wbr+4DnDEUSyfs3nnNDnSKvTMdkDgskxdCj2wFtyHcrnrrLaiHNT/29V1aaWXDeUaUBywnjulDovwfMq2Qj57tNu7GE+JEzeMuZ1n9ZLvTNJS5wBtAXTK2Z6EluR4gP9m5t6AQscCQ2X//DSE7yZikgg//oNmfSxRRD33iZwjjXJmqm5WKgMCKWWXg4b2G8s2O/Ss4sD9PF+c++VHA7mSBbJPTY6z69PW//Aa5fZEuB+YrS3VL2SMgydXb3uoTp+WZwL7fGVwCBIQN9MJTjDoTsDAsA7BAq5Jem424SVGiz0fGLnXraEyeekAIiRfY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4428.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(26005)(91956017)(36756003)(83380400001)(316002)(66946007)(66446008)(76116006)(186003)(54906003)(2616005)(5660300002)(53546011)(6506007)(71200400001)(966005)(478600001)(6486002)(8936002)(4326008)(8676002)(31686004)(38100700001)(2906002)(66556008)(64756008)(66476007)(86362001)(6512007)(31696002)(6916009)(45980500001)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?anRlRmo2bStJejhSRzAxWTRobTRYWnB1OUt4dkpyVGUzalgwb1FyYmFKTVU1?=
 =?utf-8?B?OG1uMkRUQ0t4Z2gxN0pyYjJRWXEzSlF3ZEpBR0NYZTcyUTc0RlhvYWxLQWE3?=
 =?utf-8?B?N1NmL0lHOFY3MEpZUGJkakxVZ1FtbDR3SjNTcksrb285UW1Da1NFOHdHMUlo?=
 =?utf-8?B?d1hjRVcvWWtsd2VUT21ybVl2N21MeEltMHk1blFDeENJSWFuSWxRQmt5bTFE?=
 =?utf-8?B?Z0lKY3V0VlU0a2NRV043RkVsaEdkWUtJSjJEOG9sbnBaRHN4YXd1a1g5dXpY?=
 =?utf-8?B?TVNsUTFrSjJHc1BkRndxbGQxcjRRUi9ZVURqd0kySUQ4MGlIcTUrRngvOC82?=
 =?utf-8?B?MGF5RWdPSURQR0w0bUYrcTdOcmpSOHhUcFlRUzVaRnRPVzBhV1pDdkRjdFB4?=
 =?utf-8?B?Q1ZsK3RSOEdBRTgrTzk0TXB3aXFSaHF3SlQxVkJhdlE1S042VU9ST3gxei9U?=
 =?utf-8?B?cXlkS25mOCtSSXUxWEROMk5NejNkbFZiYUtGYi9MOUxCS1RPWEo4Zk1wRDN1?=
 =?utf-8?B?UjJZVDIzZ1dRT1ovNUxtVDJqRGttZU1UZFNkRHhjRE9QNVJ5dml6dWlBS2gy?=
 =?utf-8?B?ZDJBT3g2dmd4QmJkZk9CU0JjYzllOWttRUFzbDgvZjJ3dXFLYTJvcExHNGt3?=
 =?utf-8?B?Y044UlpNY0RQbU5iRHpwWkVSMnJmZzhNS25vbXFPSUxWNmkzaUpybDJHSlhv?=
 =?utf-8?B?aFVMRjYwWk5QWjEwVVl1RkgxcjBjZGt2VXl3N292cEZNeWZuU2xHUllnWXdE?=
 =?utf-8?B?RDArVmY0dllydGVDY2ttU2pLaGhiUFdFWVJsbkVVSVd4T2lydEpRUXhET3BQ?=
 =?utf-8?B?ajd4NXN3WUp4d05DelBNc3JYU05LL2U2OFA2M21TSDVqcGowQUx4V2lFSzk3?=
 =?utf-8?B?Ym04QTlLSCtwVmJERkY1Q0ZJQXJoeXhkaTFCRDQ1cWxxVFVRZ1JTRGVYbVVY?=
 =?utf-8?B?OHMzbDZDcHZFYURHUVU0ejhCbkYyVmZTNFFKU0RNUkJiSm5ta2hpM1RPSUNM?=
 =?utf-8?B?MWJXMTlyV3JnNlJjc241WGhyUEpZQXV4Z0RqUnJ1N244U21VN0Zrb255NXVS?=
 =?utf-8?B?SDkrcXplbGpPUnNpN0lpcDBHaW1HU3lueXlYZDMwSlNERnRoNnQxN0JFTlla?=
 =?utf-8?B?N3Focy91ZmsrR3Y2S0pqNVFVNXVWNlFMMGtwaHN6U3l1NUZGenRMMEVaSUpP?=
 =?utf-8?B?VFMrYzg4bFIvd1k4bCtTSmc4bDVtL212NjIwZ1hINzRPQUtFdXp5cGo0ZFZY?=
 =?utf-8?B?WTgrQk9QTEtFcXNCM1N5Ui8vZXVnd3dDQ21LSG1KL0plZWoyL2Z5bjRQZDZq?=
 =?utf-8?B?eENhVWx4ejFSbDlpWllXRDJIaUZvdjZmRytpZE4yM3N5eGd6YzI0T0YxeU11?=
 =?utf-8?B?K0N3SEZ2OEVCZyttQUcxZDg5RkZIYnNIdFVXeWRPN3FyS1h1MWxoYVBuR0FF?=
 =?utf-8?B?V2N1d3dnY1U1cFFNbExKbVltN2tFSERlc0w1d0RaTGJLcG9pSHZobCt3SU5j?=
 =?utf-8?B?eUlhKzBTZE02eVBOS2VtY2k3Zy9ES2ZRWUNISGhRc1l6RFVJRi9LMlZHVTNX?=
 =?utf-8?B?T3pXSUJmWFFYNzVOT1RzWWgzTGo5MUZFblBrc0l1ODFGbTBDTGZ4SHBoMlB4?=
 =?utf-8?B?REpmdklzWlo1bmFzVjh6ZVNJemdYZGc4b2hYc21jbmhmczBZRlJ5RGVCM1ZT?=
 =?utf-8?B?ZWtKTmNjMGdMWXJQcm43RllmbTMxNVFSem5aQ0YvK2ZTY0VMU3lScm5TT1o0?=
 =?utf-8?Q?T/ch1rmOVf2iMnE/74=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4D967B852742D4AA8E9D21BD782528D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4428.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daa74107-a4b8-4693-21e7-08d8f05d71d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 13:45:40.3702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6K/4e28k6w9RDdd1fm3ARQHsyhM8sjxX5TV22iSiExKcXotYLMtdb90rAxQSNZRqP8DWojwhnxpTDgXh+7vWYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1248
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KT24gMy8yNi8yMDIxIDE3OjMyLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6
DQo+IE9uIEZyaSwgTWFyIDI2LCAyMDIxIGF0IDAyOjIzOjU4UE0gKzA0MDAsIEFydHVyIFBldHJv
c3lhbiB3cm90ZToNCj4+IFRoaXMgcGF0Y2ggc2V0IGlzIHBhcnQgb2YgbXVsdGlwbGUgc2VyaWVz
IGFuZCBpcw0KPj4gY29udGludWF0aW9uIG9mIHRoZSAidXNiOiBkd2MyOiBGaXggYW5kIGltcHJv
dmUNCj4+IHBvd2VyIHNhdmluZyBtb2RlcyIgcGF0Y2ggc2V0Lg0KPj4gKFBhdGNoIHNldCBsaW5r
OiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgt
dXNiJm09MTYwMzc5NjIyNDAzOTc1Jnc9Ml9fOyEhQTRGMlI5R19wZyFJY3l1aWxsZnpfSXlfRnJI
ZTJSbVZQMHpGTlRZdXBXUVltbWEyQVg3MUpzcWc0Y3dTYXc0aEtva0RTdklCeHJBZHNSbVVENCQg
KS4NCj4+DQo+PiBUaGUgcGF0Y2hlcyB0aGF0IHdlcmUgaW5jbHVkZWQgaW4gdGhlICJ1c2I6IGR3
YzI6DQo+PiBGaXggYW5kIGltcHJvdmUgcG93ZXIgc2F2aW5nIG1vZGVzIiB3aGljaCB3YXMgc3Vi
bWl0dGVkDQo+PiBlYXJsaWVyIHdhcyB0b28gbGFyZ2UgYW5kIG5lZWRlZCB0byBiZSBzcGxpdCB1
cCBpbnRvDQo+PiBzbWFsbGVyIHBhdGNoIHNldHMuIFNvIHRoaXMgaXMgdGhlIGZpcnN0IHNlcmll
cyBpbiB0aGUNCj4+IHdob2xlIHBvd2VyIHNhdmluZyBtb2RlIGZpeGVzLg0KPj4NCj4+IEVhY2gg
cmVtYWluaW5nIHBhdGNoIHNldCBoYXZlIGRlcGVuZGVuY3kgb24gcHJldmlvdXMgc2V0DQo+PiBh
bmQgd2lsbCBiZSBzdWJtaXR0ZWQgYWZ0ZXIgZWFjaCBvZiB0aGVtIGFyZSBpbnRlZ3JhdGVkLg0K
Pj4NCj4+IFRoZSBzZXJpZXMgaW5jbHVkZXMgdGhlIGZvbGxvd2luZyBwYXRjaCBzZXRzIHdpdGgg
bXVsdGlwbGUgcGF0Y2hlcw0KPj4gYnkgYmVsb3cgb3JkZXIuDQo+PiAgIDEuIHVzYjogZHdjMjog
Rml4IHBvd2VyIHNhdmluZyBnZW5lcmFsIGlzc3Vlcy4NCj4+ICAgMi4gdXNiOiBkd2MyOiBGaXgg
UGFydGlhbCBQb3dlciBkb3duIGlzc3Vlcy4NCj4+ICAgMy4gdXNiOiBkd2MyOiBBZGQgY2xvY2sg
Z2F0aW5nIHN1cHBvcnQuDQo+PiAgIDQuIHVzYjogZHdjMjogRml4IEhpYmVybmF0aW9uIGlzc3Vl
cw0KPiANCj4gWW91IG9ubHkgc2VudCAzIHBhdGNoZXMsIG5vdCA0Lg0KPiANCj4gU28gdGhpcyBt
YWtlcyBubyBzZW5zZSB0byBtZSwgd2hhdCBhbSBJIHN1cHBvc2VkIHRvIGRvPw0KVGhlIDQgaXRl
bXMgdGhhdCBhcmUgbGlzdGVkIGFyZSBwYXRjaCBzZXRzLiBUaGUgZmlyc3QgcGF0Y2ggc2V0IHRo
YXQgSSANCmhhdmUgc2VudCBpcyAidXNiOiBkd2MyOiBGaXggcG93ZXIgc2F2aW5nIGdlbmVyYWwg
aXNzdWVzLiIsIHdoaWNoIA0KaW5jbHVkZXMgdGhlIDMgcGF0Y2hlcyB0aGF0IGhhdmUgYmVlbiBz
ZW50Lg0KDQpJIHdyb3RlIHRoZSBvdGhlciAzIHBhdGNoIHNldCBuYW1lcyBpbiB0aGUgbGlzdCB0
byBpbmRpY2F0ZSB0aGF0IEkgd2lsbCANCnNlbmQgdGhlbSBhZnRlciB0aGlzICJ1c2I6IGR3YzI6
IEZpeCBwb3dlciBzYXZpbmcgZ2VuZXJhbCBpc3N1ZXMuIiBwYXRjaCANCnNldCBpcyBpbnRlZ3Jh
dGVkIHRvIG1haW5saW5lLg0KDQo+IA0KPiBjb25mdXNlZCwNCj4gDQo+IGdyZWcgay1oDQo+IA0K
DQpSZWdhcmRzLA0KQXJ0dXINCg==
