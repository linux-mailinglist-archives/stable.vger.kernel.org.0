Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8E75953DC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiHPHec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiHPHeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:34:11 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F53B1146E
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 21:12:59 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27G404TX009228;
        Tue, 16 Aug 2022 04:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=PPS06212021;
 bh=4Ldt4sTQw4pd2FZRNQ4+qepcv5nUQpIxx95DYw5I68o=;
 b=qIK72dJNazoEi3WUSf/H83xpCBN2XCxY9lgEoO+Dcyx8typOOdLWgDfDauRvlDgPdR49
 Z1fqG3HshI/9d931oVoM818X4NGYtsTlpf6rC4dPEWi+Fi5wR0oawiS00Cc8cSZFwjHQ
 ouyG0NjE4LuGHYdCfWw1TbUqBkpiWAED82LD/6/zQJHOlnFaXe/fIj1+sh7RKkcE8/Ee
 zrajNqhD704VZk09IC3iUtCCzC8dTqf6bDfiF/eM4lre+i5lU97DCcTWS/v1YZUnDkV7
 /Fr1ogsTq4Vo5v9k4yB/38wO4o2PT7mOAeJTCtFrk0zIyjTt0ZynoyToLdiFWCnEYtFF 8g== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hx160t9rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 04:12:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajea4ng7Wf4+RDZivaTyrxqxKqcb2siZ09AdLro46ZMpwf4DNFU8A9ej6VdwNIhzO7qngLuNuebV9B276dmjO5YNBZ8g0Po56DqmWSXaXrRAGw/DU9rmNNRA7tA5ZHh1XQK9UqyN292GEcZAkY5BRA00L3sqnwWwW3aJGpgH9o0uPhAbpGTfvOM6psCloBBAtK3ktMBxHVH+Pd7sla3eyD/8uvUmzfYFxNsNq1plArIs/8FB/pAfi3LnOD01jxuG3WxKbNhjj6YtIcVy84Lf+dgAOmdjs5a+FXoAhhueLRHhRilTMv0+z7k+rBt/ytZPO15i0ibVQgRTYlPc8IYuEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ldt4sTQw4pd2FZRNQ4+qepcv5nUQpIxx95DYw5I68o=;
 b=e6s9jiWyAx5bkJDsfsznqpXHWc2jSX25IatkdrH3m3/wJrR4raSOcEz/5884SFCxtN0wNci8YcN5Llg3GXMWypfwzNBAyhQs3ntAZb0tFlUOx1+RUHTRjOAtLsSHUxNib3KtQP/jcm3UG9yJ/04rmXzvhKxsWjyTcFY25E+0562OzWEenccm4E6RLRnJJ2RBDr5q0UENDydYiCBBU3uNmYbvU/NxA0ik6esM2PKlVdtsxLs6DypQFGNmW4JPe6BP9S6BHEN8pIh4bA57SRU3IUEqDle432NQFhwKBETVjm4D5pUFRg3ij3uNNxEbrTKHixIc2zJvj8T+IkRevK0xAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CY4PR1101MB2069.namprd11.prod.outlook.com (2603:10b6:910:17::7)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Tue, 16 Aug
 2022 04:12:28 +0000
Received: from CY4PR1101MB2069.namprd11.prod.outlook.com
 ([fe80::9898:dadb:f62b:efb8]) by CY4PR1101MB2069.namprd11.prod.outlook.com
 ([fe80::9898:dadb:f62b:efb8%11]) with mapi id 15.20.5504.025; Tue, 16 Aug
 2022 04:12:27 +0000
Date:   Tue, 16 Aug 2022 00:12:24 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: v5.15.57 regression - boot panic after retbleed backports with
 CONFIG_KPROBES_SANITY_TEST=y
Message-ID: <20220816041224.GE73154@windriver.com>
References: <20220805200438.GC42579@windriver.com>
 <Yu2H/Rdg/U4bHWaY@quatroqueijos>
 <20220806001100.GD42579@windriver.com>
 <YvEULC3tjmzgan7J@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvEULC3tjmzgan7J@kroah.com>
X-ClientProxiedBy: YQBPR0101CA0052.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::29) To CY4PR1101MB2069.namprd11.prod.outlook.com
 (2603:10b6:910:17::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4cc81c7-6b8e-4cb3-6906-08da7f3d87e1
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xR9L609/4vN/NCeQlxgoRS/Ypov6CymtnCMrkMwtBbNL3/pL6Qo64bp8bUOPXFvy1BWjOlEWNJryAsG38D03+i9OoDiL5rfmxrblvpmojOdw+5JP8fNiSINYWhHm36g6xKOInZbhdE8lWJP0m3bL50i44HU4QzHVhIIan/U3dO6fbuT0D6aEURxd7VmuqNHu8JzBFB/KVRkUW15I5/7avuL4JgKQ+++uPfQJqxEusCpvuvhB38OwNgd17crnEBfGar+A54RHvcgECWuYNZcaaVwpsH5ohEd1dSb5BoCqcdwqgdpilZIaDeG8sr0kyUEwIaOUETVCRY5jA0IDXcRzcRgNxd9bdjWp8ckds8hNGkTkPBZe9SG3UvcUsgYJRR8zMCEJfAsvhbNhcSnb0s4D8wYTG1AigVHyzzWzKL0LzWJGfIH7jaHHQpiUOXzc52ZUNwCSCozxh2IwQP1pOa6I757TDqhQUMZZSMh0NtU6MoplzblzGGoY9apCOqjwquUfOPNYz/yL7o/7oUrpsrGzV56zBgACSR8TNXmC0futpc1yYqvFH2Q+PUOKUBME8NX7gMoqUhwhHQ8KGLL0ubqm7aroMR6/7yFV2QY8PhN+/8iFcC0X/tcQR4IfEtYQpVK0s0t3/WnQuIoTvHCzlFvmGxVgr4vDcbq3hEW8AbeubLj5qyYjJ1ImKx9/U5ENTP88M9peSsl+ozSrTl2iq88Az97ngbFMG3KzpASNIdrz7xV6O2zAtVt0fmQsJncWtNkC/xL5IWo/9cZr92v5HPv1nET/Po1BjWOfxKX8u/oemSg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2069.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39850400004)(396003)(376002)(346002)(366004)(136003)(6916009)(66556008)(5660300002)(1076003)(38350700002)(38100700002)(8676002)(4326008)(66476007)(66946007)(83380400001)(36756003)(8936002)(2616005)(186003)(6486002)(6666004)(478600001)(52116002)(26005)(6512007)(6506007)(86362001)(41300700001)(33656002)(54906003)(2906002)(316002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XjwbMSCvfwko+GKGZo41wKGdfAKtGZvOvrH1eKEBPx1/X3s3lBdymivw/imp?=
 =?us-ascii?Q?A6MlHnYWCwu6sN3Bqb3YD74cVC8liECPIX1v4+Zjb7B8jacJgATc+BGNDO3d?=
 =?us-ascii?Q?P4e9oRAbLnJ3BlfAZWEsEHEaVrECBcQXDAKdh/bHIp+4YUrKQxIbEz9xZz00?=
 =?us-ascii?Q?IYSW4rAO/Z1x7a/MwGPtKs+7lRS6fBFoELbN/tlcngNfNosbKhQiJvh7UxJ/?=
 =?us-ascii?Q?u/cUJneOEMy1YDnpcYPVvscSLn2yr2beTq1CQEXv4I8Q//oCrzTKNAbMH4ff?=
 =?us-ascii?Q?abeJCKWc9aZvAWW3Eh1L5jl4V0NB+vQKQ2Ykj/xehp9mIgHoQv4l/XNFWLEC?=
 =?us-ascii?Q?OGxRqJA2apyFUo8cpCqa6aFqnGHo+AYMB87ao35TeFoICKs7NOKRbqssP0hd?=
 =?us-ascii?Q?SW07wR3pz8t396D0AZZisg2fkF6O+UgiKQZw1DYyWCUjxaL/JbaQQgHQilqa?=
 =?us-ascii?Q?c7YXES6UHTDXzdcCRfqryLoURxGgzAY3RXYC5nes7z0imZDDsQdQLX8zxeoq?=
 =?us-ascii?Q?7ZOyYzpIIUXRfXTxLVUAApiQK199A0zM8x90CkwmC5UVhCnYN9JGUIdWzGzJ?=
 =?us-ascii?Q?ZN1qc+tSsku97v+omvP32pOj5xchrEXbVBZURICYY1w08eSUrQxaeZTTcIGj?=
 =?us-ascii?Q?hnuqQaWmukyv4snh2gz7zY00jDcg+hWebnG2IwEUaqXy2myellCgreQGQ+Z+?=
 =?us-ascii?Q?73zSmrGr9+Be9fzTiHMWvGPmeysGD+sDvPS0AztyfLlViY0PYxk6YtsosXrJ?=
 =?us-ascii?Q?mIPar9UPJLurf2UvciHFUJO9dGzli8wO0WosJLvFgvkiEDTt32GOvrTlJaN1?=
 =?us-ascii?Q?yZuXdyjtgYMAlZS1uaDwXrTDk5uFwfbVaKuymM2LQmEXt9nDAgr9C55mQxKn?=
 =?us-ascii?Q?PuP6ebJt20RiEI+MX4/IZK7GWnNOTJhbezyJuXiR+qnHlMmukID2ibudpime?=
 =?us-ascii?Q?JtMAygH9ypeRo2jxwnbVZSlYN9pzt2AoIRHnIcpjyLAH0MMsMlEkO6yDEnsC?=
 =?us-ascii?Q?hNfgL1IgybW8jDJwgD62V+thgyB5Q1nMrcc462K/qetWVnm3aLogxkWXAx+Z?=
 =?us-ascii?Q?TGZ8vaBH8Wsmtgj1UROKLAPjpCATjHiKimlYRCGNRWqe6bNOSbwgVkr0rm/w?=
 =?us-ascii?Q?/nG6+YOe4zTiBo7S/kgtDJIjpuxaByVIG0hlXpzz42E6z5s/41TrwsZwu3lZ?=
 =?us-ascii?Q?aMidj9GfG8BMZOzuyzJUTr2G1+b8pTpVt87Rzr2X7kus+xzMSelRl9Cyak4F?=
 =?us-ascii?Q?hC1QPSKzZT+HrCsCTICP5vgTHXyH8uzQIXUK2gvs/H4G2bINkvYOHi5KrExu?=
 =?us-ascii?Q?PvrfSw8IFyiexFARNMAD1g1uGTl8C3zsvkpRL8Q8x8pkrovlbhQ4cZkEzrlk?=
 =?us-ascii?Q?k6YytaqJA+SAS2ecPchBKlz+7/J3lm+yk3kJVrCzz/p3bOv9V92Y9CYWxSVr?=
 =?us-ascii?Q?c1XntT0+k7w26h6S8vZemF6Qt9g7wrni7SU4W9Ash8mG7QBUKJ04XctMbv7Z?=
 =?us-ascii?Q?/MK9cTT4/CoJj8BPTuYXlQsJYkaTQccISvSD3D53yplOQhyHPNUn46KoGVwS?=
 =?us-ascii?Q?sB2bBMFHqPyYdqEi/YG2Qqb1jF4N47hwRwuLxdJOZx4zxR6sI7Ml/KuIeQ/L?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4cc81c7-6b8e-4cb3-6906-08da7f3d87e1
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2069.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 04:12:27.7963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6n3wJAWFud49oc1vKtSdYtcB/Tb3c58y1b/Ti9Dp4fx1LJIWszch+ZIyEJ3+DXmWdLWbzZCGRe5ARrrITV4KJrtiyht+yjxuny7haiBN9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
X-Proofpoint-ORIG-GUID: gsJycfb6LaLOb3DrAcw0TANe3a2sHis3
X-Proofpoint-GUID: gsJycfb6LaLOb3DrAcw0TANe3a2sHis3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_02,2022-08-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=806 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160016
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Re: v5.15.57 regression - boot panic after retbleed backports with CONFIG_KPROBES_SANITY_TEST=y] On 08/08/2022 (Mon 15:48) Greg Kroah-Hartman wrote:

> On Fri, Aug 05, 2022 at 08:11:00PM -0400, Paul Gortmaker wrote:
> > [Re: v5.15.57 regression - boot panic after retbleed backports with CONFIG_KPROBES_SANITY_TEST=y] On 05/08/2022 (Fri 18:13) Thadeu Lima de Souza Cascardo wrote:

[...]

> > > Can you try the patch below?
> > 
> > [    2.529263] rcu: Hierarchical SRCU implementation.
> > [    2.530393] Kprobe smoke test: started
> > [    2.555965] Kprobe smoke test: passed successfully
> > [    2.556454] smp: Bringing up secondary CPUs ...
> > 
> > As per above, the same spot in the kprobe test seems to manage to not
> > panic anymore and the remainder of the boot looks clean and normal.
> > 
> > I tested directly on vanilla v5.15.57.
> > 
> > Thanks for the quick response!
> 
> Great, can someone send a "real" patch for this then?

Cascardo,

Was this a final patch or just a "can you test this so we can better
understand the regression"  intermediate step?  I don't think anyone
wants to guess at that or at what you wanted to put in the commit log.

It would be nice to close this out vs. leaving it hanging out there.

Thanks,
Paul.
--

> 
> thanks,
> 
> greg k-h
