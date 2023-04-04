Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7828A6D68F1
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 18:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjDDQc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 12:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjDDQc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 12:32:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2744811D
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 09:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CweRpoE1h+jQIqwGBW7HBfWvyVYf1JReMcEht2eV761lJMGs+/c5XxIO+eGfm/qju8tTa+2J56K06Z9qUl8ufi1Wkzi0ESCj4uPAGM484a8cqpVg9765rLXZelHYZr822MtSJD1mIwjsAyc4FUVwcGFklnixsvCxJ+SqybunFWJ36iRAVIX0tJLq5LLHWCTa0Kr5Kd+SCY1Ibxh+vWXMzhbKDqSkB5Y5mn4gQByP9zVCXaD9micEV2WYV7EUGckNRivlE8CN5PAHuCuHp4J7phBI4A10aEafkvrBocqXL06BtwgdVTHOZ+YqeLIMlYnAPxd150QQ02WL5elpdyT5lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgGPUtY6ePnAnj6w7vmEEEs1Ix/UCPuQyz2kp89r0tQ=;
 b=UhyftCN70PtCZebG3a8KULVOOLwYog3HpB75D0lYJi3mo11UYNpB/ho2/VJ+kMoUF34v6HE2MFiab+xNMDeMcfZi+Zc3LKcrUPyT5GjiAvI5s8XjpaJfhG47Kq2vvnv+jE3XE0WGw4uiqEdarfbHlMWibbG0v4DPayqf3sRUQBAcJprTtQgoMvTQYM+BWH1zVpi794+FfTYJKNKvsoDVvZMfibLrHg/5PiX6QRUY/yN8bieNGYLgsbcB5fbvCUVnDh57ICBhMUnZhcJqNJbgeX+xptki0B/SNdwFPsuQ/n4WiOGhISh0JA1yDs28BdKVLmGEkTvgezzyCfyXvN+77Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgGPUtY6ePnAnj6w7vmEEEs1Ix/UCPuQyz2kp89r0tQ=;
 b=2ggBaw0vZDttDQIrwtceT9O2pkopq+YwBzz6pLkMQSbhTN3bs2b+sPYrfbDTtzasHzcXf5vkK1jdixNwt5YwhaPRNpO27AbRGrf2LeAVAC6YW+hjY/EVxoIngO8RBM9elS6XWuJ5vsvQc3bX7Wzyxyd/qFjhTJNIzYOwrBAagBY=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 16:32:52 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6254.028; Tue, 4 Apr 2023
 16:32:52 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "Mehta, Sanju" <Sanju.Mehta@amd.com>
Subject: RE: [PATCH 5.10 063/173] thunderbolt: Use const qualifier for
 `ring_interrupt_index`
Thread-Topic: [PATCH 5.10 063/173] thunderbolt: Use const qualifier for
 `ring_interrupt_index`
Thread-Index: AQHZZjgoKBahEBebHEKfHel+wXbzZa8bBOeAgAAPDgCAAEVdkA==
Date:   Tue, 4 Apr 2023 16:32:52 +0000
Message-ID: <MN0PR12MB610127A927ABC44DBDA20827E2939@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.499791738@linuxfoundation.org> <ZCwKBSQSbj3Ka4on@duo.ucw.cz>
 <20230404122302.GQ33314@black.fi.intel.com>
In-Reply-To: <20230404122302.GQ33314@black.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-04T16:32:50Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=ff9ea119-3da7-4fb9-91a9-a5a14e11578c;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-04T16:32:50Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: f946f1e8-39a2-4d06-84fe-3d706053e9e2
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|CH3PR12MB7524:EE_
x-ms-office365-filtering-correlation-id: dfc27831-5691-4295-81a0-08db352a3cba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MpOqE+cYMzAMDfKPzRNB9sHw/hW/AoSFcRBMghxlHUBTU7K7cisXfJYw1WHiYQeFTIcUG57JJff2V/XWFXZPg0QM6eJC+kNkru4r3q8sF2nic3c7Wo0E2Iws/14ndrkkP0OnlZ8+A2dzOe0xkHe3HBpfuBFAmQcIodQELOxZ+jaOhrDR5ZhHe3nEvF1dy223KeBp2QL72e2j9X1Hsifj3Rb3RSs7g/+YRM5UrjEPcArXT+m8MklFTdHXJ25T0YfEIbKTFhiWsvr9Bizkmvj8d6BgEYyGA6+2cx62t2+mTBd+VFNl6p4bV9moBXqiGL6NlLs/nRDjpjeFAbOQ7lDC5xiN5hGIdkjL74yq36fMJ1CjQEyHUgDHb3PEQnv6sTcmGClOS9BgFlkqq/F+JATCPmI6HGz5Xgsx0t4sQ2gHerhWptN2rXroUqxrn7AVBcWnxUfn/5I4gwGJyopGn6otIGbMmQkFU0pvbFSg50lFpkriKF6jubxWJywSYm2Yhh4omn/+PfBgp457Lu1oIO9xnfJQ/iXFHi54Ru/rgnMQzhw+v/d4R9gJPmrr3faNZOLHJHylrZUcAU5tExtpXKYKcphjhU0loe5TsrUcd61kHQuY3gQdfNvaED5Lw8I7aUcjONUDCkKjCvQwsqJTVsjIBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199021)(9686003)(6506007)(26005)(186003)(52536014)(41300700001)(8936002)(5660300002)(66476007)(66446008)(76116006)(64756008)(66946007)(66556008)(2906002)(4326008)(7696005)(4744005)(110136005)(478600001)(316002)(71200400001)(54906003)(8676002)(55016003)(33656002)(38070700005)(86362001)(38100700002)(122000001)(81973001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGlmbnNxVG5OSHM2b0xMTFlRMXdOQUsrdkNVMXdKQzRGTmFqSnlzSWtTMm9P?=
 =?utf-8?B?ekRQT3F4YkhNZjFETjZaOW9PUDhsbFVPMVZjRWNyZ2xlVGEyY0p0aFBabWRG?=
 =?utf-8?B?K3lYZitnaEloS1VKWUE4QjF3ZVlnZjdFTi9NVWxVL0tydjkwQVd0VDdRcm9B?=
 =?utf-8?B?bjgzd1Nua1VXRE0xcG1vMFl1Sk9JZEpqT1NtQUlHaXhwWDJJaVlZdkdRY1l5?=
 =?utf-8?B?WUxwNks3VGNZdWlOa1E0M2wzdVdVVW8wMTB0cWtlU1pKdit4K0gwL3VCbFNk?=
 =?utf-8?B?YlNJSHphSEdOOENoRUhmSmJ6cU5MR014QVNQY0NMWnFMMkQ5QmpHL1QwVU85?=
 =?utf-8?B?M2JRTkgxMGhKUndmeU9odG5TRENZOXhNMEQxZWZDYnpXTndXTWIvb2g1NFlB?=
 =?utf-8?B?R3loeGdlakhSbi9MMzNUTWtBQmNYa2xHcnBYTTlyUWVSK2phUUZJN2sxVUhQ?=
 =?utf-8?B?aFUzVnI4UElicWh1Qnc5aGRPeDdpRnRLOU1KaitsaGNPdlhRRy9kZlFIbTNO?=
 =?utf-8?B?MU13dXpIS1FEbWMzamRMZ2FWY0RsT1pzRmNIUkdwMjVuRjM4ekRCYkdOUmpS?=
 =?utf-8?B?ZkVBK05rQWZ3aDdPbmZzL1NhZHFUb0VHWC85Z1MzVHlGbUNTTURkYmdYTzBa?=
 =?utf-8?B?YWo4ZTM0c1FaNTR4UnFzQitTZ2FLVU5DSUVFaDhrQ2pOZTdKb1hvRXU3Rk16?=
 =?utf-8?B?UW5IT1JKbVFSV0Q2bnVrRU5zWGJOVDhRb0hjTUNaNkgzbFgxNWJKWk5rNFVu?=
 =?utf-8?B?RURJdDd2Zk0wdVRUK01TRSt6djdwQ3hWMDRRdGlNZk5QN1hpNXptTXVkQWZG?=
 =?utf-8?B?RHlONHFxTmh1SkxDdGhrYit4ZG10SWRiNmh6MEJjdmZmUXV0QURybCtWN2ZK?=
 =?utf-8?B?cEN6VDRJYmEySXp1WnAraHRRS3RMUWdTMkFVbmoyTWIwMXVUSFFObjBiSDZN?=
 =?utf-8?B?R2lNMWpHeE5GYS93ZHUwc3NxdTBDQ1g0LzBlVVQwMkZ3Q1krQTFhZUhwSldw?=
 =?utf-8?B?UVZsTTZ5SFpLdkhNNjArVHZldmZsd25MTnBWVllaUUpJMzNUMThWemcwT2pL?=
 =?utf-8?B?d24zdnRSNWRScnZxbXYxMDlCQTJCVE1xSFIwcFRNUG5wRmpJdUlCREM2ZTlX?=
 =?utf-8?B?ck40NXNEWUNpVUthaVdzMEJFQmIzVklzUUgyRkwyYm1qL0laNzBaNTRSWWRP?=
 =?utf-8?B?cWV3YUtXMTkzUmlhUHQ4R0lJMFU1d3JhUVFJbXp6YVpKd011bmJuTHlTL2NO?=
 =?utf-8?B?YUorUUpQUTRNVExJUHplcDI5VG9jZGpoVzFHdTV0b2s4Vnoyckg4SVpqcFlw?=
 =?utf-8?B?dkQ5TTBGNnZSTjBVY2N5Ukw5S1BFTnRNSHN2QzZ4alhaTmxsbUFLeEI3MVBw?=
 =?utf-8?B?eWhMVDJLUDU5SjR2em5wNk03SGRNN1J5cUUrMWpYQkt2MFdhZjJrNnkrdm5R?=
 =?utf-8?B?Y2tGSkYvSXBsSHJBajJRU1I5Rno5RUFtd2FuTkJLSm5ocUt4dVVnNVdCSitO?=
 =?utf-8?B?aDArNzcwYWZZcUVFaEp0V29LWWUwOWhRdVRRM3RwdW1Wais0UmFXUTBFZTRG?=
 =?utf-8?B?RGcvcHdKVXZVNzdUS1A5MXU4MG1zNkFiMUIvbmJOSk9jRjFCeENLYy93SHJW?=
 =?utf-8?B?RGtMTkhZaGhLSnlrMmhreCsvSHpSUk5pU3Z0a0xyMXo3NGpDeFB3dlp4Y2hD?=
 =?utf-8?B?ZE1aMDdqbFlqcVlnRmFXcFNqQVYvamJyRjRYSUFqa0JnKzVNaFFZcFJtNlU4?=
 =?utf-8?B?ano3U2ZKOHBIclNmY3BNUjVpTStudDhmNWk3Znk4Y2JjRFB3cis2Vmx3QWcx?=
 =?utf-8?B?b1crSkhMbk5pckJRM1IwQUxBQ0JENTZrUzBIU2JlbTBHSEFXRzRvL0FjelIv?=
 =?utf-8?B?TVdTdHROVmx1MmFHaVBLbjJLdjJTUWpSTUxrWnhzcDBVYVREcUVSQzJGRUlv?=
 =?utf-8?B?aEFkL1lNYnQ3SURmQW5DaWlDaUtDOHplcEF3OXdrdFV5M1RFazdBbEhid242?=
 =?utf-8?B?eXUzZDg2RnlsTEdVTTBmT0liUEYrT2hNMXhicDgxVVNlcTZ1WlI3SDFWYXFq?=
 =?utf-8?B?WVZvWkhUcGVKK3c5YnVrZWU3ZHZ1Nzc4bDRkandqMlpmSzl2V3NlVm5icmIy?=
 =?utf-8?Q?JAkg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc27831-5691-4295-81a0-08db352a3cba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 16:32:52.6771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oStGBB1MP2Jq1ypsTHlxB5rk6hw9BOURPFQ1iMLVqDW/Le1bk6P84IpKKOmR2tO4bhOWyTngjSQombP9zIY1Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiBPbiBUdWUsIEFwciAwNCwgMjAyMyBhdCAwMToyOTowOVBNICswMjAwLCBQ
YXZlbCBNYWNoZWsgd3JvdGU6DQo+ID4gSGkhDQo+ID4NCj4gPiA+IEZyb206IE1hcmlvIExpbW9u
Y2llbGxvIDxtYXJpby5saW1vbmNpZWxsb0BhbWQuY29tPg0KPiA+ID4NCj4gPiA+IGNvbW1pdCAx
NzE2ZWZkYjA3OTM4YmQ2NTEwZTExMjdkMDIwMTI3OTkxMTJjNDMzIHVwc3RyZWFtLg0KPiA+ID4N
Cj4gPiA+IGByaW5nX2ludGVycnVwdF9pbmRleGAgZG9lc24ndCBjaGFuZ2UgdGhlIGRhdGEgZm9y
IGByaW5nYCBzbyBtYXJrIGl0IGFzDQo+ID4gPiBjb25zdC4gVGhpcyBpcyBuZWVkZWQgYnkgdGhl
IGZvbGxvd2luZyBwYXRjaCB0aGF0IGRpc2FibGVzIGludGVycnVwdA0KPiA+ID4gYXV0byBjbGVh
ciBmb3IgcmluZ3MuDQo+ID4NCj4gPiBZZWFoLCBuaWNlIGNsZWFudXAuIEJ1dCBkbyB3ZSByZWFs
bHkgbmVlZCBpdCBpbiAtc3RhYmxlPw0KPiANCj4gWWVzLCBpdCB3YXMgZm9sbG93ZWQgYnkgYSBm
aXggcGF0Y2ggdGhhdCBuZWVkcyB0aGlzOg0KPiANCj4gNDY4YzQ5ZjQ0NzU5ICgidGh1bmRlcmJv
bHQ6IERpc2FibGUgaW50ZXJydXB0IGF1dG8gY2xlYXIgZm9yIHJpbmdzIikNCj4gDQo+IEkgbWFy
a2VkIGJvdGggZm9yIHN0YWJsZSBidXQgcGVyaGFwcyB0aGUgbGF0dGVyIGRpZCBub3QgYXBwbHkg
Y2xlYW5seQ0KPiBmb3IgdjUuMTA/DQoNCjQ2OGM0OWY0NDc1OSB3YXMgYSBmaXggZm9yIDdhMTgw
OGY4MmEzNyB3aGljaCBsYW5kZWQgaW4gNS4xNS1yYzEuDQpUaGUgcmVsZXZhbnQgQU1EIGhhcmR3
YXJlIHcvIFVTQjQgd2Fzbid0IHN1cHBvcnRlZCBiYWNrIGluIDUuMTAuDQoNClNvIG5vIGJpZyBy
ZWFzb24gdG8gdGFrZSB0aGlzIGNvbnN0IHF1YWxpZmllciBwYXRjaCBpbiBmb3IgNS4xMCBJTU8u
DQo=
