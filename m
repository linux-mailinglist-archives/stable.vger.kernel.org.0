Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE60531C8E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiEWTcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 15:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiEWTau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 15:30:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F147356E;
        Mon, 23 May 2022 12:12:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NHLD0S022813;
        Mon, 23 May 2022 17:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PDdfso50z5cO1XN4KW2gBTNZay4Vb738O3aXncgc5d0=;
 b=EhtABCg6rTVDdpKJ5bBHOV9n0Yr5vTVkt+jZ44IKRxnE39ukAOVUyQXEp5K2oMsXxXr7
 DN3rlROV25O2d7+MKoEpD+Dp7eei9NQVqDMXbPwJ+S/i8Efbtyb0WnY+BbB1L0PGoX2F
 h6TFLmwcktESMhwTTgQnIH+Q7DmpdAQJ+ccoyGTUGoRQSNI7vVcfyHHaEssWC7N1heRM
 WsS62wFArULBid4nbhnqlB/rmr1krAJlziAikBmwzjVE7oRUHqyENNQUc3LsmhzTwmMU
 ATkKUWBtd/1HQ9lw+YKOqylEBtMzjlujxMrf47nKjT7JCRcP6YtgEcOWt85J4YJEoiJa rA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6rmtv3hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 17:39:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24NHa6if015137;
        Mon, 23 May 2022 17:39:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph815th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 17:39:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9jAhmb+es8arDaJXlLCHAxyRi+e9NGRSEhF4wiCBH6z5wkgYsa137pQgE0hp21AK7aKLJRUKxrQ98oIzr0xHVNjxVESssOIWKTsKi/H4g+t+/7z0YMqWvP5uqE1dxafTrHBQVJVny8G99VG6FGShTRA7/8AgJl37ChOIRkRziLx573u5OZEDlYdeKIiY+UXpd5l9CvycXYTX9hm5h+3Vvs7YlrwxrCp5LEmuUFb23I2AhIgsd9n7OTaIQaQCSh9IS/NlGLh55KQLDiTdI0j02JirbjodA0pQ6vnlZeZNoQzteMeEPKRz7dNTYrVd/HxfR2Krl8piywtuVmUTlPLpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDdfso50z5cO1XN4KW2gBTNZay4Vb738O3aXncgc5d0=;
 b=FOYV/S1ufUmHa6So4zTd7LDhXyfi+T+prtvHO6vv6O6RDc3XkI7+WC61MwUKt59HrP1pmDzC1Xecg8AoKsNeHWr/1hRaP+zKYX7HHSg0VDRwYJO12Pqo/HxSfysAEI1W0GZy2+Xk1UoXdvDU5pa49IAmROMdZDHti5S9ACBGEmINKBvBr3WiB67Arkj9t5210lAFKTghiOoxawpzMn3L4MUiCOPkxtpSUKMyaQx/J3YsbmWAWLX9URQmWWLqx4kUxOyu4r52SDwNXeYN6PK4H2TcSZ1lVBVsWp7XBLMMtVlhLfpAl0vPWV/1ZkNvO5iwOM2LuTMhb1sEBbyzt4/Thg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDdfso50z5cO1XN4KW2gBTNZay4Vb738O3aXncgc5d0=;
 b=gCw3j0sfbib3orDoyAhjoZmLHlrkInb69F8sOetOQiSNzPL/wys8aZ/F9GSJ32Yd+MC4MVjulK9shc5Nlt+jW+O9p6bqdAROd99oMatKAVu9e/wHmS1n8bkRhalqXCTC7tIzqdlxoKPPYJuGnbi2N559qppbe0myi46CT25rCCc=
Received: from CH2PR10MB4166.namprd10.prod.outlook.com (2603:10b6:610:78::20)
 by MN2PR10MB3181.namprd10.prod.outlook.com (2603:10b6:208:12e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Mon, 23 May
 2022 17:39:28 +0000
Received: from CH2PR10MB4166.namprd10.prod.outlook.com
 ([fe80::4421:897e:e867:679c]) by CH2PR10MB4166.namprd10.prod.outlook.com
 ([fe80::4421:897e:e867:679c%8]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 17:39:28 +0000
From:   Stephen Brennan <stephen.s.brennan@oracle.com>
To:     David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        keyrings@vger.kernel.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] assoc_array: Fix BUG_ON during garbage collect
In-Reply-To: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
References: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
Date:   Mon, 23 May 2022 10:39:27 -0700
Message-ID: <87ee0k173k.fsf@stepbren-lnx.us.oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:806:120::27) To CH2PR10MB4166.namprd10.prod.outlook.com
 (2603:10b6:610:78::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c166c87-6ca5-4ad2-7687-08da3ce32ff5
X-MS-TrafficTypeDiagnostic: MN2PR10MB3181:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB318124D4948935D0C760096CDBD49@MN2PR10MB3181.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzXChL33a+0WeeL9ETfWzBfW/eQLKmummTi+0tq6fQWI1hM+rEf2EyWQ9K2KksgjgCPgBDyRZKknjU/rSefp8h6jCh5K6SE/JSUKn0YGemtoLG1swkUbNP3Xj9mqUBvTstjBCZg7HXVvZnUevKBs4PoNWXhpWk+drRc1bVNWzUWXmOmZo0gzazUq32yPXcBidnt+/Kh2IdSMbS5CNHqp11EYhUmWLW8/IT2ZjgawOEtSEcP8ck/8duHFi9vDjDjgBvEzyKD1Suh8WGXYyXRMawC2xA/U/wezylEOhoI3ArvqyeXn5o6f3l/FlxlAahteXwNv4c+5Aarzj46P99F8LTsgEH49f8eliack7k6blNAXtS5VWrYCIy48TCOs+h2vezbIgsTmni/6AjEqiYjQsNwT5qvITY1f87HkPHs5fOF5Hz9TZ7ZtZsuqPkMPMZrQAIl0puuprTznT2ywGpdvDLHzOtzbzfrDQEU+r7eJ/ZZm3IP0tfcMAzYfxDTLSCf74cs14zJyTen4xoC8ygapDKAz3PIF3MIc3h3aQsEghN5XJnEoUx/4IcsrmQiup+9Zf1UJOCS+paLRerrhjlDATckdY476e0gA02FTVlYkFLi5FE1pO67buqtTx2eoTP4Kk1/Ij5yyxHDR5F1OYTAxB6vEJhrNCcwaJ+D4isP6J8ps1CsZwFuobplbh8hUzgxOM/zpwLW0MejiZ1FcqyHQDMAwlVY5aJIVUQRfnaNTxO1q9VqXseCDiVbKr+v0bJqQIrs3cXLa3p5PQ5fYxsguqNxmlqh3YZZ/EzCyqxU40B0BruBMH2Q7hxLFdAk+pfNouOGg4nY+kztm1wEfm5CAlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4166.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(966005)(83380400001)(508600001)(316002)(186003)(2906002)(6486002)(38350700002)(38100700002)(26005)(6512007)(8676002)(6506007)(8936002)(5660300002)(52116002)(4326008)(54906003)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8uqkXI8vBUqj9v6ZNJpN9F9zw0Tb2DVNGi34RehM42KtQa0RFkXofXULoh1y?=
 =?us-ascii?Q?MWbnTEwaU5bH1ISsXBxR9nSn14VZUQZAVKGtRYuZJ658WvBM1CPy9vTklLeO?=
 =?us-ascii?Q?HOMOQ1JZHnabnvVZSTJhu3ocwIiz573jvTS8braOeLxrXmWnAddCXB3XPGOF?=
 =?us-ascii?Q?dUTQHDKL+k2rkiWMQrlNnI2Lu/HW4v9Xqldceq3wR+BoUoc2njBBbVuFbe+S?=
 =?us-ascii?Q?UEuXF18UlJfIq7js9tRyjfU7eyz8HNwLSiopyeucsJDZ6BsicL7xIiVVEd9m?=
 =?us-ascii?Q?iq1/9zQzZWLB5HUKlPelrLnFMhVPXDDusYpZfNM7s54Ms8GtlvvHpD9uhNfY?=
 =?us-ascii?Q?aTWEEVrT5DslXu3oND1Vfi/FROM1QPsHRzW/D+0kLtwHo6ohajTkld+v9SAw?=
 =?us-ascii?Q?QefhnJ+yvynq9M2cBY0QElX82nDurLbosZSsH8MxUEgpWRqDNuzB3VnISqCH?=
 =?us-ascii?Q?X1UVJyVbqVyfvSNmVJyOymqSXLl4eKotcbUi6l/TP8T9ePsVay5PVaHuspLL?=
 =?us-ascii?Q?HWLnTLIn9u8/rlzsrM42d4e+VWKEmfhvaOMnLUbB188MtO1fkz7CYGPAQYPd?=
 =?us-ascii?Q?+muNtPKUHRxyC4pcnWnKlIy05ZFjDqwCuaIE8VfehjSxXguNrznkkXF4X49A?=
 =?us-ascii?Q?+ttMkWgz34RoLcwLv6TEr0pNDnBHZZK5KVE5jM4DW1C7Vd8eCyio9BIYDkI4?=
 =?us-ascii?Q?oURJl2vDTylzUtIR6oyIAanxXUtqQYFTIqKpbAh70q/Y3zxQh4oEcrm1ONHK?=
 =?us-ascii?Q?F876CJoFbP6n2JtZv0rjApe2/JwY/P0ixw7u6YKHVyhfNGpley7PaTgMTji8?=
 =?us-ascii?Q?PlOSdAP/J0bJhSPO+Q7veiBZrsltg9v7cnhZFYoqBiLb/lh0t9IB0dj/jWGj?=
 =?us-ascii?Q?cnvC0yces1Hf6Z35DG0Rp7HScxsZACEJvzPaTfdgT5YPMsxiwRDfaedW69Ki?=
 =?us-ascii?Q?i3HBP+GB7PG7bhQkxdfI5Tim/W4XtbphYfrji8nQAe9QafUjZQZc/RVjMatz?=
 =?us-ascii?Q?5vj7SVidYn0Vex/pqxjt+dcvdFyu6DAQxmKZwb+3RcJWBHHkis4aGg3adcfz?=
 =?us-ascii?Q?Tn200IXvlOLn24luBPooLaFv+8Rr1J06cwZlAhrMPVK8g2GclHlyUw64e/fS?=
 =?us-ascii?Q?O2/c1xgW0XoaGUavkkXgyZcdxCiJpaVi+oDEqt6/AbcmyT2LvuDGz67aWOdK?=
 =?us-ascii?Q?oVDc6MxxvZhg13fRpF8hlHgXgVsP3h5CYj7Xgqif5kwzaeS6sTKip4JRwO9T?=
 =?us-ascii?Q?UAUPJy2teEO+daRLGYIXlYjLLlS7TVRE1KId+P9ZwNRUvbWf1FYghMUud4br?=
 =?us-ascii?Q?blPv3Mn/4QsLd7EDtSkXna68B2C6D7rLEZWMNyBffV0ogzYcIwVukiCxjPFa?=
 =?us-ascii?Q?zy9uu0n61Nzbqny5h3NsWiN5TmYKyjXRn2dM2DvCAxvIZBOcy3aB1PrIqc+F?=
 =?us-ascii?Q?pIl26Fvy7LC9xryveUCYFXgOSIorMX0+asVX/7JoqdtHPDkrnk+yRlkOl/ll?=
 =?us-ascii?Q?4d5V7CHN374sRCboi/4Kujdz6zlBzExCpJ6q8bL9ww2+GCSO6Z+gR9emIQpK?=
 =?us-ascii?Q?0R1abuDoFZtiaXpjifJKoejxuPnHQIMQc5xPKrDQ0oz5SHhm2df/jE/fGqQW?=
 =?us-ascii?Q?1aapwuPKgU7yzrjOYIKcziI929P24F9VJIB9iDtzSFH2zODgmMwEZQy13Tkr?=
 =?us-ascii?Q?GXVL+UUTziUi6brRgKXPIITA6MrizDLGlGfCFnrI0M/1coVhiPa5zaAEezkN?=
 =?us-ascii?Q?uRDemjiG55oeLqFxE2lQ0y+NKP5ZyVA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c166c87-6ca5-4ad2-7687-08da3ce32ff5
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4166.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 17:39:28.7767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cxJSp2QNI8DjRWQ9nFZOlyOfatH7HEV6ZDG8Vk9L8gHPwve6cW6nuHqBtt1BMZQs9OdSFPKY1QvfWrw3AnOfyPyDzXIx6iNuPPEPLw8XVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3181
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_07:2022-05-23,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230099
X-Proofpoint-GUID: tAAlgkciGCPHJYBm4U_su7eZiMoaAKck
X-Proofpoint-ORIG-GUID: tAAlgkciGCPHJYBm4U_su7eZiMoaAKck
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> From: Stephen Brennan <stephen.s.brennan@oracle.com>
>
> A rare BUG_ON triggered in assoc_array_gc:
>
>     [3430308.818153] kernel BUG at lib/assoc_array.c:1609!
>
> Which corresponded to the statement currently at line 1593 upstream:
>
>     BUG_ON(assoc_array_ptr_is_meta(p));
>
> Using the data from the core dump, I was able to generate a userspace
> reproducer[1] and determine the cause of the bug.
>
> [1]: https://github.com/brenns10/kernel_stuff/tree/master/assoc_array_gc
>
> After running the iterator on the entire branch, an internal tree node
> looked like the following:
>
>     NODE (nr_leaves_on_branch: 3)
>       SLOT [0] NODE (2 leaves)
>       SLOT [1] NODE (1 leaf)
>       SLOT [2..f] NODE (empty)
>
> In the userspace reproducer, the pr_devel output when compressing this
> node was:
>
>     -- compress node 0x5607cc089380 --
>     free=0, leaves=0
>     [0] retain node 2/1 [nx 0]
>     [1] fold node 1/1 [nx 0]
>     [2] fold node 0/1 [nx 2]
>     [3] fold node 0/2 [nx 2]
>     [4] fold node 0/3 [nx 2]
>     [5] fold node 0/4 [nx 2]
>     [6] fold node 0/5 [nx 2]
>     [7] fold node 0/6 [nx 2]
>     [8] fold node 0/7 [nx 2]
>     [9] fold node 0/8 [nx 2]
>     [10] fold node 0/9 [nx 2]
>     [11] fold node 0/10 [nx 2]
>     [12] fold node 0/11 [nx 2]
>     [13] fold node 0/12 [nx 2]
>     [14] fold node 0/13 [nx 2]
>     [15] fold node 0/14 [nx 2]
>     after: 3
>
> At slot 0, an internal node with 2 leaves could not be folded into the
> node, because there was only one available slot (slot 0). Thus, the
> internal node was retained. At slot 1, the node had one leaf, and was
> able to be folded in successfully. The remaining nodes had no leaves,
> and so were removed. By the end of the compression stage, there were 14
> free slots, and only 3 leaf nodes. The tree was ascended and then its
> parent node was compressed. When this node was seen, it could not be
> folded, due to the internal node it contained.
>
> The invariant for compression in this function is: whenever
> nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT, the node should contain all
> leaf nodes. The compression step currently cannot guarantee this, given
> the corner case shown above.
>
> To fix this issue, retry compression whenever we have retained a node,
> and yet nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT. This second
> compression will then allow the node in slot 1 to be folded in,
> satisfying the invariant. Below is the output of the reproducer once the
> fix is applied:
>
>     -- compress node 0x560e9c562380 --
>     free=0, leaves=0
>     [0] retain node 2/1 [nx 0]
>     [1] fold node 1/1 [nx 0]
>     [2] fold node 0/1 [nx 2]
>     [3] fold node 0/2 [nx 2]
>     [4] fold node 0/3 [nx 2]
>     [5] fold node 0/4 [nx 2]
>     [6] fold node 0/5 [nx 2]
>     [7] fold node 0/6 [nx 2]
>     [8] fold node 0/7 [nx 2]
>     [9] fold node 0/8 [nx 2]
>     [10] fold node 0/9 [nx 2]
>     [11] fold node 0/10 [nx 2]
>     [12] fold node 0/11 [nx 2]
>     [13] fold node 0/12 [nx 2]
>     [14] fold node 0/13 [nx 2]
>     [15] fold node 0/14 [nx 2]
>     internal nodes remain despite enough space, retrying
>     -- compress node 0x560e9c562380 --
>     free=14, leaves=1
>     [0] fold node 2/15 [nx 0]
>     after: 3
>
> Changes
> =======
> DH:
>  - Use false instead of 0.
>  - Reorder the inserted lines in a couple of places to put retained before
>    next_slot.

Thanks for the fixes, sorry I left so many loose ends on this fix! All
looks good to me.

Stephen

>
> ver #2)
>  - Fix typo in pr_devel, correct comparison to "<="
>
>
> Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jarkko Sakkinen <jarkko@kernel.org>
> cc: Andrew Morton <akpm@linux-foundation.org>
> cc: keyrings@vger.kernel.org
> Link: https://lore.kernel.org/r/20220511225517.407935-1-stephen.s.brennan@oracle.com/ # v1
> Link: https://lore.kernel.org/r/20220512215045.489140-1-stephen.s.brennan@oracle.com/ # v2
> ---
>
>  lib/assoc_array.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/lib/assoc_array.c b/lib/assoc_array.c
> index 079c72e26493..ca0b4f360c1a 100644
> --- a/lib/assoc_array.c
> +++ b/lib/assoc_array.c
> @@ -1461,6 +1461,7 @@ int assoc_array_gc(struct assoc_array *array,
>  	struct assoc_array_ptr *cursor, *ptr;
>  	struct assoc_array_ptr *new_root, *new_parent, **new_ptr_pp;
>  	unsigned long nr_leaves_on_tree;
> +	bool retained;
>  	int keylen, slot, nr_free, next_slot, i;
>  
>  	pr_devel("-->%s()\n", __func__);
> @@ -1536,6 +1537,7 @@ int assoc_array_gc(struct assoc_array *array,
>  		goto descend;
>  	}
>  
> +retry_compress:
>  	pr_devel("-- compress node %p --\n", new_n);
>  
>  	/* Count up the number of empty slots in this node and work out the
> @@ -1553,6 +1555,7 @@ int assoc_array_gc(struct assoc_array *array,
>  	pr_devel("free=%d, leaves=%lu\n", nr_free, new_n->nr_leaves_on_branch);
>  
>  	/* See what we can fold in */
> +	retained = false;
>  	next_slot = 0;
>  	for (slot = 0; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
>  		struct assoc_array_shortcut *s;
> @@ -1602,9 +1605,14 @@ int assoc_array_gc(struct assoc_array *array,
>  			pr_devel("[%d] retain node %lu/%d [nx %d]\n",
>  				 slot, child->nr_leaves_on_branch, nr_free + 1,
>  				 next_slot);
> +			retained = true;
>  		}
>  	}
>  
> +	if (retained && new_n->nr_leaves_on_branch <= ASSOC_ARRAY_FAN_OUT) {
> +		pr_devel("internal nodes remain despite enough space, retrying\n");
> +		goto retry_compress;
> +	}
>  	pr_devel("after: %lu\n", new_n->nr_leaves_on_branch);
>  
>  	nr_leaves_on_tree = new_n->nr_leaves_on_branch;
