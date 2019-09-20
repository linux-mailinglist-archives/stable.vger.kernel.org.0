Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4ACB9175
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbfITOPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:15:14 -0400
Received: from mail-eopbgr740074.outbound.protection.outlook.com ([40.107.74.74]:36768
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387678AbfITOPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 10:15:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+D9QFP2czJqYiKv8wxSmveTYAuB7bsu8LXVnbISh+BwCvBXxx8q3e4iG+AbnViBnTDROw/BbtJVk0qlEH3thZumclktKb2xR2um4sSHORjZpmAdFCPzduwtOt4/OnrcXCIeEnaiyxpRDNDQPpVKdXKoZvPfJ9N4PdW+y/j76GgDREV4umrKFx2uuwJ5nc6uXvDatEuvP0m/3AsILzxD4BjQcYxTfIw53Iqtacdhjd9OWllvd64vy/wC2ThLaRFx64VhAkyBGhajMQuhcEUZNgwZ3HCgpVGZ023IxLww5SjtukxAnHtUt+r8vHetXhr/esQUZDOCEBloh3vVbxmoIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWiSSv6x45YU8s7WXCWEHawu4LcrDk54C/xLlTDbVcs=;
 b=OCNuSxBK5e4r+1aVI60gTcvFeUpXwkKOCw8XbiHSTdzhmnVgzihlRXUXNIcP/9XXZJRQm1H1H8g6BbMLGAZrPNgWkWrO2xiAZUWlZlmRTWXIEJGDtFtzmwOJ8TjgUB6AdISpL1bznIYH5x6VPIyr4Uwl2toOZe2Nw7WFCoP2yW/H0O5gyA4TtcReGlAtj1m6WoRFzrBVnQ0xAXvdRMbxUAAqCXcHP2qZ8VFtJ6gbkW5+SVL1AbV/65q9+yZ55pjCfHmfWg+ut9K4oYewerxACbJ5dgG5gcR7ze2yj+5oxwR2sJJmctaG1SZ8+q4yA2ykTjcIiTbFBAH+ye8Gx6ZF9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWiSSv6x45YU8s7WXCWEHawu4LcrDk54C/xLlTDbVcs=;
 b=1mUhEbs6QkC7IHBwFv8x/Q97VHQlJwzJgYBnsrTuli5ZnjYH6sM5x9olWfmRZeBOVcXUlg8zH1BQx++GU3f7e0slnqu8KHXLvQ+x9hPPbcSYc1FbVYKyabyfAi+NhMgWV8PwsJA4OcgdiXdn6o7oNj6N4j0BX5ezoaU58uHu1/U=
Received: from BN6PR12MB1809.namprd12.prod.outlook.com (10.175.101.17) by
 BN6PR12MB1761.namprd12.prod.outlook.com (10.175.101.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Fri, 20 Sep 2019 14:15:11 +0000
Received: from BN6PR12MB1809.namprd12.prod.outlook.com
 ([fe80::a930:a648:d4d2:d25c]) by BN6PR12MB1809.namprd12.prod.outlook.com
 ([fe80::a930:a648:d4d2:d25c%12]) with mapi id 15.20.2263.030; Fri, 20 Sep
 2019 14:15:11 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alex Deucher <alexdeucher@gmail.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>
Subject: RE: [PATCH 0/3] amdgpu DC fixes for stable
Thread-Topic: [PATCH 0/3] amdgpu DC fixes for stable
Thread-Index: AQHVb7w+ACOpqA+sO0i904Jjrrjj/qc0myaAgAAA2aA=
Date:   Fri, 20 Sep 2019 14:15:11 +0000
Message-ID: <BN6PR12MB18092E39C33B29F34E93702FF7880@BN6PR12MB1809.namprd12.prod.outlook.com>
References: <20190920140338.3172-1-alexander.deucher@amd.com>
 <20190920141135.GA588297@kroah.com>
In-Reply-To: <20190920141135.GA588297@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Alexander.Deucher@amd.com; 
x-originating-ip: [165.204.84.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34fada3b-510f-4556-2ba3-08d73dd4f321
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BN6PR12MB1761;
x-ms-traffictypediagnostic: BN6PR12MB1761:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR12MB176154FB5FF711718C4EECB6F7880@BN6PR12MB1761.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(199004)(189003)(13464003)(5660300002)(256004)(110136005)(102836004)(478600001)(54906003)(76176011)(7696005)(33656002)(6506007)(2906002)(99286004)(53546011)(6306002)(55016002)(9686003)(4744005)(6436002)(8676002)(81156014)(8936002)(81166006)(229853002)(71190400001)(71200400001)(66946007)(64756008)(316002)(66446008)(52536014)(66556008)(25786009)(6116002)(4326008)(76116006)(86362001)(66476007)(3846002)(6246003)(476003)(74316002)(486006)(446003)(26005)(66066001)(14454004)(11346002)(7736002)(305945005)(186003)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR12MB1761;H:BN6PR12MB1809.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Jgavo9AiGY5EsDfEH9b8tTyXiyt0aVvi2gBs6uXErCU+VG6MX9ao+B/NwQNVQ0lNLDMYmjFY22PS36ENT+bB2Tzt1MHP7YcPMEpBSbPbKXEutTFo2P/vtlJAQ8JqiNsekuX0QLujeZ326hjnF1igjM4M9yBmwQgKF9sTGi87z5ka2xGemHzfP2MTNEc3Is6OKJaHN73WD/li4yQ3DIxjmJanuaYxqK30jpWtk/Wh6In6t2d7c/FWvhOy/kwTMY1Jc9F4iez58IUiNjOakx/teVoiCE0ZTtXuxSAOuFyvJ8Fhy5HLyLmgjELPCSQ6Cm+3ZQ4CzhKeHHkh+c9olSutQpfvGU1ufTQBv3stviTD0K7dDlXuIM/bql6hdnNdWLIQ2fY9FHTolVlomiPusQJIO3iDyEpsjsqCDQ7/e8AQPYg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34fada3b-510f-4556-2ba3-08d73dd4f321
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 14:15:11.5353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ko8brd2sWYW9pWC76MYyF9F7zB2MIgqbscOeuaAWMOCyqJxzv6wgCDJ9ok0ov3QvQ6mFY2xs2guIVbsAXL/qQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1761
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, September 20, 2019 10:12 AM
> To: Alex Deucher <alexdeucher@gmail.com>
> Cc: stable@vger.kernel.org; Kazlauskas, Nicholas
> <Nicholas.Kazlauskas@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: Re: [PATCH 0/3] amdgpu DC fixes for stable
>=20
> On Fri, Sep 20, 2019 at 09:03:35AM -0500, Alex Deucher wrote:
> > This set of patches is cherry-picked from 5.4 to stable to fix:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D204181
> >
> > Please apply!
>=20
> What stable tree(s) do you wish to see this applied to?

5.3 and 5.2 would be great.  Thanks!

Alex

>=20
> thanks,
>=20
> greg k-h
