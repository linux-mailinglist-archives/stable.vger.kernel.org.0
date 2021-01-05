Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E672EABF0
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 14:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbhAENaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 08:30:16 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:54546 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbhAENaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 08:30:16 -0500
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4D4E6C00B8;
        Tue,  5 Jan 2021 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609853355; bh=PaGrbMaDU2lAocRIiZMsyFMMW7C/Xgu+5dXrTRiHEUg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=g0gRX5rMd61kGbUyqGOfS8EfqLUXJSThSsSpcRH2PhVB1ykyTnwW/P0hh30d+pmbN
         OBPhIXz9p0fl+PS0buXBO14MY+QSIG4BUcLRpTgY1dGgVCx2L10tVcPLRS3PWkTM/Y
         R3pZHj92NQrkTzuKfeBq1VOF0zeNFSjcOCgh+KwmZepOXP5AhIg0dubcYPjWTe7t+Z
         9KI6gLpcJdXP3EVJa4DTLFGgaeWLffg5aNUH8I8MObLnMhKXDfAnU/ymffXro/aCpM
         vSVU/mqFRRaVSAtR3qMzwq1ncP+D24vRUImUzckbKmeTQ331cOi0DscMX+n68ol7jD
         QB2xcSkJOjpaw==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id EB1A1A009D;
        Tue,  5 Jan 2021 13:29:14 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id EBFB7400BA;
        Tue,  5 Jan 2021 13:29:13 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="RUZjeXiH";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFuiSMjbjIb2P2tAZhJfmaPaSMt9m8YlHmiW7DFG8QzKGsRPiZBJGR2RYUAj2ajf3d0RalQB/XhxtMtRxcDsGYfZ7qBjL0MpPZq88/4zFKBx2PLwfJcAE3Mrd07h6Dt3Eho4mnUDaTXw++b0sMFe8a0M54rfF97Rfr0jLWcTh1oddYlbJQz8n+Q1xJ+VAWzoIstIlE8ABHfIO49W0hEWkdQt6rjdN+K192X/GOVWwe6Mz6yk+vBCxHMCCl2e0PDBIuacNUDnfPVt881qXTKQjMf147jtsjLXDf0cMg6iXSIX3+0Nnv7TAdQ5vR97Ms1yZPLfsZMQVzDa2OzvztB0sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaGrbMaDU2lAocRIiZMsyFMMW7C/Xgu+5dXrTRiHEUg=;
 b=hM2pGGCrbXurmxO0TNoQwcYFITafrE5WRLpnOHj8+g082H5iwYSwGMoo8UF2kTGVict/f5IGUCd6buGdFuNac1pwP0XZDx4e8dGhv5kGi+oDxldLCr2sqwMCIGlVXwBvkoDDq+ApLOSbyIra/kcFQknriImLQS2iVGW9oMOkTKUv6VjLCzrtHKd2gRSenqvtOhb4Xyrzi46rSqVeSKx2t0FcAI2XjKfkdcuHz/JTr3OodnLhZ/E6JrFRwrGHWscS+W/+O9NNIBzr9joNq+E1XGld4WsbvgrhkVAqBrn8jASvLSajWaPimnXWzXKcIKdl6/lWXdJa2lbzqjBI95VKNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaGrbMaDU2lAocRIiZMsyFMMW7C/Xgu+5dXrTRiHEUg=;
 b=RUZjeXiHddYuVJz2zX3J0ogUzvtifaRquyW4TbGgXJqARvIWpNmJbRwDv4vTVdG+5L8NqG/+WLJi5ZQPJt/tS3hyVZzImJc87Cy8a83HRJvnmQAd7Ep61iXf1h+ryHIt4ZtBPxunIK4xohqVZI9ScGWyrBobqWA6S3cFL1T+jQs=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB3747.namprd12.prod.outlook.com (2603:10b6:a03:1ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 13:29:11 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 13:29:11 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc3: gadget: Clear wait flag on dequeue
Thread-Topic: [PATCH v2] usb: dwc3: gadget: Clear wait flag on dequeue
Thread-Index: AQHW4y33HnzKPNWuFEi/UYOoagNn1qoY/quAgAAId4A=
Date:   Tue, 5 Jan 2021 13:29:10 +0000
Message-ID: <b5ce8d29-7013-126b-cea0-353941a1909d@synopsys.com>
References: <b81cd5b5281cfbfdadb002c4bcf5c9be7c017cfd.1609828485.git.Thinh.Nguyen@synopsys.com>
 <87turvczg4.fsf@kernel.org>
In-Reply-To: <87turvczg4.fsf@kernel.org>
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
x-ms-office365-filtering-correlation-id: 2e9fbdab-d348-4db8-d069-08d8b17de300
x-ms-traffictypediagnostic: BY5PR12MB3747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB374702B0AB8600103BB2120DAAD10@BY5PR12MB3747.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K/1jPDHzYELYcOwqMjdWebDXlWNvvvaCczZbVobF1HBG0lDOd5M9vKa+lqgOgnXR4wHqF1RWVwrJEy66EO1+gh3zvY3LNgAkXKAjI2xi7qKHWzTKRXD2JtpxO6CS+4CAs2XdcnwjVbwkUp5Un9CEnLiy8GiffQ5UuT7lMHf8rLCtellyMkG+IL/A3Ebwsu/vbCp4NZDbAYehn0TvRzggbi2Scwfy2wPGgadjjDLTP4J/MYHWxGgHaoK5t6rs04TxkDp1HO7MSdeBPJ6FAkcYdjiAGeMcTUXOHxqK6eob838HzX3q3jKTPqKRmaItY6amURGScE4aJBKCW0PDhJow8ZrLyUuj6q3wow+yAIl+I++6LR8jpPQefhbCW7iai7Uyjgvt7p6dE3Z988qK5vXM5PbxBe/mfxt/Z58Ndq1Z+8hDXqC0z3kh7f4CI2awPY2KP9DUJ8yqlKSY+CBGPh+6OQKWhVgW2RCEd4ItBLxE0ks=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39860400002)(396003)(66946007)(66556008)(8676002)(66476007)(86362001)(76116006)(478600001)(66446008)(71200400001)(2906002)(8936002)(54906003)(316002)(6512007)(6486002)(64756008)(110136005)(36756003)(2616005)(5660300002)(83380400001)(186003)(4326008)(31686004)(31696002)(26005)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?c3BLVHRBeEsyVkw4cHJJZE95UXRFdFBvb0JOUVhEVzVBcVlqYWMzNzJXRm4w?=
 =?utf-8?B?WWxNeDQyWktNZ1A1Q2ZPTDNhSit5T0VnbW1EZWFFcTFqWVVIVXY3dWUrVUdk?=
 =?utf-8?B?U2xVa3JrUDJramNxRk9mZFVPRXlWRjV0M0JwcC9kcWtaUmF1VW9SZUsrOXB3?=
 =?utf-8?B?ckhDZUM3Q1FIeUdNUG5KSUVLdWRVOVlKYjFSdm50UVEzMmY1aVVnQjJncVFC?=
 =?utf-8?B?NFhvWnBFa1k4cXFWR3FBbW80a3craFRtYi9zR0NXSGJuTkh0WjA5Wko1S1ZZ?=
 =?utf-8?B?Vm9YNFhiL3hKcWxmV3BEV0JXVldjVGtmQ1g3RS9tbkxSNWRyWWJRcEZRN2RQ?=
 =?utf-8?B?Rm5CU2NiN3JGQmZWOU1hNFJGcmJaUnNqSFlKV0NVTzVhR21iNGtGc0I4TDVV?=
 =?utf-8?B?ZHFycDVvQzIwNUdDa3pqNUlmejZhL2k4cnJaeDRnL1NTNS9tRm9IUDE5d0pt?=
 =?utf-8?B?YmJyNUEyU3RyVWR5QmJpYVFVMFhKZy96RTBjelBqMXFtRE4zQTJpM2xkdGJq?=
 =?utf-8?B?d0ZtZmdRazJHelhSSE5QOW9HaEtZb0g5bThIUUp3WWZYUTVDaitJRWtGNW50?=
 =?utf-8?B?VHYyWG1SK080cXpua1VreDRjY1FUNG1peE1jcGUzckwvZWptZTk5U0ZuSWo3?=
 =?utf-8?B?dmVCa2ZvdFNoYmt2SSs4SXRnbGZnRVBmemhnUWdPUlNMVjNDUnJCQ0ROU0pr?=
 =?utf-8?B?dnNVSU55dDlHNTllV0pCa1kwdVlNQU4ybEV1Q09FL2hGVWRPWHVxZ1dVNytX?=
 =?utf-8?B?SCtNa0hBK2kvdm93dWlna2hUQ3h6V2dQREV6VU83L0lxMmRoM05PZnkzU3VQ?=
 =?utf-8?B?ckRMMGFsZFNLaWYwbmY2NnlWMVlzNEp2OVlUc0xCZUpna3c2SEFFckZzWWdi?=
 =?utf-8?B?STdPZHZDOXB5RHFUQjZDS014TnRIcThxSHlieTYzUWIzdzk2TzhFUko4RERa?=
 =?utf-8?B?REJ1bUtKWG5DTnJ4YXJRVHV1RU5JeUt1R0RucHQ3YzIwTVljbmQ2cmhqL0hX?=
 =?utf-8?B?VWF5ZmVEaW13a0d3UXNjQzBvanpaMVRnTWJmQndNTWNURFVHNTFjMjRUM1lP?=
 =?utf-8?B?L0FLNDZhSnRJMHNvbW5Xb2laVHcydFd4Wk5RMU16UTNuT1JOZndYQzkrdmZI?=
 =?utf-8?B?MUFOTXpmWm5qeWtZM0RMc28vMndKN1U0WVlPaDZyVUhaSUFUb0QrdjlJQmRa?=
 =?utf-8?B?VlNJQkhlbDBqOUYwcUZ1OEdlNmFwT0FZTFVqZGUrMlRWSmFFSU9rMWxMOVNP?=
 =?utf-8?B?dXo0VmRJT2tVSUMzWFV2RG5IaklXUVZZa1JWZmNtL3B1a0wyalVnRmMzazRL?=
 =?utf-8?Q?1LrnNGgjjYVP0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7633A92C7E4FE245AE0D2E875D629BD6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9fbdab-d348-4db8-d069-08d8b17de300
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 13:29:10.8825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Tx7SgIhr92INl+AZtvCK3t/iSibwA8uwsOJpbABJhE20yToGKdGGvgM88NMc/XeLt4rl3dSFalXyVmFEhwt/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3747
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpGZWxpcGUgQmFsYmkgd3JvdGU6DQo+IEhpLA0KPg0KPiBUaGluaCBOZ3V5
ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+IHdyaXRlczoNCj4+IElmIGFuIGFjdGl2ZSB0
cmFuc2ZlciBpcyBkZXF1ZXVlZCwgdGhlbiB0aGUgZW5kcG9pbnQgaXMgZnJlZWQgdG8gc3RhcnQg
YQ0KPj4gbmV3IHRyYW5zZmVyLiBNYWtlIHN1cmUgdG8gY2xlYXIgdGhlIGVuZHBvaW50J3MgdHJh
bnNmZXIgd2FpdCBmbGFnIGZvcg0KPj4gdGhpcyBjYXNlLg0KPj4NCj4+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+PiBGaXhlczogZTBkMTk1NjNlYjZjICgidXNiOiBkd2MzOiBnYWRnZXQ6
IFdhaXQgZm9yIHRyYW5zZmVyIGNvbXBsZXRpb24iKQ0KPj4gU2lnbmVkLW9mZi1ieTogVGhpbmgg
Tmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPg0KPj4gLS0tDQo+PiAgQ2hhbmdlcyBp
biB2MjoNCj4+ICAtIE9ubHkgY2xlYXIgdGhlIHdhaXQgZmxhZyBpZiB0aGUgc2VsZWN0ZWQgcmVx
dWVzdCBpcyBvZiBhbiBhY3RpdmUgdHJhbnNmZXIuDQo+PiAgICBPdGhlcndpc2UsIGFueSBkZXF1
ZXVlIHdpbGwgY2hhbmdlIHRoZSBlbmRwb2ludCdzIHN0YXRlIGV2ZW4gaWYgaXQncyBmb3INCj4+
ICAgIHNvbWUgcmFuZG9tIHJlcXVlc3QuDQo+Pg0KPj4gIGRyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0
LmMgfCAyICsrDQo+PiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91c2IvZHdjMy9n
YWRnZXQuYw0KPj4gaW5kZXggNzhjYjRkYjhhNmU0Li45YTAwZGNhY2EwMTAgMTAwNjQ0DQo+PiAt
LS0gYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+PiArKysgYi9kcml2ZXJzL3VzYi9kd2Mz
L2dhZGdldC5jDQo+PiBAQCAtMTc2Myw2ICsxNzYzLDggQEAgc3RhdGljIGludCBkd2MzX2dhZGdl
dF9lcF9kZXF1ZXVlKHN0cnVjdCB1c2JfZXAgKmVwLA0KPj4gIAkJCWxpc3RfZm9yX2VhY2hfZW50
cnlfc2FmZShyLCB0LCAmZGVwLT5zdGFydGVkX2xpc3QsIGxpc3QpDQo+PiAgCQkJCWR3YzNfZ2Fk
Z2V0X21vdmVfY2FuY2VsbGVkX3JlcXVlc3Qocik7DQo+PiAgDQo+PiArCQkJZGVwLT5mbGFncyAm
PSB+RFdDM19FUF9XQUlUX1RSQU5TRkVSX0NPTVBMRVRFOw0KPiBJJ20gbm90IHN1cmUgdGhpcyBp
cyBjb3JyZWN0LiBUaGlzIGNvdWxkIGNyZWF0ZSBhIHJhY2UgY29uZGl0aW9uIGJldHdlZW4NCj4g
Y2xlYXJpbmcgdGhpcyBiaXQgYW5kIGdldHRpbmcgdGhlIHRyYW5zZmVyIGNvbXBsZXRlIGludGVy
cnVwdC4gSXQgYWxzbw0KPiBzZWVtcyB0byBicmVhayB0aGUgYXNzdW1wdGlvbnMgbWFkZSBieQ0K
PiBkd2MzX2dhZGdldF9lbmRwb2ludF90cmJzX2NvbXBsZXRlKCkgKGFjdHVhbGx5IGl0cyB1c2Vy
cyksIHNwZWNpYWxseQ0KPiByZWdhcmRpbmcgSVNPQyBlbmRwb2ludHMuDQo+DQo+IEhhdmUgeW91
IHZlcmlmaWVkIGFsbCB0cmFuc2ZlciB0eXBlcyB3aXRoIHRoaXMgY29tbWl0Pw0KPg0KDQpJdCBz
aG91bGRuJ3QgcmFjZS4gSXQncyBwcm90ZWN0ZWQgYnkgdGhlIHNwaW5sb2NrIGlycSBhbmQgaXQg
ZG9lc24ndA0KbWF0dGVyIHdoZXRoZXIgZHdjM19nYWRnZXRfZW5kcG9pbnRfdHJic19jb21wbGV0
ZSgpIG9yIHRoaXMgZGVxdWV1ZQ0KZnVuY3Rpb24gY2xlYXJzIGl0IGZpcnN0LiBUaGUgZmxhZyBE
V0MzX0VQX1dBSVRfVFJBTlNGRVJfQ09NUExFVEUgaXMNCm9ubHkgYXBwbGljYWJsZSB0byBzdHJl
YW0gdHJhbnNmZXIgYXMgdGhlIGRyaXZlciBuZWVkcyB0byB3YWl0IGZvciAxDQpzdHJlYW0gdG8g
ZmluaXNoIGJlZm9yZSBzdGFydGluZyBhbm90aGVyLg0KDQpUaGlzIGlzIHZlcmlmaWVkIHdpdGgg
b3VyIHRlc3QgZW52aXJvbm1lbnQgKHdoaWNoIGluY2x1ZGVzIFVBU1AgQ1YgYW5kDQpvdGhlcnMp
Lg0KDQpCUiwNClRoaW5oDQoNCg==
