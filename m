Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C476A0EEB
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 18:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjBWRy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 12:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBWRy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 12:54:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75DE3028E;
        Thu, 23 Feb 2023 09:54:26 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31NH01NG031518;
        Thu, 23 Feb 2023 17:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=LNkeAMvVi17VQdoXYfSLutFfmod5EXFkyeSo6B3W5+k=;
 b=0v8N4ymUBADf6IrHwiECMrEOlawTofv5YqhiGj9q6HMpV3bs4+nmhWfIy1Kzhp+FE9yS
 4F1Jg5FPQNSOuuoD7odT69zxqxZKaeTA/F2dfUatgIquXpkguA8IsWw/TB62navleObh
 cA2LUpSqAzTDaNCYvQH3K/pLGcuX6yttOyEbyDotz+bKBZ5KwYHkwFGbbnccABGbmn5s
 XgYj5w8G9G4M74pUlTBWqCcYG6LxmDnsXnBVI2vg9BCuXU39eP5RQQCseTqiMvXonBCi
 C8NjLobjsirbLAx3sCwHIdwdSBtovS5L8sj4At6j2KuYfIr++ekf/lb0SCoRJu7QtGsz bw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90u8q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 17:53:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31NGe3aA018143;
        Thu, 23 Feb 2023 17:53:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn48mudf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 17:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6INGjVPocKXwbZqIDaQn4SMyGpQ2vCIflYOWlGH0G4zsYAl+6i7vWxglUVunEPOx3GyH660vSuUgk6nq89pqGZ/atuLfOnY+17BeTEbgvp7L0XJHb7vgVOduoXTluKVHpkG+K70vQcDSQ9aVm/V0pH8On4gjMcSvyXnOP2x2KHMO+2y0xXGPM+pTnXKVLzRb7vWJv0epNNpm6akI50a1DcR1Smwn/7VeotmIiTxG9zl9fYfiT1/+sffiSjxADSBoQBV+mwRf8dakBLRgx1VJYniichXZrVtBP7SeyoYEn+UatljRal2bugfpen5VprcfimLD0qI7bFVBN3xGdGrxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNkeAMvVi17VQdoXYfSLutFfmod5EXFkyeSo6B3W5+k=;
 b=R0C1CdNCbiM3cqGy/A6Pq4aVgChFoFIY17rE5AId8Bv3lEQnolU0G/pMLFsOnD8YsfgxaYw2qYtlxj88cg1LrfUlNnwpDRj9t8M90DYQTv1Qa/tikDQ7zNFSU8UGzDDvkaGro+zaKjAe6yW04sgox2eoeYGh7ncYheoI+H+o7ti4y8Ih99lGvwKFvijphfD0OJY27/ro1hKfZoWQV84hMbpinnvP8WXezLQ+Eo3RHS9K/WxAeu15rJXccYpfp5/v+mOJbcVxPfWXEfuN44aTj94/MdhQQrAO5rUHG/eHftS9HdR2CrKALvaRHX78XF5It0hPlnJK0FIe9onUAIM0hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNkeAMvVi17VQdoXYfSLutFfmod5EXFkyeSo6B3W5+k=;
 b=atO5kPhsrK2X9NK0D5YcIWIk+Fs0QHoLErCN+yr8emuKCUItk5TA2aTdkNkCzVjobQ83nnSjuKfTGYEj/TAKSlJQCdUXNtYX09DjGRlf9rQY1Q7EF0B7lknWWeiawYPYdBrzmOureLBJF79FqOyt+82qppv2ktTgNyAwly/nS6o=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by PH0PR10MB7097.namprd10.prod.outlook.com (2603:10b6:510:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 17:53:37 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.007; Thu, 23 Feb 2023
 17:53:37 +0000
Date:   Thu, 23 Feb 2023 11:53:31 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5.15 v2 1/5] arch: fix broken BuildID for arm64 and riscv
Message-ID: <20230223175331.7tsgvkvcur6wl7h7@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
 <20230210-tsaeger-upstream-linux-stable-5-15-v2-1-6c68622745e9@oracle.com>
 <Y/c3MSvnN4DcvzSx@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/c3MSvnN4DcvzSx@kroah.com>
X-ClientProxiedBy: DS7PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::31) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|PH0PR10MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: c0337f48-f113-4c4f-c710-08db15c6e399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12HiqLorwYFLIRjjvltjoA4hsF3evqORsd2KDEqcJqnovCB638cCHfS3An+ovo/qqMEeadiSEmtnZAs9wqUdyK4JXnXgR7wHtcUS6C9tPbCq/2cpB4QGPLmTkXW9btYwSib5NGRAI/GOinqkMHchBKQoNjsyR50/4Vhe3McOei521yHC3vPOa+6c28CbrTp8wKEHCB3CSAbMvxvPLBf4a0piCkVKCpIW8sWKH4YFLh2CZTHFzs+8vF35buiSKk9ZPehAsI+Jwhy4WWDXtyxlIwTVmp00/QJlrFxYpsxSXB21XjYtmPtb+TB2ru5qxYWpF49zVaF70l4p3ALHMXgKS5z8YmKb/NNCgS2e8NnxFxzkpwy9bMjaT0He3QY9zvc1b8e5wv0Wsa0Q36f48d1wANzMQfc6P4wG9Qclc2oGSVzEoANJOSOnlQF3dErEpntIMnFjgD0TeEU4KI49S5LZrrtDMlN7twCpFTiZl8QVN+mMJo9rlB82/2pgRAcmCxcs+dl1MpQXZyfAbJOqbM6h2KG9KdRTTHBbmsx7+EHX0nBbs/QbSEm/xVrpoi3mId2+rqgM2/IayAExIdjGH8EiPLXzoroOOlCVlUTf2VMF5SZbSI1SNFiIpYNJDlEHnqvW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199018)(5660300002)(7416002)(44832011)(41300700001)(8936002)(2906002)(66946007)(83380400001)(4326008)(6916009)(8676002)(66476007)(66556008)(316002)(6666004)(36756003)(478600001)(6486002)(966005)(26005)(186003)(1076003)(6506007)(2616005)(38100700002)(86362001)(54906003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3AwMmp0UEtmT3hQTTVIaUFJZTh1ZU9IY3BkT2YwQzIycE9ML2hxVFhpSndx?=
 =?utf-8?B?dEpmWVVzbkN4YjEwSVp6NVJ2SXhrelgwNkswK3ZMN1NBRnV4TmYwOWpZcTBS?=
 =?utf-8?B?OG9SeVRWMHFGMzVvL1dpRUlBRFhGRTloZU00S0V5S1Arc2wwdk16bkY1R0Jh?=
 =?utf-8?B?eXMwMW5ocGNZVUo3dzhzdjVJNHhXZGszdjlzK0doQWdjMmZwNkYvUHQ0NVpE?=
 =?utf-8?B?Snp0VGkxblpaaXdRNUpIRVU0VUJNOVczTC9UNjYwR25UalRTcDRkVGdpaXZ1?=
 =?utf-8?B?U004SWVsTllFTFpPY0VnU0d1UTNXMW5YMTZNK0ZLNTBBYTgzZ1RjVGxXYkc5?=
 =?utf-8?B?REo0b1F5a240R3dta1Y0QVNNaWV3TmMvTmd3UTFaeVdUdk5VWENHVEZoUEJz?=
 =?utf-8?B?bUtNOTRMei9kMU85NUE1d1FrdmdsNmFWdCtXTHRLNkdmZzltR0Fwc0RDTE1J?=
 =?utf-8?B?ek10MUw3MkVuWEhPVWdzTFZEbndHOUgxOU1IallVM0huM2lxVE5HMjhqVStF?=
 =?utf-8?B?dHZDOVZmT0E3cExOOXgvZkdpZ0tUeERaUVBGTVk5dXdseWhTRTFzQTlEZWQx?=
 =?utf-8?B?VHJadDRxTktLQmhOb0Vad3BENXVpTmtnZzV2aGx2NStIbnFZbzVpcGJvQlR3?=
 =?utf-8?B?ekh4anc2SXNLUXpPODgxK0pvaU5LWHh4Z3JNOEtMOFZJdkltOCtOb083ak1L?=
 =?utf-8?B?QXRVT0QyeFo3QXA0T1FlTTRYMEFQRlljZjBsZVlVV1BsR0VUcUdEeExoR0tJ?=
 =?utf-8?B?VXI2ckNmMzhIMll6Y29FRVBhMmpLS0RnRmlEOFd0MUxhSmN5eVlaZlZka09G?=
 =?utf-8?B?Rm90WUdIN3Mwcm1nUjYwbE1oQkRhL0NPL1ovdzk0cjFMYkRRMGVZZGMrdWNm?=
 =?utf-8?B?ejB3U0dGc083dklTcDhlK0M4dGNXRWhMc1JXY2FYZVE0MitJaFpwWTd3QmVm?=
 =?utf-8?B?S3dtWnVTbnJuRjVlemdnYjRkcUU4S1hPeWtpc3o0R05pa2JUdGJ5L25mZHFV?=
 =?utf-8?B?OWgzOVVEaWtDTHBJL3ppZDIxV0RCTnJEYjZoR2lIT01mZy9QKzhDbzI0ZlND?=
 =?utf-8?B?MnQ2OC9mK21ka2hSbExxYUVUV3d3aFJ4SlMwUWxuKzB0RlIxeTBrbFF3Zk1k?=
 =?utf-8?B?NnZSTzdkbGROMzBaT0Vtc1lFdHlLVnBRd0EwUk1rUnNsNVNaYVIxU2dQemtm?=
 =?utf-8?B?ajdyMTVPOGRYQVpwUlg4eElXQUNyUW1MWVBld3ZYM2Nrc1RSSDVpM3pZYVBT?=
 =?utf-8?B?UGZPZWxwL0IrMkkrb2FsYTBwbVU5a0dYVFA1N2dhZ2FGZ3BFMVRGc0hObkU1?=
 =?utf-8?B?dk9aNDVBL3F1MlBtczAxL1YwZnVYVDVDOWlDS0hRTWpXY0NNOGRZSXRLREho?=
 =?utf-8?B?Wll6QU1rSHFsc3ZjQVhSTDkxNVF1K3RTeTU5c3dGUEpmMHZRcjJIREVJUlZI?=
 =?utf-8?B?cDBZS2ZEYmhWRmwyRzVmTGhxUlh0bDNINVZOOTBtelZzdi9LbE9ZbXZaMndx?=
 =?utf-8?B?L3ROR1AzblpyVkpUaWpNQlU4TDJKd1F5a09vcW9WQ21qakRTMmJnZHA4am8z?=
 =?utf-8?B?KzJaU25BRXZGY3RCc3ZWcFZ0Q2RaZ29VRGJDVWZ2bmlvaU92cTlvZlRGcC9U?=
 =?utf-8?B?Qi95YUdNZFp0WHYyelRiWEpkMUVyV3dNOU5DNHhzSmhwc3QxL21IMHNKQTZI?=
 =?utf-8?B?ZHlXS2pTb0NZcVdWU0Z4dXFFU2UrKzVlRWVBbllBb0dLaDUrZHJ4NzRQSkpl?=
 =?utf-8?B?WFJJclJUNDhZeitTRSs2b1Nrdms1OTNpY29RVDlDaDJxa0IyTXU4MG9uUkVB?=
 =?utf-8?B?cHU1MG9qL1YzVXBmYzJwNmNsMGhBSXhFRXFEcXFPeDRPeHdFSmhJdHZ4U2Ev?=
 =?utf-8?B?a1hCSFRtM2YrbjBObHVSNHBFSkFmbkQxNnd3bXVIWm5CRnZYTGxjZlUyQzVv?=
 =?utf-8?B?OVNLd1hsa1l6Y1Q1UVNzTGtPeTBET2RrYnJ3Z1Z6UXRnK29ZVmFKVDlocm9F?=
 =?utf-8?B?YWN0N09XWTVwSUphKzZodFdWK1RjQlFhbWFjQkhQKzlLcjRiZ3pJM0FLcm5Y?=
 =?utf-8?B?elh1SjYrNGRva25MSy9YUDBkM2MwMUh5Mzl5cWdpcFZyNmJRclp4djBoaTdq?=
 =?utf-8?Q?9yKpuJJFbL9sw54W1f3+JjbW0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?V0ViV0cxZ2VjSE81alNiMS9SajJRcUthazZaWXRDTXlDcmRYQUZBSHdhY2t2?=
 =?utf-8?B?bVVzRXpXalo2VyswTXd5YUZFS0o2ZkpyVFJCZHh2VXNsWTZSRVVTa3JKUU1i?=
 =?utf-8?B?VXlxenE3MHA4UHF2OWxRaU56blF0V25yZk42ekJaUGdYL0xqRGFJZytWYlg1?=
 =?utf-8?B?MForSUs0a1RxSEFjdm9QdCsrMXl6M1V0VXZxU05TYU5QbFFBMTJnRGFyRVZD?=
 =?utf-8?B?d0RqZHhBTW1FVUp1cXBYa082dnZjdzdUNkhRdnZPTUhzMHVUdk5WSEswRGVs?=
 =?utf-8?B?QmJnYm1sMGFaMEt2SUlCdXl5c01JVnRraDZVQk1wYmprSXV1bHVjWlFPekhl?=
 =?utf-8?B?M2QvZFdxUERsY1pvdHZ2SU4wSlU2cXJNa3dtV2F3VG4rdUQyaVZSb3RVNG5X?=
 =?utf-8?B?aXNDNDJMNjBxUFdCUEM0dVZIVUpqOVdDU1lXM3htR05hOVkxM1dLZ25LWTBu?=
 =?utf-8?B?bUpoaXBZNmVmSlIvS0Y5TGc4OHo5WG4xejUvMFhjY0VuMENMNXk0MFV2Ukk4?=
 =?utf-8?B?cUtnQjdzdndtM0ZMVk5xVUFYdUdjT3RLTVpEOVVhdG1pVC96ZkIwSXRNWEpF?=
 =?utf-8?B?b0ZuTkkrTHQ5RlF2Qkx6emRXUVRkaUdPYnRsaFVERjJNUkM0WlErOGM2OEFn?=
 =?utf-8?B?ZStwbTRlWk1tbTRGM3NkbU1uTUkyV2lKZWxub3FsVENNa2xHMEQydnp6QjZW?=
 =?utf-8?B?Q05tL0ZZUnVNVVhtSk45Y0VHODN0S0tlbDVsb3hCdUJBMCtIOXVBaDZjN0F5?=
 =?utf-8?B?U2RvdCtyZXlZSW4zWFo0RDBFWk0zTDd0NUhESlE1b1pZbExiM29JUXNCcHY5?=
 =?utf-8?B?N1NZaEhPQ0FGN0pPWkx4RUNnRUZraXN6WEFlTGNIa1dacXBVbXNRTzZad2h2?=
 =?utf-8?B?NjJEekEwazJweTJkZ3hCTnMrK0Q5TU40S01XR1o5WTcvMFlIVllWanRqajBU?=
 =?utf-8?B?NFRaek9XelNEQ2FNTng3Ly9wYnZlR2dja0lDT1Q4dGg0THhYbFFGRERZdGpt?=
 =?utf-8?B?cDQ2aU0ycGRvMmg1YVU5SWNSSndmMklsUi9jRWJzT1Vzdzg5ZktBbThhNWF6?=
 =?utf-8?B?clpxMEtqdVpWL3lia1I2dGs1WkMwNllaMlFuUE9kSGFOa1VjUlBHcTVkNlI0?=
 =?utf-8?B?UVZGc0cyR3FjdzN0RTBYUDNEMkN3SlIway9YUFBsTkdGWjJERjlNaDVYMWZl?=
 =?utf-8?B?aG03TGdxMHJoYzI3SThMd3VUV1k4dTRKcjJ0dDRCWHdhTDBhOHhERW03MVIy?=
 =?utf-8?B?bTNSRFFjS1A0QW5OL3dUUFdhdHdUN1JTUXZIdC8vNThOcUtvUThkbXA5T0Mr?=
 =?utf-8?B?WjBNczhoOHlmeUszNXl3cGZNQkZ6Yk1PeWtWU09JZ0dleWl3MWxaT215bzV5?=
 =?utf-8?B?eStNUEpkNFp6RWYyTDJON2hiclNLSUIzL1FkV2llaUluT2poZXhkWksvMTMz?=
 =?utf-8?B?dGhTM0l3T3lNb1JsK2hDTTVJQk5OaU41MkRoRDh6dHdnZ3lGMHpGdWxTdnpR?=
 =?utf-8?B?SGFNU0tLZmFmakIwR0Z4VkFxNkl6aWZPRzdxSEhJUHR6MnhFaTNyK1hYWFBq?=
 =?utf-8?Q?1FJm148IUVs6KkC2ODIEoJEgo3dY/RT+xZR2ZIey5mshOr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0337f48-f113-4c4f-c710-08db15c6e399
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 17:53:37.2864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1PORxfFqvm0DHC2LkZQnICN7XWBaEjR0DlC29qnKLoSCM9g896BuJKT1c2s4r/rfdxoo0dDsru/7isYuzw1uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7097
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_10,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230148
X-Proofpoint-ORIG-GUID: Cl9UFILi6yELgIz4lo3HBFuPn0iSiXf_
X-Proofpoint-GUID: Cl9UFILi6yELgIz4lo3HBFuPn0iSiXf_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 10:51:45AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 10, 2023 at 01:18:40PM -0700, Tom Saeger wrote:
> > From: Masahiro Yamada <masahiroy@kernel.org>
> > 
> > commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.
> > 
> > Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
> > since commit 994b7ac1697b ("arm64: remove special treatment for the
> > link order of head.o").
> > 
> > The issue is that the type of .notes section, which contains the BuildID,
> > changed from NOTES to PROGBITS.
> > 
> > Ard Biesheuvel figured out that whichever object gets linked first gets
> > to decide the type of a section. The PROGBITS type is the result of the
> > compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.
> > 
> > While Ard provided a fix for arm64, I want to fix this globally because
> > the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
> > remove special treatment for the link order of head.o"). This problem
> > will happen in general for other architectures if they start to drop
> > unneeded entries from scripts/head-object-list.txt.
> > 
> > Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.
> > 
> > Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
> > Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
> > Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
> 
> Why are we adding a commit to 5.15.y that fixes an issue that only
> showed up in 6.1.y?

Only in 6.1.y?  No, not true. It was just the
observed manifestation of 'ld' quirkiness at that time in mainline.

This same issue "missing Build ID in arm64 vmlinux"
also exists in stable with CONFIG_MODVERSIONS=y arm64 since:
5.15.60+
5.10.136+
5.4.210+

These all had backports of:
0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
which with CONFIG_MODVERSIONS=y brought about an observable 'ld' quirkiness.

Both are related to a behavior change in different versions of binutils ld and the
kernel's linker script.

99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
IS the mechanism which works-around the ld quirkiness, by adjusting
kernel's linker script.

a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36")
Documents the binutils commit which changed ld's behavior.

The entire sequence (dependencies and fixes) IS the 5.4 patch series I sent.
It provides the kernel linker script mechanism and architecture hooks to
work with 'ld' versions before and after...

5.10, and 5.15 are similar, but already had dependency patches.

Please reconsider applying the 5.15, 5.10, and 5.4 series, as they fix a
real problem.

> 
> We need a good comment somewhere saying why this is needed...

Does the above suffice?

> 
> thanks,
> 
> greg k-h
