Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC942F588B
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 04:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbhANCkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 21:40:24 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:41698 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbhANCkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 21:40:22 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3DFD8401AB;
        Thu, 14 Jan 2021 02:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610591962; bh=d4KcJxDKwKXBM/TzhYvxQrgoNNimEP3hPWf278FntQw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Kf/lw8D/eEqVZLb19EwWyCPloLo5dnxAIasCR1zQs0RO3BW4AD9nzOSsjN2A3rruY
         Ak/F0e8g2tNog0NY8OMNMLtYH31jyHhBunfHzV1hoQM7bPB5Pmp2tbpl68JFENavCZ
         vUrQtsWhLon0wAsK79yUMXJGp+1n1Dd3TfuTA3lKBxJTS5QEaBdNs+OYPijfK7O8pa
         oRe7wJunYhvhw0Q6ZhLRKgb8tpZJXVEsc4e4xuFXRGSLEaTPwlxKhL1NppHWzjsTm5
         NfJWEehYxt5ZuFcpA1op3M/TtD2hdtm+5M9XX6cCFDd6XS8n42iiHiiI7blvTqwV/7
         rUezs8UVQ3EsQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D7DCAA0071;
        Thu, 14 Jan 2021 02:39:17 +0000 (UTC)
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2058.outbound.protection.outlook.com [104.47.37.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id D3D3D400FC;
        Thu, 14 Jan 2021 02:39:15 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Ln7VfEma";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACgyLVuaxbrHfo0+cun9DHbw3bYfNpwb6JHi8IIquDCW0jNpuV6yZlIxob1EDUDi3mc8cxeAbrORU+iou4QebI7P21I/RvudqreW4KKCs8BsTMZxrvC7iogM5WsPFEebGEHTtakcGuCQOaR28BauhYDwtqn7ZOATtttt+oYk7TkWtQkK5sBb1aFzPY/SL+Ho2fqqaqtsmPM0DpFxst5br+sRVLHOct8Ex2ylF3zWp4E466PS0HV+EhOi/kmdEW8KKIEPmNkjy/JSrUJD5JzkMR0EVjPwLgq45ciYyhr13JAZ93e8RxLoq0eiqn/oLgG/ODuHj122VnutXkVdJg7hgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4KcJxDKwKXBM/TzhYvxQrgoNNimEP3hPWf278FntQw=;
 b=Gx145TqUKJG2pf0tLAoBWv6WnWx6xNRXUOfirfJ2T0BBH1VyanslH6JsB15AWwPTzMPhs5yjITsHV186GWOOuoWE/QohEnVPmDvy6V9/rl0rWWNpEF4sjUTt6kTSuFzx3gP+CNM65IrmnGNt3SW4zzxex9j2RR+U1VO2wsR0yHQRiGzo4b0DxgT4B5lob55TUYX1hdu5ftsltFdb1pmHF2MfjroFFmeGqU1l+ZZuihF4xwFzAnmNOkwcup8ckws/yOiGGP1aKW6Nv1ySmLB+lko/Wfq7DvEj9toH7cp+hWUY0JsIGB4F6JCtHii3KcvyUrV5MS9EckpWbL2VWfg62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4KcJxDKwKXBM/TzhYvxQrgoNNimEP3hPWf278FntQw=;
 b=Ln7VfEma4hqvnyKMIpgGAIRyQ++FYs/lkWYAvCYf5rwOmIowgfD8rCIFjr/czh0Pn4NKSrgwWCdi+PmvQK9lwtACoE8eT7Epwk+TeMA9X8g24fEsaFq0bRl8+QY4S6bEDn0g56BAWixEguLBmsZb557lDNHScA2aOR4GdIAzSdk=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB4242.namprd12.prod.outlook.com (2603:10b6:a03:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 02:39:14 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 02:39:14 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Peter Chen <peter.chen@nxp.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: udc: core: Use lock for soft_connect
Thread-Topic: [PATCH] usb: udc: core: Use lock for soft_connect
Thread-Index: AQHW6TqPA5FX8bEPGkiCDn1hzxU8g6okxBiAgAGmVoA=
Date:   Thu, 14 Jan 2021 02:39:14 +0000
Message-ID: <42729023-e916-855b-d19a-32508e10647d@synopsys.com>
References: <8262fabe3aa7c02981f3b9d302461804c451ea5a.1610493934.git.Thinh.Nguyen@synopsys.com>
 <DBBPR04MB79790965BEC1A036A2048A088BA90@DBBPR04MB7979.eurprd04.prod.outlook.com>
In-Reply-To: <DBBPR04MB79790965BEC1A036A2048A088BA90@DBBPR04MB7979.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcd63e82-6123-4242-9825-08d8b83594dd
x-ms-traffictypediagnostic: BY5PR12MB4242:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB42427C63388C5E34FC012C9BAAA80@BY5PR12MB4242.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3KeG/3aV0cxz6Mt+9J10q1ANvjvsncJ1CvoNa9KgLKc9XOute9KoZvigNLcn6GcrKuT6H9yVsA5/piC3qt0I0jtE8H5ZpgANGvNIOVWokBhRwJIcmG7sJ2/q2gSUFbvSVs6/LKkj7EGl37UjaRuO+3wBxz53z0RDCpn9CyWJbvOxd7BhsFkzUl2pnsnYJlq42v4Vz4tKHsVd7oMXKor9gppqyDtxE4lNFt2xlu6OZlO5DNaaildg/5VEcXtDaH20CPhNyD6gaThUrSlJTcTvWZXoekW6UFKKTWp32Xcna4UpVvZ7DkzjbbNaxxvN453S+D8LttKE8VUhdTlIWAtehc+r9gjY6hOY7xKNsJECn4h2CgGQ1Pv7+bOW6Rgk5NX0BKK/M/uTfEHpizHRb6AGmXO4Xtmt9C/KsnKXxkqvxhCu10znrHoLkG+m/IyZbibfa5POC3PIxIy4Gep/zocH7JZl9mArz5aVFvilGD2BuTDzSyQWxbuFIRAL5/rJT4fG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39860400002)(396003)(376002)(86362001)(31696002)(36756003)(76116006)(4326008)(6506007)(5660300002)(4744005)(31686004)(66946007)(2906002)(83380400001)(71200400001)(66476007)(64756008)(26005)(2616005)(6512007)(6486002)(316002)(8936002)(110136005)(921005)(478600001)(66556008)(66446008)(8676002)(7416002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cjFmY01UZUpQVmpucnVqMFpBOGhvcXpESS9tbTJraHRBNUx5ODBXMlc0R0Vj?=
 =?utf-8?B?OENwNE9vUVlacVkwQnZ6YzkyOFN0SVB0VHJ2UlVISG05NkkveU9GWDVzSXBI?=
 =?utf-8?B?WEptQ2ZubjVjeWNDa0o1T1dPTkpIZUhuVnpEenJlSzErYXh0Q2NPNjdiZUNX?=
 =?utf-8?B?UDBWYnRGN2xNdnMyN2lBUkhKdFg0bGg0MnNjQXpycCtnWGVMSGprYmE3TjZu?=
 =?utf-8?B?UmdaMHdBWHJFcjk5cDZOc2I0WGJsdWJFUExnRDNKeWhBMGxiWEVZdUpGcHRC?=
 =?utf-8?B?SzBiRzRoRjJnek85cDlOR3hCV3hzN05HV3JzZndxbWhPWmdvS1BUa3BlclZn?=
 =?utf-8?B?SzhJUmwzMk5EeDBqbjVIeGozd3crak9jY1dsL2hVS01DVjVIWnpNOEF5UTdD?=
 =?utf-8?B?b1o2QjhPZSttN1JXRlpUTmJlZWIrZFhCcDc3dU5xTGlicWRaUFE3bUJoMTBu?=
 =?utf-8?B?MFZsMElpV3FsNVBzZFFOY29Ia1Y3WUFLUWVSZGFzdkdzajFGR1FxTVBzU0lx?=
 =?utf-8?B?TjVYLzgvek0vNEFaV2dwL1hoTndMeUlkZnpGbUV4c2lQajZOeHRXRWJTWGcx?=
 =?utf-8?B?cjZ2MUJub0w4Nm9lZGxFc1JwS0hVWlJpd3Vxd2ZuQ0ZFdytraWJOempiZGV5?=
 =?utf-8?B?clZyaWI0SUh4alVZbEUvTEdkZUFCY29qWmFQMFJnTzU0d2wvajZDa0xxblZs?=
 =?utf-8?B?NHYyMVNwTGg2MEpwYVV3Yk5CQ0M2WG5iaFA3eWtGdDkrSmhPdXJ3ekEwc1dh?=
 =?utf-8?B?WmEvanhxMFdobzdxZFA4VCtJT3E2VHVBZ0Uyby9ONlF4cUR6L1d2M3N0SStp?=
 =?utf-8?B?YldvNDlyUllveVYvZ0gwN0xiMW5NTDMyN0JJUnhBcWE1dlF3d0I3WGM2WlpP?=
 =?utf-8?B?TVJLQXlscytsNnRzRWxKY3ZkWnpiRm1jcFZzRGR3NmErQ0xXT25XYjdWMUhj?=
 =?utf-8?B?Nm1zR3VOQUVoWndlb0RDOEorRFMxMDNXbFFvK3JQWEdrWGg4Rmd1SXY5VGZu?=
 =?utf-8?B?R1hzQ1hkVjFqRkRNeDY2UzA2MHpEd0ZpeG1uWmdSLy80czZWU2JzK2MvLzhR?=
 =?utf-8?B?WXA5NXpkanZ5MTQxenVLK1pmU2UycG1ZRVpzSVNKQ2w1VUM1MFFJUWk5MWcr?=
 =?utf-8?B?ejJBY0E3dW8wNTBydUtCSFpnVVJOWHJURUVsUUo4ODRrbFdTTXNFNituQ2ZY?=
 =?utf-8?B?SENhQXl0TEJJU0lseTJTTmVEVi9wQm5rMzV0cWxYZTBXQkVpRzVLYjREQjZF?=
 =?utf-8?B?Vnd4ZjFFUWxoenp2TmlVTmc4Vm5FMnM1enhua01wa0lVMHJOOHNEWmNtOTJu?=
 =?utf-8?Q?4rNO/jAOu0LaE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <638323E663B3D44B85E4EB8A17AE62D0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd63e82-6123-4242-9825-08d8b83594dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 02:39:14.2143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aLtIj2acIV9oMM5EfsPCrn978ZCHrwujfl5M+q180D+AHnhfaemthRzK7kJMFojEC7MJ6h70CMeqUnb5Zza6+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4242
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

UGV0ZXIgQ2hlbiB3cm90ZToNCj4gIA0KPj4gVG86IEZlbGlwZSBCYWxiaSA8YmFsYmlAa2VybmVs
Lm9yZz47IEdyZWcgS3JvYWgtSGFydG1hbg0KPj4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3Jn
PjsgbGludXgtdXNiQHZnZXIua2VybmVsLm9yZzsgUGV0ZXIgQ2hlbg0KPj4gPHBldGVyLmNoZW5A
bnhwLmNvbT47IExlZSBKb25lcyA8bGVlLmpvbmVzQGxpbmFyby5vcmc+OyBBbGFuIFN0ZXJuDQo+
PiA8c3Rlcm5Acm93bGFuZC5oYXJ2YXJkLmVkdT47IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51
dHJvbml4LmRlPjsgRGVqaW4NCj4+IFpoZW5nIDx6aGVuZ2RlamluNUBnbWFpbC5jb20+OyBTZWJh
c3RpYW4gQW5kcnplaiBTaWV3aW9yDQo+PiA8YmlnZWFzeUBsaW51dHJvbml4LmRlPjsgQWhtZWQg
Uy4gRGFyd2lzaCA8YS5kYXJ3aXNoQGxpbnV0cm9uaXguZGU+Ow0KPj4gTWFyZWsgU3p5cHJvd3Nr
aSA8bS5zenlwcm93c2tpQHNhbXN1bmcuY29tPjsgTWljaGFsIE5hemFyZXdpY3oNCj4+IDxtaW5h
ODZAbWluYTg2LmNvbT4NCj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+PiBTdWJqZWN0
OiBbUEFUQ0hdIHVzYjogdWRjOiBjb3JlOiBVc2UgbG9jayBmb3Igc29mdF9jb25uZWN0DQo+Pg0K
Pj4gVXNlIGxvY2sgdG8gZ3VhcmQgYWdhaW5zdCBjb25jdXJyZW50IGFjY2VzcyBmb3Igc29mdC1j
b25uZWN0L2Rpc2Nvbm5lY3QNCj4+IG9wZXJhdGlvbnMgd2hlbiB3cml0aW5nIHRvIHNvZnRfY29u
bmVjdCBzeXNmcy4NCj4+DQo+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPj4gRml4ZXM6
IDJjY2VhMDNhOGY3ZSAoInVzYjogZ2FkZ2V0OiBpbnRyb2R1Y2UgVURDIENsYXNzIikNCj4+IFNp
Z25lZC1vZmYtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5bm9wc3lzLmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IFBldGVyIENoZW4gPHBldGVyLmNoZW5Aa2VybmVsLm9yZz4NCj4NCj4gUGV0
ZXINCg0KVGhhbmsgeW91IGZvciB0aGUgcmV2aWV3Lg0KDQpUaGluaA0K
