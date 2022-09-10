Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F885B4769
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 17:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiIJP7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 11:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiIJP7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 11:59:08 -0400
Received: from GBR01-CWL-obe.outbound.protection.outlook.com (mail-cwlgbr01hn2246.outbound.protection.outlook.com [52.100.178.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DBF402EB
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 08:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+IzSGsvGXYRG5FWlhN5QLiYAu7lQYoeYDxsJZb7qWpvgy19d65V4jj+0XExsTsHSVbttMV/+cQ5E25RY/+V+n5VN1P73STPQAH+Uc8k2J0IzfTfmLQ/8AWH008oABYVgLSGxD3oJztArzbFw4BeIiWNvhC1Qv5aeNVq5Cby/CqQowBZkWOdUhZowADBhrsPXnc7McYW89itQqCl3NP0lpY+8M7QnqOEEaN+UVe8k4hwdBFbeVPck1WH5mf+ZQU9jbWz63nJ6hxHur282WxtZCrkJRzkOg+77lzAdIKUP721ZBCKIlQ9zI8QQQW3TpUuRHlzMfKlVLPCgCizBASW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=th6RZcxCuR6Al8nV254zAcBRyn8bJ4DuGbMWIqqPL2w=;
 b=oYHIip4hpVO4SvA+dCFgkLP/NkIZOFt5HJukSuAdJFM5SlrsDVdIYn1Pv9DzxThtqKeP6SgfU4Cwx81D+Jg+Ec/PdhKLzJvwxqd7j0fHzt1kvqk/6LP2fw0ajNV7Hov/z0cON3ARc7orL1tuEPWuWFozQ2VdJpO+AkZ++ag8e8qhW94M/l7k/7ScfhsHUtOCXe+lDaSWl2SZC+6a19z/zcj6DRKiB5tKk67TizUXVSPIxKkVKUsIYRaGjQ+7T3nAZZTsGUnqWVnAxjlx4Y8sjjdDsYGItdO4PtZ7H5jAt+44UK1IJo2Kd2O7nlC5mQ2mAOk1Hzq0qyzkVWFVTRX5kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bywater.xyz; dmarc=pass action=none header.from=bywater.xyz;
 dkim=pass header.d=bywater.xyz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bywater.xyz;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=th6RZcxCuR6Al8nV254zAcBRyn8bJ4DuGbMWIqqPL2w=;
 b=YwAFJm0tNNGbl3lCwuGqqzv/9VV0VTMFoY67HQcabaFDxzcyyJLnSlqPDCLXhbmYRft4pn09Xlh9PyRtUQkCAjJr0IgILKMzcxdl485p+/OqMY1jpEJna99g55+3TL9ps6FmoUNT7PIkoUYLdf09tdEiYifeoHPO68EKN485x1tod/F0Uky1CNZer21L8OD0MoAASF70TekQbnXs6CzNUCG9JoSFCxnpqY7oZqHb2ZKMmEN9bepB98yAAaj9O6a4EC+hnj1L9BlQK2mA/WVaG3Fwn2NWLMyQp+Ns1KTcjqCbubOpPHTbl3E8eDIcgzZZ8TCaBq7R4U1OHuPIov4LRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bywater.xyz;
Received: from LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1f2::7)
 by LO4P123MB6466.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:29a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Sat, 10 Sep
 2022 15:59:03 +0000
Received: from LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 ([fe80::e11b:26a4:86c2:f2f5]) by LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 ([fe80::e11b:26a4:86c2:f2f5%8]) with mapi id 15.20.5612.022; Sat, 10 Sep 2022
 15:59:03 +0000
From:   joseph@bywater.xyz
To:     joseph@intrigued.uk
Cc:     SeongJae Park <sj@kernel.org>, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>
Subject: [PATCH 03/50] xen-blkfront: Cache feature_persistent value before advertisement
Date:   Sat, 10 Sep 2022 16:58:06 +0100
Message-Id: <20220910155853.78392-3-joseph@bywater.xyz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220910155853.78392-1-joseph@bywater.xyz>
References: <20220910155853.78392-1-joseph@bywater.xyz>
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3498; i=joseph@bywater.xyz; h=from:subject; bh=JSJMNmqYzB5i9CH6Ni+8L1naPeTWi+hE7GkRxsBm59s=; b=owEBbQGS/pANAwAKAXxHkY8fXCH/AcsmYgBjHLQDrU5dcaTr2tO8GUqbqADYviRWKNEwuIzTseHj ps+LY0+JATMEAAEKAB0WIQRiG5oO6weufXC5rRB8R5GPH1wh/wUCYxy0AwAKCRB8R5GPH1wh/x9uB/ 4ytmDcGes5jkbx05N//3fLkLUhmGabuWUqNuKq1jwPvUhtsAjsVRBU2I6WDDb8v6jxTMNoMlbbSW53 Aa+NYFuCuhb2KlWPB25F3Ne44lpSWuDmKy4dg3upd0cZnpdzN/q6CCTLL3BnSErtHX7/NLohfHX/B5 UjHCnQXuB2TNlBl3inIozG+k05CPAAzER+XaGFQZfpvN7ZFZOfMNHGQ6vNp35+E2WHFoQDcN607mw3 tUUS+dOL3p82bMnNWLKtS/r2b2L5w+/Uj7WMVsqS4lP8vo0URwdWhkaKWjyCR30oP8J3P+RiF2T1NQ tiGeOQ9CisTCfrEHKA6cTbN6H4avRi
X-Developer-Key: i=joseph@bywater.xyz; a=openpgp; fpr=621B9A0EEB07AE7D70B9AD107C47918F1F5C21FF
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0093.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::8) To LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1f2::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO4P123MB4995:EE_|LO4P123MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: d50286ac-2a8e-47c0-2011-08da93456246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aW14bXRiL1FTYXRpMXZ3QXJhQmxVMUdCbklJdU5iUG1zTFVob2FMNzhBMWEz?=
 =?utf-8?B?bTZ3ZHRITVUvMVluV3psZ0VxUFEvcFEzb0FoUUc5Y2dRK0lEakl6N0dsUmVM?=
 =?utf-8?B?citIMnIzOWgxeUpOSm5CNVZTQ2RWdmxzWDZ1WWRtOTRpemFuWnp6c0pZMGh2?=
 =?utf-8?B?TU1MYWxzMlJwY2lBUEhuRkxKd3FNaUJ6UTgyMmE2SCtDc096bVBySEw3d0xl?=
 =?utf-8?B?L3RraS9OV0JVTTF4ajd4Ym1md1AybVFlcFNScjVua3pyU3RpNWN6K3FzRmJD?=
 =?utf-8?B?RC91bmoxa0JBYnppQ1JrQzhuU3paMktvMXpGOTBSZDN6SDJhWnJ1cEN6UWo5?=
 =?utf-8?B?VFJGRGdoWHUyMm11aEZYV1VGSnA4MWRHbTFyNWs4SzZhcWVLR2RGNkNHUlNK?=
 =?utf-8?B?QzEzUzVKVlRFaWlNcGV4azNabjQ5Znk1RFd3ak5MclVnNVJZZmxEVmFzVUJE?=
 =?utf-8?B?YkhTTXZXZ2gxbzRYY3NMdTFTRWtGMit1cWV1RGJaYWd1ck50Z1RxTUFmTFc5?=
 =?utf-8?B?cDFnb3lmSFZkNGpJUnh1eis3MnFIbjdIRnV2TnRVRmRRSEFoNkVXU3IyYzZC?=
 =?utf-8?B?RzFpTldsOGorWHd1SE5VRHpYaUp4U1Aza2l3bVNzVmNxdkZTR21heUl1d1A0?=
 =?utf-8?B?UmRFa1dCcklOOE9QeElGRWVuKzhTMXhJQmVJd25BbHBmV0kwTVNqL2NKMjhq?=
 =?utf-8?B?MmxGWEdkVkhnNVJKWWFhRmo5L1dTL0VXTFJQY0MvUDBmNTg1NGN2dzI4cVVv?=
 =?utf-8?B?ZXpLazNEZWdUN1UvKy9WOXJyb2hTanI2TDJKcjZ1Y0tGc2k5a2FKcEdWYlk2?=
 =?utf-8?B?ckdDZ2xMQjRGeUlMbzBGdis1M3NleTZuVU1IQVllUUlKcC8yaExnQWJnd2F5?=
 =?utf-8?B?SDBWZDBzN2ZQbHhUcUNoNnVaZWlUbnFYRzdEMXdLUUI5SThPL0JGZkUrOC90?=
 =?utf-8?B?VElOdStEWEsyamgvMDEzSHl6a2plUW5EV2xMOFZINDk4YWYxZDFkWGxFaHpK?=
 =?utf-8?B?SWtsc3kwRTJrYjlPbU94WGpOZCswVUh6WU5QdDhvbEpObHdTZkhkaHNBaVhv?=
 =?utf-8?B?NDVzWTZqeDVqYVg3Qm5IUG1TWmM4ekVNclpzUE5lUEF0UE1CVU1vZGVlSjI2?=
 =?utf-8?B?SHEwTURJUHgwajN2ZkVwU2RBaXF3OTRsK1hmRmtIY082VWlMdXNKVDJvemFQ?=
 =?utf-8?B?UFRoY2RBQ0JHa0lUeXZUQXMzS2lac3c5YTJJVndzZnJzNEI0RW5pOGpBUGhF?=
 =?utf-8?B?RGNWdmtsVStMZkZpaVVyRUZQcVREaWVlbFF2c0lGeng3M0VHRnZMKytDOHVo?=
 =?utf-8?B?eFlFZVFvMWp3Qk5FNTVNbmJxQUtOVmlQS3RGV3ltRnRqQ1NCSkRmZGZtRDBx?=
 =?utf-8?B?N1FGQ2p4KzRkZ0gvcDdySDhYUUsvcVpFblBnbUhjUDRvOTR3VDZwdGlqSEdm?=
 =?utf-8?B?VVhKUzdaNnJRcG5LWHpPb3d2VWh2YnFLR2NzTGpzd1VsbXBZbDR1a05nbGRT?=
 =?utf-8?B?V1E5SVpxdmE5emRJaFhGZ3cwMWVWNXo1UGY2cHRyajQ2Q3l3STdkOHBMR0pq?=
 =?utf-8?B?eDh3NGx2ZzRKN05tbzhlbGN2Q1hRUlVKSEVFKzFUSUNSNXNhbEdsd1d5WFh5?=
 =?utf-8?B?WjVXMVE1dWZWdHZ1RHU5U3BGOHkzMEE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230016)(136003)(366004)(346002)(396003)(39830400003)(376002)(83380400001)(66574015)(54906003)(966005)(316002)(6486002)(478600001)(36756003)(2616005)(2906002)(6512007)(9686003)(1076003)(6506007)(186003)(52116002)(86362001)(38100700002)(8676002)(4326008)(5660300002)(66946007)(66556008)(66476007)(8936002)(41300700001)(34206002)(4720100020)(309714004);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTFrelJrYUt6MFdJVUFmQkNnc1RZenlJN2xzK1NmbXVHMlI0anRQMnE3cElT?=
 =?utf-8?B?a2ZLa3cwaGFqZzVINW1jMC9wdUR6SzVIKytXRTJPWlB3d3JTVmxZZk1XbU9G?=
 =?utf-8?B?ZFE0bmlsS1lMY3BSeWQzejU2N2U1MmdXbitKWEdrUlB0ZXEvbE1BQkFMa2hC?=
 =?utf-8?B?ZVVSOGw4alVWR1dXdnNZMHdwKytUMnpOS3Jod0FVV3dlNkhibEQrWXJITCtE?=
 =?utf-8?B?UnJYQ3pLOEVTRFk0Vk42QWNNbzBoOG10d093UkJBbGU0N3k1UWU5SGZqcmRS?=
 =?utf-8?B?ZUN1V1RCRVJmOFhWKzVxRzZvd29rUHVnUUZ6T1ZkNzNwTThjSEY2cTNadUND?=
 =?utf-8?B?U1RuenJGWkZhajdDQ1c5ZHp5WW92NG4rRFdyYSt5bkMyL1FlVi9Hbk9Ia2Y4?=
 =?utf-8?B?Yi9LQUc0UEZXUFlPc2pZdXZjbWMwK2x6bzlNb1grTnVubklFS0M3cVdXZ1d3?=
 =?utf-8?B?bnkrVFQ5d0kzSEFkMTQvc3EvVk5tRlZTd1FSNTd4ck0xOVJxSWtmcFlnMDdZ?=
 =?utf-8?B?Y3hkNzRPZGROK2NNS3d4cUQ0Y29Pd08zbTNKWi9yTkE4ckNyNyt1ZGZJbzhx?=
 =?utf-8?B?M1haTHV6NUN0ZzVUVjZNbHMzUVhUeW1payswUVZqSFlTUHcxYVpYdmh3T3l1?=
 =?utf-8?B?RENRMVpLWEhrWkR6Yk9mQWo0cUx5TWNYL2JmcnVxYTk4MlhPMExmN0xtZWY0?=
 =?utf-8?B?RVlxM1c4djd3RU9WcURRTHNTQmFWS2JpOHB6RGI3N0wxeWNCQTk4T3FiRU01?=
 =?utf-8?B?TzFtN1QzUEJJWWhmY3R4ZkVjTVc2MzdCQlc0STN3S1BFZWhTRVZEbWNSV00r?=
 =?utf-8?B?cm9HOW5rWTErdVpKVmZZcWR6VStETTBJV3BQTXZvdHJxMGJiM2RoejdxL2d0?=
 =?utf-8?B?TmVZdHlKWkk0dVRzYlFjaDB3ZTdTZ0hjc1pTZmN4MWw5OE1xdVZKZUc2UHRk?=
 =?utf-8?B?Sjl5M2M5WnJTWVBTV0s1dzQ2NWNpQXJla1pkSmJyalB4TkJhL2REKzVLamJi?=
 =?utf-8?B?RmEyVnhBaDhXS0NOc3Z3d3cvOEFtNTFVcitPUTBoTkVyd2RGbUpHUHFCYWRp?=
 =?utf-8?B?MHlBU3ZNcnM4NG52MXNMaVEydHc5YmFIMXZ6UDhFK0tHZloxdlRSVTBZUXhx?=
 =?utf-8?B?Yk1yaGF0Z2hnNk9yd0g1aGNkRFpTZDNpbkFHMnNWNnN6RGIzcW55cEFsNWpV?=
 =?utf-8?B?QnhLQUlpNUtMaVNGM3A1NFcydi9JZ0VYWlNpbXV0UE5Qd0xjamFPMCtMNmsx?=
 =?utf-8?B?dVQ3Uk1waXhKNjROeUpkUVNLVURSOWM0N1BraEdSeFYxem1QZmRMeHUyTEts?=
 =?utf-8?B?SlNscHhabUFEVFhodDZIQTh0VTF6TC8zT1ZGQWd0Uk4xcEN6SXMzZVNMM1RM?=
 =?utf-8?B?Y0R6R09xNHpWbng2b2UzbGlQTmVZNlMydlpKNTZ1MC9MR3JDUjVhb1VxdXMy?=
 =?utf-8?B?VVpaV1ZtM1EyT0w5eWYvcno0YUFxa3VqMlBpNGhmVWJZN0U4ZXNMODg3SEpD?=
 =?utf-8?B?WjhxM3ZZZU1xYlZ2bE5VV1V5TkRlZGxNVmRBeXhTSWtRVzhieTB5TXNVQldr?=
 =?utf-8?B?T3VpL0dFUWpuK1BLMFdWS1NRMG1QclZoRlRSa0xPSDRhZm9ocUY1eHZkUXJO?=
 =?utf-8?B?Y3JwNXFUcW13UE55MS9FMHl6VUkvVWdqUFExd3pNTExOVXhBVGhjb3d5ZHNL?=
 =?utf-8?B?QmtkTWlWNkUwdEQwbWd1ZzV1U21vUTdmRGttU1JFeW9jdWxZaXJNelBydXR3?=
 =?utf-8?B?QlZydnp3dnlKRFlvR1JVVzRtZjZKM0cxTkF6em9aNkpzeFhkWkhUUVB1U3pD?=
 =?utf-8?B?ejN6YjZXdk9DUTMweDZXM0c2RzRHMGpnQmtUeHVhYk1JUU1kdTBQa25NYk1w?=
 =?utf-8?B?RW5NOVcxYlBIVTJkRVpQTXRERkNmL2hSV1BWWE1FZDlqYk90OEQvaE5sTUpw?=
 =?utf-8?B?cndjdk5wQ0gzTXEzaHQ0dlZWM0VDL1BRTGVQLzllbTVxRGRDM09OYU96Z3dz?=
 =?utf-8?B?OFJQQ1BEdTJTNFhlSEZMbUFTWU44eFFMck0rbmNGTnU1N2JRM3NTdXB1TC9Q?=
 =?utf-8?B?TGhOODZwV2NvRitTMU1WTU1ZUml3QTE4REFhaEZHVGdjdG13SnZFd1RDdXFN?=
 =?utf-8?B?TW5Qc3M2YkZvSDIrcEw1djBET3ZnV01VQWUybXd2YkdxMUZ3ZFBRenR2UTg1?=
 =?utf-8?Q?FQmtFoZHHzDKkgLlw/SsBZXD6cyP7F+TeKn6jjQI0Ps0?=
X-OriginatorOrg: bywater.xyz
X-MS-Exchange-CrossTenant-Network-Message-Id: d50286ac-2a8e-47c0-2011-08da93456246
X-MS-Exchange-CrossTenant-AuthSource: LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2022 15:59:03.7761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 42dcc6dd-439a-483c-99c4-86bd4e2f0f10
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFGHfkWLV8sYA0yLVlmHe57dgaXAi/5Bi7yFnid3AvgqoVEluftlMb5BswYaCdLjSuTGyYIFDOFsk0mTMrTZ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P123MB6466
X-Spam-Status: No, score=2.5 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FROM_SUSPICIOUS_NTLD,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

Xen blkfront advertises its support of the persistent grants feature
when it first setting up and when resuming in 'talk_to_blkback()'.
Then, blkback reads the advertised value when it connects with blkfront
and decides if it will use the persistent grants feature or not, and
advertises its decision to blkfront.  Blkfront reads the blkback's
decision and it also makes the decision for the use of the feature.

Commit 402c43ea6b34 ("xen-blkfront: Apply 'feature_persistent' parameter
when connect"), however, made the blkfront's read of the parameter for
disabling the advertisement, namely 'feature_persistent', to be done
when it negotiate, not when advertise.  Therefore blkfront advertises
without reading the parameter.  As the field for caching the parameter
value is zero-initialized, it always advertises as the feature is
disabled, so that the persistent grants feature becomes always disabled.

This commit fixes the issue by making the blkfront does parmeter caching
just before the advertisement.

Fixes: 402c43ea6b34 ("xen-blkfront: Apply 'feature_persistent' parameter when connect")
Cc: <stable@vger.kernel.org> # 5.10.x
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220831165824.94815-4-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/block/xen-blkfront.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 276b2ee2a155..1f85750f981e 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1759,6 +1759,12 @@ static int write_per_ring_nodes(struct xenbus_transaction xbt,
 	return err;
 }
 
+/* Enable the persistent grants feature. */
+static bool feature_persistent = true;
+module_param(feature_persistent, bool, 0644);
+MODULE_PARM_DESC(feature_persistent,
+		"Enables the persistent grants feature");
+
 /* Common code used when first setting up, and when resuming. */
 static int talk_to_blkback(struct xenbus_device *dev,
 			   struct blkfront_info *info)
@@ -1850,6 +1856,7 @@ static int talk_to_blkback(struct xenbus_device *dev,
 		message = "writing protocol";
 		goto abort_transaction;
 	}
+	info->feature_persistent_parm = feature_persistent;
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
 			info->feature_persistent_parm);
 	if (err)
@@ -1919,12 +1926,6 @@ static int negotiate_mq(struct blkfront_info *info)
 	return 0;
 }
 
-/* Enable the persistent grants feature. */
-static bool feature_persistent = true;
-module_param(feature_persistent, bool, 0644);
-MODULE_PARM_DESC(feature_persistent,
-		"Enables the persistent grants feature");
-
 /*
  * Entry point to this code when a new device is created.  Allocate the basic
  * structures and the ring buffer for communication with the backend, and
@@ -2284,7 +2285,6 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	info->feature_persistent_parm = feature_persistent;
 	if (info->feature_persistent_parm)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
-- 
2.34.1

