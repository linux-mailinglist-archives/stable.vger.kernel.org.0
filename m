Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75FF650B5B
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 13:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiLSMVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 07:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiLSMVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 07:21:52 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2072.outbound.protection.outlook.com [40.107.12.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863B9DE98;
        Mon, 19 Dec 2022 04:21:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrPF3Akphba4/EqFvBSjeVZd0L8phummHVMZqJDlpEdW69whXGbpx4SgrX3k6cizM41rX2i+SZromKSdbuMOFTl9TGc5Y9I0lRnY3TxQmW4mxz80k/oQVuXdROYKCwCeeEoEzXr0HuDgc2S0sNFDodtwZ+u/XjApxdVT5CQ/QH51UOpFaenkhHt45tRH00hc162t6KJ/qPqQslOdabL3ASd9hunbRAQbyMnT03/cW1qfhz6ICPO2Djde3EJxjS8a3VRloK8CvWvcOLhd8+BWR4lORRtmug44EFOGAZr7OtLuD5kRF7PsBwQc2/yN1mpRLGkRmfaHJZ/dFbfDnuGiNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsIYFfbpKCJinTouFo9G1W0AVkjH9tKoMjD/BCEFt4g=;
 b=Htv6eLUDyu7PJI0GYjeV57fnAafDtd4bk3lG+zSru7QqWftYMbKPFLwI6AIQY3vHDyU9lEiQKJyqZyadvsyjNgkgqPtYAqa78uTr/jREv/WR8jePVm54es5XuA4u+spcDhTgCnV1YN9kzA+klg+Fz+9bIfgeMxdmQ061bcHruBbg2U9tP/mT3PcrTl/T47KEiF2P6QjXF7I26dMiyjtBPgXbA9j8B7dq8hRoggWzdvRfBXxzhYphkxttdMh4ezcUghMWX9ASYuWqcxOLCwB9YytNFYPpYJBvrVbWhP5SVYfarylVzWV8AFOtOy1QYkl3m8ZqOvoF3PFya1ZkfM8bgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsIYFfbpKCJinTouFo9G1W0AVkjH9tKoMjD/BCEFt4g=;
 b=ZKEozKVDp8CREiWPsSjcv4+K3pLjfp9ugz6VU171zc8OEbB0k3iTP9S3KNlYCJRTfNGE2gycQpuVoY9cPUXaGbtgJXzH73XE7/FkVk0v4QR7YTjXtkB/7N3PuUW6sI7tI4sIQyjHFLsG038ahXTWDgNGil6Cjgbmmeivcqd/7lWhwMvUHfAYkhg9pUVYB6sbTZwKQQYL87TzWHZ8dH5gHwwuZXeWARi5qXaJNxBWIOEdoFkszjCvqARR7E45r1E2+EOp5wZzIKgVcwLKaeU6qtH8G5+tPQ+VpC0ICzP/gFkMBmQKNGFq5gaMkz8pfF/qOMueo7Kf4YN4/5ZRXJgfCg==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3091.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 12:21:48 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8e8b:856e:12eb:ff9d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8e8b:856e:12eb:ff9d%9]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 12:21:47 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     FRANJOU Stephane <stephane.franjou@csgroup.eu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tony Jones <tonyj@suse.de>, Jiri Olsa <jolsa@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] [Backport for 4.14] perf script python: Remove explicit
 shebang from tests/attr.c
Thread-Topic: [PATCH] [Backport for 4.14] perf script python: Remove explicit
 shebang from tests/attr.c
Thread-Index: AQHZEUL5gFBiA1aBn0uXom0Tt8m04q51JVgAgAABD4A=
Date:   Mon, 19 Dec 2022 12:21:47 +0000
Message-ID: <617a746a-5f64-6d7c-48df-7c96b3aca535@csgroup.eu>
References: <3ca0515edb717e0f394f973f3cbbe2c80abb35e4.1671190496.git.christophe.leroy@csgroup.eu>
 <Y6BWeFdJiz/tIhQ6@kroah.com>
In-Reply-To: <Y6BWeFdJiz/tIhQ6@kroah.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MR1P264MB3091:EE_
x-ms-office365-filtering-correlation-id: d117ac0f-d194-4974-8964-08dae1bb99a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2iXCqKavhUNifY+FszKleE7J9VrSPE07nPvfpvIToMP5npZeFSVSjADDRag2piB2SoQ7EOYvxiT4CXQxSQ9hY0PBkwT9YmdGZsxTYE5EsK5rO7qSePNJflcWtxz8zjGXz0Pxq/ybG4fn2e1RzuOZO0YHSvSdXG527JGbOIVhPCUvMpqQT50Tqv51IUEgcom6M3gCPY5hfjaHkNe8fc/UvINEtvXbJsWIK23J58qoUcC6Nwnwf3ppNPy8JoAUTrgHoaLQ4oxa0ot6mM2Ft26cULh53DUB1nO+zGBXBIQa+pHwQqM4veVnZ6BDYqtfA+kMrDruMnk8Av4rgGWIPXri7lxDRdaHmoSDOTXBdJ2QnBpLzapR+t/YsVrEXTFL6dzIi6b1laGep6qzTzyB+5IAZ0nazNi31zOKRIZ+i+ebCuE44RtbEQbQ+mbJEe+o43SUlCHA0IxD/SCiAhtSCfL2pQYWUEhEp1Qq1K34HhgWw290mYjWPMfqVt4pqZHH8YX/SdYeuqnu+ZpwSSsS+M6lEgQgJf0cNLwzsAnIgXCZKr+JxxDI7ft0sM5INobgZYiNU6pFtqH23RQfSn2S4M2ZXftYAmvfogdEFp8DtwCidWA0RLHdjvOeRU4Of6EvO0yiCc+XAcIm89yCrOzIM5ty5BL3wUVcFWe9Y4utbIpaIsRTB7OS24yq1s8XF1XmOjTrr2SKPOjGDnsbTj1UM6l5Zbjru0Jun0b8dSWtZrUni7Cx01iDdHvRSiGK2KVAtWKUqbVTOBLAazJ9F9d6Lr5bBr7PM4zJobAauChTc+NPCpY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(376002)(396003)(39850400004)(451199015)(31686004)(36756003)(966005)(38070700005)(86362001)(64756008)(66446008)(5660300002)(4326008)(66476007)(76116006)(66556008)(2906002)(8676002)(66946007)(7416002)(44832011)(122000001)(38100700002)(31696002)(83380400001)(478600001)(91956017)(6916009)(71200400001)(2616005)(54906003)(316002)(6486002)(41300700001)(8936002)(66574015)(6506007)(26005)(186003)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmkvWFh3UmkwWm42TWtXcUhCWkY3Y2V4M0crSDVoOTExUUNCdmw3R1IzWi9l?=
 =?utf-8?B?NDdiemN3YmphbzFSQStESFhlL0h4NWs0RmRMV1dWWXlXdHZ5dDdjNER5elZY?=
 =?utf-8?B?aGp2ZXY5Um9vRUMrVlFNSnV3OTA5OU5Yb2w4R0cxNi9McThNa1htaHNCMVdp?=
 =?utf-8?B?aUtzck1TNFhFcXp6RkZ5MUo3cTZ6TnBaaHhhc0VReFRPaDNVMlVBU20zdlFU?=
 =?utf-8?B?WXE0VXFiTkFnenpwZEVRRXZEM1hTaE5Rc1RJa3o1MWZmOEJoZjArMW1QcXMy?=
 =?utf-8?B?UWo3azlXZk5uSVhVbFVnUmNXRThSejd6R2NCbzRVYWhYMndmczRydGdzcnBR?=
 =?utf-8?B?bUd3aXFjV09kRlFlWHNIcGk1TEI3bEtYcUJTdHBKUlc1RTlDdzNHYlJGT3pD?=
 =?utf-8?B?MFEwZWxxQ1BDcFBEc0gvOXgyR2l0RzVUbFN5Ni9kbEVmS1Q3MHZkcXlzazZ2?=
 =?utf-8?B?c2dWKzYxVnlEVGlKUHJjUnNwMGR2bVJ2MzRqODRaeWpDcFdiRU52MTNCV2M3?=
 =?utf-8?B?dEFHNE9kYzVxWXdaTW9UVjhvSFo4OE9oSVVNSlpLYnRDNzlYVDdRYTVVMEJ2?=
 =?utf-8?B?RUFjakU3OFRQclV6azhVVUtZOWVnMGtXdXd4ZlI3MVdjZDVqSk50YjQvZU5N?=
 =?utf-8?B?b0hJQnNjL1YzZ3cvRnJ4VXA5N1pPREV4SWdGZUo2OSt6UWgvdEpOcHl5VStR?=
 =?utf-8?B?UjljU2crMmoyTlBsbE83bUVST0xjNzdmUkJnUTIrbHBQOWNaVnBXMmZMYjN3?=
 =?utf-8?B?TVNpc04xSG1UOFYyVTh5em1KNU43UmRNRXpTUHdTcHJIQWhvUHBYaWY2cjcw?=
 =?utf-8?B?eit5RE9zUElDd0w5WENUUFllV0FlMlhKZFNkTDl4Mk5aeVJzZW9kZGtCaVBD?=
 =?utf-8?B?T2MvY3htcWtVc3FSNGJSUE1FaytHL0pFR1FQdmdhWEQxbTAweFZ2T1MyWnN5?=
 =?utf-8?B?TnovSk9kYk00eWQ0WWJXODNmcGtIWUt5VlNvcDNGR1VmWmR5Y3V2VUJHTldq?=
 =?utf-8?B?MG9BZ09IbDE2T2hIU2ZBT2E1dDRXVWJrQ1dFbE1FS3BNenpiUkRsRGFzSE16?=
 =?utf-8?B?cWZMakU3QlViUkdMMlN2UXJObzZOZlRkR1MzekFsaXg3bjNGWEtqYTVrL2VU?=
 =?utf-8?B?UDQrOFErQXNBbnlqWnF4d0NtM1Y0N3ZMNUJEZUJoV0JnclpLT05ZcVhLS0NG?=
 =?utf-8?B?OStKNWkrUEtvY1MwUFJMeDlkOEdtM2NyZndYUjRJckNGNmVEeVpuMk5aOTA0?=
 =?utf-8?B?VHhZRjI1YjVvNlViaW5sWEQwWlpUdDgvQXF6L1NkSzhDYi9ldTNYWGxmZDRE?=
 =?utf-8?B?VmxzSWtKWUcyM2N5ekNZRWtLQit6Z0VDRE5RWkZ1THNUR1NIcDg4TzBueXho?=
 =?utf-8?B?b1YwUWNOcXR1ZnUxN3BpdzhmdEh6SlduRFpPOWxaMG9GOVdvUkhQRmliSms5?=
 =?utf-8?B?QnFSS2pyMk1lOTFXUXphN2FHbkx1ZjhqdE04OTUyazg4MzBwOVhOUWF4cVJD?=
 =?utf-8?B?VDlkbnJ6SFlUam5SNUFmNWhLZWE3WFcySEtucWplcXJJNm10OTkyTDZ2L0FT?=
 =?utf-8?B?a2wyMktwZmMzWDZROTBQaG1KMVNsVldPSzIrSlEyQnIwdzVXS01DWVZlL2F5?=
 =?utf-8?B?QlRKdS9oL0dwdFp5a0hDTG5PaXJUVnllcHhORXlnVExTeXJ2aTJCQ3Z0eERO?=
 =?utf-8?B?REhhNWZxbjcrbmtQdmFUN3VZN01SZXJsMXdyTllzaldUVnc0a1dVam9aVlE4?=
 =?utf-8?B?TG5MWEZrbFBiY2dyM2NSVUhHb0VOUkVkck5HWjlmTDBNRlloMEVRL1Y5Y0hC?=
 =?utf-8?B?bDhBbzlMS3pTOVZTS3Q4Y3BCK3diME1IUVpZempaNmV1UTNTaStHRnhsTllD?=
 =?utf-8?B?a1JHS3FTK1FWbHJLSnRubmpKRkM2VFVuYkhsUGQrVHZTOU5lSU1nWTE2RHpC?=
 =?utf-8?B?ckkwOFRpVU4ySENqRjQxRS92blRZbm9WeWJQQkZ4NXhaZzZHeEtIYjcrWHZD?=
 =?utf-8?B?ZkQ2RW1nNkFmZGt4L0o5cktMaDFveVhBcXQ4YlcrOTQxTXNoNDlMZUhoRXcv?=
 =?utf-8?B?cWxUekFtbG8xOW5TVUp1QnhNeXBndlZQd2gvdXFadHdreWtFQzJ5WC9HeHUz?=
 =?utf-8?B?VTBxVlFRdTdnMCtQMG1SbG56WUJmVFRxWCtCUGZWdTZZcTRlU1hqb0pvdVAx?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DB6B35E68673E4490BD8733C5424400@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d117ac0f-d194-4974-8964-08dae1bb99a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 12:21:47.8971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8KcVfISOQXrPbogrw8JyiPa0itLVMWvBLXn42gZ3f3T+Xny/WWrZ0cNxu3DLqmNOFL+zfTpI/f+yDc0+cJxWr/2Q7lE8zk8bbCfpwtmOggs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3091
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDE5LzEyLzIwMjIgw6AgMTM6MTgsIEdyZWcgS0ggYSDDqWNyaXTCoDoNCj4gT24gRnJp
LCBEZWMgMTYsIDIwMjIgYXQgMTI6Mzg6MTJQTSArMDEwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90
ZToNCj4+IEZyb206IFRvbnkgSm9uZXMgPHRvbnlqQHN1c2UuZGU+DQo+Pg0KPj4gW1Vwc3RyZWFt
IGNvbW1pdCBkNzJlYWRiYzFkMjg2NmZjMDQ3ZWRkNDUzNWZmYjAyOThmZTI0MGJlXQ0KPj4NCj4+
IHRlc3RzL2F0dHIuYyBpbnZva2VzIGF0dHIucHkgdmlhIGFuIGV4cGxpY2l0IGludm9jYXRpb24g
b2YgUHl0aG9uDQo+PiAoJFBZVEhPTikgc28gdGhlcmUgaXMgdGhlcmVmb3JlIG5vIG5lZWQgZm9y
IGFuIGV4cGxpY2l0IHNoZWJhbmcuDQo+Pg0KPj4gQWxzbyBtb3N0IGRpc3Ryb3MgZm9sbG93IHBl
cC0wMzk0IHdoaWNoIHJlY29tbWVuZHMgdGhhdCAvdXNyL2Jpbi9weXRob24NCj4+IHJlZmVyIG9u
bHkgdG8gdjIgYW5kIHNvIG1heSBub3QgZXhpc3Qgb24gdGhlIHN5c3RlbSAoaWYgUFlUSE9OPXB5
dGhvbjMpLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IFRvbnkgSm9uZXMgPHRvbnlqQHN1c2UuZGU+
DQo+PiBBY2tlZC1ieTogSmlyaSBPbHNhIDxqb2xzYUBrZXJuZWwub3JnPg0KPj4gQ2M6IEpvbmF0
aGFuIENvcmJldCA8Y29yYmV0QGx3bi5uZXQ+DQo+PiBDYzogUmF2aSBCYW5nb3JpYSA8cmF2aS5i
YW5nb3JpYUBsaW51eC5pYm0uY29tPg0KPj4gQ2M6IFNlZXRlZW5hIFRob3VmZWVrIDxzMXNlZXRl
ZUBsaW51eC52bmV0LmlibS5jb20+DQo+PiBMaW5rOiBodHRwOi8vbGttbC5rZXJuZWwub3JnL3Iv
MjAxOTAxMjQwMDUyMjkuMTYxNDYtNS10b255akBzdXNlLmRlDQo+PiBTaWduZWQtb2ZmLWJ5OiBB
cm5hbGRvIENhcnZhbGhvIGRlIE1lbG8gPGFjbWVAcmVkaGF0LmNvbT4NCj4+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waGUgTGVyb3kgPGNocmlzdG9waGUubGVyb3lAY3Nncm91cC5ldT4NCj4+IC0t
LQ0KPj4gICB0b29scy9wZXJmL3Rlc3RzL2F0dHIucHkgfCAxIC0NCj4+ICAgMSBmaWxlIGNoYW5n
ZWQsIDEgZGVsZXRpb24oLSkNCj4gDQo+IFdoeSBvbmx5IDQuMTQ/ICBXaGF0IGFib3V0IDQuMTk/
DQo+IA0KDQoNCkkgc3VibWl0dGVkIHRoYXQgYmFja3BvcnQgYmVjYXVzZSBJIGVuY291bnRlcmVk
IHRoZSBwcm9ibGVtIHdoaWxlIA0KYnVpbGRpbmcgcGVyZiBmb3IgNC4xNC4NCg0KSSBkaWRuJ3Qg
bG9vayBhdCBvdGhlciBrZXJuZWwgdmVyc2lvbnMuDQoNCkNocmlzdG9waGUNCg==
