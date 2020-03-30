Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C888198823
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 01:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgC3XWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 19:22:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:1588 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgC3XWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 19:22:07 -0400
IronPort-SDR: EA6QdyGvwwnWZnLXK4rNx6mugdPQvOkLrMUudx44TE3Mdkvp1AN032aMNvTk7j+2iELCEsgFQH
 /W6Dg8EkvcTg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 16:22:07 -0700
IronPort-SDR: XQ5WVjInFRIcWHq1Av6XgSl9jsFQDWNl3Wvu9RtqOTLAT+RmuJGwRhXjg+wiMBpjQ3EBttnvKj
 HAyncbBBcevQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,326,1580803200"; 
   d="scan'208";a="449965209"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga006.fm.intel.com with ESMTP; 30 Mar 2020 16:22:06 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 16:22:06 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX157.amr.corp.intel.com (10.22.240.23) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 16:22:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 16:22:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsWJGr5m2vnvroTtYlxCvvdj9yVNnT9+K1pr4I+jmjZPeFbTl8gOJjTv4rRowcCdqSU504WpwN7ZZQVMe1w4LxCWWqFo2Es+t9o6Gq77Xwgd5Y4E8lySiuldmJRoU8Lx3I3VC/5m3TXO8p432/N+5j771T0YcFRu0Uuuo4MNvJnuwSjoGBhkALiYbF9hkNmiZ7xMDFY+BsUgegU3ZgUqxjpAszhU65LrfBGSx+HDw8DFq3x1FsUbcirX8hWVxmw22beOaHl48xGH4C3j3B+wCvVNMbSq+7ujk9rK4APo+5651Zq7UK74iKAJ4SfNqd3BVq98inzUThQYFkzb1GxLDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYj+x6ADGR+8oLqwUO44OqYkXt7PD+FT7ifYUTiIks0=;
 b=hMLqgYMwlG0DECD+UwY7KoC3EWpd6FtWx5IiafBKIplupVqcV+GF/krB6to2GScZUbg16Wakj+XyrudSCKteAArUQdsXMaLfRPaFarYPkHu24/eADih4yZE64DGQfKD0BPiCj7cdBMGqRmRINDIul1AjnSh+gzeQKMtUV5M7FVtVIqQK4UX4aSvu5xMOJJ6X34/IoJvXbbyKufE+pG1ww2Ov85aDdaWcWCFrkvbCWKcH9vz7uS+bb7GJUmwRn4iXVnt3Y/tmyU+Qc+8WWkMVRDtYlc3+AO3/nQxrdEul3smrgH/VoSl0eFzZHUcMk01NFs2wVQGYRpllNI/mS7N9RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYj+x6ADGR+8oLqwUO44OqYkXt7PD+FT7ifYUTiIks0=;
 b=iCqKPJ4Ywa3M1Uk26wBaisHwM7wzw6Y7zHe1nBKrk9OznEm/uHz340o0g8ppzwuPBCWtzQNd/wTeRA0nKzU11pGHkFNq3eygQe0sC8E+kjRuNJfqxV9ZJE52ZM3csAqEZa5yGyEUa+ANZwEZ1TEm3uHgh4pR3i3/3/eMNruh0Ic=
Received: from BYAPR11MB3624.namprd11.prod.outlook.com (2603:10b6:a03:b1::33)
 by BYAPR11MB3269.namprd11.prod.outlook.com (2603:10b6:a03:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Mon, 30 Mar
 2020 23:22:04 +0000
Received: from BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::d17e:dcc4:4196:87ab]) by BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::d17e:dcc4:4196:87ab%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 23:22:04 +0000
From:   "Kammela, Gayatri" <gayatri.kammela@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
CC:     "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        "Darren Hart" <dvhart@infradead.org>,
        Alex Hung <alex.hung@canonical.com>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Prestopine, Charles D" <charles.d.prestopine@intel.com>,
        "5 . 6+" <stable@vger.kernel.org>,
        "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: [PATCH v2 1/3] ACPI: fix: Update Tiger Lake ACPI device IDs
Thread-Topic: [PATCH v2 1/3] ACPI: fix: Update Tiger Lake ACPI device IDs
Thread-Index: AQHWBH910OKQBnwWv0WQ/gPpntCYtqhhW7aAgAALeYCAAGMMwA==
Date:   Mon, 30 Mar 2020 23:22:04 +0000
Message-ID: <BYAPR11MB362459660B914BEF1526AD8DF2CB0@BYAPR11MB3624.namprd11.prod.outlook.com>
References: <cover.1585343507.git.gayatri.kammela@intel.com>
 <9359b8e261d69983b1eed2b8e53ef9eabfdfdd51.1585343507.git.gayatri.kammela@intel.com>
 <CAJZ5v0j8OaqM6k52Ar9sYn0Ea_u9+MBB0rcMWv6vGBt5jXCQBQ@mail.gmail.com>
 <20200330172439.GB1922688@smile.fi.intel.com>
In-Reply-To: <20200330172439.GB1922688@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gayatri.kammela@intel.com; 
x-originating-ip: [134.134.136.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4eb1c70a-fc29-4eb1-e8b5-08d7d5012861
x-ms-traffictypediagnostic: BYAPR11MB3269:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB32690448DB83E8EDC519B4D2F2CB0@BYAPR11MB3269.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3624.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(346002)(136003)(39860400002)(366004)(396003)(81156014)(110136005)(54906003)(6506007)(76116006)(4326008)(26005)(8676002)(7696005)(15650500001)(71200400001)(186003)(66476007)(64756008)(478600001)(66946007)(66556008)(53546011)(86362001)(2906002)(66446008)(52536014)(9686003)(8936002)(81166006)(55016002)(33656002)(7416002)(5660300002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FO9w/09qDmQfKqjyzVj4WQ/DWBZduA/2cZToDbAiUt8DhkI0dhMycV5zti5nM5KJplVBRpYMh+2nEy4I+R1T8NBz+tGTrW6l138NwU+HpsWQ52wK1V224FhLLWe8INEXqY+ZCB/bTUrcik4fI5qM7gtLDnqjdGIruLxVY/QF9bPFNswkMYkTEUo7+EM4qhSY9MYXz70WnclrLPj0H7q6+/dqoyN0Ay7SlHcYp4p/iP/Ip1UWbBWu1xJ9k19wLfHzXElh/Clym9zfsVOkZt/ovL9G3OdDmFUGotG0jWNkdg9Qksp663laBFynsZE06ZeoowH5UAyuaHlCVtsH3mqSWRq6WW0jm0fFrke2VUM7bA7ivetUurImEyiKpCXrbxBatQsuLCtsor1IlkU/uuR9MmcwktcCDMfVzhT2+7l02jNdL3CwI0joZYnVYceQYFIC
x-ms-exchange-antispam-messagedata: iQOgSe3BH5N4VeX2VPfhynpXIIKsxP/QsgXaFVMa5n1mwZt5PzCq9KGAUXAQwDs3zfGm6cge8+sYv7NifFj0BOyUSoUmhPHH1lCDIcntUPW8Sps4c+V+X9ZcoRxMi44MjKaX0FAfmle7C416jF3WDw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb1c70a-fc29-4eb1-e8b5-08d7d5012861
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 23:22:04.2964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LHjpcF1bRpY2jhZ2OMixmkS8WzNLAiDy2MVCQRDu9c1hySD8X3fVPz1NmlfViJMesGiaK5dajfuHGy/aNP1k9HZmVEItIQ+roC8vgcd1Ic4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3269
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Sent: Monday, March 30, 2020 10:25 AM
> To: Rafael J. Wysocki <rafael@kernel.org>
> Cc: Kammela, Gayatri <gayatri.kammela@intel.com>; Zhang, Rui
> <rui.zhang@intel.com>; Linux PM <linux-pm@vger.kernel.org>; Platform
> Driver <platform-driver-x86@vger.kernel.org>; Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org>; Len Brown <lenb@kernel.org>; Darren Hart
> <dvhart@infradead.org>; Alex Hung <alex.hung@canonical.com>; Daniel
> Lezcano <daniel.lezcano@linaro.org>; Amit Kucheria
> <amit.kucheria@verdurent.com>; Westerberg, Mika
> <mika.westerberg@intel.com>; Peter Zijlstra <peterz@infradead.org>;
> Prestopine, Charles D <charles.d.prestopine@intel.com>; 5 . 6+
> <stable@vger.kernel.org>; Pandruvada, Srinivas
> <srinivas.pandruvada@intel.com>; Wysocki, Rafael J
> <rafael.j.wysocki@intel.com>
> Subject: Re: [PATCH v2 1/3] ACPI: fix: Update Tiger Lake ACPI device IDs
>=20
> On Mon, Mar 30, 2020 at 06:43:35PM +0200, Rafael J. Wysocki wrote:
> > On Fri, Mar 27, 2020 at 10:34 PM Gayatri Kammela
> > <gayatri.kammela@intel.com> wrote:
>=20
> > > -       {"INT1044"},
> > > -       {"INT1047"},
> > > +       {"INTC1040"},
> > > +       {"INTC1043"},
> > > +       {"INTC1044"},
> > > +       {"INTC1047"},
> > >         {"INT3400"},
> > >         {"INT3401", INT3401_DEVICE},
> > >         {"INT3402"},
> > > --
> >
> > I can take this along with the other two patches in the series if that
> > is fine by Andy and Rui.
>=20
> One nit is to fix the ordering to be alphanumeric or close enough (I admi=
t in
> some cases it might require unneeded churn) to that.
Thanks Andy and Rafael! Should I send v3 for this series with right orderin=
g this time?
>=20
> Otherwise,
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>=20
> --
> With Best Regards,
> Andy Shevchenko
>=20

