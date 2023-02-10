Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCFD6923E4
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjBJRCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjBJRCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:02:35 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEDD38673;
        Fri, 10 Feb 2023 09:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676048553; x=1707584553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E11hJc6c2M7W8fzBqxZr2Jt/Vdo6uZmMbYJ3Q4/jRIo=;
  b=XjIAr2bByHv7nNvFbydMYXcGhehehxKIPD6vt4hm8s7AzLdSa2GmwRLG
   kTUeqEGuNOXo2ejh+ubuQEt/hR5BenK4F2+lPNj3m1Ljm1wLsPXBZqCaU
   H2K4yC/mPywKHkbwb8vB3WLqYs5zCJA6A5SaoY/uvNCEcNcdLqaBhC/MF
   BB9egg2CQdPjePNkrJjisP2JP8vXAmHk+YQMcS9HEaRU9CMXaJUxikRC2
   fY11B/D5Il0JlRzwzZVOkBb7AmArJBj5vQb22vz6s/FxGDIiQRX7wAxAb
   MJqowck/qjJSLusc/j69/cgvY7ih2791T8asyLOVGnbB79FmepL79cWaa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="314113095"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="314113095"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:02:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="736799654"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="736799654"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 10 Feb 2023 09:02:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 09:02:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 09:02:31 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 09:02:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QP4heRZ0Za/QWAzoH8WeAFIURUq5GaWVZDPmXfLTJmMC30BszoxhjDl7ZmtRABKa5iCzTyG26y/6dZnI8YH8HfEy1LSV5OQi9ncTulQrq2Gf1ntyJABThceDLImJblUMsQRMLSj8H2Hxmaehcl0W2hAWbXGX3xE31kWifLCgbPJnValDXtrK7hLdko5BSP/X7yhRBlnFgmmAxSRM+p8PDzcsIYa8yQmzxWlASKZJlyzuWXQXy3KuzkBnhEagE6MrPkUGMSwuJlQdU7DwLDI0sak8IgzIWed2POKYVwx71vSXHl1crHyvPkM/2yJhvrsHqLOqMO3LFXeMCB12OCm1HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E11hJc6c2M7W8fzBqxZr2Jt/Vdo6uZmMbYJ3Q4/jRIo=;
 b=STq9lGv7mejigomfceayMsAcC9vvTyv4SkakPAmjKe6s7aDGAt4og8XHHLS9SufePV1il89eIjBqWmNkChk1aS1usATwLc6suJrEZQ/xr5iGyRNvBK5I0S4pbRTw7HeQR/+ecFk8WyjSKDxxuwX7WknDOA9j7pS4FQVTp8LkLoXTC99Z6vjDSFSf9NOYIFyWvtAebu5zKaTBc0vP+Ra+7h0LMkBKKVAkG0SCXGE7Piavn9ad8Pvd7RLoOaYOrQK0D7g12VzD6u9nYsw9cMQon4TpRKoipfMdYDRwLTFIJR4EXAc1VAVUXinbDxqKTOZypumTGxCMF+JKcWfjuSiQnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5789.namprd11.prod.outlook.com (2603:10b6:a03:424::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 17:02:28 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::ee6a:b9b2:6f37:86a1]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::ee6a:b9b2:6f37:86a1%9]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 17:02:28 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
CC:     Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Xu, Feng F" <feng.f.xu@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address
 mapping arrays
Thread-Topic: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address
 mapping arrays
Thread-Index: AQHZPIrF3XH5dmXuJ0mF/10OMnsMRq7G3fkggADr7wCAAJ9/QA==
Date:   Fri, 10 Feb 2023 17:02:28 +0000
Message-ID: <SJ1PR11MB6083F2E23723D45E52614E51FCDE9@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20230209133023.39825-1-qiuxu.zhuo@intel.com>
 <SJ1PR11MB6083CC9171E90537D09CB9B4FCD99@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SJ1PR11MB617933E74BB2D538C0426A9589DE9@SJ1PR11MB6179.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB617933E74BB2D538C0426A9589DE9@SJ1PR11MB6179.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5789:EE_
x-ms-office365-filtering-correlation-id: 71f29e2a-32f1-4b16-104d-08db0b889761
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OMrUY6Rt6Dyod76rlntTKE5fYvCnPo2A1aB2bfz30/qfUZokeqaiS7Vj1JgELGw92XvFh6Jo2FAySiF53SMtwW+2rkFDSxqkDQqcWqXMOdg6QkCBWnUxuj1XUE7twt24DUXm29ZnGB3zZZDa5LyzAvwbeOnmt2e9lmMoovcf5F7QlXvmhSPRaxb9MrmfLuYN91B2rv0X5P+nFbygwIEwtYH6lemy8cvh1H5xIKLqg0tMNaFEi0jlmGYnZ1nHHSxiJxlpULpdqREpHVEiVBpOlx0kG4uxsmoQqkl4qi3V4FTFonZRq/nOqspT9CwbOW4vgl4Xnl5YOrJkOM3dUSgRRwJnxplZQhqjMmpz0JN8pwjCBBeoehhCf93vivVUWxbSPG5YlWSE3gBQ7BE9w2tx4U+Ba9ajKqUBxS6g0vVoFLGw6BHyIIaSw0LOtfFjhFT2JjNKtH6AwEtugoXkYA329aMxN7P1m7jgaMNuP40tJICC49RhDemEhfS56JQLassBEAEncPl0kd+u9LOYP0jH5BdMXirwYj3fWAcna4dED9zJsr5bvAMwT08NwJ1Adm4pTY9irFiHt75hCrOJfADhMwEOtRFXSqqy4TKVJBANTBj5rvQ+zj/luf+CMSnu/p5ynBpT0NBGw8YjYYspv1yq7kN2ynsSJ7Rm0GEigOqv2NOSDBVpwtDXLqoFG8GCK9m+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(86362001)(38070700005)(33656002)(122000001)(38100700002)(82960400001)(26005)(4326008)(186003)(8676002)(64756008)(6506007)(66556008)(66946007)(76116006)(66476007)(8936002)(9686003)(66446008)(6862004)(4744005)(5660300002)(52536014)(41300700001)(478600001)(55016003)(7696005)(6636002)(316002)(54906003)(71200400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3JNQjdPd0hHMDVrVEF4dStOMkFaRnBJM08wMUplZ05lelRoemVtbExNRlk0?=
 =?utf-8?B?M096RVlxcGZ0REhpT3p5U2VTamhpVG9teHRCYmFZcXIvS1FNZk8yN2Nveis0?=
 =?utf-8?B?Qld5STQ2S1dnLzhZanRTUGJkTFBwRzdESVB1aEVhcG9VbjFTWkE1RGVNc05o?=
 =?utf-8?B?Z0hXME40OE1YMzNST0FpUy83WE05ekhwOC9ybkxkMDBMY3Roc1ArOWpPdWZq?=
 =?utf-8?B?VC9xZk4vUHBSOUxuTXdmSjRZOFdlc3ErU3ByNHhsa1VOaGR0TGIwTk9RWG1s?=
 =?utf-8?B?Q1F2UGU3YmgzOU1GT21YSFhaajFWaHY0b0I4RDhGcFJ0K0JRWDZ4TlV4U0FK?=
 =?utf-8?B?VnJTTmF3QjNRalRIMERIQy9yY0NFL3V4U1VnMExlWHFrazNlbDZYMzZxY2M4?=
 =?utf-8?B?QjZ5VE5PL2d5eHhNSnBTaWpvVUUvc3Z5eWJEdUl3cUhFYXg0Z21zU3U5UXRV?=
 =?utf-8?B?REl4MG1nV1JuOXZFekdzdlQ2UXRSQUNubEt2WW1OTkY3QldxRVlhazFqbkFH?=
 =?utf-8?B?R2p1L2J6U2xRbDRpbVdESGJ0OG44UVJwcVBEU0IvdnVTRzlOSTFteUd1Y0Q5?=
 =?utf-8?B?ZDE2QTdjcG1EVjV3dHdvc3U3eEVGSlk0OWhhbVlIblNtdFZXb2dIT2FMVGFT?=
 =?utf-8?B?WGJwZVR3ZFFKRXJtbUx5ODRYTEVxRkFKUDhkVVFsNGw0VmY0SThpNVFaR1VE?=
 =?utf-8?B?WmN2VVR6NEhCZm1hQ3NIK1cxc0xuNzBram9zZWx5YlNnQVMwOXVJR3N3WE5H?=
 =?utf-8?B?VDlkanFXZjF1cUQ1eEJWSXdvaCt1bUxZMEUxaFRrNkVaZFRkc0wwOEs3SUw0?=
 =?utf-8?B?YjNQd2xGbFd1MytzWnhqNnRzMWYxUElWQ3Z5aEtkaHZFS1hSODg0dklwekp2?=
 =?utf-8?B?UkFpbUg4aWwvem1IT0VJaFdJVTJTbURNQkFLeGJpSkl1eUxsSlBzZnVkWXRP?=
 =?utf-8?B?TE1KWEMwL055VHZ6b0lnSVVSMUtJYU9LWFJxZlp2QTVIYUI4MWQ1TzRHdUtp?=
 =?utf-8?B?OER2ak90RVpPcENmMDFxYTBPaXpjenQ0cTBScWlpR3B1ZE0yb2xWeWN4RU5o?=
 =?utf-8?B?L25KdjlHR0dVRXRkSVBXTUtSY3YzWGlkWnBwcmRaUnlnM041M3RzUmtSekQw?=
 =?utf-8?B?QWUxYnBaZ3lpOUlLWnVxVzRsRWtGZWVBRks1TUdUUnQwb1JSS0V1U1h1QUpP?=
 =?utf-8?B?SUtxZExSRlMzMklRUTQ5NnJBWTVVRVdFQ3NEM3NWaVBRSVNVQ3EwRmRRSXFw?=
 =?utf-8?B?dW5HVldDd1R4RUsxcS9VbEVWRE9JWnRVZ3gyS2N6TWFWNlVESmtTQ20vT1Uz?=
 =?utf-8?B?Vllad0dnNUhhdkFjRFlJMWE0eVJRb3loaWhiblhiRGZ6Tk8vaVJRU3JwbCtM?=
 =?utf-8?B?RzRyM3drODhmdUJjS0h3bjJwMGRtdW9vUHpEdDBDRmE5SVBjejdqcitVOXRo?=
 =?utf-8?B?WFN3a3VRTGk4bVlvd2R6dXFpMzJHMjBNbVJzaWg5OERwQkxoaTlWUllyc3Zr?=
 =?utf-8?B?K3lKKzkrQ1h3V2JCdWVlOVhxTFRBRUltNVpFN1NmMm0yOUhweHErSU5aV2lu?=
 =?utf-8?B?NjlMUnl5bFl3UDVIMk03UTBzY1MvUzUwSzBsRzBFVTdEZGIySWNDeERpMDN2?=
 =?utf-8?B?bXYvM3dmWGNoQllYb3crVkNjUEpIaWxrWWs0cE8vL2VKMzlHZTlIYWI4TFZM?=
 =?utf-8?B?TWlMWEZoUDBYWTVZcHUvRWdxeDNrZjk0RHM2bFI3YURvUmlPS1ZZQVBLeDNx?=
 =?utf-8?B?UzgyVlZWYm5MMFJpUjVxYmlBdDFKRHhxMnVkRDlNT1BXZ3c5UVNtcDlmKzRF?=
 =?utf-8?B?K1RYRjdIMENabFlBc3ZpTkh1cXpVQ2N6Y1lFb0JITVdEV2EyVVM2cHZpWG9T?=
 =?utf-8?B?K0dPaThkYlJTWmxkRmNHaWlEMkMxbW1vYnBYdml6OXJlSjlyY2RNcS9CQzFy?=
 =?utf-8?B?Z1hMZXF5bFlZUXo2VnlvRmhxd0hpaW1RYk9TZmc2Qm5RQ0hFZVRPZ2NZQjJX?=
 =?utf-8?B?MTZvdDdYL3JSNUIxb3QxeXNMNnFtdWRoVHZVUkJlTjAzVGVFZW9nemowUHZ5?=
 =?utf-8?B?VEE5UlRMQTVWTU0vOTZxU2kvYlNKS1RQeDd2Z3hEcFBpTjVxcGNDK2dGdlBM?=
 =?utf-8?Q?kd9ePTFzbudyyyad2l6ljaw8f?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f29e2a-32f1-4b16-104d-08db0b889761
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 17:02:28.5767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRUmsnIRY9eXH0A6ZA/ihtFsKtVMHFhlrBSw2wWHzRyvAT322Woa1Z3ygC0RJRieCEtxQVj8UFClacHVsvVAJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5789
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBEbyB5b3UgdGhpbmsgdGhlIG9yaWdpbmFsIGNvbW1pdCAiNGVjNjU2YmRmNDNhIiBvZiB0aGUg
ZmlsZSBza3hfZWRhYy5jICh0aG91Z2ggaXQgd2FzIHJlbW92ZWQpIGlzIHRoZSByaWdodCBjb21t
aXQgdG8gYmUgdXNlZCBhcyB0aGUgRml4ZXMgdGFnIGZvciB0aGlzIHBhdGNoPw0KPg0KPiAgICAg
IEZpeGVzOiA0ZWM2NTZiZGY0M2EgKCJFREFDLCBza3hfZWRhYzogQWRkIEVEQUMgZHJpdmVyIGZv
ciBTa3lsYWtlIikNCg0KVGhpcyBpcyB0aGUgY29ycmVjdCB0YWcgKHRoaXMgcHJvYmxlbSBnb2Vz
IGFsbCB0aGUgd2F5IGJhY2sgdG8gdGhlIHZlcnkgZmlyc3QgdmVyc2lvbiBvZiB0aGlzIGRyaXZl
cikuDQoNCi1Ub255DQo=
