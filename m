Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F836A7951
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCBCHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjCBCHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:07:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB94515DD
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:07:35 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NPegj028222;
        Thu, 2 Mar 2023 02:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BZM9yieU2ldb5Fr6vB/dbym8voWzfSvG10S78nEL2nk=;
 b=Ba/6lGOpzZGrJsvJRNibypS9vq8LHXBGc9EUMLxBMOPw4TyDAmm8v5NuXhOeazvyvlVJ
 8V1afqa//IOKvwFJRQSu/B4IARFpysvOz3RAjfaVf/nv0xB4wBnnEs58Jxo+IjQhpWMO
 BzGKS3nAgkha84C76L9Rv+CNCZMOau//VxCYLiUqEF0ASIZfe/S1CrDccc4uwnQswQZg
 cQw48c+VQlxsLK0MUuwY8+xrk/R0sghTsar8eOE9m3fywi11bB1yTPKSxvGSepkoUtan
 xoYHxzkM/mMLpuaJorgWmfxMUOb3j5QfDBhFur4bx5S0f3iYn1LoWe2eSCG1q4cL9mCJ Ug== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb72jbn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 321NK5x0015811;
        Thu, 2 Mar 2023 02:07:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9pg8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4LjzL38yDyehX5/7Qp8Jc/UaclIFFwnhBpijoYprw+5jwUmNAf/ZljiUxXaO+bRJd64W7Tzt8qNWJ2xWsW9HxMMLMa9dbHDY551LryB1D6Xb4/rrz2zgmOFsR+G7jU5kFdd5UzZqFoW4Z0NmPM3KW2K639oZwFpt7I3GKpE+yVYKMOKx0tN21LDP5ciHNVGf2fH/y6Xr29fB26LyQj97a1zvUIfpwRS1kYxSBhVD60MC/gLz4Rp6aiIMezm53SRfXmqAWerBXsURwsoUKdzwmAkC8aLAu6K/zP4Y/+NQ/LJUmDf82FQLKtWYqJeBtP9a8/y5WrDnzmFc0jU9eLXdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZM9yieU2ldb5Fr6vB/dbym8voWzfSvG10S78nEL2nk=;
 b=AL6N8DP2Mdx9tLi40/mCdTXwMCQNYNWaEq8wEewGbDxLp5cB0nBM/v5BcQ/i0NZojSN4EVlcQyvQSKf/5hsScR3XWboq7px9oANpmWYVW2ybh6MOvc3Wl/1+0ymesq/ACkKn1H5xFhSlZwjLwzU7MGujTLdVDCiILSlgXeidzKdxgCjMfa1qQSssPacT/oYru9NPfS5Ml+Kr/qWIezvrnhXrMtnnCzEfm5GJ1xm/nyZfU+CMoRXxWimdTS/fR1Y5jT9j1e7THzkn8Cvr7Ykklrbt4ZZkTCGMSTAUyE6UJffrEK0UTVwAlO7ywjO4csyVUeK/ykENUGr/8/muYK3uaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZM9yieU2ldb5Fr6vB/dbym8voWzfSvG10S78nEL2nk=;
 b=b2junINa0LzNINmuJbx0wzwBxRjoPXB5GaDODn6vAq9q2txgBkVRPx03K8k/ogjDC57nYi6pVCkSLdtu5xRLl/VJTT+JiQjUwueoTufDIbZYVi/y08TtfHrePuffPPCu3He0fXyPxEHOCxsn9oiaRIap2P9w3C65m0Y95eWcrZ8=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM6PR10MB4284.namprd10.prod.outlook.com (2603:10b6:5:21f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 02:07:27 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:07:27 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 v3 5/6] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Wed,  1 Mar 2023 19:07:03 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v3-5-122fc5440d4c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0215.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::10) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM6PR10MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ab5bf69-266f-4d92-0f84-08db1ac2df59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpqV7qi0G8gYF41RCAAhxnKDlvyZQfJk/O3NdpKksPsA+Fo0bD3A+gGh/gWYBYZzIP8nnF3QrAtLt33y+ZhuPRO3rhheREnVUTnRfascUvbDdbUioDW3LlTzs3jWih1cCa1itVsMF87Er0bzserqaQ2Mkr2ZS8LInSXvk+w3b+YmMLdIs90EAnfWAjVYnFrbgH/aeHZQ7AjJ8QV+jwTZBGX5BMzUc0T44jdL7qLsTpPvsXq1XnCA97rL/RbFSHKkEs7gUVxneZcVMCy406XByiwDRhDCPjCz5nqNH5qlZo+r8MShbYcV4FyKa436VeNR4Ld6BAJ8RvtRzcBBpy4J7u9MuNyOVwegvif8+z7ahpuCBvLrmj2H1HO068m66MaoPYKsCNdiCAau0ceMGloGeZZ+ulf6+roEB/nuSetAwuclTGPJzs0cPO8cDt+Rkw8nfhxBxKnEk+YxXavIR6XDTxzCFr05spYx1G5dS2Br7tQ4pcoT1ViXm8YWoRmRmp/hSZM/6d/GvefvQmgW0diQ8NihpsKcBTGoxknYfv0a49I/h/9kdUKSGNjOyOT59omzN7s6ptF/k2UfM/mZvBhXe26BwkB7uIchItd3+45gQ9B/PipPoxvpH2aWPE98DMV/FwiXTOgzzZBam2KIx9Ht3vs+tZ/ZuQXHrQB/aTazCr0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199018)(5660300002)(44832011)(66899018)(41300700001)(4326008)(6916009)(66476007)(66556008)(8676002)(8936002)(66946007)(316002)(54906003)(38100700002)(966005)(36756003)(2906002)(6486002)(6512007)(86362001)(6506007)(26005)(186003)(6666004)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDJ5ajVuNDREZmYyQVhiYWVvV1NObUpyU2NZZ0pTejF5NHlzUWZ0M2Rmdm1L?=
 =?utf-8?B?MEdqaU1NRVZ4bmtFQlJjRHoxMm9vQUptQ3dFQ080YkJySkhqMTliVmxZTTdz?=
 =?utf-8?B?eFRzV2p5a3FacWtuclViY3BVZVRIL0s2MjJHbWVQL09wL25rOHJyNUtjLzF4?=
 =?utf-8?B?ZWhpb2ZubWZlVXFGN0Njc0tRSmpXMVRNczFONzdZaWNhOWo0WjZUOTg2MTFh?=
 =?utf-8?B?bERvOUtSc1htNTJkSXcweHlOR2xHdm9DY3g5WGRhNFc2TUtlUW1kVWFyUExO?=
 =?utf-8?B?cllVT1V6SmU0RDFZaHFjT2lCbHFKK1NGb05FOW9vZmRtc1ZnZzYwN3cwKzVh?=
 =?utf-8?B?cDlNUkgvZmZ0WEpka1dYS1JkWHJ0NVFvclpBcHp1UkFpaHRSekNDemtuVjVB?=
 =?utf-8?B?RzViZVhZMXZ4aDVwYlhuQ0wvWG1adHUvLzZaVmV1ays0QXZRcFY2LzMyTmVC?=
 =?utf-8?B?aUJnd0V1Q2FjMGhPM0lzZXVQZWdKQ2ZNVnQ4SkF6UjJLTEJIbUdVSjFQNGUx?=
 =?utf-8?B?TTM2ajNnNWtxVHhFWFlCUzBhRTd5ZVp2aGlBbzY3UWRtcWhSQVFvamtzYUQw?=
 =?utf-8?B?TE5XQ204d0RiUVkwbFJqL1hEUVdoL2VrcHozSXFQQjk0NGpiMDMwZ1Q5anhX?=
 =?utf-8?B?dWgzeVdvY29yeTVqTzNjNjZ0VUtzeVZONEVXNks3dGdweFNtUXNvMmIvalp4?=
 =?utf-8?B?K0M1bHc2ZUU4T1ZZN2w2ZDVsVWU2WWdvSU1zYTlqaXp3ZVZBNFl4T1duSS9i?=
 =?utf-8?B?OElqOEwyR1ZiZFRkaEFLSXhLeHBjQklMb3pBU2xVL0Y2YTF2aWVrTGYrbXE2?=
 =?utf-8?B?RkJVaHF4OWh1Z1FERnhMOW03b0Q1ZFN4OTFxNWc0K3dWL2pDMCt4TFljYkRp?=
 =?utf-8?B?Q2N6WUZDYWhTbk5RV2w0VkVrRWRqQ1hOeFEvNVUxSkpUcm1Tb2ptOXFPWHhC?=
 =?utf-8?B?dnNiZnkrNCtYZThWbWV5YlNmcFRJUmdHRWV0S1VlZmc2bk8wRmlHU0Q4Sitv?=
 =?utf-8?B?SDNJVTJUWFNlTE5sK2tTOXk5MklPS2ZkejViaEpBc2NJajdGWWZCMlZDbDk3?=
 =?utf-8?B?RDBRbjI0MlFoRzVSdGp5QkdqbVB2MzZTSzBObTdjK1NXQWFERGpoU2hZL3lE?=
 =?utf-8?B?di9aVlVrVVB2NFI1aW80cUF3Z3dPNWxUa2VrSGZRajlJeDRhdEFRVGpVcHVH?=
 =?utf-8?B?aXBNalFLellwZk84ck93MGZZZ09xUFpCMmx1bVgrbmhNemNmVXFwQ08yWGJB?=
 =?utf-8?B?UW9LVDhabmRuaGdqR0RuNzdidmszTGZnNVJ2Q0k0MTY2UDRCNTh0UHZoSitK?=
 =?utf-8?B?NUZxT0c2ZmxtYXF2QWJGY1ZSUnVZeStnRnpIcDNxK0M0R1JkVWZUYmx6bjJ4?=
 =?utf-8?B?a3lubHE2L2NSbVNCaE9qSS9wUnhZdXNSaWIvNmNBSUlUTmNxUk5Rd2k5UFNN?=
 =?utf-8?B?cGVOdWVRVSsweWdOZENIT0k5Z1hHOFo0MnJOUDlvUDVFNTBIR3lsbjczNXhy?=
 =?utf-8?B?VEJFODdOWU5RWEJtU1pTbmlCcWoxZzVKRmZIS1FHOEdzZHVFY3BaNEdsQ2lS?=
 =?utf-8?B?UC9SdDZOYmhqak56RHdUcENPajZ4UzhmMDQvakp5elpjNFlxTUJ6RThSRHQ3?=
 =?utf-8?B?ZlRZWjdOaFEzcXNuRjRvVEd3RTl1YlhhRmVoS0tESkpLRW02NWFpYStvbHov?=
 =?utf-8?B?QmNPNng0aEpuMmt5VWRjOFpjUkpqTW8xNWxKK28xTmlCcXFlNXIzYjdTUHBu?=
 =?utf-8?B?QjFFMGpqVzVBcDd5YmNXZzdSaHJ3R0cxZUh4V0lGdzU0YkRiMVF4R1Z5VGl0?=
 =?utf-8?B?OVJMeUZST1lXTlhoYjE5Mk5OTDRmanExZXNzbFN1bGROakthdDlXMU5nOWtB?=
 =?utf-8?B?N2phZCtybUFvMklXeGtjRmI5ejVSbzd4eTNPclAwNERlT1cvYXhyaEM3dkNo?=
 =?utf-8?B?ek1VUTFPYjRjU1JiNGwxMVhpeGNzT3h0dC9tSGFsZUR3YWpIRkgvYUxocHpZ?=
 =?utf-8?B?UHowdkw4SWt0bXNpQ2pwZnVqZGtycUd6VUlXM01pKzBMSXJ2L1R0U203Mkdw?=
 =?utf-8?B?QTFRWWV0VG0vVU91RGo5TFJSVlEyNFFxTGM1TTd3NWlvVllYRFVxMCtpUjl0?=
 =?utf-8?B?cnpOSmpUUitnSlRYUU5tdWJJWGJySW9TaVlwSlRURUs5Z2Z6MXNweFRlUEhj?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yYlMqzBABCfoVHnkAZEjobE4v5vI7BP9nCM01pHvbQMucvnQ2OstOGIhuRTN832MafXom215pmS3vX7fObODkdhs4v14uu/uS8jwXSLPBbAdFqQETn8zkcOZMqz5FVd3ftrkl5YiinJXpyxwc/epLhYdAp5ZRHmCS5VKgCpG6+d3uMsOoWTLFVsDUCnWNTtNHv0KoQM+m60IgsE6U+itIVBHmEL0mGJAXF1cNt4cPr2x6zV32lnd+CTrd2gcIoGK3oqSi2CEIUku0167vIQIG/N3ESLE5gtZbLMYVvQ0vi2fUiJWd5HTtRxU3/1hGJ42EwP+gCAyH8jG9LP5U6CEY/KxEhpo/d6oHUo0145WxOvgyYI1I1koVu3WHO/Xm6Mte1NdBZcURMzfMKKE/iD7A3yT+zAZD2UZkKcOD1K9hZsB8N+0ABoweJguHHzjg4rCj+vhraiCVDC8P73/whYUuJ5ncp6WyAbdi4SIjRC/TGNwi4QTlnoSdJ14C+kKtFUT084dbf2Ox7F1TUoo3LiptHMxyPs2uXveJ9uVe3eW4E03n0pJq33Is357iZ64l/bEXyFAuErydDbQ5iJtJFC11sUZlX2JzNFIYRaXbwtL01Flm16e+gGzqOniyqhpTmFp58juEQOecNeP3Tt73Z/ko50IH9H5Pe4O2FbHlIwxppWPkpHDQaezYiGF6MYHPZRJTzuN6P0EXv21Sg63GAOUNZdRtwrQ+hMA6FDjJ+DonsIwFzhjeDVgUG7oY8AxubscDPbMlFnlsR7JhaEO0KLVl0944mf/rbyd1YnnpPW650FodLIG2RrtUsF8qnfX0gs53k7L5m79F14KxjMuVAJJkw2MmwokU0tTLlPTi4OwzGhP+xyyiX+arR194qMRDcza
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ab5bf69-266f-4d92-0f84-08db1ac2df59
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:07:27.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05Jww33FqtE3XpbgV2ivpyX7MLVAw70JYmK0k/hifMpZ+bcTcCi1wp3gq8LHRg88Jq7wkdomr72xkl7yD/v7eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4284
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: ndg2wfF0wyvVpRS5JjMoRZlNYZR0iYBm
X-Proofpoint-GUID: ndg2wfF0wyvVpRS5JjMoRZlNYZR0iYBm
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

commit a494398bde273143c2352dd373cad8211f7d94b2 upstream.

Nathan Chancellor reports that the s390 vmlinux fails to link with
GNU ld < 2.36 since commit 99cb0d917ffa ("arch: fix broken BuildID
for arm64 and riscv").

It happens for defconfig, or more specifically for CONFIG_EXPOLINE=y.

  $ s390x-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- allnoconfig
  $ ./scripts/config -e CONFIG_EXPOLINE
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- olddefconfig
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu-
  `.exit.text' referenced in section `.s390_return_reg' of drivers/base/dd.o: defined in discarded section `.exit.text' of drivers/base/dd.o
  make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make: *** [Makefile:1252: vmlinux] Error 2

arch/s390/kernel/vmlinux.lds.S wants to keep EXIT_TEXT:

        .exit.text : {
                EXIT_TEXT
        }

But, at the same time, EXIT_TEXT is thrown away by DISCARD because
s390 does not define RUNTIME_DISCARD_EXIT.

I still do not understand why the latter wins after 99cb0d917ffa,
but defining RUNTIME_DISCARD_EXIT seems correct because the comment
line in arch/s390/kernel/vmlinux.lds.S says:

        /*
         * .exit.text is discarded at runtime, not link time,
         * to deal with references from __bug_table
         */

Nathan also found that binutils commit 21401fc7bf67 ("Duplicate output
sections in scripts") cured this issue, so we cannot reproduce it with
binutils 2.36+, but it is better to not rely on it.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20230105031306.1455409-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 4df41695caec..a471bd480397 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/vmlinux.lds.h>
 

-- 
2.39.2

