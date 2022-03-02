Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7003F4CA9AC
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbiCBPxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 10:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241651AbiCBPxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 10:53:34 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4957FD24;
        Wed,  2 Mar 2022 07:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646236368; x=1677772368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sX1VBvACN4mQ5RfIruEVLq7Mp1w1ZXQBvcv1c657wmo=;
  b=Z/2iEsQbgTXQaovQkt2QfQNKfkCC9U26hlNRPEeYd9rK94LcjL+XmkDe
   tUkvqWWwkPR6OX7EWvPJBSwUCED3KXYTRTT2f4AEBBC9UrN7T/OdAUA5t
   iLwC2nUDEKrRGrnXTFSYWQzJ2qX26NePckuiDp16GSN2bE6ZT4k+2MsAu
   Uc5MqeWMJdxIK4kWG9ehBt9BPqos7JT3FxRF4bAVaRGGsZxXQ0v5e4Lgh
   FN7dqQo4VOy3ptZz7+pZdFa/gN9l1O/NacJVAfZ18OkO76QByzBN/aeE4
   KHRcsNCqlqIXDc2IQa3zThoDXpN8UNHAJBxztGIiqRcuV88VY7Q8Yljof
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="316644412"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="316644412"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:52:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="686170270"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 02 Mar 2022 07:52:32 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 07:52:32 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 07:52:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 2 Mar 2022 07:52:32 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 2 Mar 2022 07:52:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SD15DHjpL4vxZ2ZZOtyVAotdR9d5iV4FrSSZtRAHYvio1htuSYWGgMwnVKxkwV/NjmF/wO3vQjMYMZZYWw/YqfsEHc5GIemCIfCzhvaeOxpOnWRjleWqiWKBAJMF5S27SaFH5yag+h5fI3u8XZ1YWc/56hZYr9hu/JYs43euLRZDA/EM3MphuhpXJ4lUgt/kec2gb7F84CQzDpLmb8+K2ataMJveUswcWMafOqN7U/5WPFvElZ7hnU+tuCUC4+GQBlHjqZp/qEMvVBeJG86At9iMYPV6XiU3XLK170179qj3gFsw3jtW9cDFHc3yiwS4dIjnaOfCF2EhgyICnsTWKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sX1VBvACN4mQ5RfIruEVLq7Mp1w1ZXQBvcv1c657wmo=;
 b=MywHoJVJa3TVa/dZ/LrJf9/mo17qwO2vTo6k6ltkp6V1foMjDPSEB3+I9PLepxnlJ1dSI+zS/ZkadqAa9Vjt8RD7PITysSir3NAu/DzmmT0NsnBNfSZU/KAJ9wAmqM+UrSPhi29+tVAOUTWfDZ3Bmi0DW/rimEZqsVQBsJVSY6uLIxl10hne/sWje8HhmElJSnmfb9uBxhcV/7E85BqB76yFLJeSYY7gtO+7vMwMRcgr4/9bwPUcH21QMV7nehwICTDs11b+3rKCve8YiCLwd/fQ3DcrUHNsbkbzmhPy50DMKHvmfo/Dy70zata4aYYUEj2YXhQfoX3KoYs9yAbCbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB3512.namprd11.prod.outlook.com (2603:10b6:a03:8f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 15:52:29 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::910a:a800:65c2:c366]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::910a:a800:65c2:c366%5]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 15:52:29 +0000
From:   "Moore, Robert" <robert.moore@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        "Kaneda, Erik" <erik.kaneda@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 4.19 041/247] ACPICA: Fix exception code class checks
Thread-Topic: [PATCH 4.19 041/247] ACPICA: Fix exception code class checks
Thread-Index: AQHXDrktGbwa7JyMZEevLNlzkJk+AKyufWHg
Date:   Wed, 2 Mar 2022 15:52:29 +0000
Message-ID: <BYAPR11MB325620EA94EF89F8BBB1C4F687039@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161033.687197314@linuxfoundation.org>
In-Reply-To: <20210301161033.687197314@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1109e8a2-de6f-4b4d-e810-08d9fc64a7ee
x-ms-traffictypediagnostic: BYAPR11MB3512:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3512C1D281DF33CDBA837C3287039@BYAPR11MB3512.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TjcD8bZ0xScyex1C2+GoxKDdSvJlE7G9guX4nnxPnxvMCbIYIxHVTUanzQiU2m9ZGa9HRWb1l2fIL8kYgwFC9cAJaIHf1ytOqoOK4f+DHOKZdocLUT2b3MugFYjx+uXBJGUGUQtf4azVTpgeqUNZAgWq4XU0cN3sSdlzyj4qknuF63ZEfF3ojZfaiqYavZFdv8pqHF6NLMFEcfcFTVyuqJhAf7ep7piy2ZTQg+nsgA4y2AoOFGPrz7KnJWki5QizK1LB9xip2Qqz+MXZy2KoaV9ra0YBTYAe3VC6DfXvYKkTQ4751eBfFticr03+Ch9irjMblu8QaAGoqN84hwHXn9Ugqm8c97hCPtMYfOd59a3AKj3DXsK/dj9xZQ22bGpn50a+Zwa0pJdV1XUW90rvc4KdhVVZN5lOgBf1ghTiGZxnfNkPW9chhUxgVFxWA9Yb4knck8caJzFJctVgFbSbHKYPXYiwTghqYbuP2jGL8/uAHx8aP25ocMJDYho+7sMKrTWKfdm8/aIAXQk5aBR7aFYF9tvGViwJRHLu6T8RuervBR6QI9XGeC+awjY6Q9KmDF90xezP+rPQbzlDc1JRRbirVWZrV9v4lgCyW9XuK3Wr43BOKV9Tf7/LU+iN5z6dqETUKYkPpSEWNB/IJ3Adxb+UwtDrFV7ZjyiKtpcvE9wm74uUn7ajMwKK0umNpsnWQNIyNTNzsR7cenBi0++1nCZ3TrkZZMoHi6IHCdHz5aLUpPZdzzxl59UuOF+CMgBhRiYC5OQjZGqxODy2AkBbABblu++HTFibjSThl8r07pw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(110136005)(64756008)(54906003)(66556008)(66476007)(66946007)(966005)(83380400001)(4326008)(66446008)(26005)(508600001)(186003)(82960400001)(316002)(86362001)(38070700005)(2906002)(55016003)(9686003)(33656002)(5660300002)(122000001)(38100700002)(53546011)(52536014)(8936002)(7696005)(76116006)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0p5UGxYNThEV25kbUF3MGQ3cjdJcUF0cDBIbWZndy9mSUsvZHBRdFgxRjNG?=
 =?utf-8?B?WXZaY3lvbUtNdHM3ZVl0ZHp4UDhWTkVDYndNZ0piZXVzRTRvemw2VjNKZjR1?=
 =?utf-8?B?UW15ZUdhMmI1WVhhQ2g2VTE4TjZuWGlGaUdTRjZGMjVOQzAzV0tEWW1EZzg2?=
 =?utf-8?B?VWNLL05SVG1mMC9leUVXVHVTWk9Jd3BIVmhCUWdqemZabU0vUExUdkthdTUw?=
 =?utf-8?B?Y0x4MUFYMFdYZkhobHYrUHl6ZHJBSEJVQlMyTnI2NlYxYVdDeHk2K3BZdmR5?=
 =?utf-8?B?RFRmejFyRXNBZjFOajh6RDZmK3UvYVBIQ2g5anRSV3RpZWNiVXZ2cW1US2NW?=
 =?utf-8?B?L29qWTN0RGsxZy93SlVZSjBWZjRsU3RNM0dnbmViSzdoL2tDNjJQYml3OUF5?=
 =?utf-8?B?dHV6dW1BT2FReWZ6RkFWQmxvUzE1ak9lREJ3amsxVi85aks0RVM3WVd1RTdI?=
 =?utf-8?B?L1VTa2JPMmJqalpCUDRicUZFbTZvTi9IcXRnOC9OODZSUXd6amV5TUt0QTJl?=
 =?utf-8?B?WlpwbXJKSlM1Yzk4MmQvQjdIbEFCQnNWcUhYVzZ0WElIMGtROXV4dngrT3hj?=
 =?utf-8?B?T2lJSGdqTXhyVnZCNFVtUG1DV04wQTUwQUs1Mkduc01UUnR0anlqbGhYZEtF?=
 =?utf-8?B?MjJEeWZIN3R3bUJpVSs0SkVLaDZXWVlVenRqNnhMT2UyVHZsS3FxUmdnOVlm?=
 =?utf-8?B?QkNodXUycGRHaGVKMHpNazNFQ3QvUHd0Nk1oeXVPeHp4RXhSaWVxSjV1Vy9r?=
 =?utf-8?B?RGpGL2Fpd1o0QllLa3FEb0d6aGlHbHF0elh0OTdsNjR2YkhqNS84dEg0Z2VU?=
 =?utf-8?B?RDZ2Zmg3OExpUjhQbzZpZ01aSW1xMTY0YjlJWHR4UzlDQzgrZzFnWTF2V2hI?=
 =?utf-8?B?SkxNb0NKTGxHYjBVdTlCUTJJdGdpL1d3dklJVThxRTg2dHR4TFkrajlmbi9s?=
 =?utf-8?B?M0J0SDcvQ3NGb3hKYUpNbDY2OEsraFpEL2dSenh5RFRlc2VyUTREalpmdWdV?=
 =?utf-8?B?NDk1OEVuUkFQVjFFY0ZSL29SUWRuSmhwQlp1Z3JmNk9KS3gvYldyTUR6cVZF?=
 =?utf-8?B?d05aNWpXZzQ5ekhDRjBQVnA0QkRaa2ttdFNNcmpoMDhoTXE2cWJKZGl6RFd4?=
 =?utf-8?B?T0k0aVdubFJVQWRUbGZ6OU8zR0tzNGtkUmYwNDQ1UzVzWlA0dnBiV0Nkcld4?=
 =?utf-8?B?T1h5bHFUcXFiU2RWWndqOTRwRnRMN1dTOVdsTmRMOTBvWW5PTjV5d3lhaW8v?=
 =?utf-8?B?VThWZFh6UEw2R1hYWE5qQ1daVG9oSEVZREg4NWUxUXpuUUhMUm13Y3VoRkw5?=
 =?utf-8?B?ZWtnVXhGUW03dVJkQU9kRU4vK0N1dVMyUnFIWElLR2d0YVZmMUdxVjhFQ3R2?=
 =?utf-8?B?UHZkUHhpUFh4bnJEeTVmTlF4VTRUY0lha0lPSU01ckdEbFhQVzhmNjQyclA1?=
 =?utf-8?B?UU1uSTZHUXZsVmJOdHZIOEFOWUxtY05lOUFHbCtvSWFkY3ZMZUFidEFZWElE?=
 =?utf-8?B?dmw0eDNRaWUwKzFEd0pmd2kvQ1hkdmFvZFo4WGZuL0VOU0FqZXhnN0EwRGhR?=
 =?utf-8?B?VExFSURIbkVtaTJuRmxKdmtiU0Y5UmpmbHR5SG80amIrYW5DY0dGK2RSdTBu?=
 =?utf-8?B?MXVPREFuNTdFbXZ5MDQ5WExIeUtsWkV5RWwrdk5ndkNRdUVSNk00UEhXUnpU?=
 =?utf-8?B?QnYyTExnSXJOVzJ4YkQyemhHL2ljSmNWSzNEMUY2WFpuYkhlaWZaZDBMRVpH?=
 =?utf-8?B?MGtaMzZrOTh3WFY0ZU1zcFpzWStQWnRlazJPWk5jZ3ppQy90dTEzN1MxQUtL?=
 =?utf-8?B?QVp5Smc5QkU3LzU3ZzZVY2s2RkY2aThMMEdKTmw1NXZnUGJVL2g2YXM3cG9X?=
 =?utf-8?B?cXpwZzRzZElpbGt3bmtoN2RUSko4cHRRV2Jid0lWWkRmK0R4MkRvaG0rSFgw?=
 =?utf-8?B?QlFXbm5oK2RZK0VPQ2prZXFGam9QNmwvTVhMd0JqTjlHMU9ub29ZemxvQnAx?=
 =?utf-8?B?R3JaZ2Rna3VacXpCSjRxUitFb0g3RmM5ditHY1VRaHhrc2JWUTgvU1lIay9p?=
 =?utf-8?B?am85OTlqRlNON3hOUlgyRlFabVREbEM2Zmg0V1RCeWJqVmh2SkdabFFlU0Rt?=
 =?utf-8?B?SC9qSDZSV01Ia0FFUlpJSmlaSS82SnRTUk12aWM4MDhWRk9nOVF0WDA1dS9O?=
 =?utf-8?Q?P9T7PwDmgz4i8BlsujgpKSA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1109e8a2-de6f-4b4d-e810-08d9fc64a7ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 15:52:29.2923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d5gzRcTFBXsPOzpMABmRajnqMGkSBu7wsjMi0EHpXxaHXvAChK9c3sgBM/rfvA7Gy/H7UfZbi2SIx7iAUDpJYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3512
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SSBoYXZlIHRoZSBmZWVsaW5nIHRoYXQgdGhpcyB3YXMgYWxyZWFkeSBmaXhlZCBpbiBhIHByZXZp
b3VzIGNvbW1pdCwgYnV0IEkgY291bGQgYmUgd3JvbmcuDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQpGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24u
b3JnPiANClNlbnQ6IE1vbmRheSwgTWFyY2ggMDEsIDIwMjEgODoxMSBBTQ0KVG86IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51
eGZvdW5kYXRpb24ub3JnPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgTWF4aW1pbGlhbiBMdXog
PGx1em1heGltaWxpYW5AZ21haWwuY29tPjsgTW9vcmUsIFJvYmVydCA8cm9iZXJ0Lm1vb3JlQGlu
dGVsLmNvbT47IEthbmVkYSwgRXJpayA8ZXJpay5rYW5lZGFAaW50ZWwuY29tPjsgV3lzb2NraSwg
UmFmYWVsIEogPHJhZmFlbC5qLnd5c29ja2lAaW50ZWwuY29tPjsgU2FzaGEgTGV2aW4gPHNhc2hh
bEBrZXJuZWwub3JnPg0KU3ViamVjdDogW1BBVENIIDQuMTkgMDQxLzI0N10gQUNQSUNBOiBGaXgg
ZXhjZXB0aW9uIGNvZGUgY2xhc3MgY2hlY2tzDQoNCkZyb206IE1heGltaWxpYW4gTHV6IDxsdXpt
YXhpbWlsaWFuQGdtYWlsLmNvbT4NCg0KWyBVcHN0cmVhbSBjb21taXQgM2RmYWVhMzgxMWY4YjZh
ODlhMzQ3ZThkYTlhYjg2MmNkZjNlMzBmZSBdDQoNCkFDUElDQSBjb21taXQgMWEzYTU0OTI4NmVh
OWRiMDdkN2VjNzAwZTdhNzBkZDhiY2M0MzU0ZQ0KDQpUaGUgbWFjcm9zIHRvIGNsYXNzaWZ5IGRp
ZmZlcmVudCBBTUwgZXhjZXB0aW9uIGNvZGVzIGFyZSBicm9rZW4uIEZvciBpbnN0YW5jZSwNCg0K
ICBBQ1BJX0VOVl9FWENFUFRJT04oU3RhdHVzKQ0KDQp3aWxsIGFsd2F5cyBldmFsdWF0ZSB0byB6
ZXJvIGR1ZSB0bw0KDQogICNkZWZpbmUgQUVfQ09ERV9FTlZJUk9OTUVOVEFMICAgICAgMHgwMDAw
DQogICNkZWZpbmUgQUNQSV9FTlZfRVhDRVBUSU9OKFN0YXR1cykgKFN0YXR1cyAmIEFFX0NPREVf
RU5WSVJPTk1FTlRBTCkNCg0KU2ltaWxhcmx5LCBBQ1BJX0FNTF9FWENFUFRJT04oU3RhdHVzKSB3
aWxsIGV2YWx1YXRlIHRvIGEgbm9uLXplcm8gdmFsdWUgZm9yIGVycm9yIGNvZGVzIG9mIHR5cGUg
QUVfQ09ERV9QUk9HUkFNTUVSLCBBRV9DT0RFX0FDUElfVEFCTEVTLCBhcyB3ZWxsIGFzIEFFX0NP
REVfQU1MLCBhbmQgbm90IGp1c3QgQUVfQ09ERV9BTUwgYXMgdGhlIG5hbWUgc3VnZ2VzdHMuDQoN
ClRoaXMgY29tbWl0IGZpeGVzIHRob3NlIGNoZWNrcy4NCg0KRml4ZXM6IGQ0NmI2NTM3ZjBjZSAo
IkFDUElDQTogQU1MIFBhcnNlcjogaWdub3JlIGFsbCBleGNlcHRpb25zIHJlc3VsdGluZyBmcm9t
IGluY29ycmVjdCBBTUwgZHVyaW5nIHRhYmxlIGxvYWQiKQ0KTGluazogaHR0cHM6Ly9naXRodWIu
Y29tL2FjcGljYS9hY3BpY2EvY29tbWl0LzFhM2E1NDkyDQpTaWduZWQtb2ZmLWJ5OiBNYXhpbWls
aWFuIEx1eiA8bHV6bWF4aW1pbGlhbkBnbWFpbC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBCb2IgTW9v
cmUgPHJvYmVydC5tb29yZUBpbnRlbC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBFcmlrIEthbmVkYSA8
ZXJpay5rYW5lZGFAaW50ZWwuY29tPg0KU2lnbmVkLW9mZi1ieTogUmFmYWVsIEouIFd5c29ja2kg
PHJhZmFlbC5qLnd5c29ja2lAaW50ZWwuY29tPg0KU2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4g
PHNhc2hhbEBrZXJuZWwub3JnPg0KLS0tDQogaW5jbHVkZS9hY3BpL2FjZXhjZXAuaCB8IDEwICsr
KysrLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygt
KQ0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hY3BpL2FjZXhjZXAuaCBiL2luY2x1ZGUvYWNwaS9h
Y2V4Y2VwLmggaW5kZXggODU2YzU2ZWYwMTQzMS4uODc4YjhlMjZjNmM1MCAxMDA2NDQNCi0tLSBh
L2luY2x1ZGUvYWNwaS9hY2V4Y2VwLmgNCisrKyBiL2luY2x1ZGUvYWNwaS9hY2V4Y2VwLmgNCkBA
IC01OSwxMSArNTksMTEgQEAgc3RydWN0IGFjcGlfZXhjZXB0aW9uX2luZm8gew0KIA0KICNkZWZp
bmUgQUVfT0sgICAgICAgICAgICAgICAgICAgICAgICAgICAoYWNwaV9zdGF0dXMpIDB4MDAwMA0K
IA0KLSNkZWZpbmUgQUNQSV9FTlZfRVhDRVBUSU9OKHN0YXR1cykgICAgICAoc3RhdHVzICYgQUVf
Q09ERV9FTlZJUk9OTUVOVEFMKQ0KLSNkZWZpbmUgQUNQSV9BTUxfRVhDRVBUSU9OKHN0YXR1cykg
ICAgICAoc3RhdHVzICYgQUVfQ09ERV9BTUwpDQotI2RlZmluZSBBQ1BJX1BST0dfRVhDRVBUSU9O
KHN0YXR1cykgICAgIChzdGF0dXMgJiBBRV9DT0RFX1BST0dSQU1NRVIpDQotI2RlZmluZSBBQ1BJ
X1RBQkxFX0VYQ0VQVElPTihzdGF0dXMpICAgIChzdGF0dXMgJiBBRV9DT0RFX0FDUElfVEFCTEVT
KQ0KLSNkZWZpbmUgQUNQSV9DTlRMX0VYQ0VQVElPTihzdGF0dXMpICAgICAoc3RhdHVzICYgQUVf
Q09ERV9DT05UUk9MKQ0KKyNkZWZpbmUgQUNQSV9FTlZfRVhDRVBUSU9OKHN0YXR1cykgICAgICAo
KChzdGF0dXMpICYgQUVfQ09ERV9NQVNLKSA9PSBBRV9DT0RFX0VOVklST05NRU5UQUwpDQorI2Rl
ZmluZSBBQ1BJX0FNTF9FWENFUFRJT04oc3RhdHVzKSAgICAgICgoKHN0YXR1cykgJiBBRV9DT0RF
X01BU0spID09IEFFX0NPREVfQU1MKQ0KKyNkZWZpbmUgQUNQSV9QUk9HX0VYQ0VQVElPTihzdGF0
dXMpICAgICAoKChzdGF0dXMpICYgQUVfQ09ERV9NQVNLKSA9PSBBRV9DT0RFX1BST0dSQU1NRVIp
DQorI2RlZmluZSBBQ1BJX1RBQkxFX0VYQ0VQVElPTihzdGF0dXMpICAgICgoKHN0YXR1cykgJiBB
RV9DT0RFX01BU0spID09IEFFX0NPREVfQUNQSV9UQUJMRVMpDQorI2RlZmluZSBBQ1BJX0NOVExf
RVhDRVBUSU9OKHN0YXR1cykgICAgICgoKHN0YXR1cykgJiBBRV9DT0RFX01BU0spID09IEFFX0NP
REVfQ09OVFJPTCkNCiANCiAvKg0KICAqIEVudmlyb25tZW50YWwgZXhjZXB0aW9ucw0KLS0NCjIu
MjcuMA0KDQoNCg0K
