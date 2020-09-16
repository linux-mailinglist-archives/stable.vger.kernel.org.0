Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C9426CB0E
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgIPUVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:21:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:8164 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgIPRau (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 13:30:50 -0400
IronPort-SDR: 3erjO3REZpIpVfhGV5USZr1C9Lyv0vfF/fBIjAZpVH9bP9dCGG870gQ/NS2mi/77rK/hIE8ZFq
 85b4vT4g1TZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="160455071"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="160455071"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 10:30:43 -0700
IronPort-SDR: uHrnkKcETH41QMPFDHF5puWPzy8N9R48s53BH/8zsWnlOy0190N3RRRCAegqsxi3TdP6GChdyw
 xws6FtpyNcsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="339135777"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 16 Sep 2020 10:30:43 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Sep 2020 10:30:42 -0700
Received: from orsmsx101.amr.corp.intel.com (10.22.225.128) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Sep 2020 10:30:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 16 Sep 2020 10:30:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 16 Sep 2020 10:30:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMCciaTcxmxFCJI+CnR6kmeiNU0Z3UzEFYP7Wfx9hZrzkqpsPBzxDuqyDSvI0I6kx/uPa7sWekxPs+5uMeZFmgDnJijCo8ufX5obDiWvuoxIav8uZBFKr3Kvy6QdqTr3zdW3nAXhr8daw9v9nIm95O8SLJhlYnFi1mImjm17PrtGhzQYImA6dE0MDIfuXIlYxu7S0aw9w4Zwbj/L4Vv72fXSWjz/HUAC3aCJ95wQzdrr7eOzm9PtzY7g8xG16yDIhRCJ3/Z1+eX8JZ/q+9Z9LutPPieIVR+vYTR5y9ckl0F2sqU8yy5HuMIzJSqk7r7M02zjDi52+5GE4zi+xVANUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKJ/vEqLrtD6BuuOw1TWhZkZmzRYo7GeG4D1R0eVcAI=;
 b=bqzam3SL6Wglo/QDx3DFiTe6qwniakC496RtLZ6kxj1GCQcIUWug6V58YR68AuF4cY8k1qk2l3il+IABrqwi1D3+7/bPDwwwti29JjHfqT6xRunmZ8UmKznZEq2S4MALmTa5ZLCjIYE7+/rdOnNfz8sD4qtjJdACJKwQ+5R+fW2KcZH3X5ubgPJdobksKM7Ql3g4XDSE6Z1xWbubAKpzNXEvwkPOxaDVN8BM+SRxdKPrQrVdLEXNbvXmtiRrzqIl9KflyjhfsUTZ98oZK3tw0ftQFxMGIekooPuEy1VnJoR6Jlkojh2XlJ2EnZezJwXIgSkAppejTRtHDA5LL/aTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKJ/vEqLrtD6BuuOw1TWhZkZmzRYo7GeG4D1R0eVcAI=;
 b=LBRkbJEDfpz4GZWgo/pK1xf30JQD7bGfhzwDz8vIpdI99jSCvTN12PUPpJoE9+oj5zlDWKhHXZSTvCBbk60VlCUAYgbZF7KDo2IfP3D3W7aIzKCPDMPSlxfoHptxkLSEMFuLr1aPrfNi+qNhWz6ik5B78QXFiP9ZkMaYvcfuCkg=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4590.namprd11.prod.outlook.com (2603:10b6:806:96::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Wed, 16 Sep
 2020 17:30:40 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7147:6b91:afe3:1579]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7147:6b91:afe3:1579%3]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 17:30:40 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: e1000e: Add support for Comet Lake
Thread-Topic: e1000e: Add support for Comet Lake
Thread-Index: AQHWjE8Z6AMvz/qzNUqwGFB1Bc2HwA==
Date:   Wed, 16 Sep 2020 17:30:40 +0000
Message-ID: <d1bd83b89a9f0b4354a56a83053adcc779fe1223.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c99a79c-d832-4b0b-5469-08d85a663bb8
x-ms-traffictypediagnostic: SA0PR11MB4590:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4590E7C5FDDD05F64747FDDDC6210@SA0PR11MB4590.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O6/Xp+RSRXPIoQL35dF4bThViz9zJz86di8FhmTbrs29ELh68PZYTkDx/rIc7D/DybuH/l9t+SPgZFY92oCrLUgtEpr2RauJ3WJC304scZLCXSLsdmiH+WucBL7UY30nD7NOjjrr3HTFN+H8htgijEki88SRpqsVsz//SGUWL4z/+y+d/mBJmk6jj8s/pRsZW+RybOm4IUaiJmIJQOBoPfv39lFEKdl42VVQLvCVTJURUf0mbuwJL5Q3UhT3i72dvw8GbgUN6grJoLRMkwF32wGx8pjyLHyMSFcCbdzHJridTwfA4AeH+ZgXIPG5+rWZgNGcmSr7hjbWdQayH3JUwSus5wYEuToe+iUV7f4QpAPKtMr93m1Z5P1tCyRdqr6HQDul6DnczmhWaXIk77HWjzXYarKQNwQMFJbLLR/6g0Puwa4cvEs0D876JhC+r4yE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(6916009)(558084003)(966005)(6506007)(8676002)(4326008)(26005)(316002)(2906002)(8936002)(71200400001)(2616005)(86362001)(54906003)(6512007)(6486002)(186003)(36756003)(478600001)(66946007)(66476007)(66556008)(64756008)(5660300002)(66446008)(91956017)(76116006)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qBQB5yiTNa6mArpWqwco8qC+J52SDJo2rLPVe6YvPTH8QfsffzlBKsEJ+9NULxEuH2gcfuLVOpqzpUh7el/cXWd/R+0kvspRanPO5U2YOJJl1oXi7j5Vi9hX68hbuiFguAp1f230KcZ3zvjfhUOw3tdxL9H6lTMAgK60opSIOOaieXJmuAjsvLupZGzDx/v5HxjFb6kWuklyojOLLBHrf19yNWJwO3XzTDcjpGEzbxP2TI1TgFcs8y9E7lHi3pKdbPP8NZPp78IugJv6EaQvffntPU9dv4NvPrFXVIqBypX1p5wvsxgKz1gN4sdhD9TG14u1yEk+5jDyS+jddxJeV3FZowVO0vrZBxmZ21KHtGVwlP00bc6kkrdRsZjGssx4LZTfLWCBGVKEOq/JISUjPq4DLDgTMHYRsDB55YI4kykAzDgMrvefoiaCZfjbjzDmmXYK0bsv2OgZFXMR3xfKmzmCG6PcCFPibsYOkSc5nvGFIyj45ZTjMxv+kTiYqxOlHM5pgO37JP+Z2O3MwAowQRgxtyO54U1ES1kKM6/xgf/S0MBleGDIoUpWIsVTBIss7IPgLNxizvfDsqyFYKdxFv/MSvCDEtQohNKPQLgJ6JRq1lMEd1ws2S66DRFssBPqcGvaDVqhNL6e0RAE9o/uaw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA7328C0DBB388438B8E29A8C7A5D999@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c99a79c-d832-4b0b-5469-08d85a663bb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 17:30:40.5996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fJ0MMflHS/TMUQQB5xB9IcB6wWXpDjKj7mQ/gKM56Qg5dRBTmDY6HjSXN/+c156gwnIOrTSfJHLvi1xzkLvGjpzd8NidXzA3uwszdUPVOv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4590
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

UGxlYXNlIGNvbnNpZGVyIGFwcGx5aW5nIGNvbW1pdCA5MTRlZTljNDM2Y2IgKCJlMTAwMGU6IEFk
ZCBzdXBwb3J0IGZvcg0KQ29tZXQgTGFrZSIpLCB3aGljaCBhZGRzIGRldmljZSBpZCBzdXBwb3J0
LCB0byA1LjQueSBhcyB0aGlzIGFkZGl0aW9uYWwNCnN1cHBvcnQgY2FuIGJlIHVzZWZ1bCB0byB1
c2VycyBbMV0uDQoNClsxXSANCmh0dHBzOi8vbGlzdHMub3N1b3NsLm9yZy9waXBlcm1haWwvaW50
ZWwtd2lyZWQtbGFuL1dlZWstb2YtTW9uLTIwMjAwOTE0LzAyMTM1OS5odG1sDQoNClRoYW5rIHlv
dSwNClRvbnkNCg==
