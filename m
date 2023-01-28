Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80567F490
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 05:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbjA1ELO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 23:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjA1ELN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 23:11:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127C97BE5E;
        Fri, 27 Jan 2023 20:11:12 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30S2sdpk026779;
        Sat, 28 Jan 2023 04:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vKB4CJNJx9rwiAfEtIpX8Saj+gc4wZsUrC4a0Kg3MCI=;
 b=Qn0JhDOUEkLN50Siv4XL7cza0CHN4DAEYlEzW5MOItF8QzdBiPIIXAzmT5j+ZlnJh8/k
 4ww9OXGMQICZUUAjEd4c9W5F7zFOmcJLlAMX9OmrtlSODwFaqGMPgp9x7mWzxbMTBBo+
 K0yCowrF4rJhzX+BDgv+b8aYhFoldLQ4YfM4vwzj5MIzkhpX+NxGWpfJ+qkFO0cR//Ue
 kBa1Ypi8SxErCVKnPy2i67DznpwaY2TM3Y6ZDBEi8WcdoeqH/lgo/lUgdBqo/xZ58xLO
 3pQ5l37cGHgOsx/i/gAh4YajFVkmpA8aG5WlpixYuXwnsoXFSMetuZUXY93wbLlXfSlF Yw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncuat81h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30S1XEm7019074;
        Sat, 28 Jan 2023 04:10:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct52b27x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INA2CJE6S24URYLUXUZGo1qZvTlQpor5wweL6Uk8Urj8MXSBG9gej9/7c1C9XgtFQqf/dmEzEhmBNCfNHg2fr56xfYzfogp2gWddcnIt2toL/nreUbljFLs/IFVs1RM5ohLjU3XlWJvxaY0NtydbWSoP6q00RAM7nLFJHrDeOrxlMpJZEklIaaDO8cQeGSMj8EQEbWiI+fI0eL20xxLbjqPKE8aeS8lGbpHDKqhAHFrtTUAKSgueifftEDI52pSI8YXaweGuMlmoXkDy8+kZLBqa29w5qUCdYDkLfI8xDrm+HoVJtLXknlxg25pC6XTAe8BFGugQaW2IyrD9sJ3rPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKB4CJNJx9rwiAfEtIpX8Saj+gc4wZsUrC4a0Kg3MCI=;
 b=kaNeHz38hdqeQ2OpKURXtDwM6uNVn+V+CC+mK9taEU+d53J9XorWcooOvFKmCDtunyRdp+JL4YGOo7LN/seOIJhF4ZjWuJB5quYoY61IB2QX3sTLUlmj4YKREJS1SCjTEFu/xXbgp7sMxuYXxML/emsegnnbRONbY0uraz+zQQxOdEcBfLW0PK2Dv3OWg9YcjU1r0Ej0xLr337jP5hKLcfWMwlsWKcvnKHdcLRSS8OP4zUFhkr9NBAHGAgv86q03mNlmSHzk5RHFSNbMdZYZNLHka/iq3QVnHcS5KSm4b6cUsEkClfwmEeJ+2sNVQJSaxw6jvKj16jLpNROyKN1ORQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKB4CJNJx9rwiAfEtIpX8Saj+gc4wZsUrC4a0Kg3MCI=;
 b=agCl7/aI2rsovvbn4Beong+NuGcWnKEEnJQ736bl6A2a2kVXu/v5Cji8azDkutUm0bvEAXw6cVVdLbvQLWjZxLT5+nawS3mZ/wV3gXL2/qGL2RN98SszO/f01xWFwG94T9h8NE5fxFkFzEgzY8CQjrUsZeddKKA2Qclfdjz4J+M=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CY8PR10MB7124.namprd10.prod.outlook.com (2603:10b6:930:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 04:10:35 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Sat, 28 Jan 2023
 04:10:34 +0000
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
Subject: [PATCH 6.1 fix build id for arm64 2/5] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Fri, 27 Jan 2023 21:10:19 -0700
Message-Id: <f4a3342159c5ddaba69e4ecfd5e997174b6e015c.1674876902.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674876902.git.tom.saeger@oracle.com>
References: <cover.1674876902.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::21) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CY8PR10MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 720f5e1a-ef8c-4a5b-b041-08db00e59abe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SH91w9YfQsYTPmPpEX6COEFCrEUFDsLvPmQH3mMbv3C/kBMvbhoars7Jr5us9F3ikkWCvu4gPcM+E6YCzsW32lXAFhD5jzsykJvVYI21mAE77ayFtKClCC/R/ty6PLjORIhgBTyHwl5soG+GORDOn2m5o8fFK/QEwy4eG2fmm75j3JPUxwVecFfmtn9aKG/Y0as5J9Cvlz1ANrON9/qb/8yQT/P+NYetoI0Gx+pFafyO3DpTo+v2J5/YbFRmnyaRVeEytzVMxExL7s1mbtR6PXuscs5zuFchUYGovr7ob3fHarwH5xync4Lxli7mUynT2M+4g+3L+8HZHJm5ookeVde9OOjvJIiqKBQBp7Cce+ZGbIG01Bdkxh5JVW7/blORZvY4TPsJsrBTH8cg7MHjzeBkTTqfqIxTZzrP4StyvT7UIq96rBGojig8FOsnm+7f48+/WkmuGoILSG3daUhHk85CWJUT7PABYo53T6awClq/3ZwwISd6uL8PlTjZc8myrUUubvfg7JFV5Uv2ySim7wi922Y5PnexSw41qVjL58IMRDsMz+a0egkw8Cp0n7zbJqKiF1I3FtCFPHOHVYC06ULruevlVzk0yvVTn1zXe/1ZAD6LE/TuCmvx20HvJA1UaWeQIBoT7FvyJsQILmk+obqb6oyN/lYjMg34y4VB5aatpyLmPso+PwHUbSxsBgmAEXkCrD5dU5j9xhqToyW5Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199018)(6666004)(186003)(8936002)(6512007)(6506007)(7416002)(54906003)(5660300002)(2906002)(36756003)(44832011)(86362001)(966005)(6486002)(478600001)(316002)(6916009)(8676002)(66556008)(66946007)(4326008)(66476007)(41300700001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NltXa6NkSVp635s5CjXotGn87bh1MeeTLo1qSKKPAMcFzdrEI5H0XocXuFnd?=
 =?us-ascii?Q?SkvvJO6fM732hVB4lQtbOIedMkiXRJx+XSqjho6PfkuIJr33m7f32D6vjofS?=
 =?us-ascii?Q?Bef4Vjsh1vlnaLRKmxWHAxGVRkZRxBgYnUX0Dhc2+psjmjMWGOApZMIMRplG?=
 =?us-ascii?Q?n32YzYkWn3FWQjgO0YKKRuxQfC5HieLuxCPn+lvyUBgdvdK6WSb6ps9gEDec?=
 =?us-ascii?Q?6HrFSF+IMtkoK8n2TKTT+SsSSzVN2T2Q7PuAZbX5RewrwU3XQ7+bw0zmx+i6?=
 =?us-ascii?Q?AyDgp0otuo+8IhfoMKWVOjcdK1JBo51tK7+iwI64wt/s7/HXjnOj0U58MHf5?=
 =?us-ascii?Q?Zh676ox0BqCG/z3SjTS4alvOqGWclJmcoyyypMdalPhweW/VuWj6sfEkxQbL?=
 =?us-ascii?Q?vI6M5hUmfWZFTzSWP8IKja9OBJNVMfGBav+RFi6pYnBAvFqlI9DURTaXcm4d?=
 =?us-ascii?Q?cxqcOAkwtLZH2GZ6eAuTZA7WWBV7EZ9bfaxpqt13sZr9ugzJYy0wA09SUMLU?=
 =?us-ascii?Q?DsovWXvY0xHkxtoOyz8+eqE001q7fRJgBNV9eH+lVNEz0ersCn020SYzCarl?=
 =?us-ascii?Q?YnEMvpUwAYo4OFy1t/F71F3biKf0SNhV/TXPkiq6GcXvg9AEg9hexEDadHSd?=
 =?us-ascii?Q?ssrD3SnNMsG+64LSms7Gm10EB8urc4RhotDAzmUL8nLsTnLnVZQLkvzpepKc?=
 =?us-ascii?Q?/PIJ+9KrnqapoaKyki4clP//6QeG37Nmn5e1WQ0e4oazE3Dnij+wn8ovuPH6?=
 =?us-ascii?Q?/MUBytVXkqhiAWKz/zpTN4jpnm6wSIEZfr3P01Sbxt56wEQAexaieEB+juJI?=
 =?us-ascii?Q?daoZnwWC99lcvX7WbX8Q6XF/q9xhZfyy/Zk0S8W8DRc9+zNNvjqy2W1wnfNr?=
 =?us-ascii?Q?CutNZxv6DezITyFsm3MxTWI8LsJia7X35bJI1xMOotji/tDaJVgJ/goUw3ZJ?=
 =?us-ascii?Q?v19//kBWCA/kxbNQkKOVppiou7ZEqn5ECehJDJKa4VvZBU8PshSdUkZOp54z?=
 =?us-ascii?Q?/nh0tLZYL58Vv3YuEUpZpEAj7a7dVhvNa3fcBhwMGLDi/u7go2yVFbzOSmbk?=
 =?us-ascii?Q?3UX76tYE1PLeGUQIdVONhtvo000Oh6YgraHs5j6+bTiEdzkUFw0/muObnBoq?=
 =?us-ascii?Q?axWDHgCPYXI5xF0hmEcExNCcXBCqKbVLHQysHSfN8IW7B7BhNso8oemwAv80?=
 =?us-ascii?Q?tXb8O/nHAG0X6SzL6O16NJD4IRzimxoCnj24q0ibLFjTQD+Il3BQd506x8jl?=
 =?us-ascii?Q?dxmQYc47BtVKduVxef4GBH5l4vvVL3BnO5armLyjsqy7Wo2QcPdssGJvCWKT?=
 =?us-ascii?Q?g4aRbHuNtESmNs/SBLNqlMjU1YtRfJTwmEuAHiGmsNA3+oW/uQpO7KKW8sb0?=
 =?us-ascii?Q?O8fJ5wL+6QJk3AFapbJI4HFmApZ6IgV2CMsf9hWjD/haK52iSNwQLrT48T5i?=
 =?us-ascii?Q?+fZvAjVIwCm2JIH83WeFBPI5cAijMmK8cJbcdoX0qvGarq9FIJEd6XEc+FnZ?=
 =?us-ascii?Q?OHFRG+0lYX/LG/RtjlkOHRYKxXPsPeJ5mH9Zs4tlJFFNmfO8KFDHnD8wWr37?=
 =?us-ascii?Q?IAhFzPNTCwIAHgpw9PRK3S1LLLKpe1BaiS1p620yglEVTC6dpLYySW6SzgXR?=
 =?us-ascii?Q?cwTQlMuGrPhI5hy+tOO71sw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?CJfFOmVEiFDx5BrGEqaJjra3Oi/US3GeEaRoNXP7jTwQW96CrpCR+YXG8Bag?=
 =?us-ascii?Q?+I7w+cvFoG1AokljLcN/3IFCjRvXjdmG/MEI3ZRVbGil1HmcjI2j5jIGQVbM?=
 =?us-ascii?Q?lt5ofSs/727DhbG84wvnH8T3uUiy9s8w297c/T69U4uKZmiXNjgZh28Tj31h?=
 =?us-ascii?Q?LvHMf6DZP8+lHi/+MiYd9PmiL0613zjOQYxa+eo0bM3H+OWwIRHTu6FaLs7C?=
 =?us-ascii?Q?TN4dGTPqLPzgNXY0KqyojFZkwPaIYy+a2G0joIjwQgVo/GcXC5sEPvD2t8iu?=
 =?us-ascii?Q?+ZWndIgUqmJ5u4AydiCnW20eQVatnrrNoHHHzmZW7FDGyT13GQKTN6kF8l4U?=
 =?us-ascii?Q?7x24RRS4RDPqFYDMkTW2vkE7UE4V+UspN5Bg27e2rNGXQ4Uy+eLLTiOkcvmc?=
 =?us-ascii?Q?62dmABvcENdaxaZIJYyVmAD4NflmHmd41ZqHFB31Ji7QCRURC7Hq4DoA0SMA?=
 =?us-ascii?Q?NER0k+6xC3r5DcP+R8gPl2Cn7RGuoAwLbitNn1Z3xI+4tbL06HRP/q/uIlDh?=
 =?us-ascii?Q?mM5KEkW4L+r1u8qDjuVX438qDaEkZ8ggPdhVP2WX2l/X3hl/muWged21ultH?=
 =?us-ascii?Q?20U9VAv6G1KFc8m0UWdamAO896SAQPORlyyggqsXXmnOlBN2B6ndpA/LAzTs?=
 =?us-ascii?Q?uFE8Il68d4306EH5G/Ks2SP8437rj4m2TkUl48ZVb/lQRKNgA+WauBvw02ha?=
 =?us-ascii?Q?RnZWlJv1A1LGZjLwOs1BKKiZ5o1Bzg4zzwBwDcIn8scshRwwyoALB/Ue6899?=
 =?us-ascii?Q?aVWbk1oS65G0TCIuHDg+7aM5gymL/xjnUzCmf2+4NgHcmbfdTmo8I/0eTi5S?=
 =?us-ascii?Q?mp805dpa7aF51YeDFXsoc9ezD+EIKG+SNOU7k/h0HYfbgjtX/7HO6E6URnUH?=
 =?us-ascii?Q?NQ4wGd7T6FSy5GREMfC8W3PiExYohagb/KYd8poDOQQ09U4JpPlDXl9mdGJm?=
 =?us-ascii?Q?NZc+zwRdsn1kgwoIbjpRcIv6ui2F6cTDmqOuuqikCRVaNkTihuXTVfFONirq?=
 =?us-ascii?Q?H6Zyx7Dbm4yJiKdVw5S+FF6+2AdTIvMtSj8kp6JhbTwlGObmDel3mTnhkhDr?=
 =?us-ascii?Q?hKc09eaP7ur3rBqfZB7FXBy+lPaE0A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 720f5e1a-ef8c-4a5b-b041-08db00e59abe
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 04:10:34.8474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2AT38PMGXrB3iL2AAcYT4/Z0BdxRtriiKRt1EJYgJdwlViBe3qleyiTRcEDTBMZkqdYuy9YIuzngkRP5oCp5ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_01,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301280039
X-Proofpoint-ORIG-GUID: QbYqKjwBleZwFRpnw8YvU0sy3JnAtuIM
X-Proofpoint-GUID: QbYqKjwBleZwFRpnw8YvU0sy3JnAtuIM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 4b9880dbf3bdba3a7c56445137c3d0e30aaa0a40 upstream.

The powerpc linker script explicitly includes .exit.text, because
otherwise the link fails due to references from __bug_table and
__ex_table. The code is freed (discarded) at runtime along with
.init.text and data.

That has worked in the past despite powerpc not defining
RUNTIME_DISCARD_EXIT because DISCARDS appears late in the powerpc linker
script (line 410), and the explicit inclusion of .exit.text
earlier (line 280) supersedes the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 136). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier [1], causing
.exit.text to actually be discarded at link time, leading to build
errors:

  '.exit.text' referenced in section '__bug_table' of crypto/algboss.o: defined in
  discarded section '.exit.text' of crypto/algboss.o
  '.exit.text' referenced in section '__ex_table' of drivers/nvdimm/core.o: defined in
  discarded section '.exit.text' of drivers/nvdimm/core.o

Fix it by defining RUNTIME_DISCARD_EXIT, which causes the generic
DISCARDS macro to not include .exit.text at all.

1: https://lore.kernel.org/lkml/87fscp2v7k.fsf@igel.home/

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-1-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 8c3862b4c259..b24b53134bad 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -24,6 +24,7 @@
 		KEEP(*(__restart_table))				\
 		__stop___restart_table = .;				\
 	}
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
-- 
2.39.1

