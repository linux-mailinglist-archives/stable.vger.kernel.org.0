Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250864C77F9
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbiB1Sig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240652AbiB1SiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:38:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D1C9EB97;
        Mon, 28 Feb 2022 10:24:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfyQ/BU+2Ue1loQnFNRqwjSU6UAPhBO49Q7lf4GsVAWB7ErdtUGUBtY+/7kIpcYdukoZeWx7rl80lFY8A96ZOUNCaR1VgRV/LnUFONrweRS//twRRwWNs3BMCXouMyEQLhJucCfakcZd7vmVg4JYUtirYNoKxouH2tryF1tuSgM7mG5wz0llHPFwgSga5zhsLDIwptVVwLmfl8hMaZ3T1HmeHHWq/z7or2yUagS/ViR5nLOD0umpdOwf9j97ZxcTAHSsKZSbcULfp0uZe6e9qo0B+q2pqXC4iwfuN8G+f0dJ9dx4q4sBx938XQJ+O2IAaQhNeXaIAZXaOsr8E0RKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AS0t0lN7YyjefmOjBWTDBxAYndosjh8nThiwuBeliE=;
 b=c3Scb0MXAPHmK+F7h8BGd4fFmdQ+YSPPhhgRy2m91xBunoYtoEFBI7qxlThKM9a4UuvwoM2JBhrKib1dtUQ66Ws338Dbn1m6p8LVLYmqpYCFaJ/Ov230KkvFsMNq2YgFtPJn1j6CgiB6XofNN2JnbQdHeCIqM0pQ2D/HNXJJ49p2EAhRjHn4CaDF74BXunYJRxCakvwx4oFDmOSGfQ+d3uGaEBwVwoBjmtiBXNDm05FSOIp6zrxVMdtabAWk7iqf+STFfTTh/hUW6nxN1KxUipaquNs5Rvyxn2tWO+ENvPVa2gb5Us5G1wAONl+eCwN7sIeoFOS2BTwJ4jvfYC9Sxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AS0t0lN7YyjefmOjBWTDBxAYndosjh8nThiwuBeliE=;
 b=Kiq2ReEhWlJkACmXFCSb4tzHgOCrqCDfRGnxhxK5LgyhlZSrW3i9q7kRLTebcY0oXJ5Rr2/47YBFVHKcrgghA5hNpLfmJjTVfnCZm1HL1hbvG8BCI+1Yju54dJoYLybOkcf37L0R/maiJ6F3fGiISIcQgOZgR9r65hXx6oTOzK4=
Received: from BN9PR12MB5146.namprd12.prod.outlook.com (2603:10b6:408:137::16)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 18:24:54 +0000
Received: from BN9PR12MB5146.namprd12.prod.outlook.com
 ([fe80::8147:cc0e:8aa7:89ba]) by BN9PR12MB5146.namprd12.prod.outlook.com
 ([fe80::8147:cc0e:8aa7:89ba%3]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 18:24:53 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Yu, Qiang" <Qiang.Yu@amd.com>
Subject: RE: [PATCH 5.16 022/164] drm/amdgpu: check vm ready by
 amdgpu_vm->evicting flag
Thread-Topic: [PATCH 5.16 022/164] drm/amdgpu: check vm ready by
 amdgpu_vm->evicting flag
Thread-Index: AQHYLMrqjsThsGgMfEiEL6OczByVFKypRyqg
Date:   Mon, 28 Feb 2022 18:24:53 +0000
Message-ID: <BN9PR12MB5146C35D7EE1B6AD23E2503BF7019@BN9PR12MB5146.namprd12.prod.outlook.com>
References: <20220228172359.567256961@linuxfoundation.org>
 <20220228172402.072667800@linuxfoundation.org>
In-Reply-To: <20220228172402.072667800@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-02-28T18:24:15Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=6fae7842-deac-45f8-967d-eb65252af2b5;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-02-28T18:24:50Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 43fed859-8527-47b6-8f71-566ae52b2733
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89e7e673-18ac-4a4b-250c-08d9fae79db5
x-ms-traffictypediagnostic: CH2PR12MB4198:EE_
x-microsoft-antispam-prvs: <CH2PR12MB4198108B45408F620C93D998F7019@CH2PR12MB4198.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYcrnxf7rpokDUF/VjZYyt0/z3mWrVtorJgJmoHtIHiVaFJrzS61LO4mMhBEsw3TbQa5Nnct1rroln9EnxJe8rNzPnmpAgX5J3A0vMVP2dgs46j1ipmTpkQ6k9l4iMRe1bQtBo7ssBcFUu5/Udh5HCweNyv+VVeFVjWgnJ+j2mpgptLag2uOTqU70ZrNgWZWcSgegMO6K42TxhoJ5XvZlY7L6Rr12cuv2RixeHPLm4Q+KSdXFd65ECe+7mVWcU74g2tiau2A9QuBQJkGJRyCPjX8Iu4W7dtNNYQhZ8mP54JA/fqWwyuNNZNGtMhSV/Dov2IQPhVoMJY5yHF4fR+FyBcLiuZyKRCyAiQdnzUEl+T52cZE7uVIJtgyF/0UHyrcyCoG1qCpGNx+wxSEufWC/+k1LBT4QBPUdhrAYuC35n3RviRbzTQWEOwbybAHC6nlObdvU2y45dPD3rSfjsGWFrGC09H9tC4XEmh20/Yj2cMdEQ1rkf64DsNjTy+uiS5pEXAw4lRQosdfIcFd4zc0RBbypDAOrSX/Ex/xIpB6lbniXXLgcOm9z1dpYlNaN/UUTUEYD52XiJFXlr+5lxaSY+XMR942cNzzR3SiR8pDcrmTZt4TxVYY9CRM6TU/wYTMtSOOlviY+Y197HCO1WZ6G9EzL0Y0HhFiSPknNfstzTRQlaGqMi+UvNYXHt8gVck+x48qFlneJWYYQnr2lebhUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5146.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(5660300002)(38070700005)(52536014)(7696005)(316002)(8936002)(26005)(66476007)(66556008)(66446008)(64756008)(76116006)(8676002)(2906002)(186003)(66946007)(33656002)(6506007)(38100700002)(53546011)(66574015)(71200400001)(4326008)(122000001)(508600001)(55016003)(83380400001)(54906003)(110136005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGZHSFBUdThTWUtiWmNXZW9yOHBOQVFDN3pLK0w0TlhaT00wVG1rMHRKZlhy?=
 =?utf-8?B?cW1SZzZ0ZXZ0RnkyL1o5N00zODYvY0Rtd3VZZkgxTUk4c2hsRGZwdXJBb1FF?=
 =?utf-8?B?VnBSNzZOS0E3YTVJY05Qangvb1ZEMVF4TEd4NjMvTGN0cnp0OFFLMkJzTXRj?=
 =?utf-8?B?NzhJQXdnb09aamo5NFdnM1ZNVXVjeXNSVWE3eWJydUw4Nk4raFdxckRUcS9u?=
 =?utf-8?B?SnhxRWtla3djRTVydXhhM1VFL2lKOTVpQzVpeGtIZEEzaUZOcm5sRmVPU3VN?=
 =?utf-8?B?Z0VhQVVxWVJhdE5rdXJ0VnlkRENyZjhrMDlSbzd6bzg0L0lwdVJKMThGTXVo?=
 =?utf-8?B?dFA5T2lwZjIvREhSZC80eVFkVW8zZ2dmUGhQNCt1dlVCNDdsQVJ6VStMKzRR?=
 =?utf-8?B?NU5xTy9hQmpSTk04TStiRkVQZjFxUEF2dEJaYWxhbVpocVMvblB2V2tRV2pl?=
 =?utf-8?B?dEJUdFdsUzhra2wrSkFzQVlMSHlCOFhCL1JNRTJZTkEydE9VRUZmRnQ2a3o5?=
 =?utf-8?B?MlVnbE9HdWJrbmVtTTZqOThLS0RKb253eTQrNDV2enNCMHZNSkJodldLZktu?=
 =?utf-8?B?VEx4anJsWTYyc1hXd0pUOHF6dzR0a2g1NmV2TkVBU09mek9rN28velJXNito?=
 =?utf-8?B?eE1NVlJJTnliQklSOXlHR1NPZmRGU1phcVFQSjIxYXExalFEMEgranRvSUE1?=
 =?utf-8?B?eWs2Q3QrN2NscFNjelkvN1dXWTRYSzlqRmFZZzVidzcrd3QyMGZBUkR6Z1pJ?=
 =?utf-8?B?bmp2eDJ4QmlmdUg1VjRGL1hUb0hxQzhpUlRRdWZ0ZStLREJQZzRBV0Z2NmZW?=
 =?utf-8?B?RkJ4Y3Q3WThYUWJBSmNOTHRVYzVtTnFnSE12K0loWjB3Umd2UGpRYVlqNUNY?=
 =?utf-8?B?eVppR2RDbzA4Wi8xakNjU3hOTGFyQlZOaGJrQ2Jnc1FIcVE4NEZreWh3enJI?=
 =?utf-8?B?RGgxRFhGMEJJYUwyL2s1UjlHUFB1SXViOXdKWU5sSjhHVVBTV1RqN1pnNlRl?=
 =?utf-8?B?cTRFOTAwYUwvb2ZmYzNCeGRyNGtyWlcwcnJXeGUwdCsxMHhORVQ0Ty9vVkla?=
 =?utf-8?B?VXZqeVF4cnM5M2tJSjdPL2t4U1BZK1JXdEJSZGhWYjBDZnBZKzlDM1E2d0pW?=
 =?utf-8?B?dVhULzBzK285dDU1Q0F6dnlEamh6OTNydm9jbTExeEJyMFJndTk0WW9KRG9D?=
 =?utf-8?B?QWoxQUF6Q0srcGFqQ0M0NHkxdGVFZHdpSDJ0czVGWlRid2VYTkE1WjN5K3ZI?=
 =?utf-8?B?ZkJCM0U3TndSVDkrMTN5dTB0U21vMTlhVGxEZG1CYmpBb3ByV0t2a3E0OUNJ?=
 =?utf-8?B?b1ZFUmNGQnlZTmRtUVlIdWN1R1ZYV01qWWFteW4rejZ5cEQxNFRwRWVpMVhR?=
 =?utf-8?B?eTNSZXJGNkszZU5JdE0vOHEzc2h3R2grdXJkbXRIUVJzRW5qdU9rQ2VhaVcv?=
 =?utf-8?B?QmR1QkE1WU51VmtLR0lpcGszSHp5VWZyMEY4RkdzaG1XQUhucU4xSUlGeXpY?=
 =?utf-8?B?clgxNGF0bUpLTm41R0xlb3YyejNMK3VJSWxpd1k5dmJ4anQ4SXkrNEFQTzht?=
 =?utf-8?B?TWlTeWRrcGQ4NDVRUHBQallURjF4UHJCSkY1d2JKNXJyNjNlU1NIRUZiWS9i?=
 =?utf-8?B?alhlazlVQWdWZTRicnlmR1E0TWJsb3g2d2sweDBKMXpKWTU3N3RtVkRJcy91?=
 =?utf-8?B?bGNOSWcvOFJGTnBBRmtmSmZaY2s0b0YxRlQxM3htQnpnRElJK3JCWkJtNnBi?=
 =?utf-8?B?L1U0aEpIdGVPWXVYWTJPQ3M2SklGbHpENWo3aWJENmV1RmYvYWhaanQvU1BB?=
 =?utf-8?B?R1lnbVl2ai9BZ2YyKzhXekc1YzRvQ2tvb3M0ZkNOSVh2SWU1RS9TN21kbjhz?=
 =?utf-8?B?SUIwVU9QR1cyM0YyalJxN3o5d3A1cEZkRDNNaDVrc3RPNkRrYTFtSEhvb0kz?=
 =?utf-8?B?TnJSQ1ZNc2ROc0RDUHVvWi9UVTBwVGJHN3ZBQjBJSi9hcUdYdHNzM1NWdWVm?=
 =?utf-8?B?bEhFMFozcmJ6c0RFSTNaaDhLbnU5a1FvcVNBR0VDSGRLdnV0MHlZTHdLWU52?=
 =?utf-8?B?eStLSld3YVNISkNnbVdEcDFrVWIySkJ5by9WVHd0c0draytYRmQvUW8rOGdM?=
 =?utf-8?B?UkNnOXRLQkVoMjdxa0NaazFsUXk4Snp2bjNQQXhVcGFVdnVLaWhUSWF4emRj?=
 =?utf-8?Q?2ZXFK95VA2YTMySPBXF9Hro=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5146.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e7e673-18ac-4a4b-250c-08d9fae79db5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 18:24:53.9294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OppUg640ezqijg8s3gElfTRBChUFvwmQtDS5YawoFELizNDF8/ZzL6KDwJONTuYFNcXMm4G865h63twz7WqX4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBNb25kYXks
IEZlYnJ1YXJ5IDI4LCAyMDIyIDEyOjIzIFBNDQo+IFRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IENjOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24u
b3JnPjsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9s
Z2VuLm1wZy5kZT47IEtvZW5pZywNCj4gQ2hyaXN0aWFuIDxDaHJpc3RpYW4uS29lbmlnQGFtZC5j
b20+OyBZdSwgUWlhbmcgPFFpYW5nLll1QGFtZC5jb20+Ow0KPiBEZXVjaGVyLCBBbGV4YW5kZXIg
PEFsZXhhbmRlci5EZXVjaGVyQGFtZC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCA1LjE2IDAyMi8x
NjRdIGRybS9hbWRncHU6IGNoZWNrIHZtIHJlYWR5IGJ5DQo+IGFtZGdwdV92bS0+ZXZpY3Rpbmcg
ZmxhZw0KPiANCj4gRnJvbTogUWlhbmcgWXUgPHFpYW5nLnl1QGFtZC5jb20+DQo+IA0KPiBjb21t
aXQgYzFhNjZjM2JjNDI1ZmY5Mzc3NGZiMmY2ZWVmYTY3YjgzMTcwZGQ3ZSB1cHN0cmVhbS4NCj4g
DQo+IFdvcmtzdGF0aW9uIGFwcGxpY2F0aW9uIEFOU0EvTUVUQSB2MjEuMS40IGdldCB0aGlzIGVy
cm9yIGRtZXNnIHdoZW4NCj4gcnVubmluZyBDSSB0ZXN0IHN1aXRlIHByb3ZpZGVkIGJ5IEFOU0Ev
TUVUQToNCj4gW2RybTphbWRncHVfZ2VtX3ZhX2lvY3RsIFthbWRncHVdXSAqRVJST1IqIENvdWxk
bid0IHVwZGF0ZSBCT19WQSAoLQ0KPiAxNikNCj4gDQo+IFRoaXMgaXMgY2F1c2VkIGJ5Og0KPiAx
LiBjcmVhdGUgYSAyNTZNQiBidWZmZXIgaW4gaW52aXNpYmxlIFZSQU0gMi4gQ1BVIG1hcCB0aGUg
YnVmZmVyIGFuZCBhY2Nlc3MNCj4gaXQgY2F1c2VzIHZtX2ZhdWx0IGFuZCB0cnkgdG8gbW92ZQ0K
PiAgICBpdCB0byB2aXNpYmxlIFZSQU0NCj4gMy4gZm9yY2UgdmlzaWJsZSBWUkFNIHNwYWNlIGFu
ZCB0cmF2ZXJzZSBhbGwgVlJBTSBib3MgdG8gY2hlY2sgaWYNCj4gICAgZXZpY3RpbmcgdGhpcyBi
byBpcyB2YWx1YWJsZQ0KPiA0LiB3aGVuIGNoZWNraW5nIGEgVk0gYm8gKGluIGludmlzaWJsZSBW
UkFNKSwgYW1kZ3B1X3ZtX2V2aWN0YWJsZSgpDQo+ICAgIHdpbGwgc2V0IGFtZGdwdV92bS0+ZXZp
Y3RpbmcsIGJ1dCBsYXR0ZXIgZHVlIHRvIG5vdCBpbiB2aXNpYmxlDQo+ICAgIFZSQU0sIHdvbid0
IHJlYWxseSBldmljdCBpdCBzbyBub3QgYWRkIGl0IHRvIGFtZGdwdV92bS0+ZXZpY3RlZCA1LiBi
ZWZvcmUNCj4gbmV4dCBDUyB0byBjbGVhciB0aGUgYW1kZ3B1X3ZtLT5ldmljdGluZywgdXNlciBW
TSBvcHMNCj4gICAgaW9jdGwgd2lsbCBwYXNzIGFtZGdwdV92bV9yZWFkeSgpIChjaGVjayBhbWRn
cHVfdm0tPmV2aWN0ZWQpDQo+ICAgIGJ1dCBmYWlsIGluIGFtZGdwdV92bV9ib191cGRhdGVfbWFw
cGluZygpIChjaGVjaw0KPiAgICBhbWRncHVfdm0tPmV2aWN0aW5nKSBhbmQgZ2V0IHRoaXMgZXJy
b3IgbG9nDQo+IA0KPiBUaGlzIGVycm9yIHdvbid0IGFmZmVjdCBmdW5jdGlvbmFsaXR5IGFzIG5l
eHQgQ1Mgd2lsbCBmaW5pc2ggdGhlIHdhaXRpbmcgVk0gb3BzLg0KPiBCdXQgd2UnZCBiZXR0ZXIg
Y2xlYXIgdGhlIGVycm9yIGxvZyBieSBjaGVja2luZyB0aGUgYW1kZ3B1X3ZtLT5ldmljdGluZyBm
bGFnDQo+IGluIGFtZGdwdV92bV9yZWFkeSgpIHRvIHN0b3AgY2FsbGluZw0KPiBhbWRncHVfdm1f
Ym9fdXBkYXRlX21hcHBpbmcoKSBsYXRlci4NCj4gDQo+IEFub3RoZXIgcmVhc29uIGlzIGFtZGdw
dV92bS0+ZXZpY3RlZCBsaXN0IGhvbGRzIGFsbCBCT3MgKGJvdGggdXNlciBidWZmZXINCj4gYW5k
IHBhZ2UgdGFibGUpLCBidXQgb25seSBwYWdlIHRhYmxlIEJPcycgZXZpY3Rpb24gcHJldmVudCBW
TSBvcHMuDQo+IGFtZGdwdV92bS0+ZXZpY3RpbmcgZmxhZyBpcyBzZXQgb25seSBmb3IgcGFnZSB0
YWJsZSBCT3MsIHNvIHdlIHNob3VsZCB1c2UNCj4gZXZpY3RpbmcgZmxhZyBpbnN0ZWFkIG9mIGV2
aWN0ZWQgbGlzdCBpbiBhbWRncHVfdm1fcmVhZHkoKS4NCj4gDQo+IFRoZSBzaWRlIGVmZmVjdCBv
ZiB0aGlzIGNoYW5nZSBpczogcHJldmlvdXNseSBibG9ja2VkIFZNIG9wICh1c2VyIGJ1ZmZlciBp
bg0KPiAiZXZpY3RlZCIgbGlzdCBidXQgbm8gcGFnZSB0YWJsZSBpbiBpdCkgZ2V0cyBkb25lIGlt
bWVkaWF0ZWx5Lg0KPiANCj4gdjI6IHVwZGF0ZSBjb21taXQgY29tbWVudHMuDQo+IA0KPiBBY2tl
ZC1ieTogUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9sZ2VuLm1wZy5kZT4NCj4gUmV2aWV3ZWQtYnk6
IENocmlzdGlhbiBLw7ZuaWcgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogUWlhbmcgWXUgPHFpYW5nLnl1QGFtZC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXgg
RGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZz4NCg0KQSByZWdyZXNzaW9uIHdhcyByZXBvcnRlZCBhZ2FpbnN0IHRo
aXMgcGF0Y2ggaW4gNS4xNy4gIFBsZWFzZSBkcm9wIGZvciBub3cuDQoNClRoYW5rcywNCg0KQWxl
eA0KDQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3ZtLmMgfCAg
ICA5ICsrKysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkNCj4gDQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV92
bS5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV92bS5jDQo+IEBA
IC03NjgsMTEgKzc2OCwxNiBAQCBpbnQgYW1kZ3B1X3ZtX3ZhbGlkYXRlX3B0X2JvcyhzdHJ1Y3Qg
YW1kDQo+ICAgKiBDaGVjayBpZiBhbGwgVk0gUERzL1BUcyBhcmUgcmVhZHkgZm9yIHVwZGF0ZXMN
Cj4gICAqDQo+ICAgKiBSZXR1cm5zOg0KPiAtICogVHJ1ZSBpZiBldmljdGlvbiBsaXN0IGlzIGVt
cHR5Lg0KPiArICogVHJ1ZSBpZiBWTSBpcyBub3QgZXZpY3RpbmcuDQo+ICAgKi8NCj4gIGJvb2wg
YW1kZ3B1X3ZtX3JlYWR5KHN0cnVjdCBhbWRncHVfdm0gKnZtKSAgew0KPiAtCXJldHVybiBsaXN0
X2VtcHR5KCZ2bS0+ZXZpY3RlZCk7DQo+ICsJYm9vbCByZXQ7DQo+ICsNCj4gKwlhbWRncHVfdm1f
ZXZpY3Rpb25fbG9jayh2bSk7DQo+ICsJcmV0ID0gIXZtLT5ldmljdGluZzsNCj4gKwlhbWRncHVf
dm1fZXZpY3Rpb25fdW5sb2NrKHZtKTsNCj4gKwlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiANCj4gIC8q
Kg0KPiANCg==
