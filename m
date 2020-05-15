Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437F81D57F6
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 19:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgEORbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 13:31:21 -0400
Received: from mail-eopbgr750103.outbound.protection.outlook.com ([40.107.75.103]:37147
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgEORbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 13:31:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ld2UG/qhw34tyfhC4Df/XJ5gpSSDtiwHT6wetC/B+QSRbxs9pWDIcb6VQQywjItRHCryTNZryrjR417WRSDwjI76G+zep3xvoynnh31Waqff+Nmmlh75E6fL8m8/FQx+WfeYTRl36CO62vCZKr1yGRL1uQhrDIaJLB02Ph4oudCp1m/BKtS9SuqI3TAQVAtE6e51M+/3c7mk5K7+2xY7DM2MeeUvCOb9pg6r0cdUVIn+rUDHBrr4Om/IpNXw+ppjB880Y2YtlDJIy8Rwl7cMcxVD99QsVy3mOftl/7BdNnCnzT2iFjhFey3TeT9GbBxvf3iCPyFflD82W9WeG49JPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xN5OcL/BoLxsqm6h+hWUVPH3oxT9j5TryL5u5t2YNbk=;
 b=IpA7ehsaeO52YpkzXvwB9Nfuy6Dr5S60L2FDtWziKWyPdV1OEj9mJpzJsv8INp/MW+SeJRBrcjNmyGGtuup9iNQRr5WSWC1ZBuEpCQPb0sXmbj7z/qQivDtjGtrwJrGnHuGJHB/U+TPq1uAq1tMAkb73sqybHW2kUR6DZAuuheOAuy5Qs0GowgSV2oYFgqsVpf2UjrYTJKKLDahglMv61E68giw3moVk0dvqIjWPNWynz5Ct9cgSd1GlM0qTcMy0bexM2LbvUZDCeOxiNbJ4tSqQNXdNCQJONRWg3UkCUvbuzpjUAwis8P9zbZXPFsTnzgbodLvd/ndNdpxF1HPISA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xN5OcL/BoLxsqm6h+hWUVPH3oxT9j5TryL5u5t2YNbk=;
 b=LhP7hUrMvROONZOdNt1qtdecDRO6uA2bGDgGx6s91Rsewvm0EXqrqOSCkClFpKhAe1I2gY2Oe/F5vSlsip5t6AgcjgxB0sNXYi/U/qIlKqYagUaOw0Xc/wGzusfqPjS5SBiqFiSSAp/XWDX7i8aqiSvAKgTosipufFJkcvxM6oA=
Received: from SN6PR2101MB0974.namprd21.prod.outlook.com (2603:10b6:805:4::27)
 by SN6PR2101MB0926.namprd21.prod.outlook.com (2603:10b6:805:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11; Fri, 15 May
 2020 17:31:17 +0000
Received: from SN6PR2101MB0974.namprd21.prod.outlook.com
 ([fe80::d0a3:23c8:602d:c574]) by SN6PR2101MB0974.namprd21.prod.outlook.com
 ([fe80::d0a3:23c8:602d:c574%4]) with mapi id 15.20.3000.007; Fri, 15 May 2020
 17:31:17 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>, Greg KH <greg@kroah.com>
CC:     Henning Schild <henning.schild@siemens.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steven French <Steven.French@microsoft.com>
Subject: RE: [EXTERNAL] Re: backport of cifs patch to 4.4.x and 4.9.x
Thread-Topic: [EXTERNAL] Re: backport of cifs patch to 4.4.x and 4.9.x
Thread-Index: AQHWKrh1sZBW0BPoHEeReTLP1WQLpKipJPqAgABCcEA=
Date:   Fri, 15 May 2020 17:31:17 +0000
Message-ID: <SN6PR2101MB097473B87E1F9913926FFC2DB6BD0@SN6PR2101MB0974.namprd21.prod.outlook.com>
References: <20200515134420.50480bb7@md1za8fc.ad001.siemens.net>
 <20200515125748.GA1936050@kroah.com> <20200515133159.GE29995@sasha-vm>
In-Reply-To: <20200515133159.GE29995@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-05-15T17:31:15Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8446b63c-6b44-4884-91c0-24f8ad52c520;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [174.21.165.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 111c44e1-7cb0-41f3-ef50-08d7f8f5c680
x-ms-traffictypediagnostic: SN6PR2101MB0926:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR2101MB09264F97BA6D697BD5694E8AB6BD0@SN6PR2101MB0926.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: crvLMRM7JNTFXRBIF6XM5NJSP88yVh/y0JLLNMh3e0qKAU5WJ85VUb/zYPCKP6UzboOjSP6k0ybiJxx74x7KD8fRtWcnkOUPNEf7O3q+GkLP5Un+KNLSlyS5fNFaQdSglq3cK3Vvbj3BrUeOAJlkMtEh+Xt7nx7P5BS+gAvShyQfCr7aV5wkPwSKxeusKpDut+ufDt00wTOubAprc2SVx/hO2raHwcaLDHOEiyxXD0UgXoif/qRQ8/nF8r2EzHk7fI9BP+0BZ6t8TkMRE7R33pJRaaNesez1eMMJo6P0b/LYNpjBzfJAnorkwAJmH3pYmJv5xEaJwGxDOr7xPfxhmk75kZxrMdXRayDZA87mPk3UO0p1NiVo17AVRWVbbhjNQcFR4tUhq94MHffiuXNNKeiGqzSJiFhwtkLMpIZi7Y3QRksxVa77qnZeNmmtA86v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB0974.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(64756008)(86362001)(82960400001)(4326008)(82950400001)(8676002)(76116006)(478600001)(110136005)(52536014)(66476007)(10290500003)(66556008)(54906003)(7696005)(66946007)(6506007)(107886003)(2906002)(26005)(316002)(71200400001)(8990500004)(9686003)(5660300002)(66446008)(33656002)(8936002)(186003)(55016002)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: J57JsAw10h4HqzVnz/bRwvh+WAE6NFZ6f8LOqtWDcSFAyLPYmQepdMUB6AeJlfnlUSYHGhe2b9chQUKoQ9WrtzcLoadeaU8G2ncKM7GJC/orfTwwYy7CZJKPHgwe1FDHBQU6V3lYUGFOyxJ9iYpkUzQPNQ6VcH5bHoX2UFYhOC95jbuvsirS7Mu5kFhojiiyioH7pt/HybZETKVgQDrvk7SvjqsBCwl/0Zwn8jB2Lp7GTvcMG0f9LsMv4UvoZz9A+UdG8MtdElJyuBoSBeGUSUayBJKLc3tSWd74bLbUe2SyaD+jMUlnNk+jKI/azPgu5qF/zXXDy8AbRNzv2UyjGOIcHLJOLoGBODNV/wS3bw3Jdnt1ynSOgCIfQzgsSOBmJYKJaEHHUtrjhULrHVjH1aRI0y9VRtg9i/Q3E/EXzExfSbGHDZt+JBkY5oby3mMRu/k2uWNWX7pDVFDZMhL/vw6Y6v6TbzYtfxyvAff0lYc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111c44e1-7cb0-41f3-ef50-08d7f8f5c680
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 17:31:17.6009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jGPg5OPDVcWBJOvXfyUwH3MW7752I3EcgsaGDAWa4Nxh8QxsWNgHjgvkjduS2407Oib7TTBOoVJSS6j6p5Legg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0926
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 09:31:59AM -0400, Sasha Levin wrote:
...=20
> I've queued these two for 4.9 and 4.4:
>=20
> f2caf901c1b7 ("cifs: Fix a race condition with cifs_echo_request")=20
> 76e752701a8a ("cifs: Check for timeout on Negotiate stage")

Thanks!

--
Best regards,
Pavel Shilovsky
