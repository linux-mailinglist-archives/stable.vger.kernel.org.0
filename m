Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1B83602FD
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 09:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhDOHLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 03:11:04 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:57098 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230118AbhDOHLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 03:11:03 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6CB60C0635;
        Thu, 15 Apr 2021 07:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618470640; bh=v2b5+4UZGviI/iSXZ2xqspnDLDN8UreJGCJSqLMobAw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=JMouj+19ifGOe1xYjouNfZ3KB1fv+sWQzT5xNp+7CqHQz4UMK+lp8r+dCpJx10i+y
         SkDYDnoAywdZoV3X+zW+6lCHiedRAoNOpOwnB6dWCGA99k4/L9B8yQwHyH52MF52kh
         iaWCrMkwDBR0/Mq4CQnCoR7U95Q8bQIK54ToOh5F8m5Po44IM+lsWZRq+apYuAW9H+
         Xtb9Xn8Efbbo/fqzrp2dvWKzvUtCgE/LfAJpxIOQM40gHwl2jGCUaim/FR5vVCW8kj
         EkomPH5ob+rfgRrG8Mke6ACpBEMzWuMS6PU7xTsZIcaA5uSfYUbVCYP2T0DR1O4KD/
         4IlIZzqB8uTlg==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7D581A00A8;
        Thu, 15 Apr 2021 07:10:39 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2057.outbound.protection.outlook.com [104.47.36.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 0D99E80091;
        Thu, 15 Apr 2021 07:10:37 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="gqKmy8ND";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9K8xkPHXrfrR+YKr25Boa58lWg8myYMSJ4FpsMJkzjw+OmTc896WWLC3+kTbOVdkRSLXYL4y/SYwayClI5DAv1XylRjpOQNEzl/OmgcqJStsGt/FJwo5PoOAHsGfPawA32Q4nyA8ea+SmzYaOrrvNtawZny/VkXxPsix4NefGFtHCFYK/62Jo0+yELGrM0fPOCm77h9oMZH8keAiXr91l+R+HmbqW+ocHwo2qqhAsaY0ih/9NRnQpGoIFyuPzb39V2c9znGV05OctSJqM3SMaA5kimbnKEu2YEqkm/06bs6T2pNc6MAQloLA0COm8gFxXek2xpj/UfCt2E8ssektA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2b5+4UZGviI/iSXZ2xqspnDLDN8UreJGCJSqLMobAw=;
 b=mLZS7WgD5LLU0NHxAOFxztE+0Xufn4Mn5Aedj/506V53Q311zqznymFSiw/brRdpwRia6mDlH9Usw8kJAM4cLyENoT4KGaqFDdO1hzFK2e4L0Vf8ZBqBd+PKXIcNH7wGtvzZpG6r0im28wpbMmHEvwmrcgQOyRpoPVxPgE8TtLLYYvUejXqPABiYDo5XJGJNfKXuq+MTIWn3QN6SqLEmhajj67v5hVbvOM6y2s2rPaMV8LRWCyRS86OehNIQ6SGs00iGEl3NR8BSM5f+ecrCvJYzTWetD+HHGdiBOlzDKjyriyh3AJa6BRxrgOZRTaqqpADgi7Zf+JCm35RjXAjJxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2b5+4UZGviI/iSXZ2xqspnDLDN8UreJGCJSqLMobAw=;
 b=gqKmy8NDmVX86bJ30yyFU+MCxrl0xaWeoZnmt5mEVIGyG+FXOmNn1XSRffRg5uV8HH0iLUOMVQM7uvqYVKzUrreozCWsuIM4EreBVkaRhwySq92YLswx9psT8CGuBfRqu6ZTii1LNkBKS88Osru013qvf26NqhqODZBUlt5UPVM=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 07:10:35 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.016; Thu, 15 Apr 2021
 07:10:35 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMZ5ZpPhhG1Y+NESFNK78+41CJ6q1HFYAgAANRoA=
Date:   Thu, 15 Apr 2021 07:10:34 +0000
Message-ID: <c125a30b-edde-8fe5-3370-d9e62a24f7e9@synopsys.com>
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
 <87sg3snk1l.fsf@kernel.org>
In-Reply-To: <87sg3snk1l.fsf@kernel.org>
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
x-ms-office365-filtering-correlation-id: dd672a49-0682-4995-92cb-08d8ffdd90ba
x-ms-traffictypediagnostic: BYAPR12MB4791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB4791293969DE4BC630C7D6F8AA4D9@BYAPR12MB4791.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0nkfwzTTKsIHXfZHcRIhI1yC1cd8x6fV20PmoI9YMJ1cYwH2vPpvuqOdticK+1EX4R4g1SdbcNK4e54pLl6ZjXuE+8thFuEEweSevRA9vwWp3EyTjXorXyd8chMYWScAi72/kbERDf7FS9M8TAYVsDp4PMZaSeHFwZl7VzMlgq9qSmY44WOcMQHH6UKt2izb/g+HgJyJfT0BGU8Xo6nHiYMkh8jJ3/89v/5K9f3x2AEJUtv7uRoHyLAYUUt0e261r9oROcjEPrRq0wX2C4cTopVARnS3/rhM7f2nROHRWeSFXON4MmHuyJpWUpiodhUzaHboda/Ab7FuWOA9oTok3J+wWIPeyEU2qh0CRSalRfaF4P8hWHuzVJuBb8FFVbTTJxe2Wu0Fg2D1NSkZixfoVadVwAEYwqZenmxhtHNL8qawrTvjGKA672/JA7s+mo3qdB3GC4ahsgqHtiD8bUvTCFgVo32VyD4Ts8RYSfkVLV9IhlTKoALbcGZAgTz3vjiYoVfNcuB7MLKUwvssNzidNVTLpY/ZNINqJ2AA5nA+kKq8Rbzf80Y5QFGQO2tQE8l18H8PEfcC3Ol2I6pdEYPSodpWLa2nyh3aqHkviB1O7YikNkpaL+S/9g2s/rVOrVRfRgyewSki5/O0b536+Wmonl6JjFcggcyHhoD9rOTUSivmlbQtumEqqjUcreUG/X8s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39860400002)(136003)(7416002)(478600001)(31686004)(6506007)(186003)(71200400001)(8936002)(8676002)(4326008)(83380400001)(86362001)(36756003)(66946007)(66446008)(66556008)(54906003)(2616005)(316002)(38100700002)(110136005)(5660300002)(31696002)(64756008)(66476007)(6486002)(2906002)(122000001)(6512007)(26005)(76116006)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L0xqZ3lJWm12aml2VlBqdE02RmgxdENHL1F1K2FSNk1XWjJOQXBqU0ZqQWVr?=
 =?utf-8?B?L2ZZU1BSRnhXQnUzQkUwbU1Md01mZlR3UUIwa2JaUUpONEoxSnY3ZXNxcmJa?=
 =?utf-8?B?b2Q2ek9vbWF3S3crc0pZZlBXZERuaUczSUsxV1F3RVFJT0RZZnNINUVQUGY4?=
 =?utf-8?B?SVRKRVl6YXJ1ZnRhOUNVK3d1RUM3bTdlMkkyTTlJMEsyazBNUUZKb2Zqd1E4?=
 =?utf-8?B?Q2tHc205S0NxWHQ5UUU1R3QyQ3ZwT01lQ1JPNldsMWt3dGRwc1lHRDNwbXJV?=
 =?utf-8?B?VFhYdzVzZnBJelZSTjFpM3h1TUNoRnB2UVpkQlBnblRQUVlyM3FYS2tZa3dS?=
 =?utf-8?B?SUpnb2M3ZS9Ka0cyYkhObXM1ZTRRaG5HVnhuR29sQTRIUEd6WGxubmpIdEU2?=
 =?utf-8?B?YjZkcEszczBjQmxmS2dCVWxEM1JqN3k2WFdwbDFDNjRNWUlZS2NDZk5zZVRt?=
 =?utf-8?B?UktjTnc0aW13THViNnpHVlpzaTJFVWpabFhYcTZDdUZXRzVzUFZhaGx1bnNh?=
 =?utf-8?B?R3lFMENaMXJRM1dvcEtudXRHNThObkV6TWxxdERnNDBGSCtvSFlKRC9VV3Mx?=
 =?utf-8?B?Tnhzd1kwSnJJeGNzVDdzVXdEa0Y3WSs4NWp4VDhMajVTVytFZWpUY3lIOXdP?=
 =?utf-8?B?N2o4Mlo2VHZtekduVmVhNGVyd3ptaXZrSnZ6K21GK3J5RC9KVzNjaC85YzB3?=
 =?utf-8?B?RGY4dGt6MkszdWdhYVpsVHRWZXprSSs0eWl5YnJUZGNXMkE4Ym1vVHd5eWQw?=
 =?utf-8?B?MWVGVTBhcnhoMjBCQkNya3NBSHJmWDVsY3BZd0VxbHAzN2ZCc25xeFBsTitQ?=
 =?utf-8?B?YUhWN0dDdU5KdWUyOFRXSGtHVGx4cmZ6V1JhYyt5dVJhMUxmWVFLNVZIZjMr?=
 =?utf-8?B?OVltQWRTZGJSZEU3MWxrQnVsSjJBWVpRZWJvVEZFalVXbEpibjN3REx2OGZq?=
 =?utf-8?B?NGlwd0pRb1N0OUZ6MjUxeFhTOEUzVUlQUkxtQWpTQkNscmFDbDZsUnN1bVdC?=
 =?utf-8?B?VGJCQXAreDdtMHVkYy91ZDN1TERhbXl3djNCTGhpZTFvN3lsamt1bkppWlM2?=
 =?utf-8?B?RHBoQnR1WVVTRWNickt0SlliZVpxUElxd253WHBHb1dNWGtaUDhJT2t2NDFx?=
 =?utf-8?B?K3kvd1ZGMmxydGtlL0hHRmRFd25wRDVtOFZWVnFSRjBoK2hobmZuTmkvRnpo?=
 =?utf-8?B?b1RjRkRCOEJvZVhGZnNXOGJ1NHhWVGM1NW5GSUpVMzMxNzZDL1Q5RHdxZ0tz?=
 =?utf-8?B?SVE1ZC9ndFUzdHRsK3JSb1MxTXU2YSt6YTNNY1ZTbWF0cUNGSVh2K2EyMXFp?=
 =?utf-8?B?L1hqY043VFdHS1RWdGlBRGFRRmh6UnBpV01jRU1vQmVQSVg0Yi9TNDAvaUN3?=
 =?utf-8?B?T1QwNnJBa1NKQ2xDREU5MmFHWUFMQU4vQjdCTTIxMlQ3ZXczZngxdEZubUR4?=
 =?utf-8?B?cFBLZVorOTZPTU1jS1UyUnZON3VHODFhMFdaQUdiWXFQTEpLdVl3MGNPWGF0?=
 =?utf-8?B?eGtESzkySGhUN2IxOTlKWS9OUnFoN2NaVUN5WENCT3g3aWdCYjBpN0ZMMnZY?=
 =?utf-8?B?OC83Ni9SQnJNSjRpR3lsTkFpdWMrS0d2dTdMemttanpkdUhxbDlBRlB0bzYr?=
 =?utf-8?B?bVVnNWpnWEdLVXVhRyswWEw2R2RNN01wRUFlZkwxRlNlcU93L3ZwN3BLNHMz?=
 =?utf-8?B?amNKK3V2b1Q3clY5T3psdkIzdDJxZXd1MFREakQzTitrbkRRaU83cE1KTU5t?=
 =?utf-8?Q?EpSRXg6mBRe6/MbwYGiLYV0JzRK5MtCIVHBqtZK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EFCA7E70D91464B9442D857E7E94378@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd672a49-0682-4995-92cb-08d8ffdd90ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 07:10:35.1628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +u+wihm2mu6fWc8iHGK5YZ/X6eHdW+YlY0r+l1An8tVzLdWlXD3dmUpXZ+WgQZw83l9cVxR7lmG6Ich02tEIYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4791
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RmVsaXBlIEJhbGJpIHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiBUaGluaCBOZ3V5ZW4gPFRoaW5o
Lk5ndXllbkBzeW5vcHN5cy5jb20+IHdyaXRlczoNCj4+IEZyb206IFl1IENoZW4gPGNoZW55dTU2
QGh1YXdlaS5jb20+DQo+PiBGcm9tOiBKb2huIFN0dWx0eiA8am9obi5zdHVsdHpAbGluYXJvLm9y
Zz4NCj4+DQo+PiBBY2NvcmRpbmcgdG8gdGhlIHByb2dyYW1taW5nIGd1aWRlLCB0byBzd2l0Y2gg
bW9kZSBmb3IgRFJEIGNvbnRyb2xsZXIsDQo+PiB0aGUgZHJpdmVyIG5lZWRzIHRvIGRvIHRoZSBm
b2xsb3dpbmcuDQo+Pg0KPj4gVG8gc3dpdGNoIGZyb20gZGV2aWNlIHRvIGhvc3Q6DQo+PiAxLiBS
ZXNldCBjb250cm9sbGVyIHdpdGggR0NUTC5Db3JlU29mdFJlc2V0DQo+PiAyLiBTZXQgR0NUTC5Q
cnRDYXBEaXIoaG9zdCBtb2RlKQ0KPj4gMy4gUmVzZXQgdGhlIGhvc3Qgd2l0aCBVU0JDTUQuSENS
RVNFVA0KPj4gNC4gVGhlbiBmb2xsb3cgdXAgd2l0aCB0aGUgaW5pdGlhbGl6aW5nIGhvc3QgcmVn
aXN0ZXJzIHNlcXVlbmNlDQo+Pg0KPj4gVG8gc3dpdGNoIGZyb20gaG9zdCB0byBkZXZpY2U6DQo+
PiAxLiBSZXNldCBjb250cm9sbGVyIHdpdGggR0NUTC5Db3JlU29mdFJlc2V0DQo+PiAyLiBTZXQg
R0NUTC5QcnRDYXBEaXIoZGV2aWNlIG1vZGUpDQo+PiAzLiBSZXNldCB0aGUgZGV2aWNlIHdpdGgg
RENUTC5DU2Z0UnN0DQo+PiA0LiBUaGVuIGZvbGxvdyB1cCB3aXRoIHRoZSBpbml0aWFsaXppbmcg
cmVnaXN0ZXJzIHNlcXVlbmNlDQo+Pg0KPj4gQ3VycmVudGx5IHdlJ3JlIG1pc3Npbmcgc3RlcCAx
KSB0byBkbyBHQ1RMLkNvcmVTb2Z0UmVzZXQgYW5kIHN0ZXAgMykgb2YNCj4gDQo+IHdlJ3JlIG5v
dCByZWFsbHkgbWlzc2luZywgaXQgd2FzIGEgZGVsaWJlcmF0ZSBjaG9pY2UgOi0pIFRoZSBvbmx5
IHJlYXNvbg0KPiB3aHkgd2UgbmVlZCB0aGUgc29mdCByZXNldCBpcyBiZWNhdXNlIGhvc3QgYW5k
IGdhZGdldCByZWdpc3RlcnMgbWFwIHRvDQo+IHRoZSBzYW1lIHBoeXNpY2FsIHNwYWNlIHdpdGhp
biBkd2MzIGNvcmUuIElmIHdlIGNhY2hlIGFuZCByZXN0b3JlIHRoZQ0KPiBhZmZlY3RlZCByZWdp
c3RlcnMsIHdlJ3JlIGdvb2QgOy0pDQoNCkl0J3MgcGFydCBvZiB0aGUgcHJvZ3JhbW1pbmcgbW9k
ZWwuIEkndmUgYWxyZWFkeSBkaXNjdXNzZWQgd2l0aCBpbnRlcm5hbA0KUlRMIGRlc2lnbmVycy4g
VGhpcyBpcyBuZWVkZWQsIGFuZCBJJ3ZlIHByb3ZpZGVkIHRoZSBkaXNjdXNzaW9uIHdlIGhhZA0K
cHJpb3IgYWxzby4gV2UgaGF2ZSBzZXZlcmFsIGRpZmZlcmVudCBkZXZpY2VzIGluIHRoZSB3aWxk
IHRoYXQgbmVlZA0KdGhpcy4gV2hhdCBpcyB0aGUgY29uY2Vybj8NCg0KPiANCj4gSU1ITywgdGhh
dCdzIGEgYmV0dGVyIGNvbXByb21pc2UgdGhhbiBkb2luZyBhIGZ1bGwgc29mdCByZXNldC4NCj4g
DQo+PiBAQCAtNDAsNiArNDEsOCBAQA0KPj4gIA0KPj4gICNkZWZpbmUgRFdDM19ERUZBVUxUX0FV
VE9TVVNQRU5EX0RFTEFZCTUwMDAgLyogbXMgKi8NCj4+ICANCj4+ICtzdGF0aWMgREVGSU5FX01V
VEVYKG1vZGVfc3dpdGNoX2xvY2spOw0KPiANCj4gdGhlcmUgYXJlIHNldmVyYWwgcGxhdGZvcm1z
IHdoaWNoIG1vcmUgdGhhbiBvbmUgRFdDMyBpbnN0YW5jZS4gU3VyZSB0aGlzDQo+IHdvbid0IGJy
ZWFrIG9uIHN1Y2ggc3lzdGVtcz8NCj4gDQoNCkhvdz8gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8g
UGxlYXNlIGxldCBtZSBrbm93IHNvIEkgY2FuIG1ha2UgdGhlIGNoYW5nZS4NCg0KVGhhbmtzLA0K
VGhpbmgNCg==
