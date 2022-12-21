Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F02F6539F0
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 00:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiLUXyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 18:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiLUXyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 18:54:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4231AF08;
        Wed, 21 Dec 2022 15:54:37 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BLMiwYk029888;
        Wed, 21 Dec 2022 23:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=cfbX9QF/6aAGTqfY/VDa1LtiWp3IAO0V8lOHVJaTq6k=;
 b=LbtbVmI/WzAn71Oh3cJRV8hX+cYm0JH85dfs2SDUj24Jtk8j/Wl0IpOT0OHIQ721OHZx
 Lg7ZDeLm682q1WPsRgdZxqILm1C8VgyezdfkQ5repd6r9rJ/EgVq5oNCQgvo3YRKjiac
 YqKOFgMazj9dg+oeNmyhUajdjENpYa9Q/VWHDvvU/g8gGiWJCJU31TbAy5wIdN40yfQC
 oi2m/UEl8qW6MK4S0l1cWl6IfXxXjAdobfJzjFwTR7eoHpS3A5Gsq+MzUuCekmX30Hr2
 RmxJ3V0TqriT1t7F2nLEw4L07qeztCwvtcLmllgcRuaNjYzxUYxj+/FX5u6gLOonff0l rw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tt2848-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 23:54:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BLN5DSN003413;
        Wed, 21 Dec 2022 23:54:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4779ut1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 23:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XROoPomI1glHYeQ/HcqbLJauMrP/+63bipsC95YSaNB/XqVEL5MkuuQ277qJI6FzsenVRjCtf5cQ68bk8OF1zendWwJFdClufMtji7ODOS7jsHBkKfpWMnaMy9SOuMiFIu7HYZRxcRrk0dcXZJLTyCoc4mRkzFqUjvkbA4ymojkvVMTlZmKPC1yjypWnxyIan39KAHW3tEZ9NpasT5JW68LI/vM4cYpg4TFuVG4EhwmOY6hRETni8ycFkLUvlVjp5Mgw+rf0aXbYy0RRbbjN/fcWjdPKoCsJhC1gQKRE0DE2rEieIYfmW1KPMZCY6Ep3p110BwyjAX4GT5I6y6a3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfbX9QF/6aAGTqfY/VDa1LtiWp3IAO0V8lOHVJaTq6k=;
 b=nwQ+v3biwc4OHYK4sgAJe0UWej6Zxn/PpF6tLk9CC8A3V+79DUXFwvUKOX68P1yDvkvl8c9Dqb1FYX5YUzC8U4IwRcbzCIvGQGLWtjXQPfbATBK8HXw/BoAUSzZadwMrt+7NZdfbVNnuj9lqlJ5XEvhegh5vVbMqg1AFI2pWDBdmp17STSafD7/6FjB9WVQua8KbVnP5cO8cOofiLiSi21celPeAO+SAv57FhaRTIFycmyxu4sglpefqGPQ6D/AYBxGaMFFQ39xYAqIlzAUgbkb0w6KAynjhuQJSwJUj+AVW1AgHvexfziIOJGRH43NhDa0F9CU0usnP2yu3XJ8smQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfbX9QF/6aAGTqfY/VDa1LtiWp3IAO0V8lOHVJaTq6k=;
 b=bQyvUvoyNJlaJwcvaHKsPvrvsERT2mPi0560eq+XkQDRczhvQXaLBXCNKJfKHw+m9fel/V+3NUNASmP8zDjwKTAYm8m9I/qviZYkJA85NYE0b114t2jd+UTxh8YB7TTQ3HysD1J7nIM7LICd8VdiAbLe4qHIlDJpbwzieXYHnPo=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 23:54:19 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 23:54:19 +0000
Date:   Wed, 21 Dec 2022 17:54:13 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Fangrui Song <maskray@google.com>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20221221235413.xaisboqmr7dkqwn6@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <CAKwvOdnu6KAgFrwmcn9qhjd+WDyW0ZTSyOzOnSsWhQ1rj0Y-6A@mail.gmail.com>
 <20221221204240.fa3ufl3twepj7357@oracle.com>
 <CAKwvOdkdPNqPQUOqBLqW7m7i-WB0fJLSSpYTPFXnaitBNatoMw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkdPNqPQUOqBLqW7m7i-WB0fJLSSpYTPFXnaitBNatoMw@mail.gmail.com>
X-ClientProxiedBy: MN2PR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:208:23e::22) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB5834:EE_
X-MS-Office365-Filtering-Correlation-Id: d19c8c35-702f-4a67-f53d-08dae3aeacc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EZSClt9/A0hJ7BwAQRqP65GDp7lKt+wDH21k+tD0wpLD51uv+qssWxSlZYMCP1VlAL7ptNRRfyqx8di17JiokpijXzMw6heT0uQ4ZRXOIB/spY83y4p3cfOFRFi4a6coejG+E/N/lhUcrtoATMdmuy8LCM77RrbiDHZ4r8VcOD3yCkOoLs+c7Y9UHrKTEjpL0JeBSgk3WIcOcXGH6lpQm4+FMwetUs5TlOJ+ZbMFlo57hNiyBtkECFRJf+HBBA/E2vK3Qq62o0mryhKw1n1Sa9A7El1znfoOFCylQc4xl8dHkGMpA4PUHqljxV7dWpaC8KllMLzoWTeUwpqswHTUOGPo4IKY8u/df7d3+1mGqigsCcyGALSxp2cG2e71lELiFbpeP2oVPpOUSggQpv6waWU77gJSWNRXoxji8kq82vPSzhps4MOsOmzCR7+uYJ+r1xWVrIqj0RPLMh3+s0Rtmd9Pd3YKEUGb4n0uUojAOHB1P1Ow847e3FDYBNtC8O8KWmCLNuR4iM/fDZ9D20+6rBsh3EHOg90f/B5FWAB/upEi6Oit7g38CAPO61lHfQ3WZ5j+Zhz+ytIxvLXKWrEtqyGAds/maH3tNr8ikzVhCYlUEEhOeB3A6Hr5kUL4UtNLtleVoO9OIZ31E+1q9QKPrHb/PzP+IjXgA3vrTFfMmvmZGAsNv8UJaTUG5lwmIt8D5n6RZt06G+yTc+CqrjrnKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(6666004)(478600001)(36756003)(6486002)(966005)(41300700001)(54906003)(6506007)(66476007)(66946007)(186003)(26005)(6512007)(66556008)(86362001)(316002)(2616005)(6916009)(8676002)(4326008)(1076003)(2906002)(7416002)(8936002)(53546011)(38100700002)(5660300002)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pqwYUgNn5FTQUEeVGxSVfKRZrbioQ10saDpFyGvWLlWLtDhonD6E+Cs8mhOG?=
 =?us-ascii?Q?STCPmRjqfRPonTxYylEzggI30AN+JGtFMD/MGYCU5u1GX4d5f68L5f1Yh0+1?=
 =?us-ascii?Q?M/Jdq1QO2OVmEKOmOORyN9fEIfevXdT98GmNkqXHx4TqlY93/6yWXK6mmPU0?=
 =?us-ascii?Q?LVMmeC2vgVSgYfgIXsFYFptef/i/oBLgX2QKWST3Wi1jPLFCLNsQTRNyzrE4?=
 =?us-ascii?Q?BX4W8TGMJUzrv6iCPhpFKwl0kIFQ1cswgUYTV2imrk0QjbI5PwA1lwS2eJGd?=
 =?us-ascii?Q?k+4ZLaaWTxwh3u9G6Ea4IogIregPLEJDBCu7G+urij4uCE98XgSILTlB5KZb?=
 =?us-ascii?Q?jfmBX9UZ5Ws67WCBvKfsu9o6ufqe8xSpG4W8aVBRbhDL0QerjnIn3pq/DNd0?=
 =?us-ascii?Q?cSSWsxevaFykyCX/cW7JbuGkCtmysKCiz5ETxzbdbqCH9pMzKRZpEYhCHP4d?=
 =?us-ascii?Q?KoNFR+B2SCRiV3xTmNNNC7lYzGoQ+SjFu8ZQ0FwxAsgadvCeVgUmdDWpp/Ft?=
 =?us-ascii?Q?iSQBAzy6ZatnwQJrAKWvEPWsZPoq/FJiI20SqF3U+c0hFDycoe6iNpzx/mf0?=
 =?us-ascii?Q?VePbyV6uIdhH/LF2EMsmCGqEG4jOkmXBnsWbxROKCzb3X+dpNwnr/MHVhyCi?=
 =?us-ascii?Q?bX92Bjz0LHsVjRdo4FCB6OLWUbDYFZUGYNxcfI1I0SKnRRYFhn0LaPb7nZ1d?=
 =?us-ascii?Q?idkSII1KR2FiBESEJp6A8cQl1lz9HI9efnGK9ZGT5bALqjtPS63khnNMiUhV?=
 =?us-ascii?Q?OVQLNj4TiTY4OryC2WUNSVSkfZusptXu7sf02IocZ3hhIhT49Sc0OXSsvFVC?=
 =?us-ascii?Q?2p2NOAw+Y8HFyJ6XTrXdiVyIsELXVNcBsjsl0DSt+qykxbUvcFAZao3E2n7z?=
 =?us-ascii?Q?S9NuaWXms4mWdyrF4bBYnj9NjkqM74jMgWRpcdc3D13PzZDESodHybSMEgoe?=
 =?us-ascii?Q?X2D4LSyZU7tCO4rr862+P1EU0DA8Yh/yiuPyXSb+q59lDglNuGgxzVNx2kX1?=
 =?us-ascii?Q?7kz0Uk89Yckt5H7QvcUL+rInwplva6mf4nbBbR4yKx+I65qpUHmUYCy3YVBt?=
 =?us-ascii?Q?MJ5s7l814RGRKe7oM7PBwNgWak+2zLkIthXqy4fItHe34ZPfLMr3DhRcuPK8?=
 =?us-ascii?Q?qQf5ffONrKdWoAfnZ1lbUy+gU+P7EQXdPII/79J1aJDYFkPVkpFxwIS0f0N1?=
 =?us-ascii?Q?yR5ALhrs/YVVcefTBzEQRK8YaU6QA0MwAYYiyDtE8Ukv969sEvdAuKth4WKH?=
 =?us-ascii?Q?63xDAlSAFTqveAXnpsS22NkUFxBWvfMxzy2yjMiN7LZ5dkRob1oydOcZc9nL?=
 =?us-ascii?Q?nQITUM5+Sq2NQ9y+/IS3JlsGX54SHH4IkkA87QLnytbx+M6erxocrJVRFd9E?=
 =?us-ascii?Q?JlU7OjBLiNCnd2dAPDCrhtHL2HFaYWt7BOY++VMfYFQ2TcOzNGvi4BsR3Ngg?=
 =?us-ascii?Q?hbUli/cRK5MFiLrWOsq8YUX2K9sB05uXTucPno1kEYJia4Ee675BOlHehK98?=
 =?us-ascii?Q?PCRQhxl/EnYoi6Zi7/nOwJ6nQ8K4BQBImfTXG1wUdzwiPRSegomlCMu7PVer?=
 =?us-ascii?Q?IjE1L0893Kb7+rRruKV9WwGK2jczR9QYTLvQqNE3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d19c8c35-702f-4a67-f53d-08dae3aeacc5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 23:54:19.2721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzRzilBikT6W2I+jpOIEzUmwibM0ZjZ4sdxGcJruLUEgdMDIMqiH26k9LLLIe793sS16d1iAu5a/bPKVZmZiRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_13,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212210204
X-Proofpoint-ORIG-GUID: JVB0dWzwED5_50MEwKJ5MTN3Ry2LZEna
X-Proofpoint-GUID: JVB0dWzwED5_50MEwKJ5MTN3Ry2LZEna
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 01:23:40PM -0800, Nick Desaulniers wrote:
> On Wed, Dec 21, 2022 at 12:42 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> >
> > On Wed, Dec 21, 2022 at 11:56:33AM -0800, Nick Desaulniers wrote:
> > > On Thu, Dec 15, 2022 at 3:18 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> > > >
> > v1 cover has a simple example if someone has capability/time to adapt to
> > another architecture.
> >
> > - enable CONFIG_MODVERSIONS
> > - build
> > - readelf -n vmlinux
> 
> Keep this info in the commit message.

Ok.

> 
> >
> > >
> > > >
> > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > after df202b452fe6 which included:
> > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > >
> > > > This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> > > > with relocatable (-r) and now (-z noexecstack)
> > > > which results in ld adding a .note.GNU-stack section to .o files.
> > > > Final linking of vmlinux should add a .NOTES segment containing the
> > > > Build ID, but does NOT (on some architectures like arm64) if a
> > > > .note.GNU-stack section is found in .o's supplied during link
> > > > of vmlinux.
> > >
> > > Is that a bug in BFD?  That the behavior differs per target
> > > architecture is subtle.  If it's not documented behavior that you can
> > > link to, can you file a bug about your findings and cc me?
> > > https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
> >
> > I've found:
> > https://sourceware.org/bugzilla/show_bug.cgi?id=16744
> > Comment 1: https://sourceware.org/bugzilla/show_bug.cgi?id=16744#c1
> >
> > "the semantics of a .note.GNU-stack presence is target-dependent."
> 
> I wonder if that's an observation, or a statement of intended design.
> A comment in a bug tracker is perhaps less normative than explicit
> documentation.
> 
> Probably doesn't hurt to include that link in the commit message as well.
> 
> >
> > corresponding to this commit:
> > https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=76f0cad6f4e0fdfc4cfeee135b44b6a090919c60
> 
> Seems x86 specific...
> 
> >
> > So - I'm not entirely sure if this is a bug or expected behavior.
> 
> Nick Clifton is cc'ed and might be able to provide more details
> (holiday timing permitting; no rush).
> 
> >
> > >
> > > If it is a bug in BFD, then I'm not opposed to working around it, but
> > > it would be good to have as precise a report as possible in the commit
> > > message if we're going to do hijinks in a stable-only patch for
> > > existing tooling.
> > >
> > > If it's a feature, having some explanation _why_ we get per-arch
> > > behavior like this may be helpful for us to link to in the future
> > > should this come up again.
> >
> > While I agree - *I* don't have an explanation (despite digging), only
> > work-arounds.
> 
> That's fine. That's why I'd rather have a bug on file that we link to
> stating we're working around this until we have a more definitive
> review of this surprising behavior.  Please file a bug wrt. this
> behavior.
> https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
> 
> >
> > >
> > > >
> > > > DISCARD .note.GNU-stack sections of .S targets.  Final link of
> > >
> > > That's going to give them an executable stack again.
> > > https://www.redhat.com/en/blog/linkers-warnings-about-executable-stacks-and-segments
> > > >> missing .note.GNU-stack section implies executable stack
> > > The intent of 0d362be5b142 is that we don't want translation units to
> > > have executable stacks, though I do note that assembler sources need
> > > to opt in.
> > >
> > > Is it possible to force a build-id via linker flag `--build-id=sha1`?
> > That's an idea - I'll see if this works.
> 
> Yes, please try this first.

--build-id=sha1 is already being supplied during link of vmlinux

> 
> >
> > >
> > > If not, can we just use `-z execstack` rather than concatenating a
> > > DISCARD section into a linker script?
> >
> > so... something like v1 patch, but replace `-z noexecstack` with `-z
> > execstack`?  And for arm64 only?  I'll try this.
> 
> If --build-id doesn't work, then I'd try this. Doesn't have to be
> arm64 only if it's difficult to express that.

I went back to only trying this on arch/arm64/kernel/head.S

-z noexecstack doesn't work
-z execstack   also doesn't work
but removing both does work.

The flow is roughly:

gcc head.S -> head.o
ld -z noexecstack head.o -> .tmp_head.o
mv -f .tmp_head.o head.o
ld -o vmlinux --whole-archive arch/arm64/kernel/head.o ...

If I supply just the compiled head.o, not .tmp_head.o everything works.

ld of head.o with either {-z noexecstack or -z execstack}
adds ".note.GNU-stack" section to the .o

This seems to be the difference.

Ideas on how to proceed?

> 
> >
> >
> > > Either command line flags feel
> > > cleaner than modifying a linker script at build time, if they work
> > > that is.
> >
> > well... that entire linker script is generated at build-time.
> 
> Fair, but yuck!
> -- 
> Thanks,
> ~Nick Desaulniers
