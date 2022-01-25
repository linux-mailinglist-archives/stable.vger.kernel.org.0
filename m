Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7EB49B62D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387608AbiAYOZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:25:09 -0500
Received: from mail-dm6nam10on2065.outbound.protection.outlook.com ([40.107.93.65]:10144
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1579006AbiAYOWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 09:22:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSxAv4/nsyX8gxCUv1uiFbTWXmrqq0kn5NJEKCwUS/9UuhqhBucU5KD9Ndknwl11198fipE1Z477cPLgM+Q+D2Jbf5wFbfTE+vhP70TVKj8Ws/r6neouMUNhgqqSULgvBnP4WXNN7xXN++0D/I18a/dB958wA0sbC91Kc/HTNl/6jig72fP8GUdtXLtholeLLCJrFqkvxBPlkVS56odxUe1SjGIW3xKpPQqAyTtQcNNxrDoJ6TQsNI3UDUGM79DrzoVAy8/qqQwQeKpCqCaz1nVfcF3287T4rUfCAq5nu9LY9t3W0+oobjOzFmmthceLv7bi79VXmidWDRIFFIBIrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mp0jCM+lj6nS+k5M3eeKdV6uWgZ2pWLX6nCbmwSEgyo=;
 b=WGWN1N7TqbtnGwvINw1O5VCDQzO2py0Tb+dwgkDyjT0j0QZm4o25OuNkrCoMkVioqJaw+JlH0uBkQbmlhoXbTdvlEuWMu1ensR0Ieu6Ye4yRJkJrFsMPkH3krwtr80Ec8mc47QbUDuNr3eFdPGXngHqm5U43T8ESeDYrx0xxB27LB3sk+nkMORbRJnIt1l2BpCCDs0ZOoKm9kzvKxrZfB6df/zdORUsJaQJMeeOxDTGlRfP4PBFX4vrv2G/EVwutULf3N6SkKOnaBPgCmWHM14wbjpSL9HvOT6B4LyJ6s/5M9EjuWwhLHs6f7UcsLbdpSBDXNG/Wyq7kSpNGGq0UCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mp0jCM+lj6nS+k5M3eeKdV6uWgZ2pWLX6nCbmwSEgyo=;
 b=SUNo28zfngFaVYg6xu7p7Huznj2t2ajV142xy3H55c7dv/bXUDwRqVPzWyJEkZqtL3dKZx3HninDxhWVRhZWeVA+SeB1i5cpB8XIAMmXUAHnAJI/JQPazxp25JpPHqL7d8ww3gyDaKN7B8PWFiJdr+qVyJmtiA/sldhKsAQBhVM=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BYAPR12MB3062.namprd12.prod.outlook.com (2603:10b6:a03:aa::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 14:22:14 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4930.015; Tue, 25 Jan 2022
 14:22:14 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Bhutani, Amit" <Amit.Bhutani@amd.com>,
        "Tsao, Anson" <anson.tsao@amd.com>
Subject: suspend to idle fixes for SATA for 5.15.y
Thread-Topic: suspend to idle fixes for SATA for 5.15.y
Thread-Index: AdgR9qphnqUAoyLrR/KqBpWH4SRB3A==
Date:   Tue, 25 Jan 2022 14:22:14 +0000
Message-ID: <BL1PR12MB51579C4626B8B584F5C50F44E25F9@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-25T14:21:40Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=c5affd7e-0e77-4317-9259-8d1119185091;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-25T14:22:12Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 5e46bd7b-4306-4cf6-9f14-82ac7f30c613
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c24a89bb-b819-4bda-b6a7-08d9e00e1572
x-ms-traffictypediagnostic: BYAPR12MB3062:EE_
x-microsoft-antispam-prvs: <BYAPR12MB3062F29A54AE28D8C410C62BE25F9@BYAPR12MB3062.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FFj5/KhFEKDUwTKD9d09qu6SctvPiRGS2OQhzdHRtrQFCtg2Pu/wPBFxkkEscKkp6p0J64a2Embo4eLJbCIXWtxuo/qMSI7/vm5L3UyVm0o4/UUsQiihEhPTl0cw7Sf4exGLZi71zQXZv9zhj/DnJqF7dCOYoHd7mVMJ15PWEwHVZ0MyI2HzNrnFVdAHKlB0tK95fkBBHxoPvZMJRZTQ3Kej77ZAgMjzn6IiYT5FI8Z2ZbuqeAoXhjCEngYvb6qMzlAVoeoAe0d3DR0JwK5nxvmkF0hC6jK0DsAF8obDtdXtvLe2b2Si5BOXwytmInAotkQY0BMGvyZutMJAPVEazSPyxVBMn/IaYK23oMaLCUuBicMXH2RIRI4rZOwOPsVaw5ASyZS1ZjA4aNl9vZtWX3k0qzFl/LjOHYPy+S205h9f/PibWegXFNsYiTervrdXYCTnTZUdlzMIazk+Sin3nPI6BQZ89FtgWqnu0GL0iS7ldQxmpZ86kgpPLsAMV94CJ8T/vY3/RbC1ON9TELfdR0c1USOdwfAffBan4srjMWehLdPtQGBEuTefB6oKu+Ns7nJCsQvRon1e344ckFnxKP5yPKRKxZmxvdp6ryT+TjYG4h19lBEJjLPwEcuEe1fCFpUYrd8N94HxiDi65anwv6wRgyOIqrqqgjZuqkxk4W6vZh6EzumpL9sqfz3rov0Gnm+hKzvIdKnP3tPHwJ0N+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66446008)(38070700005)(66556008)(76116006)(64756008)(15650500001)(33656002)(71200400001)(9686003)(86362001)(316002)(38100700002)(508600001)(52536014)(54906003)(4326008)(186003)(122000001)(2906002)(6916009)(4744005)(55016003)(26005)(7696005)(6506007)(8676002)(5660300002)(83380400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/OJLJEr4BtgRucSHzLE23rc473k+W8rB2otrxAxGbz0jVIW/jQNaqpXZpuvh?=
 =?us-ascii?Q?bUbJXcdMJi92jBA6THK3L2WngGf5vgA5Xd2f+FUCvWvAsjf49c6zKj+u4V/W?=
 =?us-ascii?Q?E0a+JzKLANK0+aDv6Nrk8I0kNX4VTz0iApgmRih9pYh3yD/gcyzJ0dxPVpbX?=
 =?us-ascii?Q?LpcBSaLIk26Vw9yMoWWkujlMZLBpxnbITna6xOGtU1J5YtLYUqudu6Hm8nho?=
 =?us-ascii?Q?aHo8O1bkkKv+snD/gtmCbu6SE6xnpCKmeU3cwN/9a5xfpbglYv5RLeHbeQ/z?=
 =?us-ascii?Q?ngAkXd+OuppBiLqt9iK3bd2in5nxBhJc5/LUNHlWPFre8QDvim9fqye+i6WE?=
 =?us-ascii?Q?dPEOXkAI9MUe1QdqyHqnatGikz2EY0ZbOk/bs+6VaivnYQyVJ13HV0HSxldd?=
 =?us-ascii?Q?83tIqQkv3Alrzyrdd+Vd0hKghp5U/+L/mPRkKSuL8v5UVAZ7HYmgEkWEL9R4?=
 =?us-ascii?Q?qJzN9tr9Xxyledq1h0KgnKiuYqtfLHxnn0GQ+a1EeJWFZoT0BYe9So6r2kB9?=
 =?us-ascii?Q?irXn7ltr8mtIfp9PLGBpjgfelG2ddv4tCph2baPwK0mj+sefyTksX3/+Q99P?=
 =?us-ascii?Q?YCaYlfsZRv/DbOwuSQXFfS6y6UTKhAbLnII1DghCfBBc+jKDGQqNUUAKlPiC?=
 =?us-ascii?Q?s0xMI9/4VOpYc5Q6q1tnflMOIOtb2wtisEi+oVBoWbGaOlNYtIxinz2IGI/v?=
 =?us-ascii?Q?6l//w9zDKZ/kuaQMt0iL99pdEBpSZ1FnldxU7LuvQlJVKpShGR2I5l1kMkyv?=
 =?us-ascii?Q?vXPeUg+xHtTlTqHngkwpEi79QGZxkDQ9hemPAFcPMQQiXmwQ1mixHSbTXF8B?=
 =?us-ascii?Q?EPwpFFEq9SdvyZf15amjEv5WO7inc5O6RWxOC7KbdlwC91bk0/U5Pb35ECsw?=
 =?us-ascii?Q?mLp9E5jw99qxO9o26P0RT74qZN6wlhdVzyWBv3eMCqRhxhqK+dYR8M5s3Vay?=
 =?us-ascii?Q?xcjnZ+04G+SKq5JOMQBeTXAN+oCCmlIvWJ0FbXcOPJtNgZQlBUWg0y6vqKg6?=
 =?us-ascii?Q?sHeGsuRIViWOq7memaQRM4U8Lzg4fxgZhM/1DNT8Dz+ESI0wgReThOEtkGAL?=
 =?us-ascii?Q?nsG7RF9Fu0H95SREE4Ep1+W4VSVAGlBJ/dYEDE76QvaELj7GwzOcRQufYSAm?=
 =?us-ascii?Q?/G3LooIBfQLYmOYDfUfAjLTejjHaGefk3VsdBBp40uLySbQ9D++odT72pYQz?=
 =?us-ascii?Q?ffKJYPfOnNwIIFsM1BDM9YV2fn8SB6lBnIN7OE9I+yNwrsjbEMoIFT7cqqaW?=
 =?us-ascii?Q?TCJKzj7OsUAdEoW5J+uNix19Ynrt0SMctVy0bWyL1j1hPV+RxeJA41aKpfWQ?=
 =?us-ascii?Q?Z1h+b/ERit8BZWFwCbHEOv4WlWYmLoK6RfxHTm75sNjbyjyS433icgTEbMrB?=
 =?us-ascii?Q?vXrVHtt4Hns1nEMWeWu5JT52ZLLxlejmFlZiI8raxreMUNDcXAEGa/ifsWZ6?=
 =?us-ascii?Q?pkXJkp66z19gunFliOPIfeDI366q9t1YJxitDfrLKyOS7z6G5uG/ciLxK5U6?=
 =?us-ascii?Q?gSyWVJ4NZ1HuLGS6Nbd44kQZt5HDEHHefrRTi2ygn/JMnCiNQa4Pf33tv/L8?=
 =?us-ascii?Q?zmWiVFYfeUBoc5PSlwvPHx0zsq0dReZGiNH9Qucas9tPaCbxTevFYM9dWLWJ?=
 =?us-ascii?Q?qPAQ88P7UyHq3EWGGAsb6iU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c24a89bb-b819-4bda-b6a7-08d9e00e1572
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 14:22:14.2065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cZ5aSo0pK4k0tzZsRYB0ebdUoQT80+sUn6ejifmb5KdzOsFD3qlwhfZGzkawOIi1DQpvB70xmnzvJUUShy9TqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3062
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

Can you please bring=20
commit 7c5f641a5914ce0303b06bcfcd7674ee64aeebe9 ("ata: libahci: Adjust beha=
vior when StorageD3Enable _DSD is set")
and
commit 1527f69204fe35f341cb599f1cb01bd02daf4374 ("ata: ahci: Add Green Sard=
ine vendor ID as board_ahci_mobile")

to 5.15.y?  These help suspend to idle failures with supported SATA disks a=
nd should make sense for LTS Kernel.

Thanks,=
