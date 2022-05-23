Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE2531064
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 15:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbiEWMCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 08:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbiEWMCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 08:02:35 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08072CDE0
        for <stable@vger.kernel.org>; Mon, 23 May 2022 05:02:34 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NBOplA018984;
        Mon, 23 May 2022 12:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=25EC3c1BE1O7IeRj6Ilu0VLk9LGAumdeJ6KPTg0NKqw=;
 b=kHh7UuPJ09GMmJENh1YtDl0viS3mNNIVf8sq5tunbTjyMnth5QEhd0ffgTf4d0d741ID
 3t38a6PfU6ZFicT6+iJKOGCvsfThrwPFUtSInajtE0Bo9969EoSfA+pfir9wlERViulg
 U2zcr6Wh8NVK7bJsfvpo4FayVfHTmUIFpsxuQnYK41NMjgNujdE4Ax21yFSV9JmM9WoH
 rxVmQVWSCL/sx6gvG2aEdY8TPEPG0w++WHae2LZ1qDKTV8Alh01CJ3Vc3fKPnlcnnx7v
 ayN6vgkglar5jXQ5EwRdU1XX/tl1q1yVb5BYWGnU8x26RSxQ0+3rT9FOUpwLAKKpyUvB 1g== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g6s94hac1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:02:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEzjXxB8nYEyB7ZK73QFHKuI8qCbWn5D5eI1bbPBbQYWlSb0HzNCUJrfMP6NbtkpOU/8YvWDAh7gaYlcuTb5ZntPu2TspXAbaX2MGEs914ufbgnplbYx602UfJn6ZuAr3NaOrQqYO6EMeqr2svatyBs273wuHT43DXlf58I7lNNsm2PQXvuJutJ4j+nN18rWnFSf8Gu9fFFntDWyNENebXtPqQyV57cbWJcSc8A4XJ7LjQq7nsgdQW2qIx9BKP0xCLPXk1gaHr96CpC333l3jm8jRtCHXtAgoCV9G6skWCjuNJMzbiQS07gw2aSlk/AY102IcPNkaWcYd2NpN1eCxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25EC3c1BE1O7IeRj6Ilu0VLk9LGAumdeJ6KPTg0NKqw=;
 b=M0Kfr8KxYMw+lyUQSSZ24XCIuxn8U4ZvyYU828KyvhqdgeYAARG3a9lnmbeFT2bQW8qUAKylG/FzeXNGZ1PAYgQVTS9GrHk3qXwl4PMawhrmwOjq14xJkY0sh1OnJ0aLKiV4JLbaeTgd3QTBA+dVGoEqvj2LLkGNf0Ed9JntX+1LKQp7p44uuQ6I/nz2OVYtgCrwcsCiV94QzbgNK1ViWT4Bipgg/DD9PUXn4dSmDTPA86/J9haatmsvTrkLuie3QW7HwjVE0ahYdxff52UBy5BkIL1Zdt96aynikKZEqQDaFDDYVDLvA0wj2srmHxWjBI0Ky35w+I/D9zVodINoeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (13.101.57.214) by
 DM8PR11MB5672.namprd11.prod.outlook.com (10.242.161.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.16; Mon, 23 May 2022 12:02:21 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 12:02:21 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 1/1] Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""
Date:   Mon, 23 May 2022 15:01:57 +0300
Message-Id: <20220523120157.364113-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9P250CA0003.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:532::9) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7d7a1d0-ad50-4983-573e-08da3cb417a2
X-MS-TrafficTypeDiagnostic: DM8PR11MB5672:EE_
X-Microsoft-Antispam-PRVS: <DM8PR11MB5672B7638133477536DABEC7FED49@DM8PR11MB5672.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6lKD0HxP8qw/xTNIHvMrs3BdZ/hMB1EZJ9+66I8lEAD3GlWUI8Mt9uyl9wOgUTOohTV6U0cI9LmIX+LHIO6dawRP8uTHTgDvLU/yqy8wx3IQjdhHpbWhJ1cuW5FgQPtFY/SCTL/YXVLe2Y/hPXI7YZa4srUGO67w/PZtZBytSVtLW726J1U2E1aUEoIhniYL5wMJKDzhVe7D1xbyc0tlgggzSxRTPv2GutqdXXVFxsEF7XPrJdHh6NNui/xwIfd8aZZ1aRFw/VpkbVSmULDYL5c4EVF5K5cE+suXhm2f9b2oG4C875ElfhQj4jsnKB2Xb9OlTgBSfwingpLkwWJ5QQNO7T1dWYrg734pIF/guad6R1m1oxXLBi3mSxbEjkPX+MVINeRWTZMuGvmxU+cE33hnCleNvkaMwRFgGZmTzIXtJmKF7pUlgTJZ499L/WGpyiaA+WktLZrNaod//PuuTCzKgINZAcveYsDnxvfhR2qlv2BH5aZ1l8X81K9Ov7cTxY6soHeV5Q2J4J4SF6GD0A2vD627dZpLrBbXSGE4ckjof0ZayLhwDys3rdYVSMttsm2dwv8pyujA3o37e1VTI/I4oq2ZYJPW86LVZjKKfUXQyG0kbz2yVj1ZDSFMdLHi0wdPN6jGF7NospRAf4wTPUt7/05yRxgHBrjEjRG1W/YfBvlcOfrBU2hATKsOwL/oJ81iB+d0VzgPZkmxcK2TOQXcJAqtkSfIeTLzA1u5guokEd683jrKxQ2C+ojw8ZAciZKmAhA8PS8t1qH6SPZfnO2Pxc3YqRsIyz9mPOL/9A+nTy803WnVm+n8BLrnCmEq5ohyonx2/9t9vEblpfbNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(38100700002)(52116002)(5660300002)(8936002)(38350700002)(107886003)(2616005)(86362001)(6486002)(2906002)(66946007)(66556008)(66476007)(186003)(36756003)(316002)(8676002)(4326008)(54906003)(966005)(1076003)(508600001)(83380400001)(6506007)(44832011)(6512007)(6916009)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3RubGcwa0V6d1FNN2RsMENEUmo3YmUyd1BBOTI5Sm1QNUFUY0RLbEVEWWVH?=
 =?utf-8?B?S0lCMGJldXVUTTkyRU03dlFVTmVxS2IxT0R2WXRWOWNMSFBOYVdUSmwySjlP?=
 =?utf-8?B?eHZhczViNWVnMHlGbDJ1RVhGWCtVNVJHZFFROWRXcWhVclE3UENKVGhVSWRD?=
 =?utf-8?B?QnVtNjNiakU4dTlscWxxOVBuZTd6bUtqUVA5eUpxejkxUHAxdFZ5M3hSaXA1?=
 =?utf-8?B?emJ2cDJBRkcreFJZbmJTSDYwMGZPRndqcTVETk4zWGMydlhNZ0dML2g0cEI5?=
 =?utf-8?B?cXhFYnBzSkZvL3ZGT3FvQ2FjQU42UGlzVjdBQnQ3NE5vT2NYQjNDYnV2ZGxa?=
 =?utf-8?B?c3c4bzR2Nk94UlVHTEJvZ2JHK1JVYzljOVBja1hoSFhLejNHUW1Eejkvcml0?=
 =?utf-8?B?S2VtZnpxL1dGdERodEV3a3lhL2pDZEJoREtIYUNiMWFoTFZTMWo5VG9KakhY?=
 =?utf-8?B?TjJwTDdXVWhuMHRXeVRlemExb1JmMjF2V2ZoR2hkOUNjQ1NGVHdYUzE5UDh3?=
 =?utf-8?B?VkZBaTNHWGJGTWxVNWdBc2RDcWZYbVNYbXV2RFVWbktNbzVzQmgxUDNBS2cz?=
 =?utf-8?B?RFArNkFoM1l6VndZblc2YUp6SUZNU1lXcWVUaU1UT0pJbWh1RmlkdU53S25Z?=
 =?utf-8?B?dW15b3lJVGRSTUdqOXB5T1lrVzdHcW9QcWd6azNtbytIZXMyY0NiNXB6clNt?=
 =?utf-8?B?NUgrdnltcFBKdXVJWExGWGxaOE9sbTQxay9mS1ZBNTRGYW5wWWVDWE9kOE81?=
 =?utf-8?B?WmtkVUphL243QU9RNklNRVEzVGg4MGlwZmlTRUV5bHkvR3A2ODRKREpVdU0z?=
 =?utf-8?B?akI5M0o3eVptVWk5M1oxWkN0eTU2dkk2Zkx4NjR1bHExNW0yOUZtZ2sxMlpw?=
 =?utf-8?B?TVRKekNUUjhKSURkNE13N2gxaTNJSVEyUXk4bERLbXd2K3NmVnc0aE9ZdGtq?=
 =?utf-8?B?bGFvY0RmeENzdTZ6NG9uOVF3NUxnREJhaXdtYXNhTks1NzUrOVJ0L0lsSHQz?=
 =?utf-8?B?SG9RbmNkTi9pREtETFFUekdsN3ZEWnMvcGtzMWRKc1lnQTBFQVA5Uk9saHdD?=
 =?utf-8?B?bmd5eFllck1kNnhWOXI5MTgzdGpRenJjY28xcGtyS2xWZEdlQWlsUSsxRE9j?=
 =?utf-8?B?ejlRRm9ybmVLNEMwNzRtUWo4Uy9jeldxOWRnVlhCdGJnUE1TOUxMbmIzWUs0?=
 =?utf-8?B?RmQzUU5EYy82WnkrdGFyMG5rVzkxd1BQL3RqM1d3MDdPZE9YV2pidU9aelkz?=
 =?utf-8?B?UWtibGptNHFSN2IxZmFGaG1va1d4QUlKcTI4QVIxN2FQcXdIWS8xMkp4SUpK?=
 =?utf-8?B?Z3FtQVdsRzhSQWlpWS9MdFBQQjdncUUrK29oWEhtRjZ2OUhxKzQxd24zWDhM?=
 =?utf-8?B?aXNlQzBQQStuTWgyc1lIeUF1TURnSVlYZnJwM2Jvbm9Vc205Ui9GaUp3bWIv?=
 =?utf-8?B?ZmRFZElLcjBiMGFocmpaZnJwVU9VT0lLM2tPUWp6U3VjZXVNTURlSzNFdSti?=
 =?utf-8?B?WGhHRitZQ1VDKzVLS1JFeXN3K1dVY3JIM092OHNaNXUzYUhnQS9uT1RJb2Zk?=
 =?utf-8?B?SWFxU2JhSjV5QWMzWkM2Z2hMMGVFcGwyd2dId3ZoTklrU09LM2RPS2Z4VS95?=
 =?utf-8?B?RlFiRk1obDlib0UxR2Q4b0xMN3U3ZEttYjFBZ2xsVjAzVFBUN0p4T2laWVFi?=
 =?utf-8?B?SWJDcGdzdVV5RXM0RVUxOWFqbkVvMTFubVZ4MVJKYXFpOGtxanJWYVFsSDZL?=
 =?utf-8?B?L253cm9iM1ZEUGxnU3ZEekxENkxpUEtHUCsyWFRweElDWkh5TmFQWXo0N3hJ?=
 =?utf-8?B?YkhNUDdBR2RkZkJiMmlLZDdtWVdzSTAyZklLR0xsZi9ybVJFNmNPV3MzRnd2?=
 =?utf-8?B?dUhlK29HWCtpQklCMnRKMWhsNmtCYnprNEt3MzRleitxU1FtMmJoRitPV2FU?=
 =?utf-8?B?clg2V0VaMk9pQlJsNFpIRkVtNy82QUNxS0IzczRrYlpSWWhaM2NBREZ2dkIx?=
 =?utf-8?B?VUxLVnd0S2llYzlHZGh5OGpqMVlqNW5oekhsd0RtczJIcVJPOTRyUnZKMlBO?=
 =?utf-8?B?alV4aFlUWTFwSnNNVmdZRHZuOHkxaDlMV0hsWjVmV1c4Q2VRWTNvR0ZTTW1t?=
 =?utf-8?B?UDY3WHJhRjM3b3Y3L3FrRlF0a2pENmJNU08wY2RSQnVuUTRKM2JaZTNxY1NY?=
 =?utf-8?B?elhSL0V6ckhsZ2dWc3prYkR3TFQ4SHVIVFpHMmhFbGxpeUc4RExtRVgrSnVJ?=
 =?utf-8?B?TjFsdDI2M2xaaFZwekxmcUptdXRCQ1VoVXhMY3hxTjhGd1ZsZGhTK0hkL21q?=
 =?utf-8?B?SnB4MUhtRXFrNmJ5NS9zTDFVZDcyZ3ZvQkN0QXFYTHgrcFNMTTlQRDVOcG1q?=
 =?utf-8?Q?Nk3HvtOHuMYezKNo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d7a1d0-ad50-4983-573e-08da3cb417a2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 12:02:21.5891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pVNacn4vB4UyOtZGZ5t4HLbwt+iT7U1QwiW0CFz5jHE9nNZ0Z9TuJvKWWy/a3+jqGyvy6pUQ9tmNHWhnzagNRcBXD/i2Ioh9ibQPlP3XJk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5672
X-Proofpoint-GUID: 0tRxZzL0xMp_BCii8kfHqc_8exC7caFV
X-Proofpoint-ORIG-GUID: 0tRxZzL0xMp_BCii8kfHqc_8exC7caFV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_04,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230067
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 901c7280ca0d5e2b4a8929fbe0bfb007ac2a6544 upstream.

Halil Pasic points out [1] that the full revert of that commit (revert
in bddac7c1e02b), and that a partial revert that only reverts the
problematic case, but still keeps some of the cleanups is probably
better.  ￼

And that partial revert [2] had already been verified by Oleksandr
Natalenko to also fix the issue, I had just missed that in the long
discussion.

So let's reinstate the cleanups from commit aa6f8dcbab47 ("swiotlb:
rework "fix info leak with DMA_FROM_DEVICE""), and effectively only
revert the part that caused problems.

Link: https://lore.kernel.org/all/20220328013731.017ae3e3.pasic@linux.ibm.com/ [1]
Link: https://lore.kernel.org/all/20220324055732.GB12078@lst.de/ [2]
Link: https://lore.kernel.org/all/4386660.LvFx2qVVIh@natalenko.name/ [3]
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[OP: backport to 5.4: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
This is part of CVE-2022-0854 patchset:
[1] ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
[2] 901c7280ca0d ("Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""")

[1] is already present in 5.4-stable.
[2] is present in 5.17/5.16/5.15, but not in 5.10 and 5.4 branches;

 Documentation/DMA-attributes.txt | 10 ----------
 include/linux/dma-mapping.h      |  8 --------
 kernel/dma/swiotlb.c             | 13 ++++++++-----
 3 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 7193505a98ca..8f8d97f65d73 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -156,13 +156,3 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
-
-DMA_ATTR_PRIVILEGED
--------------------
-
-Some advanced peripherals such as remote processors and GPUs perform
-accesses to DMA buffers in both privileged "supervisor" and unprivileged
-"user" modes.  This attribute is used to indicate to the DMA-mapping
-subsystem that the buffer is fully accessible at the elevated privilege
-level (and ideally inaccessible or at least read-only at the
-lesser-privileged levels).
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index da90f20e11c1..4d450672b7d6 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -70,14 +70,6 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
-/*
- * This is a hint to the DMA-mapping subsystem that the device is expected
- * to overwrite the entire mapped size, thus the caller does not require any
- * of the previous buffer contents to be preserved. This allows
- * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
- */
-#define DMA_ATTR_OVERWRITE		(1UL << 10)
-
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index f17b771856d1..913cb71198af 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -571,11 +571,14 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	 */
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
-	    dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
-
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
-- 
2.36.1

