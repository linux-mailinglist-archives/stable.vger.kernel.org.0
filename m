Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039D45A4BC3
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiH2M13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiH2M0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:26:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BE8A2D85
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 05:10:40 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TAgb4H012990;
        Mon, 29 Aug 2022 04:51:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=C84JCWVIo4eL5UBTepJzEaP4NZxP0w3fPdhJBT6skdI=;
 b=QkWdAJXl9WAEGIf7QOUKwv6N4vdl95SSBylhWPtjNgj37EFkkO6M83fkTAIP0efcSBlD
 l3ixrDgVljgjG7H2d660Z3O5K7iGH13g2RcqrNzrBMmKvufwU5F2JjruqApjoaxh49dQ
 8eOlxCIxzYZJxdiydbbkTZkr2FxNp9OuXnRfesa4Ypvk2ulJ00dExQWV6vullmeF3wSF
 zlr/gC+XISoOFieVOwB6yvuNyilVKColqllTAWN5+vIUw41Zd4j+Tu4KUTmeFFfsZp8v
 dhCxSZhnOBiYqjoZ9vYJelFcFcnF5wIkNUY2H7Pmtc4iq1K74XUAXuk/C7rycgE/Bv+k +A== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3j7jsk9b85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 04:51:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6NiGDeDxjaTPc7oEs9FxArVXlnejKb6vyAjXHy6PrCTSbSN8T04IhdEp22+ijy7iTogCBQwS93g1KSoOq/BVeSgk1iij00w9reDxJMih2aWmwNE2N6h97sLu9+AhPEJocwgTAyV2mvpo3guGrwGjmC2ixIBVmkHNJuBo8tVZwnfIihAXUPMiTGw7Ho8tWEMdMky+r5DOLofrF7u26u8F4hOFbPQGXWkua6sHs1W8um5o1ssqRHWfqkECWdQoRCkRMDyS35yhDtef2DyWbf0wHwoJNGrSRDmDsXkrhWE9wNdCXTTpIg+rBuSes1DhskFxPUQcVshiEycbxbAP65Iog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C84JCWVIo4eL5UBTepJzEaP4NZxP0w3fPdhJBT6skdI=;
 b=b1QONnbtMFJuPFvOWEKkUdaCf3UJJ6FKVJYRKzOjLf8TyFQHRzYoUW3Ta5I2l2iTu7h2G1QIM7Z0f6QLlpQCZw3UdlPCRYQmxbmhmGR+7coOSCA2Mt4aiovgb9pegUWfitqiN1IxjMRoTagAUKMQO2vZlOe3YX5/+RxVHOGD5CujTrZDq3iWJgGwrpUZbRROPZYVXsEkckK8ACDLBlVXtujhVSZaiv/emXY+EVH1FhsyEMp5ueusNlMmt9FkCogvaQS8WxqGxxdeSebJu7F32wdzdcrcd1chLszQbrY3oFh2rSFkBfXRLR9f9Fgyws7324fszPECn6TM37ZHjbpcDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BL1PR11MB5366.namprd11.prod.outlook.com (2603:10b6:208:31c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 11:51:14 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%5]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 11:51:12 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     raajeshdasari@gmail.com, jean-philippe@linaro.org,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 0/2] bpf: fix test_verifier, test_align selftests
Date:   Mon, 29 Aug 2022 14:50:52 +0300
Message-Id: <20220829115054.1714528-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0025.eurprd02.prod.outlook.com
 (2603:10a6:803:14::38) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 429603eb-8e0e-4e2f-4ed1-08da89b4c55b
X-MS-TrafficTypeDiagnostic: BL1PR11MB5366:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yD/piANd4zfhrAAs+/zMpaFveDhha1b4Bad4NPNK9KZSovAlExfIdlGyxbRCXabDNA8nZEY/r4nhXiAeTRWjpLsJ139HywyaPfiPI5rbIAEUcVWucaWkHB2j8MMKKD2eGq1CnWBZ7LvoT9TkBiU4XcjHagQYrjQBWo0mZcl/u2TgOWa6GG4OkbivTFfX4h0RPeLXjR6xtNvjwn6UsDPPM2Ryvgz2D1dLq2lJ8HofcNimuBy7jlEnQB86z5s3xqeEiKtlFQa4R1wvTnyzFihEVyl6a1Hg5ruRC/f2EtPZjUADU46aV4WLxi/2Ul8e9lCy5kuWQEAtv+VTfBA4rpVC/3pfOWCPcAm4/ZdjMEtex6lyTQsZbfsyHHHlJq0W/XUscAq+406Aw3IwYjzX5Klb8R+SOsrX23GKpvTsiCTekddmpPtHm0a0wJynSC2U9vVDXTvFxUWf14AMsZOaK0/LJjx55nRY0tXmY8KFsjG5FgAeIvn8lfYEjBBXNy1kmvoD9H26cpCc4OuExMSyuxYPGdKW1VKsdnbnw3XxbSQkZZ5UPRjLsJ4RvEl+g7vK1WT4eI18CXuf5oxghtTaPhlerC7ZwlDGbIXNcORmdcuhoHuKREWUraGi4Y62tFeXnBjv8CQlet2zOeSrs+lt8OOCaeshkAAnsaF+IrxLzeJW93kF6mlgV6yFGvp2esesEGoeNDeKlb2SzaNlCL0SRZ4LhMwrBOc6H41Sz/I7pbYST5aAgA6w9ugqHTaVeOHA0BtFzbV6Evk3tXKHdrAGzoiG6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(366004)(346002)(396003)(376002)(66476007)(66946007)(66556008)(5660300002)(8936002)(8676002)(4326008)(1076003)(44832011)(2616005)(316002)(36756003)(2906002)(6916009)(6486002)(478600001)(107886003)(6666004)(41300700001)(6506007)(26005)(38350700002)(52116002)(86362001)(6512007)(83380400001)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O0UHNLAok+vtkn4jJDotiXz5O/okmMJBTihXOOCbQ2iJdy39JfmEYrXuan0D?=
 =?us-ascii?Q?m/aQ3i48CXOHJztcWuoTsIU3JenATPYGpotlHtrRri2iGzQGOkgFXD3o8TRX?=
 =?us-ascii?Q?CRVdRv3l23xhQ5uGLCQ8BjXQeIDsw2lRX9oIsGSyFe9Y6QEYsXd0iefHl8km?=
 =?us-ascii?Q?akvGFdi/TMFlF5NCMf74Ba8D8oMDZemvyuIkHKWIp9qm/xh8QIch8xTpXGVN?=
 =?us-ascii?Q?cabkCOVuQH1VXOwiNKJqVfFIOi2rHyXNsYQdHBUb4CNr1xjOvejeQFRQ9Y1m?=
 =?us-ascii?Q?szhzXy+2xhbzJ4Z2QMCoE1yq4uQQzPoxjp9rgPm23Mk1fLrDkN7RpT7iW3AY?=
 =?us-ascii?Q?HBqr7+AgEteGvQMaJGoT34w6HoOFQyZXbLYTnqeYSk3zqXKXJLhnit0Y/LCG?=
 =?us-ascii?Q?9OYxOAu4KexlT541Hk7H1PqgjrwfGs8DB3KFF0jmSAhDQwS+kJSUsNi8P7yZ?=
 =?us-ascii?Q?w9o2WLIMgFF43DZWCKk+wCp9X8zfejDOcLFljigLnBCj8AgzI5FSx68UK48s?=
 =?us-ascii?Q?ul/BU6vvBsCL6Ql4bJLkr1JUnIA/kExhnT3rHknS9gBcqO8J5q0eQfzINhHC?=
 =?us-ascii?Q?6C7S3v6pVODXRrs8VJlZsxDerdx00alVH4DZPaLLUGjyqF5zvQL6NlTEODlK?=
 =?us-ascii?Q?XaOZ7YcNo5DNDdlWf3okUagv/IDUDeSBp9m5WjUa7Wpbq9r0mVFlscAaiN2G?=
 =?us-ascii?Q?QWxs3Sx6nKO+74LPpqxJd9wWKwytCXN0mDodaxiu5HNh/EhFVt168LRw+4Bd?=
 =?us-ascii?Q?fwpdbfzCCVGaIWcnUQjBiCW9ONA1tjZzld3T/2ufeISkNhC4yqJCj+GBKODX?=
 =?us-ascii?Q?aEohkHwNpyhrJyTRQCtiuYGoH0HndROgvAiYPlXYn6h5q7MMMERgSdBkKhIN?=
 =?us-ascii?Q?vyZo/+UhqUrS6UKMqiwQKqCKaIO/PNUuGEyuuvCRNIJmstLtEttapEUCxhBK?=
 =?us-ascii?Q?RXOXPHs2Lxu3KJxV8Geiwei3lD9ObYL/7DQ68AOa36JmEsCRU1NGg7emdRVZ?=
 =?us-ascii?Q?E7hJh03IYPkSmZo8vzPyJ6an6xYVrYDJoXtLo9XhK29S0O2aXnBl1rWmA14u?=
 =?us-ascii?Q?Cq3fkP6iw26vV9clmBAPS6lituXV9UcHdLziq7bfL1mecjv3C7wfAPKnvpQV?=
 =?us-ascii?Q?Y9vXAIKjUQQuz4aEdDfClBQDlYyUQ4dgD2Ax8xA95a4hB83Gc/ataBmAMQUD?=
 =?us-ascii?Q?pnqbOAODBWqT5Sbwnj65oJJU06cxYc4qP92P9lpMDw9QFexZgNVd/yb4YuhN?=
 =?us-ascii?Q?a2JoofZswEDb1/LIUTVw2/FG+8KWZRehSJ3i+X827mz2Ty+INIGD+zlliGyt?=
 =?us-ascii?Q?xUpmrkOi1QIDQtgIjnKn62whwGawF7ZjxKn4P5Mp885o2wpl64i5KKJNFSv8?=
 =?us-ascii?Q?UMyCsfKfl7X3GtchUnqWDUBr5zXgEwhc79+EyojQYOSHGEpCktRTPXWVz4mW?=
 =?us-ascii?Q?tq4/TcojF4ueay8aYUmA02y5DfULiRnVjMI3vgu5NW2XCW6yOadBaLUZVqEb?=
 =?us-ascii?Q?1MfOloCt6jnnba9Oo4vj4MkLr8i2dP4A0RKRjOLh+zkUTQg+EjUsm+UDoA1n?=
 =?us-ascii?Q?l1cvFgv0PW0wWiw8J3YJtS1+kM/waYKQFSYuI2r6lZybGLf3ZSRtUX6Nodhl?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429603eb-8e0e-4e2f-4ed1-08da89b4c55b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:51:12.5653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ki2Ta04FTloIBNim6bHUapRtE/wiF63FVTVeIsdggoH8q9QYLdElR1wihtW6ZhMJrOxyQV9iA2gZWekYK/io8mzOvtQ8kUu9A5E9MIW4zbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5366
X-Proofpoint-GUID: AMNhm1BEoG8U_rVJ1xkGt6QQP9ROnQsy
X-Proofpoint-ORIG-GUID: AMNhm1BEoG8U_rVJ1xkGt6QQP9ROnQsy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 suspectscore=0 impostorscore=0 mlxlogscore=677
 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208290054
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport of upstream commits [1] and [2] to 4.19-stable broke test_verifier and
test_align bpf selftests.
[1] 2fa7d94afc1a ("bpf: Fix the off-by-two error in range markings")
[2] 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always call
                   update_reg_bounds()")

This series fixes all failing test_verifier/test_align testcases for 4.19:
root@intel-x86-64:~/bpf# ./test_verifier
...
#664/p mov64 src == dst OK
#665/p mov64 src != dst OK
#666/u calls: ctx read at start of subprog OK
#666/p calls: ctx read at start of subprog OK
Summary: 932 PASSED, 0 SKIPPED, 0 FAILED

root@intel-x86-64:~/bpf# ./test_align
Test   0: mov ... PASS
Test   1: shift ... PASS
Test   2: addsub ... PASS
Test   3: mul ... PASS
Test   4: unknown shift ... PASS
Test   5: unknown mul ... PASS
Test   6: packet const offset ... PASS
Test   7: packet variable offset ... PASS
Test   8: packet variable offset 2 ... PASS
Test   9: dubious pointer arithmetic ... PASS
Test  10: variable subtraction ... PASS
Test  11: pointer variable subtraction ... PASS
Results: 12 pass 0 fail


Maxim Mikityanskiy (1):
  bpf: Fix the off-by-two error in range markings

Stanislav Fomichev (1):
  selftests/bpf: Fix test_align verifier log patterns

 tools/testing/selftests/bpf/test_align.c    | 27 ++++++++---------
 tools/testing/selftests/bpf/test_verifier.c | 32 ++++++++++-----------
 2 files changed, 30 insertions(+), 29 deletions(-)

-- 
2.37.2

