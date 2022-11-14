Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A25628968
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 20:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiKNTcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 14:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiKNTcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 14:32:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B229929821;
        Mon, 14 Nov 2022 11:32:41 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AEHPkRi011027;
        Mon, 14 Nov 2022 19:30:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=qOtJAqjAcnFuWul8du9WCIizBJNJpfKUaYoDOIWUtgU=;
 b=eQSmnaY969hYfoklua7DqIiD+Gc0p3EnNWGbtiBT0VJixTFhN5IBCXfpaXSgc0ZCsYcJ
 jMlfTV6NhenpGmKKsDlRlIw2cHoYkgmwIut3pzfpjygcVIVg+V5YawaHp+Kf73giGty6
 cGra2ySD3KrouQ1XTfcKkLi5Z0A4l2Dd+pFdMlB+aNXg+pbGbENoJlJB0b/ZzGVML/GM
 M5gXFJqTveydLO+Y1gjXptyBXZT0n2Js06s3yX7JRkiuWFoyrV2LEegvLvFBa/vIJlfc
 AG+fvKTl7WQIT+Jeq4rme5Glp9452q2rPjhx/ET5VTzww9gvN2JhvgIZUFEyppXdpKvF Yw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kut2f0dm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 19:30:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AEJG8RU019462;
        Mon, 14 Nov 2022 19:30:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1x4kgb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 19:30:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3AavNQAb+ngOmLW9EkqF7hGV42ncG1Vml04KJcjA+tpWvp6CljwKdBnqv7d1+36q20R1apGtFSwnUDXgFGAtsK73FzD3kCdwpz1SfnWBQRP5OLc5kRsCqCGMjG3jZhrbRIGUz9bTbuIpvVeOqYYsh1lrfm4azfOMsH8Gis7OiPLUrF/UytyiugNZ6kmngLMi6qEpIpxl6pYtUrSJZZici6Ii4B1txactXCQlWReuLjurV96DKPlicjXjCv4MA2RkH8OeYkuaZQ6Sykhgb8Wnp/uBhkeB3fPJIYpxSf44bTpSfVTmX0SNy54jVXgdKc2qqJF012lHELzCUlXEmMkJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOtJAqjAcnFuWul8du9WCIizBJNJpfKUaYoDOIWUtgU=;
 b=QBsgjk4h7JRcQp50Xx3lok9MCX4fmH0YmrdzJrVt6whrbUbnFuja0D8vjJYQ1usp5b/4RYVpXo1MwUT7B2mnMsywoQH4NH7D5PsmBDIHiw0r7GkjuSkIEYA28/hKDkejERNcttiv8CFZp0oqgZ5Agrs9HFNYjaVTGgjgJOrzqtBskGiKdVXTack5B5jYoExXR9zw0l2t5NNOkMVu+uBdosLrJKiT9rkLqcF60rGjB9P5aPdzmc2xrsjmDFdb5Cy5JaLOEj/QJhLbf4I/BcJI7Aa/JQTavEICNICYtpMfgGXAwS9JImokznlDBEjbhuUgyR7nKzXrREnczQ/Ef1IKHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOtJAqjAcnFuWul8du9WCIizBJNJpfKUaYoDOIWUtgU=;
 b=oTvDzPYSvozsSN5EgJNaS9ml8nuUD0OLgIXgV1p7+wWgIwXLZUQuCF8rtKci5nPL3HL7nn7zW4N7suauWx7x6qo/X+P6GjHDNqIgc1KZJf2ESK6YMCN/aJUU/Au4WKM2xH/TArfJLYxfX4IrjzpTYExZTInL5H6RGxe2cEKdFeM=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BLAPR10MB4833.namprd10.prod.outlook.com (2603:10b6:208:333::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 19:30:16 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 19:30:16 +0000
Date:   Mon, 14 Nov 2022 11:30:12 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v9 2/3] hugetlb: remove duplicate mmu notifications
Message-ID: <Y3KXRNXXOPmJS+gP@monkey>
References: <20221111232628.290160-1-mike.kravetz@oracle.com>
 <20221111232628.290160-3-mike.kravetz@oracle.com>
 <cfb2e9de-3bf8-6380-f336-dc3d7a5ecc29@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfb2e9de-3bf8-6380-f336-dc3d7a5ecc29@redhat.com>
X-ClientProxiedBy: MW4P222CA0029.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::34) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BLAPR10MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: b390ca43-d9a1-4c5a-75bb-08dac676a830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgms+vHCzixL1RzWJGbJbAOokrFhg92ZRBvEUY3SAP6IX5xQvdjh4B1oBAZfqbkj2v3SIG9OOEnyjxt+gS9l9f/pqfUCgwJzjjsGnEqhIa71g3Ox7VWhJEg2KA8kUlqgK7EMl1/auEbq91oZ7F2DdTXj72RhgoDBEoeInIzfPhN/B3kqWG+Fh4Mf26ovktEbzhR+Kd2kXtZMHRsGnd7z6jw2SzxRjyVMDZzNaZRub1haBKZ8nsSouQdGUSCajNQS+gVx+jh5MOvdxqMLiNhDHyV1wbK7W7HSooSKEJBIsAS8AD2v+xgpsQKs9AE7x6GeiXjIfjQU32oqR4va72zeY2hnh9b41B+npX6kNBHJlMzs1Rh8bc7DmwsOVPoE0j/KMWKOxGkAn+4lxPwAGAxl7R9RxRW6YmW7ra/wLG4LXD9iiXc/oCOmpoupzBz8yokZoqW4/k2iSu6Q/hMDTpvV/iER2hCj4DLr9KwVLrT9XqQIlqSaHTyoMPkRwTCbckQTI72ZrML13CkK3MDNPEMBCU5h36EGNcM+vVfo4vqn1VySkoeppxe9SbZO8F3n4rH32kE3Ppdo19kjEWSlBHhdopM03ICPaRfDhwVf3dwTCR6D3NUjA3o+Uq6B5leh4jmA4HIamxxjdzPcFW2dzuVUoq3ja35iVp2j3X+crJgiSncGYoUn2uHIRwRj5O75Mve668RUqPwurlCBWtMRgAUyYH/QOAYKCeExOskQoxnXiuvPGNM4Rdna4gqnA0uCx09m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(2906002)(44832011)(15650500001)(5660300002)(8936002)(7416002)(41300700001)(83380400001)(26005)(6512007)(186003)(9686003)(38100700002)(316002)(86362001)(54906003)(66476007)(66946007)(8676002)(66556008)(4326008)(6506007)(6666004)(6916009)(6486002)(53546011)(478600001)(33716001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jLOZALjoW9B8N+gPQAiA7+5QvuovCQwQQ1dhWtmgFaoxg1kZIURrXAywLS7r?=
 =?us-ascii?Q?ZCmAMXS3dY0LpFtbbSJ6FsjonY7vO+l9ye7YrDgbMgZewIQLdKCiFpbfv51+?=
 =?us-ascii?Q?yJgSvGBaXpuU1BH7Rxp/FnJc3Ho7ohRLE/Ytf1X8rLNh9DYWyuKWCuaaI8kO?=
 =?us-ascii?Q?QmdxBVf9ZGJSaRWtE8gyBZFZG7clvG6wAyNmqP8CNs4amfodi5FlcDa+mreo?=
 =?us-ascii?Q?hVELfq1CcfABA3oWjHq92Hwl/hKujpSKwvWCbgY4R+wWWPfT+LoccikodulH?=
 =?us-ascii?Q?4qvJRN+j9kUE5F0kDR61kT0/WRCxU+fyKQqUWACauzGjjuFNGTxnvfYjDfe5?=
 =?us-ascii?Q?lm5BkwZDl+0rwShp4mV8jPS2sDZNSHrzr4qHfsuMs/TSANXDN2Zw6BL4Lnxi?=
 =?us-ascii?Q?vqhpXSCDrr2qp/zHVRenL+9KOVHYkjwwyT4UGxgkY6en2Tt+VVEq7AvVZl0p?=
 =?us-ascii?Q?S+H5CDP3hxzdSYGtwK0ijJQLR4WGB8+o1cBgg3pBg60F4ZMy8zo0ZEdls9Pk?=
 =?us-ascii?Q?39L1FZ4qVnQrwZ5gSG8aswxMCL0INtxV9zInAmbovUFetzye2elVCrQdljLG?=
 =?us-ascii?Q?f5pBhvQ9dOVQ1lnjtwKfhRuCzfdFWROvhrJeGgDKNCYYJnjdTXbgQFxW1YlJ?=
 =?us-ascii?Q?ZyUKVCLpPcqtJdftpP6n/fduRVzPpUTsk8Pm/fSO6JM+cXAMpV3zqI48Tir6?=
 =?us-ascii?Q?XAbdqmzu/K/hcoCLFTJ09bBE5r1ho5clJr3NLX7gtf4hI0ogOdluv17o/2t4?=
 =?us-ascii?Q?CxM3+MnQtMb62LPN1XuH63Hs33PFbWWi89cR13nx5Ymu7feu7IO9RuiRWosU?=
 =?us-ascii?Q?dAg/uta7ahTbBVdKllvagI5yrFjVOZSSIL01gYJqoByXvobJfRYWKBJRBjPg?=
 =?us-ascii?Q?9yUxdrLwdNYGg1EdcZ9FeWX1IXYtw4IIn+6ufng1q8eVaJwuIekAODIrA1Mf?=
 =?us-ascii?Q?Ikh8AWD53+gcAUWnLQaZMfYQ4PUmnatXRXzmfvnlZ7Mi0fnefxBMSxADGnNg?=
 =?us-ascii?Q?RLYBRnMLvYVs+jW4RCEaxnH6lRCGm8AOU8dcMuRdP+HUykn2p8y6hgXwYbJL?=
 =?us-ascii?Q?AsAR7/PQTxpBmuPfmcyKjZq5G8sKQvAwKqQ/6QCOXMm0rK5LRJlSTL/FaTlj?=
 =?us-ascii?Q?t5KXyJJZoHxRClBf/aBCOhj/CSwIF1p8mfiDXk7n7FK1q895MbR7mtoefW/5?=
 =?us-ascii?Q?wW/HKF0qaVaX/ncl8EzvV/+X84fgjWcVKek5kjMb4yfZhibEuYSj+7qj8xYJ?=
 =?us-ascii?Q?HHc5URSMNzs4rXXhJRV7O4LmMuak/A7f7a85r/oEVqVAw10JHi8Cgh2u8QW6?=
 =?us-ascii?Q?GSm8FUFUiKPZmG6k1cDifhZSoUe1+D4ecWKIuFiZZ1465WYyUWYE0Eorpf6+?=
 =?us-ascii?Q?j2gJEXeofD00mQAnI29HWHUmWTpMWmTDswyHBTCrYuLMGCcB3Y/rK8B5rSmV?=
 =?us-ascii?Q?LrShDddytmDyDQ2bV+U9qLyCQ1hDgccfP2v6plauATUwAhNB6doa20jgWryV?=
 =?us-ascii?Q?LAn9p2ypAcpHugSmMNDJWQ/Awxi0wJz/wAN0xxRQdmqvPDUhRl0yohcXE/1B?=
 =?us-ascii?Q?HbZkrxs+2+5LU4BtIw/iR20yAqELOh2bOYYmgBJjmTUUkSj+4AB7l8sx+pX7?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?UG+yjL+F86a6REBtpPQxdAZ6dWdZP5f3NitJ+VeAhdV5m54fJIoIoSGhHsbr?=
 =?us-ascii?Q?gPCAK8oku9SZ9Z+kw7BjkNuSPSm2s3Jb39xS/chCu7kLO59YprID3ivvblg9?=
 =?us-ascii?Q?Qprm4UNBs/aJX/3DwTKAk4iv4R+YsAQlVWZ/z/afAPH7e18bXSdm9QSMLHbT?=
 =?us-ascii?Q?590Kq8z5zvGLaHPifP24TeWZhyXpUEEzEzhAqNW12Q9duPq2Mi0x6Vf4u4j6?=
 =?us-ascii?Q?2Ilg1y5HZjCTGl/uHN4DSAeb/mqRl713Pcjt7u5F+TzRZ9dtU0+dCcBtpfpV?=
 =?us-ascii?Q?TuSHNBAzR4YMNEFmfPu1c7BemjIlOg0wvg3CqpEFMpOQ+Wb5GqBL5hNKoOvn?=
 =?us-ascii?Q?FSUfZEHqTyBX+plknYqXNOpbHyyd2NCwKtwWa5uuwAIwRVpeES7/0G8tqXRl?=
 =?us-ascii?Q?KBJI5zOvoj7YJ9k6X/HsYnJ720fWwp0Am8gAhXPXsu9AZwzhBKIWRtZ/FchW?=
 =?us-ascii?Q?iiSMq52OstWy7grs+MT2Yzum3o6c38HWEK58B43T8kjUPLb9N+A/7tWU/uUe?=
 =?us-ascii?Q?Vbk7oPCI+KSnxwSHEVbYf2WHUC+IAJFe3C3ItnHckTaXqtQCovokoD7NKvI3?=
 =?us-ascii?Q?gvGrhWLkEAjSgBN7o53CAk5LoqMXARVGfFvpHHF2PwoSgQ75FLltd5nZyaBA?=
 =?us-ascii?Q?T44c38OZoul+qOv530A5zRLrZmyoCDDmGEOyD2gkMFo8jztdRhDp5huf0GH8?=
 =?us-ascii?Q?+mGkq/Lm+p+ST1GiWgRVCkOFwPc4x643XQXG6hEQtCFzeJkpkmpHMFzXmgwY?=
 =?us-ascii?Q?spgRtRMOdBLDkRDdQCFnaokpavkjODPPvhnQuuyysUcty2cZtfMCXoyyCs3q?=
 =?us-ascii?Q?MyPBMeywqlZD/Nc41ks0r609Ur995i+NfTc9vEaON1SWYpCL3c73c2Vrj6uW?=
 =?us-ascii?Q?Mnb6V6B2arhKwMG5U9PPxzomOtprARggmwD1UVVNDsiWm1UytGncF54HGNmc?=
 =?us-ascii?Q?Pzgt2XKUOwFzDJAciqNVbv8ssSiINLd70zcgXG8oX4gppXtLrd+96RtlIH+s?=
 =?us-ascii?Q?98OxE70xNiBWG5ARV/C6xefvqVNIUhkd04NiMAJwNs27RIYYJULzACyDwyRY?=
 =?us-ascii?Q?LHVTP4t7vuezvx3MtkIug18tMYXXpkpsh9N+Fr/hTLakGrVLPkwxFxVMMcSf?=
 =?us-ascii?Q?7LZi1+Amjdkvmb1xhumgpFMDM0lWpuVnwFPXdKtfWAxoCxDku7rQf+c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b390ca43-d9a1-4c5a-75bb-08dac676a830
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 19:30:16.0923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PwLAI/pBezdFVor9bp+GZyC8NQWqbEIdQK1eIgffZCpEa4tgfy4Nl+l9yg6aYE8632xJOtZwTnGYqvHa+jH/9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_13,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211140137
X-Proofpoint-ORIG-GUID: TPcFaf4__mYk7U0PGWv0z4Vp_bWHH41A
X-Proofpoint-GUID: TPcFaf4__mYk7U0PGWv0z4Vp_bWHH41A
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/14/22 10:06, David Hildenbrand wrote:
> On 12.11.22 00:26, Mike Kravetz wrote:
> > The common hugetlb unmap routine __unmap_hugepage_range performs mmu
> > notification calls.  However, in the case where __unmap_hugepage_range
> > is called via __unmap_hugepage_range_final, mmu notification calls are
> > performed earlier in other calling routines.
> > 
> > Remove mmu notification calls from __unmap_hugepage_range.  Add
> > notification calls to the only other caller: unmap_hugepage_range.
> > unmap_hugepage_range is called for truncation and hole punch, so
> > change notification type from UNMAP to CLEAR as this is more appropriate.
> > 
> > Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
> > Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> > Reported-by: Wei Chen <harperchen1110@gmail.com>
> > Cc: <stable@vger.kernel.org>
> 
> Why exactly do we care about stable backports here? What's the user-visible
> impact?

I do not believe the duplicate notification calls have a user-visible impact.
They have existed for a long time without notice.

When fixing this issue, this was noticed and cleaned up.  We should be able to
fix the issue without this change.  Unless someone really thinks this needs
to be fixed in stable as well.

I will move this to the end of the patch series and drop the Fixes/Cc stable
tags.  Will send out later today as I will want to do another round of testing.
-- 
Mike Kravetz
