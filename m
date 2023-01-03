Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C55465C69E
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjACSpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238574AbjACSpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:45:19 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09381056E;
        Tue,  3 Jan 2023 10:43:51 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303IJnNx015607;
        Tue, 3 Jan 2023 18:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=wje1NDMN8Sx/Z1AJQylCF5ecxLBPrRp3mjqNchoCiNg=;
 b=AfGP99MI2Qp74dzXSAGsWKWykcmWu/w7IWy8lAh34DTzbb02uKWrN5tU1uKZL4IqMx+S
 hndfgkMY4P9JmeyJoF8ng3UAC+UHC2mv3TYaTAs6Evjm/xNfyN1/PyKCuS1QF87vHKjt
 JB1dI7P3FnPHYB7WyOUISHPU+m2R7v2cy6rMPQOaW0+7z9KxevYwf3U+uFOdo3/MqK/O
 olDqBCKWCPwZfBoilf2k5wK2Yg1ulnqq6a91b+2p5RRjiCJ2nVj75XFqORUawGmmSn9s
 HeM3lNhAfgHVtpZfIY/s2dEnU+/PWwL46z3YEbFGk0xQV1FURfILMH/wOD2c7j1+KLfm 4g== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3mtaa2hvcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Jan 2023 18:43:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DO7IMeVBGhsCuUp4h3uAuBNUIxtWLg2H9+YJ+EKXAPkJAGuJAcFepeVOVTxShG1rbPGoVjGUTVbDHRFBKxP2UWvlqvwmIUXTE4K80ptXD7Iqr9SXHFup/WRuWa7J2kZeQ0Qn4ue103Uxs5LWM0ZYjXGtkjV9QhoyljsCHDtsPESMlPmMrdiXFadOVK+r550rsfCDyZrZV2GfuHB2YSJjoPmPqSO4nN0kxGNXO+9ctHznvVIjupQbmoBip6AvWhA8MJoufslGOZDPYzh6V/vKtfbrZ1I++KUXlpwGBO6qMG7KK8vv5VhP+h+VUL13ZOORvC/OH/q1PwROs3xY+EL+4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wje1NDMN8Sx/Z1AJQylCF5ecxLBPrRp3mjqNchoCiNg=;
 b=EE4JEAgcaQhVvKi2EDgLv89OvzrnmHCTIDWA15U6SeGXrPm2PNuIgb8qlZrIG5R+wL+Ee78QsAPeK7+6Ki8oYyF6KxMd58Y8CtUWgp30uuxOiMp5xi0/IOuS+rGxz34ADdvmLCIL2CSwdtWVA3Yt6dnbbaw8Sf2SLhKlQWyi5tz+MEoRHYrsI7shy9+1fp82PilC6g3h4kQT0jqvKi6FcG7xTviedPJoD7PKGFIZhWZMUq+tdR7NDRJ5oAW5VL3VgLZXN4meUds99XgPCeU4Zmz1qL/4WvRM4KZm4d3i0oVrW6Iqgi/nVsGBSkLxLhutoCopfi60ZeECpIEtGulPTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by DS0PR11MB6352.namprd11.prod.outlook.com (2603:10b6:8:cb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Tue, 3 Jan 2023 18:43:21 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380%7]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 18:43:21 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Zhou <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.19 0/1] drm/amdkfd: Check for null pointer after calling kmemdup
Date:   Tue,  3 Jan 2023 20:43:07 +0200
Message-Id: <20230103184308.511448-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0295.eurprd07.prod.outlook.com
 (2603:10a6:800:130::23) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|DS0PR11MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: 4977ca77-26e9-4baa-5a66-08daedba6332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MfHITHCNcv3szdo0C6yyd4OYlo7q/cgXZK8B+6IfeLMX5oXQ7R3c5r3HDDILL09QTW8354gJyACDb3mFwyjtR0ofrL+M3O9YqerRlcd4OUBrUPxXJnUCnSI7UbJIxMQtL61VjnJYeJTVsoBqdJXS6HKO2TlWDF/Z8faOtO+bcx/ojPZqJmPoWUZQ8rYfYQ2iXCKKIC7nRVu88JTE9qvE2dS8r1s93GvoBzvIismJar7h7ACRS52iVRd4OYWyqxwIAYgmGaBkPzXZJYrHCepmw/noI0eW3SF9ObYailZs7sJXHaxJ1pBloDmm3byfHNaCjBVaseTt4gD/gMFW3lH/G3xASM6jlrmrkm7GVXM633tN7ho9hiygjyqFiPGbEk/zQoD3iE0QPJbGQu7xuTYqrUlWkhPMO27Z6r2N+K/8C49invrZ12Spm0WYYysZv7/JsQUyxMU/NwDWUl3FpUR7q79wJMczEubVb9BCBDxesOiRfVwTZubm/Fhs7W2WsM4ljpKkP40oxxS+gOu7KDAQiUtzTzOluVaPna5bZmr4z4XzfO1eHNrh4+HpWYUNEMZ9hOz89E411K3NhhRSl1Xex6uNcfxz0iy15bhPWsk4XLNlQepjQWBAy6/vjloXuBQzkkPrfM4B+hxGsa+RLZX2ypsZEdmJRSpQ2G79UgH3Fk2uKogk2zXVA7IG+/0y0CnhaDWe1nMdZ9xjgGW+/Hxmnyg5souZCoTZFPSzzxzjeji5RXWLCkhG0ZWXuEp9CwdO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(39850400004)(396003)(376002)(451199015)(66556008)(66476007)(4326008)(66946007)(8676002)(7416002)(41300700001)(6916009)(54906003)(5660300002)(4744005)(8936002)(2906002)(316002)(36756003)(52116002)(6506007)(966005)(6666004)(478600001)(186003)(1076003)(26005)(2616005)(6512007)(6486002)(86362001)(38350700002)(38100700002)(22166006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nKd1S0KiDlo8/kVn4yPnvoMZqulzrrf5pWlgI2qWfqYB4777wObynx3fttV1?=
 =?us-ascii?Q?0PDhN8AnXem3NejUpaVZIlrOO6zCEQ5RkpzvGGgs47HtT1H+oZo7yICLw4hw?=
 =?us-ascii?Q?ioLqu8QYSjNah33IcF+e73SQwcNnvAi9B49n7l369YJNYkbptdhiKWgkKRZ8?=
 =?us-ascii?Q?tH5dy3plnbwEgMBHpF17SMP0cAMJVZAQkkMryy0FCMUSTI+MsKkdTnf4gdrN?=
 =?us-ascii?Q?lRnpGDQ3Ofn/NMwySGgvDeX4CKL+nC3VoyuRKBMAhuMD9IzZtwUdB5WOh1HK?=
 =?us-ascii?Q?BoLpWrhx3mnFxsds5H0Rtp9j/81OELsVXwvkGtGGVSNPakSd/5uZg/lfg+pB?=
 =?us-ascii?Q?QWrMykpRftt8r4tCB9KKfivfKKXzTJjDt9w5JWOhPgLUCh2b41wN258zWMD9?=
 =?us-ascii?Q?6iBSVyOhjiderAupG5uZ7XhjlbpzfMYsQJe6Hbxt7KjSKEDbJtYQLhWwL7WJ?=
 =?us-ascii?Q?6jfwqaQTnr/eoQArItPzuVFWyABs1GUsbqmAhr2x4fnKnstNj8jh9p8vOiYu?=
 =?us-ascii?Q?DGd5jy24YLmkjGTFVP33KcSdDUodFmu4fedfGy8elNQWJbzteOP7tIgyzt7y?=
 =?us-ascii?Q?1JhsC4zCXpCDG2MIHyT+jBnNlV0s/WkSxLpjta96/7E8/mboOyT185QlLGZh?=
 =?us-ascii?Q?syLzjlgAemO1ueOvXagW900beqRewzFBaXY78f4BGJTFrQvejp0TZO86F8Sa?=
 =?us-ascii?Q?abaZc5r+NZPa8R7dnjzgGpeQOQQDky0TGchcTWdR/KuDHtn2P+5m6k2YsloN?=
 =?us-ascii?Q?ZSxzb9f959dMRX900xUe1ri9Ojdp9bKf5kEe5crE2M2w0bjm4xpNTXjiEDL+?=
 =?us-ascii?Q?ocx3k/f+jzPeueC2ChAc5kAdbt1u7nq+EFjSXy9Biq4oWU6sLYtgWrgFOXul?=
 =?us-ascii?Q?I/pmFHSs+v1knZNienz8L394XR05DLPC3PuH8ev2zFcodx8fYzgBIlKx7nJW?=
 =?us-ascii?Q?erfYR3KzRinkNMigNumrB1x3dpwWEFkb6v7Bheqyaz9DvV7fXtg5RTf0hfIH?=
 =?us-ascii?Q?EZxeNxdBRK+fL7m6AcdtacFr4A0Yef+U7OkgzDo08Eq1RCQSUhQpuLQ3zYxB?=
 =?us-ascii?Q?l2UOM+EMw7JurWGjydiNLSMqZPk8SUILF8KKuReUT2vmkHXhH06/5rm68Z4M?=
 =?us-ascii?Q?YwrEDTOtUdkHmIRcXw9GfEi4LVk1kvFznLxX10iwdKxCGk5JitiHbOXoy49o?=
 =?us-ascii?Q?n99irwZSkDowFnyOmtv01Mw55Uc+2Zr5aupz+Pdl1dcnbhuv219oBavBu/Nr?=
 =?us-ascii?Q?CpRX1Q858Em+bJ/15H07CNW5vUI/UM/xtaD/luTDZC8m/RbqraqEoFkEXqHX?=
 =?us-ascii?Q?WC4buadvA4TvqKeoYCMXv3rc71/L3sPgj61F1WYXt9lOI5DLmH+tq0L9r5ac?=
 =?us-ascii?Q?NY+lfnheKCXgDXSVjjBcr/ginPpZz7ecg3w1bIY0LFGrFUUy3sK922ToODNN?=
 =?us-ascii?Q?Om0H1ozACML1WBQNYkfCcTdcrkhdCmCVCclnwZ7k/7nU6rXHz5ZEp5e36AUD?=
 =?us-ascii?Q?Z1TUhzQwfk5+2kTwY/RL5QRyNDL55taVVNoOdy+gS9WhE4GBhEZJiNe94nnW?=
 =?us-ascii?Q?9p2aGPQQ8CDnK4ZJ8396g04xU+NPLEq2rCU6tz1HPGrLX1an72xtXFb+0Q7f?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4977ca77-26e9-4baa-5a66-08daedba6332
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 18:43:21.3258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hdp3/BgSCU46wHsYzkoCqU7KvTNS36tDctrJv/hZ8wfpPTPwUcdngfeGExt+bHZr71eP+qy9hRAkQXefz01hA/WWFaBl+QDmOzPUEYT46EM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6352
X-Proofpoint-ORIG-GUID: 8XDpUqJ2ql_dbFkTcJSd-373clOiJ--n
X-Proofpoint-GUID: 8XDpUqJ2ql_dbFkTcJSd-373clOiJ--n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_07,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 phishscore=0 mlxlogscore=643 impostorscore=0 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301030160
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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


base-commit: c652c812211c7a427d16be1d3f904eb02eb4265f
-- 
2.38.1

