Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9114A28F310
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 15:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgJONSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 09:18:37 -0400
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:25696
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728418AbgJONSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Oct 2020 09:18:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6Jxzi4DMmOf2O/+scMktAliezLfxX/hswQ4XmKm6ehrKNceDTDJm1rmYVV7LVVdTMtUsA+Wv/2s0Suh0D0yMJsXa75de+HYmvYKqGS+hX21xBO/Vd5ausc2uREsLiQlkbHXW+EQZg0zSMekGFxe2SV/885G37EHmmrAaC3C6SAzBWzGa812a2DZRb9yXD64jNwXI1TLUSB5W+XunDaE6MV6SvBWDhZBw7IOdELNKcZ/bfKmGUkTEEiYAm0JiYAJE+/4cFzkW7Gl+vr/2xdYkEX7We550kBTZHc+2tUy37CciZB5JNT0CB0txbGoOTR8psbmpLedvZwqAfP4gly0Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2q3hzR2KbCY1G5qi/aeoMdsSsacCL6VaqVi+v5nhh/Q=;
 b=SngFrLjvBz8DNcDl+El7weOeFrqcurKdlREMtdI0PN+n/jFZNu9tFQ+z/RXPKCUKRYIubXmeKMZZux4OvYuNJSw77fhzju+jSMwi88N8B7Y4nz/UvHEui95DT0BiGQH+shKPmyInkcCldYreBU4JZriITG7IfOTqqxcAlQAFzWDVQThwYZEf/qattfHSqLpOTUJdAu0kTPJPLbdBhQmH1HUkaBAZzsw63syQ3A+xS0RKfkt+SnDE+DMzxv6h4tbBzOZ6geyG/M+cvncQwo7h5l6EZNScLKMG3r204YZ2YBf03gkBDTaBymxrLemcjwRLhWIL16nb3/2i/B+uIKXPxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2q3hzR2KbCY1G5qi/aeoMdsSsacCL6VaqVi+v5nhh/Q=;
 b=FEbgQhaFN7/1xxQRhsZa7itNA39P9qao5J2w0Pt6v3mIr2n+r6mlv6jB4NfNFkQ5I8+P9S+ca1i4PCAjDB1xSddrjS2WUc8l7On/mn5FaoGDo0KvjN6BFQPkUsvJhBNg5dccJzv0W+fiJjd4E4GkzaC/8i3OCmhMoD40FVb5OhY=
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by BL0PR12MB2338.namprd12.prod.outlook.com (2603:10b6:207:4c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Thu, 15 Oct
 2020 13:18:34 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::99dd:ff77:1ffd:d96a]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::99dd:ff77:1ffd:d96a%3]) with mapi id 15.20.3477.021; Thu, 15 Oct 2020
 13:18:34 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alex Deucher <alexdeucher@gmail.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs
 handlers"
Thread-Topic: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs
 handlers"
Thread-Index: AQHWomieOyAGFaf48EOq2y93EG1BbqmYH2aAgACGVcA=
Date:   Thu, 15 Oct 2020 13:18:34 +0000
Message-ID: <MN2PR12MB448853FE73DE3EF2D64BE36CF7020@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <20201014202836.240347-1-alexander.deucher@amd.com>
 <20201015051451.GA405484@kroah.com>
In-Reply-To: <20201015051451.GA405484@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2020-10-15T13:17:07Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=51a1dbac-de9e-49de-afb8-00009f7cbe1a;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_enabled: true
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_setdate: 2020-10-15T13:18:29Z
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_method: Privileged
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_name: Public_0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_actionid: 43683619-6795-4775-a2a1-000099ae216a
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_contentbits: 0
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [165.204.10.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4ff6a06a-eae6-4bb7-5665-08d8710cd1c8
x-ms-traffictypediagnostic: BL0PR12MB2338:
x-microsoft-antispam-prvs: <BL0PR12MB233838DFA478A638CF4EF089F7020@BL0PR12MB2338.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qYQZkAKcvk3yZsHfisfWgri87hxjqfalNq4MkOafjZi8UEwURY46gq6GNZQEs+UmQnGzKell/k9daKfxRLuyaJmWeQSMk99FoJWHMDEfINDBL8lf1bcyp3nVhkhj2coYy2JWRdO73k6Ko9VVK9tuxuUTaSCnN1fAMc8Z2e5Awms+0ut8UakuAmor+spfQpmwA6zoNGcsEIdpXDwi0wj1DD7lFYKS/vf/Vk1PBGUyeAWifHOJiujoF4C2mXErj4HewwMMhhoyEH7EZyxhGXogvb2pVZ3AwkXI23rS1h63AZGFAyYxOpxHYzA6m5w3vlFr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(8676002)(83380400001)(86362001)(8936002)(9686003)(110136005)(33656002)(316002)(71200400001)(64756008)(66556008)(2906002)(66946007)(66446008)(76116006)(7696005)(52536014)(478600001)(26005)(186003)(6506007)(53546011)(4744005)(55016002)(4326008)(5660300002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +9YZCUJOD4ROIGQ2FNwSrImh17QyEBvbzVXJlb/cnO1f5TofTqmXHxLMRt1kdzZdpe8Jf4QIACzNA4duv2+qt2Um98rs/aXrda+O0EFQknapqGCB+XCChouUmlYsj7UkYJXWQz7NnjKjhknpoQKigX1LvbSiFxFSeSnIl/P7GaS37cQXPmitBS7AGS3Fgg74iy2hnzu2EnjRuiqW2KBwnBlGUYsMGTMKUfykNNXdBgZvzMZpcih5QW4cqy9hpM7qv/B0qJaW/juzVcXu15W1MVbdQKgZSbwrMX/kuba62RSSNN1p2fbn1rgygAqalvrvbT6qx09Rhkn2KaUCFZB331aCu18w+PxFDgsuyD7L7YJ9vFKBESJK8YbU4rXQm18wg0NOnXC7ItXbckXRFtaOIMdJjdpd0j378vmFkGuyTWw5JysxSBf4tRQh2O3EBxrePOkxMx7TWyn5jzs0EF5eGFKlsvauFT7U5RpoNzcF1/b+3BkWAhHe3jW0/qM+91RjSxPrgV3q/a4Gl/XB54ioNPR6q+82KV3145Gk+JrRmDjqDSKuq7U1VXQGzqxKScAVngEPPh+uAPb6XMPuQZtUr/tZEeojNStS0ZFILwf4/GZoj6w1z8yzxaKjMaQ82PQJntLSQ1ZToGNIY/OEWQox1Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4488.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff6a06a-eae6-4bb7-5665-08d8710cd1c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 13:18:34.5570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mpo6wtgN0QAp8SrAO9wdBteDI0oqkDTlsApvgu3kVS72ToqGITvQ2P+H2AOj2kjVKlZJcBH52MJCovrYcR6S4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2338
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Thursday, October 15, 2020 1:15 AM
> To: Alex Deucher <alexdeucher@gmail.com>
> Cc: stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: Re: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm
> sysfs handlers"
>=20
> On Wed, Oct 14, 2020 at 04:28:36PM -0400, Alex Deucher wrote:
> > This regressed some working configurations so revert it.  Will fix
> > this properly for 5.9 and backport then.
>=20
> What do you mean "backport then"?
>=20
> >
> > This reverts commit 38e0c89a19fd13f28d2b4721035160a3e66e270b.
> >
> > This needs to be applied to 5.9 as well.  -next (5.10) has this
> > already, but 5.9 missed it.
>=20
> What is the real fix for this?  Is it in Linus's tree and I can just back=
port that
> fix?
>=20

This is no real fix.  The revert is the fix.  Sorry, I should have clarifie=
d that.

Thanks,

Alex

> thanks,
>=20
> greg k-h
