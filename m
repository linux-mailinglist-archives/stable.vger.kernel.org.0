Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7116989DD
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 02:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBPBgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 20:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBPBgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 20:36:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FE542BE6;
        Wed, 15 Feb 2023 17:36:16 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FMx60Z021564;
        Thu, 16 Feb 2023 01:35:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=GkkucyCz1c37jiH3oUr36wqifLD7hbNjPknNBFR4GmI=;
 b=2gDerc5GMlej4WRkeEyLXY821mox1O+0DtMZSnXTO/PJJVYzanQiT52Mj0m635CWPDoJ
 wOZuPetOuJXtm8ZqRpokjhXJTgsep8iaKw2CLOHRVWSwuiU9Dut6tsUx+hTWGZZED+E7
 Dj6SEb2dM8nq9m2sx9YeVSDDYI5qG5+4YM/1q1/ikyUIE2VmzXjELwxPWUr9+cHPI4MJ
 dlRd16GS7UgL2QdYNjmvuuNvjOyBW1KReGDgi3y6b863oU7lG1Q1W5s35QqX1m6p73a7
 UVBd7bDmL6QsZBkvpe+Hs0kTf2AU/IImDkwFAOqhZCDw0XgullCGU7YxIIKZVqpXqPlR QA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1edhvc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 01:35:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G0Ljj0013605;
        Thu, 16 Feb 2023 01:35:49 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f7n3jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 01:35:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQrtRiUy3hYqQao5tecRk9PlTlkoIiKE01WTn9trsX4Mc0nAnB0lA7LqMue2Ct6G+4rkBGrpzcE+CKz5V9LTHUL8gXyp762UjtAo/vy82AXxrr2PFnln2upIAc+lfiW30iLB9fC0Z7wf6JQQLkwJ2vrMHDDJYsVPrLjG5xrw25P2OtGuK+Q0WLhhiaEGW3675w6320aSOw+HuQkqcOr57Jz+8IFyeqB6yJ6JNkp84S9r2u/1sJUeH5grLz56AhuRrmJC5E9UxgzWoGaIqnua1fiuDY12nTjSFdLRnBgV1I8OZFvduojweeEOC/G9VYO7caTwOLGLY1nQZOYVNo0Wbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkkucyCz1c37jiH3oUr36wqifLD7hbNjPknNBFR4GmI=;
 b=OQKn3ZhCRr8NQYJgH9VvXJJUDLdb/x8mhxxZcpP7TCDPiRPGMlocOvvdTBF8O1LaWMf1KrXZGj2oTo+T3e0l2V+f5iZ3iN7EcCK/TMWyZvrxhV2bRV0Byye2rI4QYv+pvTiz1ycn1Z1ytGvmjPSZWW2yvaLCSGILYphfgGaIZ5JxyzBAR4aj8XJ/IIQzJapsX5g10Y6PlLv0mvEmpASnyogGrOhdgaRQhomtnfKD33KanbpGG0JGYPz18iH7mkf+YfQl7qs44o65K6Y2z6ZWQIcgEJaPdg3tNPUlje4cvNgHnH6UHSF36n4zXGvnmRgX/h5Kb61Fb5z9CIa8HZXAmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkkucyCz1c37jiH3oUr36wqifLD7hbNjPknNBFR4GmI=;
 b=Ct5Z+Y2MJMyVkgqCPRml4CxtjNTnvCDOYAY2QrFVw6mdO8A7xp+ZU0dFIPO0Z7p/adwwmN+i/lzr79ce4cuC8bPFBVzpnxkp00LGkxhO4vmW504DWyDhO/oHYXda2aZ6+ibMotNm/OQiSi7WVvp2wxv5VZ63Cb+VMPbR09sTp9Q=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by IA0PR10MB7135.namprd10.prod.outlook.com (2603:10b6:208:401::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 01:35:47 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a%8]) with mapi id 15.20.6111.010; Thu, 16 Feb 2023
 01:35:46 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] hugetlb: check for undefined shift on 32 bit architectures
Date:   Wed, 15 Feb 2023 17:35:42 -0800
Message-Id: <20230216013542.138708-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:303:8c::26) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|IA0PR10MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d350af8-0dfd-4750-e938-08db0fbe2074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +E+2SRsnVPHlMt6lh/wUMPAvBjPILAF07xTd7Egp0vrKG7oRntTnZMfJGigSfXIsvl71XEcrjK9wWqGhaYdAFXXzfNzgrTNVt0ugKoA5CykDebgz8qtk50++RfmsFhC9sMjOsWaAXO8c6y+Ej/95SSViiHcz8bqXIH9A65aUgrQSps+Q3HfMvX1flNN23DXanhc3ey8DNzceNAAWDVCzujxr8sRQHNNoO1m+qnHcvjCNny5MwmgfvMjLIGohdZXXSP9acPs2S8AxIK6HficSaVFPRSEzMpohwoy3iZ9M1/4q2iuZBgunt0jaUoJEcClXT8SuVuvrPL4r0sBt7ggSOn3+Cms/XniusPIz6jlYEOIoAX2fzJVv3pCK/sS6iDpsgujU1uSst2aKwUAdhqdtqVyrQYdLxBapHn5jprRmZsm/y+7APuW8+Xl3PqGwuxTvsev1NXiw+UOvici9/h9hiy/JZq0j/ItdkIXltgz7uKNd75y80ADTcvp2urbLpoi/vGmEijvLm7swDYJ1rHsIf6XrA/mbnZ3Q8zDUwPjECLWABvfOYFSbp1UresFsvv5v90Ih6J19M0H2Tr85mlsBI3U52cemiyhDUJgK1iFzTYS2dgymInJBiDLg8zX/AvrP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(136003)(376002)(366004)(451199018)(66556008)(66476007)(66946007)(2616005)(86362001)(38100700002)(54906003)(1076003)(6506007)(186003)(6512007)(26005)(6666004)(316002)(36756003)(83380400001)(478600001)(6486002)(966005)(44832011)(2906002)(41300700001)(5660300002)(8936002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FA4kK+2OFxyf5zEpKpVJHaJmZV6b1i4mizv0HD7TJrtCkDxt45G2sPXrNGVk?=
 =?us-ascii?Q?8E6CY5zShZJIaIdkOjIjYdnq9aOO5vJAjCLiLo41FrBvWlkUzfHKyOPdsYbe?=
 =?us-ascii?Q?J/CFmrWuFsRyLOM20kyewvscc4IR5PvbVKu/UKQWBEULtTiQuVdjhYPvW8CC?=
 =?us-ascii?Q?gmkkWnPNABVRukVhd4mxz7u+wg+Hkb1/+EOmww3EYM+/azBjVm3X7dQKe//j?=
 =?us-ascii?Q?kTKG9j0k6ByGp9lcz/4Oj0Zeq7Dt45Fg7b+3zmJOnSW7pcjjUckYga9uDiz4?=
 =?us-ascii?Q?sEKdHFdEXQvTw/6x+nhIBFJDkhqCqC0TcU7BAi+HYKywhyvHqDnFGL74elIe?=
 =?us-ascii?Q?TjHE+KGyo22YFjJ3HVqt9fU5tcziih3xlqR5sLLRMcbL5ULM7ETxlaMH2ufj?=
 =?us-ascii?Q?jYFRcwy6pQ+Yzap3owZVCXcCCrFnHihoMmksyrtk5e2wnF45IbJmEH19KIUq?=
 =?us-ascii?Q?vDO6mpl7fBBoJVdCykQaavR1MePuJAJt3J7JDSuZi0oxJkHeFv8o13ekjhYa?=
 =?us-ascii?Q?OadV3SQL0LDXJW9Ro+79e96BdVERrQQsHhOKPh0+jcPfQ0yRdwycpxaofI4h?=
 =?us-ascii?Q?g1HFpmJ15UVel+YinWnuoiSOQocUUFsfc83xMxRPtUhUDIf1ijMVvAXvBb0R?=
 =?us-ascii?Q?VwNgwdivq+iSNSfcAzCTKfDZudQxk4yrcnaE8QE20m/rTlufIBztG9LyJIN1?=
 =?us-ascii?Q?FDpSoXA1ij2uikHnHsoNrC4kUqqLiPYNnoWGaIy5jnRBfXzKE5dlvtoGrytE?=
 =?us-ascii?Q?wKrcKqIgSA29Ew9sStZZ8kWAv/DlBOYjiX+jJBOl5b1VF64fR5ReDnqZvlDh?=
 =?us-ascii?Q?H1YrzM7cXPQqA8+JzjiNWNWY/MR450zknRktLAtjvI62cNOUdWhUSntl+Eo7?=
 =?us-ascii?Q?A4h9xQHM+A8VmRAzYpwNUbio6jAdJxP6FOiwa7j2pMLaY6Wt58epP+7m0Yv9?=
 =?us-ascii?Q?D2S51TOz5gAwniZzVKyZ38V5biGEHCh4YXI4iJn2TxwjrnxILoyVrS0SWEK7?=
 =?us-ascii?Q?gntC/i3TxOgXM3c3fum8jxAyqzVkY6eaBe7AQYko9C15D22YwTRLjhgBdQG5?=
 =?us-ascii?Q?Vj+d2sDtOGbZhhIeStkSWp+d7KMHwMY9c0fKi5zizTjMI5Jm8OtJZCAME8EA?=
 =?us-ascii?Q?2wR7Bbzfs0d3AcSdJGvIvcB9OYM/dGQJ9qpQ4fAe3+w9/8wjnQdlB03lhaxB?=
 =?us-ascii?Q?QsvdCqRFCrP070mU7kbi8LufLpp+swS5STUfJ7SfV9jEO2iWpR9EobfCbG4e?=
 =?us-ascii?Q?qXA6LxaZw0kIDFyA+V+sp5ASkkAlthYsdhxKF2UlmLlwB1/dTeVEJjkNEbCK?=
 =?us-ascii?Q?iE1spAemS7MoKufL+t++Qm9dynMtc1bdsJRM9PRDbSM9dKPR+glTDwYo0yaB?=
 =?us-ascii?Q?RkbVLTpIGj2rb1SXEri96t4b/PC8nW6C2izd//7nokZzVZ3n4lABvXkwTWsg?=
 =?us-ascii?Q?BLgBCZObhGKcf3UTSDwHJPl9/62BkMi9e15rKv0lgHOCfgk2uAHHs0qiie6f?=
 =?us-ascii?Q?7PCdFxaLSvwbEncg5b8ymUNDE7Qp62AtmeXED95dLw2mtogBRD2LOjqwQuaE?=
 =?us-ascii?Q?M07Q3U/DR2N4tkqcs6NUMuchcMLZVWYJqZxozJ5eCj6pRNfs/xEh2na7dsIs?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?/Uh+TkN7is9iMQIiPdK8ThoxqPC+XXozvP5L0J0KJnEjvux58y08+BOS0VjJ?=
 =?us-ascii?Q?5p4Tz7NAu+UyA+kZe6/IFPk9aBDiBKm4dhmqO/RTOxCLQcGHIDZagcqX905F?=
 =?us-ascii?Q?rSf9LSpiVu+Lyzt4rHzQWvfyviefBBi0SjUN8uuQFSy0a55iERYQNzc9hFrJ?=
 =?us-ascii?Q?z7A2DWyyMGKlZq1PPFolEB0pggF576TDKb81u4bjrR5s1paqDvwNlj9bNG1k?=
 =?us-ascii?Q?7mjR5gtdb/kqCLdhtHVDIh9RjZuAs3h0wW0axNd4DvCbZBVURBxBu+l5gyjw?=
 =?us-ascii?Q?ygwOWlPxSza2EMgshPX8N1NKPJzk6APshTaqlB84eQkmeEgLRqIcAQj7FgEy?=
 =?us-ascii?Q?jebLzykP01hhTmqcMUcDgG7+KJ6+2LnUiXXTRq8VTGhatUhWEohvdPNQ9QR8?=
 =?us-ascii?Q?107OzCKFJ4JJErRzAyKtdGRPWNNTWFP1iM28CeYmzrIZLSLQ9KjKNGQCigsk?=
 =?us-ascii?Q?EU61fb6jRtigEXLXzGy/HfLYhh/keBESf74pFRAtaGhr/5MMA8y7A/6EjBfP?=
 =?us-ascii?Q?j5GYtrNDA2lB3hNUKkCymh8GvBF79m7uNR7yfQfZB1LwujbjoZMwBu0Phztq?=
 =?us-ascii?Q?wyjMu+eOsznWbw4NSjd396wjhxeDkYOHlxfYbp1kL7JF3FMMTrXI314YPCyy?=
 =?us-ascii?Q?4QBtLzOXUhS29Qy+jMmiDpwj/q/EiCkoVoTckFIbN9U7N0VtyKAOg6zTVi0I?=
 =?us-ascii?Q?C/iV6S9gtMp4ad7BgAC+hmPb3s/8By0kJ4HmO/S5N1BuPxUx3pdMj1vX1EBk?=
 =?us-ascii?Q?0EeSEeAuVYe51y9G1FsKdJMc9nH5v7wfXYNMCc54PNXKi57dMCLsjLCASA4F?=
 =?us-ascii?Q?eYhQzg2Xa+U/QYGr6PGQ4yg4Uk2Htjmv/SoZi6IzGa1NOLf3wpKIWEyA8Io5?=
 =?us-ascii?Q?mimb8njCG6TySX0/2YmLJJMQgBH5V+BaC4b8QK3MBUtc+e5UR9AeDCtjQQLn?=
 =?us-ascii?Q?eahOThOmiBl7qCCduVGyt9eSzNLhCEWb12mGgVLSo5c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d350af8-0dfd-4750-e938-08db0fbe2074
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 01:35:46.7355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gSxIcS0aN6MVWc01ucYQknABRamX90ZB8tkdZ4fYV98fvyA0BQj8DQkZ1fQdOFq/7t9R8sIIHbXevED0ka1JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_15,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=811 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160010
X-Proofpoint-GUID: hS8mAD7ZzNnlI2tB6CUrSkWR8v0IzrQZ
X-Proofpoint-ORIG-GUID: hS8mAD7ZzNnlI2tB6CUrSkWR8v0IzrQZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Users can specify the hugetlb page size in the mmap, shmget and
memfd_create system calls.  This is done by using 6 bits within the
flags argument to encode the base-2 logarithm of the desired page size.
The routine hstate_sizelog() uses the log2 value to find the
corresponding hugetlb hstate structure.  Converting the log2 value
(page_size_log) to potential hugetlb page size is the simple statement:

	1UL << page_size_log

Because only 6 bits are used for page_size_log, the left shift can not
be greater than 63.  This is fine on 64 bit architectures where a long
is 64 bits.  However, if a value greater than 31 is passed on a 32 bit
architecture (where long is 32 bits) the shift will result in undefined
behavior.  This was generally not an issue as the result of the
undefined shift had to exactly match hugetlb page size to proceed.

Recent improvements in runtime checking have resulted in this undefined
behavior throwing errors such as reported below.

Fix by comparing page_size_log to BITS_PER_LONG before doing shift.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Link: https://lore.kernel.org/lkml/CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com/
Fixes: 42d7395feb56 ("mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 include/linux/hugetlb.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index df6dd624ccfe..8b45720f9475 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -781,7 +781,10 @@ static inline struct hstate *hstate_sizelog(int page_size_log)
 	if (!page_size_log)
 		return &default_hstate;
 
-	return size_to_hstate(1UL << page_size_log);
+	if (page_size_log < BITS_PER_LONG)
+		return size_to_hstate(1UL << page_size_log);
+
+	return NULL;
 }
 
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
-- 
2.39.1

