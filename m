Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5725E5406FF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347419AbiFGRlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347959AbiFGRk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:40:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59130544C5;
        Tue,  7 Jun 2022 10:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHezIs+6vLjDhtbSZ+4IZVBWPLLSM0kLXJnZhJEwMVaVVpth28a9omff3zBGuiVBbP/gvqCrKNxVmTmHL/CfBOIDB6PHE7QrwE7ToJNVAcfM69HTTH+HqKbHvM0n8iAU9kjKmqDjHEwMP3FEvlsZiM1jLK4M9dYTpi+CUxZEGQEE8ip1FqMUvlLvIaJCnrlFTafJN+9bWNJVSgJyxUBHWvvMDXq6020ZzbBe5x83PH0f+KJkw8fPvjN7cAuqdG+nuVqNUYVfzD5dwQNjqgP45faWgVxGcF/3cF3iGQ+ga3Hcs/kiiwhnmLgFpVNVV5tAsgZMzTfCDH8w1j5CFkZHyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTws/LIs0K0RKIygfb6L0vOH0kTyhUEUhhHqOcrLzaE=;
 b=Xwfc7FfhRhW7eO8scifYisFz3Sm4vtnlRHTkZg92slVDGDyG110xtW1OoNoNxnRyG+TIDkyfd10ahRdNdSnZPsomsXsHjxqD7PjyAGXagNfBwau40VLI6TS618ghEKCCCY4CXlNRL75DMiLdcJMUGbR4p7cxvsnuIsz2tXeUKP/S4MJONqPWHEzOc9a4l4G9vXK7M8u2bk9okUZgARintHQ5+lQxBELxsKbEuO3yOfrvEXHs0/yohS7gIKciyvBwvdFLrhmf3dWzGyL+QU4B4NqV62y+l9c0RC03TpNLNNhNZx5pVxJf7NpQWLzgi1CPhW9lge/W2CttnIvrOZLRoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTws/LIs0K0RKIygfb6L0vOH0kTyhUEUhhHqOcrLzaE=;
 b=q5U1GAeMorJuDZ3n7MXZfXDWMrsvPI/+fGBhk9mc2NcAo2MZm/2zVh5au1eM5VzxK0GHdLC9gQmW6oxi/ws1HrwLNQPolwtF+SS0MKivykSYF4f8mVFcWpoGJC5sIjQnlU986uedaFv02XYI2BU20WYlp/SbHyYj18ZiOoVyra4=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM5PR12MB2566.namprd12.prod.outlook.com (2603:10b6:4:b4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Tue, 7 Jun
 2022 17:33:02 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::589b:a1f6:9c87:a8ba]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::589b:a1f6:9c87:a8ba%6]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 17:33:02 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wong, Alice" <Shiwei.Wong@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.10 065/452] drm/amdgpu/ucode: Remove firmware load type
 check in amdgpu_ucode_free_bo
Thread-Topic: [PATCH 5.10 065/452] drm/amdgpu/ucode: Remove firmware load type
 check in amdgpu_ucode_free_bo
Thread-Index: AQHYepL5pPxigf4tn0SR4uYAIkKWz61EM4DA
Date:   Tue, 7 Jun 2022 17:33:01 +0000
Message-ID: <BL1PR12MB5144C45C376EA576CE8A4744F7A59@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220607164908.521895282@linuxfoundation.org>
 <20220607164910.488356562@linuxfoundation.org>
In-Reply-To: <20220607164910.488356562@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-07T17:32:52Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=3d095b12-2a38-45ef-a760-58edf76ed3ed;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-07T17:33:00Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 2b7b4e23-45ad-45cb-aa08-d420e6367168
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01157149-cbc9-46b8-a67b-08da48abc5af
x-ms-traffictypediagnostic: DM5PR12MB2566:EE_
x-microsoft-antispam-prvs: <DM5PR12MB25668DE21974EA7A0F227028F7A59@DM5PR12MB2566.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wubZiGqWFVXEvkfwLHDnMtCNymWJaaD1zTaNvR0BAMG5FLYVpW7pjrpk0Exp2eVtpIywDhogOtoda0UcUHMFKkG7w7TGfDCt7ciF1YWMckIFlhx2qnWYB2KRAlPvTByagPD9u5Y5tYzKmiL0Q6rfOat/BohprXeZDC9HyOE7M/SzIRzAzt+dXO6DWZ1YyPVuG4BPWRgy+lHtkW1FgyFyw7JaqG9hDe1iojUMrSEsB6EEUUq37y5Ztpt4d2XC7VHo0r0LjGJ4WQguEZEOeEeTf+3KR+Ujh4G+cVKP1oll+psqQWvdBZKMsFrBXqOi7eyFa2AzusDkSSFMIvXcjkhC6dCYfexZ3NIjaIdjhv9W7d57L+GCWThH9MTz6eKaFwgeU5DvGMFrUtG+Rt2VCXndR78CcktavBJoixKqM2eZzFeR1E/fEAJWYrdaxuVnfcgcQ0KB2w0sTyXwnQeUK575W66ympKQc2i4niRKOP86LPunarnO4yOrz3sPq5yenjqYh1YAwL3XSzp+CcxRRmEtxnkPucjEh8VtoqOcS33enO5888Np3+0/1ZA47RIoF9GNNQU8AE1eFn51FSsPxt/JeNfCV1vI3ldEskr5hHQGWL19Fixu42pCz2sykuqcPvpjkqIynjPxIASUdPu4F8olYolOt9RGNlaVnrTcIoFEK+tGqggjEMZ1wsyi15nCnGnHc0YiaH+yxTQH48BZXs3Tiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(66946007)(9686003)(186003)(26005)(53546011)(6506007)(7696005)(66476007)(8936002)(66556008)(110136005)(38100700002)(83380400001)(122000001)(55016003)(316002)(86362001)(71200400001)(4326008)(508600001)(8676002)(66446008)(54906003)(5660300002)(64756008)(76116006)(33656002)(2906002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkJVUnpyWEdncnhMNVY3aTB1K3gvSWQ5aXZuR2RETCtxMVRuenVYdG9OU2xv?=
 =?utf-8?B?S3FNbkpVc1lRQndXWEFkaTNZS0FXdkc3eVFtajRrc1E0RU5NT2lKRmhBZHor?=
 =?utf-8?B?NC9LL0pLdGVoRnhScG5JZFAyNTJiWVl4SkVNQ1BJYlZlWFhaY0svTlB4UGRN?=
 =?utf-8?B?bUc0MWpOdmZIcy9MRExYMDg1LzFqRDlleXh0dVZ5dFhoZWVDdkxFMTduY1Rh?=
 =?utf-8?B?RnhUWUpMcnBFeWFLTnNXNEJNaXBsRXIzSnFXRk5QVk9OVDRkYkd6Y1VBcFBq?=
 =?utf-8?B?ZUlCR2RRWjlrcHE0Y0k5M0xOcDAwZURKMjdaVTA0bGk1SlRHT09Ebm5UOHgx?=
 =?utf-8?B?UlNRcUZYQWhJT1h3MzExak9keDlseGVGd01YbVpac1g0aEFCSFJCZUdJZHVh?=
 =?utf-8?B?NmVBdjRoaVU0RGhnWkN5V2RkODVyT0RIdTl4a09XaFVVTjgxSVZYbzJpbTll?=
 =?utf-8?B?S3QxeTV3SHBXZ1pleWQ4alpmMlVkZUFwREhZb1E3RXRwK2lkUHBQMnliV2R3?=
 =?utf-8?B?UldUOEF3Z3lnVVduc2lZbWN4R1pxR014V0cxcEJGOHlCNUlJaWJFTEducHhz?=
 =?utf-8?B?ZnB1VHA1clV2M3VGd3ErZytUYWZWNU9UVENoNU1taWVDM3RONzRPWkZCQkR5?=
 =?utf-8?B?ZHRuanEvcHhYOWJDV1NQdUp3ZnpPamV5MFBTWURRejdYQjUyaVhtSTdWSzhT?=
 =?utf-8?B?WFdaUk9JRU9DR1NwYmczUUN0djZkVWx1ZFRSRGN5QU9BWEp1VDZTUUF1NkVX?=
 =?utf-8?B?RzA2L0F3OXN0VVI2b0pGVWwyUmhvWEFrV2lwV29laGxEdnhoblNwMTJ6cmxG?=
 =?utf-8?B?T21zRmZxcjVic3I3Z24yZXBPQUZUNmlabE9JaHNrakhhRXI4amE4c0h1VVZS?=
 =?utf-8?B?N3lGSEhtQ0pwUlpnOXFySmN6TVgwRjBnQldhY3QwTTJtRUNHbWJRcEszckRn?=
 =?utf-8?B?ZHhlbUtoWmdJNVNxOEZyM2hlSkVsRjkyZ3FRTXR5Rk5YeG1ZdXdmNUhnQWFx?=
 =?utf-8?B?djBUZ2tHU0hzbUtKZzgwcUdhTXlPTU44WVgxRDVqKzUxb1N5VmtqRGduL2p5?=
 =?utf-8?B?elNjYnpUZjdURlUxTzBPcXlWbElIWGp3N1prVVVFdGszL2xkcTk2YkxKbmJK?=
 =?utf-8?B?bFdmSHB3REd5dVFhbk13dDJ5VlkrZ1RGcEJPQWpQQ0hQZkRKaWIwNzlvNjdF?=
 =?utf-8?B?NWRQdU90cWE3M3ZUM3JtT0VqR2dkRjJ1V3I3RWVsUW1yZUduVW5PaGd5d3F0?=
 =?utf-8?B?dzkrbFlSZmVZUExUQnFmd0RoNXdjS2FxUjVLeVJtMEorRkRJOXZtS3dOaTVF?=
 =?utf-8?B?NVBueVFmWkl5WGFzVGtVanh1TFVBb1MzVi9OSmV0cDllNk1KSWFWeXVseUFF?=
 =?utf-8?B?dzNGUWRFa3NGZzlDZi95R0NHWXphUmtjMGN6amNIeFowbVRmbXdGaXZRMmZi?=
 =?utf-8?B?NWNaYWI0cjI1Zkk4QThpVy92RWVuVkEyYlp0WGQ5MGwzTTA1YmVkK0FwQThS?=
 =?utf-8?B?akpCZ0NuUXBvTmlER1FCcnJLRjJiRU9JSXhQT2VmVVRaQU0xWHkvVHZuTG1G?=
 =?utf-8?B?UitubjNBY2VJaVhUT2hpNWpuSS9XZDY0Y01DOVVBM09nREs2QWJqRE53NStI?=
 =?utf-8?B?L0VOR29PTW11UjZDU2RkVG80OWdWSHE0UElBenlDWkJmNVZhUVVWMDl2NGpr?=
 =?utf-8?B?TXc3Q0FsVFp1QkN0bkVRUDlaQzAzNVNGemFlaUlQTFowWmVENHF0QyszZG5z?=
 =?utf-8?B?cDlNYWwrK0hyTldJTk44eC9yc3JMMjg4UzVibE83VnNEK0Y3ZHdwV1NzWjc2?=
 =?utf-8?B?K0FRQ0hoREN4bVZEeU1UVndNdmhyQ3hCRC9VMmRhODhwd1c4ZUxhZlZlM2cy?=
 =?utf-8?B?Z2VOUXVhbHVpaS9oOEhPNnUxYUV3QXRYV1lBcnNzTU93MnNYSENndXNEUjdE?=
 =?utf-8?B?dXp1R3RMWmdGcmJxSlFmWjNybE5tTmF3Q3Jtb1k1Y3g1QXdxaVYyQkhFY0pY?=
 =?utf-8?B?VUlIbFFZbE9sMVd4enQvblB6RFR0c29FRVZNZlFCZ1ZPK3dUdWFMeEZpa05O?=
 =?utf-8?B?ZUpxbnpJUlRIT2djNUFCRVQzR0ZkRHdJMnZDVFN6UEV5aHlsR1hOOHltSXJi?=
 =?utf-8?B?UGlvVk84eVU0Z1BRZ1g1TzBhVGFIZzVKM2hoMzhtNjRDaWs5WjNPYkVQUG0v?=
 =?utf-8?B?KzFYV0VLQjhKZ1daR21oL1lFNkdNM0ZWZC9Ka2UxTkpGMFYzV1Y3SENUcmIz?=
 =?utf-8?B?ZWcwSFJnaWFLZFlFaG15bHFQK2p2Uk1zRC9LWXYwV3cwR3A5bHkwK0xHbkZh?=
 =?utf-8?B?QmtiNUExQXNhd1lsNXZLWTdQZXNZekszd0ZHdlBhaGdnNTZVOFN6QT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01157149-cbc9-46b8-a67b-08da48abc5af
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 17:33:01.9420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LCP0BHHaNGpCvI383YXrr+HHK1atMoyiMhwSbEA7lReWfxkwSfLHugFANzkmrvCURJ4PINRn4JrK5iJPR6L3nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2566
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBUdWVzZGF5
LCBKdW5lIDcsIDIwMjIgMTI6NTkgUE0NCj4gVG86IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmcNCj4gQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+
Ow0KPiBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBXb25nLCBBbGljZSA8U2hpd2VpLldvbmdAYW1k
LmNvbT47IERldWNoZXIsDQo+IEFsZXhhbmRlciA8QWxleGFuZGVyLkRldWNoZXJAYW1kLmNvbT47
IFNhc2hhIExldmluDQo+IDxzYXNoYWxAa2VybmVsLm9yZz4NCj4gU3ViamVjdDogW1BBVENIIDUu
MTAgMDY1LzQ1Ml0gZHJtL2FtZGdwdS91Y29kZTogUmVtb3ZlIGZpcm13YXJlIGxvYWQNCj4gdHlw
ZSBjaGVjayBpbiBhbWRncHVfdWNvZGVfZnJlZV9ibw0KPiANCj4gRnJvbTogQWxpY2UgV29uZyA8
c2hpd2VpLndvbmdAYW1kLmNvbT4NCj4gDQo+IFsgVXBzdHJlYW0gY29tbWl0IGFiMGNkNGE5YWU1
YjQ2NzliNzE0ZDhkYmZlZGMwOTAxZmVjZGNlOWYgXQ0KPiANCj4gV2hlbiBwc3BfaHdfaW5pdCBm
YWlsZWQsIGl0IHdpbGwgc2V0IHRoZSBsb2FkX3R5cGUgdG8NCj4gQU1ER1BVX0ZXX0xPQURfRElS
RUNULg0KPiBEdXJpbmcgYW1kZ3B1X2RldmljZV9pcF9maW5pLCBhbWRncHVfdWNvZGVfZnJlZV9i
byBjaGVja3MgdGhhdA0KPiBsb2FkX3R5cGUgaXMgQU1ER1BVX0ZXX0xPQURfRElSRUNUIGFuZCBz
a2lwcyBkZWFsbG9jYXRpbmcgZndfYnVmDQo+IGNhdXNpbmcgbWVtb3J5IGxlYWsuDQo+IFJlbW92
ZSBsb2FkX3R5cGUgY2hlY2sgaW4gYW1kZ3B1X3Vjb2RlX2ZyZWVfYm8uDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBBbGljZSBXb25nIDxzaGl3ZWkud29uZ0BhbWQuY29tPg0KPiBSZXZpZXdlZC1ieTog
QWxleCBEZXVjaGVyIDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCg0KDQpJIGRvbid0IHRoaW5rIHRo
aXMgcGF0Y2ggaXMgcmVsZXZhbnQgZm9yIGtlcm5lbHMgb2xkZXIgdGhhbiA1LjE5LiAgSSBzaG91
bGRuJ3QgaHVydCBhbnl0aGluZyBob3dldmVyLg0KDQpBbGV4DQoNCj4gLS0tDQo+ICBkcml2ZXJz
L2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdWNvZGUuYyB8IDMgKy0tDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3Vjb2RlLmMNCj4gYi9kcml2ZXJzL2dw
dS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdWNvZGUuYw0KPiBpbmRleCBiMzEzY2U0YzNlOTcuLjMw
MDA1ZWQ4MTU2ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1k
Z3B1X3Vjb2RlLmMNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3Vj
b2RlLmMNCj4gQEAgLTYyNSw4ICs2MjUsNyBAQCBpbnQgYW1kZ3B1X3Vjb2RlX2NyZWF0ZV9ibyhz
dHJ1Y3QgYW1kZ3B1X2RldmljZQ0KPiAqYWRldikNCj4gDQo+ICB2b2lkIGFtZGdwdV91Y29kZV9m
cmVlX2JvKHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2KSAgew0KPiAtCWlmIChhZGV2LT5maXJt
d2FyZS5sb2FkX3R5cGUgIT0gQU1ER1BVX0ZXX0xPQURfRElSRUNUKQ0KPiAtCQlhbWRncHVfYm9f
ZnJlZV9rZXJuZWwoJmFkZXYtPmZpcm13YXJlLmZ3X2J1ZiwNCj4gKwlhbWRncHVfYm9fZnJlZV9r
ZXJuZWwoJmFkZXYtPmZpcm13YXJlLmZ3X2J1ZiwNCj4gIAkJJmFkZXYtPmZpcm13YXJlLmZ3X2J1
Zl9tYywNCj4gIAkJJmFkZXYtPmZpcm13YXJlLmZ3X2J1Zl9wdHIpOw0KPiAgfQ0KPiAtLQ0KPiAy
LjM1LjENCj4gDQo+IA0K
