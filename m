Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCD1636A37
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbiKWTzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiKWTzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:55:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68BC2BE2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 11:54:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANIwxiI006018;
        Wed, 23 Nov 2022 19:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=wAYQ4kHlIXiOKqHFbvdAoEbuKL1oIyz6KTJZkriajj8=;
 b=dLbWs2mE9XaHP9J5V38ThnB3ZYx6IT4M343g9yUyHetqwE9SfdN2rzWZ83m55ZImNUhA
 23G2qXx4HgznMpV5N1nOIRfGlW8NyB3YRxEObYZDrayDeHjRFNly8US02OcqGgmp0kQz
 8n8rbGBToLjPa2pzRxb6I8hC3kaYxa+dK1TqLA/iBiC1i8jZlzujamYxvw3KpWaFcD1Z
 j3C/kMHXUUJWwyo5sMESbZi7KpyQLCVR3XKr8szUIqo+1L7Vs1HHw+BUfAfKEt6jmQQR
 BIItyyHWZkwulT/N068mB2PomxyXm+JxnoQmkyme4uhxhC4qCsr5A4KLQ7WhgVpssqRG qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m169535x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ANJJ3gb009704;
        Wed, 23 Nov 2022 19:54:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk7gwu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qx5vWECvpPXiTN8NUFkdMUocmJcwyW/qwbo0dBuH61ylR6PR8/1oMsO2XQt+cxoTe14XEHOZ6Wy5wTM59PadFzx0Xb6vZzEUAnYECGhs3b5GXIkYdGPEfJtvfnfjrkfwp9JIF8GoOXAEJIK5eZT6j/03sRPnRVyUJZrwrRQ5l69dhq+wGjSCNXVBHG0Esw0xOsaag1yeV0oyTiYkg/dko9TXj6uZLHl+/UyhTHkj5B+ftvo3z2CuXK2mexicQuhw1lV5WcWHsHyQb/5ADcjRQA5xlNbx+u8L825853WS1cmKrCaTbqe/ebW6LLZKXQCWKdx1zds2F5vPNxkO9tN5rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAYQ4kHlIXiOKqHFbvdAoEbuKL1oIyz6KTJZkriajj8=;
 b=Nyn7e5h/felysYm4aV2mpsFGw7mVHCJa7OuHJQfyn+bgehwXAzu33HX48//RsUnuMaDLC0ad1kknD9NvZHpwvkSCoqVWSMq/zSkruWb4YSEZqhGfwZotOhrnGc5CqVc8TzrjG1nvQaFMGSxvxKz0qAlXVEX5qFQXkXa54CRZhJPBEV6n3QUalNM8IYtI6dHl2+7eum3oBQ/wLXNMmljK+AncSafvZYYnJWFL6GRZhI1vcq4CdWQWQ3IFPc+nRc9+yQuBv9q9qDhN5ZspXi5g0SRqk1+ucTwvQiZKwWjpA3M3+IeDc/Zl2LENd9SVfK7ABR8FokkAeT1Y4DRw8PUsgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAYQ4kHlIXiOKqHFbvdAoEbuKL1oIyz6KTJZkriajj8=;
 b=AwDfuvQfViPRMXx77xa4qRFeFFYJOWZEqkW/DBoVdh6VsSS1oV+VE3fzfuLP+OBZGnKvIPJXb4dXSk/BJltHJ6SghBAGCm2EUn3PW/JVYriQ8+nbBzm9pzhlg4qQ9cVNvFrKRLOTTnK3Dccq0rFzda37u2lpIbPf1VfTyiDGLCM=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MW4PR10MB6300.namprd10.prod.outlook.com (2603:10b6:303:1ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:54:17 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:54:17 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/6] mm: shmem: don't truncate page if memory failure happens
Date:   Wed, 23 Nov 2022 11:54:07 -0800
Message-Id: <20221123195408.135161-6-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123195408.135161-1-mike.kravetz@oracle.com>
References: <20221123195408.135161-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0250.namprd04.prod.outlook.com
 (2603:10b6:303:88::15) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MW4PR10MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c6e0f68-266a-4d9d-9cb3-08dacd8c8156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52bPhwbaJ164Ivr0ctEkR4GRxidtQIzRibO/3XqarT3h8rAq90ndcOaAJdi+764XdhbxpNwOQopIlNZGOuT2vx3PxJ4kbJ4Ezvg/DOcwO33YIGjiYxdk+vglgjqF/cTp4WKeGDK1P4WhXXIqJemquyX6ijjg4H7oMRReGr5//i4FVArVGrjASlkk8nQ3IUrOS4y6RqUqSOjYyifXWN0vQ6Wd5FgSqkUnyG6ca5Gssee6iChjpjvCWHpAJ5zwmFhmywSaqf99bWl09S9WT+RrZD99uw9Hr6qoj8pHsmbf/FxwY3ks2az5F03UpEaNHilj5vzMfA7wknVrwSTdBuwaQB3ORPgHlfU3RIAfCdVhPd+HaDqxiFKMyTImWgi33MYxmt8ivTf8v/IpFaBQekqMYY3qE8del6gpXY6d8Fv8Yt1yZKd3mwitdE0BmEXt7cct1O2ymv3nnuilMwNR+kuMCsmNWvCcaHXd4NQMZB6ZSbWMAl+1rYk1+TdnThXJUzdyBhL9LMXpOCpXL5PM+Q5EANGqcRbidUNoT1wga3lmDIdv8s+PwjU5LdzWLNYAV1SP05eatC2d1lto4PmG5T7GWbiLi7TMtMt0N8mzNq9LfqAmXAODOX37lRklU7bZapodHUb63S4K/n/xh4hk4ep7eRiZzPwCKlLezZsgcgfJcmocxWLw/rNfSQ23qz/w2FH9w8eP69kamT/9wEEWz2fZNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199015)(36756003)(316002)(54906003)(6506007)(186003)(1076003)(83380400001)(2616005)(966005)(6666004)(6486002)(26005)(478600001)(6512007)(41300700001)(44832011)(8936002)(5660300002)(86362001)(38100700002)(2906002)(4326008)(66476007)(66946007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N+n9AFpabryHXRahR92WoeEPwcBZAVlsgR7ID5K7mxoG4S07eZEdq04PV56p?=
 =?us-ascii?Q?q5dMfqUPerRk8ULEaLGKWAUf8uHyMglPAkV2QdaF9sGDolVaW2qI0dP+s1ZB?=
 =?us-ascii?Q?cnG/hKAkuOy4u7gqZbCyBtW9UKvf6H/o5O0PZSO+hF2y3BnBjvNt9jL5LsPt?=
 =?us-ascii?Q?Zf81DezPKw8goL5Ok7R0WL8eKEgzvAUa1O2o2Yjwgcb2jHWZFEtn70cGNDWn?=
 =?us-ascii?Q?Oufd+rVy1VjDPcl+0T2Ui66MO/K31jsRUTCtec4E0qyMDO1drq9l+rTcWBU0?=
 =?us-ascii?Q?CZSnd38JU4nJAKQjOZ+cG8mAGysfjrJOi9hvT4CGHAL4eXgN2PQytZY1EZAy?=
 =?us-ascii?Q?AHjGyChB00vHoj9NnYJKdVW41Y4Jl0Vzo7e0SqF2cYjezmNUI3OHO/iuT/hl?=
 =?us-ascii?Q?cH7DrHAeqEZuwAAyFaxpK1K0YwjYQccbJQekWiDHxO9hkoK6+slYBXHSrFnc?=
 =?us-ascii?Q?JsV9dtI824QXXxhaTwdKjnVptTbkZvYTd59smERZCKcMKbo+sg1sqoZvsrLe?=
 =?us-ascii?Q?L9U1vLez5pDiT/ULOS++6rLXKbYftTt4eu73eNpNsX0RQzgX8wIiNG0BO0HI?=
 =?us-ascii?Q?XUrGnl4x+MCbVEw1QFCP+2htHpn7TX3u4iq5YsZj4/sgxt5JaTki/+FQ8Vpx?=
 =?us-ascii?Q?8gDDzNwtDs9IxBdC3UlqjfJn4lellapJNGBlTdr3Unyac4jVEjrxdwZWrt5a?=
 =?us-ascii?Q?R+YroAtwVGFmu+cy4Kv27BrFh693TlgTIbnD0QCZBwvFGG1UmZ9IV5f8+Igs?=
 =?us-ascii?Q?wKd69vtfeX7RXIxIfteuxrRaPkuywvsLZkPbYH3C2ar0h3DrKKbevBSvHOI3?=
 =?us-ascii?Q?KE3rjCPBhTU0x7JppgPjeKM+D6iaUslIBHoLaxR+Dg4cr0Gv28JPA35fzbZj?=
 =?us-ascii?Q?gcnPTUWPUifrEA6M3c24K7EXWh/Ymn3hwc/OWjgL9YlZ0wtFDHKBL7yU6Qub?=
 =?us-ascii?Q?YCTzOpe0auaByXvWpFrEvQzxf8e5SwM41ecVzBO6Rqa1FTNupCx71ddKuxRr?=
 =?us-ascii?Q?GNTcA9GqTGuelKsgT2v2ZAYqq9PyaUWFsc2plrFhZLGXdACRqjaDLPQata2h?=
 =?us-ascii?Q?XsADBtWutTiqAl3T2wokkLdyQfx6o4uI6jqSHIU3e4agCclVbAhHLj37Vr4Q?=
 =?us-ascii?Q?Xf2xwWBzLR11Eem3xEmdn+1NHjC9v/ewTeUT5KKlSkQn4Br6FlJWV48RTXHS?=
 =?us-ascii?Q?yfmoeR5pk5Ey3JUgwBmycQhMmFTY4KOTvJEexY5/+iFRGYBGamiMy6TlFtQk?=
 =?us-ascii?Q?/fuhnOtUnwSaqfXid7NncbU8q5NcPAodZ8wbZiVklNc3RkVQQjyhaUMmFHJn?=
 =?us-ascii?Q?c1pyAHCiKxsIVBjLCNV1DrOC0ALrkNIcwVoUKgJfbIRoYmF3SqkJURKAxXsH?=
 =?us-ascii?Q?sptKKQI91FLzgiKycO00JkAYKNTcgN1toSoiPE4naQtX5OYAUa0skCPhsbG/?=
 =?us-ascii?Q?kaT+BRp1tJVuryIOnn6TcUmP/7nPveEyK0uTAeCeYoBLVvnu6rCQDRQR3wcX?=
 =?us-ascii?Q?GirqBujFf78iucHLVUXDcqDrondbqVohk1a03oLwyzFNrXPPv39Ma9p11ggk?=
 =?us-ascii?Q?z9JZ5UXjJ7CXRvklqMdv/GIAvMulYVBZPwOfeAWRmYHFQz0z8sH32fxGU0bV?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?B0jU1IOSbQ5B1HogZS7YxsgidX+v+JqY3prIDfY9XJojB3fWLOCTjzEGy7I4?=
 =?us-ascii?Q?3Am459dgcV3Xvlo1X1HQbNzxKnfea1JljCdv6KJM6gdTwLKSJNtMS5fi85ZT?=
 =?us-ascii?Q?3O4+8NnlOvh8ZmSF+/91Bwn6sPD/H2JS1r12AHUyPf719f1ZSJxbR0CZ/sW0?=
 =?us-ascii?Q?6F1EbhMUflK/yeuaIwLzdn5PpOA2C2u93AGFMYg39di6R9GKzyHWNshBOQqa?=
 =?us-ascii?Q?wPZgeZPzp/KfNPZwp26AVjZc9Iovlt2vUC80zvR38WIFsis2rp6o4OZya6+z?=
 =?us-ascii?Q?LV3AMz/l6JuuDG5JxDZvUkcpgJW6Rknoc7eVs6AdSgQQGtnpUiwXzXgPOoIt?=
 =?us-ascii?Q?Fv/tnptcYxOIT/Fc5aK91HQUj6tRh3DAtpVMU9wJ1qNKOqdzIRX2rV+VeIyt?=
 =?us-ascii?Q?wR3lYIAtrOTK3SsCbSUqfF7NahNElRPzZKYG+RPiVz+ljvw6eq+Y4ZLpyNCE?=
 =?us-ascii?Q?NeCI2M8ANDOMmsSRckvIKG2LYT3jF6UuCHhvX2aUqS81/PWE7W5lN+972ask?=
 =?us-ascii?Q?wdykoKsKpfdsiwAwr453HTf53ZNq18Rf27P27RzTTcGqdHzcBKhKjXB1UGjx?=
 =?us-ascii?Q?FTMQmkQWlHjaFY7VVhjP3/+JbDxk0ZmsCxZCVtLYe5tgDkcNGnf6nceAYQ8B?=
 =?us-ascii?Q?B8g0zREQE5kDcmfxGZRWyAFrdrbl19AW8Fro5PnrNW+B7uS8u/R8HDZMNJZK?=
 =?us-ascii?Q?hBMnXjZE6Fyu3Q170xr1WIMDez/xbSa4ZjzjRKa++R1LKtW7tFr/yEcYJBek?=
 =?us-ascii?Q?KeB/EFc2W6cFPXOdqxpGcjwTprh1i/vxIrln/EhX8Yks/5E119x1NkIGch1b?=
 =?us-ascii?Q?BkicfZp25ZLuqNxZYCyhoitAv5fkWl2DEYVCn/mk8R2/ixj7E+uJq2+5XMR4?=
 =?us-ascii?Q?2KjsVvIjSKAEKgWnzwOL9jvMwcKlGk6UUI/jplQfW29EfzO0Pf7EE5c9Ldbw?=
 =?us-ascii?Q?U8d/ARnMqL+9kM7iq3ihXEAvODmxkI5oFw5490o2Bk89k29sGB06EbwutHYd?=
 =?us-ascii?Q?IVYuuFz14ObatVjzGIgc7AUPOQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6e0f68-266a-4d9d-9cb3-08dacd8c8156
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:54:17.6962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmNN2CTC1h+bJNQBNp5A0WAFljI7LMw3g1hTVa8U2IBdtuNwHrajemEOhDFXSz/JXF1eufSFXepbpw0uuQqQGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_11,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230147
X-Proofpoint-GUID: y5DIevq3OccUe0nk_iK2G2U1wj8_N1G3
X-Proofpoint-ORIG-GUID: y5DIevq3OccUe0nk_iK2G2U1wj8_N1G3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit a7605426666196c5a460dd3de6f8dac1d3c21f00 upstream.

The current behavior of memory failure is to truncate the page cache
regardless of dirty or clean.  If the page is dirty the later access
will get the obsolete data from disk without any notification to the
users.  This may cause silent data loss.  It is even worse for shmem
since shmem is in-memory filesystem, truncating page cache means
discarding data blocks.  The later read would return all zero.

The right approach is to keep the corrupted page in page cache, any
later access would return error for syscalls or SIGBUS for page fault,
until the file is truncated, hole punched or removed.  The regular
storage backed filesystems would be more complicated so this patch is
focused on shmem.  This also unblock the support for soft offlining
shmem THP.

[akpm@linux-foundation.org: coding style fixes]
[arnd@arndb.de: fix uninitialized variable use in me_pagecache_clean()]
  Link: https://lkml.kernel.org/r/20211022064748.4173718-1-arnd@kernel.org
[Fix invalid pointer dereference in shmem_read_mapping_page_gfp() with a
 slight different implementation from what Ajay Garg <ajaygargnsit@gmail.com>
 and Muchun Song <songmuchun@bytedance.com> proposed and reworked the
 error handling of shmem_write_begin() suggested by Linus]
  Link: https://lore.kernel.org/linux-mm/20211111084617.6746-1-ajaygargnsit@gmail.com/

Link: https://lkml.kernel.org/r/20211020210755.23964-6-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20211116193247.21102-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ajay Garg <ajaygargnsit@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Andy Lavr <andy.lavr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/memory-failure.c | 10 ++++++++-
 mm/shmem.c          | 51 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 1d37de089008..7d96be8e93b7 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -56,6 +56,7 @@
 #include <linux/kfifo.h>
 #include <linux/ratelimit.h>
 #include <linux/page-isolation.h>
+#include <linux/shmem_fs.h>
 #include "internal.h"
 #include "ras/ras_event.h"
 
@@ -705,6 +706,7 @@ static int me_unknown(struct page_state *ps, struct page *p)
 static int me_pagecache_clean(struct page_state *ps, struct page *p)
 {
 	struct address_space *mapping;
+	bool extra_pins;
 	int ret;
 
 	delete_from_lru_cache(p);
@@ -731,6 +733,12 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
 		return MF_FAILED;
 	}
 
+	/*
+	 * The shmem page is kept in page cache instead of truncating
+	 * so is expected to have an extra refcount after error-handling.
+	 */
+	extra_pins = shmem_mapping(mapping);
+
 	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
@@ -738,7 +746,7 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
 	 */
 	ret = truncate_error_page(p, page_to_pfn(p), mapping);
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
 	return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index d3d8c5e7a296..8b539033dfe2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2521,6 +2521,7 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t index = pos >> PAGE_SHIFT;
+	int ret = 0;
 
 	/* i_mutex is held by caller */
 	if (unlikely(info->seals & (F_SEAL_GROW |
@@ -2531,7 +2532,19 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
 			return -EPERM;
 	}
 
-	return shmem_getpage(inode, index, pagep, SGP_WRITE);
+	ret = shmem_getpage(inode, index, pagep, SGP_WRITE);
+
+	if (ret)
+		return ret;
+
+	if (PageHWPoison(*pagep)) {
+		unlock_page(*pagep);
+		put_page(*pagep);
+		*pagep = NULL;
+		return -EIO;
+	}
+
+	return 0;
 }
 
 static int
@@ -2618,6 +2631,12 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			if (sgp == SGP_CACHE)
 				set_page_dirty(page);
 			unlock_page(page);
+
+			if (PageHWPoison(page)) {
+				put_page(page);
+				error = -EIO;
+				break;
+			}
 		}
 
 		/*
@@ -3210,7 +3229,8 @@ static const char *shmem_get_link(struct dentry *dentry,
 		page = find_get_page(inode->i_mapping, 0);
 		if (!page)
 			return ERR_PTR(-ECHILD);
-		if (!PageUptodate(page)) {
+		if (PageHWPoison(page) ||
+		    !PageUptodate(page)) {
 			put_page(page);
 			return ERR_PTR(-ECHILD);
 		}
@@ -3218,6 +3238,13 @@ static const char *shmem_get_link(struct dentry *dentry,
 		error = shmem_getpage(inode, 0, &page, SGP_READ);
 		if (error)
 			return ERR_PTR(error);
+		if (!page)
+			return ERR_PTR(-ECHILD);
+		if (PageHWPoison(page)) {
+			unlock_page(page);
+			put_page(page);
+			return ERR_PTR(-ECHILD);
+		}
 		unlock_page(page);
 	}
 	set_delayed_call(done, shmem_put_link, page);
@@ -3866,6 +3893,13 @@ static void shmem_destroy_inodecache(void)
 	kmem_cache_destroy(shmem_inode_cachep);
 }
 
+/* Keep the page in page cache instead of truncating it */
+static int shmem_error_remove_page(struct address_space *mapping,
+				struct page *page)
+{
+	return 0;
+}
+
 static const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
@@ -3876,7 +3910,7 @@ static const struct address_space_operations shmem_aops = {
 #ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
 #endif
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_page = shmem_error_remove_page,
 };
 
 static const struct file_operations shmem_file_operations = {
@@ -4316,9 +4350,14 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
 				  gfp, NULL, NULL, NULL);
 	if (error)
-		page = ERR_PTR(error);
-	else
-		unlock_page(page);
+		return ERR_PTR(error);
+
+	unlock_page(page);
+	if (PageHWPoison(page)) {
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+
 	return page;
 #else
 	/*
-- 
2.38.1

