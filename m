Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ADC5ECB9C
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 19:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbiI0Rtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 13:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiI0RtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 13:49:08 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CE7101B;
        Tue, 27 Sep 2022 10:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664300860; x=1695836860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IQsJfppVHRnP1pyW1ASYMAGS9hkMUXqaBgAi8LGzlL4=;
  b=Lo2TFgCDsjdC4W4QUIB/MqVm3x6YkB/H8bQgW359WwsFQvRjwMiAlQ1K
   VxjqhdlQUyoRlWCD4Hh3mtFei7rdUOwuI0x+za96MqeKC9PyEllmVwVMu
   0vqO6sGqFGbFl8+bCjY52YhgIb2BadgjCBWTgGIKkUOKrU765jLL4mIrD
   s9cMpWtRPaoD5u5Fumnl5nXBqkB8msH1zVdsikmasMUd/RDgNStxcKokj
   0W+4y98V2nzHH3oWm+neMyJT9KtXQK/CITsKnZ9Avwi11d4JyXLIrjc+H
   BfzVw/P24OS3+iPT6S85tpOVdvD/2JCzmx0tVY88WBlgkCdbG6pGXzv9/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="363224205"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="363224205"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 10:47:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="654814417"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="654814417"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 27 Sep 2022 10:47:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 10:47:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 27 Sep 2022 10:47:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 27 Sep 2022 10:47:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/1E5W7bwiCYN1ME/uLi8mY9O4xR9bUqtToN4gXjsac6T8mGqb4eM2wzIQuc33iM21Rr1WyyJBZ+W4DdRyQv5GIEo0NHTA7F/+WGG/PDF0BB8I7mgBUE3QidRoZ/6GCnMdIaCdSIFkgaFxT8geO7iivA1OrsuAUTsveai0dcrczu5MDukgn1XhsmAkt1gEyxCjhVOl9jtCWrjbdIn1U7gauLu23H/IF0gN0u6yEjj6IQi3CPPSuxH6c00LrqoObkvMP2AKx76k0r2FS84+1IHBfDQ6ER/udcrMNrEudccybX0nLzpWYbTUY7s7HOMSN22bwtHdAvR7Lhcl44T6R8Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQsJfppVHRnP1pyW1ASYMAGS9hkMUXqaBgAi8LGzlL4=;
 b=R8Z4J+JQQ06yzg3hsqMKg7+5nA+3HtJ6ZG11+Hffexuvg29UD449hi859YYaUykSAUArjHTwOJvefIpMurXkFQOJN8Ihp2rwDW8ifjqfNtYqa5GFnYQIxAQygO06WmPzZC/G+qWXkNFbleGyyXQUr2kZiBqec+1R9sEszeP1hKocL9m8NzNDavK3+HhGNTbfiPDpIThz6N03eqgGstADzwBKHo573MNpU47kMZgTMfHH4oaO4p35v17RjpYICoagqtXyomPR7HeaBWM35lT8Hu1zP6e4fgsu2eJHmbNxsxeeq3ZIkWqeOaUMUHCHSadhU0OmG+10yniJdGly4Gq1Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS7PR11MB6037.namprd11.prod.outlook.com (2603:10b6:8:74::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.25; Tue, 27 Sep 2022 17:47:36 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60%5]) with mapi id 15.20.5612.022; Tue, 27 Sep 2022
 17:47:36 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Shuai Xue <xueshuai@linux.alibaba.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        James Morse <james.morse@arm.com>
CC:     Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhuo.song@linux.alibaba.com" <zhuo.song@linux.alibaba.com>
Subject: RE: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Thread-Topic: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Thread-Index: AQHYz+pWnxyJgYboZk+A8TiiA+I2Ca3u0zyAgALE/YCAAD4LsIAA0nMAgADpGLA=
Date:   Tue, 27 Sep 2022 17:47:36 +0000
Message-ID: <SJ1PR11MB60830CBCB42CFF552A2B6CF0FC559@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
 <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
 <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
In-Reply-To: <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS7PR11MB6037:EE_
x-ms-office365-filtering-correlation-id: e9cbf834-f10d-44b8-bc5c-08daa0b05d5f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pb8bbqhH7ErIA+mlQQzmAs2o9+Z3U6r/VfBeSQ2dDkzt4HS4cD54oTRoE7A1zlHqTz3RGIcipKs1aLKT9q5RBTMFa89C3LkkbPO7y8J+JAZ6/hbRJlcw7oB1xwNTKc3Ru34AeLSGRAESAjkLF7hoIvAZaRr5gZ6JAUsQN8kSyiddm5G4hEoSPNIaTIh3frI70o6hZek7bFjvCe2DsotwDJNXSwEtUh+SGCtro88KTzADvvHqxfa18YfgpkqLyony1XBM4tgIsr77iZFTVdx/LbQyQ+t0e4djjb3FpNI6eboUCEW1zgG9vGqEzO0JBsushZ8Z5hjptU8FpvPTQnahsD5eMKVzUxvKK3Y3TtCNeROeBYXkqCnxrDLmJLHu1nfswdS+4yiHgHc1YkkYXQo2O2MTVWuDNKOmpcTU3CsxJgNqS7Y1fYpzi6QrtQ6ZLRMBjU9d09GWfDQ8/Y50Y6MMow1Iz3N62HwRqkzG1U71o6x0XO6Ecide3PfRAL8jpN15to0QvuCWcsH9kwV+YEiOjWPjW1B21CFct0/s2gS9wOXz8fJxl4p3cvoCrfdrgZo0QwDp/aSUsy2vQFeGQ6++sbVN4G55XnEV5e83AO7ibUl6ToQDlis5WshAcV6m2tszhsMz5bFGG7n0LxocGoXSRuPKWcUSwinQCR6ZcR3ouvZ9rGzulE7NyIW7lNZtiAyjUeI51z/jPVl+8jX/hvgj36RCZreLF10UgamALkF0LfgYzyfUO9zVeM7lyxX0yqJuR/6nZXzsz9jPIThFhXPzIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(71200400001)(7696005)(6506007)(478600001)(41300700001)(5660300002)(9686003)(186003)(2906002)(7416002)(4744005)(26005)(55016003)(52536014)(54906003)(110136005)(64756008)(66556008)(66946007)(66446008)(66476007)(8676002)(8936002)(76116006)(316002)(4326008)(38070700005)(82960400001)(86362001)(38100700002)(122000001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHhPQXJHVnJnUVhRSDB2RHlRMFpZVm8yb3NkWDVOc0hVRFlIWVRxK3M5Wm9U?=
 =?utf-8?B?Z2x5anpLSzRUSjVzQW5wMCs2SWNEMjR0L1pkWlFBNTh4TE9QSjk5SnVHZmFo?=
 =?utf-8?B?bFRqUjNlK0tuaEd6akhFcHZmK1lmWW9NaVI0ZXBPejhHVnA3aHlGRXhhQVcr?=
 =?utf-8?B?RVErMlVyV3J0VjRLOXRaWTdEMHdPNDB0MlhraU01NnlMZGhhekxSc0VGQXNp?=
 =?utf-8?B?QmxVekdlaHNTN29CWTMwOU1XYXhvSU1wbGRkRDJTRjFrSU83MWFWMmdYZHlM?=
 =?utf-8?B?eHlwcG9lMTdYWE1xbGFBQjFGZVp5aWZQZlVNbHVFbWtzK0lqTis2L1ZsMFhH?=
 =?utf-8?B?c05ORmJjUWw1L0lpVnRGUDR2K3ZFT3lHVGNVRFRydk9YQnA5WXRZclF1S0pm?=
 =?utf-8?B?d2QvdE1pZ2RzWWZTZUYrZHBzeHBQcTJrZGttN1pnNWZCLzVVUm1vTWpsY1Uw?=
 =?utf-8?B?Y09VMTlNQmgrNkFVNjBzMXlNdUx2UE1NemQ4YTc1Z2gyMGh4eENyUzBwM3U1?=
 =?utf-8?B?MkN6ZmlJVlcrZm92SEdzRk1SWGE1WlY3eHJWOVNsZW1FeUJqM0hhL2JvNWx6?=
 =?utf-8?B?Zjd4YkV0c1RBVXZ4clBLUWZwY2g0anZUUWhabjhCanJkUkp4MG5PNmM0M2Fq?=
 =?utf-8?B?T2I2elNFcFh4ZDZVbU0wSE1zOCtEd3EwWklSUHVaMHJFaEsyVWpWWjJ1WFl4?=
 =?utf-8?B?aGd1WENjMjRJU3h1RG9LTThva2xURTB2VzFSbmtEaUVnVll5WkhlT1JxODJM?=
 =?utf-8?B?ZjFEZlBRMjVCaHd2QjBZUzFraVZoZmp4NldGeWgyeHpiMGV2TzVldXFCRnlP?=
 =?utf-8?B?aWppQ2JBR045azdUTlhFU05IbXN1SXQxaXNNajFJZ2d5VFg4enA3M0dkTGh1?=
 =?utf-8?B?bzJodHBaOUo5cFNUT09wSmZTVU5pdC9DZ2dIUElrL0ZTakE0S282UnNKT2lS?=
 =?utf-8?B?elRnVFNwRS9kdi9rTU1mK3lvU1hTVUNzZzdOeWF2MVFwdXFDSTh2TXdBaWV0?=
 =?utf-8?B?ZXc5cEJOSWV2TmFDc0pXWWZiemdXc3JSalVERzJrcENENHFBNmkxdUhnSHNW?=
 =?utf-8?B?SnNLUndRQ2lDSXE1bHdwU2FWcVJjaFc0dHh1c1ZxY1c5Q1BkV3M2ZWVGUzhm?=
 =?utf-8?B?VytuejN3Y3d5L1VQOHFQeDNlRzZ3OGg2d2dGN3VkSVZIMktEbE1SdW9qdWkr?=
 =?utf-8?B?a2FneTFWQSt2V1JURkYxVzNiTmtVdXdkMEtXUmkvTlIxak56NHd0d2JRbWM2?=
 =?utf-8?B?MXpORXYyT3B3YU9ZWmhaZVMxdFR5SzVFZzk5bWc5V2RIRVFndlFyNUxSK2Jt?=
 =?utf-8?B?Q3lBYmx1d0lHSUJDNlBQY29iOEhidUc0VVNLYlBaU2hQMk94SGYzYkNmdTZ2?=
 =?utf-8?B?Z2RpYjdEZG9VWGN4QmJFSTBrZEtLOXhpS3VxcUMySDRqWEUweEM4QjNuZnpz?=
 =?utf-8?B?ZEV2Q0FWWlpEZHVLemtmRlRhWXhsc1BJN00xOFp4MGtKbU1iL00ydWtwUUhq?=
 =?utf-8?B?NmM5YXl0V3FPUys4NFRlek9XejI5Y3RRV3NaTUt5MGw1ZG1rZjFRYzc5bXNx?=
 =?utf-8?B?TUE0YUJjbkp2UFN1UWpMcjVWTmpzYmxJQTlubXhUYm5pbTJuMTBGWlVmRzB4?=
 =?utf-8?B?cGc1V2JpcFpCa3laVVlUanY4WEFxZDhOd2NKL3FDaTEvRC8yeWJKQ2lPSUp4?=
 =?utf-8?B?aEZValNQMTBqWlhXTHl2bUlUckNheXdLRFV1ZEtTMFdSTnNrWitpSkZTb3Iy?=
 =?utf-8?B?VXdRellZYWpMMkNiTVdHN1MrNmhYK2ZHbG90ZkZaMkpmZFM5YTJ0bHZadXQx?=
 =?utf-8?B?bWoxenZTdG1GZGhsZHBsczNVdEswTjFLdlAzUHBySUJzdTFDZ0hyTW9DMzFT?=
 =?utf-8?B?RStwM1BjNm4zR1N1Wm5jZGJPU1U4RUd2Z2xXVVZVdjF0cDBSZUp6eEt5aHdk?=
 =?utf-8?B?RmVnQkNXckdjd1BCWi9vcXIyaXNrdXRubGUvRENrS1lvSXVUVXdDVjM1ck1Z?=
 =?utf-8?B?amlxWEhlckllaWhheklVWktwRmNhbTZ5Ly82cXdQa0pVbStENW1yQUxudnY2?=
 =?utf-8?B?empZYTVCYVBwRm5oWVZTUVhlTVJYRkZBY1BKb3hBZXlDZ2h5RWs3dnVJeGh1?=
 =?utf-8?Q?hbuY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9cbf834-f10d-44b8-bc5c-08daa0b05d5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 17:47:36.7433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EjcIRWOjDNj5PV+BCQCsyHmn3YJHYkyVhdh8eI43+iCah8BYMECioyywtoo+m6XS9XWdxeuHpsp9Ynb3Aeu0Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SSBmb2xsb3cgYW5kIGFncmVlIHdpdGggZXZlcnl0aGluZyB1cCB1bnRpbDoNCg0KPiBJbiBhIGNv
bmNsdXNpb24sIHRoZSBlcnJvciB3aWxsIGJlIGhhbmRsZWQgaW4gYSBrd29ya2VyIHdpdGggb3Ig
d2l0aG91dCB0aGlzIGZpeC4NCg0KV2hvIGhhbmRsZXMgdGhlIGVycm9yIGlmIHRoZSBpbnRlcnJ1
cHQgaGFwcGVucyBkdXJpbmcgdGhlIGV4ZWN1dGlvbiBvZiBhIGt0aHJlYWQ/DQoNCkl0IGlzbid0
IGhhbmRsZWQgZHVyaW5nIHRoZSBpbnRlcnJ1cHQgKGl0IGNhbid0IGJlKS4NCg0KQ2FuJ3QgdXNl
IHRoZSB0YXNrX3dvcmtfYWRkKCkgdHJpY2sgdG8gaGFuZGxlIGl0IChiZWNhdXNlIHRoaXMgdGhy
ZWFkIG5ldmVyIHJldHVybnMgdG8gdXNlciBtb2RlKS4NCg0KU28gaG93IGlzIHRoZSBlcnJvciBo
YW5kbGVkPw0KDQotVG9ueQ0K
