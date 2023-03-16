Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E366BDB36
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 23:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCPWAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 18:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjCPWAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 18:00:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186806A409;
        Thu, 16 Mar 2023 15:00:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GJmQcW015284;
        Thu, 16 Mar 2023 22:00:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=Ck5qclHUVqaMGKvFgwQRtimxlqwhn8XpQzR5tcnt4sM=;
 b=OldgoMHP0qJ/6fT2v4CV4nARjQoiT7oRh67l8OFE6MPaIzqgwDsC+yhkF9+Cc/TTBY6+
 AihE4xdPs0pRAIP/nGcuZr8Eb9TR+0nKHHRqmxe4RcEsgbAj9TrJFNWFrsl0F1E4z5ta
 njRiQzK4UaBD0Y7LCzz5d7DnF1sKddkyOqvzLUQ0b92ugV13KeALozxE9Lk7bb6PH3J3
 cKyKvM5RpY/E8ID7rwLuofPEaOgNK5M7G7Mg1mnHnWnsRzmRIFQQkIPKMo0uSkeZ3CQR
 25+O4jvSGeAhXlchCjTBoHhkNoFHZN0UEZ3M6DeyiT1iU9Br/u+OQFG3y+DNJqS7uAgF sA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29jcys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 22:00:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GJqtoZ036908;
        Thu, 16 Mar 2023 22:00:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq9j6a1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 22:00:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVH5kCzC8cLMhkLVioWCaPJuGVsHdOe/5dU/ulhHy24R1Tv7gwDY9GKD7by0N37DmZVE4ktgFX2vy1ACF0d4kWELyipFkNx0imtNQ93kD2IUoGEf925o8/tLDmvm6AMivF+2V6fQIlMPhSCNm1syCdh9ztE5q2YU2gYq4o3gFqvEnSwFnnWNlNdihjdf7J9IX1mux5mDqGaf6Hm1aKsgZxZ+NtvL4zD8liM3h0a5RPSXGuTyVBouUePbxI3USdtZ9gIgAmTvEx/6trTG8V9+ZXt+rxFAlFGYhBTaM19kh4bcDsKvANA228SfbTIj0IZQjTdhgsFr4r0oHGj0mFUlyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ck5qclHUVqaMGKvFgwQRtimxlqwhn8XpQzR5tcnt4sM=;
 b=Pm9wcaOP+yl4F5jyM3lsYVYPvKUOoyZ7JP4T+E/rcL6rzal0qh+EyZq2/HGryapUuwlPBuB8MZDpUUUdO1CkVvBtO1JNZT3VpFA82Ooe7BLNkwgQSpVfR6smO14uAuOfAsTs+mjburiTZ6BfHprnr5JlYz3CprvdyhOCVDYRtQScG/Q21RglVs+c+MnGs3ldAxzkEBt13/6QykahoTv8oCjmLFwdCRQd6kI1CLnQyfWd60ZAA74C3fSv34FQnb963KkG7Se0Yvqok2kyile234f5U6+55aRtWXgPdF5BbXYxu9fd3nJmbUcLkxmf1Tc7TkBB1Vt3ieUVzBDG6qKB0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck5qclHUVqaMGKvFgwQRtimxlqwhn8XpQzR5tcnt4sM=;
 b=r5xAygujK0mo7p51vv+RT2noHbU3M6hZFKWIOerYuqR9grg3mnviS9rYI4zyRiX7CRQNuKK+MVnzHQRV7q7Ihxu09OhNF87yLLRFg0eTX6cMVapx78hfclnPftQgpD84fe4XYPhQ4KTtK+dhmphPi02eplmO5UNTraXRP13RZgI=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM4PR10MB7391.namprd10.prod.outlook.com (2603:10b6:8:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 21:59:58 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 21:59:57 +0000
Date:   Thu, 16 Mar 2023 15:59:51 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/55] 5.4.237-rc2 review
Message-ID: <20230316215951.2wgzudp7sptmc5zq@oracle.com>
References: <20230316083403.224993044@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>
X-ClientProxiedBy: SN7PR04CA0232.namprd04.prod.outlook.com
 (2603:10b6:806:127::27) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM4PR10MB7391:EE_
X-MS-Office365-Filtering-Correlation-Id: dabf5fb7-87c3-4232-cc49-08db2669c80c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z2kZbmVw2f5FgIGILX2SwAQQwRO4pmWkvxNmRhHJLYn1YoaDq6Hr9f6iDLf69EISJNq3greaR4pKL6MxfQoSd6IET30ooSOM9Cm6xEt2TjKUi7OtgadhVyJxOcJZZuw57jASI6tkRO2+f0A0+g1J4miZzrwJ7I4gdG57VDRP1GsqLJcTvBT5Pr2M/RwPKcGbNYshi3pVJzCkhPmQYE3ahe1mdy83h4JH+aEhIzPVytMmzgTi1WPj7nnVFi0OuRzitr6t4OH2twfsx3Y9cFDuOD4apHkBi/S48/lrLRFXqC43Umw1AzOHDWx/8w/3/1Bgr+79pu0wdJVABUebLcvcyHtVnrC7ExE/qVI7O64b4ZWjg5b17yOOgXcR/YHYKaaFuXFOIddrWbAbQDYnhqVD1HhzaXCkD0HzE7t89QjWkFwWqILsE19iFDjtXDMzkf06zKlnbl4AcX60rO9mszaB6uBgv80OsIAK66fYSfLechHYEJVaJBoCg+sSHzIn48DzR4EACwhPx2Sdob/MdIZP2snBw2iU+eqfhsA+11YpCGIN/yCqkBh3A5GR/XXJUirCBcP/nVRjvU+Dx4ByPhubnaXK0eUx4QiCZIgdEzOBc0nbFCJfCLSNGmYcLZvnDYJg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199018)(5660300002)(4326008)(8936002)(86362001)(7416002)(2616005)(26005)(6512007)(6506007)(41300700001)(1076003)(36756003)(6916009)(186003)(8676002)(2906002)(66946007)(44832011)(6666004)(6486002)(66556008)(4744005)(478600001)(316002)(66476007)(966005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDJwY0ZKVkl3cS9MNmhHWENpTzdnYVBNckZWUTVndjlqc3pxU2F3VzczL3pO?=
 =?utf-8?B?V1F1RTV1TkpnY0FhamJzZjZCQVZYZzkxTmVMeHMyT3cvZGxPQmEveDVEZEIx?=
 =?utf-8?B?eHMrYUl4S2VKMU5PNG50TkV6UTREN2xFU3BIRVNiMFp1Y05rQVprdXgzdkJM?=
 =?utf-8?B?NDNvREw5ZVE5blVRSStQV1hZTmxodk1kb2tkL00wYlF1VUF2QVBvdWNEME9K?=
 =?utf-8?B?N1BheUErN0pPMkI4YWFiOXVab2RVZFZyKzFuRXRPRUhYVDRzLzYzNUJ6U2l4?=
 =?utf-8?B?cmtrOVgza1kxY0pScXJ4SFY4bkRMd0ZYTVVPVk1GSVBMYXE5dUY3RkRHY2h2?=
 =?utf-8?B?YmVZeWtWOTgvam1yT0swWFVKTjQxaHJpQ1FSUlBnSGVRWWhSRXFyeFNKU29s?=
 =?utf-8?B?Q0c3RUdkUWFLUWlpNUo3T2tVSnpyWFd5eFIrODhUYmVUUlVHUnY1bVlEVnMw?=
 =?utf-8?B?WHpOeDJGQlZGSklEeEFsZXRDanNQZUo2NmJOL09tTXlwZFcwMFZRWE5yc3gz?=
 =?utf-8?B?TDAyekVMcldkVExjQlc5Zm0wOS9BU2x0cjZzK1o4L2taNExEWUdzUFJNNldR?=
 =?utf-8?B?UVVpZ0hQS3NjK1grSGN3dHc5UW1McVFNQXpZOXdCZE9JYU1vRUd2WGRuL0Rm?=
 =?utf-8?B?UzFYUEkrOElVM2VwSndSRHIxeUswVFkySVYzSlJKTHlGOFA2S1A4YVJ0bDhE?=
 =?utf-8?B?cVlHTWNETzJaaVlQYW9MWkxJRnIxWERkRnRxVmJrS2w4dy9SSEpOQThqSW1X?=
 =?utf-8?B?UFRPb2Fvd1F2MHJlQnlIeGsyVHpZaFMxTFhMOEVpVzlNREJ3dkF2VHJaYmMw?=
 =?utf-8?B?S3ZueVI1RVF0ay83RmIwVFdFaHdhc1E3WlZuVng5Mnd3NVZCb0RoN2lsQVdC?=
 =?utf-8?B?bzN3Ny90VUhlNjVGSWtuYXJSNmZFaTVvekhjbTR2cnZnQVRVcmN2a1FxQU4y?=
 =?utf-8?B?TS9KaW1SejlTWEMrMU12UkU5V3RBR1FGQmtSTzAwOWkrOHd0dFRrVjFGZ1lJ?=
 =?utf-8?B?TmkzNTZ1U2lZazl0K1dqUWR4dEZKbE03MkIxVmlSaTA3dDAzbkt3OVp2b1NV?=
 =?utf-8?B?RUd6bHl4NGhOaEVFbmIveHFTUkRoK215K1UybDFGd1lNTzB3U0RXS0JjWEFy?=
 =?utf-8?B?aU40ZmdOYmhFRVFKOFNOVExRemgyK1dPY1dtOE1yL1FZb2YrdFJJMzJySS9L?=
 =?utf-8?B?OStKN09jaXRXbkk5SFAyWGFQVmczcHdVWDR6MXJFL0NJb3FQbmFpYnI1WGs4?=
 =?utf-8?B?bW0xWk9JTldlWTRkUGo3eXZYaTU1QmhicUpVQkt0SVFNbzNUQ3ZRZHJaVlRE?=
 =?utf-8?B?N1NQelhrc2tLeDluT0crcHlQRTlGektxK2tBa2tQTkFWNVRDYWc5NEs3Mm93?=
 =?utf-8?B?L3BxTHBSTEl2elh6VnN6MGdocTNVYUUzWDMyWGN1TWRka3MwWEVHWjBrcWRy?=
 =?utf-8?B?M1pUMWJleVgyeFBncTJ4Ui96dWUwcXN3VXdBMys1eXRlTnFsOHI0YzFMczlp?=
 =?utf-8?B?c1RWUytENTM3UXAvemJxUjJKVzRRQmZrdC81SU1wU3FYaDJlWVRUOVJXdDhl?=
 =?utf-8?B?enpwRUcwMGlOaHB1R1Y0aXNRQVNlS0JTZmdCQUE5ajNUeGZ6enFSbGxuR0FS?=
 =?utf-8?B?WW5DanVlQzU0SzArOVltMTh5VEhyTU9qZnFuU1NRblFZWTNiVjA5L3d1bWsw?=
 =?utf-8?B?dXdDcmVRNHhJK3l0T1QxTUNOOElQbk0xdUNSZEdlU0xUM1A3b1FGTDZsKzQr?=
 =?utf-8?B?Wm1ybGdHYnZ0NzVsUGxCbERnb0lXVW03WkZza3ZsTUNlZVY1WmhXMStYK29m?=
 =?utf-8?B?bmdEVUVpRWlQWFd2QzdlZ0ZtcHA2NmFRVStHUkh2QTBmSzVSemNwZ0Mvc0cz?=
 =?utf-8?B?WGRkN0dxYUdSSTBydVVsRWVNQyttUC9EclFjQnVabS9NTkR3WDBEZkVuSmh5?=
 =?utf-8?B?UFpqc2VPS0dHSjlmN0JXZEtYa291QXZCNC9Sb0tpMzhCaXNKRDFVeXNTa0pv?=
 =?utf-8?B?OFFwQUNDRnc0TUhBUHl6NVpMOEVFVHhCSnVvVjJ1bHgxK0FZMTRibWtVbjJB?=
 =?utf-8?B?czczOEFVenk1Mk1UNldqbXU5aHM4VER2RXFzMEZlYjNEUXpjUGpyakJha2Vn?=
 =?utf-8?Q?qnMlOBkejIfI+gfsTRSh40//I?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?S1dtSmFHRWRBNjRBU09kcmdtNFZ6TEFnWUt3eDdlSml0RkxzUDI2SVcwVUZo?=
 =?utf-8?B?cklQT200ZS9BTmEzUTVUNE90TStZdGFjNnpReHhpNERRR3hNczhGZUNMeS9u?=
 =?utf-8?B?YmIzdkxXM1hqOVV1ZlZEZ28xaElEK09JWTc1RWxCUmJBbjNDK0dmUFNScTBU?=
 =?utf-8?B?ckhDZ2FqMzVxRjM1MHgyWk9nWlI4eDA2ZHZuSzQxcHEvZkhzTTZVbzhSajhU?=
 =?utf-8?B?WnFtTXVPVGFlZWJ6dHVZcVc3d3RMZ052dDErZDExYzNyUlBrSUpzVnlvblVF?=
 =?utf-8?B?SGV0YUlIbFJHYkRoZXMrNktvbkF3ZGdwekswS2NSdnlLZHpzUEs3Y0trTzJa?=
 =?utf-8?B?TlJ4a2IvYkttOXRBM0xaNXZsVlZESXNSdG05TjZxY3FVNzg5S1J0c244N21M?=
 =?utf-8?B?WGhIQmhtcmNhdmxSMFRsc01Sc2ovZWVWZnE4blVGeFRqZlMxajhGQmhFMTRy?=
 =?utf-8?B?bkxWV210azZKRmQ4ODNVUmtnNE9YdjhXQXQ4aWFHTnpyaXpjdEJiT21CNU00?=
 =?utf-8?B?bVlteUV4SVU4MS9lQXJlL0JyUDFYU29sVEJNMWVtZlJBWU1icm1GZ1pBNjJj?=
 =?utf-8?B?a0xsbTFnVmtGamFZdGdydm9XZEZLcVNsazZ5b2pnQndqa20rUHVYbnRQbUF5?=
 =?utf-8?B?UXMwZWF1QUsxK3VsMk9wWmJjTkhmN3JFNENncXdMV0VQSU9CcWZ4WHIwbEJO?=
 =?utf-8?B?MWxZNEY1YW8xRnQveXBGMHdWOXZCMXdCT1dMTTRPeHhnVjExeDJhN3V1MTRp?=
 =?utf-8?B?d3NYTDFYaVVua3dQS2k4cFM3OGMxUFJmUFhJU2lNQVRWSGwwVzlpYkJCMWNz?=
 =?utf-8?B?V201VW1lbFhabjJycVV4TFByYU9RdjBCRENrcHA1Q2NTdHd5SXZYUFJtTkZi?=
 =?utf-8?B?TVVqNHp2TzFzTk40YXplN0dpMDhvOEVmYkJYU2R2QmpNYk8xVUhGZVp3L2Ni?=
 =?utf-8?B?b1ZDb3U4YnowUUVYbGJIODRGVzJBSTRDUEtqKzhZL1Erb1ZKcUxGVGVTdlRt?=
 =?utf-8?B?d0FjaXQwQVNqSUZmdVBPekRwSFlnQU9PUzVxc3l4Rk1nR0RTeloxNkJhdXhk?=
 =?utf-8?B?M1lHWjNiR2tSKzBrNG8wVzd1enNEZXVmd3BwdG5hUEc0bmQ4OE55a045MXhD?=
 =?utf-8?B?QmRsRnVqVTQvUTZ5bnFNVWxQWkIxbm54UWJxWDJtaGVtSFlXTkxrOXdNTENa?=
 =?utf-8?B?WTJrbmxtUVZVNW9SNEt4TzJ2ZDZtZ0ZKTzRGTkFZM0hkaGV1M29pTEpsYlBE?=
 =?utf-8?B?WVIyVzVOZk9ndGMxczJZdE14b3ZHTlNMYlU5Rm1KZnYxVHY0bnpwekJleTQ0?=
 =?utf-8?B?eGxUd1VqV0xCSmVFblIwNGVtSW9TbzFRaXo3S2JFTXVYSUhDcVNTbTJ6bjV1?=
 =?utf-8?B?dVRTdldFckQ3OWtoNjkwM1k2OFZZak1qWDVwZHdiOGJjL0FOYUQra2kwRnZt?=
 =?utf-8?B?c2RYRUJqemszY2RxSUlaMWxER0NXeXR2ckZ3V0oxYkhIS2h4NjVUdUNLZE84?=
 =?utf-8?B?dmoyYXZGMXZMVEU5WC9jbEZveHErNW9VVGM1M3d6aDdzSmlGWkdjVGdFRW5n?=
 =?utf-8?Q?W7HGFiioZer2muLrVdUjvfMpHTNNTsVTv7KgWWYcTOsryD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dabf5fb7-87c3-4232-cc49-08db2669c80c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 21:59:57.6510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u24Qx57jY4tV9Uo9oHRoRU4klyWGjErfH+PHhY5XjTpbtdLlpLOJg8lZ1WrPRnR84paslFfm7D9DkzriyV8c8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=961 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303160164
X-Proofpoint-ORIG-GUID: ThxAgt09a98h_yITfAuXmnY12k-Ub4wb
X-Proofpoint-GUID: ThxAgt09a98h_yITfAuXmnY12k-Ub4wb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 09:49:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Build ID for arm64 is back with CONFIG_MODVERSIONS=y
Hooray!

Tested-by: Tom Saeger <tom.saeger@oracle.com>
