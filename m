Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467DF6DDF25
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjDKPMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjDKPMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA2E59FA;
        Tue, 11 Apr 2023 08:11:42 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BF1L78018024;
        Tue, 11 Apr 2023 15:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=H7GafY00XNeLtGkCZPLes1j18MvQT13RgP/nrlD7voE=;
 b=fvhICczC7rZpLEfnU/d79n7YqCbnVqbnlnoJvQvETGDKs6Q4ueJlSSSNI4m+ZQkCK/tF
 U5pksU+atGTHLbkKLkwDq3aluumaHKLhEbnlaF/ZON9aYn5glm+v8rsoTvqatCARy84+
 usG55BHjUANpVa7HXfUJM1RHVTDeydjaLm1M2SoR33bet3YjFCp6TRrM7pY5azcy1UR5
 pkxMJG5lMuXNhpEAXdrGE6RNVuvylgfSGQr/O5G5qz5PJRuh9Lt8IR4FRyY4o2rCQFmy
 KALZHspi/IHFQOXgFPg7mcpP/1IXnGBNG8M8/2D3nyWcyVKG8hVOOTs3FyYolA/51Xxo ww== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etnntv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BESfgI008096;
        Tue, 11 Apr 2023 15:11:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc4970a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E32J/u5pRjLMPaM4hkGimqGq28955OIrkdEzUCbJ8AZmPGNoa39fD6xq+gh0f/wtYulCWF4yQgrknMd0MlWRKMauQGSGh2mW8mYwUhLnNRAm5Y2WUTuuvrKNVHdKzNpzgYcSiJG+BCEMYE4gB/R0vISFbaQAmedan7VJDqlF7a5cn3+20EHPglIyfwgu0IdnowKXXXhTaczlRstP7ARQzDSS3TnYUyF8jose4eksLHi6NNQF0TjbFErdG0+d7cyxyjzK/ilhFEBJRNC/+XjSCTWUG9AoQzSpLv24peMeDqm+8weG9PuRsLaQKDnl7PLIETn3FbZQAG0y4n4n1puIow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7GafY00XNeLtGkCZPLes1j18MvQT13RgP/nrlD7voE=;
 b=HLAQhXkHeCSR91CAANmfsuys8tVjVLnaHcMQ0GWHbDdlgpgnz0/ObstzCDt/Z7fT9Y2S5Gszrr8xcEjYVl0C57HYSdAxsQOooPSArsXfCwvlvYKksDfFG9hWexjmHJwJa1KnUGt1FxwhMZiBMholqyr3MQ6iByIOzYpQOr03TdTP7qJyyCGLB9Q48lFIw8CJyxRzRpEIssgmSo+GVb6G6YqbbXW2553Ziw1FgF6a3qKII2HguGwmYwqeExt7Tj7Y1MWsPeI4EqsZC3ZhqVDA673+GhxIp8AUhUfm3ihG2PaH3hR68JYt1c7Cgquo3pUfeg5xv2jaCzcFveqUxSiTWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7GafY00XNeLtGkCZPLes1j18MvQT13RgP/nrlD7voE=;
 b=aDqssLow9qCrE+0tre56KgfSYAArX/FoHfWPLIR1Zrg/fYIirV42wErH5KjL+cBeIlQkU/fF5tppFTMgdO7vdrP4s+ji1svT06resjJZiY32pTJRh+teyWumLuWY021MYPP52qejymgtntb6kiixZ37lHuSdrAR/4EWFd1DRfZA=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 15:11:21 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:21 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 00/14] Backport of maple tree fixes for 6.1/6.2
Date:   Tue, 11 Apr 2023 11:10:41 -0400
Message-Id: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0137.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::16) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: a610d5d1-4053-478d-cade-08db3a9f023c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Q32u90WeHdFzblI3pHYgd5VD5OgP9ZPbIeTNBKcy4m9Bjkevc53bz/7kNNnt+VoAADWNYsqBX66Fvk5D6wzqLYPDiMndS8bKv8TJkNnibCHHZZ4HKjsJgSnE3j4Wvsb8Lsfopm7iIRherT6kJZ8O3fa4fE2f5UExRaPG1UtUTmrkp4iqBh0X/BGWACzX3dzGlcXU3J/l7EfQNEhuKNcsaofQ3zP7AjFwqTRjsIwFjDCSiNMdsc2IsWXLR6lvZ+nTJIJhipyjjb48CN9bmE9vhh5KuqB66NP8UuYphdi2FWe/jBNGScrX2JgdVqTFJyQaiIzdl1t0MLV44LlXWVmP15vUvTpF5ZgdcDMhKBRumlie/eyg6G8cjvtegbN1rwkYVOdmUcbvm8RviuGCBgZ03i5HZao5/ppMAFkFi4dniC/5DJyOZ56duYhzEnBlJVzvtXDe7z3mGi/uA/4MzOL7klwhTfm6o0qg/w3BxYMrA/tA/+RPJ94yCLRhg5919kLhknPcOGrbw6GQdWwouNqUuTXR4tCPhhfeUhF6YJUbj7ejf+LosIGu9qlZy1/DcQ1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(38100700002)(6512007)(6506007)(186003)(6666004)(26005)(1076003)(107886003)(2616005)(8676002)(83380400001)(2906002)(6486002)(5660300002)(8936002)(36756003)(478600001)(4326008)(86362001)(316002)(66476007)(41300700001)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZgAvRKTCuzq5D/LHWbQwY7+xqftHWlPj/1LcjQyOLkitK6lstcP8gudWs/Z2?=
 =?us-ascii?Q?0E3W69Q39vyxavEzuX5eTFP66ilVb0dNtQERykUN3MKWJez4y01WytbR+zY5?=
 =?us-ascii?Q?DFpq1DwJpsnYfskuyoSfKYqwNfu4x/xof8Mus7wFn+N0VKxhcdMfSm61RK2z?=
 =?us-ascii?Q?/LVILK8hXjEz1TWjTA7PhG6hf5QchwwoCJcu2GNoupGbTDGIWSIkCDyjU/zI?=
 =?us-ascii?Q?Jwl2N0BGQPPDkHzuPAhR0MQdEud7zxepPUDDLPCgqkR06bMvbgd5XOohX9z8?=
 =?us-ascii?Q?zCQFGTdwkJhWqI7HuB/2g+Gwm0uCqRnQVmaQUPyhi5MjT+NsMNzIEd0jKCQu?=
 =?us-ascii?Q?eawsC5pmU8yJMVJlMf7yJUOvZbCLfzX7DCicghMELLxMsRMerzkUyjM0WOzw?=
 =?us-ascii?Q?xFcHVmq3nOTKT+D61vlSCpoPuNKend5aG+x9N/XJXZ3pZTakiza09kFfjhqH?=
 =?us-ascii?Q?pcFW14Re3wTwiAo3TXuE0hhqI4uJg3Tg/HPmJe2dXX3pKaK/bdf1ppPc33Gs?=
 =?us-ascii?Q?NG8KLdpTlHRE1e8EFrxpUMpE6IaxBR3IBFY59g7FvJHNzrt3IFYg+tV5Fb7w?=
 =?us-ascii?Q?L9zV4WGIS2GjICmf/QWi4jr2IzwMJcb0UuTD7PuKC4GSU1cvq+feehosxmoo?=
 =?us-ascii?Q?k41zXSmwiKJptTM10MPAKCWf8vSSsdZvZjJSOdCO2hPPXtr0FaQl1WXMV56O?=
 =?us-ascii?Q?xEppTL+iig4K/SeT2YU6YodXVNQOAWhcMRfppQGPa7QzrZdxPpyeu0b5JUxt?=
 =?us-ascii?Q?l0AjnyI88mNbsKggTLx6vUbaBIFavrSoFVdZcxA1N0S6Ch6XDeg5GfNCf3Gf?=
 =?us-ascii?Q?82TVlPbYutRsEQqBWfN40S1cBK2vRn7RAOBRiRiB2wwLgp/2P5uD/LVWRDj0?=
 =?us-ascii?Q?84Vgv8ftWG3CYucGW+q82SQLhx0LqL2uptdzaCBhQs4zi7zEiVh7ALSd1QsU?=
 =?us-ascii?Q?p+JuB8nKuYezgzvms072n5y1z2xJSAVFHP0KrfFsrLMXqMyFNxYill79zk+Z?=
 =?us-ascii?Q?cXaxdB0+jL/Pwma6j+2MhLR4C7iKmMKjZfCV1C1eIo5IVRWiSLqwcAbx7era?=
 =?us-ascii?Q?AT/rcysDKw5DBwmkoWlb6Hg+SmqzZ/ZCewcXeDhRbRJWHkhkkz/vUdf571d+?=
 =?us-ascii?Q?ICwjdfqaiJw9W6dqD9VI/qAzm7rhkUm+PCCB/TiYn2ky6Q0m7x6uqdg/Zm2w?=
 =?us-ascii?Q?8vUIfAIDS1Ike0FqtgLZW0uogdbJBQZmQJzFMRfT2zKU0kpgTUFK1rgQPFIJ?=
 =?us-ascii?Q?mNeIl+0nwB1mq5AGZxdZF39a93Nno0a/q3L+hy/ii1gBdU3ZiOA3Vg3rkqLi?=
 =?us-ascii?Q?gW+qAGkX7mGNqdTHU5qQJEyPkDJmb5k7Ki2YUjEpTAREPgBGdmTvkwOYD6va?=
 =?us-ascii?Q?DThFaPK9U26+UzGFlL3mdT7qcBbARPSh6aTaVnv0YVIQmKxfTjxDIjHGgHTF?=
 =?us-ascii?Q?VJ55a0nozutmXAiqzrcE7TVMgy/DUXOR93gGPFARhwcF47KoeMARLsVJYzNy?=
 =?us-ascii?Q?TvuxuAINP5+YcYB1exZEmqFYMeCJme8lhfbNfHHHwlsymRcXwUYJp185sPLw?=
 =?us-ascii?Q?c0+Yo5qVGTZMK3mJFAvjS+hk2xBTcFDly9SgjqgQz7fTXRA5tgLn84SaFA2J?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cdqD0+kBiPIbBV/a+oKK+jwStpfrVv/OWm4WkQob9hKSEJkHdN02UTdqAV0YTb8xTueBD571pVpiUfhtoN5f2zK7dj6jsXtut9vGZYBDxtw1aqBGYw864rXcojXJlvlffljmlvPvb6CO1y6w5iRkSGB+2FKnvV4TAYRZSTfLh28Y9ezKZCELErsF6huvARD1Du1bB2rTsD5khEjkfv+kiZ2DqvFmnyMIE2EXMfe6qWPSNEeV4xasVCDJ8vBKKclHE0fXzSq9oaT1SaBx4iSqUrMpm4RSxWEZx9SsflSK4YvG59mJrHHH7V9CziT4f5Y0I37EZ7W0n1IBwS5t4gncSL47R3fYB0N5ra1WH9yz7t5ZIAXaCq7yj95/6sCMISAEgHt354MD78X3mNrL3o3FdDOwzWOuDxhFvKSIvJOF8P7NYm2RTdcGybVZrwEZ2Nfi6ECEUfWatQG2EHsYO6NgjBGlRmcxvc7qVT6X5GAkgxTXYWrH3CVQ3YYlJ7ys8YKBycVmFMyA07c66OqPt7BN9obn72mRmgpSqsv7ly0yeA+C83TC11z6ScvrmtoAnYzyTRIL1Bg05PXOPAqf5sN33svFmIOGXHfcgHKfU+flfVxpYP/OK0bdErSaofB4h2EU9Zotl/HwYTeSeOcAtUK77riPrZhANlMdlQdc8DDWTlt0m7BxH7sBblWfLyT40qDxGoO2n8UXRbmmbAoGrWXeulkeg+8hDIOg7MayTIghRKsGHFFatNIUaGP6TjhOmyVhYEAfo4i2SpfxBPE/Yli37Xonq0WMbXVovataKlaYoTr/i723z/lp2+a/5H/MpnwsR0lhMD9Hc+/1KSM+vAVvnTAzQnWs4RQw8CpNrFgx4zVCplMt0QZr+OcjKQ4R88wDT8tgsFG5izbhDRYUSJ9csA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a610d5d1-4053-478d-cade-08db3a9f023c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:21.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zi4G+U5oMixiSl4nibE62xhZctt0Bl/l9DaspHKZojp+153dCpmvfji6ASKaesgIQocfFTujn0rswKs4KojM/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304110138
X-Proofpoint-GUID: LN9z2lZbsFBpfyCi55RagKecmIvTyGxf
X-Proofpoint-ORIG-GUID: LN9z2lZbsFBpfyCi55RagKecmIvTyGxf
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

Here are the backports of the patches for the maple tree fixes from
6.3-rc6 for 6.1 and 6.2.

The patches differ with a few extra patches for the maple tree, and
changes to the mm code patch to work without the vma iterator change.

Liam R. Howlett (14):
  maple_tree: remove GFP_ZERO from kmem_cache_alloc() and
    kmem_cache_alloc_bulk()
  maple_tree: fix potential rcu issue
  maple_tree: reduce user error potential
  maple_tree: fix handle of invalidated state in mas_wr_store_setup()
  maple_tree: fix mas_prev() and mas_find() state handling
  maple_tree: fix mas_skip_node() end slot detection
  maple_tree: be more cautious about dead nodes
  maple_tree: refine ma_state init from mas_start()
  maple_tree: detect dead nodes in mas_start()
  maple_tree: fix freeing of nodes in rcu mode
  maple_tree: remove extra smp_wmb() from mas_dead_leaves()
  maple_tree: add smp_rmb() to dead node detection
  maple_tree: add RCU lock checking to rcu callback functions
  mm: enable maple tree RCU mode by default.

 include/linux/mm_types.h         |   3 +-
 kernel/fork.c                    |   3 +
 lib/maple_tree.c                 | 389 ++++++++++++++++++++-----------
 mm/mmap.c                        |   3 +-
 tools/testing/radix-tree/maple.c |  18 +-
 5 files changed, 263 insertions(+), 153 deletions(-)

-- 
2.39.2

