Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1DF595DA7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 15:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiHPNse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiHPNsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 09:48:31 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1FD7FE4E
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 06:48:28 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GCGpWS009157;
        Tue, 16 Aug 2022 06:48:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=PPS06212021;
 bh=leMAJ7tqM8rGF51YOtzROixQtaLjQasjpd1V/FXmYIo=;
 b=M+Kk/iBk6QvUIGXO7wNw13TY1HhePT7t0hqEOP3hNfrao3FHHB0ej5DLVL+XAIir05ic
 K88jcg2qJU2Ww5aI8qstgl6SiI4u+MReFUPDSLO1rH8CE4qLunLzf/IZuhjkcAv7P5go
 MtfuYwUI6uvTRN9Or+hXMQ5bsKE31wmleXdAAY5RgNCbB1gRS8fJ527N0V0FsAp9gT91
 kQJTjfouL7TovNe96CiTivMQl+XFeeWlXVxE+h/QjkPGk0iSYjnX3QoY9X+vJA1dE4Ak
 GuPhjbVCR03Pe1s9XtCoWa5HUJbPJPqu0SnWC5m/C13bqXqaFCLLRICOWIAqat9umRYF 1A== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hx783afc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 06:48:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSiCUN1Ba/iTBfypfscuqPr3SabGkvVDJa3ZLycpnqKhoqXsDb6dyFV7mcrmtg42Vs2464b0uInj/zDLMuq+DxRN1HS153KYfd+WsdUDoYBpRgDeXgxlj1Ruezz4+7qtgSFGRFWNLwLS+5x0KQrKjSXS02jkIvgHxukGy99wKJi7dRaytjbhycuPIoHCqSJzG3lZu685LWNwqEDjbc9C4ysZnkkqdYeevrt2TqoxAXrYivHvXAn8HwIJRolgVQWRVypBuFPbHjBwR9Q3ojwIekvYtYSBFu4krrotB6N3Fj+M22AnFmW799+SPHD6Bwno+Gu+ncMp11GKfSNCKn9zMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leMAJ7tqM8rGF51YOtzROixQtaLjQasjpd1V/FXmYIo=;
 b=eCoi0QBCp037tLbsi2ZKE+MDrd7RA1BtH3xVeUWeWhAP/ekuKrGywJzg7LI3/zAbYutdf++cOBE+wN1ZG7xVnzcKssUv29nx3Sl0TpyyByerbT3s3QH54G348CoEBBjz+8hWPWjRjk1sqFqTGAMlo9k7gjLooAbdcyimw0QCY+feCkwG5s5dM33bMqcaB8fsYlbOJ4zew53sElEMAm3N9nh6FnEDQWM8f/BUjpt88XETfQn0+ahm3UfnYaUJjzmc8Yo9Wtw+LO/I9dnCRZm1KTvW2LTYdIP/7bhrd841nOkag/sCXUSpmQxf1hyMquMcbRgMBlvPMF3j/TsnFyGxXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CY4PR1101MB2069.namprd11.prod.outlook.com (2603:10b6:910:17::7)
 by MN2PR11MB4432.namprd11.prod.outlook.com (2603:10b6:208:193::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 13:48:00 +0000
Received: from CY4PR1101MB2069.namprd11.prod.outlook.com
 ([fe80::9898:dadb:f62b:efb8]) by CY4PR1101MB2069.namprd11.prod.outlook.com
 ([fe80::9898:dadb:f62b:efb8%11]) with mapi id 15.20.5504.025; Tue, 16 Aug
 2022 13:48:00 +0000
Date:   Tue, 16 Aug 2022 09:47:57 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: v5.15.57 regression - boot panic after retbleed backports with
 CONFIG_KPROBES_SANITY_TEST=y
Message-ID: <20220816134757.GF73154@windriver.com>
References: <20220805200438.GC42579@windriver.com>
 <Yu2H/Rdg/U4bHWaY@quatroqueijos>
 <20220806001100.GD42579@windriver.com>
 <YvEULC3tjmzgan7J@kroah.com>
 <20220816041224.GE73154@windriver.com>
 <YvtHVORl4FqwEM9y@quatroqueijos>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvtHVORl4FqwEM9y@quatroqueijos>
X-ClientProxiedBy: YQBPR0101CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::38) To CY4PR1101MB2069.namprd11.prod.outlook.com
 (2603:10b6:910:17::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c507dd3-58fc-4c04-9051-08da7f8def0b
X-MS-TrafficTypeDiagnostic: MN2PR11MB4432:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raWZ76Q1hSeOOLxN/zSCqgeXk0GAYQimOfRNIWf6ldaAtG2Pkf36ejf+Op9EpsR4EDhfuLxX4Cbxe7i0JTFd4rkZmy9ymZpi2g0fyLwj/KF705VqTZGtBsc9M6x+99X7is7nd0x2FbdGE4nv4CBRhQRL9054P7Ib+RibCNK7x1c6VD5LbVg067qM7fm6ok4tebsatybrVWH0q/NYaJt7PEHusQp9yQ/FdYzP1cwixjVRX7IjjNNrWus//JVXtWbOV9mAGtKTjnWA/J5XdVPo1k+Ex+KPaRLaiucLLDhnp3GWPgGSK6B5RcNUUReCk26sPZK35SHDtJ4kvpR4WhBCXfYzl+AQSCg+lw8O12yUHsWKE4MqGdcSnScjCP6PbC4VT6oWjn1NJscY0BdJRnxF9GKPhlRJ4+ag4CVm8Gurw4SqhTjEJq5bZjNBwgRu71YPk/7C86ilnXdJ0vpVnigTx0whdnAwtPHmjS7FBQhRzlhHhq5mPdBaut87p33h8lBylKr11M1bxLRktBLES3h3N1+bN7NOeDUOvHq0qo5M9RrJA0KJSVc5KxwIbseLtmbHnDSUkVVTUQ/jeC4ZJ/KIpv6YjTYZLSarMKDuiJj89IYp9vD+vhRaIWqnyuXTcdEiZxNOF8S4OtLa9hutZvolMyKbsXqGMuArSq4JWiY3KVsvuj4hrQms62GExC7lHxYp8j7oZ4s0mTLwPcKo0nR06K1PnAHfUqxp5uL71cWTGoxiPVMeSx5E1tHMheyDwT1eojwPy2palLPIq4YScODfEeBm1OZwlSCJHMnSXoZ1Y4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2069.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39850400004)(396003)(366004)(346002)(136003)(8676002)(6916009)(4326008)(54906003)(66476007)(478600001)(6486002)(66556008)(6666004)(52116002)(1076003)(41300700001)(44832011)(2616005)(36756003)(26005)(186003)(6506007)(6512007)(33656002)(2906002)(8936002)(66946007)(86362001)(5660300002)(83380400001)(38100700002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nljSart0kkbbInpUj/+qCwwx55z1aQkThGqnhqoZf4kV6i81ROxKDmHFqQey?=
 =?us-ascii?Q?tmVcWTlHuMH1fQrdmAlehhXEDwE1/0QaoKJudLkKIsvGuYTVjHrY5UyrAkLr?=
 =?us-ascii?Q?C1XZbXxBqez0BKxifUCeKWaPWCuYdqEddNfKAOx3dr+WT4D3gOtTbH9kkcpo?=
 =?us-ascii?Q?Qplx9EDqNVKBclq8qzf8vJxY7Ve07275rsFZdcrD+VPuQqnry6Fh9p5ndquw?=
 =?us-ascii?Q?CVj57UAcKVL8XRjKB5fSYDck/LjYK5Tk8sl0vJR6p2Ta21yJqnEbgt06RWfm?=
 =?us-ascii?Q?lbglHOe2Uwpk21a7tOoObTR1ipY2eK11wqsOm4hTcWffLcwTD7OkRB+65Xic?=
 =?us-ascii?Q?p6NaM7O53NaWC0BqBGzxjBjdSSANIl+In1JzgWYJ6fQzc2V4xE+X3iQrBoma?=
 =?us-ascii?Q?xtZFmyr/jH+3uHhCXaM1pFyZyiEkAx/hdz/hwTCKouYi0DplxHGm/89cM6pb?=
 =?us-ascii?Q?n55eyXUYL9A8ebz9fdTgi0b6EFxe63u8cZ75U1Wiq/+rgQ+bl5KK5kXMLlH5?=
 =?us-ascii?Q?4ibYChrLHBgf6LRIq9JqihNStKInxxpYGvZSKueVuNS282J4wXdoIS/4+fo3?=
 =?us-ascii?Q?rtqPTm3EJomCaBYxKyTrfa5b7A12qNnwzjsJdYEI8YYrVrqcP6todpcwaQ2Y?=
 =?us-ascii?Q?oX0Qhj9OluvGaMskU22qlkh1EODQXELv5NTreXCNjXbbzu/LqvnJkQzxtJ7Y?=
 =?us-ascii?Q?fmPPm2TA9KOEI3GJmFVxa+OtT3l9na5U8kk/5XwmnrKgH354L088lGMSoeQ/?=
 =?us-ascii?Q?RA8tLa6lACSE+ZUlccsNzkdSUfnE2sCTDoMZWX4RuvXz8uPTqlN0ZkxwihhF?=
 =?us-ascii?Q?W2R3jEwVtjPYx+RQSD6Af2B+Shg6s/pi/oqBoSxUFUDrjrnN7fCONDuz0PxX?=
 =?us-ascii?Q?BArwIv1g9AxBhsXMEXdthGDqFGcECuH7eJDpQBazo7ZT1k5sS4Ci4rTc73AU?=
 =?us-ascii?Q?U2pOlELQ7JzSsfDFRnCk+CYfjN8DhWDDnk37in9w0nBKOBZKwsYkoJBllrqW?=
 =?us-ascii?Q?NAk0oyu4A7aDmRGoaxysi9PY0xH9NkKolEZg1S8KfCkmrRvCm9W4O2Zh5BlI?=
 =?us-ascii?Q?qSFvXDvpTHk1fzDk3z7taTK5PYlEs+UL4Pao57Eds72hU8b9MrRNRGq31SAr?=
 =?us-ascii?Q?HahI6ZTmaqawAYX2PdqrdwertPPp2rUz7aZWuLqIySpSv2cG+F9sTy0OvJ6q?=
 =?us-ascii?Q?Nv/sjbKZTXPZn7tiEsFqFuozBehwwgcU0tRX1qEOB1MCTO+5WtzHPnrKorNT?=
 =?us-ascii?Q?7p6w5PQSHf4Q6bIcCxaXdITIiK/isnUyiy7Ktg595AJmfgxRrq/tKfHtUZdg?=
 =?us-ascii?Q?L9Wcgv7unzMkHuK5oze/MSZzFXo1ULVq9wXEEqKSTVNl9GE8zCqBb2hkxfx5?=
 =?us-ascii?Q?obXoQDFThh/bgOT00IqFHYatdOU95npk+h8AtAqtP3kdWiQLiwuTN0F9FS5X?=
 =?us-ascii?Q?xW1/ZuwhlNQkC5elMnzsIpF+g77k6vRnhyxq6nQcnIkRbyh5JyfkjqkK8E4L?=
 =?us-ascii?Q?rntm1LFcquT31iZvacu8rjBZgDtgB3tHATbvdH9S6fmBhJwP3LjJOKgxB/16?=
 =?us-ascii?Q?v0Lgva0lqc4zxF6LKfeIa8kZcpPqB/OV+mw2oOuFuW5Kn/2nL65940pb+nD5?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c507dd3-58fc-4c04-9051-08da7f8def0b
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2069.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:48:00.6631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a3KtX6VTom/v0QVfM8J2Fx1zk+fmvAoXa3WanfpgeIJ6f3bGUgzNqsRR2p9bE2A6joRX9JZGHSAMhjoEA7e3u4QFC3/rWGkW62lPgUm6Az0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4432
X-Proofpoint-ORIG-GUID: R9T1u6Jsm8lWj6YhdXb7Xz3axM5KWAUS
X-Proofpoint-GUID: R9T1u6Jsm8lWj6YhdXb7Xz3axM5KWAUS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=884 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160052
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Re: v5.15.57 regression - boot panic after retbleed backports with CONFIG_KPROBES_SANITY_TEST=y] On 16/08/2022 (Tue 04:29) Thadeu Lima de Souza Cascardo wrote:

> On Tue, Aug 16, 2022 at 12:12:24AM -0400, Paul Gortmaker wrote:

> > Cascardo,
> > 
> > Was this a final patch or just a "can you test this so we can better
> > understand the regression"  intermediate step?  I don't think anyone
> > wants to guess at that or at what you wanted to put in the commit log.
> > 
> > It would be nice to close this out vs. leaving it hanging out there.
> > 
> > Thanks,
> > Paul.
> > --
> 
> Not a final thing, I was catching up on other stuff before I could go back to
> it, was planning on doing it this week. Just need to sort out the order of some
> commits here to get to that end result.

Great - I didn't want to nag, but some new ftrace/kprobe regressions
were reported on a Yocto variant of v5.15 and I immediately thought of
this being the underlying cause and the breakage being more than just
the CONFIG_KPROBES_SANITY_TEST corner case I originally reported.

The good news is that I've tested with your new three pack and that
fixes both new issues.  I'll loop back and re-check the original issue
as well for completeness, but if you don't hear from me again, you can
assume that went well too.  So, if Greg wants to, feel free to add: 

Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Thanks again for fixing this.  Much appreciated.
Paul.
--

> 
> Cascardo.
> 
> > 
> > > 
> > > thanks,
> > > 
> > > greg k-h
