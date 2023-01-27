Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7287567EFC9
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjA0Ulk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjA0Ulj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:41:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F07E057;
        Fri, 27 Jan 2023 12:41:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESgmh005583;
        Fri, 27 Jan 2023 20:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=rklWroYm5Z3wUGlVglz9yJko9citdfW74l4y36YRFCI=;
 b=hVDG0aAmhGG5xykKIH8Kno9UgDQR2q1DSxeW/T8/fFV5cLuUhHvLB01Vx2iMZkqkWsMd
 Kh9nW6zEpkqPIDX/ZVdax7+/O4LlPWkYsJuJ8ov8t4pd/Vv2BG0FsvZjNLVzr/XJafnp
 OyP4ApJxyFlxZ8QXi7q/SZkZeu9yJtSqVy01mQtaHWAPFt1UhXQ3DP6g7EK4+1I6fviU
 oUsPIAKZpeS0TJRtBhRvNKkfpcL9vttfw9UqIWl+WmmFEsHDW/NV11fGHeh1A9soQdKb
 /T0Wht5EBm0Q+cRgvyXzV4sU51GUfFrkCIhH1vXTddYK40cQQ9geMs8HVmPJx2yal5Pm hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u35rce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKGdGF030036;
        Fri, 27 Jan 2023 20:40:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g9p74s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FS+jhe/Vocbu5v5/aZG1kyskFhXn7THeXwhKWEzftJOwIeF0gcUI+4SxuNOcA9q4y/7GMrQ6SmrxcTbFU6O8iCW7dHgUVA/ierkzYTSAaWy+SQUW6XV0GsOr9Mj1tlKVRcRMnBD6OpvOVr7nN74PfDLea/sAA6Yy1HnHk/PPvQgbhPBaeIyC33n4zyeyAQdLeAR03WY36tL4QD/gQuZzkjkPos5fJgcqFWcCjTHIOoTKlKGUkaawDOSSDUbU8repN7ihV/yM7PTmqbqxESNGAm0jhUk8FdWIGLTnlS6qbJuekuFkr6GRmjfHYjLFFM44TPu/yH6Ydp8lGBYlAre3tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rklWroYm5Z3wUGlVglz9yJko9citdfW74l4y36YRFCI=;
 b=DhlEqBLDZJNrV+OypakegGWZZOhRNJgerwY8A/aw3Bqx4NCJ/uTlIP/9b+OT2fR4wL1qncBwsVEC629pdfQ0iq3rpM5vzigYi9g9OARWisWkfhrR/DkjRswCKuXOkGFPkmN9F72OUAngubDR4XMgHRXcIrL70vzI4KOLa62oshhttFQcsIe9RVP4jFyxNYrU1JDzWo2jO3EDSSegzyP/EqowbNhsrXbdu79n/EM2jjNMDWTv0g2YjhKZ+Mm9l1oNNNIr8qUkF3iHMWy1WQKVby5XaTHDEyJKlhQZ0+1bJsBn/8aQDtSDps5Kz+pf2c9cNCcaL82jd9Duf9+f/glusQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rklWroYm5Z3wUGlVglz9yJko9citdfW74l4y36YRFCI=;
 b=kG/AMRwrPVkBNAb9h9RwEnO9m3EQcQCVY+WbGNrG6Z7EXM14yN2iywY6RCMKwk4pPoGiKo+fZWBzE2G1AA2i6+9HNp5VhRpthl6E1vQahEd+2jQmFsmkbPA58Jj56KhYHkxApruoOPaJ2k46Sy5QJOyleoOh8JC2tU8dI2DERZo=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:40:17 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:40:17 +0000
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
Subject: [PATCH 5.15 fix build id for arm64 0/5]
Date:   Fri, 27 Jan 2023 13:40:06 -0700
Message-Id: <cover.1674851705.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:254::7) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ef27df-cede-4774-be7b-08db00a6b2c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: faKAuo+AReAUsv776ProN6c7b38KBpCZRVc75OZjFTMv/AOKV3RrIiDne/MumY3PS3zFH5ehdqRmKjmu8VTEzc5vhw+zhgwfz/JNC93bSfNf8Wrt/CBk60j3DAq5lFu7HCgKZobriu/zBQFSh/vzZSuxEL8FO2zWPmYATGSN5qX8m3YLE4UHqZa3DPzEIsJPhANN5r/r1UgXmEXGnEBJfC7XuE4YHSxTrmYlc1XPFzCyW+AsEfLEarsy2ZHrcs29LkJ4gOP+ecoHYN7+XaEMY0kggeiYtaXBoLMFJxbi2HmOSAuEd5wjXx9aqM4+KVApKtjolAJOO2Kae9cvBZ5FCZdww94QFDrF1+gSmMtjPanSlTsnC9/bnLyHlsv9fV41t5W/VxEUu8rhno5s3GP2+IR2e4fcXrqipPuQkhDXEB73+almRoKeBPnahtrVjcdaB8GBTNj2zqGIOV28tENgmTVoQPJa3Ih+UIfbfbzPfhNzaY/DCSG0IyJy3b43aF7fU0pzdrlWJI2EgOQnn10eD7c6A85qny2rNa7uATkbfy8TJNgDw2QiBB3mK+f7/f+oBJUri6+TpFkzO6hSD04ZlHmMK1RZxMV3DXXlPqqh0sXgrVsdrE1kBSbDhDy5k/Sp5h5lVyLHmdnd9XizMgmhU4Q5z24Y5l74a/kCtSUziDOXSJhYwqMWHhS7hDlsJckV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(54906003)(6506007)(6486002)(966005)(478600001)(83380400001)(6512007)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bqClJ9J6XMf+T5pYS4v8TycI+iNYvOMOIqYmdYLExyHNjNO67jCYzMusgtBw?=
 =?us-ascii?Q?nBdf3/GnCbgzelPb1MnagjVieINs2lWdLs621haSBFsdLmRaib+BFhJGrYEq?=
 =?us-ascii?Q?+Sqr8dUYuttElNF5qVx5ygsr1BKuQOrNL0cdIKhU40sxwrHNnI9vVh7407bc?=
 =?us-ascii?Q?EfChoIJDFigrMDRMDtbIBk40PYXDxHWmR71U088JKGRnTBuKlk+rHowYvEOE?=
 =?us-ascii?Q?TStM5MAB9kByANA8KorG/rRChiz0X0yC5m3tpGaqsECYho2R4AOG2JVRZClh?=
 =?us-ascii?Q?y5f2ifEs0Jo6PZXwF4WU/CiyHvLgElTv8rtuyIqCfJfWGT4QEiQoy+09RJBR?=
 =?us-ascii?Q?MyAjE5mMrIYK+od7bqsfvxEaRo5hu2Ow28GnDYmK0kcquZTBrsWiN3RTtxJr?=
 =?us-ascii?Q?XYR9dGjIywmtjM6+DnEb+8coVdtXXm/scqPGCuS2vF+fnEY2BcveFbMnddPD?=
 =?us-ascii?Q?Bbd1GvV6mHORx1WaAPzhSzfQQzHpwVsaOJC5NzLhPjmQHPhNrl26E8njErtf?=
 =?us-ascii?Q?GGCZVpxdQYOnc03sZQ5iEaQnE7q9Htm1rE8d4zythztY6+gZ0F18B7BZD8WX?=
 =?us-ascii?Q?mXbFHGd5T9WsydWAGHwPKQ7HWlriv8ZlTEdJqpRj+SexjqyvIIRne2lYllEk?=
 =?us-ascii?Q?Z01Dn9DoGjs1Nduu2FeAI+bgA7c1P7kOOHcnrxsnwqU0fj5TDmBm4ET2gewT?=
 =?us-ascii?Q?RupC3Y+ZaXdl/Noq394T3pmZp3TjrguG3/gKD9KVbHbj+sgrBaCo25U3D6JK?=
 =?us-ascii?Q?jjhjHATXO7MfWRwIUcBMSXdVBRDJhaA9UzjFQhzA4TSNly4om/OLR4/QdKal?=
 =?us-ascii?Q?b/N3BFGKnxQQQWAx7kWvEqUn7FvOFcxoPfY2MhWqlcO8s/cERHrEcetbwVwO?=
 =?us-ascii?Q?z12UIcbBwRnh5Ezwy5aNohXRzaUsdxuWEO6Oe3oJ5cwKgQXak7NdQCV5zQuD?=
 =?us-ascii?Q?w2QGae8dgjeLeW4GVF5a6h6dSoShidUpHFpHq+jgw5RWnTJgLBqKO1aSOOzP?=
 =?us-ascii?Q?Uf1ibjgRJYybATd4ToitKNCz7r59llyrE0Nqx9Coq1sW1yNLcneK9ThXjUNX?=
 =?us-ascii?Q?s0aKE/qWzuPr7vjZZ+xJGPEKnYu/DqntGVddCugtu/MGQpcxGqZu36TTA5sp?=
 =?us-ascii?Q?hyZCzJBMIrtA85Rd1D5sDfb1JQKlE1vRoFdKCQ69Svx5/q4tQ3UdMr81+3/8?=
 =?us-ascii?Q?CuXfNcN4dQEJ2HDoVkGhijRhcnEB+kr6pkyu6aRilgqiy6Sghy9Te0Vr/Plz?=
 =?us-ascii?Q?9YpiP5++e9Jhi2nAuk8iY77tTpM7SV/0bPYrWH1KWpLUSL0kKYE+y4vhJG9x?=
 =?us-ascii?Q?qS2RyzeBywz3yiGnKBCEh9S6+DkuilY1c57e/pvZmKg77dHpRKvNsQFyTO7s?=
 =?us-ascii?Q?Y+rwsiB7BfuNBhJ1aU5uaXCn/GMgqQSiXCb2+3DCZ/1DSSuH0yex5MZoSaRa?=
 =?us-ascii?Q?DFk/G+k3XxMO/UQMR2/fzp03AeMScMNBb+ZIsOU2QKlk0tYDLdnmT0n7mKpx?=
 =?us-ascii?Q?8TQi8yxg0TG9bV/UVFkAZZ/cojmIAytK2J45IQyoLN4mqmkePoH2yrzjcmK7?=
 =?us-ascii?Q?D3Oi0WJBkndjYLJo/PnFmJclydy4b5zI12Z5z6mpBJXvErVEcE5tLFEP0LV/?=
 =?us-ascii?Q?/nqdukzqVdQkpUz/+FG5lIw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?LSM9NI3IjvdI2RG7OXsDAvMjduhnDwkFFvucWhruu+GztRnV4JpaQfYbL078?=
 =?us-ascii?Q?B4LdTwcoyEowHFuDhhkdrxInJaVlIr6xG93qkEQiZvbs6oQ2qG5dLo2dV4LC?=
 =?us-ascii?Q?vQ536EjDU1Fim8L+srnHKI6Aao5NmgecYwg4nwAbnEUung+aaHGeiccKpCeM?=
 =?us-ascii?Q?K30/nTOSlkEQBu76ehPAP6YQLo+h5ZTqW8CNMwXuo9PRYufPcOH4g3TvjHHw?=
 =?us-ascii?Q?WDUnmgObgxycLHUUZk1JbcsSuUfw6Uz5Tg8kndYFJbFEKAvbNwyqmvh3guSP?=
 =?us-ascii?Q?2Y/SgyIb+yTqx8dZIQ5oqlV8u9cTTwORjbqs9YzSSWkVxpDoh6pJVGwa/c5O?=
 =?us-ascii?Q?aszgQaBUQK6+hTQIDZkk+T+c5A6ILIFYBF3KxnG45ahQ59/Q0jhuZn24ZVhQ?=
 =?us-ascii?Q?mbW/UndpdyJFFRU6N6nA90cob5FBaWyBu2HBLSlLIHo8rDcTJGvrda3gFGsx?=
 =?us-ascii?Q?vV6qRPIvQ9vjRflsCPuQlw2tHcIwoWUlnQARk50zdOEIErfvlTV4rPTce+d2?=
 =?us-ascii?Q?hyytWP18Upq5kWNCQoeWWj7TSw66TV5uWY6I8YCEmycP6cHj6Y454Gf0prA8?=
 =?us-ascii?Q?J91nrn5ioGorSXeQH5WJ7KoKzpjZwqrxjmefvpM37ZrQFU/BPk3uxmo5Ie0a?=
 =?us-ascii?Q?+7ZN85TfKrOeC6KVl9Q3M0I6azwH9moBQE3WKio9g4lG+srTp+rWarGFGDCz?=
 =?us-ascii?Q?/Fulmj6vHFvQqiORNY3ndWXxRnAnfTr3WbUgseSLwfDfqfR+BIw0giJPes5x?=
 =?us-ascii?Q?7InEem8YebRUgJ8DJFnbUCopnWAXpCmoHsqo6It6EKIRUNNccQqdzGrzDJA0?=
 =?us-ascii?Q?jmjc/Mn8OD/tfL01hTzGjIq0Qc9ldSt9fEieVYf6Lk1pG+XykuISxM8zJYVP?=
 =?us-ascii?Q?mLalJLBh46F8yFavHTbCqHd2TINmQXWZmIc8aMxYK4J1Lt2w7Dj+fwxybPuj?=
 =?us-ascii?Q?NNjVTlPph1h+AafzSlfETgV8pVG2bTB4+rFBaHu2kIj2wyE5cWgZGW9RacGC?=
 =?us-ascii?Q?O39ueSU+lRRd+T2WmyI3to7F4cZBu4hvbe6EjGoW3D8N/WnddfdTFVlOu6Kz?=
 =?us-ascii?Q?J3gXlPpt9+ttn0pZeJ/h9LTiXIRk8g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ef27df-cede-4774-be7b-08db00a6b2c9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:40:16.9069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqKcvQfe5jjO1KGPr+UDfYIdkwGMxFcjsIuRNioTcS6NWu5FCK0k06wgwOZv9eTe+YwttUWq+MaWfKX5T4HU6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=883 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270190
X-Proofpoint-GUID: gXpYEscFvfWiRpIUTlGDVZAAbZs3_jzX
X-Proofpoint-ORIG-GUID: gXpYEscFvfWiRpIUTlGDVZAAbZs3_jzX
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

I've build tested on {x86_64, arm64, riscv, powerpc, s390, sh}

Without these patches Build ID is missing for arm64 (ld >= 2.36):

  $ readelf -n vmlinux | grep "Build ID"

*NOTE* to following is not in mainline, yet:
[PATCH 5.15 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
https://lore.kernel.org/all/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com/

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


base-commit: aabd5ba7e9b03e9a211a4842ab4a93d46f684d2c
-- 
2.39.1

