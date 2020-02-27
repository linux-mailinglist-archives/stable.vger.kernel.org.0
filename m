Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9BE172199
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgB0OwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:52:17 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:51553
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729137AbgB0OwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:52:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6W/rN5dOXXqzqarm+FrULsVHn57rOMQild8t2x5FyF/mjG6m4L0jthG4m2RKN12nEFr92mZmDvUgYR4aA4E841JxJz448gsTuWQKRA67aS0ZdA9VLMH2YzXMOS51TfVuTdHTYGP9zyas13/YgXbJwKaPi+8VJ07U3jb+AUz6uC8S/6/S6qT52pSiP1muY3keCkeNxu2PAWpuPn6UnXchNY0JG9SxZWIsdEN/xrpFOHTJJ/gLW8zoTBNU0rrppjj7GJtv12xJkAoXdpAVM+JwwCZ2WuI/Aczmb0A2NgR1/1/nwja8yYuNCstfWgqVPQSTgQDipHSPrPqUY0WaTaZJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKsZQujuqK228L/YHOh1Ypac9udyhJTS9T4eF83IYqM=;
 b=C5WEgLBBv4bXHa6CKusKhg/LhST2DoERzaJe6iycxe4xfgxqOaaMLJIFfgKtzVKWpBrq5+0ZSdDGDcdXGV2LaOiJjkEWnpX6wyzF4+/4PzyBUMcguedeTsAn6vM3BdPAhwEHXHD13NsFie1uFhvP2/TWtFITSYNF37evTiJc1B8bmQUwlfFlfHVJwpvCJszr9w0GrTu8SNWT46Sp2NfSe/Tt1zbOTgJQBV9h0xvxeTaNNvE2FI6CT1Hbc5PMgf32bmAsD41sEnQNWMnvE1sjUU6Sf9NnSzrf+xJfQ/ifgGeHcglN1i8j1C9OJ6Rz5Hgf+saTYVPzZovXrQietHKcCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKsZQujuqK228L/YHOh1Ypac9udyhJTS9T4eF83IYqM=;
 b=xj5ql6JTbE8BD/XINGEl/96pzLkxAYFxdOtC6rd9EHvcrsNtWlHYrqMTnehXtzQGykgXzguzSwgEtOsKpltN+eeLIAk1/c51SMt0co/5zFZrqOXaNlj2F3cC8DY2SFD5VZ3ZQyrCPrVSTRSlNERgoc4Y6y6OEVaotgPLsNTYlfM=
Received: from CH2PR12MB3912.namprd12.prod.outlook.com (2603:10b6:610:2c::22)
 by CH2PR12MB3800.namprd12.prod.outlook.com (2603:10b6:610:2d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Thu, 27 Feb
 2020 14:52:14 +0000
Received: from CH2PR12MB3912.namprd12.prod.outlook.com
 ([fe80::7921:a391:1d1b:5167]) by CH2PR12MB3912.namprd12.prod.outlook.com
 ([fe80::7921:a391:1d1b:5167%5]) with mapi id 15.20.2772.012; Thu, 27 Feb 2020
 14:52:14 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Lakha, Bhawanpreet" <Bhawanpreet.Lakha@amd.com>,
        "Xu, Feifei" <Feifei.Xu@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/amd/display: fix dtm unloading" failed
 to apply to 5.5-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/amd/display: fix dtm unloading"
 failed to apply to 5.5-stable tree
Thread-Index: AQHV7WgrllotQn8PN0OaDWgcfRDRtqgu9iCAgAAp3yA=
Date:   Thu, 27 Feb 2020 14:52:13 +0000
Message-ID: <CH2PR12MB3912A58135079C88D00469E5F7EB0@CH2PR12MB3912.namprd12.prod.outlook.com>
References: <1582805969210220@kroah.com> <20200227122143.GA896418@kroah.com>
In-Reply-To: <20200227122143.GA896418@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Enabled=true;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SetDate=2020-02-27T14:52:11Z;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Method=Standard;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Name=Internal Use Only -
 Unrestricted;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ActionId=672c81c8-f102-4b0c-8e36-00007c4d2b72;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ContentBits=1
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_enabled: true
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_setdate: 2020-02-27T14:52:11Z
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_method: Standard
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_name: Internal Use Only -
 Unrestricted
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_actionid: 9425b256-0d7d-4236-a3b3-00004e1a2dee
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_contentbits: 0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Alexander.Deucher@amd.com; 
x-originating-ip: [165.204.84.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c581bad7-fb8f-4f70-78c1-08d7bb94a1e5
x-ms-traffictypediagnostic: CH2PR12MB3800:|CH2PR12MB3800:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB3800558F2A6530D6ED4C0C8AF7EB0@CH2PR12MB3800.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(186003)(5660300002)(33656002)(4744005)(2906002)(86362001)(26005)(66476007)(478600001)(66556008)(81166006)(7696005)(66446008)(81156014)(64756008)(76116006)(53546011)(66946007)(52536014)(8676002)(6506007)(110136005)(316002)(9686003)(4326008)(8936002)(71200400001)(6636002)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR12MB3800;H:CH2PR12MB3912.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LsMoI1CZ0KiEkq3RRTuUNJMLeS21EqHRYD6eNQ+k2hoJp7FIuRAv4RdR6d2kr62iFATy8xuZKUPQyIsWglBTzHdp5iVtTnrzf76s5B1qJjTPaas8GYtJmMBgakKNZ8A+ARofB195DNteVHvQKBySgymbsdIn+omGwaoNoyuOjNb62rlfr0T/7LTDP3SYaACrxVAbH9T9nD5GVY9JnmtEe5l26pxe8pZyES0dqp0qwNlRWQSt1jX92tb00dAwsRI95CRfyIF/W8VrZG0zYGft/IZeYVG62SIzfhn763wfy7IhOX81JJ6sydnx77gHIgRIgmiu59/Vn6dMK87VzjHqTiw8LdcUh3Gy4KD8IEYbbUaYR6JEQqKAsGdFHNw7DxNiQbLGmXbLYCxdmgPEeNO4U24pV/3ElaxWJ+26gHVvKLP60e6O1MrEYFnC4LQSqVCk
x-ms-exchange-antispam-messagedata: QHLiQNuIPmU5zR6IZZkTl2Y9MXcmcgC4VEnciCPa8sUUbPMYea5BcMIC769A6GiX/Uo3ZAj251w+MexDu3L7Fhi1fVFXF2dbIH8/IAMuXR/DC0qd3FGuZ3B0NraDnxgpz0lI2gFhzeAQj2rZkkqdTA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c581bad7-fb8f-4f70-78c1-08d7bb94a1e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 14:52:13.9850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S7ZkWcCg+VWYfzYmOyPXuh6FhP6HpPymMwjCpERgM5gioSUUPhXfP9ta/WuqfDm9wYEx4MyrxFZ4hc6eJRJ3lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3800
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - Internal Distribution Only]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Thursday, February 27, 2020 7:22 AM
> To: Lakha, Bhawanpreet <Bhawanpreet.Lakha@amd.com>; Xu, Feifei
> <Feifei.Xu@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org
> Subject: Re: FAILED: patch "[PATCH] drm/amd/display: fix dtm unloading"
> failed to apply to 5.5-stable tree
>=20
> On Thu, Feb 27, 2020 at 01:19:29PM +0100, gregkh@linuxfoundation.org
> wrote:
> >
> > The patch below does not apply to the 5.5-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git
> > commit id to <stable@vger.kernel.org>.
>=20
> Note, it applied, but broke the build :(

Please drop it.  I'll take a look at alternatives.

Thanks!

Alex
