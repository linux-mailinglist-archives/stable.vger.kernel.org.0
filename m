Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6427F4983EF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbiAXP7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:59:22 -0500
Received: from mail-bn1nam07on2088.outbound.protection.outlook.com ([40.107.212.88]:31124
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238881AbiAXP7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 10:59:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/xRAMbNGXGOxUEY5B8yj5TuHlzk8DSRXOfgDp32VUC9B7qBc4fq6jUP3ZjN19xm8Bi1j/5hvDaCzx3gldvIvT0Xn/yhrcNRn/JL6YuKGsfF+EVczjXz+C5SnY8laqup2FYF4hiRtkeckX2HajLY1oCRzBZH0+NGZLdSiHGwfYMUd0usbyJIiU5kvsoiuhZU+H/xC+KL90rAdLGQ1VNiPvuy61CUd+PFEiAUROOtxIXqNG3Yc1cU/nMSk85nSKUEx7sr9gWd7FeV3axprvYbag4JO+od/+D4/4a+faFi1T5dE5BmROPCTpC6ij8g2RBMcViOXpRpzDYCSqFJEMt/RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1Nvwq0DxwwHhZ0qYu7XlAvlFAlfLAcZm7JpV4iE2j8=;
 b=jynbJVsQRHTCi2fG+448L+zgNVfmtVVF6Ef0QmAOmcvrZxFRj2umCra3JS6uQLPNbAJxKgweUDq/ffwwdkZ3YWIyygH30Gv7u6PfVQZTU6x0CU67inBuaWKTO/M/X3VOqFTy0xlBmlUr0UC94DsFRPAgPl77Q9Uwh77Yhbq89HK1wkAWLyYz9f5KjkLedeev1LAD7vzn2bni2m4S4OUiVpseEdmojfLxOAdWlBbaHzeCWBfCH1yXQorBJxxBBeMDGoCF51qqFiZ+4DVpZi5pSkSZxIiWHfVwwgBjhfCJkZZw0aEeDK9BrObUeYwW90/CBBGRtnva4nOaUv6w6S400w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1Nvwq0DxwwHhZ0qYu7XlAvlFAlfLAcZm7JpV4iE2j8=;
 b=q5mM4zsQuf2PJEdbS8HAtbxxnIcbJjjE+/7O5SmN86r146hbtYfsdsUQYMtIB23LxT2l/VHjcINm12TY8chggu27uiTb1rQ5jIoyOZFuxBFDqxPhr0z4dsfUfTBeCNMIc+CGob8cLXlaqCulR1QFRSCRFRdw+zFb7jr+LxZXQX0=
Received: from MN2PR05MB6624.namprd05.prod.outlook.com (2603:10b6:208:d8::18)
 by MWHPR05MB3039.namprd05.prod.outlook.com (2603:10b6:300:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.14; Mon, 24 Jan
 2022 15:59:16 +0000
Received: from MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::c5b8:e9c7:1cc6:4622]) by MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::c5b8:e9c7:1cc6:4622%3]) with mapi id 15.20.4930.014; Mon, 24 Jan 2022
 15:59:16 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "airlied@linux.ie" <airlied@linux.ie>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>,
        "javierm@redhat.com" <javierm@redhat.com>,
        "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "maarten.lankhorst@linux.intel.com" 
        <maarten.lankhorst@linux.intel.com>,
        "deller@gmx.de" <deller@gmx.de>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "mripard@kernel.org" <mripard@kernel.org>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/5] fbdev: Hot-unplug firmware fb devices on forced
 removal
Thread-Topic: [PATCH 1/5] fbdev: Hot-unplug firmware fb devices on forced
 removal
Thread-Index: AQHYER8bYQRkc/9a+k+MHA11TJBlBqxyVG2A
Date:   Mon, 24 Jan 2022 15:59:16 +0000
Message-ID: <e7cd09a7b302c4c7ea9b13cf0b59328cca5dc89e.camel@vmware.com>
References: <20220124123659.4692-1-tzimmermann@suse.de>
         <20220124123659.4692-2-tzimmermann@suse.de>
In-Reply-To: <20220124123659.4692-2-tzimmermann@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebd9c461-c902-4399-cd55-08d9df52791c
x-ms-traffictypediagnostic: MWHPR05MB3039:EE_
x-microsoft-antispam-prvs: <MWHPR05MB30399CF2D0BDF6F476633FFBCE5E9@MWHPR05MB3039.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r9W/UELl9PpbECDnUsKT57yb+pp9JEt1MVbM2+JR/Znsr2B5UAhCJfoIQFJYNnowYifz6u8SNQeJE380Qbu0HxsYNKbI62R5+aH1Nn911qglfl2BVkHM1+kZZauesndKZLOyZ81PdW6La84f+qK1JVWd/nZJk+olaSZwn/uFGghpWCiLfJ4RkmWdTF8q/Khg4DM4pWPL6DwShCkNgfD+MI/uDFMCOAqsmQ7S1A8iF7zZt4LrgOR7WMo+MOEfYY4cY2BoBbzpw84nxzYFk0R8sRxIfKbG3VWuC68o1izsqQBAltJLrmxo4BBT6NyLZSnd65KbmF/ftFqlgVITJICqxQT+5ZplihGBwYoDnNUUKK5psntWwF/cXzoaSQ09EsuumKejrBYxlaTLG96J1wfId9Isp8BQdutK/6m0TXWd3oRZlz9rLxjl6Mmt4sIGjEd7Yfm0I5+x2zTN/mkuT9WvOPbJxiL/GetrvbxLMbxotZg42qT8R4GbR71SdNoDzLvzxfXiyzSlUbnE4GjPPSLwJ+7xJzkGLWZdxcio0l04S1/axiMgjur2tuWPtcRvurcDO+FdMsmDitTPfY9+QldEEAzcIoO7XgSbYFkSCsRVlybKqVSex+GjK5d7SAdR19ZecT6+w81N/OD7sNGuZ7FxGu1GSjyCfA6MKKuCQmY0IKW9xyNepvsUdQytK/jrxTGwJnLhCrb8gXMth3s05b+mZiUj5i9F7A+aNfHGYe/iEkKjZI/bMrwO7T4umzH5NoBj9B4fUt4tZo+uclokJMWgQjNFu+6uiJXuiuxJWcugprE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR05MB6624.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(110136005)(966005)(6486002)(76116006)(508600001)(66946007)(6512007)(66476007)(7416002)(66556008)(36756003)(8936002)(2906002)(86362001)(6506007)(316002)(64756008)(66446008)(4326008)(91956017)(38070700005)(8676002)(38100700002)(5660300002)(83380400001)(2616005)(186003)(122000001)(26005)(71200400001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTlDUlZENWxoZlZURjVYaGtua29sZW94TUtLZjI3VnFVQ2xscHRINDIyVnlj?=
 =?utf-8?B?T0lIZjhFcUE2b0p0WURkTTFveTJIMU1EQjU5VWphSVZCSThsZHpQNTBUZ0Nv?=
 =?utf-8?B?Wm9ZTzh6TlYwOTFZTzI4bDRPTjYzMExLcWEwYm5JckRYZTBMWGhVRzdXVDVm?=
 =?utf-8?B?U2RMRWhkeXNDOHRvU2hTdllTc2ljZUpSK0tnRkZPWGY0NnFXM0c2V1o4MUF1?=
 =?utf-8?B?K1RQZ3FGaEtka1hmNEhCc3oxSGxFOGFpKzVNaGJBYStRYlBpNXdqTGJUVGt3?=
 =?utf-8?B?R1laL3BLSzlDM3NRRUtZTlNlTUtLZjQ4TlM4Wk1kSGF4SnUzc2xXL2ZvTjJS?=
 =?utf-8?B?d0dJdjhLallGSFRFMzN1ZktueUJBczdtM2xXVTB4citHM3dpK1RGeDd3dkRL?=
 =?utf-8?B?WnVXQmRJbk5FOFlFSHNUenA2V2hDSzNERFMzQ2ZIQkZQNHp4TnRxUDFjcm84?=
 =?utf-8?B?ZkxnaHJFejZSMmFhSm1qRGtyYkNNOFhVT1JTbDNEaTg4dldMQ1p3UDZlNlhq?=
 =?utf-8?B?cG9ucWp1V0hCUXl1aC9LaW03QUxnYmVucFhjeCtydzRiNEp2ZnltRnRaN2to?=
 =?utf-8?B?WHRvUmJWa2ZmRzQwNW1nWURUbVlzZE9EV21tNVNnTUs4VVJyNHhQSnEvRWxW?=
 =?utf-8?B?QmNGZzNyOHMyb0YzalluOXBWUFJWbll6b2xmUklWQ21LV1VObTJ5UHZUM0xL?=
 =?utf-8?B?SFhxRm9HYUc1ZVd3TUU4b3lZTDY3ZThqMlRqL2gweHFkRjdsOW83eGVMc3M5?=
 =?utf-8?B?dUoxcjR3anl4Zkc5dW9HSzAyNzVNU1NobkJ2VjljZ0pZc1JOdlpxUWxpRkxD?=
 =?utf-8?B?NHRkTjU0MXpmWG5ocmxnVDNxNVI5N2Y4ZkJmY2JqRUF5MkV1Mi9UbzhHR2RK?=
 =?utf-8?B?cXp2ODhBcUpnZ1gwWDgyQ0JiZTF4WDFmQWoxcWxjSy8vQXVoanFZL29hbnVZ?=
 =?utf-8?B?UThHY3grUWZrb0loWVcvN1hydGxhRjhMUjNEempGcSt4dHNOZUN0aDFOakJw?=
 =?utf-8?B?QjFPYUxZTXRTaTd1c1NFSmpUWXI0My9LY0RxejJuRHc5aVRra1lSZnB2Tm5R?=
 =?utf-8?B?c0dFdms5TzgvN0NzSmk4U0E0cml0eDAwSGROV1pBZ3ZabDRlbTZDakpuMHB3?=
 =?utf-8?B?VFBRSjlQUkdsdFMwNE1ZUFFBMk1RRVZFeExKdTUvNUNacHZyOHFSVnkrY3JO?=
 =?utf-8?B?enN0YXFYNkszbXp4cE1ha0VKRUkwd2ZNeGZSWnZDRXd4eVlnZW5YRG5wWXZH?=
 =?utf-8?B?aXRQaEFNSEprUVhzUW9HQWo0RENwbWFUMFhNc2x1dVcrTklCN2N2d1NvdTZs?=
 =?utf-8?B?dENIQ3hOV0tWR3I5bi9LOGNGdnNiaE9CNWdFTGtua0taU2xCb2x3S3VHTVBw?=
 =?utf-8?B?M0hJM1B2aUptM0JSdnM4RUE0dERXNC8xdWlVVnY5ODBMck5tekVxOXFOMmpN?=
 =?utf-8?B?enZER0tDYkxuS05DTFFJRmFvaXM2eXo2RGtKUkV6TFZjeUxJYVpJditmaEM0?=
 =?utf-8?B?NEpFTjdMYVZWKzltd3U5ZXNESlQ0SG9VQllaaWpoRjJjY3dXMG85RU9PQ3hj?=
 =?utf-8?B?T0VmYXVPbElCU0xXdE9NVWN2TGxCZXhwd0N1VGpnZ2l2WURsTU5CazVpQll0?=
 =?utf-8?B?d2kvZ1NXNUxuRlRya3hvWlNMb01zVkh2dmpQZTNpNzdVYU9NaThVWkVEZ0wr?=
 =?utf-8?B?NTZ3dU1tZEczcHBMampuOTdEeHRtT0lrSzg4T0xSOEZ6am9NQzUybUl2bkt2?=
 =?utf-8?B?dUpUejhkdVowZk1iU2pvS0MxL2FicElDalhQMy9IZWZ1RG9mRHJCMktEMmZ6?=
 =?utf-8?B?NmlJRkc3Zy9xWnBhSDBWZTVJcTVrVmcrZWZ1ZG1sMlNVcmdpWWx6dUNzSmg5?=
 =?utf-8?B?dnBsTlZIZXZ5SFloRnV3eEtteXphTmlFMXJFalZsM2RHY3dwMjJpYlZmYWNk?=
 =?utf-8?B?a3JNRENNQkpuc2pvSkJUSGxzeHgxSnpPZXlSSDdkK09sUVZQbVFOZEdhenQ3?=
 =?utf-8?B?V3pOMTZWb1Vad2F2amZXdVBPZndKeGVpQ3FONW4xZGxwQy9qc2xhL3RrUFdh?=
 =?utf-8?B?R3drM3dwQTkwUkppNkFFRkVpc0ZUUTJuUUJ3d3lzdlhJUTAvQUdDN3dnNkRN?=
 =?utf-8?B?aTBLbDE2UWprY1VoaFovRmpOd28xUWsyYjVUT2s5YXJpM2JYWTBmU0lDWTY1?=
 =?utf-8?Q?CVJnsJm9btgYaRT2UBU0zTA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <588013557BA0DE4090497D128574B500@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR05MB6624.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd9c461-c902-4399-cd55-08d9df52791c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 15:59:16.0628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jPE5/RJlg12lZ+GhhvvoutffY1rHVY9aqca+sxE4rPYM3j4iL3cCbZOIVChGVW6iO1+7cJyfvpWvDL3+tCSfzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3039
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIyLTAxLTI0IGF0IDEzOjM2ICswMTAwLCBUaG9tYXMgWmltbWVybWFubiB3cm90
ZToNCj4gSG90LXVucGx1ZyBhbGwgZmlybXdhcmUtZnJhbWVidWZmZXIgZGV2aWNlcyBhcyBwYXJ0
IG9mIHJlbW92aW5nDQo+IHRoZW0gdmlhIHJlbW92ZV9jb25mbGljdGluZ19mcmFtZWJ1ZmZlcnMo
KSBldCBhbC4gUmVsZWFzZXMgYWxsDQo+IG1lbW9yeSByZWdpb25zIHRvIGJlIGFjcXVpcmVkIGJ5
IG5hdGl2ZSBkcml2ZXJzLg0KPiANCj4gRmlybXdhcmUsIHN1Y2ggYXMgRUZJLCBpbnN0YWxsIGEg
ZnJhbWVidWZmZXIgd2hpbGUgcG9zdGluZyB0aGUNCj4gY29tcHV0ZXIuIEFmdGVyIHJlbW92aW5n
IHRoZSBmaXJtd2FyZS1mcmFtZWJ1ZmZlciBkZXZpY2UgZnJvbSBmYmRldiwNCj4gYSBuYXRpdmUg
ZHJpdmVyIHRha2VzIG92ZXIgdGhlIGhhcmR3YXJlIGFuZCB0aGUgZmlybXdhcmUgZnJhbWVidWZm
ZXINCj4gYmVjb21lcyBpbnZhbGlkLg0KPiANCj4gRmlybXdhcmUtZnJhbWVidWZmZXIgZHJpdmVy
cywgc3BlY2lmaWNhbGx5IHNpbXBsZWZiLCBkb24ndCByZWxlYXNlDQo+IHRoZWlyIGRldmljZSBm
cm9tIExpbnV4JyBkZXZpY2UgaGllcmFyY2h5LiBJdCBzdGlsbCBvd25zIHRoZSBmaXJtd2FyZQ0K
PiBmcmFtZWJ1ZmZlciBhbmQgYmxvY2tzIHRoZSBuYXRpdmUgZHJpdmVycyBmcm9tIGxvYWRpbmcu
IFRoaXMgaGFzIGJlZW4NCj4gb2JzZXJ2ZWQgaW4gdGhlIHZtd2dmeCBkcml2ZXIuIFsxXQ0KPiAN
Cj4gSW5pdGlhdGluZyBhIGRldmljZSByZW1vdmFsIChpLmUuLCBob3QgdW5wbHVnKSBhcyBwYXJ0
IG9mDQo+IHJlbW92ZV9jb25mbGljdGluZ19mcmFtZWJ1ZmZlcnMoKSByZW1vdmVzIHRoZSB1bmRl
cmx5aW5nIGRldmljZSBhbmQNCj4gcmV0dXJucyB0aGUgbWVtb3J5IHJhbmdlIHRvIHRoZSBzeXN0
ZW0uDQo+IA0KPiBbMV0NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvZHJpLWRldmVsLzIwMjIw
MTE3MTgwMzU5LjE4MTE0LTEtemFja0BrZGUub3JnLw0KPiANCj4gU2lnbmVkLW9mZi1ieTogVGhv
bWFzIFppbW1lcm1hbm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+DQo+IENDOiBzdGFibGVAdmdlci5r
ZXJuZWwub3JnwqAjIHY1LjExKw0KDQpMb29rcyBncmVhdCwgdGhhbmtzIQ0KDQpSZXZpZXdlZC1i
eTogWmFjayBSdXNpbiA8emFja3JAdm13YXJlLmNvbT4NCg==
