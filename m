Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A544814DA
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 17:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbhL2QJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 11:09:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:64033 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229528AbhL2QJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Dec 2021 11:09:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640794165; x=1672330165;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i0lsO6bsHce1IKUWJEe4/K4psMf6nk+UUIZh+mfnK64=;
  b=aYPpbqDqN2WUBhQTdRPSj05CELnR+/DfIEWYaYx1xBFPuiL+Ur21bqkd
   R++pdr3kWZdyiKuSwZqlk0eDoC0l6AiaU/8UFTfxExkGzrxpxh3BJFvkK
   keZ5oeWjTTxkdj0B1YhzwWTUpYRt3cNnFjLyZ9c36zp5I+k7bEfOQtiV0
   ocR3swnG9ea+Q7VeZq3N0nl342cMHRy0SNJMp6/LlZ6rGdfDmbJxzY8pt
   QDpaUwnVK3xaG/XRdrdTyv2f5biqb9fE9g0kQ0/JRb2wxCsj84Ix5ca1S
   MVHtTFMlzdL+36tjtzsdKewk2I+TPz/ltT/U1CBEKLthAqBlNZ22EwK5t
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="304895773"
X-IronPort-AV: E=Sophos;i="5.88,245,1635231600"; 
   d="scan'208";a="304895773"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 08:09:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,245,1635231600"; 
   d="scan'208";a="609670727"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 08:09:24 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 29 Dec 2021 08:09:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 29 Dec 2021 08:09:23 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 29 Dec 2021 08:09:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsJaEOYR0aL6Jh5y3eqDEY4za8FXpzkVi9hEr+bJudZ2H3ygEUo4PdFIKoOJ+2KJyg5FetYs13OnPZtJ2EZJ4UOXQOH37dAZdrsHHKL7x0hCx4FMC16o2NyEdbg6mbRUOqIwO1kbOKIdncipxFTLEOCV3IW3jyy1V4lwgHydZDQUG9cdc5TLA5c9glh7z57NxCLUcBKn83eYljjIicSWZiLmoYxKeb11qc96Q4OGXSCqcbYGAO19k1QQYQ52VasFn/QNMawYXdfIr3qerydVQmqfIUnqU3dh9fv882pIf8zCgeSPQYmjvf54a2U+Iho6x+Pg/6lZOJXzZh0hFBESAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0lsO6bsHce1IKUWJEe4/K4psMf6nk+UUIZh+mfnK64=;
 b=O/i6gI3jNlqBInhIvrTqXSW1x1N+RpgDiGBxei4nouwC155m09lcRqepwJGOO+sV+cYDQgD3JLGbBg1plBa9fJhBiVulbyss3NajBzm8sc/UdBYfkeEcg6/UQj8BDYREYvR3Te9+LrM7AirJ6lU8NG/VzBindSL3Bl2//CCPD0zz//Xk78mndwIPGY0pY+kmgcb/6sVQkZeTipFRzoRgkPg07KMMqPdK7F6GpVjKj7co0drTf02gBITzqMJ7pHmgnOyBFk5cfIPBo3B2vlLr3ugTrLq78KaFDoWs2xBs4S6tQ0sd7ux6T3vUsv+iA8w4pMXOwqCUNUHl1Al4GnLm2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5825.namprd11.prod.outlook.com (2603:10b6:806:234::5)
 by SA0PR11MB4606.namprd11.prod.outlook.com (2603:10b6:806:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 29 Dec
 2021 16:09:21 +0000
Received: from SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::fdde:8f2a:3e17:a18a]) by SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::fdde:8f2a:3e17:a18a%7]) with mapi id 15.20.4844.014; Wed, 29 Dec 2021
 16:09:21 +0000
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     "Winkler, Tomas" <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        "Lubart, Vitaly" <vitaly.lubart@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [char-misc-next] mei: hbm: fix client dma reply status
Thread-Topic: [char-misc-next] mei: hbm: fix client dma reply status
Thread-Index: AQHX+8Pg9sLBPaZUrkOEjWuSXLAWu6xJpSlg
Date:   Wed, 29 Dec 2021 16:09:21 +0000
Message-ID: <SA1PR11MB58255A9F7420254F869218D6F2449@SA1PR11MB5825.namprd11.prod.outlook.com>
References: <20211228082047.378115-1-tomas.winkler@intel.com>
In-Reply-To: <20211228082047.378115-1-tomas.winkler@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20bc30b1-32ee-40e7-63c3-08d9cae59329
x-ms-traffictypediagnostic: SA0PR11MB4606:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SA0PR11MB4606CCC84E8FF2AEC326A418F2449@SA0PR11MB4606.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xo7w6vPeldS8I1UK2C/pzsgGee/nTxpvTo/ueK2gR37/vQ7SVg5X9Xi4Plr5rCc/QtVF6+f8J7slirg5Q6H4hJ4ooZS02BEKxZ6LHyY53j+ptBzGU+obECBxV6nI/fRpUfXfsn7QKE6MUivTj+AUc2uH+XOF/qTEe9P8Qd75fZi/5gCgPOCzpHWqnOlGIIx14/rE+zg3rLzTqmp+Aiv7JFQr+xGQtFRN/E1u2KSOgxW/IxjGNn/zeHhQEKcb6ekFYVIeGcJaNNfR27Ive9eL2CIj+o1NIcU1Rs6UidFurNmEnwMu3RXiiWQEvxMK8valIPqN67UZ/J2vCeqzlgyzAGYgJdNzMWb4ruVVio7Nd5H16/ewlK6YrtSuj1wgC/kcH4f4iSEgdcpPohjzgPPGJgZGzXH5cFE3PI4zlOAlgEA3xHHEVvrqK8++4+S3smQI2WYPn2mqz38pVJMcPwgoJOu02+eHfWacr1mdj15Gf1M8lzKqNTp9qfJCzFHY0Xr604e13y9eNMf9VWqWmdc9MFiozW7FAl41DFFkLeaAKPYLFXaPH0wV9iYSBYC20vXA+Uztzbx3KBpOJhCoc7aiJ13SYkv0YK4EquJkjRxM53ylcwMsahA2ScUGfs6CgIP9XUy27W/LmAneZKJgviIaL5on6cZl4Yt4T1IHvHasL5bvQ0dBVslWI7GEUJCCh0yzp2lgAdIcAK6ibC2rEBNQ2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5825.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(86362001)(122000001)(54906003)(55016003)(83380400001)(66946007)(66556008)(8676002)(64756008)(66476007)(66446008)(52536014)(9686003)(38100700002)(38070700005)(4326008)(7696005)(8936002)(2906002)(82960400001)(4744005)(508600001)(71200400001)(316002)(6506007)(26005)(186003)(33656002)(76116006)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U0NN7tjkUeGD3vJPCAvKkpVl8C2goO6C0ZiLCVijVzvMXE4x4TRnTXOQQkKs?=
 =?us-ascii?Q?DwJhqdBYcHnojEeeVi/C7PLO3z6J4FKmwC53KRNG4VJUyvC++KcxCHtV5SCv?=
 =?us-ascii?Q?9xgulCvtq+GnABMY6RkzAZdnRxSu96HDzhRJHJ+agYpQXMIVPNG0bjzQizqH?=
 =?us-ascii?Q?oACvoPYA25wDyxhz244wHryc190Ty10BY6xhBYqyemFqn7J2gK55cnArlzfz?=
 =?us-ascii?Q?EuZf4mNkwDVXDcYee61CvRryimQsnPlSBG9R28lSFE9+UR+1RNchGnIy4nMg?=
 =?us-ascii?Q?aN8loo2tQpyqUOvQzUSbtoINVAeBiIdnxisao8497y8xYCk7yKpMoRzilheu?=
 =?us-ascii?Q?Y2Yi66Aimn6ld5rc7ykT95taZvNhS1LxLveHH1epYKYlX2yqRFa1ZK7RXmh2?=
 =?us-ascii?Q?blMMVHhdmsQfy+ZNFD/Fb1gBJtorfeAKjlX7U7X5AWSdKvf7O79TXADT8fmc?=
 =?us-ascii?Q?uACyDenQafy+L4ZOSFObZmkBG8/sx7Lfcdq6S4G5IUKuosJXZpjIjcPXm4cT?=
 =?us-ascii?Q?MdS7y7PRbhn9QLjogzrcYQLg6hRjSB8dJdpKaadHrnlj64CR3FOEpbg1aKSu?=
 =?us-ascii?Q?tRPAWezryvDDITJFAyt+SiZOYWhigWrwNhkPDD1aAaq4nOtVSSPogdpoCC2U?=
 =?us-ascii?Q?ydfRAzIlwAXwrbQfpNSmbl9lsL5MNJTrotarlzEbDG9GbEBB8MNYPgaKVdaF?=
 =?us-ascii?Q?YsW8w4Sbyd4wCkbkwcFzGaX2poRJYDd0t7hGBOF5u6j1O0Xmkis/Ait3Guge?=
 =?us-ascii?Q?qSY6v2xUX0XUNLyeAkpL889kxVF2i/oKEMAtiZs/p21bDA8aNJBKUr3EfANj?=
 =?us-ascii?Q?f5qTaV5CLfXVXwgWeGLh2dyJGHUs/XRwO2Zhi2qBfryR2zgsBHhrd/QbO6fK?=
 =?us-ascii?Q?HCDSZPJ6g4i6fV7Tireoix25EF3ir3R5n/C6/wQCrno3Xz9YCgLoEyyEYNwR?=
 =?us-ascii?Q?CgmXKGl27gDWTxzrVGCEe2L6ZFpJ5iaLb3oK180gO5uUq8SnO9jrVAdcw010?=
 =?us-ascii?Q?4coMUC0OOvO9oSt1ewATEridFe1AX3CCVDC4uHv1U4Wt/zu0xxV8m6Lf7ZSI?=
 =?us-ascii?Q?t1EivMo8aZzMxW6v04DQKmwuCn6qncfz5NSBRePeuo32nvVqhwyxa5/9dGDz?=
 =?us-ascii?Q?Qze/7BIfIjWQxkTn6Jo9PJLKAeJ2ygq2zijcZ6ynRUYuEHm6ZVrxBvEv2Ruv?=
 =?us-ascii?Q?tZQIGveXfBBenomh985aW9vytlIuPs7rcPesC8C9KuFaY8Uheh8tAA3r6WIu?=
 =?us-ascii?Q?GrJ7nMSI9mLEZpy1gPc0TbxnF8/tQth1te9nbFtxC+yc+2puf8HKp6Q1B8gG?=
 =?us-ascii?Q?Nz5uXRA4KBY77dGGf52w4Xo2/8ZD0hKB3dkh1/KdiajXgz07eu5rtVIGivCu?=
 =?us-ascii?Q?gOklsSwJiJAGA8D9dMjT44gvC70ZokH7Osz1m+is1PRT+R4BgzeWi4ENJlAv?=
 =?us-ascii?Q?6z4xKadhFBlnHA++vVJndSXkVLjczJlRf4j/uBL78OhorZO9hSUv2OCSbiNU?=
 =?us-ascii?Q?vcxbIlWJomFT4HWRQcj+oy/hakoY0+1MRweBli4mvdTB307uj1WdbXjrUycx?=
 =?us-ascii?Q?myOHU+yUBfNQ/VLNWQnysmJdbvXBzajb8AT0GKfDuc5b8kFR+zOnNvNuYdlp?=
 =?us-ascii?Q?G3Ry39Uqv8jCIn+aKuLBuaWc5YO3s7N7MYbQ7Wcm0vpwCJzR5344iSG1yHfy?=
 =?us-ascii?Q?DuYghA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5825.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20bc30b1-32ee-40e7-63c3-08d9cae59329
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2021 16:09:21.4295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eV34Hg7miMW2WrxpTqSAREW5rUcqIH0beaJ/92Tog7KdalDRSDm+pF2ZGlvINfUrvpoRXekf9XOttLyOKoShklo31gbJ1XE3BX9C7c0JTSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4606
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>=20
> From: Alexander Usyskin <alexander.usyskin@intel.com>
>=20
> Don't blindly copy status value received from the firmware into internal =
client
> status field, It may be positive and ERR_PTR(ret) will translate it into =
an
> invalid address and the caller will crash.
>=20
> Put the error code into the client status on failure.
>=20
> Fixes: 369aea845951 ("mei: implement client dma setup.")
> Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: <stable@vger.kernel.org> # v5.11+
> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>=20

Tested-by: : Emmanuel Grumbach <emmanuel.grumbach@intel.com>
