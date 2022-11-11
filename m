Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119EB62522B
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 05:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiKKEKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 23:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKKEKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 23:10:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0F81B9D6;
        Thu, 10 Nov 2022 20:10:40 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB4AM8H000313;
        Fri, 11 Nov 2022 04:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=G8tMlRL3lwWH2Oo74NFWxaDJzq15d1X/8TI+M/a03rU=;
 b=twPrU5lAFWofGmkmbm/1H2Z448kR6Jw1KC0teJXZd6hZogY/kGeEhf1Uht5gU5YIHxMw
 3QQiojZSX22dQ6C/+falUYJsvEHsc+GE1AcUNAbPwSXOhPuwFZkcS4cYpeWj3EWN5BLE
 mwnRCYPLxkiw7FDJUG5jTCidn+OqiU87bDr/y4J38ypproPcbsVrkczXJn1dbXZyhMP3
 RaFzoQ6ebsclAyza0F8zx5ec0RF7ezYtUyhqM265FSUYyNNKHY1YntILdkwmtJ+OuOnK
 MZE3iSJpsrFjFOgQ+IjnkYyFeBQSGifGjH3XpNcfESm3fDaE1zNlnP8O4GR3QRaiRNOd hA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksf4hr00a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:10:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB2C8Ao038160;
        Fri, 11 Nov 2022 04:10:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcshgvt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:10:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnGbraMyar99U3hecOyW739locTyNNBDUge0e4x93Az6+gy0ms/3qtguQtyyBWe//ibr0QBbpJInEs4IfMZOYSEfHVcLGiyYqtUj6ckqVgNRqinmwCJKVY0MNT+gmsYbWAhVjcsfd1WbAhBcyYO/MoyuCddzhHMcJMzk0avtzxGVbdFhqTI+tCl0Kf3n9CW9PvC72WqromrcdeXIAv0zCDNKN1NaLuMK1cVc619AxjTsgr3e9DxCUkHCtNig0GRYui5o+dTkM1UatigdrWti1VakpkXwE4IFbkoNdC6vaDHZHfChC7mi7xtsgDbDLliYSLqo01ZSoFPssg8CRc62BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8tMlRL3lwWH2Oo74NFWxaDJzq15d1X/8TI+M/a03rU=;
 b=MyNeB9e5wMbi+7j5xn+rrHypc91qqH0QWaxYYWiE9KBRHadQttE+1fNB6PI5fV+z5t0KkLwXY0R6XvsM6gwrKDoQ8hs6HdtALqXK/W16XiyBYeLzRYQ1YJS6CTcwx7OQU7JY6EG+Z6ko5f4PXTJ3z06D3bSExa+G0tsK1k3tfGc7Q0Rq5vbirx/SLNsXo9wUAds9A+KdVXtpQfi6Z8xoFFvIGlwQmI5xjgo6xrx42Z5FDTWp0il819KQLRf9l5LHGEnb4xM8TmXw2AxmOVuJah5CCN5AAdU04wcAyTQLFT8jvMN5+XN9sxt57ZvCG3wVX+FjCTmTOgv6TS6XoCVMFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8tMlRL3lwWH2Oo74NFWxaDJzq15d1X/8TI+M/a03rU=;
 b=flDw64ni08iXlJNxBzX+fyxdI/CBauwUQrvWWO+X/bHdSfGSirtj34FTjunaVA82iace69J2MeZwIiZejPR5ctifsm7TggyX8/4OXckNsFzbKYmpvKzIp7JlBEyS6l6nd2yAowprVc0FfM2VBgq6Qvwe8RKPAVPiKjF0PUanRxA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4730.namprd10.prod.outlook.com (2603:10b6:806:117::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 04:10:31 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 04:10:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 0/6] xfs stable candidate patches for 5.4.y (from v5.9)
Date:   Fri, 11 Nov 2022 09:40:19 +0530
Message-Id: <20221111041025.87704-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP286CA0114.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4730:EE_
X-MS-Office365-Filtering-Correlation-Id: 83f398c9-bfc8-4432-7fb6-08dac39aac9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YnZdFCWPW3KFHmonhWwfQUoD+jdKaXzd65u5VkSIplRlNkabbyMELIFE4K7gWEKUe9w4ZQ2Zv7/2KUvGSaDuldUSV9MrdTul6Esq+2C9whumunk+J779o25i68VyTTtvB6ZArRdUw47bLwGQU3Xofn61F0hhDvFKf6xE8UY9hg4uR0nosFK0ajcFJ/BnjbDyQ3AnLVaYugxvhR+5LheUAVONqNo6AYXxMCK9WyQb8gq2xYkC4Y8K3NKXrrsHCB2BjqzuFQP1X0p3r+O3yi6w/2Np8ufhlkHpiZBAz4I7ZEJFdTcqx6WgZgYU7zviG1K9XPBG27pAO9tTjXWrkdtgBY0AVaIQaaSR3oCZQ6hlJi+01G27P5O9+/1nMCI+4y/9ylKkbFHomFMQgJyp5zdaiA76Spp141E3JT2hqKB8GNTuIzu5TgmKhclQi5HFrBsXatPbfb/g8Co5JHen486CUh/qKIva0I+nv7HM862HV9HeM/uTPIx8o3Mt8hkw0JhglxcuG4vOqbHX8CBWSB9s6x7h2wFfSxNt7G8i1YYJdY/Jgd2IEPXROsCFaKZDw5JZ7FEC21FP+qkIeh+QxUzIIQzZmkpULuerltXCCaCf9yEvMNnzDB4JVTUcRsussvncmijLmXkWEujxRRN/Dlce8xuH57oAghOJITGYXgMzDOnQW3u8VinRpDJsX+Jx+2AerFiwaCDiMKSarwMyLZvZGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36756003)(66556008)(6916009)(38100700002)(8936002)(66476007)(5660300002)(6506007)(66946007)(8676002)(316002)(2906002)(4744005)(41300700001)(4326008)(6486002)(6666004)(86362001)(2616005)(186003)(6512007)(83380400001)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1RDSXdGWFpub0Vyc1M0eTJ6R3F5RStyd2JCeWMwcFFuUTJNTGlqbHVlYW5v?=
 =?utf-8?B?d3ZXSWJZcnRFY0JhNXk4WVdacEtEWnlrVE1LK2ZhNmpqbnZobFdWK1ZSc2Y1?=
 =?utf-8?B?U0ZOS3QvSE14dnpNTTRBWWpTM2xJTGdXcDFJSkxqTWdzWXByNnd4b3crU3Jt?=
 =?utf-8?B?d0NWcENCWnlVVFlXYWJGWlViTFc0aGRvWHVQWlJNU2VpMkk1TStVc3RjTkhN?=
 =?utf-8?B?Rnl6eXZYbFhwRU4rcm1pMGJyOHZKVkcxWlZ0VlMyMjRPdHo3cjdocGVVVWwv?=
 =?utf-8?B?NzdEamRjNGlsYlBHbFViLzBuQnI5Q1p3NjZvcGlZcjE0ZC9rbzAreTJWNTNm?=
 =?utf-8?B?Yno5WlJZRGtPKzN2cFZKdlEydU5aaFVmWEgvUW5lVSs2bXFXeU9zRkVkVFFP?=
 =?utf-8?B?L2crYm1kNEZLZUlQcy9jczA0NmgwRzVYNnp4MzBqNW54ZWtETXdzQzZnTnR6?=
 =?utf-8?B?ZjlUWHNVd1Fta2d3ektxSnhHU2xYZHkxTDBGTk1uWEk2ZHQyRWx0QTRaOUpv?=
 =?utf-8?B?WmQ3czRLUHkyc0JRaTNLckFBczRWVXBkQkZ0YmVyOHUwNUY3Unh4aEhHdFpC?=
 =?utf-8?B?ZXhHQ3JTbWFnNmJneENvOXlYQWVOSi9ZV1VuRmpaYy9tWW5vK3ZBcU9kWC93?=
 =?utf-8?B?ZXd6Nll5cU5kZThsazJnS2wvdUhRVHpiK21RL3J0Y04wY0RTbHlsZW9udEpC?=
 =?utf-8?B?citkQnRVbFJ3OWtLNDZMcHFjT2ZmcWFROTRDNFREUEdJVyt4RXhpNERxb2dG?=
 =?utf-8?B?am01N2MzdnR0V2hOVVEyMjlpQ3ZGczdvcThoTWwyWFJ1ZU40ZmVCN2thM2dC?=
 =?utf-8?B?L3c2amN4VmcwRHVWclE0UXA2bDJmTENwdi80bjJKenZ6elJRUEhnQkcrd1Zk?=
 =?utf-8?B?QnhkYU1ReGRwaHk3UzU0MmNWWXc0QzkwWDVFSGZzOWJFMWFiVWx6WkdZNTB3?=
 =?utf-8?B?VW1RbWl5YWRxUzg3U1RXNmgreTM1U2hXWHFOWnQ1UXVkR3dQMXdBcTNDUHAw?=
 =?utf-8?B?amlFNno5c1AzRHNJVkZyMG56dDRwSXNFbTlaMU1BUWRacElSODh1cGFnMHdR?=
 =?utf-8?B?U2dZOUxHb2J1Tk40cytOUG81eVlVQ252UDZLdjUwNUxmM1ovMW1UaVZXZ2o0?=
 =?utf-8?B?SnM1WjUxMEVwOUhJNWptMlRMaDl0SEtxVEFCZWNweGJCMXVVNURpZS9nb285?=
 =?utf-8?B?d3JMUHc0ejJGeTF3SjFQcE44cVNQUU5oQTQvQU16ejQxRzAxMXBxRTQrc1c1?=
 =?utf-8?B?MWVKREJQb2JHME9nWEZFeTVqNFpRN0gwV2VwdHQ4NXh6dlRZbStaN0NRM3l5?=
 =?utf-8?B?UWV2eGxLQkdPdnRTRUxQdGNKR2hoVGlmbWlCVDNieEdvUXhTS0FZQWU3ZmNr?=
 =?utf-8?B?RStLOFlVb0pkU1pMVk5xQm03YU9idEp0VHJtckgvUU1ZQzBibVExNXlUOHp3?=
 =?utf-8?B?M1J5YTFWUEg3RTE5TlE5dm1rUzF2M0dNeEloY3Y1bHRMYjVyTVMwNU1jRFN5?=
 =?utf-8?B?UTB1TWVDNkVKK2ZrR1BER2Y0S2F1N3pQdEpuLzdYY1RPdEkrd2NEQkZ0VmQw?=
 =?utf-8?B?OVBNRkxTUk50b3gzTHV6UlBPdmllS05VSlRVSmVxL3JoY0czU1hSYnFkdURD?=
 =?utf-8?B?QnJKNndnK2hBQTFub3pFMmg0Ti9oTnBoRWx6QU83VGFObitQdmR3b0JEN2p6?=
 =?utf-8?B?aU52YVVJcExxUTd1WnBvZ0xmUmNwcGxtTk44NTVaaXkyMlRzT1ozWE9lNFJO?=
 =?utf-8?B?bW42Rlpoc3F1U3hCeFpaZ3k5UXdsQ2U4dWYyeWQrRjRXcUgyVGNEOFhKTThz?=
 =?utf-8?B?azNNeWRYMWtEMzZZZ0JNdDZjeWRaY1l1UFIyREUweTZIS09WbVUrRHludzdq?=
 =?utf-8?B?S1BjU1dScEpPdzdrVG90MWpyTHNKZGZMcVpBMmRmdXpzQlVCOVViemxEdUVs?=
 =?utf-8?B?SWdURUtOa21hZ3R3ejlhUXNsQ0RPa2FYOHJvVjRCdDh3elhCRlcwUUw5TkxD?=
 =?utf-8?B?ZEhuVThSRW84Q3Y3YXgrSEtYYmM0eWRmVFZMdXQ3S2VoU01DWUJ1SGFFM2Uy?=
 =?utf-8?B?MHB6WGthK0M4b3VIdGlGdzhvWDh2SkJMKzNVeEFZaEdMK1h6T0R4YnZyMGdt?=
 =?utf-8?Q?4u37iEaOtBhPh0OrKadfoSczp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f398c9-bfc8-4432-7fb6-08dac39aac9a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 04:10:31.5626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+d4iwgVCMR4mhOzikhKbgryvILh6VnnFFS9nrqgR0n1T98eyPiOyXEJoKGR3Ug4gFic1CSHdxhtxnjGahS3pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_01,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110026
X-Proofpoint-ORIG-GUID: dmesroUy6Od1R5l0sXLJyeFf2j4-VXFO
X-Proofpoint-GUID: dmesroUy6Od1R5l0sXLJyeFf2j4-VXFO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This 5.4.y backport series contains XFS fixes from v5.9. The patchset
has been acked by Darrick.

Brian Foster (2):
  xfs: preserve rmapbt swapext block reservation from freed blocks
  xfs: drain the buf delwri queue before xfsaild idles

Darrick J. Wong (2):
  xfs: rename xfs_bmap_is_real_extent to is_written_extent
  xfs: redesign the reflink remap loop to fix blkres depletion crash

Dave Chinner (1):
  xfs: use MMAPLOCK around filemap_map_pages()

Eric Sandeen (1):
  xfs: preserve inode versioning across remounts

 fs/xfs/libxfs/xfs_bmap.h     |  15 ++-
 fs/xfs/libxfs/xfs_rtbitmap.c |   2 +-
 fs/xfs/libxfs/xfs_shared.h   |   1 +
 fs/xfs/xfs_bmap_util.c       |  18 +--
 fs/xfs/xfs_file.c            |  15 ++-
 fs/xfs/xfs_reflink.c         | 244 +++++++++++++++++++----------------
 fs/xfs/xfs_super.c           |   4 +
 fs/xfs/xfs_trace.h           |  52 +-------
 fs/xfs/xfs_trans.c           |  19 ++-
 fs/xfs/xfs_trans_ail.c       |  16 +--
 10 files changed, 198 insertions(+), 188 deletions(-)

-- 
2.35.1

