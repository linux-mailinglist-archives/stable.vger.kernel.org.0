Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B588E537441
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 07:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiE3FUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 01:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiE3FT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 01:19:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88D112D17;
        Sun, 29 May 2022 22:19:57 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24THDEgg026309;
        Sun, 29 May 2022 22:19:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=kebkptH03v++6rCwE38cOXi9ev8u+vxirTH5QLqFEDo=;
 b=rkEvypPVI+i2s4H5ETCjJUev0xtGgXJTL8WvBOKRvjddWTwF0KVk8l2f6e+Kv99Oizwd
 zBkNRgvkfoYlk3ijXouDv5yS9wSoKSrXg4ErOrZ3R0CQ1VZ/maDhK1S37mZss1iIHDg3
 iJjLQyMNKRVchGUzVQRZx2UOj7573p2qV2U= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gbk22p7vw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 May 2022 22:19:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0PsBgpseTT7V8QIJPOi5vyl339+OG3jK/SuEQlAAq9MCcjCVyIhYyaQmEx41u8zHsDmBr6wl8iVH1GMhU9No9xSa4J4h9qb1MH4KQWrejNkEJY6LghoP9l9zjbwiuxHxEyT/McEbP2IqgRzCWEBmbDfAYaQZcP0zeqzp6hrKHShYo8Agr4Zo8An8kYG3LqPzaU8pnkjgFSWCnda2XEeKWNC0txUryYkZUCSWCuyOvAWzDEvEr03tfIcHRHfkHL0i3i9JRTRite5WxW+aqr8/Rx8WQnTOkZIfxlc+dDWqfpw+gofZ0ogw7fqKCxaDI0lbtbDKufhZ+UwNcsz/90bdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kebkptH03v++6rCwE38cOXi9ev8u+vxirTH5QLqFEDo=;
 b=hKy3CeouVYYZJvknlisoJDQHbSULwrHcJ480paqYdeWQWn4qCIJtb4xtuc2JnOMb2iVL8JyobIFrnWolACBwotVyqeYbBiDzVWBE359LfpWmw2TEOUYmuMZpmfcumEp91QlmLXByZiz2pR7yQFKrM7hIgjPLeoVI7Mp23KF0ydZ20IPqPaISeK2LzuQfgW2zoJa+IEL+hQnn711oLp7TE7wjif7A7CpEpJGid2Abd4EqMO45q0QQwtGvvVhpDqQdgk5mbqkQN49xoIDgNCj6dKH3d6GvhlAWBD3KUDZXRtfbFGhRrA+9BZ93szqLMKTs/K7GBQnePVwh1mV1CxsBoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB4108.namprd15.prod.outlook.com (2603:10b6:5:c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Mon, 30 May
 2022 05:19:53 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%5]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 05:19:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
Thread-Topic: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
Thread-Index: AQHYceI9+nNYqnip2EqaqGe+bD34G6025gMA
Date:   Mon, 30 May 2022 05:19:53 +0000
Message-ID: <5EBCF33B-D777-4763-ADC3-0EBE676AC220@fb.com>
References: <165366693881.797669.16926184644089588731.stgit@devnote2>
In-Reply-To: <165366693881.797669.16926184644089588731.stgit@devnote2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b7b48eb-e84e-488d-7bd2-08da41fc0752
x-ms-traffictypediagnostic: DM6PR15MB4108:EE_
x-microsoft-antispam-prvs: <DM6PR15MB41089213A7A7167D5BF87A50B3DD9@DM6PR15MB4108.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sPN58LKaqcC74/SDr/r93/Y6CQNmA9hol7mwODHXgKBW/VsjCfgVozWwmRZPHQbkdPeoWDk3X1CHti8JtyZw0ZHpvB9AhymwKB35RAhU4Q/IUnbpHL+0kCqQPpoW61QXAPABaej5VNHj5GM30TMktPgRaHYoUaBomIFRJ40eY3jQGNaatalL5Ho/cz4Osgu+DTufga32WWZLitnPl+Zj76qGxs8OSAZcL9YoLPuz/oasFVSDsYmY7lI4KfuqBRSvqL5X0sO2wt4Fn/NbnAkvSkuZNieQ84MDuo3gbpC495BqG/0W8Sqi3BBd2oZTNwydKHFa+hJ21tL0EMbASGRVcSjSXM9nLQVB9SD55A23AZwfx68LwYXyMh7dgA+uFIn6Z6fIM3tSq9NkR4iLTBFngpu3l2ixr/9PohfbOixKd3iHjIEqL0pr7NULgV3Vq5hna2mKrK0NEsxc0BkcN4sCOSsoPI+Rh2qw/dS1mq+5XZjtE8ek4c23OKtvvBF3iRq1pssRaodbbfgfvvDYcQsW30U5ED/Ht/WbnGuyQWv4lRQSw5+L27YeOvUw4hr6tdOto3ykc5sxq/p/x0z1oybq//kdn32Q/Ledr0K/z7UzSe54yrWCku7UJygNiNPOYEmMXH3TsPcGS54t4LEW1KIHNI90c5fpjU8pQhVSKsOgBUJYd2sa6BHhGp1g6kWDBVKKlZjY9j1q7lAoIiFivr700X9rwbAhKHZQMAANNcAEu6pNduCtuSB7qx0dvEWwhDUj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(66476007)(36756003)(66446008)(91956017)(86362001)(54906003)(6512007)(71200400001)(186003)(2616005)(76116006)(64756008)(38100700002)(38070700005)(122000001)(53546011)(6506007)(4326008)(2906002)(8676002)(4744005)(6486002)(316002)(508600001)(33656002)(5660300002)(6916009)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5uRNC9BU+a/PO6vgX6yjSMKTnurycMPfWWLTIOHBJSksd6oKqloDAXDQ/kGg?=
 =?us-ascii?Q?gRIbINFMyRDAl3iSXqABUkDwAbrmFHqwow1+jVTCFDTe+UfRHAam1ss+++70?=
 =?us-ascii?Q?b/HJzGkRWGHlNFUnGtqnEpx7bcxNbVlkck0Xwbjw2rnXoi9l5HkuEB2SD5fZ?=
 =?us-ascii?Q?P9v1+DiZEChjcgqPth36q5snaE8wl2MlaXeuHpN64tKfJJ11bTG6Ju4ta7iT?=
 =?us-ascii?Q?Mg7aS+cwZSHGpn0q5ggeTXrPJuMhFT9QTvHej31KW62YVewAaQgz+aKPggBu?=
 =?us-ascii?Q?Fb5RdShpCIP1kbZMHkmKnA/kP8soCQqQCh/QZW687TFbuNyGaJZuuCBfaTe+?=
 =?us-ascii?Q?r9bcUqJnBcmHJQ2+F7T9cP1KQWA348yngkGp9jXTDHVBwbquU20bECI8mJ5p?=
 =?us-ascii?Q?Ovcbi5IhHx/bmPqeXebRe26VVunFwOcoTWQwuvRHAoIIpYCMVn6mh4qa+pp6?=
 =?us-ascii?Q?EMAPubpUrmP1EWkT3fA3x2eu4i1gNTDrB5CzH5BwLWth6bUiwZz5ziM9Usa7?=
 =?us-ascii?Q?NisK4ZAezaRWATHqpHDJc2hHM6Gbsn5NDFVKn1uBDrJcb3pGoQ7LNG+4Iqcl?=
 =?us-ascii?Q?IbDElqsXa7A6y14UNLB6GCC2h9Qt9dHpCNIkAcF899tzEs5WUNiqi3katA8u?=
 =?us-ascii?Q?YSIojKaUGySR+8wbb/VC4aCaSJcCtt8p/z7BD1AZqdEZ4be+EWiFparql2AX?=
 =?us-ascii?Q?wqI/SyLncSN6/9qW+yLGZswBrtQO1EmOfH8lE3A/bQuipQCQwnY9JC0HFaZ8?=
 =?us-ascii?Q?mX5bWOcrcH+ExiVrQyJU8kOwLbKfA8m2JWtdu/Nktho1+O3EZ3VtlKrKP0id?=
 =?us-ascii?Q?aKtavi2niDrdGNwPiWbY32n3iP30kz0kRuHqxJDJ/dvgw+qxujfF5hvViqUV?=
 =?us-ascii?Q?uFL0DcCHV5/EMppeqBXMbcwWYR5wg/i09GTWYklT21q0eqWRHxyphsGrxevD?=
 =?us-ascii?Q?v2xCmidswp+hHfH+YX7D1zRVAfMBmXcBllR2FBJTz6wiWm4KaMgYBT8P0mMv?=
 =?us-ascii?Q?2TOfbGRdkzHaaNrYwOvRtW/cxyBI9tpR7J87swnmND6oJscnXHoN3mDCWadG?=
 =?us-ascii?Q?5SMURRYc2hMsEM2vguQj7IYq8KxdR4vX2HMkUPwBWnISr/tIfdPIbLw+Mgh4?=
 =?us-ascii?Q?uCPVKBGVIYtJtUnimjdvJJaylRPBFwzqB8sYPSB4Ag3FIEvECE0RBN/0UFu0?=
 =?us-ascii?Q?8COmPcUkNi/he5xlkextSWND5RTOWGSHL//7MIbWDtUMPLqhYwO53stfpzcE?=
 =?us-ascii?Q?CJFLBn/PmBJ9d2x4mIEzWXmAmoM8/c9QO6Leegqd/oTIEvip+kjEgfRVzWPl?=
 =?us-ascii?Q?qMrhBrbaOMZz8NktxYL+nXES6kZQM+yOHi80UtxRbdKA9o9yCCn93++6vhKM?=
 =?us-ascii?Q?LAs+zDkUxl7T4nrkxrCib/SNyOiBVDOWs47MnAX836dO1i9bICvUw6lFC+Uj?=
 =?us-ascii?Q?xzLtStp6UzE8V3e5WIBypcPOz7T4MgnK9Yh7cYdP/YpoT83chmrTDKKl+2Sm?=
 =?us-ascii?Q?a4UkHfg0moOoDIbW3tn/iuGdbtCCuJbGq+bKIjsNxVenUBvYEl+q2KDDBYBl?=
 =?us-ascii?Q?1DdvewUo04bM4nD9OxuPp6u5snhIbTtqtudcMNMlwjdY3Dwnrm6dgHrJQOX2?=
 =?us-ascii?Q?3YK6RVEeXioEBkQULzqYTkPilY4eIpnpfaJmK1moZDYUvCzuFEtOsZzpLdAY?=
 =?us-ascii?Q?/LZX2wReEWB5UULt4kc1aLKcmC1t9TBG+mB0xDi/Z8ISoNXtNSwVH4k4A4lu?=
 =?us-ascii?Q?4OXEKGGd2nNVZ89lXGg5ysF0nt0wLX1UTJ3FqPPv5lKPOxJURfJI?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1EB8AF69DD47C74381B20341D43D1EAE@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7b48eb-e84e-488d-7bd2-08da41fc0752
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2022 05:19:53.6287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RlAzn4G7yq6bW6wR/UCNfk9xoBHpfEZUGAe2Q/vtwfH+C6C8LitFOka2ARHb0fmV4ORitGql3iLHxfmzbI4DjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4108
X-Proofpoint-GUID: cKFkQRDjqyuI5-ex_Zp3k7vJjWW8yAg0
X-Proofpoint-ORIG-GUID: cKFkQRDjqyuI5-ex_Zp3k7vJjWW8yAg0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_01,2022-05-27_01,2022-02-23_01
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 27, 2022, at 8:55 AM, Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
> 
> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> There is a small chance that get_kretprobe(ri) returns NULL in
> kretprobe_dispatcher() when another CPU unregisters the kretprobe
> right after __kretprobe_trampoline_handler().
> 
> To avoid this issue, kretprobe_dispatcher() checks the get_kretprobe()
> return value again. And if it is NULL, it returns soon because that
> kretprobe is under unregistering process.
> 
> This issue has been introduced when the kretprobe is decoupled
> from the struct kretprobe_instance by commit d741bf41d7c7
> ("kprobes: Remove kretprobe hash"). Before that commit, the
> struct kretprob_instance::rp directly points the kretprobe
> and it is never be NULL.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
> Cc: stable@vger.kernel.org
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Acked-by: Song Liu <song@kernel.org>

[...]
