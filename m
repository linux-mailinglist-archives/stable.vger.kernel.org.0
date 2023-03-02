Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369F66A7942
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjCBCE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCBCEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:04:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDAB32E77
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:04:23 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NJkUO012653;
        Thu, 2 Mar 2023 02:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=2al3dXV4cWy9b4/UivxxBunvNvYAODHspZGu6IEr7lI=;
 b=zwKWMH+/UW/MgWUFfj9oSHImibnbemSBoIBP4Xfz0HrP6H0i7ylkz2iXghRFB6Z4bsRo
 3QiVDUc1gq8zCgzlslWMtXHDQ/ZyKESeEbsVDRHHFKuYCQ8Az7E2YWikoQOdZ+ojFtih
 g3kqxKdSy7qQpE8aFcxcfM+DZordk1FhJVKUT55Z0h94nzRXK5QA8Lsfz37p6NsX8CnY
 n5ZhApzynl5ttSJyjoEQCtDf1zs5o8/NoBXqjfmSdZv2Hfdu3DVEsLzOx8R2DhVsadAh
 U0yS+SL/tLpLiGnhJhp5mpwirnirgGwevrcplW/j2JdJ74BsjBEoLCwj24nsdT/JhvmN 7Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7jd85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3221gmR5013778;
        Thu, 2 Mar 2023 02:04:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9cmca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKjucv8lA8YIkjnOwNkFqmg9RxEO1oNHktHjri1Sy1Tx37OENaZqbAMdxo8Anpk9l7XYJcgCJG4R23ZYFONXTME+6ZesBwPdiioaqGYuiwKbatv8y+1alyp6IHwESXQGKyOZLdYIimdIAdQdm4lHGeaB4an7KxBtu1M4RZKHrGQ/vZSXAKEiqXGifA0dTmKqjskVDLtwXnMBGBBEakAUNQstu0wOiIANBHYnjoOkMXfR6mF2szhS+bol61DCmF8iSrePC5t/kG9I8hjJrgW8EWChRZqZo6jZqv/PaquIwfUMPJBoOyFcxuIp1u7etIvTRxASfkpGXxWOogTkl8/k/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2al3dXV4cWy9b4/UivxxBunvNvYAODHspZGu6IEr7lI=;
 b=nRxxMqacJ16rLb0TFiSs+yn3KiHgvLNqfd5yR/4LvD1uO39Iv9P5Y3w4+qsEmgx/b/2L0t1sTjquzBX5FrWiVj8btfbk3epWyruQzg3zYS/Oy8JFp7TeAlCGw/8EcbaK9ZZKUD3XYEQIAs4kfViDGKQun9IgB0q4Y+Gd+yH+AYmOJ17+1bny+qj1JGXtur6svQzPnTz7qcicctybqrYyKRgaJKSP71nJbFLWV8Zvw5ZNclv0donI0GO9pQiYQ+Q1elfNZvvpS4sxLIXkbs33NaNaZif7TR6lUH0Jw6XdGzonLKixlhWCOvn5IwDOR7q1dITQwCTRWlwSWMl8XTR7Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2al3dXV4cWy9b4/UivxxBunvNvYAODHspZGu6IEr7lI=;
 b=CW/OM5anHCTX5Skx/Fwxooj3a39tva2jqI8Wli+Ft41iZhGxkYOxf0YUNCQUpn+r0NjHtNKEAQ7GqoR7bXVf0k9Dacz1WKc3/FPi25/5BXi17WPcNqzkx2w4BjBtAnmPG41ZwJ8prvRSMqLvbZ6lYa6ARJUsQqFrgNgWkwuUjhs=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:04:13 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:04:13 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 v3 2/5] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Wed,  1 Mar 2023 19:03:49 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v3-2-3431a425f0c7@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:8:57::22) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 19f3ab4c-3147-4562-843b-08db1ac26b4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ca7DnGPQVAQuxb9PntWjiVv37r25L8j0i/O83wN5E7ZFg0tVZRwr3Af0eYAmeJAOc+6qtEtF+e7tlwJVa+YvpLEERObBHwFn7eaCsHBDMfNfyM3zSSvXfxDW0grc+C2svLOjNkgZs/Ap56aWtWKXdDWhYidfQMl9Pw3kYLrMebz4yYBcuu+k0H35j8DLpJtR95+5VEdSMJadx2ruCGO1pGl+f/0qq+yY2dUC7RjCPtS4A8lpjHcMV8IjweEcME6cYG9QfPb8lCJ/N8Qmi9+H7zVJJautBKDlGgo6oAg3qulqrPZVoxVyfjNlP3ExMqJdjYODb8gCXh/nenyyVL2LwRvGMkhILQdQilRQuqEvcr5IeDJ3AaN/V7tiaKH6CRk9CIboZLOrlOe1xekCYeZjkK4F9ltZu+ZwS7Sjf30MIH+TPn+M7cdcMCtER51s3X+FstA2aMxCdb7q91yU4K3h2QwR+gauc6BYDiyvK0TIssXSyAGRgHrxf3ciC2FyK6bKr82QqrXnSjFIp2rynaLf9nUIx1Ex4Bz4xuPPtR9mtzPViq17CkM5yg16vgNmGYtfDTMwoggS2m9wVj06F6mJBnLdnZua2BmBF6myXXcWToI0K5Fkec4g5VuPUHad97CbkJ9rwljBpWox3axmHiUpwoMQmP06nWWCTg3KoSZC8JQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(41300700001)(4326008)(6916009)(8676002)(8936002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUI5OSs1TzZEU2FvbFg2WHora2JoN0ozQ3RTc3VrSXdadmYremN0RjF6bzdR?=
 =?utf-8?B?aUxyV1QyZkt5RW83U2ZFTkUydi8xNmxrQ2Q0UDZqa3U5dkZDbGpYTXVKdFVL?=
 =?utf-8?B?MDNsbnl3NjhoMEZrbUtSNUErbFRVNEpEYXNDS3VSTk5DSVJndkIrQnV2SWd6?=
 =?utf-8?B?bUdxL0xKb1JJVjBJMTVvaWZhc1pyVjNDNFBxOHFXZFBaQnB1UVI1VVo2aEhk?=
 =?utf-8?B?TVJVL0tabVNIOWJlQXd4MzE4TE0xcjhxSTBkbkozaGpNcG9iOVBueTNQMk5F?=
 =?utf-8?B?aWQ0WXZKeFhaN3JPcyt2d1VTQnRxWGp1ZHIyNTAvTktjNVB2NmdmMFFtalQv?=
 =?utf-8?B?aVBTNUU3dC95S1Z1SVJmZW00RStBNjc5VktuTVdSRS9TYldhREZob1psNGJU?=
 =?utf-8?B?QWRVaUtnRWo3STNSRzlqeVlXKzZLZGIzRElocFlPVFJXYzNUakVJUEtDKzl1?=
 =?utf-8?B?aDAzSi9xSzRXWStpMTlvejJHTDdubFFvYmR0MGVCanlVNjVUUE1ITGZLWFJx?=
 =?utf-8?B?OEM5UFZKZytMT3lLZkpKRk1sRGlId29tdDc0eVpwdGZrNnhFd0U2aGtrQjMx?=
 =?utf-8?B?YW1rOG4vcGRoWXFIRGNtakovUUJmd29UWnNIenlyd3hCVU42U0t2UWlDaUMv?=
 =?utf-8?B?NGhQM2ZKalI2c3lTQUxFTlQrcEVuMW1qdXBEUXRIcXhPL3hDblNIVmg4STRI?=
 =?utf-8?B?a2tkd3ovL252MlhLU2JsMTlFNVhCWk1qTHVmb244U0tDYWt0aU5CR3U0VzZp?=
 =?utf-8?B?bXVDV1VjV2VENFdoaHoxb3JENzZ4V3BLaFFRcS9vaVlKR1dnRnBwcDV4aHFB?=
 =?utf-8?B?WG43T2FuY0VMRVNJbkFjdlFYSG9CendpdkpuOHZZRTJnZmUyMG14cGF2NFAw?=
 =?utf-8?B?ZkV0a3hMYTJwa2VUMFpRbURFSmJuTDVOalRWa1NYWTF3eUMvNG5oTVVTWnJI?=
 =?utf-8?B?Q0lWWjhzODNOYUpmSStsMk1TRHlTc0YvYjB6SjVvMm1RWVRuU1NaNVNWMkZ6?=
 =?utf-8?B?aWEwRjFEUDltZGkwbXRZYzB6SXZzWVYvU1Y5cFhrdVo5YXlHSEVkbDFPZ09C?=
 =?utf-8?B?eE1hZjdDL0NXdjdWTThvSUEzWnVjK2hEYzhRazBuQVBxUFVHdC9RR216RHg2?=
 =?utf-8?B?bS9RVEdJN3lBN1YvWGpHSmFPNnlmOWFESnVHUitma1JHdURyNHVUSGRwNy9O?=
 =?utf-8?B?U0FHZ3EwbnV6aHlUSDdsb1dMTjFjNFJQNXRETVNCNDRTTTROd2F6VE1adDBq?=
 =?utf-8?B?VnpUam1ZQXRYakNMT2FuRW9hQlJ3WTJKb0R6eEFCTWoyQXZ5NXhRM1VqUUlk?=
 =?utf-8?B?a2lxbWF4TzZmc01hU3RtZHROMmlzMUJZUzFkT1BOMktGaStPWjduK2Z6MTFo?=
 =?utf-8?B?Ky9ZaEJxMlNucFpTejhzcEx1MzBkZTFnbDBSWEpUQThKUlFSbXlVK3RaYVF5?=
 =?utf-8?B?ZlNyeWtlTGFXcmN6WnZhVUp5VVMxUVZhaGsrc0k2cjRYQ3EvVkdQSThFSnpa?=
 =?utf-8?B?MFllRy9yWUM3anFhTll1cUhraEk0VzJ5Nm5TQW9Ia2tQYlgxNCtwMVBBZXhJ?=
 =?utf-8?B?KzlBK0xhVUl5bzI2YjVTVlFkeVl4RDB3YVM2UitESWMzaWV3NFF5UzY3bDlY?=
 =?utf-8?B?U2paSVdVdGFjU1pJcmQ3VHkwWUN0Y25LQkFjaHRiWUJFUDQ4M0lvdE8wdWs2?=
 =?utf-8?B?eHVnSzZBRU9NRFVtNmdWVFB1dlJQZDhmUVpaN0JuREhzR3ZqWDErbzdIN2NO?=
 =?utf-8?B?UFFYQlFjWEdhb3BNWmhObXlyTlU2ZDd3U0dwYnZQMWRKWC9ZV1EwbkFXY0do?=
 =?utf-8?B?dmtnVkU2MlY0VzlZTnRWcWIvOXc4K01PU3BPN0VyZyszeXRUK21FUjlCRUx1?=
 =?utf-8?B?MXVwS1hhaUdxYUJXMmF1d3lTamtwU0swdENXSmZacStPME5yR1NqYU9kaWhL?=
 =?utf-8?B?WU16YzVDbFNtRENaWjV3SEFuK1lBTVU4di8wS0ppRngzUlZ4OGE1NFJBMFM1?=
 =?utf-8?B?MmVtOXVoVW9qcEU3cHNUbmM1eUtTMzk2cnJaY0pabFBvT2NVY3IxZzhHdGZn?=
 =?utf-8?B?VFBwejdNOUR5MzNPVkxSVmRDUmZMMmxWYjJLNDUvU3VNeUpUMWlnNHZOVmNJ?=
 =?utf-8?B?R3pUOHNqWkFQM2tmWW4vRzFEL1Vwd1ZYcDZDZ2EwakxkVXppandGcWhmdGJ1?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tkkI0J/aK/2AxePVK057lLrxfy8dmJFi8ZP/o8O5TfkI7Y8BYo6sxs013tz+8H4bK9l8dBkG/kkG6BHqgrSwzfugRFs3hP4kNB0EVh16jqZwNU4y1EqnlLJSjpGa6OLxkwbaGMpxxU7jMZpB3tDk2ms8LQVp/l70FWjvUcgy3Y96BhE80js1sfmYJz3jsnEkjwb3o7zyJDpsw5qto4FUjp2C7ZAQYPleUMsIUPVdSHnoUTfeaOXOyLI0W26ZvptAoYQbT3H5NkC5QgsNlD1BxfZ4VrIbEGUhG/mupku7l0MfTVl/dKq1RcqM21IvP9V8bZq1VDlT9SlB31GDD3NJXOxe1XcFRsxEU47YzhuWF2T30GMwfebRUM+aHVjDxt1u+rskHdPJwmNcpqjHhqJg/zy3ZPvvcaLfXDlUfD41m8BKuSgzRPlo5BmVU0DtvT3VZndI6wBZr9I/fipO+G+a8I2mAnBNgTiVpAt/sy43lkdsjn7bXjIzfNwkt3a8gtP2ahnB7CXUlQWd29Y/I1w8qVLFuJjR2sPeHlBRLnRFGMi/uMt+JUe56mMc9KVTwdT8lZQ7ILXNukJok0nuN+4umPU1c3QGYLnMjfqC058kkgmRvwHONcJWgUxHA688LugIRtdW7u2VyZYpD0NlELws9niy2opDzDu8FEnAOTXuzKFHh4cXjJYkrQvydYo6IyhaWNgvhn10rSyJU4gX74pXGkmP/0o3C9GU64Ta5VgatcKqjpD9rlEnC6np2CggLBBpR18l56QkSBQykYlf3dv8ibmj6FueVcWt37vLD6+tqOG8zoKrKoACi1HGQq5UH+AbAbGtZWvBALGtrySkHKMYczedPGI7evz+0ao/FzhK5lTir+GPaQvVY/ese30KvWN5
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f3ab4c-3147-4562-843b-08db1ac26b4b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:04:13.1020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HBoCyOw+biG4vgXL+71Jr8vKuf4pXQXnE33oEci7x3tI1ibQtz3UgOH+kd54KTnMn4+oi6j11V1zKV3KYxQrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: wQIOAy9ZAdnw8vgekigy01zE41Oel8Qe
X-Proofpoint-GUID: wQIOAy9ZAdnw8vgekigy01zE41Oel8Qe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 4b9880dbf3bdba3a7c56445137c3d0e30aaa0a40 upstream.

The powerpc linker script explicitly includes .exit.text, because
otherwise the link fails due to references from __bug_table and
__ex_table. The code is freed (discarded) at runtime along with
.init.text and data.

That has worked in the past despite powerpc not defining
RUNTIME_DISCARD_EXIT because DISCARDS appears late in the powerpc linker
script (line 410), and the explicit inclusion of .exit.text
earlier (line 280) supersedes the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 136). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier [1], causing
.exit.text to actually be discarded at link time, leading to build
errors:

  '.exit.text' referenced in section '__bug_table' of crypto/algboss.o: defined in
  discarded section '.exit.text' of crypto/algboss.o
  '.exit.text' referenced in section '__ex_table' of drivers/nvdimm/core.o: defined in
  discarded section '.exit.text' of drivers/nvdimm/core.o

Fix it by defining RUNTIME_DISCARD_EXIT, which causes the generic
DISCARDS macro to not include .exit.text at all.

1: https://lore.kernel.org/lkml/87fscp2v7k.fsf@igel.home/

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-1-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index a664d0c4344a..fda97c3dca4c 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #define SOFT_MASK_TABLE(align)						\
 	. = ALIGN(align);						\

-- 
2.39.2

