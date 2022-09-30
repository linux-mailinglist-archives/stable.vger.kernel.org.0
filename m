Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE855F0C2C
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 15:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiI3NGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 09:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3NGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 09:06:16 -0400
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2075.outbound.protection.outlook.com [40.107.24.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C78D12F3CD
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 06:06:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQpRscXUX29n4Bqe7Pr4W0JwumIdtadn4XHY5Lr7gplqVXC8wbHYiKvI2ApMNzeZLGak9W8LxVILiiJ6PLZRRhsR3svgq+irs/wsxXfWBlQ/Xnhc3I4MAzEOYLsyGZRc6o7BmjOFIIDfIGY0fEiQa1bw80ksghp5nIRS827snO6qHrhWwqXUJIpXNLYd4TEkZHcOc25BMYqUZnPyYFPsxSpkjBK+YAAT2DuEHZ1eqLCPq5WVP0/OYo3EysFf6s/XVnPMQova9Pvem5rNs/OiGcplfEzrjo0DjD1s3d3JCRcD9TGNziK54aEY8JurZipOXxex/nMSz0f6A0DcrUCN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKU7cErQkNiRO27izwnupS6HvuyjFGNGB/H9fdDvpMA=;
 b=menFVUmiK8eet0u+Uxya6UUUFPmtdG5YMSQUpmdLV7XzZyWNzRcauiW1FWZmhuigGfiNjO/Lrjr+c8+DtfN3sN5ANpngcFAHQEPT4lpsqqEWvwhaFlR7j0iu1XLUpdiqLDdnf5P9OI9wz4vJGc4LLSCVizQq9jnFPglbWhJzlc7IHnXA7kzFJ8uSjoZBYgWkW+7IOtIoX1iWod4bfHeeB4pfraYBddwNn0eTuXrX3oLSCUysIE31x7e0c+wjwnwITD1Dy40cQfD6XiU4Ish1O0IOS3hyhq12BIQMb76jd/Gf2LePvQyeLGAvFsgE2B4uJq8tHwzezI54vUfX4oKPBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 188.184.36.50) smtp.rcpttodomain=leemhuis.info smtp.mailfrom=cern.ch;
 dmarc=bestguesspass action=none header.from=cern.ch; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cern.onmicrosoft.com;
 s=selector2-cern-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKU7cErQkNiRO27izwnupS6HvuyjFGNGB/H9fdDvpMA=;
 b=AmS9dlNVXVsGWngtgvL3xOLOBDMgXuOki7THknSW+zrtXVDWTZDtU8JOsat8h8Aaprj9GXmmYVk1KWUwwekLHerwD4ytFee69UCsFkiAFScxDvTbXKMKINTp605HGnQTOuEpMGrsONGGdRl+9dd4PGsJs50+w+iyJQeTfHggLfs=
Received: from AM5PR0701CA0062.eurprd07.prod.outlook.com (2603:10a6:203:2::24)
 by ZR0P278MB0822.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.22; Fri, 30 Sep
 2022 13:06:12 +0000
Received: from AM5EUR02FT073.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:203:2:cafe::c5) by AM5PR0701CA0062.outlook.office365.com
 (2603:10a6:203:2::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20 via Frontend
 Transport; Fri, 30 Sep 2022 13:06:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 188.184.36.50)
 smtp.mailfrom=cern.ch; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=cern.ch;
Received-SPF: Pass (protection.outlook.com: domain of cern.ch designates
 188.184.36.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=188.184.36.50; helo=cernmxgwlb4.cern.ch; pr=C
Received: from cernmxgwlb4.cern.ch (188.184.36.50) by
 AM5EUR02FT073.mail.protection.outlook.com (10.152.9.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 13:06:12 +0000
Received: from cernfe04.cern.ch (188.184.36.41) by cernmxgwlb4.cern.ch
 (188.184.36.50) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 30 Sep
 2022 15:05:48 +0200
Received: from [192.168.1.25] (24.61.185.63) by smtp.cern.ch (188.184.36.52)
 with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 30 Sep 2022 15:05:33
 +0200
Message-ID: <36d318f0-9fc4-d5d9-9dc2-26145c963f0f@cern.ch>
Date:   Fri, 30 Sep 2022 09:05:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        <stable@vger.kernel.org>
CC:     <regressions@lists.linux.dev>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <b85bc2cf-5ea5-c5fb-465c-cd6637f6d30f@leemhuis.info>
From:   Jerry Ling <jiling@cern.ch>
In-Reply-To: <b85bc2cf-5ea5-c5fb-465c-cd6637f6d30f@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.61.185.63]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5EUR02FT073:EE_|ZR0P278MB0822:EE_
X-MS-Office365-Filtering-Correlation-Id: cf51d9c8-d38f-4877-9260-08daa2e48caf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lcbqi8tKXWQbCHrXEoa1vyqngBPCIjUgnhKljAjpGezdHoywCVFE8jhZiX8SR/JaWsmbBLJuNhUSPbtUMb1PmNJOqLyOGlb56cGUMWIl6vaMO+2ch+frD2JS+Akrb8RsgL0pTzGqffJ9nAYk7MWnr2XeCZsdOHb+MpSJNE3D77utxMCIGrS/HEWiUINyVhyn+4A/q0C0bM6zTv8cv+v1oeo1pTzvbGxI8tbuaRrmV7x1XM3ijWHTsw5yLz9eeVqNUwn2B8ruMzaTC0HSKxGaQ9kSttL1gR+g3uPJ8kyjam1Ys4/yQeIY247aMTPtX+nLHTdseWXnTdGmA0GdqP6iZIdYKZcLg1/cjCjGKIN/zpdLyjrwfs0dD1X6stFRq/sOn5clrOD57vaeRvver5Tv1/+x3sRn0GE1SXiwZmN5hvUTedinwaGMzHgj497Hs+lEutIcF+YJXnltgWJnM9IiHrWg2XBpprBMSTymkffdIDGWZ4U3cOz4i/hY5dpPEvd+9ziLkSgB0ZIua47Bv92tHWclmrkMIBI13E8fzqQexzbJ/iBcg7bVVaNxlfc/YIddcY0XJJrf2AS1pPQhm1YefIUx0a0Zj37JxWLxMdxoq5+F1VW+seKPN9ESIWsvIuvjMbQr4nSH3GdEHiTcMYLDJ5nbG0Yrt3NF6ERfHCSJvd9mOKstbPNdVB0tkLyWq7D0iYnJuQpezoueGrAPd3Pa340cCFSC4d6+tx1CsFGR6emRM5RfI1+2q+bUz+KiFKehHLDf8ndWH80fxf69yrpZOYI9gTX9/UbAgUY8OZ4UmO4SWIm+cka3GnTlEw0n0j5I+gYHxgNBloBfWBzxEEQudHZUdKczcpdzyQaxhvDxsV4=
X-Forefront-Antispam-Report: CIP:188.184.36.50;CTRY:CH;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cernmxgwlb4.cern.ch;PTR:cernmx11.cern.ch;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199015)(40470700004)(36840700001)(46966006)(2616005)(426003)(956004)(66899015)(47076005)(31686004)(83380400001)(336012)(36860700001)(186003)(16526019)(8936002)(478600001)(40480700001)(34070700002)(70586007)(70206006)(36756003)(966005)(31696002)(82740400003)(5660300002)(41300700001)(53546011)(4326008)(2906002)(82310400005)(41320700001)(40460700003)(26005)(110136005)(316002)(786003)(16576012)(356005)(7636003)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: cern.ch
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 13:06:12.0406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf51d9c8-d38f-4877-9260-08daa2e48caf
X-MS-Exchange-CrossTenant-Id: c80d3499-4a40-4a8c-986e-abce017d6b19
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=c80d3499-4a40-4a8c-986e-abce017d6b19;Ip=[188.184.36.50];Helo=[cernmxgwlb4.cern.ch]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR02FT073.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0822
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>If it is, simply starting with "i915.enable_psr=0" might already help.

unfortunately this didn't help.

On 9/30/22 01:10, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker.
>
> On 30.09.22 04:26, Jerry Ling wrote:
>> It has been reported by multiple users across a handful of distros that
>> there seems to be regression on Framework laptop (which presumably is
>> not that special in terms of mobo and display)
>>
>> Ref:
>> https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171
> A bisect would be good, as Greg already mentioned.
>
> Not my area of expertise, so it's a wild guess, but display flickering
> made me wonder if this change is the culprit:
>
> https://lore.kernel.org/all/20220926100814.131449678@linuxfoundation.org/
>
> If it is, simply starting with "i915.enable_psr=0" might already help.
> but as I said, just a wild guess after briefly looking into the problem.
>
> Anyway, for the rest of this mail:
> [TLDR: I'm adding this regression report to the list of tracked
> regressions; all text from me you find below is based on a few templates
> paragraphs you might have encountered already already in similar form.]
>
> Thanks for the report. To be sure below issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
> tracking bot:
>
> #regzbot ^introduced v5.19.11..v5.19.12
> #regzbot title Display flickering on Framework laptop
> #regzbot ignore-activity
>
> This isn't a regression? This issue or a fix for it are already
> discussed somewhere else? It was fixed already? You want to clarify when
> the regression started to happen? Or point out I got the title or
> something else totally wrong? Then just reply -- ideally with also
> telling regzbot about it, as explained here:
> https://linux-regtracking.leemhuis.info/tracked-regression/
>
> Reminder for developers: When fixing the issue, add 'Link:' tags
> pointing to the report (the mail this one replies to), as explained for
> in the Linux kernel's documentation; above webpage explains why this is
> important for tracked regressions.
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.
