Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFF866C94A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbjAPQrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjAPQrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:47:19 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2042.outbound.protection.outlook.com [40.107.212.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F5F40BE9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:35:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGnIG25Prb9OvAg7flKsZdLcuAdKlG1hxr1BIp92DJi2upoQBeK4vwoOP99GA6M9BSDMNLYtOoG8uqb/WwA66y/v+S68oh2i3fEwrTGcm6lmECkMTOmnt+1nscbtpvhPQhT+uFO/leBHK9+he8jcf15V0tgBiAiWG7PNoH49Jl4G8hUsSZJM04H5GCsBYdS7zXyMVVTofscJz2SlQXoi0Mc8NxtbJepEnHtOJdUcSxvuNWgG81EUm2t8P4rpLyDdb+wHRw+1HyqdOtHBUbMA3WsOiAN2kckDBZVomlk89uN8oF4BMGvD/HkK7bCotBKpWLTG/aWpOi/IiJFoLv2c4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cbgI0Mn3j8crJsISyS+DOno2+/mCCGoXTG6oXwmGi0A=;
 b=Ln7zusuRnMXH7l7FnCU/4Dv/TZuTW7ryDgH6ErjAMBY6W945MSdv0Jivb2mgpUhXpI8heybeJNpZhK06GTj3/dwzQkUNxugLQIhi3hJ1s2rCT3KgrLwyM/2iUfs3Y2gZoHqtio4Ja4eWkrQ4k/AoXXjixH1qO17OpHIZp3Gk93xCGPORTKoviBuz1WpSd8+EFC5EByVzSDXwQdBPKq+Ns9b9yIcI2yWpEjKmfW7P1cU8Olsm+J+vNhVZLlr8o74dzqyYTgw0LmYS+vuFwLyoW3hzqG4snWhofWdSKsiWKr4LKwILfhSCv4bFKaZjeXcTqaFjhb9RtDyHs96Vbq5PgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbgI0Mn3j8crJsISyS+DOno2+/mCCGoXTG6oXwmGi0A=;
 b=3Gt8hw3SxCgFC5pE4Ulf8Pjvlc49G2aFN7HuC388YIbDzTeUsWBANGYq0ULIFP00F1lPxt5Q/tlxQZISQ6o934mhflOQZqIXMxvI0IGYk1PE3DzMt+lZWweiy73AKFKk8q4zdjA/DQWgHIZe6uyCMyUqIJqTACieMlDaskUqOhk=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DS7PR12MB6165.namprd12.prod.outlook.com (2603:10b6:8:9a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 16:35:05 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::5cbd:2c52:1e96:dd41]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::5cbd:2c52:1e96:dd41%5]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 16:35:05 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "Tuikov, Luben" <Luben.Tuikov@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [PATCH 5.4 537/658] drm/amdgpu: make display pinning more
 flexible (v2)
Thread-Topic: [PATCH 5.4 537/658] drm/amdgpu: make display pinning more
 flexible (v2)
Thread-Index: AQHZKcgS/D4R4Qs+Q0OOQXTB6D0++q6hPQXA
Date:   Mon, 16 Jan 2023 16:35:05 +0000
Message-ID: <BL1PR12MB514444FC720081DAC5423410F7C19@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20230116154909.645460653@linuxfoundation.org>
 <20230116154934.097314689@linuxfoundation.org>
In-Reply-To: <20230116154934.097314689@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-16T16:33:48Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=b39d2053-573e-4783-939b-a792364d0d8b;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-16T16:35:02Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 9c673548-87eb-4926-accc-e4edd0eb017c
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DS7PR12MB6165:EE_
x-ms-office365-filtering-correlation-id: a77e1c2c-84f1-49ec-53d7-08daf7df9fa8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i6BRzsi1hpj1GP678ZBj74eHH2ZL9z9nlIgWHF15YBvaluxgkedT5gIF2wcZSjuz6I7Qzpatlb+dcb0vFbQx67Gpp90bj7R6IbkmOeWOS/kkvYhTm5s7ZG2uHkHYVNAvdB88aTL76Rx0JMK7Q3gj2AYTAQZv1RBQW9evBkb78LyiVweSBSo7EI3mFMCw/eijc7HzeAVbASBBt/rITr7nz8IUjofQZbj/2XptlYWTx1LcLAcK6XNMT9Ti2CPW59lGzu8Tlluk1t1fabZYtu9Uw/MvhW+83/4Jrbmztqt0iTO5G498zhrE0M8Z/SYktomUt/5eorbltzYVqyU/nnLQ7biqhKgsP3ITBf6YFjPDhDEmTmxRQEPFJy5u7dGKr+mppgn9APRzRjPnNHvRZpfYlOMJ5TV/wbD+vKY2ZA8POlW1rv6bKOe/XUA60uY452vYoi0BYcVxvIHwORP/e9eoZUJi8u4I/sOq3p4T6ekk1CdOK7SZGQGfhfEp4MNcYF0bC+2jNRiew/CN+Sz0VxEdCXFoiWKGDfPwOe0CNxdo/WUKfW5alFOiMG1atoCouJRMl6fXTbUl3L2IlL84Hs3FG1OtPiti+xTwEJ2eYJLBvMiEofD2G8+zQHR3kS1DA448//msWMuxzQGElog3rtT2bQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(53546011)(33656002)(66556008)(76116006)(66946007)(66574015)(41300700001)(186003)(66446008)(66476007)(9686003)(4326008)(64756008)(8676002)(26005)(86362001)(5660300002)(52536014)(8936002)(54906003)(110136005)(478600001)(7696005)(6506007)(55016003)(71200400001)(316002)(83380400001)(2906002)(38100700002)(38070700005)(122000001)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0FQWnBDNmFTTGZHUVBPYWZKLzkyaGhTNzVnM1FWalYxNHlZRXFza1JCMzd1?=
 =?utf-8?B?UVN2dHNhdlNBdWt5Zmh1WUJwZmR4aEoyenpXVFNiek1tVE83Q1dYUEhJR1BB?=
 =?utf-8?B?TEZWNVRmcDUvcXpUMHRLWFVQaEwvNGxZbnVnNXVrZGExV1pxN0JFUk92THg0?=
 =?utf-8?B?MmdlS25Oc3pZYzRIM1ZIamVwQzZZcFppanhwNFlUWDNpcHRGZGN4TUdsdm9R?=
 =?utf-8?B?Tm04OEh4bC9JNEpZdXJKUW1ZTytlQ3JScFpnVjJoRjEvc25sZUdiQkovOXFj?=
 =?utf-8?B?UlRoY2kyZnVIbUV4bW1KMGQ0c1RwU3VoVzkwMWErSGpGWGZ5TzhSeis3V0Iw?=
 =?utf-8?B?ZXl2cVRFWnVyTEt0eTZvNk9OcFkxSUJudGlydjRVUlYwdXVDanh0Y25ZKzhG?=
 =?utf-8?B?dkJCRHNJUFRBMmhpMDAwZGZ1MUlUV0lEU3FBUkRqbS9ZNTIyUmdtbjdra1gz?=
 =?utf-8?B?MU9EdVV2a1hsbHhWYmNUdm9kb1ptU1NhdnduaWdpekdtS1JqcXRZYVowcEpG?=
 =?utf-8?B?WkRibXM0WjlIU3kwNkF6NHdRZEd5U1VHRHZoOHdVRkwzT3AxVUk0KzkzU3E5?=
 =?utf-8?B?S1RBbDBhZ0FYNlFFd1BlaFlBOEhJRUoxM1BpQzBTZVFhWWRCYWkyRStXaUtk?=
 =?utf-8?B?T0lGQXZKR2hqWjB1Z0dOZmhsYU1rSkU4Sjd4MkF1UE5WditSdFRwcS9iWFFY?=
 =?utf-8?B?ZXh3aUNTOWFKRW5HV055MXQwZ3JzQnJET25lOGpRa24zM2h2TUIyYWdsYjhi?=
 =?utf-8?B?aTZaeGxIRjl3TmRtSjdYL3dsa0NwMzZibHo4L0tUY1VMZHV6MlRZbXdncHZv?=
 =?utf-8?B?TnlQdlhFdjBsUk12cG1NaU56eUJqUTlEbjh3b2MzaFcyZmRxdEQyRTdzUVZ3?=
 =?utf-8?B?QXVDcjRqTEs1Z1BrblY5b1R3aFVWT3ZRTUVzVW81b1ljRWMxVk8zQnB6YTJo?=
 =?utf-8?B?ZnZhVHFYMVZiSEN1cHJobUpSSmpVd0VLUVJqa3VWOVNnMXdPR3o5REx5SnpO?=
 =?utf-8?B?K1E0dDF1UHlJS0w3dXN4NklEeGNoOFQxRXkvL0ZRV2hFVldhbVQ4ZEZ2eGlP?=
 =?utf-8?B?U3dXQVBhdWptR2hxek5jVEFhNkg5TEVXd04xd3lnT1FuaEtlVGZJZDQzeUwz?=
 =?utf-8?B?cmJORmdVRm0vbGdVT3VhbFUwb1NXVU9FcllCTE04bXdrZEptMUN2QTR1ZlIy?=
 =?utf-8?B?S1J2aEQ2K0ZJNEw2MmF0a09VWjdUOWpPSkhJSTNicGpEbGlyQzBTU1hLS1ZJ?=
 =?utf-8?B?enRVcHVpRUFLcHJSQ3BBQTAyYld3eXRnbE5KK2w1MUwzNG5vZDAwUDJqcXRT?=
 =?utf-8?B?S21EV0xnbmFmbENqaDRHbGtXZU9vdGJQdE5obWtjbk9jb1JRTlJlWUFDMTJx?=
 =?utf-8?B?dkJhMTNqd1kvamdpK05oSUxBZ082RXUzRzRENENhS2laa0JjcVI4RHJaK3FD?=
 =?utf-8?B?eTZYcXRpQzBMUm1KUG5SejZxU0JEU2hmUTkwcW1UUWYwNUJtVERzblpVam56?=
 =?utf-8?B?VlR3VVJIc0dNdkZIZ1FrZlo3V1lTd3FIU1gxTVJZTzRPMHI3UnNZdHYwK3Zh?=
 =?utf-8?B?SHg5U0h0aVVSVDZpSTRRSTFnaE91WldicStQVThRbFRoTEQzNXI5S0d1TG9H?=
 =?utf-8?B?Y0JiZUp5VHAwc3RERHBkT1Q2REN3RlRPSThaU3dVaGZMdk9hZjZaU3BIQlVC?=
 =?utf-8?B?RDRHc2VKL1BpSytTNDc5dHg5QS9LUXpUMXJXcDNYamFWWWFIQ2RNaHdyOFZU?=
 =?utf-8?B?UTZyRU5JRE82SDJqWEEvRlFxdVpTVGE3QzYxVTJqQjZjM2hhRVJMRGNVRUFJ?=
 =?utf-8?B?d3JRYWIrMlJYdzBiMTlVRkVBSDYzc0sycFlIV1UrTFQxZ2VPcGVRd0ZWVHFC?=
 =?utf-8?B?WXp5U2Q0dklvRWhpSU1DVnc0UjBpTW0zV2dWVWZoUlRKTnZSUlEreGV1N1BO?=
 =?utf-8?B?MjNabGNQRVlxVmJ6VmdTdkp4T2toZXRwSjV1UkJmRkV1STV4dmhrTERjM2hh?=
 =?utf-8?B?S01tMmhra3kxQVNjSzhMR25NQWZvc0xmMjhkSkNURTZ1cldxZVJiRWx3TXRB?=
 =?utf-8?B?OVpCSGp3MnB4cmFwQXI0K2ZCRndtZ0VmQTFtbVVYSENyNzEzRHVSTXZ4QVhF?=
 =?utf-8?Q?7zl4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a77e1c2c-84f1-49ec-53d7-08daf7df9fa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 16:35:05.4254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y5DL5tiPKBa3m+X2b9DG8O5II4R8ZtFgEsUm4aeXXfsTuGCW50H9ZQceKZoisOK5ZzULclKBuu4fXn40+1FO7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6165
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBNb25kYXks
IEphbnVhcnkgMTYsIDIwMjMgMTA6NTAgQU0NCj4gVG86IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Ow0K
PiBwYXRjaGVzQGxpc3RzLmxpbnV4LmRldjsgVHVpa292LCBMdWJlbiA8THViZW4uVHVpa292QGFt
ZC5jb20+OyBLb2VuaWcsDQo+IENocmlzdGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPjsg
RGV1Y2hlciwgQWxleGFuZGVyDQo+IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPg0KPiBTdWJq
ZWN0OiBbUEFUQ0ggNS40IDUzNy82NThdIGRybS9hbWRncHU6IG1ha2UgZGlzcGxheSBwaW5uaW5n
IG1vcmUNCj4gZmxleGlibGUgKHYyKQ0KPiANCj4gRnJvbTogQWxleCBEZXVjaGVyIDxhbGV4YW5k
ZXIuZGV1Y2hlckBhbWQuY29tPg0KPiANCj4gY29tbWl0IDgxZDBiY2Y5OTAwOTMyNjMzZDI3MGQ1
YmM0YTU0ZmY1OTljNmViZGIgdXBzdHJlYW0uDQo+IA0KPiBPbmx5IGFwcGx5IHRoZSBzdGF0aWMg
dGhyZXNob2xkIGZvciBTdG9uZXkgYW5kIENhcnJpem8uDQo+IFRoaXMgaGFyZHdhcmUgaGFzIGNl
cnRhaW4gcmVxdWlyZW1lbnRzIHRoYXQgZG9uJ3QgYWxsb3cgbWl4aW5nIG9mIEdUVCBhbmQNCj4g
VlJBTS4gIE5ld2VyIGFzaWNzIGRvIG5vdCBoYXZlIHRoZXNlIHJlcXVpcmVtZW50cyBzbyB3ZSBz
aG91bGQgYmUgYWJsZSB0bw0KPiBiZSBtb3JlIGZsZXhpYmxlIHdpdGggd2hlcmUgYnVmZmVycyBl
bmQgdXAuDQo+IA0KPiBCdWc6IGh0dHBzOi8vZ2l0bGFiLmZyZWVkZXNrdG9wLm9yZy9kcm0vYW1k
Ly0vaXNzdWVzLzIyNzANCj4gQnVnOiBodHRwczovL2dpdGxhYi5mcmVlZGVza3RvcC5vcmcvZHJt
L2FtZC8tL2lzc3Vlcy8yMjkxDQo+IEJ1ZzogaHR0cHM6Ly9naXRsYWIuZnJlZWRlc2t0b3Aub3Jn
L2RybS9hbWQvLS9pc3N1ZXMvMjI1NQ0KPiBBY2tlZC1ieTogTHViZW4gVHVpa292IDxsdWJlbi50
dWlrb3ZAYW1kLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IENocmlzdGlhbiBLw7ZuaWcgPGNocmlzdGlh
bi5rb2VuaWdAYW1kLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4YW5k
ZXIuZGV1Y2hlckBhbWQuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWdu
ZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3Jn
Pg0KDQpMZXQncyBkcm9wIHRoaXMgcGF0Y2guICBUaGVyZSBhcmUgcmVncmVzc2lvbnMgZm9yIGhp
YmVybmF0aW9uIG9uIHNvbWUgcGxhdGZvcm1zIG9uIGtlcm5lbHMgb2xkZXIgdGhhbiA2LjEueA0K
DQpBbGV4DQoNCj4gLS0tDQo+ICBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfb2Jq
ZWN0LmMgfCAgICAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1
X29iamVjdC5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9vYmpl
Y3QuYw0KPiBAQCAtMTQ1OCw3ICsxNDU4LDggQEAgdTY0IGFtZGdwdV9ib19ncHVfb2Zmc2V0KHN0
cnVjdCBhbWRncHVfYg0KPiB1aW50MzJfdCBhbWRncHVfYm9fZ2V0X3ByZWZlcnJlZF9waW5fZG9t
YWluKHN0cnVjdCBhbWRncHVfZGV2aWNlDQo+ICphZGV2LA0KPiAgCQkJCQkgICAgdWludDMyX3Qg
ZG9tYWluKQ0KPiAgew0KPiAtCWlmIChkb21haW4gPT0gKEFNREdQVV9HRU1fRE9NQUlOX1ZSQU0g
fA0KPiBBTURHUFVfR0VNX0RPTUFJTl9HVFQpKSB7DQo+ICsJaWYgKChkb21haW4gPT0gKEFNREdQ
VV9HRU1fRE9NQUlOX1ZSQU0gfA0KPiBBTURHUFVfR0VNX0RPTUFJTl9HVFQpKSAmJg0KPiArCSAg
ICAoKGFkZXYtPmFzaWNfdHlwZSA9PSBDSElQX0NBUlJJWk8pIHx8IChhZGV2LT5hc2ljX3R5cGUg
PT0NCj4gK0NISVBfU1RPTkVZKSkpIHsNCj4gIAkJZG9tYWluID0gQU1ER1BVX0dFTV9ET01BSU5f
VlJBTTsNCj4gIAkJaWYgKGFkZXYtPmdtYy5yZWFsX3ZyYW1fc2l6ZSA8PSBBTURHUFVfU0dfVEhS
RVNIT0xEKQ0KPiAgCQkJZG9tYWluID0gQU1ER1BVX0dFTV9ET01BSU5fR1RUOw0KPiANCg==
