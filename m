Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039E967EFBB
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjA0UkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjA0UkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:40:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94ACE7D9BD;
        Fri, 27 Jan 2023 12:40:09 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESXcN004169;
        Fri, 27 Jan 2023 20:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=kmO23abRBgPtmDBpNQ9blSPHAPqqjxkVBwxqHKNafA4=;
 b=ggXCIQ6Xf9bw92nOD/+ioEX4Ql4cv6uY+jT1ve0kIHTAZQqohFwbVhi712oCzuUmdnU+
 PptumBneQAkrB4X7nYQVgQ8WziyV38++/QXGOZk9gYkjYhHrBbViG7yd7Gyri2ZlSFeN
 3WanXoybA2NFx/if+7G42y2S+x06vy+5m9yCTiRNDW9SrCdrwta8RCoro5gsZhP5U7iH
 uKTphTNOBuYheY+gPX/ct3EHc3xKBuGvm36KCfXn9TIOjykBr1B/SWKpzUwc9fhx+EQB
 ap20ryPFZGwxIzWYXJRrqe9lOFVtRliY4XEyGVS6XispPeiJqGmH9Jpqe2+yeiVCy8Fm Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncfd190u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKFmcf029892;
        Fri, 27 Jan 2023 20:39:38 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g9p69y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n10Xxu7wVNoBAuTwrppgPVKtTMwV7jvPd3tjC7SC+gNzkh7s5adtKntUmLNEarM2z1nxFKG92cnGdA/dGfG6wzR1aHjmn2KwopOcNsD93IrBk5zFrWMZx+l714RTQ5Ts4FGq2EFVABXCMBn61lZbGVz7XlXpvI+rwdTPNqcASDdjy22SAoylZOpYTcgusaXp9Vu/aKs2ZFxVClUQvTtCsL+TFOh06Ptemet3F8dzArxy5NNtJVKlAfQybWalPwhHUM0mVmPtrlYR5uCBSW4Q8dffoLs7/XCGOMzLOpKrVk8IUjQlydITIAQHfZDQyc1WW2Pju9BDC+PmVi/Flu01sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmO23abRBgPtmDBpNQ9blSPHAPqqjxkVBwxqHKNafA4=;
 b=AF928OibfTDMfCi08qBwbEwMYlGeQaSxwTo9HXiTQOIdjhyq0P43OA3cj9VhG9F+AslPfcCAtF6h+9tiaJu915m2dtxJXD8ULjUyKxU9u7rCyf3MoU+2QetqVYtHTXFJ8At1tp2DINCbNInuweh5wNj3oJYnDZjrp7GKTqbgfOR8W7GfHuJ5vmwWMrLEGSmD3LDatUQ0ulEI7O0IQTIezeJVvxnyWLm1UR3zmtfjtDuPpvvY27hO73CKPwDoUogQeMBZBSUANmD4M9FW3aBmkap1NL0Yk1UOvCcV4lIJm+k3da8wHhekev2f0TGe5PC6GK9gV3zDH4mcovfZlyuxWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmO23abRBgPtmDBpNQ9blSPHAPqqjxkVBwxqHKNafA4=;
 b=xs21i586xrAQxEFaLWUJgpyUDXqdUEWqRMoxu2wDthdzXdSXX/6/KzqCjJka6DAr2xxXGepa1FcmyucqjM3XI2odASGhn+H6fZ48n2DRN/Yfsjo2EA725sE/z0IoqroFicGyIdnodxVIDio64P0QKpsE/2q26q92hjEH4yUd+jA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:39:36 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:39:36 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.10 fix build id for arm64 1/5] arch: fix broken BuildID for arm64 and riscv
Date:   Fri, 27 Jan 2023 13:39:23 -0700
Message-Id: <6608d565dbeace275597dd22787b3c6161d7e501.1674850666.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674850666.git.tom.saeger@oracle.com>
References: <cover.1674850666.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0039.namprd11.prod.outlook.com
 (2603:10b6:a03:80::16) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e28caa7-b681-40e5-87b7-08db00a69acc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wG57AVUJGnm2bSAAh5M4HkESHDL7u5aVePU+JSx63/D8HbfeT8wOs7GB7DmViX4f7wvNw07OsZJMt6TyNIXb1moBsgMfC1DcXF4BRZTcfMc14ur62lyYL6SRMAGmQqwxWLMop3Q/TnfL6vMGWDoP5tWCT2A+v9tRCn3KIv3Uv5FOtfVH72Rhiz/sOA79if4Ge6W1QAMtiCpbV0SMx7n3AQvBTw2Li23kOpSdq8hcJMwYSmBlsJ08+hhaaAvTHxFS0xBc0smAHgvvzmX9vD1ltTxpHzzc1b54a++lk6f6tlaO4aKu0vZYZzZv8I4H+arIrw7uxvgHuGxp2XjGZsE61HUGNbsuEgHlUdqr9lA9evqsZroYpfvJoNLMlN9un8XF8pyz0uuX9Q7oJQmZNb63KrmZrJFnn7l6e1AmVDrRQ8BV691TntdzfsZwv3jnaBYrh3RdPsdKEFpmMe1Dr2zuVpNN9/e1IAs1u9od9eJdYdrmQGQl2U8CIDExw+10u/cgTHK99brVWbB/giX5E1TPbeRnq0VEtBdnukA5F0m/QgpulDuCL+g/ZTm+U26Z2EDYAUpMR3BljKV30SDIBNC6dcjonGjnrCplcNgyL2isDqWAjQxbkIEc8mhoEPXVs4BmgSZCmcLV/nmfS3UXm0CLcwkuvPKPNawEELYL+8XBJX4MzU49fCFMIBaHqdWf/+Bx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(54906003)(6506007)(6486002)(966005)(478600001)(83380400001)(6512007)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tZArC0m6RE/tl01eZZQ31anuNqBHtqV5NbKuP6GIKcpppQViXxlEIA3wS9q8?=
 =?us-ascii?Q?AnRNXmjXMF8NJ5x2KVgnDTmqrWILFZBAlVpAYmj9VSKREcWQzq4ls6ROF8yU?=
 =?us-ascii?Q?4++Tfyh1c3W/fKHDs/gCm7Y9+55tF/I668h4UpASuqT5YA0XxR0KYPIrl7ql?=
 =?us-ascii?Q?cmsVBTTpwaLysHzRDDPQrxjy4TgoYGRm+s7HCAJof81Xqmz79WlV6B5Mfe7+?=
 =?us-ascii?Q?DiVmSV5aOyhC7UsNEgJrQ/BpglVqqHg+LNxvLONuONkNnD58BtX+cGz56vdR?=
 =?us-ascii?Q?YMg/t/mPt78ZG57kMc/ZoXjCJ0mLocSDkDXaDrrOOMK3yCJOyp8BlzBRFw2w?=
 =?us-ascii?Q?FWYkyaGJiIqAFhnCmDGg3ha/aV5pZ+Bm3oZv3JCJdCOEgfBO71hCMi7NdBMy?=
 =?us-ascii?Q?+g3PoRWzey2j8qFuEt2RyouqhCR/7PMbQCpuKWnofcL8uglITOaXUBIObGLR?=
 =?us-ascii?Q?GXocfVRJc7LAvR7qJVhNyfU2/YyrhxxRb5yk8X/jxQPFBdr7PS6dpKpGIZvP?=
 =?us-ascii?Q?j6BoHIGMeriEbWk9HA1eRIlyQg+qozHfhmkfGNhgI4K13s69tkZYASaYE5KP?=
 =?us-ascii?Q?wnRaR9OcqYOFqCWMXQ4Kv0o6jjkXfylbr+hPCTPrN3syO52MFScjwGI+wdD5?=
 =?us-ascii?Q?R1hzvZq0vE2o57+TxQNINVtl0XwH8oZ5sDFRXxW7eA6qA9zWUFCKWAcQq03Q?=
 =?us-ascii?Q?J8jCunTostU6wgBRNv/FRy00B+w1Q9o+5wqIIBbVMzN/LFdcVMDS8xZZXnkg?=
 =?us-ascii?Q?N3Nd+wCh6MY53FIBDvcO3ErJDy6wvGtAB2uHg7CaO4CFDcM/zKmArSLIpSA1?=
 =?us-ascii?Q?ZR9p+wrD/seCrD9Pr7MRUX7VjghpBponTjBd3fM66W1eRp+aQPUq6BjM7j8T?=
 =?us-ascii?Q?j3F5pgS9VHO2BltNS9H0sCMkvY+1+odprYFVJU2xZ+EcmSDf8GQZ5Lh7y8gH?=
 =?us-ascii?Q?NTXgl4A9CXKfluBvVmdPYxCorxAOH3nDESuzVA6oZQbVuiGtYX3dRAVGVrIR?=
 =?us-ascii?Q?2OvpotJhqcIgclmHSakNI3+mUq0qtibg/nM8RpHdhOiySW4IJEUU21USpVr9?=
 =?us-ascii?Q?2d/qE7aC0t8TBqNsDkpfCWouVTPeKureJcOtBEQLHsg5m/leYb/0LYYYFsG0?=
 =?us-ascii?Q?jfpML0HbPQqMUmjM5l0KiHk+TeDl5Ps2jl9WVU4dsBbxh61/M7nQcrB7ooec?=
 =?us-ascii?Q?XQg8bruvphYl3+AGCkf6pwJDt3LUHFbP1z/D3apS2os0sN01hfuNkjrMvV1+?=
 =?us-ascii?Q?iz+Btu5IZBVpccSJCd4286mimIkgeXRHwfpdo0ryXTMiX/iezArkxv2U1Gy2?=
 =?us-ascii?Q?qWVcaZji0aDNTRp+y/E87fYBuJG6h84CThxoK2qSC6r705VMYnCNjnZXZxVA?=
 =?us-ascii?Q?WmcXpK+mkYKhoDlxVyCak5V60ZeagB8SlzARmojNFB7NQ5f29v2QkQ3g99hU?=
 =?us-ascii?Q?2H9Ua6EG2Js63HQRopCqQt+ue5rdpQqT1XdBjx0Uem14KnEWWsvHHB0Cp0fI?=
 =?us-ascii?Q?HQn3gEDt86CHv14HRMGJxu/vnrTi9+iWhNgsthYwssyBC2KT7IUBU4QgmioI?=
 =?us-ascii?Q?sbRhH0LzfFRS/S1bMkm/P9Ex76VGQPJ4ozu133VSsQcxOL7so7ynOhkF6rWD?=
 =?us-ascii?Q?PKalpml6MD/SBte30NUF2LY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?nwBaRurJr5qyW/5tqNkCMRkxyZRSuZzFJ4Q24AVcSk+IUyB8+bTe3ljAbwOV?=
 =?us-ascii?Q?v6zdKQnvswTqHUpKXcuGlAPFSPu7td8l97MXyP6fx8u6LaydG22a72EDk9rn?=
 =?us-ascii?Q?WANBWLfwG5yT66CJy+G8RtrtI3Cde40+lrq1RkhI02lWl8vSmLoxcPByf1qc?=
 =?us-ascii?Q?LitYwJHWYwHFSr7oVaTpK7Mby9CuR08Aw3/SL+rWF003ET+fZfnqyC3Wd/Ga?=
 =?us-ascii?Q?jwS8Amct07wr76XwcWGnBi7C2k4sRXTqqTqJUKf/g6NS4Tj+UF6l+wXMFnV7?=
 =?us-ascii?Q?SXGTA+sxO/aWoillqr7+aQ9wnh9c3i+ntj/QT3zQfm6vEQ9QcG/IJirT5bKp?=
 =?us-ascii?Q?8adGKGqeO3gZHrpZYfBpqL5XLOdkw2wogJxncDTb3AEQ92eNDDtzdm1sU6ZE?=
 =?us-ascii?Q?b/FoZ9Y+pOEfgX31nBX+q0cjMcH79g3DpVAoh9Zy99+YNPlJKoziD61VxWab?=
 =?us-ascii?Q?iSJUjBidbOAHJgmv0W17RRyiyDeDjjD8kXygI6jHUayJM8KYFSRTOMy+ZIoA?=
 =?us-ascii?Q?OiH7C6QuQ7t5Hu+bGGo3+3Zk6/lcfxtawt2fs8ZNIrMdXzBZiYqLWXlOC08F?=
 =?us-ascii?Q?d5dgb5Kjrfl5sphpJJ78SDWbUuuB8VypkHnDX0dYg/Fkw/zKCP/SSR1lAZ1G?=
 =?us-ascii?Q?t9OBt5H4fqOHHgQ0OAHTtFjTvPbrYPT9EIQf9sGmbkFbQm+vY9OVpRerBS+l?=
 =?us-ascii?Q?mSzaIHZUpGjDe7EITZnTcNCe0izWQ/IZ/k9avPTHKDxOIfnlywTs2D+luQIG?=
 =?us-ascii?Q?fnbJ6luuW8/qraaqPM8fVHnspdgVHfiWhFvmZMjU7f8DIYZeNQQfG653ScRP?=
 =?us-ascii?Q?kwo1VdfRUkWEGEWTUfM4H7dhpj+0mzD9elQsg2isvWamgseu2OFseA7IhEh4?=
 =?us-ascii?Q?IgO7LqhDl2cb+cB2UGhhjq6P72WbAJuXTR4JN04BxOYX5VgYX/oHyDWyxkXX?=
 =?us-ascii?Q?wOw77xPGNR9gbCjHg6FWewj6ObdkHoUSq52tYOICw3T83cJCh9dADi99ddDB?=
 =?us-ascii?Q?e/2xgVeX0nuvfVzgY/jx2yPMqoGOpbhw+gh1e64zfpwO8ze1l3WAQWoN7PAA?=
 =?us-ascii?Q?7L4a5UfTitZpaGVncfVES0GnndFK8w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e28caa7-b681-40e5-87b7-08db00a69acc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:39:36.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XVjZ1xHTKmuwCq8xdhXzkXj/nu0Qg1S3dDAeIp3uNzaYRt/A/SDFTYckcpgs0R014qfH/gSLUM6W8NSpQgQRhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270190
X-Proofpoint-ORIG-GUID: xeOm5KqRA2mQGXYYAyKlqTNjON4yhOEO
X-Proofpoint-GUID: xeOm5KqRA2mQGXYYAyKlqTNjON4yhOEO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index d233f9e4b9c6..44103f9487c9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -906,7 +906,12 @@
 #define TRACEDATA
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\
-- 
2.39.1

