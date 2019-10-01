Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72FE0C4410
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 00:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfJAW6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 18:58:35 -0400
Received: from mail-eopbgr730139.outbound.protection.outlook.com ([40.107.73.139]:6118
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727362AbfJAW6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 18:58:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0PP7w47Xh6jhCND1jRH4DYck4aNSDSVtNtardrUsYS636p1uw62tt5+eDeM3ihVZZRfMplPIn5AlZT1iIb8Oyfo4ZOBgO/CQ2R+tF3MU6bF0Ekhhc3FYk6p6Li6IiTYifHxL/SnwRkSCjbpMV11MXbC8FfIPPAwxQrpgG3c0lkImO9bnNHnJrNWE223XmwJ1KgiThLdAZJpXhyeyR/QvtpyO73G7sCaTh1oxpzxSfCHjKbuOt71e1a+rbmnMD0BEdiM4Pyq5TTVjs+GSrGYfsLXDwLM3NIk7FM2FacTnNetGNoLyeZOYrJUVjSUkH/wqjpX/7TNHX1K6xU3N409jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PG+JG67IvM+tCUi7GMob6JClhFJdru1ErWlwVGQiLk=;
 b=llQNRKSDezgxvf9EX/J2q+ZGKnBUPlC9XzAXEyAi5O8wZoH8F5JqLZ/txNguerXlrYGbtf8hmj2rlNPzEiB4FL7xO8tDi/EPzSSiUOnMRZeHwaPojrZ+cgf0VQvc5br/ShgDGPsEUP4x/533BSSzm8NbDPv+FEM5Jdg4JJ7Tf0Duj/GTQpX/Xe0CHijsrMhuBKtoimtlmttCuNGdEGiiSy7fDh07BRfk/EcIJv32JhmmVfp3etugT+DwARNsXcrOfbRA59Qb9c3hUCwplzIAKD5EaK7IJJ7pU2OyUT4mj5q0Ndbu+ye1uOG2BgRHkoVvSJz+kNlwfXAtcRtlKcllcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PG+JG67IvM+tCUi7GMob6JClhFJdru1ErWlwVGQiLk=;
 b=KmOintRgxSJHR5xu65+mEGFPFVsbHCGjdTiuPRpeg8vn8A0KmMh1PORZl336XrCvaZohqJqbYWOTFMyJw0L8hfE5FiII+4ivSH84QOPmOol3YPerpAov6akV0TaBwVhtk96/mlSP3iHCcluSD8XWw65PHYE8wBmTcPna8MhP1Rk=
Received: from BY5PR21MB1395.namprd21.prod.outlook.com (20.180.34.12) by
 BY5PR21MB1508.namprd21.prod.outlook.com (20.180.34.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.6; Tue, 1 Oct 2019 22:58:32 +0000
Received: from BY5PR21MB1395.namprd21.prod.outlook.com
 ([fe80::81aa:19e8:4e5e:b2dc]) by BY5PR21MB1395.namprd21.prod.outlook.com
 ([fe80::81aa:19e8:4e5e:b2dc%2]) with mapi id 15.20.2347.003; Tue, 1 Oct 2019
 22:58:32 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven French <Steven.French@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: RE: [PATCH 5.2 02/45] smb3: fix unmount hang in open_shroot
Thread-Topic: [PATCH 5.2 02/45] smb3: fix unmount hang in open_shroot
Thread-Index: AQHVds5cF4tEGrkArkiZ6kF9upgKeadGQl8ggAAk6ICAAAJZIA==
Date:   Tue, 1 Oct 2019 22:58:32 +0000
Message-ID: <BY5PR21MB1395063CA8DA58DD499C824FB69D0@BY5PR21MB1395.namprd21.prod.outlook.com>
References: <20190929135024.387033930@linuxfoundation.org>
 <20190929135025.151404151@linuxfoundation.org>
 <BY5PR21MB13958939EBDEB4122A29675EB69D0@BY5PR21MB1395.namprd21.prod.outlook.com>
 <20191001224913.GE17454@sasha-vm>
In-Reply-To: <20191001224913.GE17454@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-01T22:58:31.2359094Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7f61303c-2db9-4607-916d-9d910e961a42;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:994b:430e:3aec:b167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e16899d2-ea63-439a-36c1-08d746c2e207
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BY5PR21MB1508:|BY5PR21MB1508:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR21MB15081ED09C918F91A2E0BD5FB69D0@BY5PR21MB1508.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(199004)(189003)(13464003)(10090500001)(81166006)(6506007)(99286004)(6436002)(316002)(22452003)(229853002)(186003)(305945005)(46003)(14454004)(7696005)(7736002)(76176011)(102836004)(54906003)(86362001)(4326008)(74316002)(6916009)(8936002)(81156014)(478600001)(6246003)(55016002)(10290500003)(25786009)(9686003)(8990500004)(64756008)(66556008)(76116006)(8676002)(66446008)(486006)(2906002)(4744005)(11346002)(52536014)(6116002)(33656002)(71190400001)(5660300002)(71200400001)(66946007)(476003)(66476007)(256004)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR21MB1508;H:BY5PR21MB1395.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rROj/HvoDdbfQE4yQSc7sKEhYrj7A2TWC6h5pYQCLquZqAooPIZkHC1rifFcjuCrK9N7/w5BjAwb28F3P9xCxI6lfeijBDCBsryC6HgrcEi2N17bSpc6CLjO99uYaapGmXRozeb+/kOfDWQgjvys2rLOSMfqaS4OGo+va2QIZeSq9gp+alpTgcIsjFGO4yC9FddZVeKe1IJ+SAXEQAI8jfPgk9Jw2fS1nVfANcnljIUcxgrZeY4bIWcdqxgY+VjWmSapwFCtkRnYGrtQ+7Z7pyooxAnlfdrpLU8z2jxxr1u2XVasUvesdb5MXxAKf1aUD+h9mOVfVwVNgI5rwGjDUmhgBcCUMpLEjFdP6EqFagZSK+80oIouKRCsr3Xpe1MeR3GhaqrWKyYpqToqyi8QW58IgmpzlUupV63pF5Jssww=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16899d2-ea63-439a-36c1-08d746c2e207
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 22:58:32.4636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6e6XKxKnp2HYGvYQnhss/OBfk2R3xqnLQXIKHSoIB+qb4onKvkRVG+x1TZFMT1u7NVNFmlo+2FFpNaFchSI5VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1508
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----Original Message-----
From: Sasha Levin <sashal@kernel.org>=20
Sent: Tuesday, October 1, 2019 3:49 PM
> On Tue, Oct 01, 2019 at 08:41:43PM +0000, Pavel Shilovskiy wrote:
> >Hi Greg,
> >
> >Are you going to apply this patch to the 5.3.y stable kernel? The patch =
is applicable there too.
>=20
> I will, yes.

Thanks!

Best regards,
Pavel Shilovsky
