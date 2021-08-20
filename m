Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980973F2444
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 02:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhHTA7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 20:59:54 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:51790 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234160AbhHTA7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 20:59:53 -0400
Received: from mailhost.synopsys.com (us03-mailhost1.synopsys.com [10.4.17.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 730CEC0827;
        Fri, 20 Aug 2021 00:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1629421156; bh=8xc3Z+ERNl9bPFKfybLSTtkuVpYqNqQjA82ahNe8rFc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DMmHFizndRQKO45/vuv1mgibIxl0XmzvbOBp2z5yIPkfsbAMagfNi0ERNSo7EpYWM
         lWSzHZAnN7WCDx3cemFjXsNi1yx+XgmEXt0nUDX0tjBV0tmxF9nEVRpCRNboW/5JqL
         s4sP6XD+HKPmGcnwIu95X4IwV/8uxwmqJW+lgBQrxXX+YnI1My6nLZlSRkr/nyNdLy
         76lQ5ad7ib2ETe+2E7UMMCxOxf/UaUoJ29dTqhlZ5jTRClLeJGJwBXKPDcTHJn0JmP
         aFeG7iO7/2n3so5ePkJst0IljSdjudjqkE5PpWa+YJYxF+OsBDE55wkjfU1mkamSus
         tlGCmGBbhSFLA==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 04F9DA0080;
        Fri, 20 Aug 2021 00:59:15 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 39BCD40131;
        Fri, 20 Aug 2021 00:59:15 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="qex9b6kD";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAfOabSlidQK1tMWToHFaeu6f7bbpu3EvbVyOboe5rT/Nn6o8JtGCVnTSXlX6ehYHdGcQnUsWwD+ui3PVYEXT1k0iv1WCFwfAvBQAjNdH6q5d+d/DDKqZN+5bl6wuWt/t8C7WCFCFQ3UMong1Q10lAZrpjbbR8cmpmvweRdoFIlKiP8A9h/kZEWc1uHd7+FgOY+qt45bYnaKkEi/FPWNZUn1B4hCSaAb3FXYRsDHWZRr8d2WrWm6WUeyM2xF5pKqsvpKYv4oQpl04rvrNK0YfgV6qM2PKkWvB1MFpQa/SUCg0kHUrpaOaUMjOK2zT7d2yHY5gDLvWzf4/m3crS2Gzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xc3Z+ERNl9bPFKfybLSTtkuVpYqNqQjA82ahNe8rFc=;
 b=ReH+lQBjbI+V0OPgPSmjZwoMzpSJKvq2ef1CKJCC9rCfe8BQuw7coWamVZEd4q3YSrVkpwxc9kBOcbAOaDUNao0wMzUsN40xm18wI2Y0nFerts+eNOTgZQpT9zur0aOtPkM3kqkSTnd6UIUGiM7caKZxBPMENrnUNePN6OcbObj13HLPnb4mDXVqNoYa8Kdjx1UIa2YxSyEknnSUzZg3dz4xFrLDeqLSFgfsE8eZKcuub3ca4Rp3ALhlIPmO9G/Xp40UHDQz7AYnLbRj8OWv8clA7btMj6zLKd4S8ZRUE6lfbl0DiRD9oYUElDkNoGZRT4prHq8xNZQe701nevZWfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xc3Z+ERNl9bPFKfybLSTtkuVpYqNqQjA82ahNe8rFc=;
 b=qex9b6kDZU1v+tiMJXlecCUn4RO2jVNB+/d0D0r2WKIKtlHo6/on/ZkSL795xV3LPzv1GeBaPyKjONcg2DXISWEZORkll9SSKR/QwigoPSr8h5KZeYUeZRV/FlgSTbRKVdlyUkXVcoLziYiOTAkYk9JlNMUyCsAw1hiK/zr8bhM=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB5015.namprd12.prod.outlook.com (2603:10b6:a03:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 00:59:13 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::163:f142:621e:3db9]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::163:f142:621e:3db9%7]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 00:59:13 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix dwc3_calc_trbs_left()
Thread-Topic: [PATCH] usb: dwc3: gadget: Fix dwc3_calc_trbs_left()
Thread-Index: AQHXlJftwHwVywn750+A9r1jkMAixKt6TgiAgAFF9QA=
Date:   Fri, 20 Aug 2021 00:59:12 +0000
Message-ID: <bba2b747-dc16-5ad8-b80b-c8fb6b11a3d3@synopsys.com>
References: <e91e975affb0d0d02770686afc3a5b9eb84409f6.1629335416.git.Thinh.Nguyen@synopsys.com>
 <87h7fmf14r.fsf@kernel.org>
In-Reply-To: <87h7fmf14r.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f693074-4861-4fe1-5be8-08d96375b9ee
x-ms-traffictypediagnostic: BY5PR12MB5015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB5015968FD212FFE07A08262AAAC19@BY5PR12MB5015.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RkHMhae4zKO8ICUYm9Cj2VhWkOF5bB1ue0D0b7+b+3mQAqRndCwO0+uDohfkFk7FX2HGLPymtNzVJ8k0FwUwyYcXt83RDVJfJpuaH627CUXkw5dThBhGbJi26IPfKjdfHWw4uWCvHA97hHgX8XpUEYXRpldnrstDw+mdBCwI/p5crxWHObixb4klCSI9PixQI3rrgEzVMymObwWN1EnfpQNaxS7kGPS1Ncx6YM9jzOanxFuQZgD3S4zkhJeOt+HptlMSTeY1z0IvckKHvBTikt8ZRkf1cuTDgqUUNt/1JoGFO41+hwIQYMoubkBk7zLP6yNYfsbV4UFFYsM5O37akEuQ+k8Wg9X3p+1ulCJo3pDJiCZWXwurLNQRqBqxIj9NSJZ97+M8DoCea82cFH+Z7AkRt20LkqPRTNMY1Od3CtjhA1vfVItiDb9A1tpqWRsZZ8n5TKr05vvBkPDr49kqtI3TMj+syvHnuHWr8BOIg+G8Huw0FjRR+wJcIb2jSA4kYXKBnG9yWlP+Mp7cWIa0TdktNS9+lwHUzosnElmLYQsJaeUn2bhTbbDPhH809BeqLf9t4HSavB+cl35Iz1oNRglw/p2paAH4xRpQPTVfT/Gcl3kqrqflyTm6aNVJB+Cv94mhk2asGiWlufDSZQHgDXN0bPAX9BHrZ4s12Fo90NwXlDlOgcT6v6ZjVvoKpNpDnAfVun9I6tBIRmQHTA/OAnoWLqglBrQm2w/tkpsFkzoPaDLSCRySsdoLiXbjUgL4aZN2Ldag6K2TRdqpLEib7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(64756008)(66476007)(66446008)(31696002)(86362001)(66946007)(31686004)(83380400001)(2906002)(76116006)(122000001)(36756003)(5660300002)(8676002)(4326008)(71200400001)(6486002)(26005)(38100700002)(2616005)(38070700005)(186003)(478600001)(66556008)(110136005)(6512007)(6506007)(316002)(54906003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFVZdlRMeGVabHlDVFVXOC80VzRxeHBqMW9DTzlJMzd3ZTJzS2VvTVIzbkwy?=
 =?utf-8?B?UGxCT2lWS05vZllTL3lMSFA5NS92aHpmN2xhcjVIOTRFdEdnRVZCMGlreHBs?=
 =?utf-8?B?SlE3dkgzRDk0Q0kvTHRWSitDQ0NDVHJITndTK040Zm56bmxFUHVlYlphSUha?=
 =?utf-8?B?alVaQzZLKysrb1BidTZYVjUrZnJkbnY2SVNIMTFLVms0Y1JUNDdPWVBYZTBN?=
 =?utf-8?B?UXhac25WUmYvQzBIRVFUd0U3RTNGT3BSakNwSFY4dW5iUHFTTzFPc0lRZkk4?=
 =?utf-8?B?T3YxZERKb0ZaS2taQzF2RC82Z2lGOWs0MFNoWGNWSHI1ZHFLRG9XK3B6Sjk1?=
 =?utf-8?B?UG1iL2IxRi9hai9CNlgyOHNmU2k3bmtYY0dnT2xQZUpDbW16UlFaaStpdStN?=
 =?utf-8?B?Z2VIWDdtbkJHcEVQUi9MNGIzV1RwRnZITHB0cElXOUJ1cHh0Q0Q5OVRCLzha?=
 =?utf-8?B?cnZyWFpHak0zdUpIenAvWk9Zc1R6YW9DbHMxUTBnaXllS2VJMlNJa3JpSloz?=
 =?utf-8?B?Zmc0TFRYZGlRQ0czTGxqT0R6cTlFblczdHUzNmU3TWRtUmZUSk5QYldBa2Np?=
 =?utf-8?B?L3NxSmtHdzd2aVFqaEpvVW5pK2FiQXE4UjhTUHhHTjB2NXNaRGtIYlNoSmdt?=
 =?utf-8?B?RVdqMm5McHNmb255NWxtN0hBTHFEc3ZDRDcwZkxTeTB1L0VpcEsrazEzM2NW?=
 =?utf-8?B?R0NLWVZ5SFJlYjBxWndyTXE1clpNTDNneEQrOUZxMUVjK1I2aDEwZlpiNXcx?=
 =?utf-8?B?ZWxyeHRwalV6UFJYaHJJbWJkOU5SWTNRU01KZCtGbkNXU3FLN3Eyc1c5S09v?=
 =?utf-8?B?S2hNckpZUUlPbVJQYXJwK25VUlljTm8zbUhLM0dpMmEvVWQrRUhqeUVycnYw?=
 =?utf-8?B?b1AvcEZURUE1U3BEL2w5a3pNSmdQdDFPNEdLYlVoWjYyMUpnWlR1N3Nndkkz?=
 =?utf-8?B?OURzVUI3NTgxbjloc0dxSjVVV1poNHNVdmcyUnVVdi9UdnI0RlFLZEZ2RWk1?=
 =?utf-8?B?aHZLcXZGV0VreUxycFI3ajVXbElrcWdXaUpVeTRlVWxOQjA2M1pMQ1Y2ZkpN?=
 =?utf-8?B?MVEzTEg0cjBwUEplRER0ZDFmeTVLY01SaGE1YVk3a0hueGRraEYydTFwemNs?=
 =?utf-8?B?bnRSZTNxRWlVVTZaenhuWks4OWlrTkJvWkkzbitOelowZDV6Q2hZaStSeDll?=
 =?utf-8?B?U3ZrNUVWYW92cURTMDhzTEwwYlpNRkhNNXZlUmNUbzNEdERGWGxMTGZQNUwr?=
 =?utf-8?B?L2tMSmNIOE5XQ0pFbW10c1M2S1dqck1vVEZJRzNMbUNYNzFIcE0vR3lGV0F5?=
 =?utf-8?B?enA5ZENZMVhEVFJYcnBaOFB2RExmdUk1dnFMbXNDNVA4elBBYVhlWkdjamUy?=
 =?utf-8?B?V3BldjBaU1Vtc0pPMzZZam5VSnJBa25EazlIM0ZtVkV3YUhZZjN4UThRYWhH?=
 =?utf-8?B?dG1DTlhZRy9ZNzJ4SzcyTlhRZm41UVAvRWxIdkFKeC9iaXhxOFVWZHdRQlZD?=
 =?utf-8?B?NWZKb3N3cnYxaWVYUG5WWXNSWklIN3IrdFp5NW9mZ2FNWERYUm0xdlUvSEo2?=
 =?utf-8?B?SE5LMzJIYXF1U1RWeTRtb1NkcWN3NStIUjFzanVzZzhsRjVreXFWNTdmSW1a?=
 =?utf-8?B?akRkS29jR09xdTBvWDBkbWROSllTZW9samFHeVpnbGViZnJtajhtY3VXejgr?=
 =?utf-8?B?RmhTTXRaTGM1NjdYeWVDTVNjdnNDNHk0cDRBNlB6ZWVpbkFxdnlrQjBSVTVJ?=
 =?utf-8?Q?XTRFEs4K/Oal8RjTh0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BC6CCC8EB94EE45805BF0CAB3406F18@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f693074-4861-4fe1-5be8-08d96375b9ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 00:59:12.9696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wAA0ECeSGIVCRYw18E2wqKiVtGvJac1dKixVQWgmE8TqdbMdNEwgsqKmF4xlQDPasgNJb5IsNzV7RB7SfhsFAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5015
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RmVsaXBlIEJhbGJpIHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiBUaGluaCBOZ3V5ZW4gPFRoaW5o
Lk5ndXllbkBzeW5vcHN5cy5jb20+IHdyaXRlczoNCj4+IFdlIGNhbid0IGRlcGVuZCBvbiB0aGUg
VFJCJ3MgSFdPIGJpdCB0byBkZXRlcm1pbmUgaWYgdGhlIFRSQiByaW5nIGlzDQo+PiAiZnVsbCIu
IEEgVFJCIGlzIG9ubHkgYXZhaWxhYmxlIHdoZW4gdGhlIGRyaXZlciBoYWQgcHJvY2Vzc2VkIGl0
LCBub3QNCj4+IHdoZW4gdGhlIGNvbnRyb2xsZXIgY29uc3VtZWQgYW5kIHJlbGlucXVpc2hlZCB0
aGUgVFJCJ3Mgb3duZXJzaGlwIHRvIHRoZQ0KPj4gZHJpdmVyLiBPdGhlcndpc2UsIHRoZSBkcml2
ZXIgbWF5IG92ZXJ3cml0ZSB1bnByb2Nlc3NlZCBUUkJzLiBUaGlzIGNhbg0KPj4gaGFwcGVuIHdo
ZW4gbWFueSB0cmFuc2ZlciBldmVudHMgYWNjdW11bGF0ZSBhbmQgdGhlIHN5c3RlbSBpcyBzbG93
IHRvDQo+PiBwcm9jZXNzIHRoZW0gYW5kL29yIHdoZW4gdGhlcmUgYXJlIHRvbyBtYW55IHNtYWxs
IHJlcXVlc3RzLg0KPj4NCj4+IElmIGEgcmVxdWVzdCBpcyBpbiB0aGUgc3RhcnRlZF9saXN0LCB0
aGF0IG1lYW5zIHRoZXJlIGlzIG9uZSBvciBtb3JlDQo+PiB1bnByb2Nlc3NlZCBUUkJzIHJlbWFp
bmVkLiBDaGVjayB0aGlzIGluc3RlYWQgb2YgdGhlIFRSQidzIEhXTyBiaXQNCj4+IHdoZXRoZXIg
dGhlIFRSQiByaW5nIGlzIGZ1bGwuDQo+Pg0KPj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3Jn
Pg0KPj4gRml4ZXM6IGM0MjMzNTczZjZlZSAoInVzYjogZHdjMzogZ2FkZ2V0OiBwcmVwYXJlIFRS
QnMgb24gdXBkYXRlIHRyYW5zZmVycyB0b28iKQ0KPj4gU2lnbmVkLW9mZi1ieTogVGhpbmggTmd1
eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy91c2Iv
ZHdjMy9nYWRnZXQuYyB8IDE2ICsrKysrKysrLS0tLS0tLS0NCj4+ICAxIGZpbGUgY2hhbmdlZCwg
OCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPj4gaW5k
ZXggODRmZTU3ZWY1YTQ5Li4xZTZkZGJjOTg2YmEgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3Vz
Yi9kd2MzL2dhZGdldC5jDQo+PiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+PiBA
QCAtOTQwLDE5ICs5NDAsMTkgQEAgc3RhdGljIHN0cnVjdCBkd2MzX3RyYiAqZHdjM19lcF9wcmV2
X3RyYihzdHJ1Y3QgZHdjM19lcCAqZGVwLCB1OCBpbmRleCkNCj4+ICANCj4+ICBzdGF0aWMgdTMy
IGR3YzNfY2FsY190cmJzX2xlZnQoc3RydWN0IGR3YzNfZXAgKmRlcCkNCj4+ICB7DQo+PiAtCXN0
cnVjdCBkd2MzX3RyYgkJKnRtcDsNCj4+ICAJdTgJCQl0cmJzX2xlZnQ7DQo+PiAgDQo+PiAgCS8q
DQo+PiAtCSAqIElmIGVucXVldWUgJiBkZXF1ZXVlIGFyZSBlcXVhbCB0aGFuIGl0IGlzIGVpdGhl
ciBmdWxsIG9yIGVtcHR5Lg0KPj4gLQkgKg0KPj4gLQkgKiBPbmUgd2F5IHRvIGtub3cgZm9yIHN1
cmUgaXMgaWYgdGhlIFRSQiByaWdodCBiZWZvcmUgdXMgaGFzIEhXTyBiaXQNCj4+IC0JICogc2V0
IG9yIG5vdC4gSWYgaXQgaGFzLCB0aGVuIHdlJ3JlIGRlZmluaXRlbHkgZnVsbCBhbmQgY2FuJ3Qg
Zml0IGFueQ0KPj4gLQkgKiBtb3JlIHRyYW5zZmVycyBpbiBvdXIgcmluZy4NCj4+ICsJICogSWYg
dGhlIGVucXVldWUgJiBkZXF1ZXVlIGFyZSBlcXVhbCB0aGVuIHRoZSBUUkIgcmluZyBpcyBlaXRo
ZXIgZnVsbA0KPj4gKwkgKiBvciBlbXB0eS4gSXQncyBjb25zaWRlcmVkIGZ1bGwgd2hlbiB0aGVy
ZSBhcmUgRFdDM19UUkJfTlVNLTEgb2YgVFJCcw0KPj4gKwkgKiBwZW5kaW5nIHRvIGJlIHByb2Nl
c3NlZCBieSB0aGUgZHJpdmVyLg0KPj4gIAkgKi8NCj4+ICAJaWYgKGRlcC0+dHJiX2VucXVldWUg
PT0gZGVwLT50cmJfZGVxdWV1ZSkgew0KPj4gLQkJdG1wID0gZHdjM19lcF9wcmV2X3RyYihkZXAs
IGRlcC0+dHJiX2VucXVldWUpOw0KPj4gLQkJaWYgKHRtcC0+Y3RybCAmIERXQzNfVFJCX0NUUkxf
SFdPKQ0KPj4gKwkJLyoNCj4+ICsJCSAqIElmIHRoZXJlIGlzIGFueSByZXF1ZXN0IHJlbWFpbmVk
IGluIHRoZSBzdGFydGVkX2xpc3QgYXQNCj4+ICsJCSAqIHRoaXMgcG9pbnQsIHRoYXQgbWVhbnMg
dGhlcmUgaXMgbm8gVFJCIGF2YWlsYWJsZS4NCj4+ICsJCSAqLw0KPj4gKwkJaWYgKCFsaXN0X2Vt
cHR5KCZkZXAtPnN0YXJ0ZWRfbGlzdCkpDQo+PiAgCQkJcmV0dXJuIDA7DQo+IA0KPiB3ZSBjb3Vs
ZCBhbHNvIGRvIGF3YXkgd2l0aCBjYWxjX3RyYnNfbGVmdCgpIGNvbXBsZXRlbHkgaWYgd2UganVz
dCBhZGQgYW4NCj4gYWN0dWFsIGNvdW50ZXIgdGhhdCBnZXRzIGluY3JlbWVudGVkIGRlY3JlbWVu
dGVkIHRvZ2V0aGVyIHdpdGggdGhlDQo+IGVucXVldWUvZGVxdWV1ZSBwb2ludGVycy4gU2luY2Ug
d2UgaGF2ZSAyNTYgVFJCcyBwZXIgZW5kcG9pbnQgYW5kIG9ubHkNCj4gMjU1IGFyZSB1c2FibGUs
IHRoaXMgbWVhbnMgd2UgY2FuIGRvIGF3YXkgd2l0aCBhIHNpbmdsZSB1OCBwZXINCj4gZW5kcG9p
bnQuIFBlcmhhcHMgdGhhdCBjb3VsZCBiZSBkb25lIGFzIGEgc2Vjb25kIHN0ZXAgYWZ0ZXIgdGhp
cyBmaXggaXMNCj4gbWVyZ2VkPw0KPiANCg0KWWVzLCB0aGF0IHdvdWxkIHNpbXBsaWZ5IHRoZSBs
b2dpYy4gV2UgY2FuIGRvIHRoYXQgYWZ0ZXIgbWVyZ2luZyB0aGlzIGZpeC4NCg0KVGhhbmtzLA0K
VGhpbmgNCg0K
