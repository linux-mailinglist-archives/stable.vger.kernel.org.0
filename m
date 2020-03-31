Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A6C19A0E9
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 23:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgCaVgP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 31 Mar 2020 17:36:15 -0400
Received: from m4a0072g.houston.softwaregrp.com ([15.124.2.130]:40984 "EHLO
        m4a0072g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727955AbgCaVgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 17:36:15 -0400
Received: FROM m4a0072g.houston.softwaregrp.com (15.120.17.147) BY m4a0072g.houston.softwaregrp.com WITH ESMTP;
 Tue, 31 Mar 2020 21:34:49 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 31 Mar 2020 21:35:46 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 31 Mar 2020 21:35:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbGYimx+xQToUTa7pnmihmUwqE0LITNiAHgxFIpMYxQv5QG8s0DA1icTr34BAOJQvfmI2U2lXqUsk18HTL3h2yJQxOgNv2wFYx9HiMmoT2dZTMeO3SzCycpPB/cal7e1qijUEb4c6WOcih0IiMh2qyg0F+sfkuC5vI1Cl4xn/c1PhEAB08Bah8RKhRbi4C8v50kakOuVNfUm+ip6ts7br3pAkEMG+xIzBIWNUgDzqtPsBWIqUWbv2cL+r7rMQeXFVhuC68unj1AntMiL8g4+XLv1bgLxDGtBigzlCPt8kml8hRwz7BVmnzVdXbPgg46rV23eRZ6Fol99+qLQ0ldqrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSyWjt7HXdQD/97cQ02RRbKMvmj2bpqjey4Kdq2Rd6w=;
 b=DkXwRL3BI/5E2TfmG1yvmA89UYQbSIJrFWbHBCXapUW3AcNFdCOawHeeEha6jAlRfBuNeYRrAWaQ3MbUDuFuyE2Q2l8GJ7gkT9NgdKZrP4ZLMl6YJoajygRuGUYT9hITcQgqeJiKhXWypOkX95PTFZ9McW8zHLlIfpuTTzJn/3gHToPJeyQ0iuKb+2PT60pK0VQk4TrRLbe+R6uCME1z+wbfGGLhfKnAJCV+SoeFvy8IqojZ0UNwhW2xub7ajyc0/9BaZ1CFA6ZMmLVFG3EREdjIIh5SBpyeybLgZknyC0dwOodck53u/O822tPsnsBOTeQGorWafprAZADToeHr6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=DMueller@suse.com; 
Received: from DM6PR18MB2458.namprd18.prod.outlook.com (2603:10b6:5:188::18)
 by DM6PR18MB3353.namprd18.prod.outlook.com (2603:10b6:5:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 21:35:44 +0000
Received: from DM6PR18MB2458.namprd18.prod.outlook.com
 ([fe80::f874:3829:ad75:5777]) by DM6PR18MB2458.namprd18.prod.outlook.com
 ([fe80::f874:3829:ad75:5777%3]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 21:35:44 +0000
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [PATCH 5.5 102/170] scripts/dtc: Remove redundant YYLOC global
 declaration
From:   =?utf-8?Q?Dirk_M=C3=BCller?= <dmueller@suse.com>
In-Reply-To: <20200331120917.GA1617997@kroah.com>
Date:   Tue, 31 Mar 2020 23:35:38 +0200
CC:     Nathan Chancellor <natechancellor@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <8020A90C-7DEE-40DF-86F6-4446DE144BAA@suse.com>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085435.053942582@linuxfoundation.org>
 <20200331095323.GA32667@ubuntu-m2-xlarge-x86>
 <20200331100238.GA1204199@kroah.com>
 <5B6493BE-F9FE-41A4-A88A-5E4DF5BCE098@suse.com>
 <20200331120917.GA1617997@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-ClientProxiedBy: LO2P265CA0044.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::32) To DM6PR18MB2458.namprd18.prod.outlook.com
 (2603:10b6:5:188::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.22.222.25] (95.118.34.218) by LO2P265CA0044.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 21:35:42 +0000
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Originating-IP: [95.118.34.218]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0805b31-550c-41dd-7c17-08d7d5bb77da
X-MS-TrafficTypeDiagnostic: DM6PR18MB3353:
X-Microsoft-Antispam-PRVS: <DM6PR18MB3353455EFDE1F615F8409BADABC80@DM6PR18MB3353.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2458.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(4326008)(5660300002)(33656002)(6666004)(66476007)(2906002)(66946007)(8676002)(66556008)(8936002)(956004)(186003)(81156014)(86362001)(2616005)(6486002)(316002)(16526019)(16576012)(81166006)(54906003)(6916009)(26005)(52116002)(36756003)(478600001);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HfFRnq6ABDNPMJD8VPmxyNT/96AbC7B/ivG3kCAFmhfEQ3pM+G9j/pwUEY0RdTAwH7gpAe3nTV8IzMLR+UC+scWiO/PMhPTjvlY5pkS1JXFd1pdfYmMQlLrPIlaW7s+4joC5aA2c+5jxyBBXxTYJ0u0lrNWgLCmEOsTw0g24uzD6CoxxwYSI8Dq3y0wJp5X7BSYLQQ4riYjaJ9g0IR0lu+Z0aJq7+0SFCr69IedfB0x8loVMokEtJfxNUEhoM0jh3PEenOKJiyuTuNO0yhZ8+RyVJ7R4LFMNXf3tsxsMP8Z37nKdF3WVaRjNXjKyBsm88Gd6rlMBhVPzQL6ONhA+MlWJAdRrj83IBwqLrITgXFRKyVIdTwY8rZk6qCTvwJpUpOJpYPJu2R0JBJNWxJGsP2Sw02QMPA934nhJNqayxaBvu9zSPcoGXM/xUWSUlarB
X-MS-Exchange-AntiSpam-MessageData: XiQVmfUU/ZvYnzAilkx1vRxnmpKopLbVYHz440FLIFnlWuYLD1ISMrDfpPTBws2/SvCzrO9dyM2R3LRNKHRr4u7R3YUvVWLqeKkjfaXUZu/N2D31gvESI0PwJVmtn1jHIuE3IYX8IaRA8IWFp0KNjQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d0805b31-550c-41dd-7c17-08d7d5bb77da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 21:35:44.4461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1P4pSZyeVnMdBu7kuuL7eC0rqaO9oW9FhX02YsFm7NCOSXJU2TJ3hh3ix086Kq1L1IsFI5D/qFMM+cRRQ7K4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3353
X-OriginatorOrg: suse.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

>> However I think the sed above on the *patch* means that the patch will *only* modify the generated sources, not the input sources. I think
>> it would be better to patch both *input* and *generated* sources, or backport the generate-at-runtime patch as well (which might be
>> even further outside the stable policy). 
> 
> What do you mean by "input sources" here?


scripts/dtc/update-dtc-source.sh in older kernel generates a _shipped variant of the files from the .l/.y files:


$ ls -1 scripts/dtc/dtc-lexer.l*
scripts/dtc/dtc-lexer.l
scripts/dtc/dtc-lexer.lex.c_shipped

in newer kernels these _shipped files are generated at build time from dtc-lexer.l, which my patch is updating. I suggested
to modify the patches for older release to *both* patch dtc-lexer.l as well as update the *generated* files that are tracked
in git as dtc-lexer.lex.c_shipped rather than just in/place modifying the generated file (which would then at some later point
in time get lost as other changes regenerate the _shipped file then, reintroducing the bug). 


> If I drop it for now, I'll have to add it back when gcc10 is pushed out
> to my build systems and laptops :(

Let me know if I can help with a backportable patch. 

Greetings,
Dirk

