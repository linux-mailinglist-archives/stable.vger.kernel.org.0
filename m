Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E9051B7DA
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 08:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244240AbiEEGWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 02:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244206AbiEEGV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 02:21:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EA41E3F2
        for <stable@vger.kernel.org>; Wed,  4 May 2022 23:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651731500; x=1683267500;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ba4y3eGxqjW9z5a3ULMQAxV0ENvF6Oi6UM9IcfdX1Wo=;
  b=NSxd5cmB+rxXyvtFf0uI/np4vlIEIriW8dZ1IdbgeRe1x383gdy0PKVY
   jzMzBp49/353OBpyPYbNWDlVoDonkXvpdZ7iBkoaDO/g/uPAjjIaE3Hj+
   vtxbUoXL4mDFhpcgdItBvjXucAjO8wtXC0TKyGkJNxXx2iv+kXhgp0K9k
   vMqDkUjjc7BJ132mPX4KZlgVq4biGlilPC8i7GdqimH7GLcyoTzn67Cjp
   gsgyP1bs5OVmKj7SIUmuwD/bB1KTWSiMYDr2hd/Vc9STmkCdTnywV16Qp
   yDl2MtNSeIx+8qddj6h/nhm/NoqVrSED1dRzpkf3vFMfyJXdWAbf4lAtj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="265605808"
X-IronPort-AV: E=Sophos;i="5.91,200,1647327600"; 
   d="scan'208";a="265605808"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 23:18:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,200,1647327600"; 
   d="scan'208";a="734751307"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 04 May 2022 23:18:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 23:18:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 4 May 2022 23:18:19 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 4 May 2022 23:18:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWOJoUf9OSJTLC9RdPfaLLDlF5j7xXMfsxVHPL2kKl04lhZ1a6ld8JmVzbWzCddNeldP0yok7335muMij4A14KtqIi+5UJoPCZhAJMGjFzJ9tlGLXuYZi2XMRLMwOZQ5pPaj6fdNqpMUWdEegPe8Ixh9h6YFVnqN3wpxQA9Rc/aDbkBHOJpE5258O3HIzxPy1S4pB++vo9LpoyzXpOVrW2sjZINMfvlJyDM0j9jWEAJNfMoSpOeTBbRCVdpo5gL+iojPtYeBhPF/nNfKz1heEu580kjuU/HbtQIWLkpey8f7CGXyp/bktgBDadGujGhvxzcTqJZFqdLjBpTwU150YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ba4y3eGxqjW9z5a3ULMQAxV0ENvF6Oi6UM9IcfdX1Wo=;
 b=bill6kvGuGnM5Vgto1/SkVuJ1qGmBTr/qlsht99Hjo40jSOjX7aXVAYq0o/MuS0Tvrl91pu5fJdnPvgZiReJCFKRwxZhpx8DKuGRL1cKdH4O4SX2l2pZsSbj/fyGTjspRlqifQvqiOeCOPqTT/n8KEnzEr3fif0cshs+s+/nP1mtkM4stxTyFdWWiuB8WdSo2S0j751WOalFBnIlUIlfUJNhTO50wRaZDlV/NkkhzgZckyh14iM0f6wA6xS09EXkP7bw8DL4aaW02IjVkE2xfS3+8PEBQNzZx/rBPTuO5YQGCEmlOujj1RGVTX06wbMHKJmoqNijOfN+kXKz7KAImw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5751.namprd11.prod.outlook.com (2603:10b6:8:12::16) by
 BYAPR11MB3781.namprd11.prod.outlook.com (2603:10b6:a03:b1::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.25; Thu, 5 May 2022 06:18:17 +0000
Received: from DM8PR11MB5751.namprd11.prod.outlook.com
 ([fe80::d5bc:19eb:e1a5:a6ae]) by DM8PR11MB5751.namprd11.prod.outlook.com
 ([fe80::d5bc:19eb:e1a5:a6ae%8]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 06:18:17 +0000
From:   "Teres Alexis, Alan Previn" <alan.previn.teres.alexis@intel.com>
To:     "Harrison, John C" <john.c.harrison@intel.com>,
        "gfx-internal-devel@eclists.intel.com" 
        <gfx-internal-devel@eclists.intel.com>
CC:     "Bloomfield, Jon" <jon.bloomfield@intel.com>,
        "jason@jlekstrand.net" <jason@jlekstrand.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "Slusarz, Marcin" <marcin.slusarz@intel.com>,
        "jason.ekstrand@intel.com" <jason.ekstrand@intel.com>
Subject: Re: [gfx-internal-devel] [PATCH 1/2] Revert "drm/i915: Propagate
 errors on awaiting already signaled fences"
Thread-Topic: [gfx-internal-devel] [PATCH 1/2] Revert "drm/i915: Propagate
 errors on awaiting already signaled fences"
Thread-Index: AQHYX+WUiRSY6Oz9mE2Y6Swml+DyUq0PXrQAgABxTgA=
Date:   Thu, 5 May 2022 06:18:16 +0000
Message-ID: <fb9da0ae12586a2c0566d742fe8f5b01c6d495dc.camel@intel.com>
References: <20220504183410.1283944-1-alan.previn.teres.alexis@intel.com>
         <20220504183410.1283944-2-alan.previn.teres.alexis@intel.com>
         <c1ff80ae-465b-b54d-a62c-43673145a038@intel.com>
In-Reply-To: <c1ff80ae-465b-b54d-a62c-43673145a038@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09667a1d-fd10-4bf8-ca2e-08da2e5f0b1c
x-ms-traffictypediagnostic: BYAPR11MB3781:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB3781C160CFFE1737A1D554218AC29@BYAPR11MB3781.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1YWPAq9ylP6WQYaZXoGJRlg+cAhApRrNUeSYNDQn9xL2X6NtYk2OhSvChuBVXRkMxdmMVeXjPatO2o7zfGB2rLRs/aJnyoVQd5HQ7iqQPbxnYwMkUlACcQsfLoIDKaWdVoaRtdYHB/I2mjS1mjbY8Lfn/R3JoYYVaRwIU1JYMncy/S6GQSyjavSYpFKvW5kTeyTFuLhi4Qnj9eILhI6RTD7rsdEzIzAfg3JapFioxOyNmyfIEB5ETyr1xNBqtZIvnMuxsji1zvKmw8rQQwXZE3dmHTkT6MUcViv6GX9BTGxmi/4Vj9kiD1jY0cPaTUGGtXD43FNidfiShhkytt7xI5aXKlAxk9xm5eRGe+s9iQ3/bClyUTCeJVCbHl/o85Yv6ouxkmSeekNNdpS7J6884RcLGLRclT+/taJzN3vWVNUZ3V5qKj9ud8n7Ci5TlnUkq9TjnANHn71pTyYnfXynHBnuxKXWZZcEyxNIy9U6Kh8p7vn5kPinYYZ8kkGd/zRV4jR8fkCsG5CYOBp8FVfONf2084RJT1+Xwab9hWi+MEYZ4oN6eihcmQthhscMkoKzFc1SFI2wGEAWscOLelSKfdT0SmtHGNacFzXpsv+a8Rx51nDsecuzhaLiq3Ev0pySINlX3NfY9xo1e5HSmqgQNxEcJP1XBnCst1r4zWiThy+JrNyPQ8AqQXmkAj32O3HCGflCJcFzREJFymC1hKbZtfHyJHxnh+iUVJYUzy5pvl1eNEiSTNk8yjohsmuw53qzZIzP2Y64z2/3jE/Wf8zGlHWYVpwv/i6jzxjLIJXU0bY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5751.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6512007)(186003)(53546011)(6506007)(26005)(122000001)(82960400001)(86362001)(38070700005)(38100700002)(4744005)(110136005)(83380400001)(5660300002)(54906003)(508600001)(316002)(66946007)(91956017)(76116006)(8676002)(66556008)(4326008)(36756003)(66446008)(64756008)(66476007)(8936002)(966005)(6486002)(71200400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aG5RcUYzenZ1VC92ZE9nZnJNMnVNQWNhWG9BZHFrYUZpYW9pTHJTUUQ3ZDIv?=
 =?utf-8?B?MHlLeStCWHhRSExtR09RUVV3WXR5b21hZ2NEWGdCVk41a1FmWkRoeWttZGU0?=
 =?utf-8?B?YU43V3RaRytiMEZ4K085cU4wVTFPbk9pZERZLzBWTDNoK1RuTTdNUUJYbjBD?=
 =?utf-8?B?MTkvQ0JZMDlJU1Znelo1Q1IvVkJNbVlmVzhNa205N3JLWTY1MGQrMEJLYkl3?=
 =?utf-8?B?a2U2UTVZeXRHR3ZHQXRGRTV0VmZtVWxib2lIZGFWMmtQYnBoaVFScUVUbDNw?=
 =?utf-8?B?OFJoT3U1ODlvbFo3NXhtY0Q4TVMybzdHbFNEbTRWNDlpMmdxUXVCZmVkcG8w?=
 =?utf-8?B?OUJJRVpXUlhlZHdUSnA4Uk9JY3YrbGFUd1N0aitHOUw0YkRPZkVUNlBpZVhl?=
 =?utf-8?B?a2RKenN2bVZweWFPWmMyYXN5L3RvdUIwQUpGSXJNVytWanhLaEZSR29GR3Vh?=
 =?utf-8?B?NktCWW1jaVFHN2x2VzFBekFFNldPTkRMM2d3NkV6QVp0L2tzdHBzU2RBc2Ji?=
 =?utf-8?B?dEc0OUJoUnNVVUNjRHljcnp5TTNxRjZQTVl2OWgzY1E1VXNGQW80bENkSUlV?=
 =?utf-8?B?bUtsZHVKd25OZFVrRVphWmhjSmxkY1ladmVNd3RCdVhBbGxESEg4Y0pxMjVY?=
 =?utf-8?B?K1IwQjRVcWpkWGhDUUdXV1U0cmhhTElYa3pTajNBalVBTzdxdHcveXR5T1Rr?=
 =?utf-8?B?ZEpGZFNPanFxS1E4ZEwyQTcxZ2hWbmFLZlFNekVNeno0MTBNWjdhTEphUzla?=
 =?utf-8?B?cXNtLzB0U1pHR1k0bmFDYlQxNGxZTUx4cnpucml1bmZUdDQ2alI4ejFnK0xW?=
 =?utf-8?B?dVhud1lHZ0U0RUl5NlVFZ2lIUzRReitUSmtwOUQwVG1sZ1VNRXZ0TGpoOVR3?=
 =?utf-8?B?b0dpUGRZZkwxR3JUdnVvRGpsRVExaWkrVWpXOG9xc0NtV0lXbFRDaWc2ZDZ4?=
 =?utf-8?B?RkUrNitEZ0hQbjlyc0dMeXNRMTF1M2N2NHI5NTBoVkl6V2ZpaXpPY0p2ZlZo?=
 =?utf-8?B?dTR2ZzRhc0hsUzd6TDM1NWp6YmFxYWI3SElzaEhSZ1ZFZlcvS3FwY1VSYlBG?=
 =?utf-8?B?d2pidEw5ZTIxdUFpS1prak5ySk9XVnVQM2xGaG9BKzZyeWJxTnQwM1NKM1I4?=
 =?utf-8?B?cFZ1M0xvYWlSeElPSE81VFJYVVJsM0JuNG80NG5mQmZnVzdaZDZiSDFKR2hL?=
 =?utf-8?B?Si9kN3F3S09oR0VXaG54SVlmaTJ1R0V6M2pnR2ZSUk5EeFlzeEhSTUMxNDBV?=
 =?utf-8?B?VmVTTnFyaStCUGltWmQ3bFB4YmRkcnArOVZ6R2xPL2NUaU9GeHNna29IcTRa?=
 =?utf-8?B?S3R1cWU5Q3E0UisvbXNycXZ6ZUgzVzcvMG1rZU02aGF4WWxLYVpESmVSYzJr?=
 =?utf-8?B?a2JsRURKTnRIS1F0cVVnNjNWVGFIdmpwLzN5UGZNYVJQWWRNakp4OXFPUUl3?=
 =?utf-8?B?K2NBcU1aay9YQ1l2dWIwZjBxNFBJNnlFeFdueGhUT1U0WDRSa0ZYZ1l4WEJ3?=
 =?utf-8?B?YlpzNVdQcE8weWNMK2pMNGg3cWpuNWhzUVcwRWVWdjFDUzgvRHNkVnZyUlF0?=
 =?utf-8?B?bDFDcFpHV1pHeWp3cHYrRUJxVGdnZUlhVFBHMVpVd0R0cmVBTWRQWUZNVzR6?=
 =?utf-8?B?R1JmRkJ4TjJwWWpTaFhsL0tIVm9zRnM0eTRNNTkrSkpoTWVVSXJvbWdldita?=
 =?utf-8?B?T0g0c3lnM3BFcWVLc3p6TXlyVC81WmREeGlidmxsUXUyQnhNYm5MRHBKYUpV?=
 =?utf-8?B?cFd2RGoxVjVJbldqaTVxaytpellhYkN2R1AvdlNEbVlwQTJLd2htZnZhVElS?=
 =?utf-8?B?RFBHZ21LeUErOGRFbTdPbldjdzBGcjREOE94RHBGRnFoUDdLRzR5SkJPVVZG?=
 =?utf-8?B?THBQZEdBd2U5d3l0Ylh0aTRDWXVIR3VHbnEvSFdMUVlwOWlkUVpWUzdiM2p2?=
 =?utf-8?B?V1RzR0ZsNitHZ3J1WXowdmE1dXVmZXVEeUtBeFRtRnRJZHZnQVI4ZTVkR3FJ?=
 =?utf-8?B?bjFqSlpqTDYvSnBmTXFHdWowK0w1a0dOcHd1N29lWHBDUFhDOS9TaFdRZUVY?=
 =?utf-8?B?TUk3dDROQ3l5Y3pvK2hIcDd0TnNZY1RaVjJiU3lJZzVIdVVRazNjMjBFQlNz?=
 =?utf-8?B?RUdRNjk4dWNYZGJGeEJ5N2g4ZUVlT05FencxTjRqb2tPemxvNFJ5c2hnODN1?=
 =?utf-8?B?NnRmN1gzRGNrTzVGZk1zTmUrM1k2Sk01Qjd5VDI5dWd3eUFOSzR0TlBVTmFZ?=
 =?utf-8?B?czlTdEhqK3NVYUdwRDI2MUFpOG1PaTBjWko1MGFLamJFdXY2dFl1R2VSVXAx?=
 =?utf-8?B?UDhOSytsMlBQSTRMb3VtZE5KNzZGaXREclUzZmlyZ2ptcURlUUEvSzE0RGdu?=
 =?utf-8?Q?zVmtV1elJgafuAqtnECYc2qRJyTL88I3cMmYPjS99JHTX?=
x-ms-exchange-antispam-messagedata-1: UBcOiEJfbE/efA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB9F4F05AC63A04991159FC2A147514C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5751.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09667a1d-fd10-4bf8-ca2e-08da2e5f0b1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 06:18:16.9241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2D4DQf7sD8jjG3Sg9XkVTxmPyyRg/i1E2GUQhaslrglkK6z1gv8WuMnaUq/qefGpFbYgQCdZe9U8SwJG7fSv2HsSm9xyQdwpeVNYyMKNpgvKVUnTqs4IAkC+RewGMeRg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3781
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiBXZWQsIDIwMjItMDUtMDQgYXQgMTY6MzIgLTA3MDAsIEpvaG4gSGFycmlzb24gd3JvdGU6
DQo+IE9uIDUvNC8yMDIyIDExOjM0LCBBbGFuIFByZXZpbiB3cm90ZToNCj4gPiBGcm9tOiBKYXNv
biBFa3N0cmFuZCA8amFzb25Aamxla3N0cmFuZC5uZXQ+DQo+ID4gDQouLi4NCj4gPiBGb3IgYmFj
a3BvcnRlcnM6IFBsZWFzZSBub3RlIHRoYXQgeW91IF9tdXN0XyBoYXZlIGEgYmFja3BvcnQgb2YN
Cj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9kcmktZGV2ZWwvMjAyMTA2MDIxNjQxNDkuMzkx
NjUzLTItamFzb25Aamxla3N0cmFuZC5uZXQvDQo+ID4gZm9yIG90aGVyd2lzZSBiYWNrcG9ydGlu
ZyBqdXN0IHRoaXMgcGF0Y2ggb3BlbnMgdXAgYSBzZWN1cml0eSBidWcuDQo+IEknbSBub3Qgc2Vl
aW5nIHRoYXQgcmVxdWlyZWQgcGF0Y2ggaW4gRElJLg0KPiANCj4gSm9obi4NCj4gDQpPa2F5LCBJ
J2xsIGdldCB0aGF0IG9uIHRoZSBuZXh0IHJldi4gSXQgd291bGQgaGF2ZSBiZWVuIG5pY2UgaWYg
dGhlIHNhbWUgcmV2aWV3IHdhcyBtYWRlDQpvbiB0aGUgRElJIGJhY2twb3J0IHRoYXQgd2FzIG1l
cmdlZCBsYXN0IHllYXIgd2hpY2ggcmVmZXJlbmNlcyB0aGlzIHZlcnkgcmV2ZXJ0IGFzIGENCnJl
bGF0ZWQgZGVwZW5kZW5jeSBidXQgd2Fzbid0IHB1bGxlZCBpbjogIlJldmVydCBkcm0vaTkxNS9n
dDogUHJvcGFnYXRlIGNoYW5nZSBpbiBlcnJvcg0Kc3RhdHVzIHRvIGNoaWxkcmVuIG9uIHVuaG9s
ZCIuDQoNCi4uLmFsYW4NCg==
