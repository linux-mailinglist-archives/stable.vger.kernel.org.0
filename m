Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C50917ED62
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 01:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgCJAol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 20:44:41 -0400
Received: from mail-eopbgr750048.outbound.protection.outlook.com ([40.107.75.48]:25345
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727287AbgCJAol (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 20:44:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ri4ntxUbuyNqgwnc6L2d8edt4SWr+uGWG7Au9Rm8Qhi41AH6qXbYjUTLzBoZ4QXH6eCjosBIz8VCNcuJS6WiUl9JO8/DNDPAB28AfMshnTcNISDEjB7l7+e4rehVBO20xMcSIYhPk/4oC3g6EamRb9XDazZYmxUgWseURx7bjmZi2RvaNSRxac1Wdh8WbdmyY1KDV5f3DffvH0kglgrNA7KY0K9zsuj+Z14s3kJGrtpXi+KHSUgFWUUjXaNMGU/Za46B+kitHc3N2zmKnteIzLmprSJdC4CzqXv0DURoCH69RqO4PterBXq29zHkWmloKCRtBMxLIXsbRLlkfslxcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+JsmR+lzANwPX68fEcJQbERLfQlhte7kh2i2MK+FBo=;
 b=Zck9T3fpnvIq4L+wY/P3f8rZwGCwG7cImKnf8gWubG6jAZWhY6GE2NrMRB5kV2BUkLAzxSKsPwlZ0HWhIq04kMfI63gwF7U6PKc2qtEHUQXkK0QrRwa3D0/EuPOC9a1KKb3hLYnHMVN5D0B6qFHiIdH7oqTdBRtUUmBd4QxH22gp3XEp54+JwEDyJfVngrXwsvPl8cS2WIRvXTTYhGeBA38MSxjpu25yIpdjTbMNI2iZnvBa9+WReIhltAonbb0C1OBg58wAdPmyHeyvJb9jBBAkjsNeBe6pjQxq0UtWXuyHQlrqQD04Qgels5Z25zxQk7Y5gv/HS/HOW0kaSKQlIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+JsmR+lzANwPX68fEcJQbERLfQlhte7kh2i2MK+FBo=;
 b=LOVhZhsw5Ip1zTmV9aIVX8TP+t71AylJpFIyCUQPJ42+P7Qj3efXYxoh7xZvm6aK/ToqczUWkkB7ocHohgTBX9bpxYvnIm49K1ySTXfegd00mfGsEzUkPCLkF+AaytOQyu3e0ORnWFsys8XgfkudvqARaxCbS5uZsUwFB7a1V3o=
Received: from MN2PR12MB3536.namprd12.prod.outlook.com (2603:10b6:208:104::19)
 by MN2PR12MB4190.namprd12.prod.outlook.com (2603:10b6:208:1dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 00:44:38 +0000
Received: from MN2PR12MB3536.namprd12.prod.outlook.com
 ([fe80::424:4ce2:f779:d08b]) by MN2PR12MB3536.namprd12.prod.outlook.com
 ([fe80::424:4ce2:f779:d08b%4]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 00:44:38 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Quan, Evan" <Evan.Quan@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/amd/powerplay: map mclk to fclk for
 COMBINATIONAL_BYPASS" failed to apply to 5.5-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/amd/powerplay: map mclk to fclk for
 COMBINATIONAL_BYPASS" failed to apply to 5.5-stable tree
Thread-Index: AQHV9kmFMSJNNPqMpk+9GGUL8J1UfKhA+NsAgAADPoA=
Date:   Tue, 10 Mar 2020 00:44:38 +0000
Message-ID: <MN2PR12MB3536EADAB39BCF921E024BB6FBFF0@MN2PR12MB3536.namprd12.prod.outlook.com>
References: <158378236575229@kroah.com> <20200310002744.GC24841@sasha-vm>
In-Reply-To: <20200310002744.GC24841@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ActionId=1beacedd-8dc4-474c-bf07-0000c281c3dd;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ContentBits=0;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Enabled=true;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Method=Standard;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Name=Internal
 Use Only -
 Unrestricted;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SetDate=2020-03-10T00:39:20Z;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Prike.Liang@amd.com; 
x-originating-ip: [139.226.16.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8b01f244-c24b-4c69-6f61-08d7c48c364e
x-ms-traffictypediagnostic: MN2PR12MB4190:|MN2PR12MB4190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB419010E2C62A370F2FD69531FBFF0@MN2PR12MB4190.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(189003)(199004)(54906003)(186003)(26005)(9686003)(110136005)(2906002)(316002)(64756008)(66556008)(66476007)(66446008)(53546011)(7696005)(33656002)(6506007)(52536014)(478600001)(5660300002)(4326008)(71200400001)(66946007)(81166006)(81156014)(76116006)(8936002)(55016002)(86362001)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB4190;H:MN2PR12MB3536.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Brb1P5JZbK/sMO3e4j5l8ZYO1r0Oo+zlXB9aRVY8DvJdOkmhi5Yv5JNy4F605xs5dX8nEd+1ByNgA4BkU0u71Ouv3MwCnZ4aOhmE1LA6IB+ueAKjhpvNQFbxSnF92iyxRcAIU0hth5nEYMErJEcnHr1xXLc99AujfJp4QWg08lOmqAOo6BaHZbyRhmzXEd3fJi1Q7iexq8xUzEkVWwIZM9vIU4B2LujhjTENYxeIQI/+jNiJyqUDF3SclXOIWL+T18v65vFCW1o1bpA23dXBc22u3IDa1BzfpGzOi876nf9RogzLpek5HncQlxl/FdRnSe+778O+HbmHOGz5TPR943y9QV1DyrawscKIPrGCOVdlyKcYMCad0RnHr1507IkccwvbWmOgE+yHPp1l+ngOf7+yp0RTUD8lPAj3HDRxcp5IKNu2g3qJubb8szzdntGq
x-ms-exchange-antispam-messagedata: oo2D/2k1/oNbgC6Sf8R4C49bfMvaHz/j96HTOqgYU0gVBTALSuCfAs/BiKfIQsAwgtdE2n6EVPHtpovOjkSKtC5ELPWrWXO6QGIDZCvkneYMxayTs366B25uIPdqE+ozhJO7brX58t2VleaTxRpbqg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b01f244-c24b-4c69-6f61-08d7c48c364e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 00:44:38.0131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bycz96qhWGkxZtkTxlIQ28IiNEhvM74usiH5z6AGhDMCOTgBJmuTBLgUMEcZgvRR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4190
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Tuesday, March 10, 2020 8:28 AM
> To: gregkh@linuxfoundation.org
> Cc: Liang, Prike <Prike.Liang@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Quan, Evan <Evan.Quan@amd.com>;
> stable@vger.kernel.org
> Subject: Re: FAILED: patch "[PATCH] drm/amd/powerplay: map mclk to fclk
> for COMBINATIONAL_BYPASS" failed to apply to 5.5-stable tree
>=20
> On Mon, Mar 09, 2020 at 08:32:45PM +0100, gregkh@linuxfoundation.org
> wrote:
> >
> >The patch below does not apply to the 5.5-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From ab65a371dd5f5cba6bd9a58a1a6d4115a71cc5c9 Mon Sep 17 00:00:00
> 2001
> >From: Prike Liang <Prike.Liang@amd.com>
> >Date: Wed, 4 Mar 2020 10:36:21 +0800
> >Subject: [PATCH] drm/amd/powerplay: map mclk to fclk for
> >COMBINATIONAL_BYPASS  case
> >
> >When hit COMBINATIONAL_BYPASS the mclk will be bypass and can export
> >fclk frequency to user usage.
> >
> >Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> >Reviewed-by: Evan Quan <evan.quan@amd.com>
> >Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >Cc: stable@vger.kernel.org
>=20
> Is it actually needed anywhere without 0b97bd6cde1d
> ("drm/amd/powerplay:
> implement interface to retrieve clock freq for renoir")?
[Prike] Besides the read sensor interface for debugsfs of amdgpu_pm_info ne=
eded,=20
the sysfs of pp_dpm_mclk also need the fix for mclk. =20
>=20
> --
> Thanks,
> Sasha
