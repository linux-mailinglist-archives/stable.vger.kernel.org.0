Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6057949B80C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384282AbiAYPzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:55:06 -0500
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:22273
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1582665AbiAYPwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 10:52:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLxR9Dt4y7/kokJjnqFmHzhJi9O76wX836uD5iXFA3elk/mSUrIM1BpJeZvUCVSyl4xup81p4ZoX76SNbRVHHGK36ibJPOIf6HE+pNUqLpBbbRwqsHnV6mQS7wttLLVlgtXfIyVgLcOS3czOU3OsNtHrFrP+qNcZTUimHi318OiXc9Yl3gCODqgSlLj7OQdYA7zIOtQScJsyXPQPTkc+9t7eNcaLFReIQQHU2jbM9pk85383ekTr3rFpLVRzOQtQxvVfzVsbfIEOYnpnUNFfY2IZ+BeFlMLBXYRaeXflNwJN2F/NCEPZ0pv8//PD6dhQOTg7qMixFNoEyWvE06kIUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIJdMpMfRE3WCtuldjvXm1etTDnUNsUsA771sTLJ2m4=;
 b=GJig8z0VzYgSFuPIbRLVl4JBE1TCwp8d3rRaS9/sb04atubpjuw4tVQOOikmS7fUdLV0qYLd5q5ey7VLtsPU7BzURWc4GgzL/75N3r0z5MRgxx3G88B0xr2pxkubR3eKJHpEaTOruXWOFtMAblOE8a4DGTvRYP0TYF8bvMBL5Z9MRsi99Q/we/du0xtrQ4AEHRrlLwmtqjg58KgXTPdgmh/vTDNtpVi3DLGdAmNASWJeikHUzYbkAGuwkYutArGu40LpljmMyfLOTQVanXl70wGjfNRJmdyqAsUX8ou5ErzAtRZLAYzMwj7t2q7Oxs/Akpa2v72o8iP7WTG+6pCRrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIJdMpMfRE3WCtuldjvXm1etTDnUNsUsA771sTLJ2m4=;
 b=bIuGwuPSkUacArkgqwkoXp5XJJM3ow2e8lr2pfKZebEL79pTshbI7VjKO4JftWINAZmTfzHFkjf87sn5+j9ITQDre/Sx4JHDtemT/1qC2MxkcxSmuakjCaRIFstcFFREa5QQsI8TAz56AvSah7wyLFQKND2LBfDgEmJk0vjRJlE=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM5PR12MB1401.namprd12.prod.outlook.com (2603:10b6:3:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 15:52:48 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4930.015; Tue, 25 Jan 2022
 15:52:48 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>
Subject: RE: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Thread-Topic: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Thread-Index: AQHYEf8xLsAkzLtQ9E2V0Q9AMYb/Haxz4m2AgAAAMtA=
Date:   Tue, 25 Jan 2022 15:52:47 +0000
Message-ID: <BL1PR12MB5157FC7109F99B0D2DB265B5E25F9@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <20220125152111.22515-1-mario.limonciello@amd.com>
 <YfAcKZALAKAMXs/O@kroah.com>
In-Reply-To: <YfAcKZALAKAMXs/O@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-25T15:50:47Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=8c0b1e50-e85e-4d16-b28e-87cf1e952c1a;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-25T15:52:46Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: fe4af42d-6519-4fd7-b333-33d4a77a29b6
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8624377-157d-4156-0561-08d9e01abc2c
x-ms-traffictypediagnostic: DM5PR12MB1401:EE_
x-microsoft-antispam-prvs: <DM5PR12MB14012AC1A40AE1F6A0C66C63E25F9@DM5PR12MB1401.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nv9WbwUwA4B8mC/g4+Bvu+vSmOYS8+Vcz39Ui8jeIt9aeC4wbvdYjrJe9rxqX9A9+BjSQxdv5bgJ7QqsJ6Vjz1PjbMIvwxZWdwoRzfrnH+gbSApAdIGyEl77x97RytFUaWhxNrUxAg2IQ+rC+klQW/xDyY+haQOHtsCzLTJYCUgupEND2ribFFkQa+vshyrBESupO3+IDpl2wUsxWnXTMOI5EuhRRWD8kV5YST2mHV6vRPs3/s6TjsnUFvk3YtsOhLC/OAfqelKRf8Cx3fYjFtmp0nTqEE4gdnNk5l5FipG6gd/MEnxiBCUlvtN+fMYOpv2GyuUP0GSWDrC9ijVNQ9GCWSJoXTYUW1oatYn/6Czr9FSS4vn6A61Tu3VRHeB5fUFqdE76jaPKwFPMG7tfmRrVli6ipYgDCk3Hc7gn05WFfDx1kUjF5NIjHgHsH27R2CLeC5btPbkIREH3RyjYuFVFV3Rl7/vyeSotCHRjIVBGhB40n2mLqrqmW140azw+LeKrdmM9Vjc0j8AgKCFFMkM1F7eovGZ0pxu2A/EqYZTGqn/wZUmZm+/tCKqstn9pQRC5+9ylSI2zXN1xvsY3CzgFVPCTIHJ3wp5tpz5EWpw+W3L5ysXnINX1h5uYN0WzNbZP/L35p07FYIYxv9kJ+PJCvzSqi9eP2NNSyESbm87tpwj7ATUr2SJYFAILPDYSMG6R1BSIm6sAdEeRhOBOPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(66446008)(7696005)(53546011)(52536014)(508600001)(5660300002)(76116006)(26005)(71200400001)(83380400001)(4326008)(66476007)(64756008)(33656002)(66946007)(66556008)(54906003)(86362001)(9686003)(186003)(8936002)(38070700005)(55016003)(6506007)(6916009)(316002)(38100700002)(8676002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wvBKFBntCfesL9u/m9aBzrgp4OV3it0bhEe5aEeRouuyc4owvcUMjsR/ZtRd?=
 =?us-ascii?Q?B1Hh8E9tXbRkL7qgaeBfd4F4Rl66ZBRAefOoC1PPvaWf3Y8HpTp/tXQusO8z?=
 =?us-ascii?Q?kc9Xfbyhn9MHx6rLCBnivZMFc0qlmWQuTrKLpl4aDPB9hMCu7fDiIcVrIcVB?=
 =?us-ascii?Q?GBGL0O8Vj63YcmVlMMLrU4dJduHSQW/YBRkTKBWX7x5rN1xAazEiYUYu42No?=
 =?us-ascii?Q?0h4TFeN5Oe2S9i0EkEOotR0kkOXctyVvAj6sERgr/PZ9zyaaQ3OYB9ajetwo?=
 =?us-ascii?Q?R/cbipl8T0esr2Zf5XzRu99swXFw8flo5VS3pdwY724iDs37iu5S0i8JFFev?=
 =?us-ascii?Q?77fjXhvsb/BqgV6dlgz/ktpevjER6aMewdJ+Jj6RYJl78VPUcX+irEmAX2ie?=
 =?us-ascii?Q?zuCNB1zrSwTIxXaen4kotIcpznTJM1XfsoXOX+opyoM8bLTd3GD5nUzn0r3k?=
 =?us-ascii?Q?6FJnqlCj5Bu8jMi6Ctw3VUAlHUo/dI9TljklUZm/iHZbzCOu0rNTr1NzLFLD?=
 =?us-ascii?Q?uRcgcqzpA7Atf5dABbWbFMasThHOFihVT+YJ0d7y+lk2HJVem9QeoeK1mZ8z?=
 =?us-ascii?Q?elRXpSf8IBxZRZvM7fA8gsDc2mzhKHNFjJFT1wfE7/seWfcePVCyIvhVvyp7?=
 =?us-ascii?Q?mKO2luchI2AibraHLKYW9QTubiU18yoH35pKNfhpMMM7JwbEFS0wmNZkJDPl?=
 =?us-ascii?Q?p82TyncxlUFoe0yYC7VD0l3EE0eucVoOuW0zmKZsHnb3+EDrt2tDZ1Bw//GA?=
 =?us-ascii?Q?wuTGWppS/K7Qhtg0lryCVmvA6r45psicPhOfEDFVN1l9cAESDevsPVGHY6w0?=
 =?us-ascii?Q?P0zJEJZRXSaKJEIF2oBOxXS5J90DDX+oMUlV43qAdmsL8fygZbAXnn48JWkw?=
 =?us-ascii?Q?ymYN8e0F4uxUc58xJnh4sf3myw685mSMTXgwo9fEMRGRwXZWWGSb2et9qTio?=
 =?us-ascii?Q?qiAJKXoHLmMiQD9ZARYp671kPMzybA1g/amduhnWt36DFZk7dM8ebvce6g41?=
 =?us-ascii?Q?TAcVhndycqimxHsXQtzHlA+f5o9oVagiFBpFQjA7dOVb+/8j5qwg+k0C7ucG?=
 =?us-ascii?Q?oQjeCNHnwzxQwgUl9TTz8RH4pyU0+a2tpSioRSvEU3vDo3GGTqZNFCwfGFJ4?=
 =?us-ascii?Q?IRGRUNMKjgZ239WppF46G/OYxLdtHQVAk6v5NftpG/+2pN1kbMphm94AsECK?=
 =?us-ascii?Q?jB1rjFDRo6E56jlYQl1zkwIvPbAACqBdxK4RJikBZgjNrxim/5ygTMODW31N?=
 =?us-ascii?Q?ZGg0NskAT26mK1EqNGITlZsz4NhxdfwENZOvy1U+2H09iprEk/AzoZXo76QE?=
 =?us-ascii?Q?6Sj5LlVc/tpVH4pOxBioKPR7URMDDB1NCyz6VwlO6pFd+hj15/FLUu+10wp+?=
 =?us-ascii?Q?ddf0n5wXNfrlWmGwNZS0rMcqoi/OCFNhi4INjjB+PKE0X55vw2KhNhcbEcPa?=
 =?us-ascii?Q?1gzT6DXUMmSYpSJTiZzqFLI7xrVrdZYFWPkSGfC74ctpJSoF/DIKi882Fzz2?=
 =?us-ascii?Q?wJp9vdbwYJ4aqoU8ivxpMYGa37e1Kpn9ASfXuxtoAye2gvfOK+N9YSgDbpOp?=
 =?us-ascii?Q?75qwgiXHR3sFR6tRFsFEYGiuB6M1Jrpa+Slh/jLkY6MshXUDPQ80QFMklZWS?=
 =?us-ascii?Q?MIXsFPQhBPUhcWH2dx5Kf1w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8624377-157d-4156-0561-08d9e01abc2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 15:52:47.8377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DdAz5JizKzD1R15gQwwq/DR+4l93434S8vc8zDSKGoDnecA91HrAkZuN58/FQ2pKpKXSDHc6ec4iEui4hMPOCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1401
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, January 25, 2022 09:50
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Wentland, Harry
> <Harry.Wentland@amd.com>
> Subject: Re: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for
> DCN2
>=20
> On Tue, Jan 25, 2022 at 09:21:11AM -0600, Mario Limonciello wrote:
> > For some reason this file isn't using the appropriate register
> > headers for DCN headers, which means that on DCN2 we're getting
> > the VIEWPORT_DIMENSION offset wrong.
> >
> > This means that we're not correctly carving out the framebuffer
> > memory correctly for a framebuffer allocated by EFI and
> > therefore see corruption when loading amdgpu before the display
> > driver takes over control of the framebuffer scanout.
> >
> > Fix this by checking the DCE_HWIP and picking the correct offset
> > accordingly.
> >
> > Long-term we should expose this info from DC as GMC shouldn't
> > need to know about DCN registers.
> >
> > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > (cherry picked from commit dc5d4aff2e99c312df8abbe1ee9a731d2913bc1b)
> > ---
> > This is backported from 5.17-rc1, but doesn't backport cleanly because
> > v5.16 changed to IP version harvesting for ASIC detection.  5.15.y does=
n't
> > have this.
> >  drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
>=20
> What stable tree(s) do you want this applied to?
>=20

The original commit it was cherry-picked from was CC to @stable and it
should have applied to 5.16 from that.=20

This fixed commit should go into 5.15.y.

> And what happened to the original signed-off-by's on the original
> commit?

I dropped them because I had to change code to do the backport, it didn't s=
eem reasonable
to me to keep all of their ACK's/signed-off-by's on the code still.

If that's incorrect, please let me know and I can re-send with the exact sa=
me commit message.

>=20
> thanks,
>=20
> greg k-h
