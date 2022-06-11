Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB8E547324
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 11:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiFKJXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 05:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiFKJXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 05:23:10 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120079.outbound.protection.outlook.com [40.107.12.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC7147562;
        Sat, 11 Jun 2022 02:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gy2r8VojsVA6xPk9zsPkeH5kArS3hwWgFoN8qaxmWqp9WeQI7lNvIFyGRNObNlNCq6R6pjkvL/d7mdjpUcHgsSlyEVNNSVuuUlQyGrSWXiruDG37HZ/h40d2Eexk4oyvzybB04EdfXJBnSplZLm6BSwSzhRRuUCyzQ6S8A3MJrOO6EsKlV5qLKbFsccByPnyENVbUx8FE/61pOLe/5bATHYni/gEIcPQqSRPF+8mnJMBmO6kKt2mSgqUMg7DwdsrlvxTnnJtsN98MKrSjCv9n5pa0t1oRNE6xplQHlpnKtKKBYm0VuV/Y+uyL3SdaElqMya6z/Wn1jBd1N6RXHgtLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9BQLfVs5viSnv/WrjReVG6P1g5Fsp2kVtyOqgioAf4=;
 b=oUuRUbFhPcVYuCipCs8WrY2mZpIJPywHrpo1lkMdlHI/dta5pl6Sa42AusyeaSvubDzH6Q4uAABioHyr8szIuePmCb3e+Kxtsc/+Ta0SzMOqqboKep37OzrMV4RPgrdmIbg2QL8qTXIlT6+D9fNmfr5CYHkVZhtiDUc6vlTkJLp2k9FC9+y8Ib8K/eleT2I3HhL1whkzJKBfa1HO0xKfFZsjhzGIZOACVAvSTTo4l4Ct2NvIkdMgu7Pczxyc6GCgFHVBtvzyURjg6uIUz96iTF6WFuirR+o5dd5ncTwVVY+T3AnnqmbBd+6DnDx+q4PjCqVe84GvbA9oCvYWZuwTQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9BQLfVs5viSnv/WrjReVG6P1g5Fsp2kVtyOqgioAf4=;
 b=io6CrRjlMFH2dJZRMPgJ6cV1hYm/OGCsIKUQv9gMigNh14PcGH3FF0Q8OT+dNDjkMXFN59+Bk7ttNQweotU07d3hO2IAsyvfEuufc+OSxz0AivFYnqcG9sykOi3Svc6P0cisR8YEbUFf+1f6XZJSxe9dKF2tTXhe8bNOKtKvV8jlD7ytwNTOLVRxTNFxD0126HBessJce8Uys3pywk7SwNdrt9b7C7YoOUG/ir7eV9I7RB0UzTHbO62+oCO98s5/Vncub1ZvA76/9qsxJ2RRGj8akGNQjjfnrNUIjB/BRpdt41/rKkwb49sq2v/Yu8VmeDSEqlgt7lfTczwoNEC3Sw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB1933.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Sat, 11 Jun
 2022 09:23:06 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 09:23:06 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/rng: wire up during setup_arch
Thread-Topic: [PATCH] powerpc/rng: wire up during setup_arch
Thread-Index: AQHYfWruAqTviXc9VEaH1Xwgmqs2/K1J7QEAgAABA4CAAADegA==
Date:   Sat, 11 Jun 2022 09:23:06 +0000
Message-ID: <05dc2709-aeeb-bdfd-7170-e7e686947208@csgroup.eu>
References: <20220611081114.449165-1-Jason@zx2c4.com>
 <956d2faa-4dae-fc75-2c03-387c77806f2b@csgroup.eu>
 <YqReQbGQ3G5JxSgP@zx2c4.com>
In-Reply-To: <YqReQbGQ3G5JxSgP@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1627d09-d7d4-4044-fa34-08da4b8bfe65
x-ms-traffictypediagnostic: PR1P264MB1933:EE_
x-microsoft-antispam-prvs: <PR1P264MB19331663C79A8069DE8163B3EDA99@PR1P264MB1933.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dZNVR3jn65mNE+qVFnnZFCgWbvMtDej56WiI4V/g+NVjmbWLQuMS+k26pFftlor5xeWcVheL2RHpuyNVCoJ+vtFkb+xqpaad3Z9LKdMpQnw2sUEUBKbtO/GV1eZO86Z/duFe1+Q2GwcXME/XVV9FSZzyR3oYFZsgtLVLfnMqejlutFvD+WcY3nFjsnu/UgN/LZP5hBBiJMbpYiacHUlRv/srAPaQ+5EadSPvMAOSuaGdSYlll5thg9E079QetO9630TQ/dP8+yOO1ZC1g8qSsnX39MY8OGVbu8bpV0QphsiTiaxOK8IEcnCSTYgBeZWEd61+S9iqt4UHzo874Esv/aGxYow+9trOHvAzCAV4vVa5+aG1iaBkVa07VedGC2Pd/+OnCzKHxMbR9XKr+M+pV2EezJiDBvsxNFwFGohNMuH4KQnI1HA++98SpGAOXya04XmekHagWz/J7jXeRG4HvItaGc7gYW2kazQjhfjwZU0v6/isjwOIGFcE4LAe0erBoIcXx89zXymKUv47xPM9dIv27GHcQBJBmzDmPESW5xcWZI366Zg1IpWZ19f1qCsoaajaT0zhWcrkXZmEtjU3YegujNGEcraPgwuzAoTkxW4itmUF5Cosz5rlAnpgaA+ELlQ6LwGDzGBCm7X7jo6UwJTNcUDfHyM2eBM+VwNeX7oLPErvRFKAb7l1u33prc13AOAorTiyfqm1GGJfFCIW67vXiOaBHRoCMYvnbkyEcwU3KMfjD4cSskfkJkEye2dsRVzKkD4fl65rV+TWcSwFQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(31686004)(6506007)(6916009)(36756003)(44832011)(186003)(83380400001)(66574015)(6512007)(8936002)(26005)(2616005)(66946007)(2906002)(4326008)(5660300002)(508600001)(66446008)(64756008)(66556008)(66476007)(6486002)(76116006)(316002)(38100700002)(31696002)(86362001)(8676002)(38070700005)(91956017)(71200400001)(122000001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmdTQmNUcVVPcXJ1Z1FJL04zN1BKcVRwb2lMZ2tMK1BLVk1MblQwTlB0SkY0?=
 =?utf-8?B?U01oeU50bGF1dW0zN04wZG9LOFRKZi9ncVVRZmErTCsvQ3NmUURUVmgrZDJm?=
 =?utf-8?B?RmRlZUZOMkRMV0lteDVhbWo5dE9uWms0NTV6MXJ6VE04VjZkUkdrQ2FWZ2VF?=
 =?utf-8?B?azFsVUZUazFLWGxMWUhYRnlpQVlpdjVSRzRRcHNMdmJSaEV5VDAwT1Z3WThR?=
 =?utf-8?B?amtGWXlvUkFFckxUOWp5M0N3aUJGSytueHRCMWFGUklsdDFSdmUveUVUUHRR?=
 =?utf-8?B?YWlrbHdpODlEWDVJV0RlM0RocW93bmpMN3VwQi9MTk5QOXFFcGVMdHI5Uzlo?=
 =?utf-8?B?d3BFdDlRd0M0M0pLRUhoUzliZWxmZi9ZdWVKSUFpcnhQUXFoc25CbHIzNnRi?=
 =?utf-8?B?czZobjhjK1pqRHNNS2NoNXF3SG5XVGNlWWtlRnZBeHVTV0cyaU1Db1JkNFdR?=
 =?utf-8?B?NEZXM21lMHlkYWNqSi91VFVCQTEreUVxV0VZM0R1bFcwSmY0Z3JXTUxXRmlm?=
 =?utf-8?B?RmhnVkVReU5nVnZXd3hUbUwxK00zRE9Zd2M1Sy9Rd0wvZERFR211cGFZb1N5?=
 =?utf-8?B?LzQxc0Y1TEF1UHNOVytQV2lWY2RtRWNNMDlNTUw1aGNwUmkrbDFlbGJveGRs?=
 =?utf-8?B?WTl6em5EWXp4SkVBMW1XM3A1aHVnaGpDRkp6QXppZDMyNHhqTXNIeWJBQlhl?=
 =?utf-8?B?c0MwRjlibXBHWGtoR3ROanM0L1ZhUmtvaitHYTZtUkVoV3hxR1BhRExqTVFl?=
 =?utf-8?B?UEpBYnVHTStzWS9ndG1XaDJBN3p6OC84QndUZnFJWFR4WGNvRW40dUxubS9C?=
 =?utf-8?B?ZHlYT1hPOXpWdnBtL1hoSjBZajNWWHY2cnhRaUl0OElES0NnNjdVVlJQS2Jy?=
 =?utf-8?B?bjNKVmxrRHZuVERxclFockwwOFVQS29ZSlg2TFAyekltVzRFZzIwVzhUZUI0?=
 =?utf-8?B?UDJ5NDdNNmN1bCsvQlJFMmxDL0lYOEtJdTRPTkFTUWhSRGNURXFLM3ZUTGNv?=
 =?utf-8?B?YldGOUZmU2dUZ2Frc3VFUUFEckV6ZHo3TnZORERidktPMmY2K0ZHVDl2TCtZ?=
 =?utf-8?B?eWJNdUt3eWxtRFJJTE41b05hU2YzN1l1RUxQUGdacGgxTUx1MVdRRmdHbm94?=
 =?utf-8?B?VEhnZDdkTjlYZXNZQTJ5L0xTVDRPS0NkYm1Qa01HUmZlRmpaSXlDZDF5Tjh5?=
 =?utf-8?B?eVBid1h4TXpMVVNNUlhFMHJpUUtJZzJWYTVxRC9MNVRpWVVVYVBvWWY3R3Y4?=
 =?utf-8?B?ZUd2Wk9EL0Z3TlVCOWVnYnU3Rm55QitJVzJ0bExVWkF2THB1TXd5QkFiSkFl?=
 =?utf-8?B?UThSUE82QzljVkFaaFB1TFdKSHNCYy9sOFc2ckFtbWVnTXB3UWpxQzhvdk5q?=
 =?utf-8?B?WU05TFY5M25xVlJxRFNyaXhadkl6NjRnMW02V0o5MG5jVWpaNnN3SXJ1M1lp?=
 =?utf-8?B?K3I3V3Y0Y0FGanNFWUdGdUI1anhkMzExZ0kwbDI5azh1Z0pYQzB0Z1RIZ3du?=
 =?utf-8?B?bjk4aXBUWTJNR3cyMmJHc1Rab05XSGRJL1AvOTEvRCtXSGprN0pOMXQzaTlR?=
 =?utf-8?B?VDdKSlRxWVp6Y1R1ZFZvWXlIVkNkNVV4bXQyZGk2bWx6L3RXYyswT3pYQzZT?=
 =?utf-8?B?WkJ3Y2JHZjlTWVM4QjJCU3Y4MWNyMWNBQWdENkhNQW1NNXVHRC8wcGlOd1NP?=
 =?utf-8?B?YmV4K2liTnB0N1lkSFFvRWZ0WXE4djBjejNZVVF3dHdDd2tqSHZPbHZpcW9n?=
 =?utf-8?B?aUthclBMeVpvMmtZcmJheFg0SGFPMEhlcXVSVHhxRVVXbHVQUzhyWFh4UE1a?=
 =?utf-8?B?NzlicU13Mjg5RmcvRCtQamsrbXlxRW1HUEdKZ3FCMDl6UDNaTW1WOVUyZE02?=
 =?utf-8?B?RDRKUTNYMlBpekloVzNnVTkzOWFjT0pHZHpxVnhKNlprMHhQckpUb2JwaWwv?=
 =?utf-8?B?OEJLdFJNTVNLSmVZVkdFZEJCTVVYenRZWlVyS3BsdlRrc2N3bDBDVUdjT1Zp?=
 =?utf-8?B?VWlTalo2bjFjd2dnV0hYMFNTNlBXd2p2RlIyQkNOOVY5dmhoeS9Oc0Z2OGtu?=
 =?utf-8?B?bW8wUTJKUjUyV25UZWVPbnNkTm51OFpPK2Q1VXZqUUtWeGpQZGcxQ29CdUxC?=
 =?utf-8?B?TS9aQTgzL1BlM2tCL3VOelVYS2JaQ3lxYmVTUFV1UHpKWi9FT2NUNUJxcEFJ?=
 =?utf-8?B?RFl0WGxxVHhEYVdGdUJMdG9ZNXZ6VmlldXdFaVdBNUQwekZhOEo2VWRWZTgz?=
 =?utf-8?B?dThtelM3ZVhtdkFlTFR2ckxyQlpPTGgvM0htWksvMGgrR0dkSGd3SzFVekpp?=
 =?utf-8?B?NGVxMWtVRHhieGFLaVZXN3RURUtLemtFQVdpWURtdGdRbzdvVEpPd3NmVHl4?=
 =?utf-8?Q?Qb7h99guWZ/Rjg0MsABQoEqnHpSAzeOagm9k3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26E7CD5DC3B26F439F3B42183B96C34C@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d1627d09-d7d4-4044-fa34-08da4b8bfe65
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 09:23:06.6667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xUofjj9Rdlr7MnqjyFeb+av38zFM7eshRXRYSgBua6ADjIRvujzy5RFEvxNtb600DxaMxcHmFaroNK8+hcT3bsi72V4imkNUmN0T7xViGFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB1933
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTE6MjAsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBIaSBDaHJpc3RvcGhlLA0KPiANCj4gT24gU2F0LCBKdW4gMTEsIDIwMjIgYXQgMDk6MTY6
MjRBTSArMDAwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+IExlIDExLzA2LzIwMjIgw6Ag
MTA6MTEsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKgOg0KPj4+IFRoZSBwbGF0Zm9ybSdz
IFJORyBtdXN0IGJlIGF2YWlsYWJsZSBiZWZvcmUgcmFuZG9tX2luaXQoKSBpbiBvcmRlciB0byBi
ZQ0KPj4+IHVzZWZ1bCBmb3IgaW5pdGlhbCBzZWVkaW5nLCB3aGljaCBpbiB0dXJuIG1lYW5zIHRo
YXQgaXQgbmVlZHMgdG8gYmUNCj4+PiBjYWxsZWQgZnJvbSBzZXR1cF9hcmNoKCksIHJhdGhlciB0
aGFuIGZyb20gYW4gaW5pdCBjYWxsLiBGb3J0dW5hdGVseSwNCj4+PiBlYWNoIHBsYXRmb3JtIGFs
cmVhZHkgaGFzIGEgc2V0dXBfYXJjaCBmdW5jdGlvbiBwb2ludGVyLCB3aGljaCBtZWFucw0KPj4+
IGl0J3MgZWFzeSB0byB3aXJlIHRoaXMgdXAgZm9yIGVhY2ggb2YgdGhlIHRocmVlIHBsYXRmb3Jt
cyB0aGF0IGhhdmUgYW4NCj4+PiBSTkcuIFRoaXMgY29tbWl0IGFsc28gcmVtb3ZlcyBzb21lIG5v
aXN5IGxvZyBtZXNzYWdlcyB0aGF0IGRvbid0IGFkZA0KPj4+IG11Y2guDQo+Pg0KPj4gQ2FuJ3Qg
d2UgdXNlIG9uZSBvZiB0aGUgbWFjaGluZSBpbml0Y2FsbHMgZm9yIHRoYXQgPw0KPj4gTGlrZSBt
YWNoaW5lX2Vhcmx5X2luaXRjYWxsKCkgb3IgbWFjaGluZV9hcmNoX2luaXRjYWxsKCkgPw0KPiAN
Cj4gTm8sIHVuZm9ydHVuYXRlbHkuIEkgdHJpZWQgdGhpcywgYW5kIGl0J3Mgc3RpbGwgdG9vIGxh
dGUuIFRoaXMgbXVzdCBiZQ0KPiBkb25lIGluIHNldHVwX2FyY2goKS4NCg0KT2sNCg0KPiANCj4+
IFRvZGF5IGl0IGlzIHVzaW5nICBtYWNoaW5lX3N1YnN5c19pbml0Y2FsbCgpIGFuZCB5b3UgZGlk
bid0IHJlbW92ZSBpdC4NCj4+IEl0IG1lYW5zIHJuZ19pbml0KCkgd2lsbCBiZSBjYWxsZWQgdHdp
Y2UuIElzIHRoYXQgb2sgPw0KPiANCj4gSSBkaWQgcmVtb3ZlIHRoZSBjYWxscyB0byBtYWNoaW5l
X3N1YnN5c19pbml0Y2FsbCgpLiBJIGp1c3QgZG91YmxlDQo+IGNoZWNrZWQ6DQo+IA0KPiB6eDJj
NEB0aGlua3BhZCB+L1Byb2plY3RzL3JhbmRvbS1saW51eC9hcmNoL3Bvd2VycGMgJCByZyBtYWNo
aW5lX3N1YnN5c19pbml0Y2FsbCBwbGF0Zm9ybXMvKi9ybmcuYw0KPiB6eDJjNEB0aGlua3BhZCB+
L1Byb2plY3RzL3JhbmRvbS1saW51eC9hcmNoL3Bvd2VycGMgJA0KDQpPb3BzLCBJIG92ZXJsb29r
ZWQgaXQsIHNvcnJ5Lg0KDQpDaHJpc3RvcGhl
