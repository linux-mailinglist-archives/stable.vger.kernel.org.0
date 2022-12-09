Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D8664800A
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 10:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLIJUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 04:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLIJUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 04:20:51 -0500
Received: from esa11.fujitsucc.c3s2.iphmx.com (esa11.fujitsucc.c3s2.iphmx.com [216.71.156.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC375803A
        for <stable@vger.kernel.org>; Fri,  9 Dec 2022 01:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1670577650; x=1702113650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7zVArKjOmkdlGX5kShhFqXLMrBiJIUIrCG5QC04RFJU=;
  b=qxNHr6SNTfwaXcFSSVcKKJPRRvz0wbDrsR1RGKUSG5xACi0w9j6D/Hf6
   hOujwMEZXNVU2/5HtU+SjQSQWRTyonwAEh1FxBjnDnvm6YNAmJ3pEFotZ
   i30nywcJHZqfrDMjpvF2ioF+YNWvpsQgDTrjLvZhuM9UQO24EulqSPD3W
   3SwFqlgp3NsJZ5/Xza9U0gb17kDDPooUDMV+m4C8gB9mDRrh6AeIdnXC4
   HW1MIOedsLBB7m5S7PEAg+WmEdzXaQ2nYSeFvNceNWVvBW6FCjY9XbHvm
   5Cr02GvOma15vw57ePoq+fW0OR0XkrOn+/6Yt5sKasDKMmKKeYyy0x5iF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="72476105"
X-IronPort-AV: E=Sophos;i="5.96,230,1665414000"; 
   d="scan'208";a="72476105"
Received: from mail-tycjpn01lp2171.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.171])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 18:19:40 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVPWdlp0V/Ex+YMeCXM7FHuUvhEiq03uyuFjcTL9YMwLcoKn5So+qcwzpBmA8TsxNh/UmYRlUVT8FLalngmeg2xV/BK0MhYivoR/bz9XK6COMLMMRSOm+mPy3Ne7x9lyBxdp4Na8gm9GROY+tM+TYILpNakGLtx2hV88GLzDsi6gXB4eeZM5DhPXRESs/C4XMY8ZY01EPxD/nccwZcgt2RACqiXfuHwTtZc1AauKWnrZ9X1cgbYsqDi4C9AKdoKCuyDCoswU3U4EdSFORDN0XHPHdt+PnbgaZu0UFMCkS3X8XauMXhjEUdSamVJwAH2mGZEMKjiADTzXLfID8VUE7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7iv6SN/8DocnjRj/g8AO2K+G1I1XWV7JUAbmIjJuS4=;
 b=kikq7a9+Hz9Mj/T5yXePy9nNZCkUBI/xqa6am3QzcKIFtRCx5dnQOEePQHx7HtY7cZchVxoBRPPWa5Spe4BKmPbsUXKrVc++HhfIPvssRoi361zeJLHDpIfz+Y84qYtcu7DV3AKl7kiJneQxJZj4Z80NQ2e/t84ol4ksELrImSXbOZQnDSaGtM73IyaRBMpVynhcx/+RyGkY0TA8/+Y7HqcxCdixwU1/IQ78cM3Ok2bB/+Z0ehWVOGqN9AmtjZ0SJm8YqwJQbW6KXYRVxB4LPQOW44AOm/wDBiMYxy31RD8eBWGIzzfLI7AGkVFcyMJelu67jFWndZb0R19Vu2O5zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB7779.jpnprd01.prod.outlook.com (2603:1096:604:17a::10)
 by TYYPR01MB10512.jpnprd01.prod.outlook.com (2603:1096:400:2f6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 09:19:38 +0000
Received: from OS3PR01MB7779.jpnprd01.prod.outlook.com
 ([fe80::6a87:be07:1510:d7d9]) by OS3PR01MB7779.jpnprd01.prod.outlook.com
 ([fe80::6a87:be07:1510:d7d9%5]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 09:19:37 +0000
From:   "Akira Naribayashi (Fujitsu)" <a.naribayashi@fujitsu.com>
To:     'Mel Gorman' <mgorman@techsingularity.net>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Akira Naribayashi (Fujitsu)" <a.naribayashi@fujitsu.com>
Subject: RE: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Thread-Topic: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Thread-Index: AQHY6S3O4xnDu8L77EevMVig1gEQ/64iskiAgAVyM4CAC1JoQIAANjcAgAE2EwCAF5ZhAIAH28Og
Date:   Fri, 9 Dec 2022 09:19:37 +0000
Message-ID: <OS3PR01MB7779E069E3F269349D4EEA3AE51C9@OS3PR01MB7779.jpnprd01.prod.outlook.com>
References: <20221027132557.5f724149bd5753036f41512a@linux-foundation.org>
 <20221031073559.36021-1-a.naribayashi@fujitsu.com>
 <TYCPR01MB77752C15C512BB7EC952F05BE53C9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
 <20221107154350.34brdl3ms2ve5wud@techsingularity.net>
 <TYCPR01MB7775D957483C895456CFE146E53E9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
 <20221123102550.kbsd3xclsr6o27up@techsingularity.net>
In-Reply-To: <20221123102550.kbsd3xclsr6o27up@techsingularity.net>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: =?iso-2022-jp?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZl?=
 =?iso-2022-jp?B?Y2UwNTBfQWN0aW9uSWQ9ZmM4M2I1ZTgtYTZlNi00M2M1LWFiYzktYmUy?=
 =?iso-2022-jp?B?N2I1ZDRmYTA1O01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFi?=
 =?iso-2022-jp?B?NGQtM2IwZjRmZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9h?=
 =?iso-2022-jp?B?NzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxl?=
 =?iso-2022-jp?B?ZD10cnVlO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQt?=
 =?iso-2022-jp?B?M2IwZjRmZWNlMDUwX01ldGhvZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9OYW1lPUZV?=
 =?iso-2022-jp?B?SklUU1UtUkVTVFJJQ1RFRBskQiJMJT8lUhsoQjtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9TZXREYXRl?=
 =?iso-2022-jp?B?PTIwMjItMTEtMjhUMTA6MjY6MTJaO01TSVBfTGFiZWxfYTcyOTVjYzEt?=
 =?iso-2022-jp?B?ZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX1NpdGVJZD1hMTlmMTIx?=
 =?iso-2022-jp?B?ZC04MWUxLTQ4NTgtYTlkOC03MzZlMjY3ZmQ0Yzc7?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB7779:EE_|TYYPR01MB10512:EE_
x-ms-office365-filtering-correlation-id: 33040a54-862b-49c5-0812-08dad9c67eb7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cuMol2ZgzJCFNrbQaGEiB3nFs9MDbRGixyx1v9Zpwi4N3ZWr0E1QZlbERMgI1+vQvTkUyNCdIy7OcocXwI+yHa5Qw3q5UAMUnY9Sk/P/2CfU6qf3zSgE0WeWN+qu4LkRHiNsq9rTf9jbw22MPfIiRGQphXUsI8cjIAh+ZYh3VCBxW14IwjDnwpYigGDIGfFNtcq3+RL4CELMQV2ez90QvV0acLlUozDYRERcS/FdNrW+wXYMA8AE3M3K28z8rhPv0Tmmeq7hwnsslzuUBkX63OLIBt5b4OYl/Gdk+OrVV5TAKlTXC+7lKE3Cb1eFpvrgY9AxkAaSrjSDdoVxdo0TwKfabRXcndq19si/10Iz24DQq2CE5AmE6FHrJKmhCcA1US7UYXagYVJffE9mQkqhTidqvLzokLwrY+8Mzf4oKCjr8RY7M+JpVaN3UXoz4Po3dyr70EB6+cCWmj84PUtBYp7waUTFK0705RuWJThfm4Mo4YvbpbUxGohRmpzUWAA6YBV3fv8zN0S89ZD3smlZAPMyjt3ZdK2DBoNFnD6sD+sDGsBXuAdrCg7H9bbOv0kqQYgckpFBLza0GsyT/uq0E4hFi/4Ww7v5n6+aiBZjm423CBrdyLVsjMwuqLqPySgZ1dLSX8UJk/RXJz6spbhPKIM72YTVBZbE1GJRooWLJcgo8Nc2C3g5/BEJqANYUMnUhbizEuuugYxl+hdstWYJYOI15dKR6LM4kANYhrrINzE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB7779.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(1590799012)(1580799009)(85182001)(5660300002)(86362001)(64756008)(8936002)(8676002)(2906002)(4326008)(122000001)(83380400001)(41300700001)(33656002)(66556008)(54906003)(478600001)(316002)(66946007)(6916009)(76116006)(71200400001)(38100700002)(186003)(82960400001)(38070700005)(52536014)(55016003)(7696005)(6506007)(107886003)(66446008)(66476007)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?QmFxTDhHMkRuVk50MVdaVHY5bmtsTmRpbjBCMVpxaXZVRHZBK2VkSFJN?=
 =?iso-2022-jp?B?ZkFBYmptZXEzVm1ITU50R1BYcFBVMm5PWXF3YVlzL2dnWEtoSUUxeGRj?=
 =?iso-2022-jp?B?MzN6LzlqTjdTRWloelRSMkNtT3dpTzVGMmxpZHRRQWdvbWVSODdvUC9N?=
 =?iso-2022-jp?B?VlVIS3FxRUt5SXI4YjE3dXJNVlRPYnMxcWZIZnFxS04rWGFsTW5YVVlS?=
 =?iso-2022-jp?B?R0JJY0wvcCtIZEt3NUNVMmZhQjd6UjlBSTY3VkhMekQ0ZlJIMGt3d1FW?=
 =?iso-2022-jp?B?VnpWOUw0S045TmkwekpSWnZBbitBekVsZUN1WnlNTkdhTHhHNFJka2dI?=
 =?iso-2022-jp?B?Wk5ZMFJVak9OdHVQSS80a2RoTFZ2VGd3YWM1UW9GcmV5TzByNGg0eFh1?=
 =?iso-2022-jp?B?c3RRSjRHNlZ1WXZiVDlFS2FFTHkyaEVWMFMvS2ZQQ0twdjZ0TnNWNVJ1?=
 =?iso-2022-jp?B?WUxBRDVhcDJxbnF1ZmpzUm1hbHlkYWRHQTltcTVUY0V6a2RIZ0pmaXBm?=
 =?iso-2022-jp?B?aUg0WWpWS2tVbkpRbTQ2NWpBZGJuaElUSnRTRnpJNnVLb3NyVzJ0cFNR?=
 =?iso-2022-jp?B?TzVVY291d1BpRHUvTko2a2x0U3g0TzBwR0tTOVpYYzNOVXJJQmpwRXFo?=
 =?iso-2022-jp?B?N0krYlBXTnQrUUs2K1I3ZkhXMk9TNUkwWWFzelNVdSsyRWV4cTk0YVRH?=
 =?iso-2022-jp?B?S0pPanBvNlNCK0RmcW5LRWdmYmtLYnQrbEVNSXNudWhpSkVqZDRrWVdp?=
 =?iso-2022-jp?B?aHN0R1N4TnNXMWNsYmoxQjN2RVVXSkYwODlZckVXU1dWZm40RG5WdnMy?=
 =?iso-2022-jp?B?ZlJnbUk2c2JSeXJhRzlFT1lzblBENHhzMkVDWVFqMlVCZDNFcVNrc3Nj?=
 =?iso-2022-jp?B?bXRyZHhoNlVweUpwYll1dUN4Q003S0NHbElSZ3FwQU4rUUZLdEZnU2Ji?=
 =?iso-2022-jp?B?M3NvWVYvcUE0TktLWGJCTHRBOWZPYkxNOUZmNFRXeXhGQU1DQmVTaEJ2?=
 =?iso-2022-jp?B?WVlJOVhUbGJQQis0U0x5MUNPeXlxWW5tMGo5ZHYyaGdQYnV1bmlEM3lj?=
 =?iso-2022-jp?B?ZCtQYU9CT2U2T2phMzRObHpGdzJwRldHamlnU0o4RDdZNlRZcjBRWFZ0?=
 =?iso-2022-jp?B?REJVV0FqcjhvN0d5TFAvTENMVW83NmNCcFZtTDJ1bnNiTllNS1RWTCtQ?=
 =?iso-2022-jp?B?N3crMWMwQVRSZnR5TWVkOWl3L0dZSGo1WFV5L0xVaGNhbnBoSGdjRVIx?=
 =?iso-2022-jp?B?Wm1JaXJsLzMwYWxhQVozWXVkVkFKUXRaRG1aMHJLYmdaS2Z1dXBpWDdG?=
 =?iso-2022-jp?B?MGxDVHl6amNzNGZPbWt5eGtMMmNnTE1PV0RVNm5pekpSaXJ2eFkxWHho?=
 =?iso-2022-jp?B?aTVxbEl0bG0wemlNckpocWt6ZnRpMmpLdUdHaFRYR0hIUUVYQW01M3BU?=
 =?iso-2022-jp?B?Z0gvS2N5R1JLNjRQb1ZVVHg5YmMzSUMyWXVDd3c3Lzg2NDJJTnc0OG9t?=
 =?iso-2022-jp?B?UXhjR09PaG41OEZWVkMxQlMxZitRZ3hOcHpoWTcwbmVqSjBMb28wLzFk?=
 =?iso-2022-jp?B?eldXeDRXdHhoVXlGNDlHS1l0czk4VittdDViODRHT1FEWVQ3aG1qVTdk?=
 =?iso-2022-jp?B?c21BUDhoeE5aMm43U2d6VTRRc2N1Tk1sY0NIQlhSK1oxY3ByWHYybjgx?=
 =?iso-2022-jp?B?OGVlRnV1VUFDcUlXclYxWG8zc2JxeGl0UVZoL0NobjVXWDMrMnYxcUtL?=
 =?iso-2022-jp?B?YStKREE4ZFFPN3VQSE9ESWlGbGRHRElrUkNhWXozNjN3cGV2VzRQdnFt?=
 =?iso-2022-jp?B?cFcvVFVkU294N1lYeEl0OVREZDYrZjdQeTE0elV4ZjlIUmwwd1lHR3FR?=
 =?iso-2022-jp?B?cytWZHJ0SHlCbmRkUnd0azNiTUQ1QVZ6STFjdHJpbFVBbEZuaDVuWU5E?=
 =?iso-2022-jp?B?d1BCekIzWmMva1ZEd2ppUnJOaHdWTERVemIyV1BmTEk5RFBwSitMdXdL?=
 =?iso-2022-jp?B?aW1EVEVpaTBJdWsxM0hLRjRpSzdzWmI1U0xHd0JuVUlqUjdpVzBrVlEx?=
 =?iso-2022-jp?B?dFVNaTNhL2lsRk1KNWJhYjRFQVlVbCsyeEwwZzdJTWRaVE1WV2NEYU9v?=
 =?iso-2022-jp?B?Mk5BZTFRSEZwVmFxYXBSckppOGV3NUpneWJkZjBxc0lsSjJ4Y2NHTFZB?=
 =?iso-2022-jp?B?ZzNPZXMrK2V6UU1tcnJVSkNuNHBQVnVHK0M5d1hYSEFQQ20xS1NpcjU4?=
 =?iso-2022-jp?B?MU8vMk1tNE5PeFF1SnZDeU8yTlFxN2R1amg1ckhyMFR5Ky9QTlNnRkIz?=
 =?iso-2022-jp?B?QmNkbTBHT21FTjB5ckF0V2lmVzVUU1BaTEE9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB7779.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33040a54-862b-49c5-0812-08dad9c67eb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 09:19:37.8397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SEZWnwM583nWZV6vcCMyVpTsK5rZ4cvg8bDkWf9MDktgzwXmcCfuVPU4apxivrDAEeBP/5lNH/HALvXmy/jV7oq64REl9iZwhtVvgkUmhg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB10512
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Nov 2022 10:26:05 +0000, Mei Gorman wrote:
> On Wed, Nov 09, 2022 at 05:41:12AM +0000, Akira Naribayashi (Fujitsu) wro=
te:
> > On Mon, 7 Nov 2022 15:43:56 +0000, Mei Gorman wrote:
> > > On Mon, Nov 07, 2022 at 12:32:34PM +0000, Akira Naribayashi (Fujitsu)=
 wrote:
> > > > > Under what circumstances will this panic occur?  I assume those
> > > > > circumstnces are pretty rare, give that 6e2b7044c1992 was nearly =
two
> > > > > years ago.
> > > > >=20
> > > > > Did you consider the desirability of backporting this fix into ea=
rlier
> > > > > kernels?
> > > >=20
> > > >=20
> > > > Panic can occur on systems with multiple zones in a single pagebloc=
k.
> > > >=20
> > >=20
> > > Please provide an example of the panic and the zoneinfo.
> >=20
> > This issue is occurring in our customer's environment and cannot=20
> > be shared publicly as it contains customer information.
> > Also, the panic is occurring with the kernel in RHEL and may not=20
> > panic with Upstream's community kernel.
> > In other words, it is possible to panic on older kernels.
> > I think this fix should be backported to stable kernel series.
> >=20
> > > > The reason it is rare is that it only happens in special configurat=
ions.
> > >=20
> > > How is this special configuration created?
> >=20
> > This is the case when the node boundary is not aligned to pageblock bou=
ndary.
>=20
> In that case, does this work to avoid rescanning an area that was already
> isolated?

In the case of your patch, I think I need to clamp the isolated_end as well=
.
Because sometimes isolated_end < start_pfn(value before entering Scan after=
) < end_pfn.

After re-reading the source, I think the problem is that min_pfn and low_pf=
n
can be out of range in fast_isolate_freepages.
How about the following patch?

diff --git a/mm/compaction.c b/mm/compaction.c
index 1f6da31dd9a5..b67b82bb4944 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1436,6 +1436,11 @@ fast_isolate_freepages(struct compact_control *cc)
        if (WARN_ON_ONCE(min_pfn > low_pfn))
                low_pfn =3D min_pfn;

+       if (min_pfn < cc->migrate_pfn)
+               min_pfn =3D cc->migrate_pfn;
+       if (low_pfn < cc->migrate_pfn)
+               low_pfn =3D cc->migrate_pfn;
+
        /*
         * Search starts from the last successful isolation order or the ne=
xt
         * order to search after a previous failure=20
