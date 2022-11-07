Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C4861F36E
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 13:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiKGMfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 07:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiKGMfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 07:35:51 -0500
X-Greylist: delayed 123 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Nov 2022 04:35:50 PST
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D165DFB3
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 04:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1667824550; x=1699360550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eu7tVovsb2J9HY0OF8i2Hn8n+sI75YpqMDVSlaPaaxE=;
  b=IDtVN0iRSJcC9yKsV7AQoQsi8rZj7M69nPNcKYrtHGIzdA2RVlSNOyRy
   aXEqeGo4KhoAUKXM6B3nUfKCHOvcqNkMFuT3MoxEBQhXe3QUGOcEv7Ho/
   lgk9paJN0I9njFf6+cKYaJbOkYf/cerERCzGzImbKeFhOil8ImQD8ycN5
   XcRXbuMUaFsmgAYeqx8rBvHnCIF4pS5zxaq9KrUPZ3s8cK97UuJ6/8hy+
   QqqBxIAzDbvb1RShsMe5kIXu9c7ie8+IHsPinzUPPGINuNh4USZb478cK
   vAYPvHxYADb9z/Golu6nmp8A+wTT7GeJNUN9b8P6v5dL4vb0LiS9VcQ6M
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="69461715"
X-IronPort-AV: E=Sophos;i="5.96,143,1665414000"; 
   d="scan'208";a="69461715"
Received: from mail-os0jpn01lp2113.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.113])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 21:32:37 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKBTom+etCHkOaKeVJf9KbGTFf72lhhuVO0+Wa/HJG41p4hNfQEv7Qjn43pOO9uQuCSdFebWZX0+yrLfc6LGzccKZGPn4PmeHVviwx7Sn756rnY/pMHgM5Wd2SalovtHeaDyK5pBL6sjMbdC3YqdBifAjRce0IxrIvPq788hq/w6W16v6wUvbp0GrPqftCpe4VcjuGPLP4qntX8B7QCZzfCziVUpw4Tr5kc5wUwvgfUFJPHmlUZwPRWRNuKhpMLAAKu62YmGBPWh1fLIH24K7aIbdJmSnkEWYDySEoriPVmewhx8UrisLgwIXmpCg/5uLo0YoFj1vnSIjXPh21T6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjZr2OSQmClvn1uJmKa3TQ+IkuHd0an2ZfKQH6eK3s0=;
 b=UBnoOoqYJH2RNr2DJZtS1fMLoGoQVvi6bpErhaBo+2uI65Tnrh0/9lJaQ5eQuYHayxjcYrgfJFQ8UUAVMPlZCDBtBUU61Bb8gHy/QQZC/DpSdJFTzSiombDAOxkt2+YLgTRzXZw3k7HmiLKtt4WF1CV+nUZd056f0ku0aZtHsWr/nJXtup3fKd3JD317BU3K8E9Vt5VBkIbw92j0HCDSiekMlN7eywhH8101ZCCaZm7KzrxySPCOZwBIN8wKaANekzYPpEc93CWdO5OS/trn/vNDb7jksNFTRYfn+HsiwJC0Ewt/rVDSDjK4nQSEmJQ2gSY1Y/OYy3JaIwM/azmiTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB7775.jpnprd01.prod.outlook.com (2603:1096:400:180::5)
 by TYCPR01MB10713.jpnprd01.prod.outlook.com (2603:1096:400:295::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 12:32:34 +0000
Received: from TYCPR01MB7775.jpnprd01.prod.outlook.com
 ([fe80::2c55:97e2:6dff:bfe6]) by TYCPR01MB7775.jpnprd01.prod.outlook.com
 ([fe80::2c55:97e2:6dff:bfe6%9]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 12:32:34 +0000
From:   "Akira Naribayashi (Fujitsu)" <a.naribayashi@fujitsu.com>
To:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC:     "vbabka@suse.cz" <vbabka@suse.cz>,
        "mgorman@techsingularity.net" <mgorman@techsingularity.net>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Akira Naribayashi (Fujitsu)" <a.naribayashi@fujitsu.com>
Subject: RE: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Thread-Topic: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Thread-Index: AQHY6S3O4xnDu8L77EevMVig1gEQ/64iskiAgAVyM4CAC1JoQA==
Date:   Mon, 7 Nov 2022 12:32:34 +0000
Message-ID: <TYCPR01MB77752C15C512BB7EC952F05BE53C9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
References: <20221027132557.5f724149bd5753036f41512a@linux-foundation.org>
 <20221031073559.36021-1-a.naribayashi@fujitsu.com>
In-Reply-To: <20221031073559.36021-1-a.naribayashi@fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: =?iso-2022-jp?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZl?=
 =?iso-2022-jp?B?Y2UwNTBfQWN0aW9uSWQ9MWY4ZTYyNTItZDU0OC00NGZlLWJkM2ItMzRj?=
 =?iso-2022-jp?B?ZjdiY2FiMDRkO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFi?=
 =?iso-2022-jp?B?NGQtM2IwZjRmZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9h?=
 =?iso-2022-jp?B?NzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxl?=
 =?iso-2022-jp?B?ZD10cnVlO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQt?=
 =?iso-2022-jp?B?M2IwZjRmZWNlMDUwX01ldGhvZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9OYW1lPUZV?=
 =?iso-2022-jp?B?SklUU1UtUkVTVFJJQ1RFRBskQiJMJT8lUhsoQjtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9TZXREYXRl?=
 =?iso-2022-jp?B?PTIwMjItMTEtMDdUMTI6Mjk6NDdaO01TSVBfTGFiZWxfYTcyOTVjYzEt?=
 =?iso-2022-jp?B?ZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX1NpdGVJZD1hMTlmMTIx?=
 =?iso-2022-jp?B?ZC04MWUxLTQ4NTgtYTlkOC03MzZlMjY3ZmQ0Yzc7?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB7775:EE_|TYCPR01MB10713:EE_
x-ms-office365-filtering-correlation-id: 865e44e1-173a-4eec-ace3-08dac0bc258c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7MTpHp2rJyHCCJTmiTA1XG6LqJJBKFUnBIpfRaUjCRGJ0K75rrVmbQdvu5SPr13L416zqXHDHjHfcFMtHhDlW044uhivsRJu3ybddVsdJlzKNzG8FxUqctyQdYIABJmrYn4GboJafDiY55lV/9Ze94wsiAvqw0PMSFEugmFi7uggaOjIzaXEIU1iwtRhITNJoE4QNMX9/PVcuk0pQjc0rDJo5QKd48yzWquDjckUbGjf/z2B+P4ti+/3uxWsSwXsQH/TmAO9D+5ZhC4a4dvStp1CF3KRXLRYmF1lUPOVqtHT1Wx1Qaz4ZJYkonKyE/V6UOtLpPiFLqriGbO0dLhJ08t5oNL65NBW2YNk3fOKxQx/P79qGRiyU5bc9iep8+wzpYq7u3vZ0IrHmBjhnqBLVXD2X5WciqqkpqZJBN+BPwPBn1U+mwGVZsiWTbjQQqdTBR54HIN+KSWmdDq+iy6Mr0XNMjbVFryI1lZEaE20itSnulV15ffH4HHjZyMs+ROxf+H6SyMhhLTS3ETerkhMBA43c086Y4ukI9X8VuDIUu4H9/ei1JtzGVlr1w2rqjha/O/SKwjhv7NVjX3eh59BRlKvvwMr9m1kP/iM2WJI18XnR1U/yup7NhX6OF2UUq8rwLoq9TWW2kLE3VzIB8Go5D+nFsiueWLxh7EB9zSAYhNZEHKMShoSxF/9uq4nT3ASHISvc2EqNMrUD4eq3RwB7Qu4WwgDRJyp9GZuOAkJV94Do87T3WrdpByxBYKcYDt/pqLxUViH6OxAiciRQdq8VXJmDgR68FphLjUtILYDweE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB7775.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199015)(1590799012)(5660300002)(6506007)(26005)(9686003)(82960400001)(478600001)(316002)(54906003)(6916009)(2906002)(122000001)(71200400001)(7696005)(86362001)(52536014)(41300700001)(8936002)(38100700002)(33656002)(107886003)(55016003)(85182001)(83380400001)(4326008)(76116006)(8676002)(38070700005)(186003)(64756008)(66946007)(66446008)(66556008)(1580799009)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?UUpPcWNraDZLYVp3L1BrMW5LTEhOSGVLYkNSM2p1VGY2eEVKRkJJajE3?=
 =?iso-2022-jp?B?ZFltZFVKK0xFWlZYMzhzR2gzRWRyUitBc21zOGdQUzJncGE1RVQ4YUVi?=
 =?iso-2022-jp?B?QjNQWlVWOE5nQ2xxTUxhT1A1YXBWSEpVNW1helFnaHZIRGhLcEU4MDhq?=
 =?iso-2022-jp?B?YWNCRTZGRVBUblRtWDNUSytocDlYaDFjcDBXb1hkMndvSCs2YVVES0lu?=
 =?iso-2022-jp?B?bkZoSnNxeVdRYTVDZy9HNzFZNWZKdW5XdW4wempKZ0pGa2U0Kytobnll?=
 =?iso-2022-jp?B?NHpHUHNYQXNxYWxlYlZhMHU5WE5kVWkzS0pRdnZnMEZPd25sL2F0Y0tD?=
 =?iso-2022-jp?B?RzhmUkpoaW1DLzE5NW01MHlrbVo2eS9PTzNCalArUWs3K2liaFRaUHNC?=
 =?iso-2022-jp?B?R20zYy8xWWdlc3ppRWZ6REFoR3lYUXVkcVBGUkw4ZmZTVXk1ZHBiZkRu?=
 =?iso-2022-jp?B?WEJ6c0NPUHl4cGRNT3crd2dzZFdXeGVlUnhxeUV5bjlnMW1ZRnMySVhJ?=
 =?iso-2022-jp?B?bVJvQSs1bWQzMDBDVnVoREc5N3NlQ2ZiTkRzZTBRWWJxVk82YXVwdmdp?=
 =?iso-2022-jp?B?QUM1K1djYSttZHRZTEt2TE45YU5VdDRJK1pEN0FzN21JUkY4REVvcVBk?=
 =?iso-2022-jp?B?VGRqcDhicVdueVRUZUk5eHFTbGRNUWI1aW0zeGVGcHlRTmJMcThFSHJv?=
 =?iso-2022-jp?B?ZHRWR3NlRXlQMXVMSk83bVdnWWx1KzZIT3dtenkvdGRzV09rOWtXVEVI?=
 =?iso-2022-jp?B?TDQ1WGxxUEJFSkFLSEgwbDBKZEk5ajlJdHFNSlpsRHdGTEk2Nmx4MGsz?=
 =?iso-2022-jp?B?eUh3cG9pNWllaGVmOWkvS2pkTG8zK1RwcGZvN3ZxTG4rQWVFeTVoSTJ0?=
 =?iso-2022-jp?B?RmQrVGwyeGtSMWJJb0pMQ3dHcFNLWGZWbjFkSUJBQlBlbnpra3JWcmNC?=
 =?iso-2022-jp?B?eWRlb0UrUFZMUExtRENJcktVZUxMNkhWSkdVcHV5VUlGdW1oVm5sUFVG?=
 =?iso-2022-jp?B?UnRqeGE1dU5Na3MxOFUwTHVvZkZKN2x2dGZZVis2OWJKeENIYVhueEJG?=
 =?iso-2022-jp?B?NDZ2U3FYZzlUbU83dkFtaW1nVVBNV1NmM2VzRUQvbEVHWWtBUncySjBq?=
 =?iso-2022-jp?B?MHBET1JsUTlEMFZzaFpVaDlPbHUyNVJ5dCtHeDRqUVZZMDVNUUJldHdD?=
 =?iso-2022-jp?B?UDhyMWlPYk5VUHlOaTRQb3pSWFhMVDZXa2NmTGYyRjNvdzNmbzJ2Ri9U?=
 =?iso-2022-jp?B?QzdIN1V3NGY1ZWl1RXhnN1BXRGluVSs5TnFuczhxS2liV0lpZWdBRHlj?=
 =?iso-2022-jp?B?aW5UUm85NDF4RWlhT1ZIOSticWFzL2hBd3E2MC9zSmN5aTNsc2FCam9Q?=
 =?iso-2022-jp?B?MmVkVEwxakswS2ROUzZWYkQwRnlVRGJrcFRhaU5Jclg1T1ZnUGFiQlFR?=
 =?iso-2022-jp?B?WHBRaEN6TGFjQnRURFdMUmpVRlVMVzlVTkU2THFGcnhiZjA4UHVhc2R2?=
 =?iso-2022-jp?B?cGZOelo2U29oL2JTMUUrZUExbC9MbVQxcllFTnpQNkhLT2VpL244b3pX?=
 =?iso-2022-jp?B?SHBoZjFNZ29odHViWHd4cEhDb3d3TURaemZZazdxdWJKMHhPRHI4VjU4?=
 =?iso-2022-jp?B?NGlOcEFoZmZncjZNRTNCSEwweW1ROUVOSW1wSFc4NVBoU2ZaVmZnaUl4?=
 =?iso-2022-jp?B?a2hxQkJLUFRsRFVWY3d5Vkh1enBmaGk3K1pKUTRrNzRpUXJoenVUak1K?=
 =?iso-2022-jp?B?ZWtKUEptUXRNTGorNytYc1RmK1Qyc2VoUm9HV0xMOGpZdndFMnRYQ0kz?=
 =?iso-2022-jp?B?b1l4WDQzYTQ4Q21rQUU5ckhaYVNqcnlFUjBFNUlsRzY1ZzlXMURZRFdB?=
 =?iso-2022-jp?B?WDN5UlNRR3FSaDBhdDVJTVAwMU1GdTNDbWdGZmFud0FwZkV0RzIvekJ2?=
 =?iso-2022-jp?B?VzVlWWZpWVI1V2xpbVkzbFUwTk1yODd5R2YxeGZmRFFNNDFnMVkxMU9k?=
 =?iso-2022-jp?B?THRGdzZPeXdVYTJOaHFtcHhyVUUyZkFmM0Qra1BGamZqYlRNUmRZZk1N?=
 =?iso-2022-jp?B?WjBLcWs1Wm4xSmFSbEY4eVozYzVMaG10YVY0SHFMcWx3K1lBWk5VNDAx?=
 =?iso-2022-jp?B?NThIcmxPak5sK0ZvNUZuN0xJNjA0U20yNmgxSkwvTHg1U2pXZk84OHRq?=
 =?iso-2022-jp?B?ZXBhajV1MUJJYzdPdUFwK1lwc2k4SFllN0VkTmIxTGpYTStRT3BaR3Nx?=
 =?iso-2022-jp?B?UkpIaDk0MXdHenNRQ0pRK05tZzIvQ2xxNk90V29sOVRlTTNTSFZ5UjNv?=
 =?iso-2022-jp?B?UFl2Mm5ZeVl6emNxVlFMNGk5Qm9ZTUFrMUE9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB7775.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865e44e1-173a-4eec-ace3-08dac0bc258c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 12:32:34.2238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ofnvbKnkY5JtmMrzs4hUvK5QM8yep80mUXL5s3AJCU29wUMl5kf2i3KmE3BsxVObyJwhWmZn4gkrJRN1CjaZDbxo2Yy6lAhann7gpPocQhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10713
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, I may not have sent the email correctly.=20
I will resend it.

On Thu, 27 Oct 2022 20:26:04 +0000 Andrew Morton <akpm@linux-foundation.org=
> wrote:
> On Wed, 26 Oct 2022 20:24:38 +0900 NARIBAYASHI Akira <a.naribayashi@fujit=
su.com> wrote:
>=20
> > Depending on the memory configuration, isolate_freepages_block() may
> > scan pages out of the target range and causes panic.
> >=20
> > The problem is that pfn as argument of fast_isolate_around() could
> > be out of the target range. Therefore we should consider the case
> > where pfn < start_pfn, and also the case where end_pfn < pfn.
> >=20
> > This problem should have been addressd by the commit 6e2b7044c199
> > ("mm, compaction: make fast_isolate_freepages() stay within zone")
> > but there was an oversight.
> >=20
> >  Case1: pfn < start_pfn
> >=20
> >   <at memory compaction for node Y>
> >   |  node X's zone  | node Y's zone
> >   +-----------------+------------------------------...
> >    pageblock    ^   ^     ^
> >   +-----------+-----------+-----------+-----------+...
> >                 ^   ^     ^
> >                 ^   ^      end_pfn
> >                 ^    start_pfn =3D cc->zone->zone_start_pfn
> >                  pfn
> >                 <---------> scanned range by "Scan After"
> >=20
> >  Case2: end_pfn < pfn
> >=20
> >   <at memory compaction for node X>
> >   |  node X's zone  | node Y's zone
> >   +-----------------+------------------------------...
> >    pageblock  ^     ^   ^
> >   +-----------+-----------+-----------+-----------+...
> >               ^     ^   ^
> >               ^     ^    pfn
> >               ^      end_pfn
> >                start_pfn
> >               <---------> scanned range by "Scan Before"
> >=20
> > It seems that there is no good reason to skip nr_isolated pages
> > just after given pfn. So let perform simple scan from start to end
> > instead of dividing the scan into "Before" and "After".
>=20
> Under what circumstances will this panic occur?  I assume those
> circumstnces are pretty rare, give that 6e2b7044c1992 was nearly two
> years ago.
>=20
> Did you consider the desirability of backporting this fix into earlier
> kernels?


Panic can occur on systems with multiple zones in a single pageblock.

The reason it is rare is that it only happens in special configurations.
Depending on how many similar systems there are, it may be a good idea to f=
ix this problem for older kernels as well.
