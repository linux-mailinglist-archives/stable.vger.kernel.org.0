Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C98636A40
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239140AbiKWTz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239278AbiKWTzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:55:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840243890
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 11:54:39 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANJiX3s009796;
        Wed, 23 Nov 2022 19:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5tRxGy5FG4mi1QJpxm1TCWGzceqRhxVq49lDSjVquw0=;
 b=C6m9/hgabY/gVrfIUn11CirZXP1TfGxPpb2gug/7S4eGLapBfGWUYtQqPs2tmLfhwpPN
 Z2am/yaM3kxMa55TXDLNKz8RP9mdVBAEBXRrAtKd1A8qJeziBEH2jSlWbk7MvickLei3
 9iAFI+YpSSh71beU9Q8K572kBd+lcB/FUd/yjRDWisDfwjxS9KIbUkC4Ren4L87CB3e4
 o6PFfia0xzZMqXNcoy5xFEhSRp+RhoFwCoJKrNeLNGGaSENh16zeqwQjD7kWHbDrbyFe
 2YOEv8PI93NWWDvixcBi1Qw9Fw3u4TlbC5TwPiCq0qxYE6+L8yXjxCYqNiB+9aTomE+Z 7A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m169535xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ANJU7YJ015679;
        Wed, 23 Nov 2022 19:54:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk78qf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOUEs2DWuHqj9ergQqFVYCtkAWCp9c7bWiFighuoVoPTRHkTILF7MVQgECLq1gZygT0ZRDsUrYQtkTK6CdGa6x7DDp1ePNeu3MGre3a4nhueFB9tFAmdODcx0I9+N5d97TmMiA49WSTe4RCGmeh/t7U030qzPTeGgbb8y2vAvwOmNH4Bc4FdiDpzB2uuwF4fCzyZrH4Bu4pu7vCxCsFr74rvpe2Xtaj9LdtLA/uwXsSsZ13V8hJ1eCHGQx63PpJyc5WuL6SLB5ifsBmJlXKLyPJGaT61VpRD26wadMr5wtz906EmWG7Ui3JBhnKJ6e2JIG2A537i9jU/+l2jYJpCtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tRxGy5FG4mi1QJpxm1TCWGzceqRhxVq49lDSjVquw0=;
 b=Dwn5rqiSmKPZVf3HE9AbgtZ0zZ10E4RWeJQd783/G6egfLqGUYDnRq1JIb31WH8mPOazZfWwkuegFI8muTxZlPtnDyRP1dUxYt5aFemfGeBr7OPLOj/HF0wJ1jFdBMEa7ualX0rWcoMp9ZaKOxcqhn3GqOk8NRiZ7OAXsDc0mjlfYiXDGndcp+J+50dlEJKpxOhKrAbNyO4f8SP2Eq74rH52jTAMYTavv5MHv4gniiLYJuLGaLQGckGZYIpDsbKfS1cct1+i6ccqZR+XrzoM8q5+Q96sB8WhAdpNEBGLGEgXP/4WxL1LllB1nEbkmFzP1TYdBhIq1RaLgmcMuy2AGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tRxGy5FG4mi1QJpxm1TCWGzceqRhxVq49lDSjVquw0=;
 b=VlemyaOYdflt+e5tCVXVmwpG32uZLSNd3CUY4LsjjHACY/QiuJHJ9rrDlHsHKPYJWtDmQzDyXMyMYYT+ta+7xDRpBqf/7ineKK2A+oMT0ybzJWEjRCZp9S2aUl8fLLgmF4anCjgVSh8f1rWrTOfCYpUtshsA/0L/VZ9V/3uqxoE=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MW4PR10MB6300.namprd10.prod.outlook.com (2603:10b6:303:1ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:54:19 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:54:19 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/6] hugetlbfs: don't delete error page from pagecache
Date:   Wed, 23 Nov 2022 11:54:08 -0800
Message-Id: <20221123195408.135161-7-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123195408.135161-1-mike.kravetz@oracle.com>
References: <20221123195408.135161-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:303:8d::24) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MW4PR10MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c45e437-3be6-471e-90cb-08dacd8c822f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OBZwQLkKjqv6jeO8c/t6p2Inf9YgirUMDY6mCxI3okG5/3e5owj/DWB7xKk6yzx66Y0tfQcPRyzupgScSLBTp1s8S+TvEBtqUq6yNUyft6KX0YdGNBDiq2I7tcp3colcEEcvG85WNlXkqnVkMhHrF/WTsAopKOEvUwVsGrVSrzpEZouyM+suKkfEcvN+MEwpsUhtkFUafTfkr/7D+QO7Fv9Ma1/s2TM3mMsWk29qeG8Xj04kLVux/j0RSHSweCXGHJUgm9IqV75nJuhmFRMrlr4p5sUBj8HxseezalULcshbtnZ1P0kJR6baulFWAqCKpNBjMFVfVyJ2FNXrnULBXGOL3ftls+1+t/x6az/2FfThofRzAFbvYDU2/8GpCtLta4x6WJDHd+Y6AFdKsmEvn08uR+P/BPNdGzKLgeMQbh0e3DXkJomw1M+rzx5ijhZ8ZDb1PIVyXFWgCwe9HEmkDRfBXNYaJ/+tV1GneKMVb/VJvyJI6hNXqsKHRQ+zM0YyfJBuiyqLMxDhgNOWzsGY3U71iFNdbSgJ7SQv5vIYy/L4FEiTw6rE1cstfvgNbXV/F/V1xUUh+pL4fRyw1GBQXDGvRqw4oEDR65Jk2i4YLwCqdueqiU59Lyw5pBv9VYgmCYYWboI5vuvFzRTj08hI40iYi8LZAFYAw8UCDBI8Xtw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199015)(36756003)(316002)(54906003)(6506007)(186003)(1076003)(83380400001)(2616005)(966005)(6666004)(6486002)(26005)(478600001)(6512007)(41300700001)(44832011)(8936002)(5660300002)(86362001)(38100700002)(2906002)(4326008)(66476007)(66946007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZX15x9LZvq8dHK0yPlvwZb2Dgcbij6IZe7u1ODUMKx9/DfhJOHhIBEX5hq1T?=
 =?us-ascii?Q?7UeqEOy/5BSVV9aH5vbm3kHR32gxVnLKRJ2A6gdKO2ikgIPMrNotgCtHHTG/?=
 =?us-ascii?Q?xLDmFeR0mruUPLxW9djhoMiM6HAWniEcfaopeAhlMuoOHXS0ZLVFtppU+h4o?=
 =?us-ascii?Q?CO0a8l+YbPhQnbFb6kaTDGOnr424McstvH0bTMRIArhpJOjw00PjZWvPzG0e?=
 =?us-ascii?Q?ftHe6flFikQ2oS5Q8w8Q8p+/h3N40/OvW9bpKIVqHi16CGICrmpQ2F5ZLXwE?=
 =?us-ascii?Q?Foh/9rN3dBpIYl1MEWAA95koCutSXq20mvD5NJWSgFc2iXWZxZOKbBdfyAc0?=
 =?us-ascii?Q?LD4iOaHFzEQXoBRXdNLOSUP3ecNRDRnee0iVTNuiFteByGx5d/TpsW9lbEso?=
 =?us-ascii?Q?IJulM5GBBET9JqrQJqdL4LYqKQEASh74vCyBzUFFHlNkBHLY6jLi9KfO+YxL?=
 =?us-ascii?Q?okMPb0EVVt/6zgIptQDca2y3/zCKzJYGDtdNkvBFS0f2LF5/iEa3pcCfMMjz?=
 =?us-ascii?Q?KCSiYcCyYrEzWHF1FzpCOBAbL5DiIRSa1N8gcgjhEqW2Zxy0/erBtji5VFId?=
 =?us-ascii?Q?klObmGSza9hCX/BlVFlzrRjWlsTejCUy/CdB8CKUpkPD7fqbraCQbkk9+Gsg?=
 =?us-ascii?Q?j4vvNNftr9MGgw19qYo2se4ykXHq0K6IU+7KrnShwhnfc3CjUt3zjink3cnX?=
 =?us-ascii?Q?DlnGw4aJ2VmbIyVo5dOpaexPNv1LLAOhV94JffimZ62ouw78/id+R4YyOvXE?=
 =?us-ascii?Q?ea+zA/Ep/ajr1gi8haVPZ7V+zkAWyC3f73ruAS/l0uZ+tHU//GAAwMGr2u1e?=
 =?us-ascii?Q?VTkI7VZGtVB06Qbcd6aVZa4WVEeTRSRG/4eU/INrt9NPkFsIBiEr9i5Gs3L0?=
 =?us-ascii?Q?rZXshrz40d70a2Ek4NIHCcMlq34IP3/VjQK8VOOH8coZSqBwVvSDtxOqLPXo?=
 =?us-ascii?Q?zIdITLcjfKc6r4XASLzsJ8YberoE5s/Ed9oc0/DtkVLZEmBBWHtZ/Jh8yj2N?=
 =?us-ascii?Q?OZ/kPved4uqfM2G/7TNJyddTzmpbpRoBoPx2kHD6tCCNvrgnMBjnWM9T66KF?=
 =?us-ascii?Q?tvOCQo3TJfLn4KtyA1p7fs7UszPU1Fd1kjyMeUrQQjXSEOyI2UwrP7fbA2EG?=
 =?us-ascii?Q?TYPBGWKTa9Cvf8GEiaC7D1hOVYHkof3xiPAdKMynngWWszDELqO7l39KqSVw?=
 =?us-ascii?Q?HU357se+Pq7NoQIEHhlM8SPu6gw+sGF0gkg3cZqA+XU/N4CYF61ZQ+Rbioww?=
 =?us-ascii?Q?6hbvAsGFIbIG1jca9YKiNmtp7wYgtWLYeDTcb82XTKNYCZqTqHS0rpivkHTU?=
 =?us-ascii?Q?y6lvFNqqbRqI8oYLdP9t2EzzGKz5soNcyYfg4AoGZMEJDPFGMwE+lolYN+mG?=
 =?us-ascii?Q?bhQ5crz0BDXexueV3EJj2XnhZO7IB2nQUiKxUa/ioijst/8KTuBurd+poBKj?=
 =?us-ascii?Q?35CZIZ5FLd6qZaWDV1S+CfHtd5Zztm1Rk31eYf+jhdJnv+5kyAhMC7RM6qFK?=
 =?us-ascii?Q?TqAUpYlVFDvvfX//rEtHULPncb4paf/DTyUslm/x/5Px3LaIFbb9FMHh2iZe?=
 =?us-ascii?Q?3ZnMPM8n9MAhQBaq36lERazw45hs01z3C3mHrCvB0YhfpSDMpAJnvY1LwSzj?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?isL7zkcyR+SnCL/wV0zTH1Ad+Fn2kLknHgcLQacqU2itATu3MU3VaUV7cTnu?=
 =?us-ascii?Q?nIF1v37Lss/AA12orIItxTiOfgUe+K4BV0lAxlsMD138m+x4JKAiCbbqi4g9?=
 =?us-ascii?Q?gamMFa9xg9oDEbupIQJgKdBYVSiW8yx0WJbepDg/d6gP9Wlp2Oh0wv+Oq6z9?=
 =?us-ascii?Q?4a/btu+zd81kxEUKUFZKWPBfMhwfVhj+g6EwhHgE8LIv5YYTuQ/m+kay48/E?=
 =?us-ascii?Q?Ur0b8ajxC2qx6y9QaEPhI2PQXZAbEtzwhLtWNwKdELXKjvbWqntR0Tx33+q0?=
 =?us-ascii?Q?E7cwuJmuGHChj4YaIsvnJ0kyDtzQOh9Mk0yx5Oiih8X8b7Jfks2CdJ0YsbEy?=
 =?us-ascii?Q?kS30ha/7LBXntC8fRUUtn/8/F7bovxd3sHBc4Q6yZgtCGGsGTPp76Y6lzwWR?=
 =?us-ascii?Q?tmiZrfUBpjLjlbtzho8drcl3itPSRwfaMd12K8ox68okboA0PZ8EahDIaroV?=
 =?us-ascii?Q?e6riOzsGsdqw8xUOCdH69XwT9Oy0NDA8JpBW0A/qcdSGALekfaPXF4vvVZ4S?=
 =?us-ascii?Q?XOsTPn5DKQUmN1VcI6JQVRTbjUiuVW/9FKJ2S6HmIKX3jnO9EQDPCFbsDFMJ?=
 =?us-ascii?Q?2VQF5poiEZQxnL2JADVUGwaL1d5DKn4UFUq3PLCfVVw4MIvzXkv23RhA5dpI?=
 =?us-ascii?Q?nyg4yJqi0Hyc/EGpARgv+rFM6CQethsrtuveBT9pgR4F4rK1qvoKxqYxO4TZ?=
 =?us-ascii?Q?yiw2KGj9K6p5csoAoRQ7nWygL1G6fq2oHAtxp7tI16WbuN3fVlynB+cR988Z?=
 =?us-ascii?Q?jXfh8U97rTBVT4/eklgDmxUIUp5z9oi6ZLVMirlFJYDYRIno/Xv0UDzRojJx?=
 =?us-ascii?Q?HO3nRkFggYbjpGEAAvoVC3wsNctTdl9R0qsuR8hoiYwfs7iHka9sI5s1O47m?=
 =?us-ascii?Q?OVLeJraZC5tEo/UlQLKMjU545ROYlwsOmXEWkshKT5sjWyqne7KhHgpOpxQu?=
 =?us-ascii?Q?AuVJ+zv+t561MaK34DDOB23RJySpSOCvTuApFIivcGHYYPFBWze7YUks4omP?=
 =?us-ascii?Q?T/GDvrOExGKuu+1Ryriax/cCSg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c45e437-3be6-471e-90cb-08dacd8c822f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:54:19.1179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPRV6f4LnOyRrQpYx18LETs9uTPlYSBAEWYDpcpaC+tbXDlOw4Ju2rj21OHGn8G3fsKlEB6Y3yDbsOFlJKnS3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_11,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230147
X-Proofpoint-GUID: PGSb7m7aGi2HLBslIIIVSJKTBapjVckA
X-Proofpoint-ORIG-GUID: PGSb7m7aGi2HLBslIIIVSJKTBapjVckA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Houghton <jthoughton@google.com>

commit 8625147cafaa9ba74713d682f5185eb62cb2aedb upstream.

This change is very similar to the change that was made for shmem [1], and
it solves the same problem but for HugeTLBFS instead.

Currently, when poison is found in a HugeTLB page, the page is removed
from the page cache.  That means that attempting to map or read that
hugepage in the future will result in a new hugepage being allocated
instead of notifying the user that the page was poisoned.  As [1] states,
this is effectively memory corruption.

The fix is to leave the page in the page cache.  If the user attempts to
use a poisoned HugeTLB page with a syscall, the syscall will fail with
EIO, the same error code that shmem uses.  For attempts to map the page,
the thread will get a BUS_MCEERR_AR SIGBUS.

[1]: commit a76054266661 ("mm: shmem: don't truncate page if memory failure happens")

Link: https://lkml.kernel.org/r/20221018200125.848471-1-jthoughton@google.com
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/hugetlbfs/inode.c | 13 ++++++-------
 mm/hugetlb.c         |  4 ++++
 mm/memory-failure.c  |  5 ++++-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index a2f43f1a85f8..580fcf26a48f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -361,6 +361,12 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		} else {
 			unlock_page(page);
 
+			if (PageHWPoison(page)) {
+				put_page(page);
+				retval = -EIO;
+				break;
+			}
+
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
@@ -994,13 +1000,6 @@ static int hugetlbfs_migrate_page(struct address_space *mapping,
 static int hugetlbfs_error_remove_page(struct address_space *mapping,
 				struct page *page)
 {
-	struct inode *inode = mapping->host;
-	pgoff_t index = page->index;
-
-	remove_huge_page(page);
-	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
-		hugetlb_fix_reserve_counts(inode);
-
 	return 0;
 }
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d8c63d79af20..6c99b217a03e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4775,6 +4775,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
 	spin_lock(ptl);
 
+	ret = -EIO;
+	if (PageHWPoison(page))
+		goto out_release_unlock;
+
 	/*
 	 * Recheck the i_size after holding PT lock to make sure not
 	 * to leave any page mapped (as page_mapped()) beyond the end
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 7d96be8e93b7..f0cfd7d9c425 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -868,6 +868,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	int res = 0;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
+	bool extra_pins = false;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
@@ -875,6 +876,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		/* The page is kept in page cache. */
+		extra_pins = true;
 	} else {
 		unlock_page(hpage);
 		/*
@@ -889,7 +892,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		lock_page(hpage);
 	}
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
 	return res;
-- 
2.38.1

