Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282786A7941
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCBCEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCBCET (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:04:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFF932E77
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:04:18 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MxWSY017246;
        Thu, 2 Mar 2023 02:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=mTp+SxQWMn4zKRQXN6tTqahaZ+eyRp/NRqwah3Odasw=;
 b=vpsQ0IihXHYxCoDUbb1B/ikwhcWy0YuxDA0pgRiEVd038hp2O6NS68H3jlia0Fw3Z+xq
 sOEkGJoW8a+3Wa7NsYPeKhrhSzOlM3tItwdyVxU+h5CvgduYB3T0lN+oZf16G1pyB9V0
 H/W+wFDSmYpz66p6x6N8N23wkNqCXlvKLwzCBhryKmmilElMJzwhcjuPVdYL6Afzk6Ef
 6Qpp0Xqb6PYT53PaHLyzzA9JTdRUJHCdOntsbq4AmiIN1vjb2FeyasvbhJuW0xfXxgpt
 1+iLRiCvc+qvjWmq9oa7Qw84GdwwKUEgNwZ90TppQd+6CbkfwlcSY4ayv1Lx+M3AK6Df Tg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nybaktgqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3221PEqg029323;
        Thu, 2 Mar 2023 02:04:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sff1yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6bPP22tRfw8v5sXJSD67DyIhAZuamkcUEOEgSJZjtlA45x/HsrtCjUCYex5QYoXNmmvHd4NF+9udrvoyt2aURykA5F3iqK4MCnmmgFG9rxuFuc1OpNu7PpnHltboAFKdjW7S9ZPJRKHL83eNgVTFEsIDzgE5cCPPBrNlm7fX79rWOBGF+ubucIaAOSCh1MAim0S8GZhOkDxFeAUQb4ceYAnoAg2m/DqMnmWLKh6rsWVGcMYLGEynmsLs+g34f5gVKVLcUjDfJDW+r1Xyg8ss0vsskYEzUE2K1HjIZBkn/gygoIf3vaiN6BTuApFZoawtHrwWTR44C5Uy9Ya8b9LXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTp+SxQWMn4zKRQXN6tTqahaZ+eyRp/NRqwah3Odasw=;
 b=Z460v/YwngeOExwkZI6iXJMS8ChL6rIP3DRk8tcySgUhkIpGLznfB2xZhk3SLwQH87K6AYMLa70ARiok+xuTRX/KksIEhYTPWVbM/M+/nDnMrr2KUcZ+vvQzQ/mgnBO0R++1e0oF9vECCMf2moe7nLwjHtbosE4Yc61WTUj/bcfs86KE+5OjKIQFB7YdNVmY4DcDH92/pi5J2/NbucXdoU3El6PxzZjEBWcSOjdTz8NdFL8EttSaf9yTEY3WM3b8s7jLg0mirRstyyWiUPy5xZG2XbqHzlkSFB92OQhGi8XSrul95IG6ivHhYi7hj9D+R4lji/ZWIcfqeur1iZqnsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTp+SxQWMn4zKRQXN6tTqahaZ+eyRp/NRqwah3Odasw=;
 b=YkKTzM7NM0bTbBXi9+pUcH1xM7ePJJJ5cfe2XFjI9VTpIJjozKNcIuDUBxuEoeOAUezehNGURTq8pBa6IRAFrZqkztF8P/78k51vUF4IXe7WE3nb27ESkhynA2wv2hO/TiCPpyVmDB8xK545fRUoYkgp0J0pxnXMyGBtg1cU3ic=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:04:09 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:04:09 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Ard Biesheuvel <ardb@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 v3 1/5] arch: fix broken BuildID for arm64 and riscv
Date:   Wed,  1 Mar 2023 19:03:48 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v3-1-3431a425f0c7@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR18CA0011.namprd18.prod.outlook.com
 (2603:10b6:5:15b::24) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 44d3b927-4c54-41bc-cd59-08db1ac26943
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FC9E97qYZmRGlOGBaAd4k0qwIfoyzWBfrh8vW+bwliBvBzJ1U+D3wxNmK5gEhQkkbjdXudmk2V9b0PWsd26jKbIitsr4MZd5YIJD0UkkxOTjuNteiIc0w4PIvThD9+Pcg3ZITnkxsw/mcIe0vZiUmwDWjbAfIcwF7NJxLH86NdQTZWifqSHdBwftfeH8qn+tmcyAr90u2xP0qmBKgpVMePXLIlu+pwQZ00wu/qfYAArGizXEIP+wbVzDkLImwXK/hNHIsuh5aIjsGTv2vGsSr0pXKtC7v+xclvhMkW/PYmfy5SxaPkSVkYO1u6CugsIHGGKaojlhMSqlhiO0TCRQ4kesFZPVSXgKaV4jSQhnlTni8RNhvXVt8jc7/nHBcKLQYBvzQOX3i3L9F5JuJocqwWHE5nI98/K/mDzCRynrs10Xy1Pf+6yIW2wnW9Qc0m5Anty2AcrYixxAqs0s269T/r3/o3GS2F8hnibsA3XkIxgRW7c2V9/AydgHs5APslRMPmlW6pB4CxPc4ZX4GMEWUCX/CemmeLCydanjmFY0D9yY/zy2rcfRK6ukn0aRz22rlOiMxBNNzwi+Zf63qaJGCmbwVawBfYMC9nS0QY9j+kG/KxXqAseVKLpYV8BRhz3nZTP+DoUWX0dTV/Pr/ZR9xIngZbQE8/U0Ou7JfR0O1Qo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(8676002)(8936002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aU4rcU1xaWlGeldOeks1b2hnWkJkZExoR3A1ZTBvSjZmRU9HV0EwSFdEa216?=
 =?utf-8?B?d29kd0I0V0pFK29MVkxWVUxTaGtqL2FTN0p2V1lNR2s0bCs0dWV1dStVbncy?=
 =?utf-8?B?dUFqeTdoeHlTK3NlOFJUR2NWVjhNdnpJS3AzNERPbVFUbG4xaXkvZko5RVZM?=
 =?utf-8?B?aGtwN1dJTDFlV25VRXRoN1IyYUE3OTdMZ0NsQkk1aGJRd2x0MCtZdFJEY3lG?=
 =?utf-8?B?NDRSaXZjUlN0UnU0bndIcElzYXZ4UW43ajlVcEpncHMvQzBTOTkvYm9hNGFK?=
 =?utf-8?B?M0cvQlAyQlVRb0g0SVlUaTc1M2RFZkpBSy9zSUJzSEVCZjNaSk5rUlZzSktK?=
 =?utf-8?B?ci9tWjhPeFlHV3VlVWF2WFBjQk96YWhyZmJEZDdlcVV2Nm5JYUZvT2tmWExG?=
 =?utf-8?B?NytTeXA1UGcvbGlHR2RNSXdEWThjZzFGbGJXKzRVdU5OWlRZM1hpWllCSU1M?=
 =?utf-8?B?dGVQdFErYXlGbWxoTUdwMnJMMWNLSnR5YVllQXEyMG9xb1dWODZucm9GM2xX?=
 =?utf-8?B?TC9ZYjVwY3N2WGFDa3RYNVArYmhxQ09IakE3U3BLS25GcWRwQUVqK1FpbjVZ?=
 =?utf-8?B?YU04eVNYN0pWOG1maGFkbldHUnByMWkzb2tiRTZVclNEd3JSaEcxNHhiYnRK?=
 =?utf-8?B?Vmg3YmF4dDJYZURDaTRIeGk0VGtIeThlNXE1YTNid2ZCVmFZRWdMWk9ORXFC?=
 =?utf-8?B?NG1KRTdETVdWQXJCdW9KL2JWdk5sTXkwSUlJeWxqYzh4cGVUT21CSjU5L1Rz?=
 =?utf-8?B?bnVOU3BSeVJTSFdxK0ZETnhERzRSV3VqRE93bnIzbU05QytBUEUvaGI5bSsr?=
 =?utf-8?B?M0FsL0MxT29MVGpaMVFVUUhrYUo1dnQ3eU1lamNycVJmM2ViZVk1c2NiVDBW?=
 =?utf-8?B?alpWVktkcTk2cGgyMnlIa05TYzJYSWhpRVMyTUovcGR0SlpFSmNNTVNCRkxi?=
 =?utf-8?B?QzlQZjlXSXNXNUkyUCtjTGxXN2xYYVNkYVlVNnIzS2xKM0pHVU50OUNFNERS?=
 =?utf-8?B?aFhaYzRRdVZHcGpGR2lBa2FIcXUyZXptSHFRd205U2tObk05RGszQ01jWHZQ?=
 =?utf-8?B?VGRoMTZmdVN5c243NGMvZWZVaWIwYXJmT0ZiaW1UNkpJcnp3M0pkRWpDdE13?=
 =?utf-8?B?SjRXZmJHZmRTT054SXZmT2sxMzJMRlNaRTVYeWttSHhPNHE1ZGV3dCtVZEpO?=
 =?utf-8?B?WVA4V3h2WkJ4ZkQyYlU4cklpQmo5Y0Y5a00vWldWYkFuQVR2UG15cEkySytU?=
 =?utf-8?B?ejV1MXlKM1JhSTdCdmFqMVFqQUhTRkVkTUUxdk5oUVEzWW5hUkdZSWswaXBV?=
 =?utf-8?B?Yzc5bnI3bnNUd3N5L0lGTkc5R3p4UTc3bGJmQnh1dWRWVWI3eDVzYUp6RmVk?=
 =?utf-8?B?N2d1Skw3NnIzY3l6VWtSaEFYTDA1Sm5DOEVqTk1PYUI5UFRDYVVXMld2YjJz?=
 =?utf-8?B?QmxHc3d0V3JiQ3VnL2YvVzBjanVYT0RGU2tZNFRWY0twQnhrcHpsOERrZ0sr?=
 =?utf-8?B?NXQ1NnRORnBLOHlyV1RySHdNRDVFU3lGRzRkeWlYNWZHellZNEo5RXJtK2hR?=
 =?utf-8?B?Wmt6LzdpT3RtWGxBQ3ovUE5aSStkNUZjUjFLUG16OEk5SVhQWlJNYURkNjVi?=
 =?utf-8?B?eEZxVHhWRjgrRWtyZW9tTCtURm1wUmZ1VDJOVi9KV3hCVEV4L1g5Vncxd2kw?=
 =?utf-8?B?YzlmbzdNZS9kejcwVWp3ZFdHclU1MEVJWi8zVDlWUXZtU1ZYNG9icTJ1QS8z?=
 =?utf-8?B?bVJTTmhzN0U1YzJjOHlpZ2t1bjgyOTFTK0xYN1ZNdDhjMW5KS0JUeWNoajlk?=
 =?utf-8?B?Y1o1WjlBdkRTSmJwaTdJbzZ6SzYwSHRucTYrcVA5TDk3dzUzckU4VGM4RFc0?=
 =?utf-8?B?V2RWTjBCbkxBZTluYzZTblBWMmFvRHM2d3psQmR5ekhUWURmZGc0WDhhWEl1?=
 =?utf-8?B?cHpHMWJxRVdIWUs5RzZyMVNCRDFoeUZHN2ZnNjJMa2gwWWdVQzdaay9MQUR4?=
 =?utf-8?B?UzRkVmdTUkNDR1J1aXVPWmNMZjBYMlV5S24xUERqakVHUHRVY1pXQ1BFekVU?=
 =?utf-8?B?UXdvb2J1WWJvSTh2TjZCWVV0a3dtQUEvZ0VmU0llLzVMOVlaZWdSNTBxb1pB?=
 =?utf-8?B?QjBaYXZCcmNiUXRnQ0dOTHZjV1VKY1VLTFVBUHBHeEszNXlVOStLNDUrb0xS?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: U1tTv1oGac0HGTLUfHuKVlwxUjQcrWLshN8dfHB+k+ydXeQuCAq1WYkPr8zt3MV353dH2MRvclP8bJeSyBIfwJld2GJt3dhs+7BTIssd5VPWAdWnHVw+qNHByKJaytMsEJdrCVHnJeGfgxY4Sg9f9/2A9148WHYhBpw4VgsaV5ReVKgj/LMApEfbyMePkWBciW3YZFfWG4E+DwMabYymhnpA9N5ehE+GabBNFPBxxuk4EEWlBw3X6FtqrDAS3TZSswfIG2QwL+PJbOI6vVk4xo++u9YfT7UouipDPfj2KQPjMIWVnVff5KMfwydJR6eHDd0xvQ9VKPZtcyCvN55BQ+R3v1rsSOH+4BGaDzDx5Dtqhvu6aSu3vdxcNrrtAlm2YrU6eT/OcFn6W2G0O5zsZBqL2W+k+a4HYJwIWWtD7Z+cDVZ3MgRxqlcJlD+X2k4w5YxXX5WQ6RMpkMAEd6jfFlX74o2zgNtixxC0+uqujK2wW7+JrnWlMoibdg4jLz0LhqJU6ZLGlKt7jpMz0TuTNCV0yXHZaPTgTxfu29gJu9/npasUl/sa6u7geCeI1t9q9fLywEVreJIcRfo6OZ2s+S/m6UMmOcZdKloQ47scar6Jft3JOtxhvU/j4CwtrBbwZx7IddSVU1rgKHUeZzrM5CqeEgR4e2YxBOehU1rF7owLRxDd3TudaoKvhRtr9Ke77i+YwhXXQG3bnYXOIq+/NbahRwvj4637q2CGS5VJTTTKGNoVhFEoQga21VVw56ctbbFEiEpkma9eonnwyLlvc48wvJtgpsFE52DyyxXWZNDN1hqeIjEXjxJOTdTWLWkiTZExfKi+W3md3ym7wql+gY/1EH29LFGXEM58FgPmmrTE6hiRIiE2RoZh7QbBhJXLHY5LLVCkziNZG+U18SWhpw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d3b927-4c54-41bc-cd59-08db1ac26943
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:04:09.6804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktdUg01RyhMBKypJI1G7cJI8ErPGe6Mrv1NYMLPnDgUjQbvzpEOKgXMQoPPZw9K6EZe1PUIXJUy/kUPRSulQug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-GUID: RBhor8LU-ygMxg13RgeEdJiF3__fyUbz
X-Proofpoint-ORIG-GUID: RBhor8LU-ygMxg13RgeEdJiF3__fyUbz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
[Tom: stable backport 5.15.y, 5.10.y, 5.4.y]

Though the above "Fixes:" commits are not in this kernel, the conditions
which lead to a missing Build ID in arm64 vmlinux are similar.

Evidence points to these conditions:
1. ld version > 2.36 (exact binutils commit documented in a494398bde27)
2. first object which gets linked (head.o) has a PROGBITS .note.GNU-stack segment

These conditions can be observed when:
- 5.15.60+ OR 5.10.136+ OR 5.4.210+
- AND ld version > 2.36
- AND arch=arm64
- AND CONFIG_MODVERSIONS=y

There are notable differences in the vmlinux elf files produced
before(bad) and after(good) applying this series.

Good: p_type:PT_NOTE segment exists.
 Bad: p_type:PT_NOTE segment is missing.

Good: sh_name_str:.notes section has sh_type:SHT_NOTE
 Bad: sh_name_str:.notes section has sh_type:SHT_PROGBITS

`readelf -n` (as of v2.40) searches for Build Id
by processing only the very first note in sh_type:SHT_NOTE sections.

This was previously bisected to the stable backport of 0d362be5b142.
Follow-up experiments were discussed here: https://lore.kernel.org/all/20221221235413.xaisboqmr7dkqwn6@oracle.com/
which strongly hints at condition 2.
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e28792ca25a1..8471717c5085 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -903,7 +903,12 @@
 #define PRINTK_INDEX
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\

-- 
2.39.2

