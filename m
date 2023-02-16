Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06AB698C85
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBPGEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPGEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:04:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3776036FCD;
        Wed, 15 Feb 2023 22:04:37 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2J9rD011524;
        Thu, 16 Feb 2023 05:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=NoSb/qUJUN1juyauXhWAzMCVy5FNtE54kGsW5ut9azQ=;
 b=bz9wKezRfBuvQa2WcABkLSVmB/eLu5Ox9mi4lHLbKnozudnirjeY7XQY/I7IXp1i18KL
 YlmW5m1+4U/GRvh9IQP3GDu23J4pyuB6ZPio2XLwgOwEIYROUUdDhCAEExOo6086dObr
 brv8kvRcErpLUk2oHVZOnCkbNPv2W8kT1bLj29vqh94awHiB4EdBvCunSbVwnBetCxZt
 1tpnDKIVb6XCliPzyCcQeJK1UnaVbVOnDr7cxV0ghjy+TiZI/azTh8VEiRTX0eDIfYdN
 UFPtDbVgvFGFs0cAHM8c7xIiL3QjSuXsCg2kMWgVhFskKWdYXXtBtLgAJ2MC/WsJXyHn xQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xba81h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2U8PM003618;
        Thu, 16 Feb 2023 05:21:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f85f5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awvRf/UQTmHtDTujyOn0Ty5tvPwt/zqvvv4ERCQZBFL3BULJry3dnrVtMjfOFOuI0FoJws7A18b2ifBGrK1T/g+XNa4dX/1LPGrHQsJQaeOOrT/0W9BzgGsWFbY5eeNEUP8hIj2jTWmwRmIwvSlVG1j6vyJg8eURZZtoBOCEBMospOMOfi9CZr9Fpu/OLT35dxZR+8anWfu6dtszcOGnalxbz9N6SY6Q3GMeMs7tyF+RpC8kdEcWTplooF5F+T1BwgGXtcGjL8fA/GgeV69bs/jnspWVVWUnhVTIBRnyANOEsOuXw0Wvd8YEpSxTeXIgCTsBxp6Tlou/Ajg9S+NrmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoSb/qUJUN1juyauXhWAzMCVy5FNtE54kGsW5ut9azQ=;
 b=Yt33sTTqpa7tfXdokk4fP/rdRdzfPZXMs4nG71TvFNyhUtf965/HqHaSekLOrrics6x4CT7DAcCZSYfy6o5WZDPMGduEdFSjan2Fgm8K96b9BU/U/klpT8ojk7tjOgg25CrnPaAh3lTdUG0BEcsMPPxvepWaLxqGV23XvvJ4VaqGqqvGU9FALJ5GlVJOqmKB/tyn+TxqAHTl8UhYyaw+C4rluRpxcghjD8+mlZSmK6lLrw45qRME6x6osrfiIPgZdU10wDrHJ8dcjVingI+l9DpDDXOf329kFQF8EVNP3KV2z9nRcbMWGF8G8QZCNyEX9cHcpgHJNDBwoncHDJkZVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoSb/qUJUN1juyauXhWAzMCVy5FNtE54kGsW5ut9azQ=;
 b=iSoOoOgzFFWBJ2l25bFWiOhPbV4mWkQ9RaBBSKl3j7CQwsYsPNECPrVJQa6sZKKj4io1ZBBKp7kkbHydAX8pwvMJFxziZBaW8g20+paU6ZQHoXKtUpTByrUyqIwPXB5JSfr+eDb1V6g5Sg23j8RZsZpp8FeVxuHhovkzkQWQIOw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:21:44 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:21:44 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 11/25] xfs: proper replay of deferred ops queued during log recovery
Date:   Thu, 16 Feb 2023 10:50:05 +0530
Message-Id: <20230216052019.368896-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0194.apcprd04.prod.outlook.com
 (2603:1096:4:14::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b3cecc6-8ca4-4aba-28db-08db0fddb157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nFoRKPCCjCa27pNjFKZUHTdHoo27aqETg3ZVvpenbD+GwhQGGMm3uNw/mfqTurVjWV0pJntgx9/bYEwSE+aAykEumPHqdB03QndQ2oNUPu2uV1f7t3ERU0zjAd0jE+pslY6qhmBZdReIRD64B9Ul6iXZii/UWcxBIiwZaS+cWnKWfJakfAk+imIOSNSpEwpBzpwaquF+zTl6rEU0MoNpPgR5pMaZz+em3UmKo4IODUDICs0MQZ1ftDpaBFPk2kN/OIiJhELNFgL+DKwzQOA4F0o8DU3kzz16j4ywwK1YQSRaKc39ZREAclSaNGTe+9gWPSJG99IJ2J3o33ZPwCzz+0ldPVY0vX/2TMwJx72Jwy2tVOl0M1se+UZE/+aUp0nNmp+1g3B25jAberPHv6t6tq4piZYcLANXVrwx5bCYqK4HJL7p5N2Ui0J7QCpHq/lXOOu2PmsG0IBB45DuNjJcdy50lZCyx/kfIZsF4DBT0mGijpD7m9PXzjbChx4mjqUxJXg7nIWocTgNIjCbSsR89U0+TfI+ydWEIoWn8O9SLgqyr/G6ukkXfCTguQJKhdz3DT5SiBQ0u0WQd3/g/rkwzG0yIR6wOos42OAFgDEWHIVmuLqJ2mwoR0hPGA9OyO9qGygk2auXlWS/sh9/ivRulg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(30864003)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9lICjRlJrfAIiZ4ej4RymYp4FoCFmHYYvgFNfa8cOQsDaPr9ssH5R341Q0mO?=
 =?us-ascii?Q?UObTVrKwIunjqhG2j8pmcIVtxCRC4Ps+MRo8+wGI9zyk8neVkLI/QVrWvqxb?=
 =?us-ascii?Q?Zv2UXEcKqWRhfWkuCZlskc4CY2P9WMMcuHEHqXL8HDvEOl8g1AXBQssD8q92?=
 =?us-ascii?Q?KnVo00vz8DhKjcP//kAmOx3oQpb3RUZnWZaoAeQaQxgQ2kazdFhOaLS34e8x?=
 =?us-ascii?Q?tiaMdsyjY55/wKY9DfJVDZL7hvXJYxI2A/77RyWLZM8tOHSaiuCCXEwZYczB?=
 =?us-ascii?Q?lNkGc02ghwJHOuLMk0O+8aF2SuTvTcDNWR5Uys1bqHCZHqX65AODmgI4Luj2?=
 =?us-ascii?Q?9PlTCpHeGnoWYGXziiZQMtp6YBAgE+iY3ukpYbiESYtbtR4bZZB3l8EC9Nfv?=
 =?us-ascii?Q?tl+TXYOEk4xozAgp1XnL1MgiptUtKJNt9Pwk0McRrJwpnLWooTiwUH3wx5yg?=
 =?us-ascii?Q?xMWZD5p9usgaUAV2hk4knuHep8Ppr8IWY2PCjADdwzr6+Yncz6ACbiB2IhH9?=
 =?us-ascii?Q?UvzQfCk75Vq6omeVARJKiRLeiVS77Uyx/sQZi4YrdQ2O0UvUFzgnK2XSToei?=
 =?us-ascii?Q?oVQjJ7amuSU9q8/EGnUKwjmCMRoJ4Hb+iFBHhPp73wSZVxVsWcQSup4GwNId?=
 =?us-ascii?Q?tcH0GYVWP94zIGQDZCyUzqm5LuP4WFRpwrUCoIRo5akD9rl/YEJsPxyTIaiw?=
 =?us-ascii?Q?pX2C7Tlk4kmkDvQ2oqS79DNinxTj+579YJClOQtydMGM/D9jEbch6+LXfkLo?=
 =?us-ascii?Q?Mv1YDy0yK3B6O3jqnX9hZzSNDWGYeI7hBrzJ1OxQSuKwAZ/NFJiz3zBj5tO1?=
 =?us-ascii?Q?b45K818eft20jh+kj3itDk/0TKqHiYYCIIdJfVqTOiiTZ3R3TFtIQKDIwvpb?=
 =?us-ascii?Q?sRWMqA/cHoshLtUUOSLDQSD+8QJ8p0WPtPhvxuoaB8sxd3Nm1HVIrXgv77je?=
 =?us-ascii?Q?xgIWro7wN9GjtdOo/r/ocpESmxA45UUci62/tTIvIRruUdp6kcYxbeAp3nWp?=
 =?us-ascii?Q?BzjYSKb1lj3wCOg4ZvAkG0sNrJL7bZW80xu/bCm4r4U/UMv8UxTahdCpXRS2?=
 =?us-ascii?Q?WDO9pCg8OzkP0ZtvT+6osTyykDfX9KSfaQ2cF5lECzMJM/XJwIy7SQ1VVZ0M?=
 =?us-ascii?Q?WXoMvVbS8QBBqs2+LO6izxZusv8zBflLPx6QZlMhGxqJD4ctyuLTUxYW9RLw?=
 =?us-ascii?Q?/JRNEV4YJ4Fy0glSOlIKoCyObeN4mHC2ElQA+CLmm+v1cv7T70zA6snEpqYf?=
 =?us-ascii?Q?BZI3hrJfmIIc+Qb7q1/op7FF7Mr6qx71oTc0yQ3cm0yU2QGv1TN3RtIFOSaX?=
 =?us-ascii?Q?AiOdaexqAp9ftDHkm8pIoPfgRVvQbKTjwrckiJYXcSqOQIHldRXcTgNfB5vi?=
 =?us-ascii?Q?ebQWGTqRPDBwMjiC7WSOP/yRBC1C4Us04Lo6uj4+wJuHkghVOVV7SZiFpn47?=
 =?us-ascii?Q?SArBNhuWHrWJ7W5Vatd3S8ZkmI+Vs25wdwN4asWddugmftYkG81+LheIZyag?=
 =?us-ascii?Q?c2h42hxw+/Oy6qab5AWWVHnwsP3xA2yMgpT5kT+pODTE8Z62g7bMyfviMv7N?=
 =?us-ascii?Q?srAcYOdnbOa4ILp6FuinAVXzIOKqTNGWGD0BhPYUs/E1biQxo/hXw8KXWvKe?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3XAAkbZzqWI6tx9EiC9fV/mWzzfakWY8Iy5cI3CQKUWDjDZN/Ot2Cfoio9e2jLVvVWy+Q842IiHkefMYxkrLQnkWFrjVLIH8zZkIzXcohFzQUT42LFpbbxQu0tRvDWr1a0aJmG4ReOAlN/vWWISup+nk+rDQyfnn1FpQOO/NG6poBIeXL3WmhLms2k1YbQNq1JaBsuGDc9Q2shfoUITJOT58xrPE9i4HWMaW+atq9PrsoBepA1AvtUwavQjXenQD7t+hk7Y+JQovu6tV4ZMGUhJ0Lt/faJSnOcSiL0+HNpZSu31BWSoOARHHT78/H7jfEkd7gtiRIakNVhgAkxRsjX9KnAtMqpvZBkBuxlA5Va76QY97YEg851JdNW+rt9z9Ro8wAvvVBwj5guAbttj6R7sZ3OP9uQx3W694jkANFjU6dVqlO5nZSjTLlkUAIcn5qjnxNLFRhxZrj0q0Fjbv7+stNU6JvOzrb7TUpJaX8+CGpYg4dRnUk3TidXR6TWxGq49/EfbtIAhOYtd41h5rw/Qf3YNr/sroDqgDx935R43JZJhUGlJJrp7tyAuVUkM+2HYODZfWW1cQzLNjN5s7jXJzDgmlYneYMBmYuU0GS5y2BT7i6nsKD7W/dXxb5vMX0LXkfbrLB68DB0j2W8ZUmcZbt6+usmSL+tev6s6cNjEEZOd7AWieuEcb0aW1WZgLus1lRNBoUKHW+jPiJlUwU6SXOkWVZfKH+1jBlMEdY6P3QY7G/raEqiKukFCO5+DUm3yuwYriQMshaVoknoE6GV6smbX1/J5wMQIUIYBLG89K1EsTKI9unBF9gXJgo0yiz6LHyHWXEocXKHD/W9+Isb1eZKzQZu9nq9RL0UfYG+n0Z9zJyF77YO4xHOl8gxOH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3cecc6-8ca4-4aba-28db-08db0fddb157
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:21:44.3493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzbDS8+cCo9YE98Ek8HtoYwjuHgyVPdJYPwEXoE4eFYv6oNmguRklHlI3J9VXUHMZme/vZSe49+ByMJSNV7Puw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=980 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: SwA0ziOvhh_1DZww7PYEZYcF9X5U5vbE
X-Proofpoint-GUID: SwA0ziOvhh_1DZww7PYEZYcF9X5U5vbE
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

commit e6fff81e487089e47358a028526a9f63cdbcd503 upstream.

When we replay unfinished intent items that have been recovered from the
log, it's possible that the replay will cause the creation of more
deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
recovery should replay deferred ops in order"), later work items have an
implicit ordering dependency on earlier work items.  Therefore, recovery
must replay the items (both recovered and created) in the same order
that they would have been during normal operation.

For log recovery, we enforce this ordering by using an empty transaction
to collect deferred ops that get created in the process of recovering a
log intent item to prevent them from being committed before the rest of
the recovered intent items.  After we finish committing all the
recovered log items, we allocate a transaction with an enormous block
reservation, splice our huge list of created deferred ops into that
transaction, and commit it, thereby finishing all those ops.

This is /really/ hokey -- it's the one place in XFS where we allow
nested transactions; the splicing of the defer ops list is is inelegant
and has to be done twice per recovery function; and the broken way we
handle inode pointers and block reservations cause subtle use-after-free
and allocator problems that will be fixed by this patch and the two
patches after it.

Therefore, replace the hokey empty transaction with a structure designed
to capture each chain of deferred ops that are created as part of
recovering a single unfinished log intent.  Finally, refactor the loop
that replays those chains to do so using one transaction per chain.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |  89 ++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |  19 ++++-
 fs/xfs/xfs_bmap_item.c     |  18 ++---
 fs/xfs/xfs_bmap_item.h     |   3 +-
 fs/xfs/xfs_extfree_item.c  |   9 ++-
 fs/xfs/xfs_extfree_item.h  |   4 +-
 fs/xfs/xfs_log_recover.c   | 151 +++++++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c |  18 ++---
 fs/xfs/xfs_refcount_item.h |   3 +-
 fs/xfs/xfs_rmap_item.c     |   8 +-
 fs/xfs/xfs_rmap_item.h     |   3 +-
 11 files changed, 213 insertions(+), 112 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 4991b02f4993..0448197d3b71 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -563,14 +563,89 @@ xfs_defer_move(
  *
  * Create and log intent items for all the work that we're capturing so that we
  * can be assured that the items will get replayed if the system goes down
- * before log recovery gets a chance to finish the work it put off.  Then we
- * move the chain from stp to dtp.
+ * before log recovery gets a chance to finish the work it put off.  The entire
+ * deferred ops state is transferred to the capture structure and the
+ * transaction is then ready for the caller to commit it.  If there are no
+ * intent items to capture, this function returns NULL.
  */
+static struct xfs_defer_capture *
+xfs_defer_ops_capture(
+	struct xfs_trans		*tp)
+{
+	struct xfs_defer_capture	*dfc;
+
+	if (list_empty(&tp->t_dfops))
+		return NULL;
+
+	/* Create an object to capture the defer ops. */
+	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
+	INIT_LIST_HEAD(&dfc->dfc_list);
+	INIT_LIST_HEAD(&dfc->dfc_dfops);
+
+	xfs_defer_create_intents(tp);
+
+	/* Move the dfops chain and transaction state to the capture struct. */
+	list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
+	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
+	tp->t_flags &= ~XFS_TRANS_LOWMODE;
+
+	return dfc;
+}
+
+/* Release all resources that we used to capture deferred ops. */
 void
-xfs_defer_capture(
-	struct xfs_trans	*dtp,
-	struct xfs_trans	*stp)
+xfs_defer_ops_release(
+	struct xfs_mount		*mp,
+	struct xfs_defer_capture	*dfc)
 {
-	xfs_defer_create_intents(stp);
-	xfs_defer_move(dtp, stp);
+	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	kmem_free(dfc);
+}
+
+/*
+ * Capture any deferred ops and commit the transaction.  This is the last step
+ * needed to finish a log intent item that we recovered from the log.
+ */
+int
+xfs_defer_ops_capture_and_commit(
+	struct xfs_trans		*tp,
+	struct list_head		*capture_list)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_defer_capture	*dfc;
+	int				error;
+
+	/* If we don't capture anything, commit transaction and exit. */
+	dfc = xfs_defer_ops_capture(tp);
+	if (!dfc)
+		return xfs_trans_commit(tp);
+
+	/* Commit the transaction and add the capture structure to the list. */
+	error = xfs_trans_commit(tp);
+	if (error) {
+		xfs_defer_ops_release(mp, dfc);
+		return error;
+	}
+
+	list_add_tail(&dfc->dfc_list, capture_list);
+	return 0;
+}
+
+/*
+ * Attach a chain of captured deferred ops to a new transaction and free the
+ * capture structure.
+ */
+void
+xfs_defer_ops_continue(
+	struct xfs_defer_capture	*dfc,
+	struct xfs_trans		*tp)
+{
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/* Move captured dfops chain and state to the transaction. */
+	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
+	tp->t_flags |= dfc->dfc_tpflags;
+
+	kmem_free(dfc);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index bc3098044c41..2c27f439298d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -7,6 +7,7 @@
 #define	__XFS_DEFER_H__
 
 struct xfs_defer_op_type;
+struct xfs_defer_capture;
 
 /*
  * Header for deferred operation list.
@@ -61,10 +62,26 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * This structure enables a dfops user to detach the chain of deferred
+ * operations from a transaction so that they can be continued later.
+ */
+struct xfs_defer_capture {
+	/* List of other capture structures. */
+	struct list_head	dfc_list;
+
+	/* Deferred ops state saved from the transaction. */
+	struct list_head	dfc_dfops;
+	unsigned int		dfc_tpflags;
+};
+
 /*
  * Functions to capture a chain of deferred operations and continue them later.
  * This doesn't normally happen except log recovery.
  */
-void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
+int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
+		struct list_head *capture_list);
+void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp);
+void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 8cbee34b5eaa..e83729bf4997 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -425,8 +425,8 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
  */
 int
 xfs_bui_recover(
-	struct xfs_trans		*parent_tp,
-	struct xfs_bui_log_item		*buip)
+	struct xfs_bui_log_item		*buip,
+	struct list_head		*capture_list)
 {
 	int				error = 0;
 	unsigned int			bui_type;
@@ -442,7 +442,7 @@ xfs_bui_recover(
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
 	struct xfs_bmbt_irec		irec;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = buip->bui_item.li_mountp;
 
 	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
 
@@ -491,12 +491,7 @@ xfs_bui_recover(
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		return error;
-	/*
-	 * Recovery stashes all deferred ops during intent processing and
-	 * finishes them on completion. Transfer current dfops state to this
-	 * transaction and transfer the result back before we return.
-	 */
-	xfs_defer_move(tp, parent_tp);
+
 	budp = xfs_trans_get_bud(tp, buip);
 
 	/* Grab the inode. */
@@ -541,15 +536,12 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-
 	return error;
 
 err_inode:
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index ad479cc73de8..a95e99c26979 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -77,6 +77,7 @@ extern struct kmem_zone	*xfs_bud_zone;
 struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
 void xfs_bui_item_free(struct xfs_bui_log_item *);
 void xfs_bui_release(struct xfs_bui_log_item *);
-int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
+int xfs_bui_recover(struct xfs_bui_log_item *buip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a9316fdb3bb4..2db85c2c6d99 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -586,9 +586,10 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
  */
 int
 xfs_efi_recover(
-	struct xfs_mount	*mp,
-	struct xfs_efi_log_item	*efip)
+	struct xfs_efi_log_item	*efip,
+	struct list_head	*capture_list)
 {
+	struct xfs_mount	*mp = efip->efi_item.li_mountp;
 	struct xfs_efd_log_item	*efdp;
 	struct xfs_trans	*tp;
 	int			i;
@@ -637,8 +638,8 @@ xfs_efi_recover(
 	}
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-	error = xfs_trans_commit(tp);
-	return error;
+
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index a2a736a77fa9..883f0f1d8989 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -84,7 +84,7 @@ int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 void			xfs_efi_item_free(struct xfs_efi_log_item *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
-int			xfs_efi_recover(struct xfs_mount *mp,
-					struct xfs_efi_log_item *efip);
+int			xfs_efi_recover(struct xfs_efi_log_item *efip,
+					struct list_head *capture_list);
 
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0d920c363939..388a2ec2d879 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4587,9 +4587,9 @@ xlog_recover_process_data(
 /* Recover the EFI if necessary. */
 STATIC int
 xlog_recover_process_efi(
-	struct xfs_mount		*mp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip;
 	int				error;
@@ -4602,7 +4602,7 @@ xlog_recover_process_efi(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_efi_recover(mp, efip);
+	error = xfs_efi_recover(efip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4627,9 +4627,9 @@ xlog_recover_cancel_efi(
 /* Recover the RUI if necessary. */
 STATIC int
 xlog_recover_process_rui(
-	struct xfs_mount		*mp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_rui_log_item		*ruip;
 	int				error;
@@ -4642,7 +4642,7 @@ xlog_recover_process_rui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_rui_recover(mp, ruip);
+	error = xfs_rui_recover(ruip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4667,9 +4667,9 @@ xlog_recover_cancel_rui(
 /* Recover the CUI if necessary. */
 STATIC int
 xlog_recover_process_cui(
-	struct xfs_trans		*parent_tp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_cui_log_item		*cuip;
 	int				error;
@@ -4682,7 +4682,7 @@ xlog_recover_process_cui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_cui_recover(parent_tp, cuip);
+	error = xfs_cui_recover(cuip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4707,9 +4707,9 @@ xlog_recover_cancel_cui(
 /* Recover the BUI if necessary. */
 STATIC int
 xlog_recover_process_bui(
-	struct xfs_trans		*parent_tp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_bui_log_item		*buip;
 	int				error;
@@ -4722,7 +4722,7 @@ xlog_recover_process_bui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_bui_recover(parent_tp, buip);
+	error = xfs_bui_recover(buip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4761,37 +4761,65 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
-	struct xfs_trans	*parent_tp)
+	struct xfs_mount	*mp,
+	struct list_head	*capture_list)
 {
-	struct xfs_mount	*mp = parent_tp->t_mountp;
+	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
 	int64_t			freeblks;
-	uint			resblks;
-	int			error;
+	uint64_t		resblks;
+	int			error = 0;
 
-	/*
-	 * We're finishing the defer_ops that accumulated as a result of
-	 * recovering unfinished intent items during log recovery.  We
-	 * reserve an itruncate transaction because it is the largest
-	 * permanent transaction type.  Since we're the only user of the fs
-	 * right now, take 93% (15/16) of the available free blocks.  Use
-	 * weird math to avoid a 64-bit division.
-	 */
-	freeblks = percpu_counter_sum(&mp->m_fdblocks);
-	if (freeblks <= 0)
-		return -ENOSPC;
-	resblks = min_t(int64_t, UINT_MAX, freeblks);
-	resblks = (resblks * 15) >> 4;
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
-			0, XFS_TRANS_RESERVE, &tp);
-	if (error)
-		return error;
-	/* transfer all collected dfops to this transaction */
-	xfs_defer_move(tp, parent_tp);
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		/*
+		 * We're finishing the defer_ops that accumulated as a result
+		 * of recovering unfinished intent items during log recovery.
+		 * We reserve an itruncate transaction because it is the
+		 * largest permanent transaction type.  Since we're the only
+		 * user of the fs right now, take 93% (15/16) of the available
+		 * free blocks.  Use weird math to avoid a 64-bit division.
+		 */
+		freeblks = percpu_counter_sum(&mp->m_fdblocks);
+		if (freeblks <= 0)
+			return -ENOSPC;
+
+		resblks = min_t(uint64_t, UINT_MAX, freeblks);
+		resblks = (resblks * 15) >> 4;
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
+				0, XFS_TRANS_RESERVE, &tp);
+		if (error)
+			return error;
+
+		/*
+		 * Transfer to this new transaction all the dfops we captured
+		 * from recovering a single intent item.
+		 */
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_continue(dfc, tp);
+
+		error = xfs_trans_commit(tp);
+		if (error)
+			return error;
+	}
 
-	return xfs_trans_commit(tp);
+	ASSERT(list_empty(capture_list));
+	return 0;
 }
 
+/* Release all the captured defer ops and capture structures in this list. */
+static void
+xlog_abort_defer_ops(
+	struct xfs_mount		*mp,
+	struct list_head		*capture_list)
+{
+	struct xfs_defer_capture	*dfc;
+	struct xfs_defer_capture	*next;
+
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_release(mp, dfc);
+	}
+}
 /*
  * When this is called, all of the log intent items which did not have
  * corresponding log done items should be in the AIL.  What we do now
@@ -4812,35 +4840,23 @@ STATIC int
 xlog_recover_process_intents(
 	struct xlog		*log)
 {
-	struct xfs_trans	*parent_tp;
+	LIST_HEAD(capture_list);
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
-	int			error;
+	int			error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
 #endif
 
-	/*
-	 * The intent recovery handlers commit transactions to complete recovery
-	 * for individual intents, but any new deferred operations that are
-	 * queued during that process are held off until the very end. The
-	 * purpose of this transaction is to serve as a container for deferred
-	 * operations. Each intent recovery handler must transfer dfops here
-	 * before its local transaction commits, and we'll finish the entire
-	 * list below.
-	 */
-	error = xfs_trans_alloc_empty(log->l_mp, &parent_tp);
-	if (error)
-		return error;
-
 	ailp = log->l_ailp;
 	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 #if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	while (lip != NULL) {
+	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	     lip != NULL;
+	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
 		/*
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
@@ -4862,35 +4878,40 @@ xlog_recover_process_intents(
 
 		/*
 		 * NOTE: If your intent processing routine can create more
-		 * deferred ops, you /must/ attach them to the dfops in this
-		 * routine or else those subsequent intents will get
+		 * deferred ops, you /must/ attach them to the capture list in
+		 * the recover routine or else those subsequent intents will be
 		 * replayed in the wrong order!
 		 */
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
+			error = xlog_recover_process_efi(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_RUI:
-			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
+			error = xlog_recover_process_rui(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_CUI:
-			error = xlog_recover_process_cui(parent_tp, ailp, lip);
+			error = xlog_recover_process_cui(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_BUI:
-			error = xlog_recover_process_bui(parent_tp, ailp, lip);
+			error = xlog_recover_process_bui(ailp, lip, &capture_list);
 			break;
 		}
 		if (error)
-			goto out;
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			break;
 	}
-out:
+
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
-	if (!error)
-		error = xlog_finish_defer_ops(parent_tp);
-	xfs_trans_cancel(parent_tp);
+	if (error)
+		goto err;
 
+	error = xlog_finish_defer_ops(log->l_mp, &capture_list);
+	if (error)
+		goto err;
+
+	return 0;
+err:
+	xlog_abort_defer_ops(log->l_mp, &capture_list);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7c674bc7ddf6..c071f8600e8e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -439,8 +439,8 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
  */
 int
 xfs_cui_recover(
-	struct xfs_trans		*parent_tp,
-	struct xfs_cui_log_item		*cuip)
+	struct xfs_cui_log_item		*cuip,
+	struct list_head		*capture_list)
 {
 	int				i;
 	int				error = 0;
@@ -456,7 +456,7 @@ xfs_cui_recover(
 	xfs_extlen_t			new_len;
 	struct xfs_bmbt_irec		irec;
 	bool				requeue_only = false;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = cuip->cui_item.li_mountp;
 
 	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
 
@@ -511,12 +511,7 @@ xfs_cui_recover(
 			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
-	/*
-	 * Recovery stashes all deferred ops during intent processing and
-	 * finishes them on completion. Transfer current dfops state to this
-	 * transaction and transfer the result back before we return.
-	 */
-	xfs_defer_move(tp, parent_tp);
+
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
@@ -574,13 +569,10 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index e47530f30489..de5f48ff4f74 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -80,6 +80,7 @@ extern struct kmem_zone	*xfs_cud_zone;
 struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
 void xfs_cui_item_free(struct xfs_cui_log_item *);
 void xfs_cui_release(struct xfs_cui_log_item *);
-int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
+int xfs_cui_recover(struct xfs_cui_log_item *cuip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 70d58557d779..5bdf1f5e51b8 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -483,9 +483,10 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
  */
 int
 xfs_rui_recover(
-	struct xfs_mount		*mp,
-	struct xfs_rui_log_item		*ruip)
+	struct xfs_rui_log_item		*ruip,
+	struct list_head		*capture_list)
 {
+	struct xfs_mount		*mp = ruip->rui_item.li_mountp;
 	int				i;
 	int				error = 0;
 	struct xfs_map_extent		*rmap;
@@ -592,8 +593,7 @@ xfs_rui_recover(
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 8708e4a5aa5c..5cf4acb0e915 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -82,6 +82,7 @@ int xfs_rui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_rui_log_format *dst_rui_fmt);
 void xfs_rui_item_free(struct xfs_rui_log_item *);
 void xfs_rui_release(struct xfs_rui_log_item *);
-int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
+int xfs_rui_recover(struct xfs_rui_log_item *ruip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_RMAP_ITEM_H__ */
-- 
2.35.1

