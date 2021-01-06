Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946762EBBB4
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 10:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbhAFJaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 04:30:18 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42166 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726006AbhAFJaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 04:30:16 -0500
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CEDFDC00AF;
        Wed,  6 Jan 2021 09:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609925355; bh=BxDJqdYIQaDHCyhK9gXWbEODskTN6hlNiYiAmwvbO18=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=BtOY9qEsqiWCg0gmqjO8eCldvIDtQegqjErA335TXt/RWNs/j0ckQogcwQDbFhiBx
         gmug56dhejFGfavrgbJTTg45V3ZVEvxX4cM0xXwN5yetZAdaoiZi1y6+B6J9vXzPoP
         hJywyCLOj6I3SPVnH06+/2bl80S1DPTJRZ6B1S7fVYM8JxNcC5AHpHucUXFeBzJwTf
         WQvTSNWEKPFhlcxbVZ9lES5FOVFobwi2fygdZTlymS5BTmx7TU3M/xQHnIYbXuFqFS
         Hmn7L3/FNfRNzp4AHqCZquKOlAEmb0V+mVnNnbpY+MZlRTBYK/8fYbsPcrqdiUJ/BW
         RQK6KTeaHAaDw==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B44A6A0063;
        Wed,  6 Jan 2021 09:29:13 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 23639400DA;
        Wed,  6 Jan 2021 09:29:11 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="cbeTxgyg";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nG6ReQiOs9tuhhw7R2+PdNTWsmWu765C/5u+/c2vAYWPSTr5WzJX7q3tYmb+RaD9/o5Ku8C5CggXC8MdVwinOio7duUJZKnfZFLL3AVXaCRdmrkD4zd+t7Z8tIPriXKydyTqDURdfRUWqPrDJlYUtT8uOv+Esu3mXbZ3iHRfJefYq5kd7NQtJkmIzr2G3UqTcwcMTvNkFWAvPsDBQRir7rCcEBCgCuIuN0pyJadqjaqV9LPuTmaEn7vKB7bQwATWTqrQ8DOfqUIq/p35JhAOSZMKA0p1evMVh3baLwH94ZGDeYI6j89wI84Ltg2Wnte0HRiwWUB+aRKHnQayRg0G2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxDJqdYIQaDHCyhK9gXWbEODskTN6hlNiYiAmwvbO18=;
 b=dmBJiYL5uBLh2bhA6G2PrNHbSA6fbIYZIvCgsC2eD9JJYqXiGOCEU+4dz1hYvr9PMyVChL3J+gFSRD/gBE2Kk9CxHbzVsF5RW00oPetJ8Lpc6A7gY3ly32vmYhREwp5rF95EaPzpMH/XbomxdozL//3HtFbeLn5xhlLsfXFjEtfRfrc+XoLeuoyTxoM6EhrLbn1mJI5ElYTJBfbGZKeBqNqLpq1C6hZ9tBxfcwWnIm6l76aLCejhzAMzpvosX1KfccXBmqeb6UTfHKxSHWVrgjBIkPf0QK/Jj0xeb2eNEsfjScc2cBMtLoMfhm6ye3ms39d6i41OCGUxWnj4rul/Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxDJqdYIQaDHCyhK9gXWbEODskTN6hlNiYiAmwvbO18=;
 b=cbeTxgygzefWNmEbfeR4cJhwA4Mc60x4MoTSZNu5Bt6Tj2xU0jyPVGtthINSZIxSCa02PUJU7ViELvk2Nl1KL7nfZwZ52ENvM9YpSgMxq4FrmOXhSwdJZUe+TweWO9rYevtYuvwv6e9jI/2wZauJFaejFFPb36L8/3DgmHYbJmQ=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB3858.namprd12.prod.outlook.com (2603:10b6:a03:1a7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Wed, 6 Jan
 2021 09:29:10 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3721.024; Wed, 6 Jan 2021
 09:29:09 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Init only available HW eps
Thread-Topic: [PATCH] usb: dwc3: gadget: Init only available HW eps
Thread-Index: AQHW44dsvevXDR9T+0aaJdM98rGhjKoaOlYAgAAbXwA=
Date:   Wed, 6 Jan 2021 09:29:09 +0000
Message-ID: <75d63bab-1cdc-737e-8ae2-64e0ddeeef75@synopsys.com>
References: <3080c0452df14d510d24471ce0f9bb7592cdfd4d.1609866964.git.Thinh.Nguyen@synopsys.com>
 <87eeiycxld.fsf@kernel.org>
In-Reply-To: <87eeiycxld.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c17207ab-6187-43c4-72ff-08d8b225858c
x-ms-traffictypediagnostic: BY5PR12MB3858:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3858917CF264595D1C104579AAD00@BY5PR12MB3858.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SdlUUX1lh3YFIhzMLm8VTyFoY2Huu9fPv4Q7F7npIHjTFmFv19rEEbYQYGERE4fmPV0C4IjSi6Ngd4O8k775gjh5jVGClyAu+PP16VL7CMq9gCC30YAj6NX+lZ2+pI2tHkdYcMo/NnQEh6SN55DJ3XK8Jy3URLF1A0p7GgyUp5rimere1jMx+6lkxweLD3+XeQPs0wTk24Xl7dkzZGe+O/ND4aknqum6mcWeTVyKUixGDbAZItnFkqEzILvNr+f0y1AZ356jHYpPGtvyKtkC5kv9NGSmLJxbbKPoBP/6OezCRoAxWpxKNv8DWNy5XbMjflYos/jIVQmV9n7KjfSduBkDfcJ4mPSYipyN5QvMcoZ5a5IP2QZF0f0JTRkgQmTKM3LJeB4k8yzeIfq3gqk2aPXlfGtQ0jLVvInwSfqKwL8T/4/LPR5Je/HvsLMFtPjAf2sBB+uvRoJ97RkvpCINF0IKnnQnqZ44HZ4NBf42I4YZwCdzqhLodC001ZltEPG+tvLu1h1tYG+X2aJIslnpRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(376002)(136003)(396003)(6486002)(86362001)(110136005)(316002)(8676002)(54906003)(66476007)(71200400001)(31686004)(5660300002)(66556008)(64756008)(76116006)(2906002)(83380400001)(66446008)(66946007)(6506007)(31696002)(8936002)(2616005)(36756003)(186003)(478600001)(26005)(4326008)(6512007)(131093003)(45980500001)(43740500002)(473944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Ri9rQW5ZTjF1TE9mYzFILytaUjYwVXFWUUwzSnhqejVVTjhGNFFrOFVsOU1v?=
 =?utf-8?B?SFp2VlB6QVVRdGw3d0NYSHRaSmRsTkR2N2tGeVNEZFpDN2dnTE1OOUhuVExH?=
 =?utf-8?B?RlZkclJkY1BGU3ZrUi81czNDU1UrRWdDZmVvUkZVbVVBOUtwYjdRazdZVENV?=
 =?utf-8?B?aGthOWdYTDNIalJUSEt2a1M5TVpJeXJGRWhHT1MveW56ZW5wTlhtbjFNaU92?=
 =?utf-8?B?cVBnV2VDVEE2OTFGM1BpcEZEQ2dKUnF0YVYrN014ekpHVENNZzNTalNDN25v?=
 =?utf-8?B?OHR1N24yVGVPVG51Y1JJYlk4VWk5eXdKQW5VRzVUUGhGOE11MlZzY3BGWmdJ?=
 =?utf-8?B?TWNWS3g5ZDlMMGJ3WFpBOVpicGwwcXdkUXExNHVQWVhmMkRRcXBJbWJobThL?=
 =?utf-8?B?d1ZlYWtJTnd0N3A1dXI5N2s1MWxHMkJNOGw4blVYdzhMdE9NTmFGNVV1UW51?=
 =?utf-8?B?anlhcjRPQU9Hb3h5UWxmc1dOTHU2cW5VK003eHR4c3ljU2kyN0RkN2dKbUJK?=
 =?utf-8?B?RDZvaFo5ZE5TS3pEOWNxQTNMMTNhaWI1ZVFBZmQ5d2xJWXVUYWQ4QnBNdjhq?=
 =?utf-8?B?dmtkNWdxSDhsUjUzMkFPQ2lzTitERCtjSDBpVmJYU3VILzVwZGJhNjUzd2N0?=
 =?utf-8?B?NVFGNTNnRHV3cFRCdnV3bElndG1ORjRmRmdoM1JZT0ZJOEwwTFNNekNSbVI1?=
 =?utf-8?B?QVcyRFFYZW5jZmgwK2lPQlJtNVRFNHJZWHN0NlRXZXVLUkN6emlwN21WaWN6?=
 =?utf-8?B?Q0F4OFB5V05kNGVsbFVpSFpHUUhzVGtIb09rNE5NcUIxS2JhbzJ0RGpTZUc2?=
 =?utf-8?B?OHdrb09wUmgwcllxRlBkaDhNV09RZHRLNTgrdXB1b3hEOG9uMUFUYkpVemtT?=
 =?utf-8?B?Nk9McXRMQVMwT2FrbkxMTWkweTN0ZGtocFB2b0xnOVBOdTdMTzFaSG9SVlo5?=
 =?utf-8?B?Yi9TQWdlSmltR2liVTk3bzVrNG1YYktUNUVqeVN0Vkkxa21VaXNpbXNLd2sz?=
 =?utf-8?B?ejBxaUM3cG9RNGJGcDV6RWd4RGMvM2JtK0IvencxQkJvWmFJd2w2R1hORmgr?=
 =?utf-8?B?UUd0ZmVOVGhHeFJMUEdXbThDWDlkYWk5c3VYb244VTl4UzBqUnM4Mlhwb0JJ?=
 =?utf-8?B?K3QzK2R1d1B5ZHVnZ2gzRDgwUFRmblNERzczT2kyZDlHRG1oSWNScmJ5dWpj?=
 =?utf-8?B?ajRaSmpHUjJ4OENjdG9xRzBMdlNUNVZxQzNncEZ3NU0waGVPYTl0QWhSbUJj?=
 =?utf-8?B?aGlZTVhGNm8vSzAxcG9TdFpqemFHdXh3N001czdkSy9nWXdxZHB0VE05Y09v?=
 =?utf-8?Q?mWcyhjNqo/7dM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D33D836FCF5A5F4ABB107CD09855EC16@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c17207ab-6187-43c4-72ff-08d8b225858c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2021 09:29:09.5224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tr4NbE7UL/89eNNiGAClF3p4tPXNdbyHz/6RVRly7T50PnJf1hxuAqlvN/rMOn1Mu71R8ik9Bet8i/ps+9Whnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3858
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCkZlbGlwZSBCYWxiaSB3cm90ZToNCj4gSGksDQo+DQo+IFRoaW5oIE5ndXllbiA8VGhp
bmguTmd1eWVuQHN5bm9wc3lzLmNvbT4gd3JpdGVzOg0KPj4gVHlwaWNhbGx5IEZQR0EgZGV2aWNl
cyBhcmUgY29uZmlndXJlZCB3aXRoIENvcmVDb25zdWx0YW50IHBhcmFtZXRlcg0KPj4gRFdDX1VT
QjN4X0VOX0xPR19QSFlTX0VQX1NVUFQ9MCB0byByZWR1Y2UgZ2F0ZSBjb3VudCBhbmQgaW1wcm92
ZSB0aW1pbmcuDQo+PiBUaGlzIG1lYW5zIHRoYXQgdGhlIG51bWJlciBvZiBJTnMgZXF1YWxzIHRv
IE9VVHMgZW5kcG9pbnRzLiBCdXQNCj4+IHR5cGljYWxseSBub24tRlBHQSBkZXZpY2VzIGVuYWJs
ZSB0aGlzIENvcmVDb25zdWx0YW50IHBhcmFtZXRlciB0bw0KPj4gc3VwcG9ydCBmbGV4aWJsZSBl
bmRwb2ludCBtYXBwaW5nIGFuZCBwb3RlbnRpYWxseSBtYXkgaGF2ZSB1bmVxdWFsDQo+PiBudW1i
ZXIgb2YgSU5zIHRvIE9VVHMgcGh5c2ljYWwgZW5kcG9pbnRzLg0KPj4NCj4+IFRoZSBkcml2ZXIg
bXVzdCBjaGVjayBob3cgbWFueSBwaHlzaWNhbCBlbmRwb2ludHMgYXJlIGF2YWlsYWJsZSBmb3Ig
ZWFjaA0KPj4gZGlyZWN0aW9uIGFuZCBpbml0aWFsaXplIHRoZW0gcHJvcGVybHkuDQo+Pg0KPj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4+IEZpeGVzOiA0N2QzOTQ2ZWEyMjAgKCJ1c2I6
IGR3YzM6IHJlZmFjdG9yIGdhZGdldCBlbmRwb2ludCBjb3VudCBjYWxjdWxhdGlvbiIpDQo+PiBT
aWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+DQo+
PiAtLS0NCj4+ICBkcml2ZXJzL3VzYi9kd2MzL2NvcmUuYyAgIHwgIDEgKw0KPj4gIGRyaXZlcnMv
dXNiL2R3YzMvY29yZS5oICAgfCAgMiArKw0KPj4gIGRyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMg
fCAxOSArKysrKysrKysrKystLS0tLS0tDQo+PiAgMyBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRp
b25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9k
d2MzL2NvcmUuYyBiL2RyaXZlcnMvdXNiL2R3YzMvY29yZS5jDQo+PiBpbmRleCA4NDFkYWVjNzBi
NmUuLjEwODRhYTg2MjNjMiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvY29yZS5j
DQo+PiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYw0KPj4gQEAgLTUyOSw2ICs1MjksNyBA
QCBzdGF0aWMgdm9pZCBkd2MzX2NvcmVfbnVtX2VwcyhzdHJ1Y3QgZHdjMyAqZHdjKQ0KPj4gIAlz
dHJ1Y3QgZHdjM19od3BhcmFtcwkqcGFybXMgPSAmZHdjLT5od3BhcmFtczsNCj4+ICANCj4+ICAJ
ZHdjLT5udW1fZXBzID0gRFdDM19OVU1fRVBTKHBhcm1zKTsNCj4+ICsJZHdjLT5udW1faW5fZXBz
ID0gRFdDM19OVU1fSU5fRVBTKHBhcm1zKTsNCj4+ICB9DQo+PiAgDQo+PiAgc3RhdGljIHZvaWQg
ZHdjM19jYWNoZV9od3BhcmFtcyhzdHJ1Y3QgZHdjMyAqZHdjKQ0KPj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL2R3YzMvY29yZS5oIGIvZHJpdmVycy91c2IvZHdjMy9jb3JlLmgNCj4+IGluZGV4
IDFiMjQxZjkzN2Q4Zi4uMTI5NWRhYzAxOWY5IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy91c2Iv
ZHdjMy9jb3JlLmgNCj4+ICsrKyBiL2RyaXZlcnMvdXNiL2R3YzMvY29yZS5oDQo+PiBAQCAtOTkw
LDYgKzk5MCw3IEBAIHN0cnVjdCBkd2MzX3NjcmF0Y2hwYWRfYXJyYXkgew0KPj4gICAqIEB1MXNl
bDogcGFyYW1ldGVyIGZyb20gU2V0IFNFTCByZXF1ZXN0Lg0KPj4gICAqIEB1MXBlbDogcGFyYW1l
dGVyIGZyb20gU2V0IFNFTCByZXF1ZXN0Lg0KPj4gICAqIEBudW1fZXBzOiBudW1iZXIgb2YgZW5k
cG9pbnRzDQo+PiArICogQG51bV9pbl9lcHM6IG51bWJlciBvZiBJTiBlbmRwb2ludHMNCj4+ICAg
KiBAZXAwX25leHRfZXZlbnQ6IGhvbGQgdGhlIG5leHQgZXhwZWN0ZWQgZXZlbnQNCj4+ICAgKiBA
ZXAwc3RhdGU6IHN0YXRlIG9mIGVuZHBvaW50IHplcm8NCj4+ICAgKiBAbGlua19zdGF0ZTogbGlu
ayBzdGF0ZQ0KPj4gQEAgLTExOTMsNiArMTE5NCw3IEBAIHN0cnVjdCBkd2MzIHsNCj4+ICAJdTgJ
CQlzcGVlZDsNCj4+ICANCj4+ICAJdTgJCQludW1fZXBzOw0KPj4gKwl1OAkJCW51bV9pbl9lcHM7
DQo+PiAgDQo+PiAgCXN0cnVjdCBkd2MzX2h3cGFyYW1zCWh3cGFyYW1zOw0KPj4gIAlzdHJ1Y3Qg
ZGVudHJ5CQkqcm9vdDsNCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5j
IGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPj4gaW5kZXggMjVmNjU0Yjc5ZTQ4Li44YTM4
ZWUxMGMwMGIgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+PiAr
KysgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+PiBAQCAtMjAyNSw3ICsyMDI1LDcgQEAg
c3RhdGljIHZvaWQgZHdjM19zdG9wX2FjdGl2ZV90cmFuc2ZlcnMoc3RydWN0IGR3YzMgKmR3YykN
Cj4+ICB7DQo+PiAgCXUzMiBlcG51bTsNCj4+ICANCj4+IC0JZm9yIChlcG51bSA9IDI7IGVwbnVt
IDwgZHdjLT5udW1fZXBzOyBlcG51bSsrKSB7DQo+PiArCWZvciAoZXBudW0gPSAyOyBlcG51bSA8
IERXQzNfRU5EUE9JTlRTX05VTTsgZXBudW0rKykgew0KPj4gIAkJc3RydWN0IGR3YzNfZXAgKmRl
cDsNCj4+ICANCj4+ICAJCWRlcCA9IGR3Yy0+ZXBzW2VwbnVtXTsNCj4+IEBAIC0yNjI4LDE2ICsy
NjI4LDIxIEBAIHN0YXRpYyBpbnQgZHdjM19nYWRnZXRfaW5pdF9lbmRwb2ludChzdHJ1Y3QgZHdj
MyAqZHdjLCB1OCBlcG51bSkNCj4+ICAJcmV0dXJuIDA7DQo+PiAgfQ0KPj4gIA0KPj4gLXN0YXRp
YyBpbnQgZHdjM19nYWRnZXRfaW5pdF9lbmRwb2ludHMoc3RydWN0IGR3YzMgKmR3YywgdTggdG90
YWwpDQo+PiArc3RhdGljIGludCBkd2MzX2dhZGdldF9pbml0X2VuZHBvaW50cyhzdHJ1Y3QgZHdj
MyAqZHdjKQ0KPj4gIHsNCj4+IC0JdTgJCQkJZXBudW07DQo+PiArCXU4CQkJCWk7DQo+PiArCWlu
dAkJCQlyZXQ7DQo+PiAgDQo+PiAgCUlOSVRfTElTVF9IRUFEKCZkd2MtPmdhZGdldC0+ZXBfbGlz
dCk7DQo+PiAgDQo+PiAtCWZvciAoZXBudW0gPSAwOyBlcG51bSA8IHRvdGFsOyBlcG51bSsrKSB7
DQo+PiAtCQlpbnQJCQlyZXQ7DQo+PiArCWZvciAoaSA9IDA7IGkgPCBkd2MtPm51bV9pbl9lcHM7
IGkrKykgew0KPj4gKwkJcmV0ID0gZHdjM19nYWRnZXRfaW5pdF9lbmRwb2ludChkd2MsIGkgKiAy
ICsgMSk7DQo+PiArCQlpZiAocmV0KQ0KPj4gKwkJCXJldHVybiByZXQ7DQo+PiArCX0NCj4+ICAN
Cj4+IC0JCXJldCA9IGR3YzNfZ2FkZ2V0X2luaXRfZW5kcG9pbnQoZHdjLCBlcG51bSk7DQo+PiAr
CWZvciAoaSA9IDA7IGkgPCBkd2MtPm51bV9lcHMgLSBkd2MtPm51bV9pbl9lcHM7IGkrKykgew0K
Pj4gKwkJcmV0ID0gZHdjM19nYWRnZXRfaW5pdF9lbmRwb2ludChkd2MsIGkgKiAyKTsNCj4+ICAJ
CWlmIChyZXQpDQo+PiAgCQkJcmV0dXJuIHJldDsNCj4+ICAJfQ0KPj4gQEAgLTM4NjMsNyArMzg2
OCw3IEBAIGludCBkd2MzX2dhZGdldF9pbml0KHN0cnVjdCBkd2MzICpkd2MpDQo+PiAgCSAqIHN1
cmUgd2UncmUgc3RhcnRpbmcgZnJvbSBhIHdlbGwga25vd24gbG9jYXRpb24uDQo+PiAgCSAqLw0K
Pj4gIA0KPj4gLQlyZXQgPSBkd2MzX2dhZGdldF9pbml0X2VuZHBvaW50cyhkd2MsIGR3Yy0+bnVt
X2Vwcyk7DQo+PiArCXJldCA9IGR3YzNfZ2FkZ2V0X2luaXRfZW5kcG9pbnRzKGR3Yyk7DQo+PiAg
CWlmIChyZXQpDQo+PiAgCQlnb3RvIGVycjQ7DQo+IGhlaCwgbG9va2luZyBhdCBvcmlnaW5hbCBj
b21taXQsIHdlIHVzZWQgdG8gaGF2ZSBudW1faW5fZXBzIGFuZA0KPiBudW1fb3V0X2Vwcy4gSW4g
ZmFjdCwgdGhpcyBjb21taXQgd2lsbCByZWludHJvZHVjZSBhbm90aGVyIHByb2JsZW0gdGhhdA0K
PiBCcnlhbiB0cmllZCB0byBzb2x2ZS4gbnVtX2VwcyAtIG51bV9pbl9lcHMgaXMgbm90IG5lY2Vz
c2FyaWx5DQo+IG51bV9vdXRfZXBzLg0KPg0KDQpGcm9tIG15IHVuZGVyc3RhbmRpbmcsIHRoYXQn
cyBub3Qgd2hhdCBCcnlhbidzIHNheWluZy4gSGVyZSdzIHRoZQ0Kc25pcHBldCBvZiB0aGUgY29t
bWl0IG1lc3NhZ2U6DQoNCiINCsKgwqDCoCBJdCdzIHBvc3NpYmxlIHRvIGNvbmZpZ3VyZSBSVEwg
c3VjaCB0aGF0IERXQ19VU0IzX05VTV9FUFMgaXMgZXF1YWwgdG8NCsKgwqDCoCBEV0NfVVNCM19O
VU1fSU5fRVBTLg0KDQrCoMKgwqAgZHdjMy1jb3JlIGNhbGN1bGF0ZXMgdGhlIG51bWJlciBvZiBP
VVQgZW5kcG9pbnRzIGFzIERXQ19VU0IzX05VTSBtaW51cw0KwqDCoMKgIERXQ19VU0IzX05VTV9J
Tl9FUFMuIElmIFJUTCBoYXMgYmVlbiBjb25maWd1cmVkIHdpdGggRFdDX1VTQjNfTlVNX0lOX0VQ
Uw0KwqDCoMKgIGVxdWFsIHRvIERXQ19VU0IzX05VTSB0aGVuIGR3YzMtY29yZSB3aWxsIGNhbGN1
bGF0ZSB0aGUgbnVtYmVyIG9mIE9VVA0KwqDCoMKgIGVuZHBvaW50cyBhcyB6ZXJvLg0KDQrCoMKg
wqAgRm9yIGV4YW1wbGUgYSBmcm9tIGR3YzNfY29yZV9udW1fZXBzKCkgc2hvd3M6DQrCoMKgwqAg
W8KgwqDCoCAxLjU2NTAwMF3CoCAvdXNiMEBmMDFkMDAwMDogZm91bmQgOCBJTiBhbmQgMCBPVVQg
ZW5kcG9pbnRzDQoiDQoNCkhlIGp1c3Qgc3RhdGVkIHRoYXQgeW91IGNhbiBjb25maWd1cmUgdG8g
aGF2ZSBudW1fZXBzIGVxdWFscyB0bw0KbnVtX2luX2Vwcy4gQmFzaWNhbGx5IGl0IG1lYW5zIHRo
ZXJlJ3Mgbm8gT1VUIHBoeXNpY2FsIGVuZHBvaW50LiBOb3QNCnN1cmUgd2h5IHlvdSB3b3VsZCBl
dmVyIHdhbnQgdG8gZG8gdGhhdCBiZWNhdXNlIHRoYXQgd2lsbCBwcmV2ZW50IGFueQ0KZGV2aWNl
IGZyb20gd29ya2luZy4gVGhlIHJlYXNvbiB3ZSBoYXZlIERXQ19VU0IzeF9OVU1fSU5fRVBTIGFu
ZA0KRFdDX1VTQjN4X05VTV9FUFMgZXhwb3NlZCBpbiB0aGUgZ2xvYmFsIEhXIHBhcmFtIHNvIHRo
YXQgdGhlIGRyaXZlciBrbm93DQpob3cgbWFueSBlbmRwb2ludHMgYXJlIGF2YWlsYWJsZSBmb3Ig
ZWFjaCBkaXJlY3Rpb24uIElmIGZvciBzb21lIHJlYXNvbg0KdGhpcyBtZWNoYW5pc20gZmFpbHMs
IHRoZXJlJ3Mgc29tZXRoaW5nIGZ1bmRhbWVudGFsbHkgd3JvbmcgaW4gdGhlIEhXDQpjb25maWd1
cmF0aW9uLiBXZSBoYXZlIG5vdCBzZWVuIHRoaXMgcHJvYmxlbSwgYW5kIEkgZG9uJ3QgdGhpbmsg
QnJ5YW4NCmRpZCBmcm9tIGhpcyBjb21taXQgc3RhdGVtZW50IGVpdGhlci4NCg0KPiBIb3cgaGF2
ZSB5b3UgdmVyaWZpZWQgdGhpcyBwYXRjaD8gRGlkIHlvdSByZWFkIEJyeWFuJ3MgY29tbWl0IGxv
Zz8gVGhpcw0KPiBpcyBsaWtlbHkgdG8gcmVpbnRyb2R1Y2UgdGhlIHByb2JsZW0gcmFpc2VkIGJ5
IEJyeWFuLg0KPg0KDQpXZSB2ZXJpZmllZCB3aXRoIG91ciBGUEdBIEhBUFMgd2l0aCB2YXJpb3Vz
IG51bWJlciBvZiBlbmRwb2ludHMuIE5vDQppc3N1ZSBpcyBzZWVuLg0KDQpCUiwNClRoaW5oDQoN
Cg0K
