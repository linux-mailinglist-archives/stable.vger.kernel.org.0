Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E40A636A3F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbiKWTzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238984AbiKWTzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:55:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C5325DB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 11:54:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANJdvjO024628;
        Wed, 23 Nov 2022 19:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=AgKd76VFYN5a43oAYLCudv4cECfRuvQ/624J/LSAkU0=;
 b=iN5ZtnKLxe57d/11Nho4PCctqiKeINFR9JD5wmU1nxzqja6kGap1mC7b/M42hJNTT4Lw
 LyyfSWmKm8CRwVi9RCQofRGb46AoeVZ5Hn9TZPA6cWgb+6ogLSa5l7EjSIX0B1yFHn4Y
 As2s71fzQUt0cbesRCQ51pfQAZCAONlQyHXRbfuMMc6I3D+8qBOOJ4KLlJiFeqT6LJqP
 /YbisUel11svgPSQNgR5wt6W72IcucTyaZB9fIXwCZekundFqpo7R3jEdiOhHLiL28ln
 bo8v6AGKCdd/545ySuhXDEXs19xHEH/W3LQndMN5TFj0apiLJXZ84D1NltrSxzJEgbx7 Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1svgg131-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ANJNkeI037402;
        Wed, 23 Nov 2022 19:54:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk6rpju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dub3IPHJkLey86YId+LFwnFr7OB/QZJFjDgUyVQ/krOVKyn81CnbOLeE5puBT9ux5Wa/MAJQdBSppukXBRm19ZK28sNmKAu3O2enObQJqS1LxkqTCB39XXS6OONV47D02xCSvzKY0CLuLCrzZtwXdffsla4C2jujXtQ/QyhJx294tonHlLr3tcQknCqKLhFo1pbWPZhIaD17xpYO34DtUlhuxb/J1IlgCmuaxFBfd07o1ZjghQZIWBXRhoeAZocHn6HcJXyfKXdaRuSnjOt8uCqmlA8x26nL/ErdJ8HKNlS4s3QMVsoEsjjfWKWUu0RgO5VRe/iQJHCc2WdPCbH00A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgKd76VFYN5a43oAYLCudv4cECfRuvQ/624J/LSAkU0=;
 b=bZw9Si4E0C7Boqk056G2+k9D1mHeXSmAWKwVvhpTctwJX1RCCfZ3RoD33F3T9zGtb4U4KEkV43SCgFFrrc/E/beSVZxnZltaFFEoh+1k0BHVWSNitNjX6Y6Ar0L29UsVSTBW45fk2ir/FS/b2K4YXiOxLlmn1ZH1/8cWRI96WCgS9sYRnOWEiGfZqT5xyaHOvYA3XDC3rLjCAA5It/ePkBqPhbyKWoddA3tP3+J706nckVkuNTBlcbGP6ye9oag6bCR6BawOFj8et8zweKG3/Uh7rFQzjLoQPwWcKN+AJzqBzw6G5XRY6L9uFk9Wgh4YynDDQYEeKXcu/KTU7SxnXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgKd76VFYN5a43oAYLCudv4cECfRuvQ/624J/LSAkU0=;
 b=SFicmzcnmshwo4jzpGUpnNVO8lp+b5fcWo9A1JrPNWlEiNnXfEhqSUY1GKJTjb1lzEXYmlz7wHQwkkzFDQ08DrNETcpk+5seZIn/7zEJhQ8d23yruS4rn/qWg57ZL7FdZqKl+8hXBmYkn1rJfEiFq6QsT2X4FpMXvMhIwrLfUv8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB5671.namprd10.prod.outlook.com (2603:10b6:a03:3ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:54:10 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:54:10 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] hwpoison, shmem, hugetlb: fix data loss issue 5.10.y
Date:   Wed, 23 Nov 2022 11:54:02 -0800
Message-Id: <20221123195408.135161-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0204.namprd04.prod.outlook.com
 (2603:10b6:303:86::29) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SJ0PR10MB5671:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c2bd25-b2c3-4684-5220-08dacd8c7cd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uk8x8gaUAjH3nH32YhygLYTupl0IktrGrql5xj/USFLfTRLR+N7paE2kGxgpgzAmNnHMYyyc9b1sD+fAbZ9Snkia1XFTXwivsdcxa3LjtzC9/hpu7OpNMzuRY3ITtA9I1Czv5Dak/7BGHG7hjC8/zLTZo5WCXmfCQ0Ip49pLCovg9rZeE5nBjkAWzhIYY9e2CyJcPrm8wHuIL+qMGYlu2r1ceJrYvVcCXCg1+SD5AoKF/z3ux9GddKZuyQe6wjfTeMl+ZKyvwrVQndudlrdGfAcJIhAZChXxqsxUHALLun6yhWXD43jV8ZgwcEWrS397J3pEUy6tdosEdotWXtvLSizlNZ6fF020rYbe1verFn/YWhdoI/lUivpK7MVBVvIxejfFqY5bch9Tou50CrjeY1+4ZZbBQrAvkzxnvFdSXdexZn8br0LwGmtOaDpNieEIluyrKj0hF1+TIJRKoh6zSKszIJACObBYbHyIQpBwTYoWGQZY9mt8jiwb/5/YJiEFjU/0+HaOXHos34Al5lD+BVkSbeWqSa0YwxQc+M/SQTjAY1zPXwApySUbpufuAKTki15jzOUWg9BnektLIxm4GpMAjuDP9UojkY6KKjLJdAoshEBPZnfHk45eMoW5/m/BKvUhMkL3LWE/VkiD+u30iTT+8q+rspAgUtQc22yhjnMrAVI2Bhr+D0zvmh2jJtBuzEDmXsyN4TiPBFXjFTLPGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199015)(86362001)(36756003)(6666004)(6506007)(44832011)(966005)(478600001)(6486002)(8936002)(5660300002)(6512007)(26005)(83380400001)(2616005)(2906002)(38100700002)(1076003)(186003)(54906003)(66556008)(66476007)(4326008)(41300700001)(66946007)(316002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wuC4IQ06a/tYtDb+PLTd9N4yyUxNyEfDabtWdQZwlPeK+iCud4Hnq3+43LXX?=
 =?us-ascii?Q?oMBXCa3qYy2eZwc4UCfuQ5cXdXaFSBosUyy8zF/MFQSLJuIN8zIXY8RhjFkX?=
 =?us-ascii?Q?8hnFWk/BB7LW23acHGsm744zgzvIXrR6RY6lcednZkrbPo/XV8ruQ0PNXakv?=
 =?us-ascii?Q?LFyUHz01TvLoMKAOaUPsuFj7EfOWRi652ehXdJZdTSssVQuhoQcZ9zsTKYze?=
 =?us-ascii?Q?36Ebn1LhYUm8J1TudG0JpyCZJrFxgEz+BpHhnqBZym8DmPJdYDR5mDJNxYQb?=
 =?us-ascii?Q?9GFnsbtOaofB2Hnxnf2c/0izNdZcp0XLTrinajV1d2AZn80//ykb8hcXI9AS?=
 =?us-ascii?Q?GxePBJ3nB0veW8AF/hgRvucMCN7X6Ng//9j047syVQc9O+RZLKoF2ME6tMVN?=
 =?us-ascii?Q?3PBjV3PK1hjoD805GPb2CyOkcVigZ8+1+E/xan3l/3pjot2ArxEZrN65Y5tw?=
 =?us-ascii?Q?81ZP6h0Ee/2HFPqtVq5AsGqoqAOvCdovqLVMs2U7RYSQJBD1DAn9n/wUix1a?=
 =?us-ascii?Q?ikHaLv3zC4CXQyfBNxCg7+ZEs/cjh9ZUYt/ERXuwWkIUrI/BZpTnpbtZ4/Wu?=
 =?us-ascii?Q?/R5kipfL9mkh+gasoGH0ANCaJYa9QsmVYeWXmWDDn3XN2rSUXqpFKYOwdaGa?=
 =?us-ascii?Q?yV8osBEYKg8TjskM/UICWSjDqCKrXnL0ryd7UNOVbaQWFROXAHBALp/d7UqN?=
 =?us-ascii?Q?GhyUx24+hcU9b2jZIZd3jc/+QbC/UzXxTmmZeHeCOnoDJmJG6CL2SUo1/hTe?=
 =?us-ascii?Q?0opTBhPsJdAdFvpdj5GE+iSPJbrrSUQVCURcSufTD9E4ROf4pQe5ILYzGsxJ?=
 =?us-ascii?Q?AuLBsEfODJC2JkXwICSCoYmZZKVuamG+CXORGb37pDTHJKslHP/D5DCGUY3P?=
 =?us-ascii?Q?do2Rnj0ZMf67PH/A18E8R+mJYT9HWVfbA0JqakU3ndzd/Cxy9NX++EJzQABb?=
 =?us-ascii?Q?sy5rvBlBskGnDrtnGS7bsTWxCTl6+Oyn9DW/RrAVB8UcNXRZPu/wq0fFSlxd?=
 =?us-ascii?Q?ccqQuo8m/6y0081VpA9yAqgKcIqlhkqpQyyyDOBLCQDaa7BOBCag5MULotY2?=
 =?us-ascii?Q?6NTh7Cakis/D5ym6+XW4MGWathBQfKFEz8IHkueOzyylFjb6jOKFu6BP2/F2?=
 =?us-ascii?Q?A6TsuTLp1UZligdN+2ka4cLGlfrdYxwkPVM3Fw+YYF178HAO4DUaW/n5zjEL?=
 =?us-ascii?Q?h92XPpwSX1uP2LqegThu9bk9oG6Ah8H7rQiMzxtyNF7Rh8x5XQZ0QihO7ZmT?=
 =?us-ascii?Q?2leriDVzeQDA6YtShaN08FlUgkla5y+s2qZi157DeXFTxu5A0UshOGwazf5i?=
 =?us-ascii?Q?ofV4oWSQTNIdzrSAoORDfsklw2/sXWkoM89iQ8gIZF74Kq0Sou9apdYfmruQ?=
 =?us-ascii?Q?rMjhqA6xW7zt8MPYvgaQ/jRvH31hURwmeXYP0lKuAo/o6eF+EV1Ux/R9mkRp?=
 =?us-ascii?Q?To0C6DUE4YsyB2E9Lrx6TsMcWaLHX7TAlOjd4lf2Ac1AVdd1/oQ9MjIlgWqw?=
 =?us-ascii?Q?ZxrJ0VZergiT9pwQLruHp0838kdHiE69S6GjZQfYnlDk88puyMhRCFTkGKRH?=
 =?us-ascii?Q?VUCJBvBbvT8VstIRf5fP3bZmUOHjzn5XHu7wdAtFJob99JCAdIKmOUJ/KzKx?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?rRraiKZUnHCVu5GJFodJQ5TyfH3a31az3ReYhNv6CtxVeOoCHyaCdCgbKdpy?=
 =?us-ascii?Q?kLWls8X7BEh5GUOWyC5VNhz/sMA+qlJ+41m2YGvRmvfslY8Ir8qzWodilVZ0?=
 =?us-ascii?Q?HncUrDmpCwsEjHXVSx4dbQoReiLJcBXdwRECA5nOghBDQ7fEg+zR9bOqKa26?=
 =?us-ascii?Q?aEVXs1Q4s6RmI+8ma0fmBm/7CM0POfP8ZJa5T/48R74v9BsLjJbMqPrFW8tf?=
 =?us-ascii?Q?k8aFc7H3OQIS91LANXup8DipROECNmboY0DqpKUGkJ91bsvtSOTjAQ6AvxRv?=
 =?us-ascii?Q?S9JVNnGopZAJqa1trMT+tsPsdNnHPDfg0G/GzswCPgToQ2u74OFICtme9UHX?=
 =?us-ascii?Q?oS7YvZ65zdBWo/FRdYPHos6Al/Q82jc34QaBbaueEWsdO2Mqqxa+jb8y82gX?=
 =?us-ascii?Q?Jhd8fpb6y2bO1m4O7hQHxUhRsnwqxqbRQW2u7zgnbcMM66DeYtJELZbkax53?=
 =?us-ascii?Q?PVLwUckLdKgpklbTQpp5dYhgUHg+tQAtb31N5J5G4RgPcwEiI0zU69g9SQA+?=
 =?us-ascii?Q?uS5OXtbrnI6XWq6Qjy8KuEZtv890AhqTA3P5oEsVn/ija8+r+07winDQUqgG?=
 =?us-ascii?Q?eZMfKhNImuFlccZZFlgmjFtmlqzNYTrS/gUm3vnf4og2YriPEnu7iHgnUGAZ?=
 =?us-ascii?Q?4VQXr7BimGFrAiCt7W3VfEnSFjz6xKwL4i8qooW2wzKbSmhP6CfMUD22Wx8Q?=
 =?us-ascii?Q?WBfzDCezUOFhfE1rnJNj2HugrMWmghQnDO2jtfhtRautr3PQ58mYdv7WtIRl?=
 =?us-ascii?Q?pLwjD4dTbCQpXrfOtYNndzWAud/6CPr3oFrZj9xyM/RjfxWRLbmdEEmaYW3M?=
 =?us-ascii?Q?4cTyowsIgt+D0u/LAuQlSYOvA/YKI951Da/rz1H5zao0ndYnGEW5xFLVm2k/?=
 =?us-ascii?Q?2CWbtaPzlDu8IvsyUXIU60zRtGBhcLUw8u4vEuGNfrS01MA4OpDZ3Gxivj8F?=
 =?us-ascii?Q?3A/3Asyb5dCsiDfqppvdMb5nO/ygt9u7HGC264tDuQfRTwWYfuSQ2IieYwFY?=
 =?us-ascii?Q?eYPaCiGDK+vhy+u8YRFTzE+a3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c2bd25-b2c3-4684-5220-08dacd8c7cd4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:54:10.1014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1T9WHQxkMfmQTmSpjGIphI5/Aman72SBWqgUO9IOgnKyyVATo3B2bcm0AXOPkFguU1BwNC7gWUXbmsWdyJWeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5671
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_11,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=870 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230147
X-Proofpoint-GUID: XcfFYLQjWpdparXu6NLGYfi9thdPZuHj
X-Proofpoint-ORIG-GUID: XcfFYLQjWpdparXu6NLGYfi9thdPZuHj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a request for adding the following patches to stable 5.10.y.

Poisoned shmem and hugetlb pages are removed from the pagecache.
Subsequent access to the offset in the file results in a NEW zero
filled page.  Application code does not get notified of the data
loss, and the only 'clue' is a message in the system log.  Data
loss has been experienced by real users.

This was addressed upstream.  Most commits were marked for backports,
but some were not.  This was discussed here [1] and here [2].

Patches apply cleanly to v5.4.224 and pass tests checking for this
specific data loss issue.  LTP mm tests show no regressions.

All patches except 4 "mm: hwpoison: handle non-anonymous THP correctly"
required a small bit of change to apply correctly: mostly for context.

linux-mm Cc'ed as it would be great to get at least an ACK from others
familiar with this issue.

[1] https://lore.kernel.org/linux-mm/Y2UTUNBHVY5U9si2@monkey/
[2] https://lore.kernel.org/stable/20221114131403.GA3807058@u2004/

James Houghton (1):
  hugetlbfs: don't delete error page from pagecache

Yang Shi (5):
  mm: hwpoison: remove the unnecessary THP check
  mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
  mm: hwpoison: refactor refcount check handling
  mm: hwpoison: handle non-anonymous THP correctly
  mm: shmem: don't truncate page if memory failure happens

 fs/hugetlbfs/inode.c       |  13 ++--
 include/linux/page-flags.h |  23 ++++++
 mm/huge_memory.c           |   2 +
 mm/hugetlb.c               |   4 +
 mm/memory-failure.c        | 153 ++++++++++++++++++++++++-------------
 mm/memory.c                |   9 +++
 mm/page_alloc.c            |   4 +-
 mm/shmem.c                 |  51 +++++++++++--
 8 files changed, 191 insertions(+), 68 deletions(-)

-- 
2.38.1

