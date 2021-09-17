Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116AD40FFB9
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 21:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbhIQTXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 15:23:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:25103 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhIQTXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 15:23:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="245259740"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="245259740"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 12:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="453389147"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 17 Sep 2021 12:22:01 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 17 Sep 2021 12:22:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 17 Sep 2021 12:22:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 17 Sep 2021 12:22:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipoNxlDQFm5cK72cxFel25+rtKqSOepI1dFIjf+bE9cEtk+8UyNwM1/0T485wmlEiPIn80hkJVWvp51MsSUc/jfhDrjVGv3fKIGnYn8f+EB+tugHWV7lChz4lrv7mAZvFN5unWqMYyGxgyrM1cTD6PM6aMRx8H8QUr4s0bRsVAMwxN+pkWTF9HO6FYW3vRVsHS83eScNJKifTYfzBEgIrUpOXx+06qVJ11JCZ0jmZvqvUsKll9gSxig4RxIatJ1hakTs3y48tVw13m/iJoF4KKbomCpV6GD2+6w/azZC3BUSTzhKdodiGUsuUKz8WRpYgWFBJqQtukZzHjvKn4qtRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cKcoOk3uU+sg6RJN2/Itl119x35zNBsCPYc1+/yCLX4=;
 b=Ey5ig0uow3AfOTQMJv3dvQoqCTyCtMa6koXiCnlFOEW3uCLcng23lKLj0gw0zYuMXDH9RGg8S1CtgTrBOlIruWSOaHncT280l/GgB2FGWeOBUiQpQq/0JkLkv1X6f9pmxVJE2cDnL6VmBIowtuaChfJD+3sThNjnZxYhVLL8d+YHEm9Wqmjtab6yncbB51y7nKT4gI2FkCXIwWq73QTTn+0QEMZAvU31566A4AroUrEvurU4SUo0qif1rV1eci1Abit6H12tpbDoUN785FUP4KFE1vTB8BT2rfP0wGtOVElYYNYKZ+za/o17yqUy52b3ODjnhxsVCQqiw8JumVLMPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKcoOk3uU+sg6RJN2/Itl119x35zNBsCPYc1+/yCLX4=;
 b=LEW/4DMTfBUjxSW9A5LRjET9C4OsuoqqOrGHeamnY7C8h1i9ICUcgrFMpAQH43yHoj5b4Kl24xuuTTaT5CdHawZU+H8Dk+CjBfOOuAg6HmyUPMm9YcMIudf2hq4df6RX/Se9vLcbRPaUe5bkDW4wTpnLfLt6z4BYGy0L7wcvKVA=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by SJ0PR11MB4942.namprd11.prod.outlook.com (2603:10b6:a03:2ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 17 Sep
 2021 19:21:58 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::70c4:1ab7:9eb4:f94a]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::70c4:1ab7:9eb4:f94a%4]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 19:21:58 +0000
From:   "Moore, Robert" <robert.moore@intel.com>
To:     Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH AUTOSEL 4.4 24/35] ACPICA: iASL: Fix for WPBT table with
 no command-line arguments
Thread-Topic: [PATCH AUTOSEL 4.4 24/35] ACPICA: iASL: Fix for WPBT table with
 no command-line arguments
Thread-Index: AQHXpXKCF9KSGb6OD0qdgXpS+NrCV6uc5MkAgAvCkRA=
Date:   Fri, 17 Sep 2021 19:21:57 +0000
Message-ID: <BYAPR11MB3256A989B8F75EE3A9C885F387DD9@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <20210909120116.150912-1-sashal@kernel.org>
 <20210909120116.150912-24-sashal@kernel.org> <20210910074535.GA454@amd>
In-Reply-To: <20210910074535.GA454@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bc89783-3df5-4b77-07b9-08d97a106b25
x-ms-traffictypediagnostic: SJ0PR11MB4942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4942560590523CFF0495A79E87DD9@SJ0PR11MB4942.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:376;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uZTu/6gs+QPElpAvAAiE4ZdZrDZAhEbAYrivefxugga8S+ZPW3wppiJBJ1PpFnQqxgx4Bkqxc3tBFzHSK46wXDUjz+e9sreHrkSq609IIGdlOk0DzZaIq/aB/SSU5wCRSatuX+3WHA495Uc6jRyiHmWOrn32fvsTDtrMf+g2Qdib6DK5vmed4xU+LjMtoCUWJvoYMdSrbFsBREAyFfhBBMEEDqpbIof9M6rDSpAqJ7sVE7/J1ppg88E2iS5cpsEGx/1OLQC7GuTTMYuYMb4iUkB0Btkrj07STd51pyQqucekmlk3qfXQRjE7FNaW7EWstOECfOKvuQjG2RZI71DRXqKU3b8Cy1imCtpFY+VYPbBFmaYH9hp9xmbhjWd9t34wAaBFeiJ7jE18AC12UzKQcf1jp/vjY1QQn3G7qT/v8/PJ4HDUIcYdADTPvaygzMiECmzCHvmE6e12jYPe1XAkthMfm6la6x00jZk23ZwkY4A3Z2qIYe5lzUxGoVF2+hIMBWBVzGsCireidHUOLQRF0G8d3ZAybdASpSg3meu76t/hNTQubOV/WoUoK66EUhCUWT3e6MWZFy0X+2Xi7l/gx/PMtKxsMu+TSBWrfKBifrwM9TKMT551byo2TgM4L7O6CigSl6WTQXOhXQO0fB+WvqV18pl61rPk6nH3GoINuIpHWjymI5WPRDx54MQmmQDJQwxO6bqfWF1+dKhjd6alWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(110136005)(2906002)(64756008)(66446008)(52536014)(478600001)(7696005)(38070700005)(53546011)(6506007)(8936002)(26005)(54906003)(122000001)(316002)(33656002)(86362001)(9686003)(186003)(66946007)(8676002)(71200400001)(38100700002)(66476007)(76116006)(55016002)(66556008)(4326008)(83380400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8PpE+frGgprpOeNmMXJeZ1Fr9e65367LVoEV3QOSFFe4AKLmr+bUE8FAG2Q5?=
 =?us-ascii?Q?OpeMeyJqOb8Xoknzfs6jJ/fBDNpLywtSs0mUpU63G6B1HdRwVV8ReULitziT?=
 =?us-ascii?Q?evE5jDLSXAlp7QZ30EAxEDnhs0TifR4zBb521DFtXx5liBxZ/kzazJfz7I7m?=
 =?us-ascii?Q?Gr8V31urEtbWiKUaKQ5dQKH6AVX5tyFjYBV01tg71x/6E7+8fA2N5AgBB2gg?=
 =?us-ascii?Q?ohdH9uW2Kcl+rbSGYSkSvImMm94abGQNNu3jQl8dn2HVDayZmjAS09VvzLv1?=
 =?us-ascii?Q?EvnLw3VhWnMWAg9beX+giH96QtKk20hXD6+RPEqbNrntouHa7xTWBd0Pxtcj?=
 =?us-ascii?Q?EBRctbA30cnHwWYATbjzzy7Kbf7BhHAl3kewH0VhEWdErdGUD8uOTOt2GXcY?=
 =?us-ascii?Q?2eqI59qAXnNJb6jmPoat1ar8zS15j9zj1v4BnVBEo+jhPrR2G+LrEnTmoZlY?=
 =?us-ascii?Q?kMgL1Hn6TfTRWQQJo+CiV8b49mF07hPVe05HbXLbFMsBOuLmE9vQaq9b6fCK?=
 =?us-ascii?Q?a0fMTNFJ6c3lzKPIUkFHAKgXAG40ZgXbIpFGDAeAG7CK0okdJEmu+yBAwqj4?=
 =?us-ascii?Q?eGHz/1hunn3ZhBjpsel3qQoJ9QLO5f+usu716DEIWavb4h4cljHFZ6pon601?=
 =?us-ascii?Q?8dTeE+zVbZmdKl2hczm19yXmiUtjzFaDAiteJTzMwe1FkpIffFpOvrCZ/6ml?=
 =?us-ascii?Q?GZqZltM7SGxdi9l0NVPHiC7E164swpY4WJsZptzcUTEEaFYRpFlz/1FguAa2?=
 =?us-ascii?Q?ewbhbFF0C3MpS4OK19OIJlqSqyJUS8lpkFHaGbBhFzaY66oiXV2a69gcGeRJ?=
 =?us-ascii?Q?IA2ldauYBzym/hCjWHruCrSaw8Rp+M4y8KtJNaF0X72+q4eA23fjrfWSw28g?=
 =?us-ascii?Q?6RDilQY9NKun1f0h5XwPgvvSDHirku6+zvl4oxRahf4ng9P7ASSbkm5UzU3D?=
 =?us-ascii?Q?y4UbiiaUvkEbXzAAMv253PMJ0q1ZomE9g1e/EemJNO4k0SuLHz7B0ACG8yEV?=
 =?us-ascii?Q?uT0sxDmhTYiROQd/OVxIXTxJHUdPGx4OAleSOwA0HeaYZdT0CV/1Tb8Lcfn8?=
 =?us-ascii?Q?fiRpoG9JocUACownL202LbmNPzlq+wXdZi8BF9FJBikSk/24f2VxtHJzhqWh?=
 =?us-ascii?Q?krSEraBF6BjrRk6ICn8BmUL4Gh1f7BnBbdi2H6QUa3QenkihPEru55o7VsPE?=
 =?us-ascii?Q?mprvNkrs6ncO5IuZA9bQrO6rKcnv8dbO24xhqoltgL4CdZRNIXKb6apiw+y3?=
 =?us-ascii?Q?bnrYrYhH3OKKps1pdj8lPEjFCLzfKL+cr8oNZD9dma2QJYuaHejpfk/0wlYD?=
 =?us-ascii?Q?no2RQfHEImpt0Qsw/5THLmwJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc89783-3df5-4b77-07b9-08d97a106b25
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 19:21:58.4130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1R60ioapViyhP28tKQ/0QorLRiBpxzrD2WzvFud6mwHP6TfL4/rR3D44jmnpm9XSEWCVwtRx2dTsZzd3cjPGAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4942
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This structure is used by the iASL data table disassembler.
Bob


-----Original Message-----
From: Pavel Machek <pavel@denx.de>=20
Sent: Friday, September 10, 2021 12:46 AM
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Moore, Robert <ro=
bert.moore@intel.com>; Wysocki, Rafael J <rafael.j.wysocki@intel.com>; linu=
x-acpi@vger.kernel.org; devel@acpica.org
Subject: Re: [PATCH AUTOSEL 4.4 24/35] ACPICA: iASL: Fix for WPBT table wit=
h no command-line arguments

Hi!

> Handle the case where the Command-line Arguments table field does not=20
> exist.
>=20
> ACPICA commit d6487164497fda170a1b1453c5d58f2be7c873d6

I'm not sure what is going on here, but adding unused definition will not m=
ake any difference for 4.4 users, so we don't need this in -stable...?

Best regards,
								Pavel

> +++ b/include/acpi/actbl3.h
> @@ -738,6 +738,10 @@ struct acpi_table_wpbt {
>  	u16 arguments_length;
>  };
> =20
> +struct acpi_wpbt_unicode {
> +	u16 *unicode_string;
> +};
> +
>  /***********************************************************************=
********
>   *
>   * XENV - Xen Environment Table (ACPI 6.0)

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
