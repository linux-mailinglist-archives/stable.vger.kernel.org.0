Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3DF6E65CF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 15:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjDRN0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 09:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjDRN0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 09:26:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1E113C1B;
        Tue, 18 Apr 2023 06:26:26 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33ICXGww018258;
        Tue, 18 Apr 2023 13:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=2rqDqtty+EwcYR36ZRoaLsiZlP/7c9EY9BGbIWQSWn4=;
 b=BIOhZarbkzi+g2zr5NP/z6jP29nDHZvtv45rXnd5YWJ+4nn7ghZBlEltItbD7fanyZRU
 8B1omBEnMk86RvZBkzPoFppwaBKxDCJomdzlv05cKPeDqXPjm3Fz7PoUA2t1gTCYSHD4
 J4FWyzq/4HpPeD5gb4f5lqiaCk0bYtuNrnmRBa9jU9DbUjXwEBeZHo6NBJMazNpouPDT
 +pJwjT/hcBhiQUL5X0qIkJpcHxH23l0DBGrEODxj7oMFEKSvoYu//yx348xQsfnUL6PJ
 jBgXqeFRaBqAtOSWjIopFP8VI/HIgLuBfsay4i5YLuGT4H3FiiQYknD61rHCOp4fLDls oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pykhtwmfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 13:26:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33ICVdqV037795;
        Tue, 18 Apr 2023 13:26:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc5g9y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 13:26:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaDDpjT4QM0a4SwaYm8j/LLblFsojqOsy3/PJjP1tA8ak8EWQYjjfXM/VOSMmSEcqjVuR5KaHYh29m0quUr6G7lR/deuOEzznhlftt6iXSDeKyh3OZ2SZ8VLKA5KU044uunG4pQM0hLYfZPduxOao3VDCLzNltyV6qtQhpj2kTZ6NtnKuYG6iUXHN9pgmsZsshvSOh/y7Ou+rMocVryWjj0QmLhkM6uLNP3QerK2tjnNoVxHMJgaANLYbE7KdDM2VzqkxZxgl/CeWc8Un9N1hWbXRR9jFb4YCaKyih70dxzgsSocLB+A4SDpSku3X9dioMRLyBO3exdVuI907gEItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rqDqtty+EwcYR36ZRoaLsiZlP/7c9EY9BGbIWQSWn4=;
 b=YKrA2hKp3bD+fWVaij/aT5Finfmo7yxrtOnSny7VrH+lNHQ02KhiVjJ9arPAEobXWZL5MynG7/czmw5/G2i/K6S9VFQsEKhe01C+5AgRIUrF00yIBhfFVtQTlhPbPcnQ5sIZA5fso3xzZbeiS4aYn0/UcKC5c98WYuiX+Czql5HOrXnOymFLT5ajGjFSgcNNpsttm5sMK8BUP4pwUlEf4sk2lONs9XOP7AniUWroz2EFIHxORgcdDKMM95YQIz8eQpFVHPkhRA120hdr8XlnCe77X5T/eiOdX1LRViHJNqiLyy55RqEGEpVoDQx/RWJnVlexBXJTVCzuqLqaD1sh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rqDqtty+EwcYR36ZRoaLsiZlP/7c9EY9BGbIWQSWn4=;
 b=kY4j1WVRJ0lx8T1QI3yvm26dS3I3k125DeKU2z1puOmmGbo6pUlJnGGu749tMHkRrsm2Ur1+2Ubg4pCpvCzTvPRoAsZJ7/AWBqEShkOndNBq/DyaUvKY2sV+hczSRV3bhVayglPw0DQlGd6a+3pLYqFIA8OPvFypQglS1XxvtFw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH2PR10MB4325.namprd10.prod.outlook.com (2603:10b6:610:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 13:26:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%3]) with mapi id 15.20.6319.020; Tue, 18 Apr 2023
 13:26:18 +0000
References: <20230412042624.600511-1-chandan.babu@oracle.com>
 <2023041853-plow-shiny-22f3@gregkh>
 <2023041814-conclude-herring-f2dd@gregkh>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/17] xfs stable candidate patches for 5.4.y (from
 v5.11 & v5.12)
Date:   Tue, 18 Apr 2023 18:09:32 +0530
In-reply-to: <2023041814-conclude-herring-f2dd@gregkh>
Message-ID: <87354xs4ni.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH2PR10MB4325:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b2767b-5012-4aad-bc74-08db40107e0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4f5SBBpCTZj7v2TnE0wCR63nDFgCb62XLtkiwxrSOwgClUzN4wP5Nmjlzf6mpckeWRPbc9tCZkxg46OQOtsWJ/zOcqJI86gdxD5jjS+Mg7IGf/IgwQS6JjvvL2ysae8jHhwRFqrdEBYvcU73IPkkpUJEqlC1sjqZmEtlgRdfs3uTatBLMAItNSyYkhLEb3vDntd4/sMKVoGaITau5Sc0NHM0DwExFSa7EMKe3d9hcRtFN+GTMlWN6vk/qkJfk4cCEfMVV4o1dUEn2BPnajzhAGPSAZjKu/uEZ1YAvHVbRIEAmCmdBAbalHJGbIcNy5JDu3+SzoOFJs7A0BWmG8Qmv8kyMvDQ/ab9BISmePNCMGqZM/XOLr8fv/cyn7QMAz1BK1rZHNy0suti76MUUV3oJ1xTTV/TZvy7WQ/NRRPdJWFHcY5GkmN5lrBend8H4MCeZ8uQqnLbznT4h/EqyujfGRwnQK7ersi8zMqSQoz/hh1KAEUyER5vWphbhv/KBFQbVaUazTiNFMT6MVOAnzrofrZOXx8f20Zm74oJHlN0yk0lEzo3kVZhiG90BK5SwrDj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199021)(6666004)(478600001)(6486002)(83380400001)(316002)(41300700001)(6916009)(4326008)(66556008)(186003)(9686003)(53546011)(6506007)(26005)(6512007)(66476007)(66946007)(5660300002)(2906002)(8936002)(38100700002)(8676002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GOvq0sDkvrZp7whZylLg2s2bcqjRbmRY3y5fP+SwDhs1fKaGJq/i/N/abwnZ?=
 =?us-ascii?Q?/9tZQbeULh5XaAOrnKjols7/T84ycRZEx3dqtJSUWXEE+gIvh7S7wgx+HCi2?=
 =?us-ascii?Q?ogZlCIVbzS/gnHpB4qXPQJr/VK8F6smNwIB2RH53JJzqVZv8wvJFnTi729v1?=
 =?us-ascii?Q?zh623WQentv/CQurGDo5X2swLMk+B4+EQAWGR+EYDF73nKH1YqleGOeJZSo4?=
 =?us-ascii?Q?p8oaDgSNA9/82DuRh1MnVUIOAGVFMUlvHZWts86wpQ402P5qIkoXL/HBh6FH?=
 =?us-ascii?Q?3ndFy5uzJODhMFN7aSlJDM9Wt2hfnJJJGK/oSW/6lIDouwSLzzVdR4vERVEf?=
 =?us-ascii?Q?SQLwHxIfHSbBOWsor4ayea/JrBZFSHWC0b38D4wPhKydS78oWHw7bJ7FUhHH?=
 =?us-ascii?Q?nWR9Kdk3TBUBB/ldEHV5fW0C9Lg+uTDhV6/USsG6xcq1bgQ+Jbf4zc2AuWuP?=
 =?us-ascii?Q?eJyP9jNf4jDijBV2A5IWXKle8blZ7vwq71EsKMEXmRahGy8c1QNSF/OKyjzo?=
 =?us-ascii?Q?rBZXBTCktDoaepL1YQEeRHvPXxp1NoxvZf1b99YNw12Lw9RY3FKjZd+4M/a0?=
 =?us-ascii?Q?NnYxls1elC1EdjTWpdPzSnF4AzBYCVZwWPG7YqhiUWV8WND0FQAWd+E9nZLC?=
 =?us-ascii?Q?RQNiY8m5/6jdY+53InU73tNfuecooWXI3F0Fa8ei5mrYMdU5EsF8QyDUkpb3?=
 =?us-ascii?Q?FSS6OjrE4+iBBHIBC4wsWtt63c6knNXzCIA70AZNQEbBjp0VJ+37wPfj7bsc?=
 =?us-ascii?Q?Aw8N0NsAHuZXH7Aj7QtekizS8kUjLcNZyWG0EBVHTNivDmDH4mfKzLfDOXaH?=
 =?us-ascii?Q?SaozGtrSL6LBSAynpztRglkctso3GZBzlPomc/+QAeO0lyKipljd7rtD8zyC?=
 =?us-ascii?Q?gx0LWHSjqhHp9o158PzNtz4y9hTgxyqN34YFXl2GBlDUtZIYYQYi4dq/LRZ1?=
 =?us-ascii?Q?ZSlQAbZOE0ur6I8Jy49XT8CVSRr8ZCswHhFstOLgw7dWHJLQcxcMi3t/ykOo?=
 =?us-ascii?Q?00syQ8wOhrNYo/qqux9VcbPYvLR4SRXvzwPEYnjP4IV3TnDjL9PPyKPK3Znp?=
 =?us-ascii?Q?uvyJWHjibqL3FNmDa3JC6TNrPQTRqNYcErsKlQuA1oq5xhF/c6CHa/xT2elu?=
 =?us-ascii?Q?xHFnXSBYRaArMeBtwMw2VQlnp6acWZ9uR6E0rEZWrqrMhQASse0z4L5SD1h5?=
 =?us-ascii?Q?fBTFwysWXJFq7YtDSuXbnlvmMaeuAU0yPaPLXL3xJ1tnwp4AkS2Xn81x8u+s?=
 =?us-ascii?Q?HHyWY9q9uZ5ZAzPLB+vNrPwWuGrrzWELWuDn5gfL30QS74norl3iXHXQjvrl?=
 =?us-ascii?Q?f0mPoovtlkEWGTNhdul7626Xrc9y+daiz5+wEohxyEejNHderfHx4bmmGQ2w?=
 =?us-ascii?Q?PJWj/FEo+ucALIhyKWF+o+JWo06Yi/w+FgKQe7HK7S/7+RpPy7DuLieWLTsr?=
 =?us-ascii?Q?aPqFXcZSWxGCDj1QSlm/WlrkASH63KeJknJZ0FAWSdy3d0Eo2vXpFh/zI+0r?=
 =?us-ascii?Q?ybcsyGME57GijdEmXIfVpAKxMKdfNhlUjYL34MA/MU+pTsKCuehrCFzb8olq?=
 =?us-ascii?Q?oqYsBsrocpEW9aSsjEMcl5UUMAoMnPJa5pFv6S0W?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1f2x2ChQU87Ch8P1KicwYejj/6iHGvHO0LnlyhhF8QzIQYuwLWAmuDNxLt91O7pK17Jk0xO5foccUx540kqxuPdgr4DsGQiaVjy4Tlao5dgks/acS0yszxg10kcyG+HUDSqkAoeiEfOYRdfSTrrvYtijoETrRgqNOcbXKX2IoPRy4LN4x2NTfL3mngk7i187Ws8yRu7+T+uUoGF1FPjXANZuupWE0iH9eOwwuYHVw747kltQRXiotFZ6+9mlrXVPXSQ85PTmZRcHURcWvI1+and2ImtAvMiw/HyR1TauoV2iPe39x4Qr6PgAo3JRvhFZdDIm4lZ5di3CV3sYabDSzeAnHusYSybCw5LX95vx1hiUVWvah69uFXhPyWR0NbHVOp84hG24YlvlOpkc4gXkxJ2ddP5mw4Wy/rOkygltxuQOpTltmMx8PLevxbg0sns5Syju99bb70LnNw6p6TvEs/fSM19nfyRgDbFiVILV/T6cebfje7V6Cisw2KiDzJnr07/aCEb2MmdQa3fjM0PXF4xfvLdr8bqJ+DuhRD3JJoomSfOIE/7OdYM6dQ5qDTpTdIZWMKzM/riJzlepymPIKwsqai+HELW23qEMCAO/YOiBCJ9cKac34RYnA72oKBDLHfD7mFnrTF1h8A/cwUyOaL4hyK0rgxNZkNkqP1U8jg+mtFcBavyIC4/QWctfWlFUK28AGm/9Q3gp1OJFea12G5K25RqBo4V+mzDG/oy990T63CLtj47Eqpp9onRDFUDGThaVuqQrnh06i7doGHkhGRoQGdKKgWS5X787PrOEgRX9Jz9WziXxOEIlwHChj5yFRPd/fjIx/rbQYK3krvbONRdorYBkjzoAC3MLblATjLbRXwCbNKyHZuIe+ecEwtoF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b2767b-5012-4aad-bc74-08db40107e0a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 13:26:18.5202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chm1hcEmkaaeBvcGQiEI0gczQYfFHZJ7+uz3dQdlpVyBUvDhOo+c21toZG8XLBIau8wgFR8CnbY5IcSWyyTxXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4325
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_09,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180116
X-Proofpoint-GUID: hjGm9AfOaUhtOy1ju7HjeYFvVOL3Vqbr
X-Proofpoint-ORIG-GUID: hjGm9AfOaUhtOy1ju7HjeYFvVOL3Vqbr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 12:53:25 PM +0200, Greg KH wrote:
> On Tue, Apr 18, 2023 at 11:49:04AM +0200, Greg KH wrote:
>> On Wed, Apr 12, 2023 at 09:56:07AM +0530, Chandan Babu R wrote:
>> > Hi Greg,
>> > 
>> > This 5.4.y backport series contains XFS fixes from v5.11 & v5.12. The
>> > patchset has been acked by Darrick.
>> > 
>> > As a side note, where applicable, patches have been cherry picked from
>> > 5.10.y rather than from v5.11/v5.12.
>> 
>> all now queued up, thanks.
>
> Wait, did you miss commit ada49d64fb35 ("xfs: fix forkoff miscalculation
> related to XFS_LITINO(mp)")?

Yes, unfortunately I missed that commit.

I always invoked my "find fixes" script as shown below,

# find-fixes-for-xfs-fixes.sh v5.11 v6.2 ~/junk/commits-fixes.log

The commits to be searched for "fixes for backported commits" spanned from the
kernel from which the fixes were backported to the latest upstream kernel. I
passed v5.11 as the argument since I was backporting patches from v5.11 and
v5.12.

However, e9e2eae89ddb ("xfs: only check the superblock version for dinode size
calculation") was from v5.7 and hence I missed ada49d64fb35.

# find-fixes-for-xfs-fixes.sh v5.4 v6.2 ~/junk/commits-fixes.log
ada49d64fb3538144192181db05de17e2ffc3551 e9e2eae89ddb

I will test the fix and send it out soon.

-- 
chandan
