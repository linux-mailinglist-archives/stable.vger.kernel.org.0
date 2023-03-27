Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1F76CAE14
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjC0TD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjC0TD0 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Mar 2023 15:03:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C54426BB;
        Mon, 27 Mar 2023 12:03:25 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RIoLeV028773;
        Mon, 27 Mar 2023 19:03:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XTWgae8f9rMe/vZ5BXq4zlzNA7EE7GgdEqqkcqLJwHk=;
 b=lVcQG0urKU2p8fGy5edUpf/7dP7ebUlC6lqCsSy6ohDwsKcClzITfgQREinI/v9kBnh8
 4T5fhwfx93uapNv7vaHdfIX0+ihsOTfnAfq1JGghWN+u5gHKti1DN+9nsetea9KsXLV7
 y2q9Gth9suk+XnTbuOivSz/pzurmBJIxTBW4MahUCzXFWDqQY41Wak6AM0yBLrAzEUVq
 klgiMWrQhW56coUQfIQztFOxyWlErCuXoCXfSBcYcRkiAKl+S45X8Ja0DvTD4kH30e7+
 XM19jCZf8mEkyaTu+Nq2DUKTIjdpsO7WTfbCvfmGi4xA6EFvcEfiWcwD7wORw0DPzNIg tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkgsa01wu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:03:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RI3Xtf008633;
        Mon, 27 Mar 2023 18:55:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdbvmfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUkBomQyhxC9diUfm0XLtiHVnA7rtbncG62Uptigid5ziMIb16f85gm0E618ReTWiLZEYR2Zdwb8/G4aunIEntPC/sPmQNZqkhKNDOcFNc63UHYnwPocG70WdhzCoWWdDgxBA3Dd/0RUOvBzChaH6jJKIB6IB5JOyWH8hOnLtcODKB5jeF4yj/vxqBV+o87ycOFgMRIMt4VSQctwKwVkZmcUIfEVFI8Wq0055ZzFOFEuiPsJvJk0lKkzqUu7Jv+sKqmMzHqNDtv3FhAoao5hlt+xc3vjoSgC3mFARRRCgoC8JsKgeQmUFBMkOYuXKdBsjzMsrF9HXEvJ1GX9T8UqlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTWgae8f9rMe/vZ5BXq4zlzNA7EE7GgdEqqkcqLJwHk=;
 b=L9jIDd4KDczY9Nl3l7/D7G+D6ipXEwisl/DKJg+N3oV2rjM6uIu5YEA4cH81dyCQ3sTgfEvTgHRV46oWe793OWjzBF8IzGcfAxkaKKzvOdheZG3hNHqv3AJylBNxSUm5LDd4h5J3zyrwyRg5FlkqhEHeZLXogZuiLwuzFBmz7MZIYik4tUFrOHnAXdWAoOmO8n6aFJhAfS+dnIj+6c0RLTan9yfxqXGZUe9yLIiHKKogo04CMRPDk/mi2pjyTL9vQMu2kQvOh5i4jsi6AJdIdzw7IvSdcBP+VsXTSW5j633rYaHRDAZWDWuK5MnOdRI/yDt7ukWdQlVOjVctWQaUgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTWgae8f9rMe/vZ5BXq4zlzNA7EE7GgdEqqkcqLJwHk=;
 b=RAFIT3Y8Mk4hLndqF/A35GfVB/wsvPd+EU7PW9WVvkaFuGHCDUvLos5xKU++MV89j2LwBGSuc+3OJk/bNj/mHvWxyH9iBtoeIGf0y86DoCXmY2K1DFqe18KuZyPVpOHof8M8AoLsiiTgK9zPXrvqxAOHTcy+RqpV/HAV+bk/kko=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB5722.namprd10.prod.outlook.com (2603:10b6:510:126::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:55:38 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 18:55:38 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 1/8] maple_tree: be more cautious about dead nodes
Date:   Mon, 27 Mar 2023 14:55:25 -0400
Message-Id: <20230327185532.2354250-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0357.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::13) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ac27d70-fa15-4e46-9291-08db2ef4db2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f1zod4f6hwZqFRRkaZeu6DIV7R5v298NVYM64sk+m8gpEMiI9XUZ1R/DPsrM/5V11hix8x76F20jmz1MrRLDYp8ODNLve6F3yc8PsKbTUiapLGynh2gcdPUawawNkT8wXWFfUW3j9N94OwFWW9X1ZmkzOIUjP2OaToV6SoNHh/ztp2nh1C9YTpo5JZGZ7wFRXkHGh3KnEmqGGyPvWIYayQxjP1Qob9ItlbT9s1I/8Cwg8GqBqL23xVmYqKu7vnaEvxZYcal6N5hLiYoJX58KI22BK3/R9vCfeHk0J2+1li4KDq3vXvuhE/TcYzOBxvMWihhtRyhByyMA2S2mkfFeOCQZH3vG22an0mjwdOeroviwp9xafdSrhWE4aT61MN8NkumCka6vAIjjFoGEGovUN7AoqeipWqgbdzxdb4AQuH9WyxfahI9iy+rtbEREwotUcH4cKsDJjfQu2VoHf1rFc28O/84VxCDV4iOGRA+pkc/aP5kHgUA2LwYaJBfRnWNqltSlJYWzx6IAGjPOJ8GPE66XdDj0ZVjWfUQfaQp5q/Yr3SW1dxALYsJM4nzrcqZE1p5FNF9dDCpXzJrktpy8vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199021)(2906002)(38100700002)(83380400001)(36756003)(5660300002)(41300700001)(8936002)(86362001)(2616005)(6666004)(107886003)(110136005)(54906003)(6506007)(1076003)(6512007)(26005)(316002)(6486002)(966005)(478600001)(186003)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sYfQ+HLZUavKqxu5jsqazVv7wKfkFP24b7PMv77+gDJNfpNOsS7XOteYp62O?=
 =?us-ascii?Q?01CQ1IY/JftQCmtruSTHu/GHbEfuHmYWmIDA52a4VDtnI9IDACDVth4cArud?=
 =?us-ascii?Q?j0UsLXz+MByiCcddyy5bIbWqVMrBAl4MLbPT4SE9Sz7i9NBGWIbCf37XXPyz?=
 =?us-ascii?Q?8dB5ZzaljS+WOdtvZIUkzqjDzIqmEyk0kOISCDPzaeuN9NZIwCmchgoli6Tl?=
 =?us-ascii?Q?Il/NN9UXJcATsHBWfisGjqiYTLUp/9uhdf3tYY3iCcq2PUwdRIFSbo3rK3ku?=
 =?us-ascii?Q?4QCIoXxrbLxfWDBMbtH2xrUEwAUCss9wDKNFcaMVRVz2myXbWdv1Dp1PQQ0k?=
 =?us-ascii?Q?kbJ+xhfS6mJoeefiUhppfESwlrHwGQLhMmteOuo88pJqGk0kNqaY+CRDg4Mg?=
 =?us-ascii?Q?sm9RqlTN0gfM651QIcRa0WG+RPCEZwN4VcMWi7CzeIyC1BtenbcOEzrZ8Q8q?=
 =?us-ascii?Q?9E+1Py7UAtT7C06q9ItP4JnuFu8dGk0+8fD5zELRZDVYNMorzq55xd5iVOn5?=
 =?us-ascii?Q?PkExzDq26Fcevap2HCB+sLtqhoKXbWrTwVNREMzuosdHmmsN7XKFyC8J/YJJ?=
 =?us-ascii?Q?t/ODxY+Ay3sxNGJO5WxvWw1nMK8YQQZZh8rGIg206uhsrNAix+zk1rBQUxP7?=
 =?us-ascii?Q?63e5U5oZJ9j63EwoN9kbTJ5ZkH7T5++Qph1yz+RTyHcKQWu0sEud7rwNBNC3?=
 =?us-ascii?Q?p0H9yhiV2shluzn63EFcaxcz1oqygbvQwVmsyieAM3/JUyd5/KWYsg4+Trz5?=
 =?us-ascii?Q?lpqI1tXcaKsHRbtuEhw0gcdCQA+gEK+UEAf2j938fJtm6GoitdBhpw/wfIHe?=
 =?us-ascii?Q?fyWif2i8JpJrF2BwHcWelgRY7LZe4zlrqoMXJ1A0s+nRbnviEbo4yNfd85wH?=
 =?us-ascii?Q?+jl1NGavGHEdOxP1Cjw5D/5I+NNYQyW58ldcnmj9IMacmbi606NRv3Z6Lyaj?=
 =?us-ascii?Q?tkn9ZhY2tVymUqR1vuT1lITUwbZWBR//Dt8bRWfXm5VLq0gCdAVVrIcd5N31?=
 =?us-ascii?Q?jPRGxY4BsqHfRmp8sV8G14pfxldCxlUVr6ilgQvhsjgL6Z64NSrnoZhRtWJo?=
 =?us-ascii?Q?JZq2iMYR9XouI0Qne2uZjBUR9pI+WfZjstMurHKCS+/R9M/ehWutHdayRrcf?=
 =?us-ascii?Q?5hnL1X7zen3bGdGzJKd9IluIQ467qLLIzmIRSlBhTqzI4OK82fp5+YGOWd1/?=
 =?us-ascii?Q?i8DA0Qi6ETkohV4rEmw0R0JHTJOnV+Q9J0wW9Ljhoqe5XvmQm6smDOJpNP1P?=
 =?us-ascii?Q?VG+G1U/olZoh0zU4xkPPW6LgtYLHR+dWDH2fw6oFF+nFAG+aBZn6BQ/QCa9f?=
 =?us-ascii?Q?AYLHIYNdJtxbVSFGxVt+w67t0u0FsIlpLI6LjKv/7dI8j7GC1s0bQ4kLevFc?=
 =?us-ascii?Q?JQtGyDPoPLddkMsv4Q9dll9zUb/wqrwuwHe52hD5HSNr+LyyTMqlNrTs+Hpe?=
 =?us-ascii?Q?FQHfxSTQSJ4DCYV8gOKLtq6V4T4yeCCneZxU+0u8lw//33gaXLhMDirYU8c1?=
 =?us-ascii?Q?XPgAKaQH4exBFR+W0DlHnepqI+cokxseikKLQE4uWyiynz4j6l6S0ueYaaQ1?=
 =?us-ascii?Q?TcGsMfaFZErAgkqHeMMQDvJXM3MGv7j3ODTljXWJL+zM3/7CTQHR+FhnXxPj?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?O+PsLTI9sf0SSfhbNMl8GvWNv1mdfbqEdTwqwY1RFHP+/IRRguiLfT9UWZkf?=
 =?us-ascii?Q?lbHQi1f092Ioo4O+1cCASg17gBlG4uQmLCiRf2LS2pWAxidL0oRQ58sUMZlP?=
 =?us-ascii?Q?nRcjix1M0Sn1KOcJtCdNP+mFJrq8JC0glpgRIPgBEl9Emzm+lwxPAntcrCSL?=
 =?us-ascii?Q?v1N17t9yW2Mw+tAWwelIcGm/8jS3Zpx5awvtEHYoI8aJjRBKm8XlNiGe/PCO?=
 =?us-ascii?Q?Qe9h/5gLzC4nx6wxOrMmVqVqKW125g9cRX4k99eoWv5GHGVLuXVQiGonVmjj?=
 =?us-ascii?Q?AnXTLq7p6MV2lRhu1c4y/+DqOPRxSjx0qppby3jwpHM5C9pASV1fIlUEL6W/?=
 =?us-ascii?Q?O6qaCFwgCGDSmVS4jLyrnsj1eU99eFeY2IdDUvVsKI8wt66JcDjV0oESiun3?=
 =?us-ascii?Q?lTneeQ4LluofhBZGGXKojhlzR7G5wM8sq7+C7VChai5PYLCmFFV9iipIYSrZ?=
 =?us-ascii?Q?4f6Vi927GBL3HKH9XJ9i7pNuskBx6MgDqv0ckUdf4zUnsllDgmlbaSqJRCs+?=
 =?us-ascii?Q?EyP0g8UHvwJTvJpTJsBavMJp1fEOdsHvRDWP887j/m6TmDGdNF5OaOuwGnYE?=
 =?us-ascii?Q?DKlrtFD9XcfsCn7RuA5FEYr2x1n0YNUSlAkmfmodMcMPPg++se5agpjQrWCX?=
 =?us-ascii?Q?nlXpaAS4hIqTdWfq0K8YAx80+VPKBQUs/0ySmZX1M6hxfEZ0I91mhn2A8RwW?=
 =?us-ascii?Q?P6pijNvtD/KHdwBOtVCGSrrXKgku50ypui8dQsHW8NBc9AA6d2Fg/2UUMN47?=
 =?us-ascii?Q?rgFmtohYWU+vJD3khrLHQlUzx2fqoiSXKFIOlKpy+ZwOqxg04jzS2VEfx76V?=
 =?us-ascii?Q?k86XAwRPGWkdCAe3jyTRJveIdW+AEotihEn5Yd6uZfHVh3WliBQuyuC2wrQq?=
 =?us-ascii?Q?XVG8pCvpTZZLJtEwYens8uDXaRepBbRqR0/cV0fzWLn5p/l9lGJHn+w8rbOX?=
 =?us-ascii?Q?kRlWnv5818KCmIh52ZImzw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac27d70-fa15-4e46-9291-08db2ef4db2b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:55:38.8180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bv2eaq3FxUzNr/GvCeeEgq1WgnwVEhJEySJSPjhRHiu6SbShXzQCJd6iqpCbzLKAdkc6zudovTmNa+ZRYsn8lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303270155
X-Proofpoint-GUID: 7iIW5NSvzuVam_hyzM7T4VA047OEWO3A
X-Proofpoint-ORIG-GUID: 7iIW5NSvzuVam_hyzM7T4VA047OEWO3A
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

ma_pivots() and ma_data_end() may be called with a dead node.  Ensure to
that the node isn't dead before using the returned values.

This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230227173632.3292573-2-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 52 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 646297cae5d1..cc356b8369ad 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -544,6 +544,7 @@ static inline bool ma_dead_node(const struct maple_node *node)
 
 	return (parent == node);
 }
+
 /*
  * mte_dead_node() - check if the @enode is dead.
  * @enode: The encoded maple node
@@ -625,6 +626,8 @@ static inline unsigned int mas_alloc_req(const struct ma_state *mas)
  * @node - the maple node
  * @type - the node type
  *
+ * In the event of a dead node, this array may be %NULL
+ *
  * Return: A pointer to the maple node pivots
  */
 static inline unsigned long *ma_pivots(struct maple_node *node,
@@ -1096,8 +1099,11 @@ static int mas_ascend(struct ma_state *mas)
 		a_type = mas_parent_enum(mas, p_enode);
 		a_node = mte_parent(p_enode);
 		a_slot = mte_parent_slot(p_enode);
-		pivots = ma_pivots(a_node, a_type);
 		a_enode = mt_mk_node(a_node, a_type);
+		pivots = ma_pivots(a_node, a_type);
+
+		if (unlikely(ma_dead_node(a_node)))
+			return 1;
 
 		if (!set_min && a_slot) {
 			set_min = true;
@@ -1401,6 +1407,9 @@ static inline unsigned char ma_data_end(struct maple_node *node,
 {
 	unsigned char offset;
 
+	if (!pivots)
+		return 0;
+
 	if (type == maple_arange_64)
 		return ma_meta_end(node, type);
 
@@ -1436,6 +1445,9 @@ static inline unsigned char mas_data_end(struct ma_state *mas)
 		return ma_meta_end(node, type);
 
 	pivots = ma_pivots(node, type);
+	if (unlikely(ma_dead_node(node)))
+		return 0;
+
 	offset = mt_pivots[type] - 1;
 	if (likely(!pivots[offset]))
 		return ma_meta_end(node, type);
@@ -4505,6 +4517,9 @@ static inline int mas_prev_node(struct ma_state *mas, unsigned long min)
 	node = mas_mn(mas);
 	slots = ma_slots(node, mt);
 	pivots = ma_pivots(node, mt);
+	if (unlikely(ma_dead_node(node)))
+		return 1;
+
 	mas->max = pivots[offset];
 	if (offset)
 		mas->min = pivots[offset - 1] + 1;
@@ -4526,6 +4541,9 @@ static inline int mas_prev_node(struct ma_state *mas, unsigned long min)
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
 		offset = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		if (offset)
 			mas->min = pivots[offset - 1] + 1;
 
@@ -4574,6 +4592,7 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 	struct maple_enode *enode;
 	int level = 0;
 	unsigned char offset;
+	unsigned char node_end;
 	enum maple_type mt;
 	void __rcu **slots;
 
@@ -4597,7 +4616,11 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 		node = mas_mn(mas);
 		mt = mte_node_type(mas->node);
 		pivots = ma_pivots(node, mt);
-	} while (unlikely(offset == ma_data_end(node, mt, pivots, mas->max)));
+		node_end = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
+	} while (unlikely(offset == node_end));
 
 	slots = ma_slots(node, mt);
 	pivot = mas_safe_pivot(mas, pivots, ++offset, mt);
@@ -4613,6 +4636,9 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 		mt = mte_node_type(mas->node);
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		offset = 0;
 		pivot = pivots[0];
 	}
@@ -4659,11 +4685,14 @@ static inline void *mas_next_nentry(struct ma_state *mas,
 		return NULL;
 	}
 
-	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
-	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	pivots = ma_pivots(node, type);
 	count = ma_data_end(node, type, pivots, mas->max);
-	if (ma_dead_node(node))
+	if (unlikely(ma_dead_node(node)))
+		return NULL;
+
+	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	if (unlikely(ma_dead_node(node)))
 		return NULL;
 
 	if (mas->index > max)
@@ -4817,6 +4846,11 @@ static inline void *mas_prev_nentry(struct ma_state *mas, unsigned long limit,
 
 	slots = ma_slots(mn, mt);
 	pivots = ma_pivots(mn, mt);
+	if (unlikely(ma_dead_node(mn))) {
+		mas_rewalk(mas, index);
+		goto retry;
+	}
+
 	if (offset == mt_pivots[mt])
 		pivot = mas->max;
 	else
@@ -6631,11 +6665,11 @@ static inline void *mas_first_entry(struct ma_state *mas, struct maple_node *mn,
 	while (likely(!ma_is_leaf(mt))) {
 		MT_BUG_ON(mas->tree, mte_dead_node(mas->node));
 		slots = ma_slots(mn, mt);
-		pivots = ma_pivots(mn, mt);
-		max = pivots[0];
 		entry = mas_slot(mas, slots, 0);
+		pivots = ma_pivots(mn, mt);
 		if (unlikely(ma_dead_node(mn)))
 			return NULL;
+		max = pivots[0];
 		mas->node = entry;
 		mn = mas_mn(mas);
 		mt = mte_node_type(mas->node);
@@ -6655,13 +6689,13 @@ static inline void *mas_first_entry(struct ma_state *mas, struct maple_node *mn,
 	if (likely(entry))
 		return entry;
 
-	pivots = ma_pivots(mn, mt);
-	mas->index = pivots[0] + 1;
 	mas->offset = 1;
 	entry = mas_slot(mas, slots, 1);
+	pivots = ma_pivots(mn, mt);
 	if (unlikely(ma_dead_node(mn)))
 		return NULL;
 
+	mas->index = pivots[0] + 1;
 	if (mas->index > limit)
 		goto none;
 
-- 
2.39.2

