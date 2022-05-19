Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0A352DC61
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 20:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242845AbiESSHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 14:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241349AbiESSHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 14:07:34 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2064.outbound.protection.outlook.com [40.107.95.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9381E941AF
        for <stable@vger.kernel.org>; Thu, 19 May 2022 11:07:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImDaFkpsnSYHiyjGN9QTA3f65FU23DnkFPcm1fdJ9MToWZi2t5a+GF50hOJHP1IZ3/VOITDCX6JTsI9CjzU0e+9tS2c9qSwZdlvG7Z2GtjiT6HC7GItfEQzD+Ero28/ob+lARnJ0T64BLxJWph/PHc/c9OHaTVjpA5nWjKDXGDSL0mZ8MLGuAtqoQWR053GNba3gXALkR/y1tEHI52vmrQfkhCY1lqJFj+nQtS0LZ89YaBwpL064pKU2auDAnmQhy6su3Wjn/2YaxBvkuFda/qo6v4ieh/Z4fAYYaRiMQBNJW3ZtcY+HlHWH78WT3k+8Agt9I532eaCHchfaBJu1Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrOpxHDoJ6n1/rurlHxGPtMpXYoqMS4rL5z0D1CGvLw=;
 b=It4opKT63hLoOxvMOJ9BerU4e48VuXqYLNxo5kEHO9lU8AMZGmzEsPIzoJvH6vxSPpS+GQtDn9eVZbZcMd6ky77Hk9k4f1KcnIRSH70cjmNb+9/VwZM/6bcjzqPhon4L7WxDiq6vXegKKZevFbIvUoNh4fg2OuytWiPJv9rv6MPZsCAFvUQo/yOW5fG3ah9iVit6C58T/36+A4zQj7DU3iqhDCVafqhEUFRzkujif7SVyoma5/3Bv9RyRbafxpV8uWuL3lTf0I8yxJoXz6gu/RU+mzrGmhprsNmnk/QhbTWuINvqRYB56yNOm+XkRoznYo2t0MmJQGUqZG58ir4RXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrOpxHDoJ6n1/rurlHxGPtMpXYoqMS4rL5z0D1CGvLw=;
 b=PCjyHbMniW3QdM6Deqg/K4cJH+/3C4KmoHkoy6z2pyYvv08Ov4XwOyTeHVDcb1GmqemnpSX4ujbEYDXhrjK+twc8DNln1zYW7GSRxg3qIIfMNEcWz+EUENrAanV8jqKG9cQsr1SY9s9Rhcv0T22ioS+h0RzQsy1mHw7eM7GibGU=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL3PR12MB6642.namprd12.prod.outlook.com (2603:10b6:208:38e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 18:07:31 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db%6]) with mapi id 15.20.5273.016; Thu, 19 May 2022
 18:07:31 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "casteyde.christian@free.fr" <casteyde.christian@free.fr>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: RE: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Thread-Topic: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Thread-Index: AQHYabuPQo7dlCpjq0mwll14F3A0P60jVmoAgAAIYsCAARsvgIAB/OSggAALy1A=
Date:   Thu, 19 May 2022 18:07:31 +0000
Message-ID: <MN0PR12MB6101D7AB5BC33430A8492E0AE2D09@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <MN0PR12MB6101BB3D9C3D73563C3445B9E2CE9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <1375623147.551034914.1652871731034.JavaMail.root@zimbra40-e7.priv.proxad.net>
 <MN0PR12MB6101FA3FF375A961E67AE89CE2D09@MN0PR12MB6101.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB6101FA3FF375A961E67AE89CE2D09@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-05-19T17:27:21Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=fd3e14ba-5598-4029-9d76-3f457f40f8cf;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-05-19T18:07:30Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: ae3ac430-a387-406a-b00f-f3452512ec04
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de876937-4fc3-4448-54a2-08da39c2717e
x-ms-traffictypediagnostic: BL3PR12MB6642:EE_
x-microsoft-antispam-prvs: <BL3PR12MB66425A3FA8EE46D227E0CFB4E2D09@BL3PR12MB6642.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +2ZCGI0K2Eem/QH79HHmYNA3kanHr/+Sk0OnVTxmJcWXYXg4jsmRS2v28oUO7/yRLEXRw/zbvu1W4pML7lEC7P0Z0vKJurp9GIqX4yEWBLu9nbEZct6/lQu2kbheZXkjtZzek2vHJCuADyh5vShAsp5ulQNjGx+kCvYp8kHHIMExqCPGmBlEXDmfEy8Y+peMrLP9VKLu897WmOojemxCRNHwS/jI+L7jt6WQyv/qdkJok9+SuLPXz7QEHBq6H5btaEd/CaMT5ovE3tYkqwKneAdgzwyiKPlHvLR1C0zBqkPoXrewwqn34qnPw9nsffJQO/Qve/0uuJBZTDiAeisTWgKp8a56hGBV6GrIwnD7Rr/BW9WgtkiRbqL/uyxcOTpD31Sd9FaW5OG+/kTtS7Wst3tHwIFbdKaiepYNWZwcMxBt+rxE3reWPz6k5RaKMKhadYlMDjceBzge7JMJAHFK1TjUQxQKLOV+CYqJegbCtvLLnojJK6MEPk9aq/GypYJDn7+kLVyHbMISvSOoeWPH7HOHEO6/VJFnlXMZM+1f6M4fIrmyiUQzw1+NOK/roeQ0aWrvOtd9TFL/pHWIl1sXvZ8kI2qXmhmPuY1l5asswZ60IkEUerUk61GwSrPNMRMUsbLgQpXIeIGynb6Wvvy4tmrbhoMaUJ7hJXA0Vr8lBbKhM2sj4SX53IY+UoHrKKP/XfHXresUQwx7fhhFYKYbwaSMitfH++A+s9MZT6iHR5tNsEix2Edczcy+EvmqxmK0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(86362001)(2940100002)(122000001)(55016003)(966005)(508600001)(186003)(83380400001)(7696005)(52536014)(6506007)(5660300002)(38070700005)(38100700002)(33656002)(66476007)(66556008)(4326008)(76116006)(66946007)(66446008)(4744005)(64756008)(6916009)(54906003)(71200400001)(9686003)(316002)(8676002)(2906002)(26005)(41080700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R20xQ3VoWVdhZFZvNVpwOW1qZEFHN1Z2U2ovdDMrK1hkbUMwZ2VxdUIxUE1B?=
 =?utf-8?B?c0RyK0RySmsvUzY0am0vMnhVUHhVcTJQZkVKOTFEd3VzY0FUbXgrTDZjS1FL?=
 =?utf-8?B?Njk4R2hiaG43L1ZkNjNtVFJCb2tYS1FGRERTWWNSWHEvUmdueGVLcDZneVJr?=
 =?utf-8?B?dklZamJxRHgyU2xreHBYSlVZNEZ5b3laNitSMmtaamhkVjk1SzZHOTFmSjlh?=
 =?utf-8?B?WFp3WGp4RHVIZ2l4cVhyWU5QTWV1WXRDVjZuSFdydStMV2tWRG0wTkxsM0hi?=
 =?utf-8?B?dHZ0L2hHckJIZTN5dktxNEtqR215QzdaLzgxZkJRZFIrbDlLeElVTmlEQXFq?=
 =?utf-8?B?MjEzeGRxeTNEMWJhbnl2Y1dVb1QwWUJ5KzhxQVluNGxnd09Fd1NNWGN0cVZv?=
 =?utf-8?B?RmRaaFk1WnFmaVZINGpudGRyb3dkbmZ2NTBkNnVKVTBLQllUTEtlNzEzYWEx?=
 =?utf-8?B?VklBVHAyUDBRSW5WMEhPc3o4Mmk1VWdudC9VNUoyYldORDFrcjY2MVQ3Mmdk?=
 =?utf-8?B?dVVQS0xpU0NZaTNxZGdFdjRRSFdINlhRaEM1V05SSWZMeHJpOFArOVdrdkNl?=
 =?utf-8?B?NkYrT0drOW0zYUZLUDdmdGlMUmQrWEVLR1BhWkJsSjRFZ1dXVXNrbnRRdmEx?=
 =?utf-8?B?bVZXYmFpRzA1ajdBNi81dDYydUh0ZVdvU1FuUC8yTmpWeFUvbmxiVXhGYWRx?=
 =?utf-8?B?WHdablRxc2NJc051cVVsek1ucU1QTGRCbklseUhha1VDR0twcDlOd0w2WTZI?=
 =?utf-8?B?Ti9ZaWErVkdWVUQyZDVNQXRaTzRsUG9HVWVXZHhIR1M5ZHhxb0ZILzBuVlhS?=
 =?utf-8?B?Z3FsT2RFSHl3RWpKRFRENlVqdmYxWCtGeWk3c3NEby9xWEI5TWlFYjYyMk8y?=
 =?utf-8?B?MW0xdTlhTlMwUlhITXFUNkRPa1kwNVdQSjhGOTZiRVVqUGc2aGlhaFduOHVW?=
 =?utf-8?B?L0drcGVZMWplSDQzZjN4d3Z4Y2ZnUVZWNjhYZDFjM20zTENiU3N1OU4reXRx?=
 =?utf-8?B?c2dqL0NXNkREQVcyNGMvMm1HV2psSWE0Z3AvdkhEUW84WTBNRHpibkYyK2lt?=
 =?utf-8?B?VWs0UGdUYXdpWXh2ZEJHYTFiNEwwNGZlQU5BQ2lxUkM1Q29PY2lQZ3Nod09z?=
 =?utf-8?B?dHdXODlDNTV4WTdzLzNwYlBZZjdCdG1MZmpIdjV5ZEtvR2RCL2xaV0NUcnJr?=
 =?utf-8?B?TW9zb1JoSG11ZDhpTEdaTFZTQWVMSVF0VUUzQWVLRFlLRnRNSEd6QWI1bmd1?=
 =?utf-8?B?OWxrM1IzRzNXQWprQ2NFYkRuYVNXWW03S2RnbTQ2T3Z0VHE5TUpwN2ZqczUy?=
 =?utf-8?B?a01aQSs5dUxIaVd4Y2I4RGdyc2xhK3BHcDZzMFg0dnYvK09vU1N5Tk56Lzlr?=
 =?utf-8?B?VmtNZzUxOStHUUFKT1huamJKU0NoMG8xdE1sakl1aGFDLzlRWUhZYlBQMGdE?=
 =?utf-8?B?Z3Zmd291ZXJQSEpvYVlYbmhXeG9ZZXRpbzl3UWhadk5wUkY2RVZPSjJ1K1RK?=
 =?utf-8?B?dWNleStEajNYVW5DTnB5NXRhRWg2RWNaQ0FDQTVxZkJLZzJaTlY3TDAyYVAy?=
 =?utf-8?B?M1hrd1J2SnlNN29xemlaZktwM1NlRE9CYmZUY2hEd0ZNV2l6Ykc4TzcyTHhC?=
 =?utf-8?B?MnJaQmRHQjJZa3ZMaTdLVGJ1SldTdGlGUnAvbHRXbE9KbGgra3NSbXg4VjNS?=
 =?utf-8?B?bXo0WGVBeC9YV3A0bmorQWNFMHh1bWhYVTcyNktNbnFIeFByUE1uY2MwbG9N?=
 =?utf-8?B?QUwvb3NOcjBrREM0RVRKV3BJMGEzazhCMkRZbkQ2Y091ZnhqUUk3MDJXNUNI?=
 =?utf-8?B?TDFUODlsS1hxT1lyZGNabDRkRkRFZDFsTFpWMFo1YVpIU29aeGFycUQyeTd2?=
 =?utf-8?B?WHpmdEt3Rk1xaVFvcHlPMCtDRDUrUkxxUnRMZGorUmRyYlh6WnlZSUdpZk4w?=
 =?utf-8?B?ODBrc3I0aDE3NnQzN1l2VEtSbHA5VWI0WGtnWGFZOTErRDdUcFZGcjA4ZUxj?=
 =?utf-8?B?aHg4SHVlSk16aklIcFRvZ1NPVDRxdlRHckdGUW5xUjBCMHFiODNyT0ZrZC84?=
 =?utf-8?B?Q3JMSjZKT3RkdXRyS0tNZkJxWUtCZ3RzQ0lmZUFUTjh4WmhTaTRJQlBvak9J?=
 =?utf-8?B?Ni9rYnEyLzJkTGhaR293YkdOVFJYYzBKV05Tb3BVMTdlRk5zVHV6N01nZVd4?=
 =?utf-8?B?ZUw2Z0tzS21Pc1NRRlV6VFErWHpiNjBsZ1FDQWlBOStVN2d3dDliVUdWaWxh?=
 =?utf-8?B?cjJzUy9Yc2FzcDBzS3lvU1Z0dmVVY2plYnUyU1Y4Ylp5Q0d1SnI3a0lFcC9m?=
 =?utf-8?B?NEZlcmpHS0Y1WHlWNmlKSTlxRWJSMlBJSS9SYTM2R0N0NThZVGRWZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de876937-4fc3-4448-54a2-08da39c2717e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 18:07:31.6733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FkDbUdmnQ0Kfrhia41/E26hZSqTDNQlPaAH5fEmZSCDQfjosJzCKhNpPUIsCajQdF+orWswktc8qfY11LhfgKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6642
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiANCj4gSW4gYWRkaXRpb24gdG8gbXkgb3RoZXIgYXNrIHNvbWV3aGVyZSBp
biB0aGlzIHRocmVhZCBmb3IgaW5jcmVhc2VkDQo+IGRlYnVnZ2luZw0KPiBvdXRwdXQgdG8gZmlu
ZCB5b3VyICJyZWFsIiBwcm9ibGVtLCBwbGVhc2UgZ2l2ZSBhIHRyeSBvZiB0aGlzIGNvbWJvOg0K
PiANCj4gMSkgNS4xOC1yYzcNCj4gMikgUGF0Y2ggdHVybmluZyBvZmYgcmVzZXQgb24gZEdQVXMg
aW4gczJpZGxlDQo+IDMpIFRoZSBiZWxvdyBwYXRjaA0KPiANCj4gVGhpcyBwYXRjaCBzaG91bGQg
ZG8gcHJldHR5IG11Y2ggdGhlIHNhbWUgdGhpbmcsIHRyeSB0byByZWNvdmVyIHlvdXIgR1BVDQo+
IHdoZW4NCj4gaXQncyBpbiB0aGlzIGJhZCBzdGF0ZS4gTm93IGl0IGhhcHBlbnMgc29tZXdoZXJl
IG1vcmUgc3VzdGFpbmFibGUgYW5kDQo+IHNlbnNpYmxlOg0KPiBvbiB0aGUgcmVzdW1lIHBhdGgu
ICBJIHRoaW5rIHRoaXMgbWlnaHQgZ2V0IHlvdSBhIGZ1bmN0aW9uYWwgZGlzcGxheSByYXRoZXIN
Cj4gdGhhbiB0aGF0DQo+ICJibGFjayBzY3JlZW4iIGZyb20gdGhlIGZhaWxlZCBzdXNwZW5kIGN5
Y2xlLiAgSXQncyBzdGlsbCBwYXBlcmluZyBvdmVyIHlvdXIgcmVhbA0KPiBpc3N1ZQ0KPiBvZiB3
aGF0ZXZlciBjYXVzZWQgdGhlIGZhaWxlZCBzdXNwZW5kLg0KPiANCg0KSSBub3RpY2VkIHRoZSBy
ZXNldCBkb2Vzbid0IHJlZG8gdGhlIEhXIGluaXQsIHRoYXQncyBzdGlsbCBhbm90aGVyIG5lZWRl
ZCBzdGVwLg0KDQpTbyBoZXJlJ3MgYSBwcm9wZXIgbGluayB0byB0aGUgcGF0Y2ggeW91IGNhbiBh
cHBseSBhcyBhbiBtYm94Og0KaHR0cHM6Ly9wYXRjaHdvcmsuZnJlZWRlc2t0b3Aub3JnL3BhdGNo
LzQ4NjgzNi8NClRoaXMgaXMgdW50ZXN0ZWQuDQo=
