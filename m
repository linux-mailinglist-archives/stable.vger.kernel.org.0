Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBB667F48A
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 05:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjA1ELL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 23:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjA1ELK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 23:11:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E817BE5E;
        Fri, 27 Jan 2023 20:11:07 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30S21O5g006430;
        Sat, 28 Jan 2023 04:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=xvVi/V3BGtmINs2CEacXkypkprOhK5dS1Ks2Hurve3w=;
 b=j5tGUKR/V4Oy9JjnI2iA6YNTSseVQ50cPTlMsOstvo4I0UvpfIs3/rqnJi3TXYknzB82
 /2Mh07sCkRURBYbLXC15aIquIBb8UbHDhneOTAI/N4WNsc/1cTh8iZfJkS5t3SU2ai3F
 9J9+mvNA7VGg4ZcweOBmz6Hv96cBd/x3w5c7hmB7l8JYUYHyun3bPmtf5jAGEMRJ0ep4
 W/VB8pdHc9i7RuGthrIiRyzN8Kxa8DLFtDZmHCUcVuQNlOrmmrjORCRIJ+T++KZfNrwI
 KzE80v3DNuuBJjbPfNXh+5FP54mScq5pn+rdkIGLNr4poMOAyMM5Y6WTK2Qtwuy8eBxk OQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nctg382kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30S1X8hY024860;
        Sat, 28 Jan 2023 04:10:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct52b2nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIDJrThpHozU97EO4T5osON18mBvGlVoKyVkXHwW6WxNqFfvmeJTzS9fXTb1+ihJEAoChDYjzP7502z3xVfBWHBYweRdiQ9fveNk4BMmuW73Y+w873R4xW9Y7gISAh6c7EBzX4XFczSbGhwZ0peTaZxKJg4rAeGW2WC21GebnV8fK7+u1TSc4UXRLYDp82uZsUbfOFqzjCwCYRfFBf+TI1tf/SGcrQJGAxi6FLN2X4IfHkS9qQWt4fFtD7DhUU6QFQpvDHqF/n6K1qRnKQ6txM/FZ9jtEiZL5buL7j2aoIpxxuZ+BL3uxjKam0WTUxw0y2834zgGCwViKE88y5Bt0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvVi/V3BGtmINs2CEacXkypkprOhK5dS1Ks2Hurve3w=;
 b=Jkut9PwULzMWwheY7w+oJuAmtkQIxlmcobNSCXtHJi8lQjGqrDoWD/trzvuZD4V5D9Q1XRLc0PsazuwFSbheZ/XIh6BWfOhO4tP1PpvkItNRA8c4c7dEJSs3A4BbbsxDzVklo/jdiRiztnPrHia63gnIBgMNzj1dn0UzWiIqVrYYnWOCmKhY/noGKdjRU2ZWm/U5DTP2IMhMxzBG/7bu1CbGNMnsta/wDvQqDr2FVpJK1qReYTZne5/KgZmv00buebUJOy1vKAjTJLqb6v0v36tTCVxX5OdBXVM2b99KPOWHCdWuzHsgyW5RkUI72zMeBRCTdP7/t2ygVuhQ2AbJuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvVi/V3BGtmINs2CEacXkypkprOhK5dS1Ks2Hurve3w=;
 b=HCYCkLHMRAuy1fl5EwxwLBFbPg/7K6jdlaPvr0DKQ9M7H6O9WfvE1AG2Q4bBKXN6V1jqZi5flBZhLIPgI1+kIdwMJbL3VZxzHJObnKR1S5xyuw06lq7YDiBC+4FeIVCpffrJSh21e5VuEm4ZQHBa1o6psvFq+45K/4uh7NK1QPk=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CY8PR10MB7124.namprd10.prod.outlook.com (2603:10b6:930:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 04:10:29 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Sat, 28 Jan 2023
 04:10:28 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 6.1 fix build id for arm64 0/5]
Date:   Fri, 27 Jan 2023 21:10:17 -0700
Message-Id: <cover.1674876902.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::23) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CY8PR10MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 147c67cb-d3f1-40b0-653f-08db00e596f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xdJDE0DBj0a/jrT1VdGyDSTUkt9mOqnZ1wNGRmc3OMLZevI3P5pldoeFpTgOxp+wxVGqXXq1rXrMRUNV3vlPG4zP4WuQOYLrp3sbHNGsJHNfk0ZSb/ABoN4/2pEfaHqukjoMekTBzNf8u96w3vFgYJJyv6slXGQevtTuJzr8PYJP0nJCljkmnlX8xJUgaPNm8a74f2E3vUVaAYm2YBz99h8xhC78JyZ7KmdmQHtBhkISeoMdizl9xR20sjCVCTEDx69e0kHhiH/RqVObFREtIJo0R+plRS97JINIOrtUe1UDFVFhHx+sbdUOGowUtpyZ5XqwxN3uvo09gcgvhI2uAWpKY1oJEwLxXKw6lCf2AtwX//xwTeVw1aq4xu73VUidg7NmKRzeh0DQTYCzzYTjvvnw39Prwti8I1K9tDYSBaa0Y3C8BcChTJWJkKyFjFEsoY2ief7UAZjK5bv9wuZOvrjeF7grxAJ7yzI46NW44vlNYcv0J+Rmo+f1FVhA3NjQsd9HZfdA92U3y92btkIJi5wH5kiPfljYjVW/TTMGGjRrnoflxMy58htuCVpqlLDU8UVceyFLki/nxk3N8LGyxNyVkIj1FYtPY4KCz/yrGxfzZP9VhnF0GdpQJpg+GFmTv3mvw3SeNuUnMZCphOnwhCGruWV7ZJ+rYiHG/OxfwgrxsiIqKk8NX0z8pp3E1BVFGEGl+D23nMzsBdKsZwyfz1aZLXPK/+fWrx+ju/rNPk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199018)(6666004)(186003)(8936002)(6512007)(6506007)(7416002)(54906003)(5660300002)(2906002)(36756003)(44832011)(86362001)(966005)(6486002)(478600001)(316002)(6916009)(8676002)(66556008)(66946007)(4326008)(66476007)(83380400001)(41300700001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SFITTVwYLwyMuZqP88PypuIrDT2dBjP9zOPBaoja2O3EIACeo/66rP5qTA7F?=
 =?us-ascii?Q?m5mjpFpNfsB60TvaL/vagG3hlXXzT6lzWV4r8irNjPHriD4T1vlcSuOXZVpl?=
 =?us-ascii?Q?9z/MS2eRHQzs1ZKP2KXJ39mbGD1tAmoB9CnHhB1j1hdpfPHKIimLBHChiSRX?=
 =?us-ascii?Q?ja8aj5xKuAXeBYigmINrlDuo8Csg6kt5PdegPNcowY9OHQACKxpIaaDZcCUD?=
 =?us-ascii?Q?6+m1MqQCCsDtwvoeMG2MVrzzxEDaGmkNgBPU50g4BnAvxk/uxZZm9sHX95fp?=
 =?us-ascii?Q?nHRL8Af3gtuHRTfCBYBEA1tAWh6jIy9C/V3JSXYOmDJUieA2jp6ZmusTQZr+?=
 =?us-ascii?Q?RCscc/KlOG9YEmpEUohG6hYSdDJjl4Fwbby8ABKkPw1GAdikrrsPRI/ZYMiH?=
 =?us-ascii?Q?yhc6NImojFeOl5mLQL79ToEb7P49Y6NPFx01y4mJecNjua7bTRx0nLSH2Qdq?=
 =?us-ascii?Q?0k59CmIpB705RwBkyjpRAENcLhGGzvVEsy0zfuolLtFMm2KmmVLOsbBRSvf0?=
 =?us-ascii?Q?ipl5lpEc9cnq47HJIvm+VPUEQQ18Ya0ZVfJvxJmsBwrE1W3DKxAvIl00+wTe?=
 =?us-ascii?Q?HGHCweiUgsU9rAHf47eJgzJKM8PZgebBFlj9SoE5/uslfTnaBupLOs6OmtW2?=
 =?us-ascii?Q?3mPrXSAtcj/QnPpOBt+dZxDf5DhZQTcpx/t+m0Sqx83HSMwUNbsmVjLQfgrG?=
 =?us-ascii?Q?3/G48NLh24RAucpC7/1g8WoxybgS4FbcqtqIF4bdYt9zJL/YyUurRZr4cljw?=
 =?us-ascii?Q?jCGgzXv2VQgO2mqRmaHGVbEN1U3fcH7cAuvznF+39r6q2huDozsYL5FfBNZr?=
 =?us-ascii?Q?DllMLR6nDLVw6rXAtKQqOWUgaPNmdslT/Mh0wi9GhWE3Ru7QGrdz+TZA8e3f?=
 =?us-ascii?Q?F6MviFbPpi0RohiqD1K4kUo8PYSNv35enz5V5rE0bispRk92Xl5Ki+krK5P5?=
 =?us-ascii?Q?vcgexypyE/qa78wB1rNnjgnt1QtKaPcdmU6N0XZAPLs7kQ7s7kcbmn/eFo+P?=
 =?us-ascii?Q?9drNK5rFmAEEI/phVbsxhY3hN5icG0n0kan8B87KQyD2cqZDY0lbVIip2nFD?=
 =?us-ascii?Q?mEuk04gx6jpWPwkiYiRvZVubT9WsQ/LhszYZpSAIZVS1YhIXlfAd+eVvow/o?=
 =?us-ascii?Q?W4hO8520rC9jDEp0wTzwsc6lyf1ACSA8eVcBVz3FaxrFK1jxQbKABkF9GFw0?=
 =?us-ascii?Q?RtGl2b1Kle56oilFPnt6s4IINmesjTzrGIkkdbwAjYHQ5a2kZwaHoEVjkjYl?=
 =?us-ascii?Q?pJxRyWuhLj8aRmrhgwOYZQV/hmf7cnJDurMhr31cGFjEgVMHCEPzapYikJyN?=
 =?us-ascii?Q?DqYUMFs4RnyO4nV7t26B7IAkRErBvwm760bK39318lnyS2McSeakPzQFxPH+?=
 =?us-ascii?Q?W0XC7wlcJ4Z5dd8CPIIsrFhJjKn/INqppmMcb+BSX47PuGzXNLOCxyLM1HBV?=
 =?us-ascii?Q?vCdxleqsuvYPFhsvgxD4YZkY/Z3NqCgiNjO4S2PtY0vZW+93PnCLUPzU2Fnx?=
 =?us-ascii?Q?bPQ7Havt9bIGxqJnvO5BV+OBnZT6N1HMrB2SFFZ6NAB+2YYpEIZnC/Ym8cqB?=
 =?us-ascii?Q?zGRbtTDvOV4UMPgKVDYITJc7NZd6ovkPKSYdoypMDQnqkoaoBtbJUX2Gt/gC?=
 =?us-ascii?Q?OPeggkqd53eEzgrnCxoioE0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?W3jJmNz9I6n0xk9NNmU6MexrUXHc8nAMfX6srLpSWFdpIu72l9Hha8fhbZt0?=
 =?us-ascii?Q?McCn5Akb4quHWbeq4X2CnKi2l+WgRteyAA2Py1jOD9dztQZVE17HwIqYis4q?=
 =?us-ascii?Q?Omi6jX5lGPuQKt50eAc8mbSf/zbEjahJ0C1TlFAS98w1oo7GImWTdOmuOVVS?=
 =?us-ascii?Q?6V+gQSZDh0mXrKLHTwgCQ6DVCDolv1akqR/+tRYGgkeHqRU6y5FWk1cPfsW+?=
 =?us-ascii?Q?uIRi3cZF1JMLy+p25/C2JUBbMn+ffExyupvSqyVrsaGFL59Rjt5jxfc6d6ul?=
 =?us-ascii?Q?HsHoK2vH8bKViXxezfJQntI7L+uiGpMNVKrHx/tYh05ERUDFdtzI6CFabvNF?=
 =?us-ascii?Q?G6NLNnlTjNiUNezqcPB1W4NC3lbm7y3gGdZqCbKdyYXVbeMk7Ze5Odprzii2?=
 =?us-ascii?Q?dqljXsF9fCStvo7AJxSG3wx4ZAMfslL10AQ/grFcRfjaHC79DeYg/seftb0W?=
 =?us-ascii?Q?st7YdkqnJzxM6gaTN9jOlcMS1dG71zD9LWZEJuzs6KKeAdQWvu+8zSfLFnlD?=
 =?us-ascii?Q?v3P87OtH7vRKLq/V+eT6SPeERCd0kpYm18ocry6Qe3MweFaoGPxNDS5QS3hX?=
 =?us-ascii?Q?X44pjcJp1wOcYmWsuLE/Q3tImr2PNeYf5/a8KiSueB9Xv2nJpZPypRvZhpka?=
 =?us-ascii?Q?WzUI2g0Q7ClFzTkAblAua2qUJyHfg3v6tYns2qmI7xAsWeEkI4RBED/oJZfQ?=
 =?us-ascii?Q?6tZLb7OAtogMfM6qNHxeb8flkGbzje+9W0fJ+Zj4breUSGBuwARgrMMZpSns?=
 =?us-ascii?Q?Oze+lL7pHE0KUtW2wcJypP0OkBVxdB75J6kt7DULBH0Sijmx4PZHcZ341O+D?=
 =?us-ascii?Q?N2m6CSlJNyo5xk1rD9iiRTzLYUMlt9XAKCaR56ETJIx3Xw2Jq5zfKGequZOS?=
 =?us-ascii?Q?RyYgDr6fftf+fkz3VQ5GIwn1sbfffMLYLJFosZTDrT6OHpl09pn6NWPygjVd?=
 =?us-ascii?Q?KFOjUsN2pGYsMeHGqdSRH+b253/G2w4tEZ4YN2QUmuHY4GeYPeWlmBRPkZNq?=
 =?us-ascii?Q?dDdRc1ulP0PBaCJSaXCNLowoEyggRBFwEQUUXdewH1EtLgJUWoLdGSvDVx/d?=
 =?us-ascii?Q?ooLeh0+34sQD/LTjvRUH0bw3NFx2+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147c67cb-d3f1-40b0-653f-08db00e596f4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 04:10:28.5354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LoNahF79GI5tLOcXfhWQIZb2mC8LEakpo/uYabcdo6+n/q+XudGCSW1RAd5U0LpM7rt5w10dxN9QsUhUZbW3sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_01,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=992 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301280039
X-Proofpoint-GUID: CRL1Ji3jd3iiLyr9od-8zEH1-zHU21QH
X-Proofpoint-ORIG-GUID: CRL1Ji3jd3iiLyr9od-8zEH1-zHU21QH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build ID on arm64 is broken if CONFIG_MODVERSIONS=y
on 5.4, 5.10, and 5.15

Greg mentioned to submit for _all_ branches here:
https://lore.kernel.org/all/Y9N9B5e7HZhFN7nl@kroah.com/
so here is 6.1's series.

This 6.1 series is not strictly necessary, as the problem
does not present itself in the current 6.1 stable kernels.

However, 6.1 would be broken with inclusion of either:
994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Should we just include these as well?

Both the above are listed as Fixes for:
[PATCH 6.1 fix build id for arm64 1/5] arch: fix broken BuildID for arm64 and riscv

Applying this series to 6.1 is probably best to remain consistent.

4.19 and 4.14 are not susceptible to the underlying quirk of
ld (at least in my study of the code to date).

I've build tested on {x86_64, arm64, riscv, powerpc, s390, sh}

Simple test case:
  $ readelf -n vmlinux | grep "Build ID"

*NOTE* to following is not in mainline, yet:
[PATCH 6.1 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
https://lore.kernel.org/all/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com/
But it is now queued in akpm's tree:
https://lore.kernel.org/all/20230127230702.81FA0C433D2@smtp.kernel.org/
Thank you Andrew!

Regards,
--Tom

Masahiro Yamada (2):
  arch: fix broken BuildID for arm64 and riscv
  s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman (2):
  powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
  powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Tom Saeger (1):
  sh: define RUNTIME_DISCARD_EXIT

 arch/powerpc/kernel/vmlinux.lds.S | 6 +++++-
 arch/s390/kernel/vmlinux.lds.S    | 2 ++
 arch/sh/kernel/vmlinux.lds.S      | 2 ++
 include/asm-generic/vmlinux.lds.h | 5 +++++
 4 files changed, 14 insertions(+), 1 deletion(-)


base-commit: 93f875a8526a291005e7f38478079526c843cbec
-- 
2.39.1

