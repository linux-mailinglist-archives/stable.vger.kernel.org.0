Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E87F2EEB6B
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 03:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbhAHCmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 21:42:00 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:38434 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbhAHCmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 21:42:00 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 83B9740239;
        Fri,  8 Jan 2021 02:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610073659; bh=TWCRUJKUJuxOIoqzgEGa4GqzgWg6fhgmazERnfjXIhQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=eM+mWWZj5wI26PbWTReGf5lmHL0A5POgBpYtJRCTh/c23mTN4i9vIWZu80svJebr5
         +fQXHVgECBnRblNhSx5dkSQjvW1sjAOoVwAi8i142theQU14I08wk+LMxHU+5yvGw3
         kIX2tBsG6Y6bP0V6a6c1WluhOf/vG9Yo9uso9IvjVoRW7Vlu6imdbi/HWhN7W5iMO1
         vMGKRIODHwMDtMqALWJo9UcYlxcJ2wI7RluZFNYwUvbdAVP8YgXpXDnHwpUMgmqKfa
         4n6aYjRCOvM8pw7r5kk+0PM9w8/WT3iSri49kiHkoaF8Ig4DhSON7T7cBW1+uCpUBB
         0mocpM5+rHRQA==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CE653A0067;
        Fri,  8 Jan 2021 02:40:58 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 9EFCE80FD7;
        Fri,  8 Jan 2021 02:40:57 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="kgA+P4y5";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgV3mlHgmWrvbxsiV9r4yRC1tTsBeDWGLfYXVgKXD+UBn3PG8VjG55oQTT09F4ghajVpC1gLg1cfTs58sqCLWyXr8oHsnr9ztvZkMmXXcuPXwvotEw8FDuSkPotXSeNCzBLSWS10k+CYUD9b++Bo9uEc5eCAR5tNQulbHZ8nA9RUJlJrDK3+SyU1LruWq/dmFCPVPwYoi419frM/og+uJ652GLHq+LRaQ7jeSIge+PSrexDeduLYwdJZrdgFBuudcExc123IHeDLUeZcBkmqq+o3XexxayCzgIgQQ8yqRUTMI0oMVpReKtGTw6reSdPubBWl+YuBcJr/EAqMT5+vkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWCRUJKUJuxOIoqzgEGa4GqzgWg6fhgmazERnfjXIhQ=;
 b=DYit6Z5ygehSgl2KbDtWsh/FgpALcGCBd1EgG5prRSY1IZEqfYMlAJgciEgm2TbwJK3ZteW4bGzq1XOZSvKk2U1Fl9k3sM8ZbrCT/l+mI/ZBY93F3GBYUaiC/fwISKO47wgr1GPYe6Ng4reIfKCEgdlrjTVKRhyKy407ZFGKyztFcZfFA8l0SgsGnm4Zn9t4yQQtld9x4WPXdmV8ztj6uDTHNN3qOHuaX6P0rnvPyuvrdHfrlSl5mbaM5P9CB4Kp5L1MA+1hELAiBbLv1iMYpXB8RJXhU97OYJSUoCvnUaCRjnKMvLtOIhMVJC+6OseaH2WfLyhNhVb/6AQlAiHeFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWCRUJKUJuxOIoqzgEGa4GqzgWg6fhgmazERnfjXIhQ=;
 b=kgA+P4y5smcdikO+s44j6aNSjxr8fOJC4ei8ibrY9ki9vOfg28rz7iSKpwfGSeoNTfCG1bCvdwiLN9TVs9hDu0pvRFgygbrM9EzqneDtqYFQJDAnAR2r+3rBzAHkLFtmP7hMgPDCiEEffpWXZWqgJZsdCG6gvZTTm1cFbMlPO2I=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB5014.namprd12.prod.outlook.com (2603:10b6:a03:1c4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 02:40:55 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3721.024; Fri, 8 Jan 2021
 02:40:55 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Peter Chen <hzpeterchen@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 0/2] usb: dwc3: gadget: Check for multiple start/stop
Thread-Topic: [PATCH 0/2] usb: dwc3: gadget: Check for multiple start/stop
Thread-Index: AQHW44O4pMz5R7e5g0W2OmYsrsvDEaodBy8AgAABKAA=
Date:   Fri, 8 Jan 2021 02:40:55 +0000
Message-ID: <93173de2-4ba0-52ab-1453-da5535c70ace@synopsys.com>
References: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
 <20210108023646.GB4672@b29397-desktop>
In-Reply-To: <20210108023646.GB4672@b29397-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc6498e8-eb58-4c8b-959e-08d8b37ed2ca
x-ms-traffictypediagnostic: BY5PR12MB5014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB5014C8E83E98B0B63CD5E964AAAE0@BY5PR12MB5014.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:338;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WlE4fG/WBBYLlALGZ1yH2XK3NS/p23lhldi7/EV4uZ5hpfnZG2h6c1kUvvyiWaD3ERw2xxXqargRTqaYM6I7Wwx/2cUJboZ2qkqBUsoaxr/14hsBdF9V2UfuYrpZxOqAtYo6R29LMdsvw6MGn4nE60TsE1PBHsvDu4PeAEsdqNP44w66ccmUtr3L4LHufFomHoGt9EA0LWV6Y7XlqZ38mqVoVH5HEDDNtMFs58ZfyXt8I02k1tcsN8JSWC3iujQ5jVM7p6Xz3NNGipxZI8FjE/VgV0G2dHs2Acbq0RLq5oWP7uFB14UGD8pwRxiW8NQbRMdfv8Yx6hqxZjzOPBtuTbDI05rdYZVpFfSTT9Ekr0RQ0D5XWq8BeOQZ2P8Qgaoc/wn63pzx6CoadRSx2CzEPpTj1xHxQHyq/AesUP93vAfwODTXsqMxdaqaV82SVzp5Dgqnu1QNIc9MBvxGQeRSDSbpCH+INkfQQWUGxREJE8I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(136003)(396003)(66476007)(36756003)(6506007)(66556008)(53546011)(76116006)(64756008)(66946007)(2616005)(66446008)(5660300002)(4744005)(26005)(316002)(4326008)(186003)(54906003)(8676002)(110136005)(6512007)(86362001)(8936002)(31696002)(6486002)(71200400001)(83380400001)(31686004)(478600001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M1VXMmFVUTFJbXdMWUt0Z09SeGZaNlYxM2VjTmo4NjR5UUtWSHZyQmlYT0gy?=
 =?utf-8?B?OW5UZjZ6UlcrdWVIR011aUppOW9nKzhtZ1JnK3RhYVpjM3E4YW9hd3FlREZk?=
 =?utf-8?B?elY1ZUhlMm84U1RRbzVDY1BPc3VEcEtmVUtFbEJlMmNwOU1hdDMvNUFaMTNn?=
 =?utf-8?B?Ukx1b1BsZzB6R0V2c1FUWEtOcXVsdUNxVmRDVDVXU0s3c3JVNTl1Uzd1TGJG?=
 =?utf-8?B?T2ltcnNiRGplNEZJS1RTakFpcjVIenUyZUMxMGhIYVljbzV5cDRnQjd1QWJJ?=
 =?utf-8?B?cERJMitBK1ZuOEFrL3U0UEU5YkN5TElXcFpKbXFIaFY0cXIyVmprSUczQXJI?=
 =?utf-8?B?Rk5adEFBTUkxMWd0QXJXNlozSVZmTVF3RWVvbWN0cjdSbHlPWFp2N2ZxUHFk?=
 =?utf-8?B?Y2lyelpWbGhvN1pPWUNGalIxR1hvMHpMOGpHdGJScTdZNmQ0S1BmTWJyczRJ?=
 =?utf-8?B?dmViYXUvb0VzV1VleW5uNi85dDh0WkpuZ1VCckxDVXE3RUxMU1F5K0NzWTV5?=
 =?utf-8?B?ZzduVExmRzhTc1VIeVM5TmIrU0tVTk9Ld0R4L1BHM3k1TUgvT0FaNVVHcmkz?=
 =?utf-8?B?ZXdyNGZSNjdYWEwvemh0WjVKajZYSVE3UmhsZkFjd3R6R25odjU4Y21sV1F2?=
 =?utf-8?B?dlUwcVpBakxteUNHdVoyRHAzdUkxRExCVEhJU09qeldLemhiS1RPdDV5ZGgx?=
 =?utf-8?B?Y3AybVlDS1c4OUVYa0FjLzcyQmJITXhSQjk2cmp5aFM1dFcyMklkdTlrMkw3?=
 =?utf-8?B?RzhMcDVXVXRSVmlPWTNsQ3FhS0pDZWFiM0gxS0tsRFIwalhSMGsvSUVBeFNC?=
 =?utf-8?B?Z29oYVVJWkNZWnRNN215YkVET0dmSmhrT1BnUDczMzBCNnRGa1l1Z2tVL1E4?=
 =?utf-8?B?VVVNYk8wRzk0S2dOTlNwYVVOa3pxUFZQbVZCN01TOG9ZU0J4dDRhdTVIVWQ2?=
 =?utf-8?B?d1dRa3hWK1ZJaUpmTmR3WUFGU20zVFdFbmJQS092WmZ3WGJXaEhqK0FTeGQ0?=
 =?utf-8?B?c3RrdElaMVlnZ2xSUWUvTDVjWjNNekFQWENtQ25IQzFtTUJsNUVCdUhQU1Bu?=
 =?utf-8?B?bVBuUWUrQnRTcE9rNDhlVEc5d3Z0a3JWY25ZOGhCSVI4K3YwTUxYZ2dnMkRJ?=
 =?utf-8?B?cmFrS2RHTVhVamNGSEVJT1VKU2VhOW9CTVNyQm9iSkJMcmJxTDF1aHNPc2tj?=
 =?utf-8?B?YWhBUHJNak1jMXhJbHk3MVNxZCtRcGFrVERoeXN6S3NRL1BIMUlOWTQweUN3?=
 =?utf-8?B?QjlnSllHZisva3JqR3N0ZElxZHhYeUtoYWR4Vm5oR3d3RTFRdzQ2RzFrNzNl?=
 =?utf-8?Q?Wt8x4cFvxgbk4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D0F4807794B5448905AB678A44EED5E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6498e8-eb58-4c8b-959e-08d8b37ed2ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 02:40:55.5608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hMhoCXbceVsdz6Ud0L45c/dKPyiKvfsy3s1qqZXVEpFLmYDBSkZJm+If+wj8yxO2kY6rwBWAy/AirldaYyIppg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5014
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgUGV0ZXIsDQoNClBldGVyIENoZW4gd3JvdGU6DQo+IE9uIDIxLTAxLTA1IDA4OjU2OjI4LCBU
aGluaCBOZ3V5ZW4gd3JvdGU6DQo+PiBBZGQgc29tZSBjaGVja3MgdG8gYXZvaWQgZ29pbmcgdGhy
b3VnaCB0aGUgc3RhcnQvc3RvcCBzZXF1ZW5jZSBpZiB0aGUgZ2FkZ2V0DQo+PiBoYWQgYWxyZWFk
eSBzdGFydGVkL3N0b3BwZWQuIFRoaXMgc2VyaWVzIGJhc2UtY29tbWl0IGlzIEdyZWcncyB1c2It
bGludXMNCj4+IGJyYW5jaC4NCj4+DQo+IEhpIFRoaW5oLA0KPg0KPiBXaGF0J3MgdGhlIHNlcXVl
bmNlIHlvdXIgY291bGQgcmVwcm9kdWNlIGl0Pw0KPg0KPiBQZXRlcg0KDQpZb3UgY2FuIHRlc3Qg
YXMgZm9sbG93Og0KDQojIGVjaG8gY29ubmVjdCA+IC9zeXMvY2xhc3MvdWRjLzxVREM+L3NvZnRf
Y29ubmVjdA0KIyBlY2hvIGNvbm5lY3QgPiAvc3lzL2NsYXNzL3VkYy88VURDPi9zb2Z0X2Nvbm5l
Y3QNCg0KYW5kDQoNCiMgZWNobyBkaXNjb25uZWN0ID4gL3N5cy9jbGFzcy91ZGMvPFVEQz4vc29m
dF9jb25uZWN0DQojIGVjaG8gZGlzY29ubmVjdCA+IC9zeXMvY2xhc3MvdWRjLzxVREM+L3NvZnRf
Y29ubmVjdA0KDQpUaGluaA0KDQo+Pg0KPj4gVGhpbmggTmd1eWVuICgyKToNCj4+ICAgdXNiOiBk
d2MzOiBnYWRnZXQ6IENoZWNrIGlmIHRoZSBnYWRnZXQgaGFkIHN0YXJ0ZWQNCj4+ICAgdXNiOiBk
d2MzOiBnYWRnZXQ6IENoZWNrIGlmIHRoZSBnYWRnZXQgaGFkIHN0b3BwZWQNCj4+DQo+PiAgZHJp
dmVycy91c2IvZHdjMy9nYWRnZXQuYyB8IDI4ICsrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0N
Cj4+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pDQo+
Pg0KPj4NCj4+IGJhc2UtY29tbWl0OiA5NmViYzljODcxZDhhMjhmYjIyYWE3NThkZDkxODhhNDcz
MmRmNDgyDQo+PiAtLSANCj4+IDIuMjguMA0KPj4NCg0K
