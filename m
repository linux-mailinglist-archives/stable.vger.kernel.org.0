Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D616E4D70
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjDQPmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjDQPmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:42:03 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3256BCD;
        Mon, 17 Apr 2023 08:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ta7KHM6F6sE2+aDQDN4CAMZK4/IcPmpjL3OK3Ldaai5NC5IloW0G61X7SWavVx7YJkrgASD2L2seDBEIWSb0AY5WbuWax92qq1byl3c0LM8Mms0BRRBYLAWZT8cT1E5bHRkOYN3BHKdTmHGr7IpvSvnzhbzg46bJHbhfXt0W7R/X7JIt2Bq6X/D562wCspvgbqIz2Vs9F91fAIUyH387E546ZsyUtsRTkPd1biQn42W24Ujupbhf5yXB6zXf+/SvBmQWNJifS38u+ZHwu5MAXwDitNEVu5sgAmhtW9EveKQkgjenuu/txzpA6mycmPC55vQ8QEd/ua9rFMxz6fhZBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTgXIfsBG7hf+2/45zBmihyQZKOEqNkV4rRifMWfKoo=;
 b=aTzeDthGa/1EKLMB8bHzHwvqumaS0oCQ1tVX7QspKcig1YddKa7By3PuzLSy9Ic6yftgckvFtxlwttHuLu6+BY0awZ0V2UzLgL7u64FpbfFSIHfbon24lDp+FQhhfc8M2X7FCLlW3Ke6ehP2dOwyrKB0oC0cLlU8ugpY/EMhFk03HsgfuCOCro84vAsW2aCo9uHV3IPc+/f/UEhs0amthxA77yaeMqO19v8UOCCR6StUbcIe5m5ZlFoDWCuJwDih65RTQKmyAH2RqIFEsuiLL6VEmdsUOGxlWiYkJB2OYD2EBHJC5xyG8cMBblTEmEc2+Sez5yp6pPXlx47i9oe7UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTgXIfsBG7hf+2/45zBmihyQZKOEqNkV4rRifMWfKoo=;
 b=yKQGj0Z3KCCyBsDb/CxXQKiM+A3NBhK4CMo5SbDAZAR0q4kM+H5800/KotCQ2mU9/dv8p4uNBy2+e6nR/7vh7ZwfDVytgOop81Er0vATujt98Q3PjByt6n1Ea+xHfWI93hQlDK8Qla2fxDhRnfOndkNw455c84K14a9PW0Lyjw8=
Received: from PH8PR12MB6962.namprd12.prod.outlook.com (2603:10b6:510:1bd::18)
 by SA1PR12MB8860.namprd12.prod.outlook.com (2603:10b6:806:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 15:41:57 +0000
Received: from PH8PR12MB6962.namprd12.prod.outlook.com
 ([fe80::f7e7:58d3:21bb:1e88]) by PH8PR12MB6962.namprd12.prod.outlook.com
 ([fe80::f7e7:58d3:21bb:1e88%6]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 15:41:57 +0000
From:   "Wu, Hersen" <hersenxs.wu@amd.com>
To:     "Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        "Zhuo, Qingqing (Lillian)" <Qingqing.Zhuo@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>,
        "Tuikov, Luben" <Luben.Tuikov@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drm/amd/display: fix flickering caused by S/G mode
Thread-Topic: [PATCH] drm/amd/display: fix flickering caused by S/G mode
Thread-Index: AQHZbwfXQjsjnBHcYUC8RviFSXltwa8vBXaAgACUqgCAAANfAIAABjyAgAADt1A=
Date:   Mon, 17 Apr 2023 15:41:56 +0000
Message-ID: <PH8PR12MB6962186DEF22F5CE45458675FD9C9@PH8PR12MB6962.namprd12.prod.outlook.com>
References: <20230414193331.199598-1-hamza.mahfooz@amd.com>
 <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
 <23ebe744-bd4b-c411-99f1-c4ae9dc132f7@amd.com>
 <d9fd286d-7f06-be80-7b81-b2aa2c074f1f@amd.com>
 <b112c88a-c3b2-67a2-b401-8d8962bbe01b@amd.com>
In-Reply-To: <b112c88a-c3b2-67a2-b401-8d8962bbe01b@amd.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-04-17T15:41:55Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=05792107-3b64-4cd8-9a10-923e6c6b0a0b;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2023-04-17T15:41:55Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: bd356eee-40d3-4f0e-8fd3-398ea30d3db6
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8PR12MB6962:EE_|SA1PR12MB8860:EE_
x-ms-office365-filtering-correlation-id: 24de781e-dcf0-4aa7-289b-08db3f5a46bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FJrua/MSzl5/d3sB0vCzIKiM0LH5J5mVvHQFPgjHPAOguFEAZxiWxYzubEfD70zOiu94rZAO4+mZC1TvIbGKph/kWEGX+5Gi0CaTVVwWX1+Y6MV/r9sXXZU/BLXm6E8SKioOC1iGcXt9eLGUCpglQqz+3eSSh+YpXLTuV3FHwVjkmdzGSHmAf1u/M3VhpmXHvlRlTOD16dIxTHqGZxpnmUCCqOPbi1xFZJtNxOBlNHQu1rv3bVZvupafwKDxyEb201IARA/FJeQajnxOZgHEpU6g0Ar6fZiibu9czgk0nCfyT7Qy/e1hawVLgRDrXtx/y9xzGpm15yYSYBVlb6lfDsudo1zv/nENi+k3gFot7mxDv4f8YHsxPqnNal+QDEG/7aM//XWNIN8/bgBPJzGJL8OYeevBdmUIN7yQH7jZZ6bgNjmOb09QTr1AUuJlHv1G3E4sFvrrMxfKpBIbIQ5xmlWfha1xSdpT4gDECmpFihDJ/RuN7r/lhemxDyFOkqHnwLzaNgvtJ/wQTp9TeQPvUC337o8fJiHKAKDnTIoLBvmkaOpubcUzpBzjn+Th/q7SqXxpo4V2IDXr9eLJGzt2cSIz3meKa6RzaGv2ihaS5QmwOxBPJKZxUMPtHcJwmjsw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB6962.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199021)(4326008)(316002)(110136005)(54906003)(76116006)(66556008)(66446008)(64756008)(66946007)(66476007)(33656002)(186003)(53546011)(26005)(6506007)(9686003)(38100700002)(122000001)(83380400001)(66574015)(55016003)(5660300002)(41300700001)(8936002)(8676002)(478600001)(71200400001)(7696005)(86362001)(38070700005)(2906002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3dtTGM1WTV6N1FqbTBwUFpRb2JBYTRJcEoyYVlTRktFUTRYa0hvZFBwRHBI?=
 =?utf-8?B?YkNuRVR1SWVkVlViTFRHc1ozMkJERHdibkFrQU5LSmVqNmRuZkR6cHpCamlI?=
 =?utf-8?B?UUFUOVlQVnVoS0FscS9PNURaN1dIU3l5bEpsSWJqdHMyTXhmRHRrOXUzeEQ2?=
 =?utf-8?B?ODhVUHRZTEU1TjJjQmd3SC9xNlFQem9SY0oxQjBoQjcwcndGQmhBNkUzRFNa?=
 =?utf-8?B?eEhpaXhDbUZWSmNLZmxUK05FRHVXblJOZGFtbGZpN01pM3NjR3pUUjFrNHFZ?=
 =?utf-8?B?N0Z1dUJ0WTA1WFFSVkZvOVViUGNvSmtBWjIzWEowRUlEQ0t1RWgxd05WQU54?=
 =?utf-8?B?RHMyTmZXN3FCV3kxMW5wWXNNaUlzayt2QkF1S3pJR2FvWjVNd2prZ1J2Yzdn?=
 =?utf-8?B?QmUvUHBZb0tmVkFpNG5SK0JRaWR1cHZNRWJhWjhXQVR4ajBjVG5paUZKb1NR?=
 =?utf-8?B?VnBTTzBpelcyZlNhVDg1MHJIZEFZTmZKR20xS3pwaW5GVnVza2xIMmxBVmVP?=
 =?utf-8?B?cEJlZ3RubktWcWU4L21McGRhaVorNjdCYjEyNklwOUxnemZSN1dySHY4NjhD?=
 =?utf-8?B?T2Y1cHdSRFZtTGZwL3cyMzdBcTZOTFJHbERnelE3dERndUNjVEtXNUljeTZm?=
 =?utf-8?B?Zzh3bCs0Y0hIdngwVEhxbFUxT05aVFBRQ0F4QmVSMnFqNVFNMWd0dWtyZGNW?=
 =?utf-8?B?TEh6RDdJdE0xUWVZR0d3UGRlV3FYTWJoTkRZdU03VmViaG45UW4rK2R6ZWRD?=
 =?utf-8?B?OUk2bUhVdnlRTkZJclNIRkE4eklrTTBCekRqa2QycUVNT29uR1V3eVNlcito?=
 =?utf-8?B?aVdDNXZ0OFdwQVlTRnM5emV2Y1VDbmUxUXNQNEdUaUhCcENnOTlVVlBvT3FL?=
 =?utf-8?B?REJXR1AzYmgxT2NGMDNiTXpXRldhVXVhZlVHQkRsUEdLdmU1a29McC9aQjQ0?=
 =?utf-8?B?MjF3d0pWclZCbkJBSHZrcU0ybGhleGN3TzVzV0Izc2VZT2czL3A0N25vSDc1?=
 =?utf-8?B?QmVuOXhrOGtHNmY3OG5zbzFOTFk1UXd3S3BId1RMbFI3ZGN0cHVaN0orQ0Ev?=
 =?utf-8?B?bC8rTnZYR0hyZVV2SUt0U2RVK1FKRlhBMHFRSGRVb2U3VVhJSUxLTmt0Sys3?=
 =?utf-8?B?cFFrZlBJd0pJRWYzMVA0TndYbVA5TTFuajhRVlhDZUFUTVZNU2RFaFZUV0dP?=
 =?utf-8?B?WmljdDBDTHNya1lWZVdtc2h4SFNzWmU2TEZIMnIrVkdhUFltMDJtQ1dPZFA3?=
 =?utf-8?B?ejBKVzBGbXkrRU81ODZzOGZCRW1XRU94bDhwaXcyOWttakFzdGg2MVF6SXhD?=
 =?utf-8?B?QkdMdERTWWFDNU8yZTUxeFRaeWtIZDkvUXZPdkE0V1MwVnBaallBZTV0cC9M?=
 =?utf-8?B?dlk2cEJyN1JsSU9FOERPZlhlZzJJVEJ1ZWUwUHUyZWpLdUx4RFZ6ZW1LeWNN?=
 =?utf-8?B?bWx4L21VZk5YRU1uWG5jR2tXVThPSmlCMUsyRVlDbVBTa0QxNUoybEk1cDg3?=
 =?utf-8?B?U0lSdUVtZlBpQkZkdkxLbzVCRktaN2l1VTlmdmhyOVNUMHltUXJrb1VHcmFz?=
 =?utf-8?B?RWNhQTc1ZWk5N0RBTnFtMWtjWWxGd1Jvalh4bUtmNE02MkFCbG45N0lQZ1NT?=
 =?utf-8?B?azEzeDNyZ2JhdEs2ODVRTlJFTDJWdlpoUjdSQnFkWEMxYkhVdjZJT0pJM3ND?=
 =?utf-8?B?aURtSmdXN2tVblBtK1FpUHpIQU1oNEpiK2RycUYzVXlyYjJRbUU4MnRhSlg2?=
 =?utf-8?B?QjFGNWdhSExPWXM5Q3p1MXorU2RRanVvWTRsZjJxNjJ1VEl3MW9zWmpOZ0dj?=
 =?utf-8?B?aGtRRG9GQkR1NHp1RkRoYTRrS1pwRmtsczRZZFZCeTZhVGRsVkhCdEI2dm1t?=
 =?utf-8?B?aUV2TGdpQlpYei9oMG1NZlFCdFZqcWM3a3FQZmcrRm8xZ21tVXJBWEtHNThQ?=
 =?utf-8?B?U1BUTEE1bUYrVW9LamZYZmZFQ1Z5dVdrU3hrOFFLNUowSitOZEgwUGdCQUdx?=
 =?utf-8?B?Q2FGdVhyenFzWmhleXR2eGlJcEJRNzhrNFJMaXVTRjUxRzdPSGVjdHMxTTZR?=
 =?utf-8?B?dnlOSjR0MXlkOHdiMUN5eG1ZZm92Z0hiZW5zZ1czdk85bkZRZDVaR2lCUG15?=
 =?utf-8?Q?dXro=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB6962.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24de781e-dcf0-4aa7-289b-08db3f5a46bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 15:41:56.9087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oa/7ODjaqDGjDZxVpT0vWxP1RbeusEf1amsUEj2xyaCctO4yzdgiIy+JaLmdQ27FEcq77NRqbVSwiTV4YMYhbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8860
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhpLA0KDQpUaGUgY2hhbmdlIGFw
cGxpZXMgdG8gYWxsIEFNRCBHUFUgQVNJQy4NClBsZWFzZSBjb21tdW5pY2F0ZSB3aXRoIGlzc3Vl
IHJlcG9ydGVyIHRvIHNlZSBpZiB0aGUgaXNzdWUgY291bGQgYmUgcmVwcm9kdWNlZCBvbGRlciBB
U0lDLCBsaWtlIE1lbmRvY2lubywgQ1pOLg0KDQpUaGFua3MhDQpIZXJzZW4NCg0KDQotLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogTWFoZm9veiwgSGFtemEgPEhhbXphLk1haGZvb3pA
YW1kLmNvbT4gDQpTZW50OiBNb25kYXksIEFwcmlsIDE3LCAyMDIzIDExOjI2IEFNDQpUbzogS29l
bmlnLCBDaHJpc3RpYW4gPENocmlzdGlhbi5Lb2VuaWdAYW1kLmNvbT47IGFtZC1nZnhAbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnDQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgV2VudGxhbmQsIEhh
cnJ5IDxIYXJyeS5XZW50bGFuZEBhbWQuY29tPjsgTGksIFN1biBwZW5nIChMZW8pIDxTdW5wZW5n
LkxpQGFtZC5jb20+OyBTaXF1ZWlyYSwgUm9kcmlnbyA8Um9kcmlnby5TaXF1ZWlyYUBhbWQuY29t
PjsgRGV1Y2hlciwgQWxleGFuZGVyIDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPjsgUGFuLCBY
aW5odWkgPFhpbmh1aS5QYW5AYW1kLmNvbT47IERhdmlkIEFpcmxpZSA8YWlybGllZEBnbWFpbC5j
b20+OyBEYW5pZWwgVmV0dGVyIDxkYW5pZWxAZmZ3bGwuY2g+OyBQaWxsYWksIEF1cmFiaW5kbyA8
QXVyYWJpbmRvLlBpbGxhaUBhbWQuY29tPjsgWmh1bywgUWluZ3FpbmcgKExpbGxpYW4pIDxRaW5n
cWluZy5aaHVvQGFtZC5jb20+OyBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUByZWRoYXQuY29tPjsg
V3UsIEhlcnNlbiA8aGVyc2VueHMud3VAYW1kLmNvbT47IFdhbmcsIENoYW8ta2FpIChTdHlsb24p
IDxTdHlsb24uV2FuZ0BhbWQuY29tPjsgVHVpa292LCBMdWJlbiA8THViZW4uVHVpa292QGFtZC5j
b20+OyBkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIXSBkcm0vYW1kL2Rpc3BsYXk6IGZpeCBmbGlj
a2VyaW5nIGNhdXNlZCBieSBTL0cgbW9kZQ0KDQoNCk9uIDQvMTcvMjMgMTE6MDMsIENocmlzdGlh
biBLw7ZuaWcgd3JvdGU6DQo+IEFtIDE3LjA0LjIzIHVtIDE2OjUxIHNjaHJpZWIgSGFtemEgTWFo
Zm9vejoNCj4+DQo+PiBPbiA0LzE3LzIzIDAxOjU5LCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOg0K
Pj4+IEFtIDE0LjA0LjIzIHVtIDIxOjMzIHNjaHJpZWIgSGFtemEgTWFoZm9vejoNCj4+Pj4gQ3Vy
cmVudGx5LCB3ZSBhbGxvdyB0aGUgZnJhbWVidWZmZXIgZm9yIGEgZ2l2ZW4gcGxhbmUgdG8gbW92
ZSANCj4+Pj4gYmV0d2VlbiBtZW1vcnkgZG9tYWlucywgaG93ZXZlciB3aGVuIHRoYXQgaGFwcGVu
cyBpdCBjYXVzZXMgdGhlIA0KPj4+PiBzY3JlZW4gdG8gZmxpY2tlciwgaXQgaXMgZXZlbiBwb3Nz
aWJsZSBmb3IgdGhlIGZyYW1lYnVmZmVyIHRvIA0KPj4+PiBjaGFuZ2UgbWVtb3J5IGRvbWFpbnMg
b24gZXZlcnkgcGxhbmUgdXBkYXRlIChjYXVzaW5nIGEgY29udGludW91cyBmbGlja2VyIGVmZmVj
dCkuDQo+Pj4+IFNvLA0KPj4+PiB0byBmaXggdGhpcywgZG9uJ3QgcGVyZm9ybSBhbiBpbW1lZGlh
dGUgZmxpcCBpbiB0aGUgYWZvcmVtZW50aW9uZWQgDQo+Pj4+IGNhc2UuDQo+Pj4NCj4+PiBUaGF0
IHNvdW5kcyBzdHJvbmdseSBsaWtlIHlvdSBqdXN0IGZvcmdldCB0byB3YWl0IGZvciB0aGUgbW92
ZSB0byANCj4+PiBmaW5pc2ghDQo+Pj4NCj4+PiBXaGF0IGlzIHRoZSBvcmRlciBvZiB0aGluZ3Mg
ZG9uZSBoZXJlPyBFLmcuIHdobyBjYWxscyANCj4+PiBhbWRncHVfYm9fcGluKCkgYW5kIHdobyB3
YWl0cyBmb3IgZmVuY2VzIGZvciBmaW5pc2ggc2lnbmFsaW5nPyBJcyANCj4+PiB0aGF0IG1heWJl
IGp1c3QgaW4gdGhlIHdyb25nIG9yZGVyPw0KPj4NCj4+IFRoZSBwaW5uaW5nIGxvZ2ljIGlzIGlu
IGRtX3BsYW5lX2hlbHBlcl9wcmVwYXJlX2ZiKCkuIEFsc28sIGl0IHNlZW1zIA0KPj4gbGlrZSB3
ZSB3YWl0IGZvciB0aGUgZmVuY2VzIGluIGFtZGdwdV9kbV9hdG9taWNfY29tbWl0X3RhaWwoKSwg
dXNpbmcgDQo+PiBkcm1fYXRvbWljX2hlbHBlcl93YWl0X2Zvcl9mZW5jZXMoKS4gVGhlIG9yZGVy
aW5nIHNob3VsZCBiZSBmaW5lIGFzIA0KPj4gd2VsbCwgc2luY2UgcHJlcGFyZV9mYigpIGlzIGFs
d2F5cyBjYWxsZWQgYmVmb3JlIGF0b21pY19jb21taXRfdGFpbCgpLg0KPiANCj4gT2ssIHRoZW4g
d2h5IGlzIHRoZXJlIGFueSBmbGlja2VyaW5nPw0KPiANCj4gQlRXIHJlc2VydmluZyBhIGZlbmNl
IHNsb3QgaXMgY29tcGxldGVseSB1bm5lY2Vzc2FyeS4gVGhhdCBsb29rcyBsaWtlIA0KPiB5b3Ug
Y29weSZwYXN0ZWQgdGhlIGNvZGUgZnJvbSBzb21ld2hlcmUgZWxzZSB3aXRob3V0IGNoZWNraW5n
IHdoYXQgaXQgDQo+IGFjdHVhbGx5IGRvZXMuDQoNCkl0IHNlZW1lZCBsaWtlIGl0IHdhcyBuZWNl
c3NhcnkgdG8gcmVhZCBgdGJvLnJlc291cmNlYCBzaW5jZSB0aGUgZG9jdW1lbnRhdGlvbiBmb3Ig
YHN0cnVjdCB0dG1fYnVmZmVyX29iamVjdGAgbWFrZXMgbWVudGlvbiBvZiBhICJibzo6cmVzdjo6
cmVzZXJ2ZWQiIGxvY2suDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IENocmlzdGlhbi4NCj4gDQo+Pg0K
Pj4+DQo+Pj4gUmVnYXJkcywNCj4+PiBDaHJpc3RpYW4uDQo+Pj4NCj4+Pj4NCj4+Pj4gQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4+Pj4gRml4ZXM6IDgxZDBiY2Y5OTAwOSAoImRybS9hbWRn
cHU6IG1ha2UgZGlzcGxheSBwaW5uaW5nIG1vcmUgDQo+Pj4+IGZsZXhpYmxlDQo+Pj4+ICh2Miki
KQ0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBIYW16YSBNYWhmb296IDxoYW16YS5tYWhmb296QGFtZC5j
b20+DQo+Pj4+IC0tLQ0KPj4+PiDCoCAuLi4vZ3B1L2RybS9hbWQvZGlzcGxheS9hbWRncHVfZG0v
YW1kZ3B1X2RtLmMgfCA0MQ0KPj4+PiArKysrKysrKysrKysrKysrKystDQo+Pj4+IMKgIDEgZmls
ZSBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4+Pg0KPj4+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5L2FtZGdwdV9kbS9hbWRncHVf
ZG0uYw0KPj4+PiBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvZGlzcGxheS9hbWRncHVfZG0vYW1kZ3B1
X2RtLmMNCj4+Pj4gaW5kZXggZGEzMDQ1ZmRjYjZkLi45YTRlNzQwODM4NGEgMTAwNjQ0DQo+Pj4+
IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvZGlzcGxheS9hbWRncHVfZG0vYW1kZ3B1X2RtLmMN
Cj4+Pj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5L2FtZGdwdV9kbS9hbWRncHVf
ZG0uYw0KPj4+PiBAQCAtNzg5Nyw2ICs3ODk3LDM0IEBAIHN0YXRpYyB2b2lkIGFtZGdwdV9kbV9j
b21taXRfY3Vyc29ycyhzdHJ1Y3QgDQo+Pj4+IGRybV9hdG9taWNfc3RhdGUgKnN0YXRlKQ0KPj4+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBhbWRncHVfZG1fcGxhbmVfaGFuZGxlX2N1cnNv
cl91cGRhdGUocGxhbmUsDQo+Pj4+IG9sZF9wbGFuZV9zdGF0ZSk7DQo+Pj4+IMKgIH0NCj4+Pj4g
K3N0YXRpYyBpbmxpbmUgdWludDMyX3QgZ2V0X21lbV90eXBlKHN0cnVjdCBhbWRncHVfZGV2aWNl
ICphZGV2LA0KPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Ry
dWN0IGRybV9nZW1fb2JqZWN0ICpvYmosDQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBib29sIGNoZWNrX2RvbWFpbikgew0KPj4+PiArwqDCoMKgIHN0cnVjdCBh
bWRncHVfYm8gKmFibyA9IGdlbV90b19hbWRncHVfYm8ob2JqKTsNCj4+Pj4gK8KgwqDCoCB1aW50
MzJfdCBtZW1fdHlwZTsNCj4+Pj4gKw0KPj4+PiArwqDCoMKgIGlmICh1bmxpa2VseShhbWRncHVf
Ym9fcmVzZXJ2ZShhYm8sIHRydWUpKSkNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAwOw0K
Pj4+PiArDQo+Pj4+ICvCoMKgwqAgaWYgKHVubGlrZWx5KGRtYV9yZXN2X3Jlc2VydmVfZmVuY2Vz
KGFiby0+dGJvLmJhc2UucmVzdiwgMSkpKQ0KPj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBlcnI7
DQo+Pj4+ICsNCj4+Pj4gK8KgwqDCoCBpZiAoY2hlY2tfZG9tYWluICYmDQo+Pj4+ICvCoMKgwqDC
oMKgwqDCoCBhbWRncHVfZGlzcGxheV9zdXBwb3J0ZWRfZG9tYWlucyhhZGV2LCBhYm8tPmZsYWdz
KSAhPQ0KPj4+PiArwqDCoMKgwqDCoMKgwqAgKEFNREdQVV9HRU1fRE9NQUlOX1ZSQU0gfCBBTURH
UFVfR0VNX0RPTUFJTl9HVFQpKQ0KPj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBlcnI7DQo+Pj4+
ICsNCj4+Pj4gK8KgwqDCoCBtZW1fdHlwZSA9IGFiby0+dGJvLnJlc291cmNlLT5tZW1fdHlwZTsN
Cj4+Pj4gK8KgwqDCoCBhbWRncHVfYm9fdW5yZXNlcnZlKGFibyk7DQo+Pj4+ICsNCj4+Pj4gK8Kg
wqDCoCByZXR1cm4gbWVtX3R5cGU7DQo+Pj4+ICsNCj4+Pj4gK2VycjoNCj4+Pj4gK8KgwqDCoCBh
bWRncHVfYm9fdW5yZXNlcnZlKGFibyk7DQo+Pj4+ICvCoMKgwqAgcmV0dXJuIDA7DQo+Pj4+ICt9
DQo+Pj4+ICsNCj4+Pj4gwqAgc3RhdGljIHZvaWQgYW1kZ3B1X2RtX2NvbW1pdF9wbGFuZXMoc3Ry
dWN0IGRybV9hdG9taWNfc3RhdGUgDQo+Pj4+ICpzdGF0ZSwNCj4+Pj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBkY19zdGF0ZSAqZGNfc3RhdGUsDQo+
Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZHJt
X2RldmljZSAqZGV2LCBAQCAtNzkxNiw2ICs3OTQ0LDcgQEAgDQo+Pj4+IHN0YXRpYyB2b2lkIGFt
ZGdwdV9kbV9jb21taXRfcGxhbmVzKHN0cnVjdCBkcm1fYXRvbWljX3N0YXRlICpzdGF0ZSwgDQo+
Pj4+IHRvX2RtX2NydGNfc3RhdGUoZHJtX2F0b21pY19nZXRfb2xkX2NydGNfc3RhdGUoc3RhdGUs
IHBjcnRjKSk7DQo+Pj4+IMKgwqDCoMKgwqAgaW50IHBsYW5lc19jb3VudCA9IDAsIHZwb3MsIGhw
b3M7DQo+Pj4+IMKgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4+Pj4gK8KgwqDCoCB1
aW50MzJfdCBtZW1fdHlwZTsNCj4+Pj4gwqDCoMKgwqDCoCB1MzIgdGFyZ2V0X3ZibGFuaywgbGFz
dF9mbGlwX3ZibGFuazsNCj4+Pj4gwqDCoMKgwqDCoCBib29sIHZycl9hY3RpdmUgPSBhbWRncHVf
ZG1fY3J0Y192cnJfYWN0aXZlKGFjcnRjX3N0YXRlKTsNCj4+Pj4gwqDCoMKgwqDCoCBib29sIGN1
cnNvcl91cGRhdGUgPSBmYWxzZTsNCj4+Pj4gQEAgLTgwMzUsMTMgKzgwNjQsMjEgQEAgc3RhdGlj
IHZvaWQgYW1kZ3B1X2RtX2NvbW1pdF9wbGFuZXMoc3RydWN0IA0KPj4+PiBkcm1fYXRvbWljX3N0
YXRlICpzdGF0ZSwNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQ0KPj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqAgfQ0KPj4+PiArwqDCoMKgwqDCoMKgwqAgbWVtX3R5cGUgPSBnZXRfbWVt
X3R5cGUoZG0tPmFkZXYsIA0KPj4+PiArb2xkX3BsYW5lX3N0YXRlLT5mYi0+b2JqWzBdLA0KPj4+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHJ1ZSk7DQo+Pj4+ICsN
Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIC8qDQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgICog
T25seSBhbGxvdyBpbW1lZGlhdGUgZmxpcHMgZm9yIGZhc3QgdXBkYXRlcyB0aGF0IGRvbid0DQo+
Pj4+IC3CoMKgwqDCoMKgwqDCoMKgICogY2hhbmdlIEZCIHBpdGNoLCBEQ0Mgc3RhdGUsIHJvdGF0
aW9uIG9yIG1pcnJvaW5nLg0KPj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqIGNoYW5nZSBtZW1vcnkg
ZG9tYWluLCBGQiBwaXRjaCwgRENDIHN0YXRlLCByb3RhdGlvbiBvcg0KPj4+PiArwqDCoMKgwqDC
oMKgwqDCoCAqIG1pcnJvcmluZy4NCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgIGJ1bmRsZS0+ZmxpcF9hZGRyc1twbGFuZXNfY291bnRdLmZsaXBf
aW1tZWRpYXRlID0NCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3J0Yy0+c3RhdGUt
PmFzeW5jX2ZsaXAgJiYNCj4+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYWNydGNfc3RhdGUt
PnVwZGF0ZV90eXBlID09IFVQREFURV9UWVBFX0ZBU1Q7DQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGFjcnRjX3N0YXRlLT51cGRhdGVfdHlwZSA9PSBVUERBVEVfVFlQRV9GQVNUICYmDQo+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICghbWVtX3R5cGUgfHwgKG1lbV90eXBlICYmIGdl
dF9tZW1fdHlwZShkbS0+YWRldiwNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZiLT5vYmpbMF0sDQo+Pj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBmYWxzZSkgPT0NCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIG1lbV90eXBlKSk7DQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCB0aW1lc3RhbXBfbnMg
PSBrdGltZV9nZXRfbnMoKTsNCj4+Pj4gYnVuZGxlLT5mbGlwX2FkZHJzW3BsYW5lc19jb3VudF0u
ZmxpcF90aW1lc3RhbXBfaW5fdXMgPQ0KPj4+PiBkaXZfdTY0KHRpbWVzdGFtcF9ucywgMTAwMCk7
DQo+Pj4NCj4gDQotLQ0KSGFtemENCg==
