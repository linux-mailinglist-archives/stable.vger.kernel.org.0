Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1922670E99
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 01:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjARA2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 19:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjARA2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 19:28:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B77B22006;
        Tue, 17 Jan 2023 15:50:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HLwkqv030951;
        Tue, 17 Jan 2023 23:50:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=qvQM3zAt6xT0LnChnO+NwnUEtXtBUiWO1/LcMy1lDGk=;
 b=nAXPMU/ozzwBbbd6bALOf/xm9L5zk9xYNY6QnmGW0bmGlr4sZYEgfGDfs95kuqASCHwZ
 VxewKJSskHf3SL4nZcJMuIlX99ca1onZ501eQtLQ0pscraGOv0ZuXGiXJ1ywVjm7Z0Ky
 1rj/qaRhoE1XtLCd0NR/A1BVYCm31H9nGdJoIDscC/N5Y3WVzdTuhpFQ3maEcs8SP/WK
 lgNMAX6LK2j4ef6FbVNtsV+QRpKF+Qjwlh7cMz0ZIq+SUzJvmmmPDSynBhrC3gvpgqqz
 N08ifuRFJkkxa9vJQqbAYSc/PT1Fk1I/E5RQ/qfq5YRs3SKoGlNpArr1lDthkaCY+yvJ 4w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3k6c68sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 23:50:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30HNnBOZ005667;
        Tue, 17 Jan 2023 23:50:15 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n65pb00tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 23:50:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fP1yjMSdJ4G2rkK7vGF1JbvjeRmMdheW4NPcvwi8tUX4yTchB+EFsqZN044cE6mGFcL9ibm2EFkGPRzFCAA438Sxx+oAU50mgRIj2IKG4FZoXoADeVqmTGMkaSjttBdd6fo7jizkUoOhrPp5pbLjbX88FrLVP6NsKTP7LCAOA9MLTI8rGjUsxMqHA4zNDsbjnVjq6eXP+beCYrFnPyH/XIA+UBnlk4k/fx8c7PNqAZANcCR5K7KYZuSDotz+g8xocd9DHIDOJGktNc8J/Gs/t5xUFuJHctBwEEJfU2KQ0/0NGG0nTfy3E9/xmdzKQcxk4LKpO+4jph04e8r2b14ncA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvQM3zAt6xT0LnChnO+NwnUEtXtBUiWO1/LcMy1lDGk=;
 b=X1Elry3daenk/agcsN8v7vDqLdN4wuhdU2PYal0DOORQL9YVHAdDA2gGD7VAbwRad2l8jRJcVqarx9Tf1lZoqPFR0wODRehNfWnID4f4e8JeCIgjK8v3nf7c4wx2Mxtpi2YNk0S6bFmrCJCE813uFHFIdbR0vbtE+F7RKLyziLr0GIsuP8PQdVT9wJvSpKSzuxvH+RUq0cA8RJ0RW3s/RCDX6jjtsbNm8D86Z1wTfiNpIDeKEKDiT8POmkYPBZkt+J7dA3tkBrhDQVrp5fTuy4cjHHPZIPGhcSYBFWCexBXr3lCA2oank5QZElzXuZIloQyG6D5XVlVFXkyoHSO8VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvQM3zAt6xT0LnChnO+NwnUEtXtBUiWO1/LcMy1lDGk=;
 b=Dk5mVPpnVOPosE4DitZJ5SSQx/1ml9ZQTFIa9/Z52Cazb9PYrtjhqmVaq4Aqjd2Ko56mS3sC8ER+ryGpb380SV9rbeQJUdczLaH8GrYIctkc8ij8LPAKSiPkfc6Q5+OmROdLh/VkPylPZao5QjbXtqT6dFGQYwBbc4mPESg32tM=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB7433.namprd10.prod.outlook.com (2603:10b6:610:157::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Tue, 17 Jan
 2023 23:50:12 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.6002.011; Tue, 17 Jan 2023
 23:50:11 +0000
Date:   Tue, 17 Jan 2023 17:50:06 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20230117235006.oishw5tlc3xnwwmd@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <Y6M090tsVRIBNlNG@kroah.com>
 <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
 <Y6Pyp+7Udn6x/UVg@kroah.com>
 <20230109183615.zxe7o7fowdpeqlj3@oracle.com>
 <Y7/2ef+JWO6BXGfC@kroah.com>
 <20230112212006.rnrbaby2imjlej4q@oracle.com>
 <20230113150654.w4cbvtasoep5rscw@oracle.com>
 <Y8Kz8JwM/4GyN1um@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8Kz8JwM/4GyN1um@kroah.com>
X-ClientProxiedBy: SN7P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::32) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB7433:EE_
X-MS-Office365-Filtering-Correlation-Id: ea7380c9-a018-4c74-d628-08daf8e5923c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +AWrgHxxxifZRmvvI41MSovJAMwu5EStx7xi/7E5R1e+pf7hByu0kFvhYB+R8dw0wmYeN45LGvU9Vc7svU8yadgKLJ/K3/ljRvtzVSfMwioxtNNH7hUixkHTp5S/jtIvakqvm1xyQq/sAL8lb/cs/0msF+IpXdUTi5XaCgzKTsaRu06kIvNdWTUJOYyiIPtf+rdMnAnQMxyN1Rk3o/ZnQgSxKCR7vZJOdHoDmeKJ1ufC9dzAIiywNET3xrXvFpgvBmrPp/YBtxfyfPpkpRLVTLcCa3gLHQIAOj1+B+9uu88Rai1f7e10pZVEr2LbYkNdG+rpq9lanzUNtWnUR8a5L2AaTjZmyqzjjGAP3mA2cvIurRG3ct/H1L4ldBfhOVGFAzfkVw9ipriqnIwjnS5Hrd1nC7BUFb3aD9wQrCeHsHYtvjEpWhM8oJlcE9D2VbpyR45UhBw/ZoV50EecbT9NTuhHQqrAATb6NpXgFmHEORXQ/mytjzen3ZAGOD22M1sdx6xg/f7qlHUgeVttmSNSX2PPNeympjfFKSFX7/hQ3HHpU3eb5nJSmbEAz9q0Xde69A1JSP1j5h8Szkbi10h1tZhHM8yZwsTKyN2sxAC5HRIQ8vhCLQ+gUqtb/j0/j7eYkpKgWQxxZWP8tR4/Vz76elz+NUXtOMNvuZhcSj4n2BG/Pq9C8YrZWCt6moEDD4bnxItgAlG/06SSEL8NSUyxOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199015)(41300700001)(36756003)(86362001)(44832011)(38100700002)(8936002)(5660300002)(2906002)(83380400001)(54906003)(6666004)(6916009)(316002)(478600001)(6506007)(8676002)(966005)(66556008)(4326008)(66476007)(1076003)(66946007)(2616005)(6486002)(26005)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHQ2dmJwbU1EMmZsRTIzak41UGZRSDIyM3llVmZCa3FjdVpkdmlSRWs5MmtW?=
 =?utf-8?B?MmhhYkZIN0RhU05Nbmx6S3FudUtTVFJ3SXo2YmI5dStMbDVrL1h0UGg2S2h0?=
 =?utf-8?B?dnRvNmtFS2dzTllYbjZtcHBJRld0ZEhpdXRncURKazR5MHd1REZHdHRHbTFC?=
 =?utf-8?B?UnZISys5VnF1OFpMYXkvUmFzcG0rSlVHL2FMN1BkL2RoMjlYVDRNTnRjVDdQ?=
 =?utf-8?B?RDJNK3k0MnFUVHAxSjAyYXZNdmF0My8rU0tlSThDZWR5Y1Y0cXA1ZVhhWDFY?=
 =?utf-8?B?ODEvNmZtSXh4YlFpcTFPOWsvUUhSWHdUMW9UWEJ3aDVaNXlsam1MTThnYVRE?=
 =?utf-8?B?ZmpzZjRHTlpHbEdCQVBrbUs5VW11aVk3WUw1SU9TaytaWGozdEJLYVFkZ3Iw?=
 =?utf-8?B?d1NGdWJ1empkaDJGQ3l5Y0xzT21CNUZuNyt4MDk0dmVqQnFRZVc5TFJpeEN6?=
 =?utf-8?B?UDhYUFdQUlZaTFVTZ3JOc05TNEJwRStNZzIxazVVTU9NVzMzRzdCbFBpaEpX?=
 =?utf-8?B?bGlKRCsveFhZRWlLTStESkpCRkV3cVVoMmZ5emttZUR3ZW80cnB5b3RueTEw?=
 =?utf-8?B?V3VtZC9RbjNvTEQvLzdBbU95TTNmdDFDZHVEbWtVSUc2MzdFYXFXRkRwaitv?=
 =?utf-8?B?MURjbVdoOTlldHAvcndHOEZydlF1T2hzci9BS0ZUMnhmYWRPNXIxYUVoUmRk?=
 =?utf-8?B?b1I0M3h4SzJuYmZ3YlIwMFNJM0UvUm5EVFRkbVhCUytaKzROQmFaVFNuT2V2?=
 =?utf-8?B?bDBPWGZZWGJHRkltOXhQS2ErR0p4a0hyNm1iejVzRWhKYU5xYVBLZVRaN3Zn?=
 =?utf-8?B?RTMwa2pZZHowcGdYMzl6cERmYkppSjVzM29PNitUWThCaUtpdERwTjFZcWxW?=
 =?utf-8?B?Ti9KMFBiKzN4SldrMXhuZjRhYVBLYzNiMDdDYndFckNGcEVDZ0JOUXJuU3Fn?=
 =?utf-8?B?ZGRtVnNYMEZoYjlGbHo3YnVhWFRVcmRRNTJ2N1dmSTlqMUcwWEdXMVFwWDhY?=
 =?utf-8?B?VHVldjh5Zm1KTlNBTWVnT1B1aDVlMmY0OTZNWFREVHAvTnMyVDI1SGZPOGxK?=
 =?utf-8?B?ZlUwK0p0S0Q2c2hYQXlCMWZ6OHVxWWw5aXNFaXVRMXBHaG1PUHR6dzJaMXpt?=
 =?utf-8?B?VjIxbmM1UXZ0MEJYSFQ1VFBBTllEanVyd1hBQmt0TFBIcGN1YWxYNnI0WXFP?=
 =?utf-8?B?aFhpZVVUZVhURkYyNE1reFhMVGZwVjlPTFVmQkhzb3M5SnQwb3M4TkpLR3RK?=
 =?utf-8?B?b215djRWcnM2SVA1aEtMSnFRU3pnMHVFYUZOM2xNa2pvejd2cTNIQ1QvY0xr?=
 =?utf-8?B?T0dnaW82M1R6Z2grWVJ0aVpvcEU4L05jb0lscE5ISHZDZE0zL0N5MnBNZ1Rq?=
 =?utf-8?B?WE84ZnNZVGlPSVhaUll2SjJZK1F0Y2dvWUlUdjBYNHEvVGZPeXZMTVhPQlFk?=
 =?utf-8?B?OUlkZ2lYRHNTL3A3dHdmeHh6WWsrOW1iQzBOY2F0L0ZDYURpYmV0UFhFSnhx?=
 =?utf-8?B?UmtyS3RoRjhqeGQ4dFFVdWFYTDlML1o4RVY3NTJyVCtnaHppRHp0WkxyS2lF?=
 =?utf-8?B?QVgrZU9rRXYycHYyRXZwbXh4WllrcWZRdUQ4aksrUEFvcm5YOTZac1NmWlFJ?=
 =?utf-8?B?cG9LVmhKWnVNaDhUekdOcmkyRWxsWFE5RnpuU0hrazlmdXViWlRaSER3OTRH?=
 =?utf-8?B?ZHljWDN1eUpTUUlELzVUS3lzUWVtTWh3WmlxaWluWFM4V280d2R5d2w5MUdM?=
 =?utf-8?B?d3oxeFVXdlhjYk5NVmg4WnF4UE9qaU50UUZNdndOb3FkMlZTWGlFVGtNYWkr?=
 =?utf-8?B?S1BWSWhnSFJIbXRqK2J0U2ZISXYxbXcyeE55b056N0J5Yi9uTDJFN2hHS1R2?=
 =?utf-8?B?RGRoTXp0a085QlZVY2xJM3dmbVhZVnZ0R2FKZlFhTVNZa2FHWlNwU2lDbWFE?=
 =?utf-8?B?VzhCVEhGMnZtNTYrRFYzUWlESFgvTXBPOGU0SUQ5amhOcVgwRzQxYXZEVHls?=
 =?utf-8?B?RUEwaCtYZVJRdXBFYzZvdGN0KzRGRCtuMDJZYWtMdzMxK0huN0RRZ0twMFhL?=
 =?utf-8?B?V0NkTjAzdFVlMVk2UWNaVHRjT05KcWdMSlppYXRuSFpENUhqL3J0VmI0ay9O?=
 =?utf-8?Q?GeKalsCqViw3BY0HNkPtmNDN+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YnlGZXVjNzJHdFV3d3BydnJxc1gyalhWU2RHYnNCTHF3NGpUMVZKdDJWNUI0?=
 =?utf-8?B?T3RKQ1VKd0dhU0t4WlB0V3hZVzFxYS9md2NkZHg3aW0rRVlValFWZXdXRzdX?=
 =?utf-8?B?OE1xLzdoQ2JJRzZLa21nSUVVNGNzWmY4VmF4aXZ1c1ZrUWduRjR1UVFndlRl?=
 =?utf-8?B?aS8rM1Y5alBISENqOW1LY2dZYWpRZlNrNXQwTHlUTVVFcmZqT1hEd0J4dGNJ?=
 =?utf-8?B?RTBka2dzd2FvS0pNdy9VOTNKTUpCL0E3MW92VUMzd2FoTHJ4UnZxUHJjUXpV?=
 =?utf-8?B?bDZiQzVNWVl3OHJzY3VLd1pzTzhEUkVSb3hkSG9aRWltTGFRbEV3U3lPZkdq?=
 =?utf-8?B?KzExNG5iRWdDMWtmcVNURkxHRkluMnp3VEZGQkZsdTFhbGtmbTFQdS80Q000?=
 =?utf-8?B?VmFTZGQwUCtvK1RpdU1MQVI3YTJqa0ppWkdYb2FEYWliWjF4cURCeXNsb0dX?=
 =?utf-8?B?cXN5d1BmOGRJWWJLZmlqOEFleVlqWXZZUEVLMEJlVURxRXA3Qkg1bnZqVFpB?=
 =?utf-8?B?aEwxL0c3RlVPUmIxdTk4Z3cyV3ZhL1pFb2NVRFl6Q1hZaElFN1cwUEROYzNM?=
 =?utf-8?B?ellyRFFKTTdHNmtibmNKUlJXRkNOUVg4bFQvNGxWWEUxdmQ4QjhiT3JSd1RB?=
 =?utf-8?B?cnJFTUNTWjl3OUdWdldDOGJnQTVnL3BkYW1PRkhnV0NHd3c1eE9VRjMvVmh3?=
 =?utf-8?B?WlcxVUIwaWZuK0FKdWlpR1l3bTdRcXM4cUcyQ1NCQXVDSnUwUWNVWVVDSVJu?=
 =?utf-8?B?cFhsaUVVWFNIZVVSUW5JeE9yNHlKYjZ3NjFxU0RORSsxK3l5YWVoLzAvTEVC?=
 =?utf-8?B?YWkzbFpxRGxtVmZMaGxmT0RLdlo1TFQxM3ZsWWlWZi9CNVFQamhHUXFpQXBX?=
 =?utf-8?B?aGRSeVRSRUxwNzBISURXaWE4NUFnZEdFQjZGTUQ1dXA4TStXRUdFVW9meTdD?=
 =?utf-8?B?V0RrSlpIQW0vQnBpVWJEY1pLVFp0TGFTQm1PMkVMQUpBaEtmZVpsRzlpdnZ4?=
 =?utf-8?B?QWFTcUxZcG53Rkw4TWQveWI4eE1NbXE3UDFUeDNjSnA1aWlZN2MwaUpDb0Ry?=
 =?utf-8?B?dXVsaFE5TVN3S0RkRE4wU2dZUHJ1NHc5d3pNQ1JNU0o4U0N6VlI5MnF3MndZ?=
 =?utf-8?B?aHRPZUllQkNWRHJZRkx4WHQyWTJKTkRwbm5ROVZ3cmJBd2k3NWpaRjJFT2JP?=
 =?utf-8?B?K3VPa3JVeW5JdzdEUEI4S0lXWXUydXQxc0gzd2NEcEU0QmNPbldUV0dxVmEw?=
 =?utf-8?Q?rxL1U4GVfkQz+Te?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7380c9-a018-4c74-d628-08daf8e5923c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:50:11.5537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNJqh1zHXLrkbcRcUPZeauE1DzyOAfoBZEIgLgEhDiDDnPeiKgoyIUa0nCh31mTfC7CigQ+gikGtmEyKGsIOfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_10,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301170190
X-Proofpoint-GUID: oYwi--_zvvJyVyD2Z-wZDhssBbeUrWc6
X-Proofpoint-ORIG-GUID: oYwi--_zvvJyVyD2Z-wZDhssBbeUrWc6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 14, 2023 at 02:53:52PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 13, 2023 at 09:06:54AM -0600, Tom Saeger wrote:
> > On Thu, Jan 12, 2023 at 03:20:11PM -0600, Tom Saeger wrote:
> > > On Thu, Jan 12, 2023 at 01:00:57PM +0100, Greg Kroah-Hartman wrote:
> > > > On Mon, Jan 09, 2023 at 12:36:15PM -0600, Tom Saeger wrote:
> > > > > On Thu, Dec 22, 2022 at 07:01:11AM +0100, Greg Kroah-Hartman wrote:
> > > > > > On Wed, Dec 21, 2022 at 02:52:10PM -0600, Tom Saeger wrote:
> > > > > > > On Wed, Dec 21, 2022 at 05:31:51PM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> > > > > > > > > Backport of:
> > > > > > > > > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > > > > > > > > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > > > > > > > > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > > > > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > > > > 
> > > > > > > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > > > > > > after df202b452fe6 which included:
> > > > > > > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > > > > > > 
> > > > > > > > Why can't we add this one instead of a custom change?
> > > > > > > 
> > > > > > > I quickly abandoned that route - there are too many dependencies.
> > > > > > 
> > > > > > How many?  Why?  Whenever we add a "this is not upstream" patch, 90% of
> > > > > > the time it is incorrect and causes problems (merge issues included.)
> > > > > > So please please please let's try to keep in sync with what is in
> > > > > > Linus's tree.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > 
> > > > > Ok - I spent some time on this.
> > > > > 
> > > > > The haystack I searched:
> > > > > 
> > > > >   git rev-list --grep="masahiroy/linux-kbuild" v5.15..v5.19-rc1 | while read -r CID ; do git rev-list "${CID}^-" ; done | wc -l
> > > > >   182
> > > > > 
> > > > > I have 54 of those 182 applied to 5.15.85, and this works in my
> > > > > limited build testing (x86_64 gcc, arm64 gcc, arm64 clang).
> > > > > 
> > > > > Specifically:
> > > > > 
> > > > > 
> > > > > cbfc9bf3223f genksyms: adjust the output format to modpost
> > > > > e7c9c2630e59 kbuild: stop merging *.symversions
> > > > > 1d788aa800c7 kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS
> > > > > 8a01c770955b modpost: extract symbol versions from *.cmd files
> > > > > a8ade6b33772 modpost: add sym_find_with_module() helper
> > > > > a9639fe6b516 modpost: change the license of EXPORT_SYMBOL to bool type
> > > > > 04804878f631 modpost: remove left-over cross_compile declaration
> > > > > 3388b8af9698 kbuild: record symbol versions in *.cmd files
> > > > > 4ff3946463a0 kbuild: generate a list of objects in vmlinux
> > > > > 074617e2ad6a modpost: move *.mod.c generation to write_mod_c_files()
> > > > > 81b78cb6e821 modpost: merge add_{intree_flag,retpoline,staging_flag} to add_header
> > > > > 9df4f00b53b4 modpost: split new_symbol() to symbol allocation and hash table addition
> > > > > 85728bcbc500 modpost: make sym_add_exported() always allocate a new symbol
> > > > > 82aa2b4d30af modpost: make multiple export error
> > > > > 6cc962f0a175 modpost: dump Module.symvers in the same order of modules.order
> > > > > 39db82cea373 modpost: traverse the namespace_list in order
> > > > > 45dc7b236dcb modpost: use doubly linked list for dump_lists
> > > > > 2a322506403a modpost: traverse unresolved symbols in order
> > > > > a85718443348 modpost: add sym_add_unresolved() helper
> > > > > 5c44b0f89c82 modpost: traverse modules in order
> > > > > a0b68f6655f2 modpost: import include/linux/list.h
> > > > > ce9f4d32be4e modpost: change mod->gpl_compatible to bool type
> > > > > f9fe36a515ca modpost: use bool type where appropriate
> > > > > 46f6334d7055 modpost: move struct namespace_list to modpost.c
> > > > > afa24c45af49 modpost: retrieve the module dependency and CRCs in check_exports()
> > > > > a8f687dc3ac2 modpost: add a separate error for exported symbols without definition
> > > > > f97f0e32b230 modpost: remove stale comment about sym_add_exported()
> > > > > 0af2ad9d11c3 modpost: do not write out any file when error occurred
> > > > > 09eac5681c02 modpost: use snprintf() instead of sprintf() for safety
> > > > > ee07380110f2 kbuild: read *.mod to get objects passed to $(LD) or $(AR)
> > > > > 97976e5c6d55 kbuild: make *.mod not depend on *.o
> > > > > 0d4368c8da07 kbuild: get rid of duplication in *.mod files
> > > > > 55f602f00903 kbuild: split the second line of *.mod into *.usyms
> > > > > ea9730eb0788 kbuild: reuse real-search to simplify cmd_mod
> > > > > 1eacf71f885a kbuild: make multi_depend work with targets in subdirectory
> > > > > 19c2b5b6f769 kbuild: reuse suffix-search to refactor multi_depend
> > > > > 75df07a9133d kbuild: refactor cmd_modversions_S
> > > > > 53257fbea174 kbuild: refactor cmd_modversions_c
> > > > > b6e50682c261 modpost: remove annoying namespace_from_kstrtabns()
> > > > > 1002d8f060b0 modpost: remove redundant initializes for static variables
> > > > > 921fbb7ab714 modpost: move export_from_secname() call to more relevant place
> > > > > f49c0989e01b modpost: remove useless export_from_sec()
> > > > > 7a98501a77db kbuild: do not remove empty *.symtypes explicitly
> > > > > 500f1b31c16f kbuild: factor out genksyms command from cmd_gensymtypes_{c,S}
> > > > > e04fcad29aa3 kallsyms: ignore all local labels prefixed by '.L'
> > > > > 9e01f7ef15d2 kbuild: drop $(size_append) from cmd_zstd
> > > > > 054133567480 kbuild: do not include include/config/auto.conf from shell scripts
> > > > > 34d14831eecb kbuild: stop using config_filename in scripts/Makefile.modsign
> > > > > 75155bda5498 kbuild: use more subdir- for visiting subdirectories while cleaning
> > > > > 1a3f00cd3be8 kbuild: reuse $(cmd_objtool) for cmd_cc_lto_link_modules
> > > > > 47704d10e997 kbuild: detect objtool update without using .SECONDEXPANSION
> > > > > 7a89d034ccc6 kbuild: factor out OBJECT_FILES_NON_STANDARD check into a macro
> > > > > 3cbbf4b9d188 kbuild: store the objtool command in *.cmd files
> > > > > 467f0d0aa6b4 kbuild: rename __objtool_obj and reuse it for cmd_cc_lto_link_modules
> > > > > 
> > > > > There may be a few more patches post v5.19-rc1 for Fixes.
> > > > > I haven't tried minimizing the 54.
> > > > > 
> > > > > Greg - is 54 too many?
> > > > 
> > > > Yes.
> > > > 
> > > > How about we just revert the original problem commit here to solve this
> > > > mess?  Wouldn't that be easier overall?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > What about a partial revert like:
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index 9f5d2e87150e..aa0f7578653d 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1083,7 +1083,9 @@ KBUILD_CFLAGS   += $(KCFLAGS)
> > >  KBUILD_LDFLAGS_MODULE += --build-id=sha1
> > >  LDFLAGS_vmlinux += --build-id=sha1
> > > 
> > > +ifneq ($(ARCH),$(filter $(ARCH),arm64))
> > >  KBUILD_LDFLAGS += -z noexecstack
> > > +endif
> > >  ifeq ($(CONFIG_LD_IS_BFD),y)
> > >  KBUILD_LDFLAGS += $(call ld-option,--no-warn-rwx-segments)
> > >  endif
> > > 
> > > 
> > > Only arm64 gcc/ld builds would need to change (with the option of adding
> > > other architectures if anyone reports same issue).
> > > 
> > > With a full revert we lose --no-warn-rwx-segments and warnings show-up
> > > with later versions of ld.
> > > 
> > > 
> > > I did open a bug against 'ld' as Nick requested:
> > > https://sourceware.org/bugzilla/show_bug.cgi?id=29994
> > > 
> > > If this is this is a better way to go - I can form up a v3 patch.
> > > 
> > > --Tom
> > 
> > nevermind
> > 
> > The patch discussed here fixes arm64 Build ID for 5.15, 5.10, and 5.4:
> > 
> > https://lore.kernel.org/all/CAMj1kXHqQoqoys83nEp=Q6oT68+-GpCuMjfnYK9pMy-X_+jjKw@mail.gmail.com/
> 
> Great, please let me know when this hits Linus's tree and I will be glad
> to queue it up.
> 
> thanks,
> 
> greg k-h

Hi Greg,

  Masahiroy's commit is already in Linus's tree.

❯ git log -n1 --format=oneline 99cb0d917ffa
99cb0d917ffa1ab628bb67364ca9b162c07699b1 arch: fix broken BuildID for arm64 and riscv

❯ git tag --contains=99cb0d917ffa
v6.2-rc2
v6.2-rc3
v6.2-rc4

Needed to fix Build ID in 5.15, 5.10, and 5.4 

Build results on arm64:
PASS v4.19.269 c652c812211c ("Linux 4.19.269") Build ID: 3b638c635fb3f3241b3e7ad6a147cf69d931b5b7
PASS v4.19.269 00527d2a4998 ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 919b5ca1964776926bc6c8addc5b8af4fb15367b
FAIL v5.4.228  851c2b5fb793 ("Linux 5.4.228")
PASS v5.4.228  39bb8287bc08 ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 483ac60fe71545045e625e681f3d4ebae5d15cd1
FAIL v5.10.163 19ff2d645f7a ("Linux 5.10.163")
PASS v5.10.163 6136c3a732cf ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 4c0926311f96a031c0581d8136d09ca4f7ca77b6
FAIL v5.15.88  90bb4f8f399f ("Linux 5.15.88")
PASS v5.15.88  6cb364966c77 ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 623dab2f6bd78271e315493c232abf042af88036
PASS v6.1.6    38f3ee12661f ("Linux 6.1.6")    Build ID: 8b9e3e330b093ab6037a5dcffcaefca84a878d44
PASS v6.1.6    db1031af82be ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 2d848c31fcc31414513fa33ff2990fe6c9afa88c

Regards,

--Tom
