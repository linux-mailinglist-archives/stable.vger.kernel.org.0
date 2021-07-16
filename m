Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1D83CB0A5
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 04:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhGPCDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 22:03:22 -0400
Received: from mail-bn8nam08on2059.outbound.protection.outlook.com ([40.107.100.59]:50273
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230297AbhGPCDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 22:03:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ao7aKN/7gTptrehA77bT+cN+hbHYsJ2xW7w/qLcYDVgUXe35fG9fex8EoDvbV0X8IYh5oc6EZM7Tka6iTdx4lKNh2zsleCc7qyWucSGrpjK8HZ9jMJGLC4zv6n8WM3+habIjKkYTqX+qBBtfajbvAnZDU4ltS/d30KRNpIAiX6EyFdsrtzBs+GcL78KOa6Vcn/6I8fdI+6S3LYtUQvPa8h8g67IB+DufAkYBDTFrFL7OKQxHhl4jLEv704b0kRqdAEcwsrlzMu1qRUVZlg8Ve9GnbD52kwpjuceP4nFau6m6OmYyYjrzFnNpwSpHzCvt8/CCa0WUyQKtwCEvzDZYOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGFjBs09iXAvNzihz4v+6E39gKFR5CISIIj6HRf1Uu0=;
 b=kuTkQdamklVbP0sWNNlDZl0NVNjmklLpNF/ChrwmEEcdQw/jJUUfa6QmHlH2diVu/R6FrBBcX0sMsweCCxzUPCBWs+exXTt49w0lELattkQ5fw8SHxfyAvvwVt64z36HAvheZNXUQONN64FcXXTbUepY7VNoEZl/rEDeVSP04x51t55Kb6R+qeqlcTsN+plvUVCPBEGDBnpVCdpGKGa+aWLajZgD+HnnvFG4Pv+iGZG71xPLdcyO/8IjCwSHvSn7OeD58KcVzwPGJEGDHb7hJeCZvGoWPmOyyba/Fr6DUpnPIPyOV6I16WChqbEa8k3n1lG/uzKv4vDeQvnNUNiWSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGFjBs09iXAvNzihz4v+6E39gKFR5CISIIj6HRf1Uu0=;
 b=YppATxhw0KHbL7wC33YwKrjd3zsqh+wL5wWFfTNvqFDWKQu1/T3p02DeFth13BBZJ3jVU7ayFE1seUPLsaIxjp/s/wAuvTVyknUcE+KoUDnwzQ3G8ZLrmk5cNIexd8MaZZbKCh/3tLAd5AEIwzslwGy66gOduaolxYYm0lFJ8Fo=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by CO6PR12MB5459.namprd12.prod.outlook.com (2603:10b6:303:13b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 02:00:25 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::f423:a6b:5d85:fd8c]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::f423:a6b:5d85:fd8c%5]) with mapi id 15.20.4331.022; Fri, 16 Jul 2021
 02:00:25 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "lyude@redhat.com" <lyude@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/dp_mst: Avoid to mess up payload table
 by ports in stale" failed to apply to 5.13-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/dp_mst: Avoid to mess up payload
 table by ports in stale" failed to apply to 5.13-stable tree
Thread-Index: AQHXeXVT5axIYUNa2UKt4ZoTYri3gqtEHksQgAAsQACAAI6X0A==
Date:   Fri, 16 Jul 2021 02:00:25 +0000
Message-ID: <CO6PR12MB54899AABE575A72A5A4F70A9FC119@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <1626351420140215@kroah.com>
 <CO6PR12MB548978A31FF543E2333447FFFC129@CO6PR12MB5489.namprd12.prod.outlook.com>
 <YPBwFGmNN2zLb3cf@kroah.com>
In-Reply-To: <YPBwFGmNN2zLb3cf@kroah.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ActionId=f608e207-1c9c-4c03-95a6-f7d7d262fd0f;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=0;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=true;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD
 Official Use Only-AIP
 2.0;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2021-07-16T01:58:09Z;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51a5cce1-7615-4256-2ddd-08d947fd7a5a
x-ms-traffictypediagnostic: CO6PR12MB5459:
x-microsoft-antispam-prvs: <CO6PR12MB5459F8D4032D48EF84ED6A2CFC119@CO6PR12MB5459.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SkzpsgcfomcWSLROdbYF6q5UwAtxwqxF4yV5/1fLoB8wnCMFyg551pqLIRrmiitNwqta8E7OxYdkIUTPKE5NZEMEBdOeUQssP71F8KG2HrOV0q/2Rp+wL8X0hrlctW6ncotlDIc/lViZlSSow8r3xoEMBrlNOZuy1+5p2ufRMwlyY1EFK9sOCNzC7+PAHJ6OAMrhAPY/Nsh33M7uizUMtv61B++QFroYfIAS1zOyZ8oDFGOAXap0jxCRIchF1K23H+lWR0jiLr6r91WEC6d5PoLM47Sf5hYOQmaANNnrhLYToC35p3AP5GQNYdoiESw1ZqtPcHK+rlyLMNFG3KCnQozX8zpH4twVCKWgkjGiM3iJd145YBUe6JoAZFxMYQy//VOFb31QpwL8nR7v6EiiobR3Qa+NQSeD7dIUTQrEdFC7RhAhcZXTcQguyQGLMlwJFMV6qRXQi8RiAtBR1iHYneyDpAN7ZadODfyygsLQ98FjWbbE17bGZYvYNbQHJyBXgCJhHpRVl2vxZnWHOWTMPmxLw2/aud1zE5Wt6R9YO7CPxMOxU61tHQA7a12yCUsMdlwy47FCZJwpI4Z0adSfsSOWFy3YZUO44tXEB0uibc5ASxiJ0UkPIBSSulsMnnF+kzOI89ncPjK9aTn+DcO1YpkrNsVvRzV/jCdED5+OfxQbDtkE7/rTT7GdNUNg1xrrtpsMM12TeTrRNaj1UmXMXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(86362001)(64756008)(66446008)(26005)(71200400001)(8936002)(2906002)(316002)(66556008)(66476007)(55016002)(4326008)(54906003)(7696005)(478600001)(33656002)(9686003)(5660300002)(66946007)(8676002)(53546011)(52536014)(186003)(76116006)(83380400001)(6506007)(6916009)(122000001)(38100700002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SgjxyxshO5nh3v5K/6hIE7ZSwYADFvvG6hb9P59W/sqj+3gjEcgpkyvSbnjX?=
 =?us-ascii?Q?5IdR32Q/aDan12/R3/OxjhaOXww/7iCImSJwCnvKvc1VFMwdaQGM3+Ke2s9h?=
 =?us-ascii?Q?9vPncrb3M7g7pk+XN7VhAmwdtGa67ZFkrhlntXuS+/anASQ8mttEU2c4Vs/D?=
 =?us-ascii?Q?bo2iOhri9AlYloQWaev7vwgCQbpfRQ2ufM02dh0t4dQ93QVj+cR2C1d35hqg?=
 =?us-ascii?Q?ngT7GCTTFmWCrJIRR7nb1R0T4wnNjuThGOQajczK3dHbQmibN99hdLxnHGvP?=
 =?us-ascii?Q?lSFV4p2j5N5AXeLEnpq9Zwc7qobAO8gHjQSFxl9v6uYJ15UxpYeQY8KgQWG4?=
 =?us-ascii?Q?pI6oXBhuv1r76O/SzaWQtEEJBzGt6LsekFKlZnGg2YBbvyYMjJsnZW7CiWF8?=
 =?us-ascii?Q?AyVs1quhnT10Mbe3+uhpF/nFyA3/kEE1K9zsXa/SdfhwDXST07E2zeymJKoS?=
 =?us-ascii?Q?O7dCU/lqMWy02saMv+9IFGj0kQ9+HviGflzI1m75GnYhDeG3TbtNCwyyqQ1E?=
 =?us-ascii?Q?xzncDjGwBnU6mE9TotEgVq1uxiwCl5nRibvtBfSuzadmqJEM2mDmSxXk9xT5?=
 =?us-ascii?Q?61Ab2EjYWCIgMIKSOXtOFxDwPmQhaQBIbcHc4vK9KZnzHaO/4qwq/gvgZuG2?=
 =?us-ascii?Q?8NrrOytP/OTrmLamH+USDaPiyBzkl7zOgvDN4GORcG2Fo6FLvlLPkvBTJedn?=
 =?us-ascii?Q?4EioR+YvgnYzkN5SYiY/XOHPtvn5mmKkkltqu5kPfD5+F/hw9b/gwUq3vZCn?=
 =?us-ascii?Q?XoBkpazSbgGl85jknBz3euo6h9VA1MuABynIRBzDSy7EBsZupC7OfLWrqBUa?=
 =?us-ascii?Q?eSQC7d4MINr8+Cx6jvp9xUecVZjKqOMtpoo02INclmYk/dJtFBhGIWJgWmkM?=
 =?us-ascii?Q?xbkgRFglkn88JCrAGQ7rECn3SCLKiqbH6CumdH3lqQx8EjZz2i2a1SKC9naV?=
 =?us-ascii?Q?DWbTCi+poQYEP1NWIrcBeDMO6rHR32ZZNUpTMh5MjAIRbKRSevDmymVOHe11?=
 =?us-ascii?Q?6NOH0SxiM/KN0mWoSdbNGExzQY/p8kK9/YyEkv4tUYaXreE5OFO06Gs0f7+X?=
 =?us-ascii?Q?Wr8IlISUTMEsHXrkTFOmQyDUcRp8bkZU7gdVXdJbHOxQFApghUGx85JsKqSB?=
 =?us-ascii?Q?RlWSGH5GEII3ZbRsBuEMqbjCJzxvZiIamiYRnm/ZgoF8krgh85ZXQDXZ6nuc?=
 =?us-ascii?Q?03R44AqGUaxRTSeLrJ031w0AbHRCcoGxlZEmDTaWMADoKin2L/1ZxZ6haYD7?=
 =?us-ascii?Q?OApqKaeRo+NiPZ6YakRLD9d9r+qpYhFHsov+44jwWGBmRJzJAruDIEef9V/H?=
 =?us-ascii?Q?3BFF70upJU3ZFXIW5WfOS/NK?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a5cce1-7615-4256-2ddd-08d947fd7a5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2021 02:00:25.3320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N814KNW1I5EV75602iriW0herfmIZWdrXDTiGxibuFEqRk0mNWjDxAAU0kmnMCfYSc+Y8pZFk0rOAbiD1yO5Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5459
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only]

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Friday, July 16, 2021 1:28 AM
> To: Lin, Wayne <Wayne.Lin@amd.com>
> Cc: lyude@redhat.com; stable@vger.kernel.org
> Subject: Re: FAILED: patch "[PATCH] drm/dp_mst: Avoid to mess up payload =
table by ports in stale" failed to apply to 5.13-stable tree
>
> On Thu, Jul 15, 2021 at 03:07:19PM +0000, Lin, Wayne wrote:
> > [AMD Official Use Only]
> >
> > Hi Greg,
> >
> > Really thanks for your time. About failing to apply below patches to st=
able tree:
> > 3769e4c0af5b82c8ea21d037013cb9564dfaa51f
> > [PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale
> > topology
> >
> > 35d3e8cb35e75450f87f87e3d314e2d418b6954b
> >  [PATCH] drm/dp_mst: Do not set proposed vcpi directly
> >
> > There was an immediate following patch to correct the issue caused by a=
bove patches:
> > 24ff3dc18b99c4b912ab1746e803ddb3be5ced4c
> > [PATCH] drm/dp_mst: Add missing drm parameters to recently added call
> > to drm_dbg_kms()
> >
> > In other words, these three patches should be committed at the same tim=
e. Sorry for any inconvenience it brought.
> > Please advise me if there is anything else to do for having these patch=
es applied to stable tree.
> > Really thanks for your help.
>
> These commits do not apply to the current stable trees, so please submit =
backports of them for how ever far back you wish to see
> them, so that we can apply them.
Hi Greg,

I see. Thanks for your time! Will do.

Regards,
Wayne
>
> thanks,
>
> greg k-h
