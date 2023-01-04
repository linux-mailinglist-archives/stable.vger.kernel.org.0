Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5C565DB90
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 18:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbjADRwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 12:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbjADRwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 12:52:45 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFD33AA87;
        Wed,  4 Jan 2023 09:52:40 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304DfW1Q015774;
        Wed, 4 Jan 2023 09:52:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=x+JyT3I+9BdQfDpmrYqtQhZhDBNailMtbw5VqSSjzkQ=;
 b=Lrom+vUohHGlhR/ZU3JP/QhF4cvhiueJgjsgilCdqJUBgIthHwCBhtETj/CvD9KvU3DT
 uC30nacSrLRgEH1b4SLdj69wH5vC137HNTlW3vesDZBgn8stvxSkzXB6+krP0wOIcHj3
 KQn2uIJKAev126B4r+o/ENm4AjGxU1gxGLezBAUEgKUevjuvGpKsor9AHFVoVL8eV0dH
 OsXzcmcKrB9jiO+P4ybEvnqTh0y6mq4psS8u5H9LF/vRgn7Pki9Kb5i03w0poMoLuAMj
 3Kr/CVENMCeCkqf1AsL1hnRG2jZve3SRhldgQ88y65sW7W+31d6ln+wWH6ddtiaBWVkg mQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3mtnfrtfcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 09:52:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRZdhLCJNxDuTsYDZKiN8QwYqPgx8zTPTVeu5OYr7Jc5w5WrNTxVqQoTdVXlFAgoGwH/tV+yKjEg83QBoWon2KrzPUBtGYRMCxMIttRvYrUd62GRFOdabplqfRu4m6j/HcQ3NrMOTCbJcvyBY6rUMdfAiYth2DyAm5Bt3+x88cq4MkVhFdqquA070In74WkoggjzxrFqyrlDJtGLa6tgbOsbSzu/rL4B0dy3y9wB/0WykjtnEoEVSTK0cBWKLTpy6XvfxoSem2/kpwDl14B+W/IQY+I8owdvBpaKeOcnYdchhYipceyXxoxmqzzgzHTSvum9igcr1/ORW/lHHTEQaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+JyT3I+9BdQfDpmrYqtQhZhDBNailMtbw5VqSSjzkQ=;
 b=WsbBpOR3M6wGA+UD8RlpnSR828t/ViCi0mN7Ye1Fl+ErPj5JPcuBZtOgGNhx1i7fi/E/xN5hrWoMYO0CgNRsCQ9oQKBJzWY8V3jHHnM4aSXGwfCm1Gx33uRCQXCz/QW2LqEnf6qrKQ7IIcf9E4jevx5keVaRcefsD2QbJYhzO97CIHWKuXn0CSBK/nFMxZwqew2K3V5uaoNgAw/x60KKwbdLug39sXF8F67M6DqZnlFMe7MQ2yTs0VOOW83U+6j6AXPy5HSloAujMFfCL4hzCX4mgBYuUpQrZ5yaMJVGuofaETqcmwKaahT0RzaoUNE3r3gCyFVMMxKLhI7PQXLIEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by IA1PR11MB8223.namprd11.prod.outlook.com (2603:10b6:208:450::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 17:52:10 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380%7]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 17:52:10 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        Ben Goz <ben.goz@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 0/1] drm/amdkfd: Check for null pointer after calling kmemdup
Date:   Wed,  4 Jan 2023 19:51:54 +0200
Message-Id: <20230104175155.1415258-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0133.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::17) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|IA1PR11MB8223:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b7e77a-75a3-438c-c073-08daee7c66cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4kBWxrLMuLh9AwGdtMvJdqY2a0OcFC35xQLRfeWynb4eJ15n++i050hGBJy4BHqbhDY14FrCkqtKcW6TkDS/zKEMzGhodUDz+aJkTJ6GkPMHxz4WqIeWcmgfA+vDdLFuDNIaf/KY9xDvAbk8ll4UBW6te9Dd89oudF43pkV5hP0iNq+nTOzEoE4Z7ze2r0ToJWTnVir/LLzs6p0gTtq9CHzFaaWb256fQ4eu/fQd6Fh5P5osK665YzuR4WZxjODDogatICp+zqwjvQJytjYaBChxtBN9XH4YsgT5Gbnmc7Sa8DH3kxx2EGKUgrp7IMJyovdQgzAkwOhusVmLFRO1iMKzzq+7l5Uzw4cO6Mpn2bXRZwZ/+h8J/Uw7DrCCrPgYZTA1JIRlMJlhh7VfGEmx/CcUCf2ukl1w34uU827X430nNgbZdG096kNiVAWtQs2SsVYG9vyEmhuU7hJhz1Jc4Ml1Kt8nJuSV/cvydY5ANwXhZKyEcLyEbw4ijX8DYHOsVxW+kq+qMkIXov/32TcQgzAhVLE6y2CGPR9xmP0SZ9n1D+s+wuiwhK33JAUI5kR4mAPbfNj4Td/8jC1DQ2emyVGpOjm25lzl8P9s52074OJQrPLEtZFbVxCqVL3KuXtbVyFqQSQbga0llHQcolcrkHiBl1Y/+Hd+5Df9XHDBh77MkzKn9vstJuoRV3ycY4eJt1QhmkC1Xj4ciBOfAPVWy5yN9FfIK368fDK2U+TRbH0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(366004)(39850400004)(451199015)(38100700002)(38350700002)(36756003)(86362001)(1076003)(66556008)(6916009)(6666004)(6506007)(2616005)(66476007)(478600001)(6512007)(6486002)(186003)(26005)(966005)(316002)(52116002)(54906003)(8676002)(2906002)(66946007)(41300700001)(4326008)(8936002)(4744005)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aRtVUG0ReUpOsxrI+encK+KhgJudJlICUQAAzg7jqUiKySb7qq431edBFxoH?=
 =?us-ascii?Q?QGCjO5lf74RHsLHgm1Ggu5E7extcy3/yQzU0hI4cj2OZAufpV+dFuRXG1Aa/?=
 =?us-ascii?Q?3gv/qpdaw4FoZV5WHj7j9SQW6enIEakLoHsOkOEKmMB/ceaLFOoPe6fM0xFx?=
 =?us-ascii?Q?UdypeQvK+mNef7dvLAoUZI+WTpG4QUCL+8OgoawT8TsYjy0J7iORT7uZDGBx?=
 =?us-ascii?Q?jQzUbnP6etMGwboWcFTJGrM4gthlICh2a0htL7Itt26iwL47OX9vI+y+G1jz?=
 =?us-ascii?Q?df2k+lShkhffbFRGioaCHH7mvpeM2wnRsVy0nKjG+CTWBR10THK23jTdVQIq?=
 =?us-ascii?Q?7RoKRbP1gQYgS3tmkfBaTj5Q4rxewcPzwzu4cbOJOcs3Dr9v233SP1iHAZ2t?=
 =?us-ascii?Q?91oDH9DIbodLnesfcDiqGBFNiKSDUSR6HPuqIbK5MKSJiH18ksIcCu05wJpn?=
 =?us-ascii?Q?JEnw9UlEHZhD7Pvq6OXYNPX7A+vNXUv/WjwU7HaGqOEe+PSQ4eSuj5ojrw91?=
 =?us-ascii?Q?by1EVLjsQUDKi1qbK9QkvxdhM5W8+KWINMp2T4doIZw+7qMHUX1IsL/XzBlr?=
 =?us-ascii?Q?++J4R4Hx2GhJvoWCZlcBIA6TPZeQClbaeloaLIBCcNpg8gYl/3mJpwgDtfbS?=
 =?us-ascii?Q?80K+86vSqPJMhtctYa9iRX5OffRoks2Ts6HZKzO/Lj3qIE3YMDyJqH0tc4gS?=
 =?us-ascii?Q?t/y2S8w/ywX2fDoj8nYAFVGUuhDwNujavOiUKm1wWoIObPAtbvso1BmL2Wgu?=
 =?us-ascii?Q?S6NdESZg22c/0XIETB6R0WwhDkDpJsi/KMoezLArkQTWeCSZ+JkHkbecKtd+?=
 =?us-ascii?Q?r6KZlwovFezsO+E8U4NSr06DLX5hcItjS2y/k/UVfQuhHauhXF6DK//u27EO?=
 =?us-ascii?Q?ZUAIDMIABgONQWnBrsEs2s69j4M0dtWciIk6rkjn3hQe+67exGkeLKtKwjXT?=
 =?us-ascii?Q?3YaG1K3Ws+ZhIvGwUH9VKDRrx6CS9iAsxwrBZ4/aeBewlpHPINs70XG1N7cX?=
 =?us-ascii?Q?47RylgnYeZb3IZgEr+Y1e3iCGtVDpX/cNWKeBYP6sKASc5LkhREr/c6tzmWx?=
 =?us-ascii?Q?wPsZYDw8lwUkcAguHaCWImN3u2xp0b9uykwKSCGImF3EsR6YV5nK0ftxzMWW?=
 =?us-ascii?Q?RbTgS+JeFgpR1GtccWDNlmbLcf3Rheel8TqO/KrG42ODeYcz/Du3OxB0dFSR?=
 =?us-ascii?Q?BrlmW7nMGCKvsA61OjScHA/HOwrZ9kU+ZXwipz/UB5k+wJAwMLP9PKFz5tpe?=
 =?us-ascii?Q?gzZOAJ3oakrhFe9QaftAVth73MDNPvuod3955KQWl3H/VnNIuPgK9h0T11HQ?=
 =?us-ascii?Q?VKi0Mxa3h8AscwRU86hFqxEAq7R7GlstNKGU5LnsehiV0BFw4cs2UHhQyDJ1?=
 =?us-ascii?Q?xoBIrDZdiQFrQxpprSIesWlmzhuPz6VAMh25ZJQ7O4aLM7/C1eoR6OGcy4la?=
 =?us-ascii?Q?scx46xnIjn3IOvkuKDGv4BkxC2IB563WUEyeBNArOzaimoWCSEVQFGA9ocp+?=
 =?us-ascii?Q?/rK3kDzIFwGOmrKGip6t5AcoVLsL+05qyufHGEp36qMLahpwQ1HNVxCoH06f?=
 =?us-ascii?Q?WO5FGRZvQAli00piBcqlZuuN/lPP0FqjEQa6YuGPjWZtezXET61PoJeV7nKH?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b7e77a-75a3-438c-c073-08daee7c66cd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 17:52:09.8680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5NQAmErZipnzt+rUk/d/kalsu/OcKqq9PyaVdgL++s1kRwORdebeRF9oB6BNGOnJoyCHjgdIT6USAdm0Db9q5bJ7x/x31g/lBDeUuccjeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8223
X-Proofpoint-ORIG-GUID: a5MHEW1ZkSyxHzaRdrKzPZFyiXR4WXW5
X-Proofpoint-GUID: a5MHEW1ZkSyxHzaRdrKzPZFyiXR4WXW5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=643
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1011 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301040149
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit is needed to fix CVE-2022-3108:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=abfaf0eee97925905e742aa3b0b72e04a918fa9e

Jiasheng Jiang (1):
  drm/amdkfd: Check for null pointer after calling kmemdup

 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
 1 file changed, 3 insertions(+)


base-commit: 851c2b5fb7936d54e1147f76f88e2675f9f82b52
-- 
2.38.1

