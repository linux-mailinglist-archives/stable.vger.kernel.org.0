Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B864D188E4B
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 20:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgCQTqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 15:46:49 -0400
Received: from mail-eopbgr1400121.outbound.protection.outlook.com ([40.107.140.121]:52546
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726555AbgCQTqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 15:46:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NstSNvJaEBYCmf0bv8SXGAMc88xeoVBWIcdEEbnhwGSTTHz4TYMhncDBE5NW8osPC3PUmXt8H4kICGlFYV55yN7UykkM3dcXmlQ/Ge66LhmGvIPn8+PaNFigTBGPe6id8o6h1qauZhVJQjcwoJr17tEVH2EzATfVC+SjUssOZsMZrXcChxlhVifY4fKxXcTfv1DC10R3c5CmdOHAb/A2m2XwOSFlqM68q/kK8HA+JGzEnqM7fk/fIExdj2Qgr0ifbyD/rGIcF2kaHG6lM4/Fe1DukncfqJHwf32lFPRkoIYDifQuR8xnAe7SCen9DTGvpnU4mNcuCi2qbifgaRhBmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARlASKY5YlAXGKgvUSVcITt7nUO35fqVWnkYIxCw/VM=;
 b=FHb2FyqR4a7/egT/Yxsiar9q5oCwr9uY7qOmJb3yF0O4Cntx+sVk6GhRG+F70WbNcqXQQ0yHDb2tenJ56zphtZaTbegcFOjVyr2J/LX8vnpLV5Pp0UvmEwATfmwjXbmKPI5Dy1i/44TlWu4NdQV1nV2CTRKFpO4jOabHtwcxp4REeLcXhpKDQPD6QJZyh/ztG9I5tz3N+Blh1Myn360eK1q3tNSzr1qg/bFYDLyAlpRKrr0RCGFPHz/tQDi9eqeCIQvQVpqHdtsntHMMMSYrhCvY+cUH6e1gvLJUHqFg5KZtcmaPz0sYH1IqVOSgm5fCU4akLtxXndPohLLrSTBiXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARlASKY5YlAXGKgvUSVcITt7nUO35fqVWnkYIxCw/VM=;
 b=sjmWqFOnEVsQO6qynPInlNiWumHsLi+alwXLOqYXIWU9oaYftrXNEDIMlDkSLpuCfjHB5w73k33e2tCAfxydvlqcRcFcuU/z8nXAUQIcQbmA6L6yoXt9p2DJ2xsmtCHSW8PfZF9IYUUCDjIMUg1Ky5iFEU7p2PCz0Zy3alP99T4=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB4733.jpnprd01.prod.outlook.com (20.179.174.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.21; Tue, 17 Mar 2020 19:46:45 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::a882:860e:5745:25e1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::a882:860e:5745:25e1%6]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 19:46:45 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4.19 00/86] 4.19.109-stable review
Thread-Topic: [PATCH 4.19 00/86] 4.19.109-stable review
Thread-Index: AQHV9t2MWw5vCoRaqkyWbNkUiDyKMahDMLzwgAAvTYCACdqSYA==
Date:   Tue, 17 Mar 2020 19:46:45 +0000
Message-ID: <TYAPR01MB22854206B2C28CB7FDFE5143B7F60@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20200310124530.808338541@linuxfoundation.org>
 <OSBPR01MB228067017410645AC3A78939B7FC0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
 <20200311131341.GB3858095@kroah.com>
In-Reply-To: <20200311131341.GB3858095@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [188.223.77.164]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 42e15800-166d-48aa-a7f6-08d7caabec9d
x-ms-traffictypediagnostic: TYAPR01MB4733:
x-microsoft-antispam-prvs: <TYAPR01MB4733D69B3EA188ADAB120E74B7F60@TYAPR01MB4733.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(199004)(6506007)(5660300002)(7696005)(316002)(54906003)(26005)(71200400001)(4326008)(52536014)(186003)(966005)(478600001)(66946007)(81166006)(64756008)(66556008)(66476007)(66446008)(86362001)(55016002)(81156014)(8676002)(76116006)(9686003)(8936002)(7416002)(33656002)(6916009)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4733;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FKu0B4MGktcPwiB8bRFIdPc5XBFWweohg+GJm4woVgx9Mk+HsURrgJ2Z56t198LRF/apRNCNU30Wgg7f1TAWNjMdSQjJ3sNzysLKJPLGSzUSRqr3/05dG7SCshyRZ/DmOjaOKgIfjzvrLw2GmC9zrVjC/asjofv1/ZasdZv++qysM2xnu5Kx2soTkLW+zH9w2mmhnW40A9g7HGibT+m4oVyHlEtJamTSb7lN9NImHIvWcZVWmJlSikasFRi83VMtGbO4i7hjiUD9RdQGyIxdf1NTP0zbSEb1scnKQ1LoAlCTBTWGvOJ/tayF5+yW3oujRU9+rVVr26ziFWzY1ZGn2LQVc2/21DJw4O66Afmr1x/SJvZTUsHQOmgy0gCGZLRrlPDVauORj8UCrClPqaDH/fDQa/WvWr/hMYqiAVPaLB9cC4P3DdWjB84bKmC2O9FPeoYSFtOjMN7/wtZ8faZKw3Oae7yghEk1ji/X+D0Alcfr8i93Ci3/m878OJlhQZbFBA9W7gj8Co8dnURNijvsTg==
x-ms-exchange-antispam-messagedata: TrAK8r2Kinzjx8+vwM7P40xTgLY6Lkb3DudFpBBgDU/R5fjIYkfEAaemKoHeaLU7Rpl+z1XYzFGaz5dA8hhhQOkD/CQ0OGofwxMhTRAam2j8tqZALJFxvaRofSEw83c56k8tj1asT7QI5UfQEFZFkQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e15800-166d-48aa-a7f6-08d7caabec9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 19:46:45.2858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +RFGW2sEPJNqBjOzjKEDCMh66IWMUZ/fZelcf8+EEDWp3j9BkLhZHQP7XKAmxUeo075qJ/H4az7sPzTfcbC/HSpAMtmvYoMvQBgqx1m+Y9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4733
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 11 March 2020 13:14
>=20
> On Wed, Mar 11, 2020 at 10:56:06AM +0000, Chris Paterson wrote:
> > Hello Greg,
> >
> > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > > Behalf Of Greg Kroah-Hartman
> > > Sent: 10 March 2020 12:44
> > >
> > > This is the start of the stable review cycle for the 4.19.109 release=
.
> > > There are 86 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >
> > No build/test issues seen for CIP configs for Linux 4.19.109-rc1
> (624c124960e8).
> > (Okay, there is a boot issue with the arm multi_v7_defconfig, but I'm p=
retty
> sure that's an issue my end that's been around for a couple of weeks now)
> >
> > Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/li=
nux-
> stable-rc-ci/pipelines/124879010
> > GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-ci=
p-
> pipelines/-/blob/master/trees/linux-4.19.y.yml
>=20
> Thanks for testing 2 of these and letting me know.
>=20
> If you figure out the boot issue, please let us know.

Sorted it. Just needed to get u-boot to load the DTB to a different address=
 to stop it getting overwritten by the giant Kernel.

Chris

>=20
> greg k-h
