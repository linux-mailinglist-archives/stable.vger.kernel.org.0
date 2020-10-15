Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10A28F47B
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 16:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388062AbgJOOLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 10:11:21 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:33601
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388046AbgJOOLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Oct 2020 10:11:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7tLYniuiLGcbe/LdO3KuoZk7OWlzm7K56Zj1QX/M1uOmZ9W8rXpOsLIMrHR6LPUcKtjz86qpKbYKzdSglRL7xQ/GwXVMQ4DsJRexWbaiWJZUZKjIANcc68fRCMOgX46l9Q3xQhzQvcUJ7r2CTkfzykM1QnwC9msM0ta4QBo0OBBllitbh8memybq++8myf5EK6cUumfD9qqCyb0gJWs+2CMurB0GMWbgYrz1+FHiDvOGrx0C+sv8Tn4EFF7EjrlVuv3E/lxVALlIBuLV9rzcnOQfcomB6M0GNaOan6NCzJ4wnUW+8b1F9Ypbz9fHPA7zkDcGqScVsJGnqkUlQp8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaucyMvNLkBeUKFuYzW4RZY+yFIXPIqEeCbtAnoiA0M=;
 b=TJV8YyHo3WnM7B9ONE5I4j6LYBmOLtPdjVb4+ZRx0u3pDC+bHWV1jQi6E5wfeUPbZ+3ztUI2nn50uTD1V6KPkq3CDnSguNviQMKoRBdzbiZIAa22AKvodrolJChqxJvhxPe/1tZze3UU6zr32FoXjj/oWB2Cp3Ct1vZm511CCkaSHtG/h92VCn6EVgdGMOXWptf4GWoZDu7uWKJFdIUnhi+tB9srmFlTVkRoWxgHb+Jc69MsOhR0epyJ8ktZ8S91LXWbaLdRYfTbEL3RtvZxhGEC1SDhRunxMqzk+VS+jTqBvKjo+5lsFsv0UuDMZTTARa6JwqwVodrqo57yBY+Trg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaucyMvNLkBeUKFuYzW4RZY+yFIXPIqEeCbtAnoiA0M=;
 b=bxpj57ulGgA0tUOkWEkmTPdHn1pOoySarQqOAp1UK50k7YUz0phNdQZ2r4jRqO/73/56PVdhoYsOn7pKPwmC9v9gSl6LB3tGJT8HO8ENJlM2R9Kc/POgnscelYsIFl9NPxKiy2TpT22jiC453OC0vw6GclKTOJHkEn8a7t4Iejg=
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23; Thu, 15 Oct
 2020 14:11:17 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::99dd:ff77:1ffd:d96a]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::99dd:ff77:1ffd:d96a%3]) with mapi id 15.20.3477.021; Thu, 15 Oct 2020
 14:11:17 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Alex Deucher <alexdeucher@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs
 handlers"
Thread-Topic: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs
 handlers"
Thread-Index: AQHWomieOyAGFaf48EOq2y93EG1BbqmYH2aAgACGVcCAAA4mgIAAAByA
Date:   Thu, 15 Oct 2020 14:11:17 +0000
Message-ID: <MN2PR12MB44881689BB508017AE3174E8F7020@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <20201014202836.240347-1-alexander.deucher@amd.com>
 <20201015051451.GA405484@kroah.com>
 <MN2PR12MB448853FE73DE3EF2D64BE36CF7020@MN2PR12MB4488.namprd12.prod.outlook.com>
 <20201015140617.GA4039567@kroah.com>
In-Reply-To: <20201015140617.GA4039567@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=True;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2020-10-15T14:11:16.999Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=AMD
 Public;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [71.219.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 84fc91f5-56c0-481f-47f1-08d871142f2d
x-ms-traffictypediagnostic: MN2PR12MB4285:
x-microsoft-antispam-prvs: <MN2PR12MB42850947D9FE7F550CCA0B70F7020@MN2PR12MB4285.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nuY0M6eqgGgyRHXZiRUm7/oerMmtpBkJgqkHGROUzsU9KPT7khc5axGz+x/o9r1vB7IPx5veK0OVG8sCc0xi9nrJ3a67tk1qcAPvRx2tt7DRh76kN9uWf10v3ySO1Jvg/fjG4yWCKcyh1OH39tv6xbIR7644tEIt0Kl/yfNFIAvGHPtRLHYb1D0y/sO+F/uq+M6aBhlofHWaIztUfyAj+roNwknf5JcFoyjHkg7TFxVWd+14LBCyBseqVp93oRAUid2fldj/0Yy24fgB0rUoiNh6FLXu5HqqF3HIBa657kDVHJTRJxOSFZPaQU0/374h31cgaUMVmKrGLkINR2/McoulLT4PStdwNW62LqWifg1XZ/y0FG5OzxVY+snjyrAD0YIut+aq37FAOBeDTL/NGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(478600001)(66446008)(76116006)(66556008)(66476007)(186003)(64756008)(9686003)(52536014)(2906002)(26005)(7696005)(33656002)(83080400001)(4326008)(66946007)(966005)(53546011)(86362001)(6506007)(83380400001)(8936002)(71200400001)(6916009)(316002)(54906003)(5660300002)(55016002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 29m5DZ5wOwkWdghq3iq21Tzm5tcoYR43jy4rAXjXP2sCQ3VSAdxpKEclGONJw7LccmpAI6L9gtXzXXNJlCkMMct0UcL0VCbLZ8B2ul1AmWVE1+mTmoxNx0QRQLMXAyLhT5xpHolZh8VzpkyHfMmruIbBMtEJFvrgdqXOuJnxBwyNbFLZZrVJxZlc1VMtyt6tR4FK2TCRDlX0Wiu4TmP1Enb8PfW/f2hp+eJhIrtvJe5rIh6ErLY4KCwG7abytry2g4X+wr79Xcx1+35CRNW2cBhp6B6wotC3mCgj3UJxDQRF/0eR/lCwlD8XkbW3Gb4/YSMIrW02Dnrgekz06QmJXSSh/Hkh6j3C2tUOEEVz/sdeaNyCAE2kNo91lc+D00an3HQK1zwMwPCyHCOzgV+S3UvRzjlamKcfwnVcBMNRXIRSM8KYiyIOwlzs1nNxGtAwv3fo6xP16Y4dupnGimau03NbGHvo2JIhx3nOldXQC+c9iIPlj2eOtN0UX5dlns/m3m0IMmMECufvj+oiu6lo8Y3o7zsRTVdmtfzz45KH6pOzGnmooU5nFq7p7NhyqUhWa3x7YdXLjGkR2a3SJuJTCELdVyW+xpyo3uw7etocFbxYQyyVdKSX90OBNU16jgMaNTGM2nP2bTE1aYrbdOjVBw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4488.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84fc91f5-56c0-481f-47f1-08d871142f2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 14:11:17.6173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2JOUDYHgmZk9SmIDwS5Y5rGeaPjibGWdIbMGuyMWltCxMJ5VC9cwlEYfLnU9Y1UWTVMYwJU1RBhpL7A4xUk8Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Thursday, October 15, 2020 10:06 AM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: Alex Deucher <alexdeucher@gmail.com>; stable@vger.kernel.org
> Subject: Re: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm
> sysfs handlers"
>
> On Thu, Oct 15, 2020 at 01:18:34PM +0000, Deucher, Alexander wrote:
> > [AMD Public Use]
> >
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Thursday, October 15, 2020 1:15 AM
> > > To: Alex Deucher <alexdeucher@gmail.com>
> > > Cc: stable@vger.kernel.org; Deucher, Alexander
> > > <Alexander.Deucher@amd.com>
> > > Subject: Re: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm
> > > sysfs handlers"
> > >
> > > On Wed, Oct 14, 2020 at 04:28:36PM -0400, Alex Deucher wrote:
> > > > This regressed some working configurations so revert it.  Will fix
> > > > this properly for 5.9 and backport then.
> > >
> > > What do you mean "backport then"?
> > >
> > > >
> > > > This reverts commit 38e0c89a19fd13f28d2b4721035160a3e66e270b.
> > > >
> > > > This needs to be applied to 5.9 as well.  -next (5.10) has this
> > > > already, but 5.9 missed it.
> > >
> > > What is the real fix for this?  Is it in Linus's tree and I can just
> > > backport that fix?
> > >
> >
> > This is no real fix.  The revert is the fix.  Sorry, I should have clar=
ified that.
>
> Is it also reverted in Linus's tree?  If so, what's that commit id?
>
> If not, shouldn't it be?

It is reverted in Linus' tree.  I cherry-picked the revert from Linus' tree=
:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D87004abfbc27261edd15716515d89ab42198b405

Alex

>
> thanks,
>
> greg k-h
