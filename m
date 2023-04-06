Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464866D8EDD
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 07:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDFFgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 01:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjDFFgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 01:36:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1E16A65;
        Wed,  5 Apr 2023 22:36:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335JBBt9008113;
        Thu, 6 Apr 2023 05:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jPegtu61qfqk3yRqs27SV2GnQd2k58iTB8C4CVany/8=;
 b=vIuoXTB98ZuU8Iqm4GlGebEqxrT7z+UKv7WvXec62E5DtRfhaUGBUwYLcUH5SJKRB+VJ
 JxmJI+rLYCdJvPJHtGPF0hhcVUm7Tb0/LI9M56Z1gz026+KSsiY5uFB7/OV463r+GhJz
 rNfdYB5Y3ed5rbHnInixbF7bLoqAdbYRFTkPr9ZKcI2dxi0UmVV7encj1uwMGehoXtMb
 w1ol9XjpuJBD7jwRhem+s9kOTyJPmfF6F/34lWWhwvTLxv4WqqH3Vv7y3ENVI9HGuS4+
 KZCO1kINjUrYbrFAt2R+lW+VU/O7B7+3U4zeepKxoHMO9eYpU5W8fgEoMa88OuxBihV+ 7A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppc7u1y2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Apr 2023 05:36:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3364OB9s001400;
        Thu, 6 Apr 2023 05:36:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3knhvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Apr 2023 05:36:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZWttF0wDxFNNOrkU1TdyHFBuptLYdp6rXImN4sWJLKVaxx56iJXg5lltQxY++SPNAnPFNByoU5u4kIrVZLuZnsRN+b1/BX1K+zr2wZNHkVN73mOz4JrkNyOdR1G4ZrJB+xSNtPuPEThGd7eiPJA+SQknjbbx2mlc+2IRt6lx8DyuBmlhcCxdrlMJo3IiGCtG9qkdj8rdN1KJjwP61ERFHXaK81LWUaNI1ytJPA4UZO2SbXhxdzL3lJfVbcDDCkX6072B+G3rlW+a8rs3mE3OBDlHHzGW/mi2ErCHas5np2iJEbgBPAvgWET6smWRpj781p66Yci0vwLh57TasC9Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPegtu61qfqk3yRqs27SV2GnQd2k58iTB8C4CVany/8=;
 b=Wye1Y9ebWvQcA4+GYbQUUSfqsuE/ooaikSPQoAJozXAgEoJLRm3P8nQnmwrDGKhwslCNcfgsmrE7rhng7FxS63y6F/e/Cm62dZvhE1W04cILXbwbJCoXRbD8Fm9GtiecsHnenGQmH8+kr3H2GxG9Tn9J88BHN0JMEm8iudPWSewUJ+0Hp3+sU8eNqAOalcTcE2SDY8EZvMOnZ4Rtb7jSRB2Irrbhwzfp5pwc+reI5Vi9SDWz4ZFYpIruH02cLDneWRDtkCHvjP7As8+10kHEfX30S0SfFEoko803nmngnS7+J7Ojc+s7noIm5TKyUsevN0ekI5TVku/SsbjEgUHnxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPegtu61qfqk3yRqs27SV2GnQd2k58iTB8C4CVany/8=;
 b=r142+0J/1lc3FZO6S52YWc1T76Ho5QRPYH2UOaPiJnABAOoIhITc4fVgIfk/11Uea6b49DUxNooH21UxZkC/5VuQSGJ1PjuyiD6sYRsy4iCWH5GCDrmQRBuziNiPXn9EseZZshd5CLu5qPefLToC7siPDpX7TTGB4YZ5jKQ7l8g=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by PH0PR10MB6984.namprd10.prod.outlook.com (2603:10b6:510:288::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 05:36:13 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::bc67:ac75:2c91:757e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::bc67:ac75:2c91:757e%6]) with mapi id 15.20.6277.031; Thu, 6 Apr 2023
 05:36:13 +0000
Message-ID: <e70620ef-1903-9081-5a3a-e1c8286f5e31@oracle.com>
Date:   Thu, 6 Apr 2023 13:36:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:95.0)
 Gecko/20100101 Thunderbird/95.0
Subject: Re: [PATCH] btrfs: scrub: reject unsupported scrub flags
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <df2418c0b26dc12913d5f542caf977bc3d1f28b2.1680757087.git.wqu@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <df2418c0b26dc12913d5f542caf977bc3d1f28b2.1680757087.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|PH0PR10MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad32d32-cee1-43b8-46bb-08db3660d53e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0u2LGBmOYylgLs1pGf7phN6IMaiXgUUidgodcWsRSDmFB+4x+o6H+RAvhLaBNzzDV6R6StGj+RPRErGj05iNPEhVszruO/IC/eD320Atmq7IecoF3fZTaWxHNTKpcZdXEw619YshGJEhZP8PKSqcHrzGHGYrdZ+WTmvMQTRX6Q+is64+pDRxd8hbsRc1p7AgmHtOUhw6bVErtTBu7YpX91K3JHqnKvvX+2l8IxMRtiXv10BEbasPxM2ULcmcwF8s+oiVKbGd/6mma6Z+QbkQpVka1MY/x1tgbD1jHN9RZAOYXfjFL1h73GgCYdI9cHw0d0p/d9ZcadkZTf6WshUsuiXI5BgKAm7hBlZds0acnnlxH7i61asC29HJIaugIUGmhhnuSnI+3L9ih1JppZuD2ENNu7giRUpNZm0FJgayrvFrHHsw7nubvoBNE099zLwWDI5hroEqzDrYg89A9pb67ZewZtCVoCXRwovXQd0KRLUxcVOtbp7kTKML8hAyY2vqpHQGtC5K3BQRBXHL+JjspS98gwPpjalvs9skxwxBAiMYv/W40EtfAqNmDPlMpx5pQ9j5ntzQsIe5SweXie8SIqF+PIifTTeZLVFiLXxz5tymDVH3EQX/cbtIjjfaG0zUZ9PT8r3zlNLR+MqvovxZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(41300700001)(8936002)(4326008)(38100700002)(5660300002)(316002)(31696002)(86362001)(66946007)(8676002)(44832011)(31686004)(66556008)(66476007)(478600001)(2906002)(6486002)(26005)(6512007)(2616005)(186003)(36756003)(6666004)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFZTczRZa1l1eExCbEVtMDlkUWgwcWcxYlZVTFZ4Vzl6cFJac2NhUVRBVTM1?=
 =?utf-8?B?RlNtajZRYVRPa0tNb0NFK3A4WGwvcmswWU0rVXJkemxENVhEZDVNL1BGSmdt?=
 =?utf-8?B?YkJ1RDNuRTdVNzdCY3lwTkZUbTZTYW1pbGZ3TjBPZ0RBeURReC9qand4aHk0?=
 =?utf-8?B?THYrY1lEQUoxbWxwU3QxQ0NMZlYyOEh1VXdUWkxNS3N1Mmp0cVlsd2hYeTg3?=
 =?utf-8?B?bXQzUkJSRnVCUEdMT1NqazBKK3RmeVpSZHhWTitjRnRKeDZKL3ZZZmlKK0VD?=
 =?utf-8?B?cmRod2RkVmhJZE1lVnVqMWY4V0RSUXprd2VlNHNibWFiOFYwTTRVSmpSak5z?=
 =?utf-8?B?bS9uZTdIejE2OXVweWdEWld0LzZiV1BFRHNxRldnWmRxMHhIalF2dCs0ZXJE?=
 =?utf-8?B?VnRBbytxWDRUVzBTQ3hOY3dTRGZWNFR3TFZZQWlEOEJQSGJ4NDFpUHQvSTh6?=
 =?utf-8?B?TXoxV0Iyb3dUNjUwcVZRYnptVENKaFBYeER5Y3ZvcFZMOSttN2tML053TUpv?=
 =?utf-8?B?bnNyK0t2eW5JUWNpOHJqbUkwZ3U5UGZ1MHZZVDBnSEVWTVpadHhzZlIrVjZw?=
 =?utf-8?B?Z1R3Vm5GSllQU0lmUkcxS1Q1cmViVEJhaHd1ZERoS2MxZ3NOM01MVzRzbHpV?=
 =?utf-8?B?SjE3ekFYS1dJd3F0S05BV1MzSDhBSXRHNEFEZFRyM3p0dWhZLzRUS3VVdXhi?=
 =?utf-8?B?OE8xcHdVMmpqOW9KMGREK2VZa0t6REMyYld0V3V6QytoV3h5VnJRL2llejRG?=
 =?utf-8?B?WkVSWVJrSEpvdHlnVDVuNExuQUltQ1dCUHI1ckw4ZGZjT2FYbTcvWnJqeVFv?=
 =?utf-8?B?SjhvMFFDaDBNcE9qNys5R3ZHUm5oOXRIVVhMQWZtV1B3U291allGMzZTZWdh?=
 =?utf-8?B?c0tDREY2N2VqemtySlpCanZtZ1ZWRTB1OVlscjR2eHRQb0pjZTI4TmlHUk1x?=
 =?utf-8?B?bTNWOHdWbEhLSWFXSTI1d2VlSWlXRERkZkhjREZHQlVrK2txdlJSYmVOVDlO?=
 =?utf-8?B?K2ZRdjhFdVVTNndmL2lwTVBUQU5PYXE3a3BJOEtkZTh4K2piMEpQSSs4UWVX?=
 =?utf-8?B?YlZucElCUHd3ZU82TG5reUdzZGFVNkNPSkp0ZGxHeUx0QWtycTloekFiMGJH?=
 =?utf-8?B?aEFLT09rNFpWdjJWTDBxN0hFc3V0TVN4N3N1VWNzeGdJWkV0eVpFNFc4bnBi?=
 =?utf-8?B?cGoxTVdDNUErYjJZbzMwUFR4a0hQZlpzbFhPQlkvL1pWZG9YbFhNbDErYUcx?=
 =?utf-8?B?Q2FuYnh4RnVwSTFYZ3lxOWVMWnI0eDQ2cGJ4aHUraDRpTG5kQUE5RGtrbW5s?=
 =?utf-8?B?Z29yamRzYUtudUZzaERHZHJmYnVhdk41aEd5YnNEaEF4TW9hd1RUQ3paVzhP?=
 =?utf-8?B?U0p0S1l6WG1Xa2pNQW03cjJYNGY2eWpDOEZCN0xHNjVlcTlUM2ZoQzJrK1R1?=
 =?utf-8?B?RUFOUGRTZ0tTc0YwSHJ3dW1oaXJOTWRBUGh0cHkrTHFYZmRPVFprY0I1Z04z?=
 =?utf-8?B?SWdJMmdaMGRXc0s0aE9lYVZVTmFIM2Z3MGJGc2hoOXNnQXd6TGRHOVRJQ3hI?=
 =?utf-8?B?L0RZSFBTNHNTYlJ1NWpVMjFTWHF6ak1kcDhmV0FwWTZlRVVldmkrRGdtSDh2?=
 =?utf-8?B?RGdNRFNVcitnOWFkM05lc0tObWJGS2piRXB5aTgyclJMQzNTQ1RtS3g5L1lY?=
 =?utf-8?B?Yi9va3R6WUREN0pXaWttZzNRblRvdG9lUW5lMEVwL2syaE1UemNmWFBxaVo4?=
 =?utf-8?B?U0d4ZUZnTitEMXpINXZlQklJY1liZStaOXhOYTN0WjlETDB1WEgxRHlFMUxY?=
 =?utf-8?B?bHpEb2NNbCt5WnBycXViM1c3OHF2aXNNMnh3empNdmFjdVlhcndtTDdVVC9Q?=
 =?utf-8?B?TDN6N21Kc3lVRlhuTlRKaVBXd3NGTk1WVDUwNGNiUTA2M2dpSm5CUngyckdw?=
 =?utf-8?B?aWNITk1JWk5oU3kvKzVpM04xVmdrd1RMelcyc0NrRW5MNjBmVnV4QkFwK0gx?=
 =?utf-8?B?blFNc093aGdFYmtpUmk2dityeHlvNnhuNloyRzlrcmtxcnBhUjNlZlhsNlJM?=
 =?utf-8?B?VHlKNEQrUlBhOWVjSDBZa2ExVWJqand4R1hERG12RjRhYjZ0QjZDdDRKVzE3?=
 =?utf-8?Q?SI1YZQAX2CtRNhm7RJX1q4H8m?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +keTp2BVxuN5OJpow+9HcTUBYkjR2jGPZEfHBBSP6Zpgskski68a7EYNqD6PV/6puCKO+95G3j64J0AybjUQKQY9eoo3ooewIZtSfJpOU8Ymj6n0akj1ah4nGRLl7nJzzic53MHtbyBf6zcgpGpcPgqXWaD+8gKRPY0F//gm/EYYniwmEOyWb4E+iW3lvYSO4S457LyOByY6OKemggJ5nAhXcibgWd0hQSiZVYmXAyiaiatxA9cOQg1RQdIz8mP8Ny7Lh6NO0vdJYDzLMSbw4KzUhI29mJ9nnSzKVHyiGKOZR5tDw7ULAld3LZtUrEelqYgNijnDTGno8R7vZlUGx84Uc5ccYN3K3VgQ8lD4ZyRX9avk6hysXGzP45+ljTMIXsEROl3jXbk/Gb8XpIBHCMW18ibSypXDlY8O+TPJeR2gCvqITvIkzVaAi2DlgRm/ADnyHBCk3Jtj+hS1RKU5Jp1kJefFh/vPA7zlY4tUioHe/r2co5UUNTp/ybWH6yqmkGmWY+YEdyIlVL3NyYiOpzDStV+g41RpLJoHwxfR53xln9k1Fg2WX9/5d3CI2N6mR2us6U6FLFV+AClG3Lpvsvi4M7O0szPOPeq+dwysbTZEM0BochPDv9dkLiG6DcDpqGR76OUMiY3bKBOEAYa60Erd4lRC23TpP+rqT+zTw5HOBMvfh99+ebm/dh4pt3JgRiWlXnVNI29WMwrJfcRqAH5a0lgb8jmlP/UNt2+ynnDAKrWPeMcUA9KLtm0x05MiDzJlbgfSekUxZyNWtpQstxiR2RQep6FS0uMDWMaoLYE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad32d32-cee1-43b8-46bb-08db3660d53e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 05:36:13.0846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gpv3UeLs8j+USXepMulVTOyiIZIf491npAKaArTuTIK55UyiOQQ5UG2rxlQ76kUTWjY8+jBKjViKTVpsx3QWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6984
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_02,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304060047
X-Proofpoint-ORIG-GUID: K2lvYuBzJ3BdAs67VJpdTxYHlYgdh_NA
X-Proofpoint-GUID: K2lvYuBzJ3BdAs67VJpdTxYHlYgdh_NA
X-Spam-Status: No, score=-2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/23 13:00, Qu Wenruo wrote:
> Since the introduction of scrub interface, the only flag that we support
> is BTRFS_SCRUB_READONLY.
> 
> Thus there is no sanity checks, if there are some undefined flags passed
> in, we just ignore them.
> 
> This is problematic if we want to introduce new scrub flags, as we have
> no way to determine if such flags are supported.
> 
> Thus this patch would address the problem by introducing a check for the
> flags, and if unsupported flags are set, return -EOPNOTSUPP to inform
> the user space.
> 
> This check should be backported for all supported kernels before any new
> scrub flags are introduced.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>


> ---
>   fs/btrfs/ioctl.c           | 5 +++++
>   include/uapi/linux/btrfs.h | 1 +
>   2 files changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ba769a1eb87a..25833b4eeaf5 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3161,6 +3161,11 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
>   	if (IS_ERR(sa))
>   		return PTR_ERR(sa);
>   
> +	if (sa->flags & ~BTRFS_SCRUB_SUPPORTED_FLAGS) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>   	if (!(sa->flags & BTRFS_SCRUB_READONLY)) {
>   		ret = mnt_want_write_file(file);
>   		if (ret)
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index ada0a489bf2b..dbb8b96da50d 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -187,6 +187,7 @@ struct btrfs_scrub_progress {
>   };
>   
>   #define BTRFS_SCRUB_READONLY	1
> +#define BTRFS_SCRUB_SUPPORTED_FLAGS	(BTRFS_SCRUB_READONLY)
>   struct btrfs_ioctl_scrub_args {
>   	__u64 devid;				/* in */
>   	__u64 start;				/* in */

