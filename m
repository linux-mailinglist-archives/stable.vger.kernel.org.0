Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CDA5F5015
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJEHCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiJEHCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:02:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D3074DE3;
        Wed,  5 Oct 2022 00:02:08 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956heG7004933;
        Wed, 5 Oct 2022 07:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=KmRk2pBB1isJmGi2/NX9hQfR+uUw/a7ooBtI2GZOyDI=;
 b=CbuCLDzVEDIgrhUaFNn3iIHdFiwXBSPUbxpjEyUVvdnchU9ASESjWBJvnSW/ydyyS+XG
 bnm0LKiyWWyGLvasbv+qrNZoNJgGIKwwzliljhCIH3q+3+QlPX+myb/weqF5yGXCMSWZ
 l/ZxhRjyB8nu3LXEl7x6yA8WgrkUce+9x9+NmIW8L1Rq2dld+eECIgXTBdw2NMIiitOB
 G59seDRKxudMfXl60DSwInmpamX9IZbapresZbkGr1zrmPSciuHhQsEJIkZqxDDTEyh7
 Mr3Wf2/euzuFXg9jeD9f/zGF8wxTFJ7yHfbhCRG55JNBjhGQ0XDrHSXKbF+O8SM5jD8/ DQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn858h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:04 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2953l55O000482;
        Wed, 5 Oct 2022 07:02:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc05ckn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEuaDlDR9ygqe/Xvp1v92TxfuivRlSIefNGIS/PR//0jfkZEpdsnHwMExUZBz/QXEkjnQiXkeWG+H3sQvh//6LEseNsgJIAuSRj0vMqiijv5JfCQ1L4pW8qVmrCMUWs4W7DUX9wzwX8TbJPlDQdCsD4fBtJscz9VqEjw5vcxaBq9gi8VQAFt0J8SU+jlCZDPBgqZdh8lLpCyKXiwYXy9UyOyV751cxsJ9/0TfMtudfIfG+VCLp0ggG8DjQawTuhBH2uDc+BiSkyxI9QUvwEl5WkUV81IIq8GnleUm5UN0dMfKlSJ4JiWGR0T76IGirJZFEgfaYvPPqx+ncJv0g7Wfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmRk2pBB1isJmGi2/NX9hQfR+uUw/a7ooBtI2GZOyDI=;
 b=ayrx8e3QJk702QRyr2wZ5fkq53/GulzFQDfyoEMDCn6XQuQPnNATi3gQsVcit/Wizq+0rse3gY4BaO9QUL2Rf9V2i3HsgYNvIaSwn7Vd25hkJ81QknWC1oR67r1UWT9VWO0/RVIjUeK79W0KIP/gTRi2L6j+vgtlKGQgcMsWxSZ2wkhIiy8HTw3q362il5uYkI20GqDHYRXUdMUdir5INOdhqHf34djVlHMpV7Qw4kBXxysGKdGOhWC//1jerEFusDTWefXe5tEMgKp1YiBJz++qZtYzFhY6CweevsTMKWwyEK6V9+7HbjkbjCmnDtGNeixxWhOv28+CNHVXaXAafg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmRk2pBB1isJmGi2/NX9hQfR+uUw/a7ooBtI2GZOyDI=;
 b=OvjmezytisjxxjZVuCjSaSCMAgR6zJqcNtIQw0/iN9vByLbD/rYmgNp25nJM6ihv5z87zHX167cC+07zEqbG8BdXLHZn9IkkSyKA3tRz3Umot2nWnWh89jbcGVvQjvNT0sipVCoN+mtrksGBJjhshBbU/x0oVVyg9MgmshUHEO4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:02:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:02:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 07/11] xfs: fix memory corruption during remote attr value buffer invalidation
Date:   Wed,  5 Oct 2022 12:31:01 +0530
Message-Id: <20221005070105.41929-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0095.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b4::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: f3b7eccc-13f8-49f5-6253-08daa69f809c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8/lR6JqWIg7/A/5TpydVOi9McZ9ZFj4Tv6vqPPrss6zBhrh89JCw5JsTa5EetvUeg+DeFPPH236icKnvTKrLua848S8Gu1b0wJymFTpme9fAyo5LcFZvHI0DLDojr8aMFsHisRYp0rDP1jZxos54jUS3KSrNJv6HMrp7ucbU0Z6BkWfens4UIFKEJ2v/elD/dej77F/93mCKtdTJfh0jn6B5Ivw+P6hA4jL7UIWQ2racyVvLrEvlfWd1bk4wPveUKzSqyA8HQ8WM7MIhhSc/rehxRuIgYsDriebRxWUSGt68Ai2W/Jh1KPjF9yq6EvIutgJ9Wg4SWJuij50Kg8yXzMGCQ46mIZ0IrUUuJmbHKYRlkbcA8WKLqL1wKFUSJq2VlBCGurlgqdIBUY0dg5qzaffbKkDGvHCu33HMycw9wqo3cVzY6glHG4sVuP90yF7gE6meVAxII3gbPY8rcL15/ApmSc4/6IPNA9fcrERvTzQ1rRGEL4DeCDDCqmAmjkOGfrexikVwWbtqHnyM6f9EvAC7edBsaG6DM7drY9SqOIfyK74I8PNFfSCqqyqd3ZI4M2J1BgN4n6EvFjMMbYk9DmsqQAElS4SFPajx+5QZHJ4DBAailwA7CsDb0UKlCV+8xw1CXdoLyRrZnMk/0gOmjAVHmoUtrYwpoJ7Zm5S81iNnzv2BWS0W3DT6SdpUFDe1cLeO9p958d96s3+J2n5Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9R7a41QfFVIhFfgxyH05VEPYHtc+O0bbmCXK5jS/Pe7vAD8cWqDyF919aQ7o?=
 =?us-ascii?Q?Pn5cMlK9WORdsBLuA2j2HSGHIAviEC7lEWnMf0SjQFYWhLBT0Um7nJQFIxX3?=
 =?us-ascii?Q?VEA2vQGdECCmCxEwWIdrwTsN/fwXxJW/IxLS26X3fDAS5dN7vvK1fxNDAwnL?=
 =?us-ascii?Q?OfyeM2O+gXToLz8I/PEyW408dB5cC612Y+G8y1NzTXOJsJ2b6udhc1QhKi52?=
 =?us-ascii?Q?b4wj3Bk25qkbuCCUxg9pJlcQEkHLjKi6KRTmq1TBPf/9QuhXpgVekofxpV6f?=
 =?us-ascii?Q?syAg/Q8YPOsZzFMmxCWD3iWVIgSePMU4e6rsnaoF/1+m/E/IZPA7i5q9PIYE?=
 =?us-ascii?Q?CUq16I1mFQ1AQ42eknehCqSS2NxMmFhhvo2gedDPbDn3CNCETee1sjggQ8rT?=
 =?us-ascii?Q?akffS8WIhORFbXPM4AisuTzHY5dvg1Mn12cLLSIYy2Lv4P/iiPx3fpinf97j?=
 =?us-ascii?Q?zREdMLRuZuGC6bUL9RDkg9rktgM4RIQ4tgfqa7LA/NrfSyX1FJ7flT7bcSH1?=
 =?us-ascii?Q?zfjzuilBrF4hVOjwgLALYc1mExoFHL+H75UC7gl8PmCHtv0h/xXmwKzDJE9L?=
 =?us-ascii?Q?a4ydz+otFzkzBhBIT3C1RSuJtmBol5KNrgqsKbP/AswcctKiwPH0HO3dG4yY?=
 =?us-ascii?Q?UoNWjwPsVzaxleyFknfFR7XwmZnLxjnMGVX4BUUwAPpAz7GFwjGrGGnVY7Mv?=
 =?us-ascii?Q?rQ8jAIbV27TS5R0lYPVjl7Kp4cRDwelWHGgH5YmlsiNuaVARZ02kvbk5frmd?=
 =?us-ascii?Q?AF6O7cZJ+94LrPrhdttZOKYDm63QPjiBGjG7wasCGxCcLfoG/W0aK6VbUSAP?=
 =?us-ascii?Q?xGmmzQ+Cs3rqMot4yPFncs8w3dSRo4CJ8VfdU9ktf3md5SXFBQXfW+hy27H5?=
 =?us-ascii?Q?AN/BgssK0e6pEfu+3bcY25ssgX6PZItNAiQeXuX8cZFFZdoAcfohkMzQCNNZ?=
 =?us-ascii?Q?KPfzfAwWWkRuECLoFFQfK7/gbhnpMqVOz+NOPSNzrtQqgEawtGzbrS/GXJ9m?=
 =?us-ascii?Q?BZjENLeQF9By0ozXmAd+Unoo2KpUFfppjqzPgiWHN/TCf7EucHN8YHrP1iQc?=
 =?us-ascii?Q?h4oenMqBEk9uQyJS4eeahtGtnS4BFFNLMaCmuqSoLhD5AfqrvgiYC6HAWTER?=
 =?us-ascii?Q?3T+9uxJY5dZOhQ4vTw7yANk5ElYPSUgznSIFiOem2q5UTxzvIe5nMPMzv2Xz?=
 =?us-ascii?Q?ljy3L/EQ+VXNx3tg248xalZgtVwigujBswMD4lZRaVXxddbZJI1zSZnQmvH4?=
 =?us-ascii?Q?VRGHT0AeccfUmQNQCgkVapPQgmoDjYfgOwe059b3LJRBgaBhPOfYqJM6H2hI?=
 =?us-ascii?Q?TtDIBH9dPaiX9v2Ox2TQccoWG6IhAecVAuIeumQsHGUYsFZjqcCajCbnPygI?=
 =?us-ascii?Q?X2Z0kSAY6UJrvakMabCspwv86EhsnfVRfhCgJnW5F3/xmhYfiIs4Ocao++ap?=
 =?us-ascii?Q?7ZgNCfUyAV8/GwOMHZvvsVVenq3PsmPl/UYdqd0jaZeL9DF1jjkeRo44FtaU?=
 =?us-ascii?Q?intbO2PMsFXFr2xes89B9VmIIvM4WL1fvq9M5TEUbTO2ADu9pMZlz2CNfULk?=
 =?us-ascii?Q?4j+kzXbnuO2Otj5a8SNXfnNGv3vIS4MRhlSzNVnmsp2tvsiDg+2ohJDapkaC?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?1sYLxaHZgmj/Nn1STcSqhcD8oZX3cTyb0VF/9GW+StM76fFRC9YSp2UcRGX8?=
 =?us-ascii?Q?xiP7vMSYIhogd4R+7vMqOyl2FzkEI2cLKRy5AJJOkhLK3i2mEq2KZxAt1Yqd?=
 =?us-ascii?Q?fLymrlEbENqDZqDA0k0OsBu2+Qfjt8S8w2dG0ImCpA+XJSB7GxHsRag8bGdV?=
 =?us-ascii?Q?3G0fjIj27tW3WH229spkbLUFvAO70HIX59rcz3B2OriFLy1nVDZTRoSwtklO?=
 =?us-ascii?Q?qn1gyD1Le1uZLvAd2qedSPqKqA0kj7pZD7vb2NzhyadJNiiUHIdwtZmKmaZY?=
 =?us-ascii?Q?C42wJpQJBybuFbCLRX2XM+180pS0u0AS6uqoELH2dbSPEl3S9jC6VKFSumNn?=
 =?us-ascii?Q?TdU1bR02dwAQCh7pikKwE+O9j0RUGQCMq6BFrVzQNGvpzjg9oe3ddf7/YF0w?=
 =?us-ascii?Q?wYFzdWYisz2cEojXkvuMBZKsPRoYc1VJecjEZbM9cLKqlOKJi+WQ4AfONU4h?=
 =?us-ascii?Q?FF8T3s4Wo9WfE/GaKp6OEBVSgTacqay1MRgRehzyg3dqzAVnjjXWM8o3Grq1?=
 =?us-ascii?Q?JjBZw5EmwdfY51BMY8EAhUotTjOtWSEC4VEwvp51Dn37ChBTvWmsXRvdLwoK?=
 =?us-ascii?Q?oYKbmqtSXfakVLdCSfrtJSUXs4Xmg+aUPnQFVQJBCvN2+Lkzt3yijc6cbybq?=
 =?us-ascii?Q?TK+xG2hzQQS/Ys1OPWNgNrcsFOuzLEkyC9fVQSnTIxKlCH6QSuMxFvslGddq?=
 =?us-ascii?Q?OQ92BOqTRz07t9Y2UoiJ8upqIx9beHqw6Smnh+stvYSGIiozeQ1XzBJ6QPW7?=
 =?us-ascii?Q?xcdQQDFskUNhxuUapgTVcogrVdcdKmiSpIp2+6lIvRmBxhvURjtPYWxXjvYn?=
 =?us-ascii?Q?XDna++ernFcw6h7EqU89FMRLEUk6WaxHFVGbXMU7IvumPEav0+RqEE2+YuOw?=
 =?us-ascii?Q?f8Bz5yuTs/n1/m+gMTdLfUggIsoSPVGf2O1I3+wxsy749UNDfUaCZu7mBZMw?=
 =?us-ascii?Q?XmJdwZZK6GtuO3/c316WuaC+pzSkOPRW8YbNTxvf3EzJDag3fhIxaf/laIiU?=
 =?us-ascii?Q?tyuD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b7eccc-13f8-49f5-6253-08daa69f809c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:02:01.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9CJKdANl/aWKBy0reICsBSyu4h767Gns2/VflwFXgbSPhpWWCEz7q0xaCY1c2gHcooWjS73G06FWNspPVQE5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050043
X-Proofpoint-GUID: M_TJTWuxBTij7olg2-BMfCVE7Sj8m36_
X-Proofpoint-ORIG-GUID: M_TJTWuxBTij7olg2-BMfCVE7Sj8m36_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit e8db2aafcedb7d88320ab83f1000f1606b26d4d7 upstream.

[Replaced XFS_IS_CORRUPT() calls with ASSERT() for 5.4.y backport]

While running generic/103, I observed what looks like memory corruption
and (with slub debugging turned on) a slub redzone warning on i386 when
inactivating an inode with a 64k remote attr value.

On a v5 filesystem, maximally sized remote attr values require one block
more than 64k worth of space to hold both the remote attribute value
header (64 bytes).  On a 4k block filesystem this results in a 68k
buffer; on a 64k block filesystem, this would be a 128k buffer.  Note
that even though we'll never use more than 65,600 bytes of this buffer,
XFS_MAX_BLOCKSIZE is 64k.

This is a problem because the definition of struct xfs_buf_log_format
allows for XFS_MAX_BLOCKSIZE worth of dirty bitmap (64k).  On i386 when we
invalidate a remote attribute, xfs_trans_binval zeroes all 68k worth of
the dirty map, writing right off the end of the log item and corrupting
memory.  We've gotten away with this on x86_64 for years because the
compiler inserts a u32 padding on the end of struct xfs_buf_log_format.

Fortunately for us, remote attribute values are written to disk with
xfs_bwrite(), which is to say that they are not logged.  Fix the problem
by removing all places where we could end up creating a buffer log item
for a remote attribute value and leave a note explaining why.  Next,
replace the open-coded buffer invalidation with a call to the helper we
created in the previous patch that does better checking for bad metadata
before marking the buffer stale.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 37 +++++++++++++++++++++-----
 fs/xfs/xfs_attr_inactive.c      | 47 +++++++++------------------------
 2 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4e5579edcf8c..de9096b8a47c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -24,6 +24,23 @@
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
+/*
+ * Remote Attribute Values
+ * =======================
+ *
+ * Remote extended attribute values are conceptually simple -- they're written
+ * to data blocks mapped by an inode's attribute fork, and they have an upper
+ * size limit of 64k.  Setting a value does not involve the XFS log.
+ *
+ * However, on a v5 filesystem, maximally sized remote attr values require one
+ * block more than 64k worth of space to hold both the remote attribute value
+ * header (64 bytes).  On a 4k block filesystem this results in a 68k buffer;
+ * on a 64k block filesystem, this would be a 128k buffer.  Note that the log
+ * format can only handle a dirty buffer of XFS_MAX_BLOCKSIZE length (64k).
+ * Therefore, we /must/ ensure that remote attribute value buffers never touch
+ * the logging system and therefore never have a log item.
+ */
+
 /*
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
@@ -400,17 +417,25 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_trans_read_buf(mp, args->trans,
-						   mp->m_ddev_targp,
-						   dblkno, dblkcnt, 0, &bp,
-						   &xfs_attr3_rmt_buf_ops);
-			if (error)
+			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
+					&xfs_attr3_rmt_buf_ops);
+			if (!bp)
+				return -ENOMEM;
+			error = bp->b_error;
+			if (error) {
+				xfs_buf_ioerror_alert(bp, __func__);
+				xfs_buf_relse(bp);
+
+				/* bad CRC means corrupted metadata */
+				if (error == -EFSBADCRC)
+					error = -EFSCORRUPTED;
 				return error;
+			}
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
-			xfs_trans_brelse(args->trans, bp);
+			xfs_buf_relse(bp);
 			if (error)
 				return error;
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 766b1386402a..9d5c27db1239 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -25,22 +25,20 @@
 #include "xfs_error.h"
 
 /*
- * Look at all the extents for this logical region,
- * invalidate any buffers that are incore/in transactions.
+ * Invalidate any incore buffers associated with this remote attribute value
+ * extent.   We never log remote attribute value buffers, which means that they
+ * won't be attached to a transaction and are therefore safe to mark stale.
+ * The actual bunmapi will be taken care of later.
  */
 STATIC int
-xfs_attr3_leaf_freextent(
-	struct xfs_trans	**trans,
+xfs_attr3_rmt_stale(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		blkno,
 	int			blkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	struct xfs_buf		*bp;
 	xfs_dablk_t		tblkno;
-	xfs_daddr_t		dblkno;
 	int			tblkcnt;
-	int			dblkcnt;
 	int			nmap;
 	int			error;
 
@@ -57,35 +55,18 @@ xfs_attr3_leaf_freextent(
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
-		if (error) {
+		if (error)
 			return error;
-		}
 		ASSERT(nmap == 1);
-		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
 
 		/*
-		 * If it's a hole, these are already unmapped
-		 * so there's nothing to invalidate.
+		 * Mark any incore buffers for the remote value as stale.  We
+		 * never log remote attr value buffers, so the buffer should be
+		 * easy to kill.
 		 */
-		if (map.br_startblock != HOLESTARTBLOCK) {
-
-			dblkno = XFS_FSB_TO_DADDR(dp->i_mount,
-						  map.br_startblock);
-			dblkcnt = XFS_FSB_TO_BB(dp->i_mount,
-						map.br_blockcount);
-			bp = xfs_trans_get_buf(*trans,
-					dp->i_mount->m_ddev_targp,
-					dblkno, dblkcnt, 0);
-			if (!bp)
-				return -ENOMEM;
-			xfs_trans_binval(*trans, bp);
-			/*
-			 * Roll to next transaction.
-			 */
-			error = xfs_trans_roll_inode(trans, dp);
-			if (error)
-				return error;
-		}
+		error = xfs_attr_rmtval_stale(dp, &map, 0);
+		if (error)
+			return error;
 
 		tblkno += map.br_blockcount;
 		tblkcnt -= map.br_blockcount;
@@ -174,9 +155,7 @@ xfs_attr3_leaf_inactive(
 	 */
 	error = 0;
 	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_leaf_freextent(trans, dp,
-				lp->valueblk, lp->valuelen);
-
+		tmp = xfs_attr3_rmt_stale(dp, lp->valueblk, lp->valuelen);
 		if (error == 0)
 			error = tmp;	/* save only the 1st errno */
 	}
-- 
2.35.1

