Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE13510596
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 19:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349339AbiDZRlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 13:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353124AbiDZRlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 13:41:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68A2151F7F;
        Tue, 26 Apr 2022 10:38:07 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QFXM9c025802;
        Tue, 26 Apr 2022 17:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4EKbWaUBCOyBOjAduthnpEY1sOsNK1g9QN189c6pkNY=;
 b=KKgECzVEb8ILRmB+DEHaRwNN2z/dRcxDo/LHMYNg5B1G9+U0p7GDFE5W/R/mRQIy4gRD
 gnShtLvaX5xefF1/yuVFdlYmczAs0LSDalo4dwL90KybUybqQE13+daC3C61p1ey3Z4b
 msIjPfSlZsB1ecRKryX+SkcNDMo4gj3h5ni2ZuGhgnCceCXT7Z4EMDc3MrvID12KLVw2
 0Bpa/ZbUHx0qbGwVjoz8xip7E/V9eiEZdfwnWKT6PRNhZLjpZoDx9YRZ69VnAbPTOzTU
 MOkJ2x5k4ab8FH/EDEoPo2+Zn6JpUNwX5jClRl/Yx4/vNkV84p49jFoyGHmukRYmZVDl Xw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mpvyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 17:37:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QHV6mw017356;
        Tue, 26 Apr 2022 17:37:30 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3mcgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 17:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdjgJ7wef1V4ku4lrJJkBbZaEFjkYdjlsSzEscKiEgyH4lXpKA9rHIhOEINKmyO56NctSHHBuFPOzuH1XeYNFRVOgH6NslkvqggweXJ9/c4FLlRUb/z3sLIKJMXsVfy1lNIEjyKGo8aZAAjSEPG1FjQEEvxeIBgF/lzS0nIFsJvEukrZRI2k0MGCITKn5OhVT9M3cukhmDHF4TgVcsVxqosZOuLmEJS7+sirTMN0gMk3KDiIVNUl6xXzoDbfGV7sf5FZ+dS4MR+NZA+G//2w6tXtinBbaoULlDK3HWR8gkt60G/9RKCafJC9fvFnMUHIz4WY/I4P8CHWbDbHD3Xkpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4EKbWaUBCOyBOjAduthnpEY1sOsNK1g9QN189c6pkNY=;
 b=iJiSIiY4mOxNLbiwxHDwFsG1Avo3aEJqyTDa3AICt73IBzw2qV/V2I8G/pRD1+JozUsGKG17a16mh5mOe1vJt3r82t+iR9ir9oAPFBucQPRCce4ESOxfOgJb9J7VNracf1wTCWT/7MSY7/JEI+oIjHssqB3Yqv3J+K5yekq7Ybjb9DLQY9X3GNX0uugqXx3lT++nvvbcRV7CxxcU89ei2ei9A/jmOgOUR2d+ewypzmNp1muuaNh3DV31KWSCDpg8BGhWBxqv/uJ3IsqXvv9yzW6ERQHFfmHvUiLYXvNSvDhBXzXk7sNJRDfKJsIRPtZ6AmuZkbBax8IQEc7zvG2Mfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EKbWaUBCOyBOjAduthnpEY1sOsNK1g9QN189c6pkNY=;
 b=zo/gY02GtAu5bGtZS6YHENtZ3bu3fe8w6LI946KqRJNobGKVhCJtEPFfyTXWBltRmXu5MDGEPZDU7XrO4V95LuMECRmH8Jow46ZsGFb47P5cjgZJO+o09Vksm6C/k4mLByHUqcTXravNNru66ux5OxX7FJ11a/XV6gJPkpHQYnI=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by SN6PR10MB3454.namprd10.prod.outlook.com (2603:10b6:805:d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 26 Apr
 2022 17:37:28 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::4427:92a2:50a5:50b6]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::4427:92a2:50a5:50b6%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 17:37:28 +0000
Message-ID: <09eb98b8-6200-20c2-faa2-ced7f0e4fc95@oracle.com>
Date:   Tue, 26 Apr 2022 12:37:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Waiman Long <longman@redhat.com>,
        John Donnelly <john.p.donnelly@oracle.com>
References: <20220426081747.286685339@linuxfoundation.org>
From:   john.p.donnelly@oracle.com
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:4:ad::43) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6a6e519-1719-4d45-c3d6-08da27ab6ec6
X-MS-TrafficTypeDiagnostic: SN6PR10MB3454:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3454817020D88A22765A7F90C7FB9@SN6PR10MB3454.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZSXCHyCDvaauks5sOONJMnBjmZ2tV4XyaCrRV65bsD94/Q4/7eSKp6GkwKRF5TRk4qJIbkI6PW5UxpeaE4x649yMG0qTnTi3lKSr6V6pR+HzR22W9gP/PhpqEBp3iScbvgQ5j6zHZHvGSUc9ITs5TXF1d+Mxh1Isd02dWrociGxyEETF/gmL5ppKKPiDHxgy20PqFc/gEv1g1WVz5eVzu2hmvL8B+DOZinMp71ZNj79klthTSmpx41B1Kc4uSCxRHFykgK0QbZti0AbrMajGZifvttPh+FcmhUtfxnvM11zeTAdWtXJN/27iHT5FqkcT8O7Q08i30QUy8sqQg72wIbJJjHho4/TZVD7oJFLA0bcDnqL5vLwAx4FowXaqR6bYlkE1hENOXTT5FGQQoDXAvYt9OeVFhxJ+SajFgdjQSjQWvMvC1UgYchw0hWqT9nhlkeCOphIGxwQl+JT12zfpzXY77EBhHXbyxqkTfpl4ZOiyqioE0zGR3eprvLfIC19iKb/62gQ/9ujyJENDUPWp1X6OZz4ZxClvxI/T6m0rdAgDXLrKCDrPZO7LYCWgQBPYLftkqVUoqDKT2LLwf3frGKF6CBIBO9r1FffRSMSEN6vvZnqL2Zi53uFjTYtcGKyBsInWLelUjtvyXapB7/s8dNFtrIz35pkHNzySps6bJHTCyhoI/uUaQuT1rlD5bI+mXKXuVHOSzPtKCDY94FgwriwpuiHKjxhLfEGTAKMK/Ztx6hi8Pa+iMqLRx7MaGClKzrLMmFYPY8TY2oPMmCUGFS4pcWtZSKjhZNZWVKTSMFjT7ndGEx6elGo3cY+6JDMa5orc7GM2SpAGqmOOvAK5vHUZM43UP0YMk6ekRpy4kj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(4326008)(8676002)(83380400001)(36756003)(186003)(6486002)(966005)(508600001)(54906003)(31696002)(316002)(86362001)(66946007)(5660300002)(38100700002)(66556008)(53546011)(26005)(2616005)(31686004)(30864003)(6506007)(2906002)(6512007)(107886003)(7416002)(8936002)(9686003)(6666004)(525324003)(48020200002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1B4VlFZUjJFVEZJQW5PNUdkdFJwdkd6WWhzNE8rNjczcmJsMTQ1SVpCQ0tU?=
 =?utf-8?B?RE9aYkE4enVrMGU1MzVWOEZmMklEM2FBb044bWNXdWluSU9ONFJ2cjV3empS?=
 =?utf-8?B?T1Q1TlovWFVDSXBRVE4xWklicUF4bGlDZ2pNS0hlOGtlNWNGZ3VraXJOb0gw?=
 =?utf-8?B?QWx1WUYwR2ROMjYvMWpjRTQ3MmhoOXpTaDZZOU5OVVV1MHV2S2IrYlNRZGM0?=
 =?utf-8?B?WHlyMEpFbGZhK29iT01OUG9iMklDL08wMU1SdURXTklWQjFhdHVtbzl1SEVN?=
 =?utf-8?B?SUltQ3l5M3RpWVBrbTJNZjdLaFZkTTlNVFVXay9mMVNuZnJKbHhLeWJWTlFG?=
 =?utf-8?B?a21YMUVldHc5Z3NHSStzcXFoSllTOExOSUxQc3RqUUpZSTRFc1IveS9pWHVW?=
 =?utf-8?B?OVVQL2FtdVdIR3B1N3NMeENINkttREFNbUJEZldCZ09ZLzhRQS9ra09qMmQv?=
 =?utf-8?B?ckU0VW5sWUFoZkdrRDd6allMRUIwdHJiTkJhNnVCVVl5ZHpCcy9MN2QxUTJM?=
 =?utf-8?B?K25uVzlybjlCZXR5NHkrN0pRMU9LNWJybG5wRjZHd3pDd2Zwbm8xd2dyYVNV?=
 =?utf-8?B?bUVHOGJlQ3hiUW8rSEkvQ1hpQUM2RmRPTWU1V3gwc285SW1GaXBJb0t2L09u?=
 =?utf-8?B?L3pRMmRlWHJWR0FMOEtQMnhNMVN1SE1mNEJWZGV2RGdJSFRvMGRvdnZpUTBI?=
 =?utf-8?B?WnhCaTBiczBURnpXYmVLbXhYaExIYllYcVg4ZVlQSCszMTVYOVJ0UWdLWGxw?=
 =?utf-8?B?S0l1NVRTTzZvRi92WVZLdHJXS2NINTRFV1J3WE8yZGJvK09UK2lPNEVQRUIv?=
 =?utf-8?B?UTBTTEFPYlNxTkJzOXBiY2tyZlpqVDBuTll6MndwRkJ5aE1PbGVBVFFhdVFx?=
 =?utf-8?B?RWgxNDMwOHdmb0JSY1RaVEZwMEpiNjY1RlFDSm9PUUlTQWVvTVd5K1B2N0k4?=
 =?utf-8?B?SzV2UnBPT1ozclE5TGRJMTU1cWNBN0VxSFoxdFlybXNBeGxOR3ZjdkxlTTFR?=
 =?utf-8?B?RkVIVmlLYU9lWkNsNG40SHdUUjNvTmpnTXltcUltNzZSRU1TeXBUVVc4N0g5?=
 =?utf-8?B?cDEvSFNOMm5kUG1xUllUc1JHUXlTZ01nM0loY3oyQ2ozTWcxd1FFOGh3SDVa?=
 =?utf-8?B?TmlXWEhJbVJsc0pEemJGbkdCb3NrWk45bEl3YXhDNTc2YjlrSHJrR0NkbzJy?=
 =?utf-8?B?NWpUUFZJUlR3c3FmVW9tTjVVdytid3poNXdMR2JrSVlUWnRrM3F3ejM4bU9Z?=
 =?utf-8?B?RUJuSDJ3ellHeHZpcDlDb05QRk5tUUp2TUhCb0ZKT1gyU2ZQN2UweHZTREN5?=
 =?utf-8?B?NzlqdG4wUlZmQ2RPb09uemhZRzVQcVdaSFpIVWNYOWxUdjZYNy9jOVZlUVRx?=
 =?utf-8?B?aGtnZWRKcHBuY3lXZ04yYTdUSVpvYjJ0dWk0VTZaQjNxVnNXVDJUek1CdjYz?=
 =?utf-8?B?VFMwM2FxNjBMVXNGZDFQVHJtN2hOL3RLNTZnZGdvUzU0azFmVjRhTFNuOHNF?=
 =?utf-8?B?UlpqTlFReW9hTXVJanhFQXhpNFozTEdSU2F0TlI2VXBPc1FDUDlCdFljUVoz?=
 =?utf-8?B?UVdiNTJDdFFJY0c4d2d4OC80VGc3VWZ2VlFQSmJZbkJieVkyTzJScVpXa3p3?=
 =?utf-8?B?R1UwYUFuTkRiQXY1THJHQWozU1RoTGZLYTJnMStEa3hjVXpKREJ4SVpsbTdS?=
 =?utf-8?B?K3dzR3dubVRUcEpva0x3V3ZoVHZRRmx1MlBpL0ZWUUZUd2ZVR1hlSE9UblIx?=
 =?utf-8?B?ZmpYNzM4YmZreUs4VnVYaVhTQ1h0eEtjM1NnYjUrSmpSYXRTVXMyaUVGWFNn?=
 =?utf-8?B?RUE2Z2dLMEhDUk5nV0l5Z3lESkFlWFlGeUYzWkNkNkp6NjJRMXlJZDNhalJP?=
 =?utf-8?B?UlpqT1RMZ2lPbWVOa0MzK0NjUGJZNEljcStIUy9hK2JmR3RGOUhNOFJ2dU9S?=
 =?utf-8?B?RXFkVWVUaUdqYzNrZFFoYjBIVE1uN1NCeng4K1g2Vlhjd3VEUEJROFNxWjVN?=
 =?utf-8?B?ZnhyQjErM3dod3FpT2ZjTHR0eVYyVVkvV0JWN0tXd1R3M2NDbmNhMHJsT3FB?=
 =?utf-8?B?ellRMHNQZjBwbllOWHFMYmN4cGNSUVFvNG1qeVBTeTdNVnpPcDBSRFpMMmw4?=
 =?utf-8?B?T0dLaHE0Qi8ydVFPcVZZU0hXWE1QY1JQZHd5MEVVemE5ZVJOY1BXNEJ1Vzla?=
 =?utf-8?B?dTZFbmR0Nm5ENENOZURMOHQxNE9jb0VZL1A3UFlENjN1RnR5QlhEZGZZTFdR?=
 =?utf-8?B?d2lsSXUvMmhWVXNuTm1wR3dWUHRqUTR4UU1yQ0w0Z3B2Q0NkTDRoODVZSTY3?=
 =?utf-8?B?ZjdFRytQVFc4Niszd3NLcStwY0lJMjBNWUJPSDFXTWJIQngvcjBjaXBibkVh?=
 =?utf-8?Q?bILrGzLFaOpoU+MA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a6e519-1719-4d45-c3d6-08da27ab6ec6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 17:37:28.2131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d47qOo/zxcnW9IlzkDi525rCoQZ4tEoEdaWol4AL9hknV+Y7zQ/f8xwM9JCP9HxbO3Mj5z906uzZjo/3s1phwcKeu2O3uu66gglpxo1y4O0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3454
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_05:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260111
X-Proofpoint-GUID: j1JOjLWB3IjcxLqaTb6VIHvfi7bFd-dN
X-Proofpoint-ORIG-GUID: j1JOjLWB3IjcxLqaTb6VIHvfi7bFd-dN
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 3:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.36 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 5.15.36-rc1
> 
> Alex Elder <elder@linaro.org>
>      arm64: dts: qcom: add IPA qcom,qmp property
> 
> Khazhismel Kumykov <khazhy@google.com>
>      block/compat_ioctl: fix range check in BLKGETSIZE
> 
> Tudor Ambarus <tudor.ambarus@microchip.com>
>      spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller
> 
> Ye Bin <yebin10@huawei.com>
>      jbd2: fix a potential race while discarding reserved buffers after an abort
> 
> Florian Westphal <fw@strlen.de>
>      netfilter: nft_ct: fix use after free when attaching zone template
> 
> Theodore Ts'o <tytso@mit.edu>
>      ext4: force overhead calculation if the s_overhead_cluster makes no sense
> 
> Theodore Ts'o <tytso@mit.edu>
>      ext4: fix overhead calculation to account for the reserved gdt blocks
> 
> wangjianjian (C) <wangjianjian3@huawei.com>
>      ext4, doc: fix incorrect h_reserved size
> 
> Tadeusz Struk <tadeusz.struk@linaro.org>
>      ext4: limit length to bitmap_maxbytes - blocksize in punch_hole
> 
> Ye Bin <yebin10@huawei.com>
>      ext4: fix use-after-free in ext4_search_dir
> 
> Ye Bin <yebin10@huawei.com>
>      ext4: fix symlink file size not match to file content
> 
> Darrick J. Wong <djwong@kernel.org>
>      ext4: fix fallocate to use file_modified to update permissions consistently
> 
> Florian Westphal <fw@strlen.de>
>      netfilter: conntrack: avoid useless indirection during conntrack destruction
> 
> Florian Westphal <fw@strlen.de>
>      netfilter: conntrack: convert to refcount_t api
> 
> Mingwei Zhang <mizhang@google.com>
>      KVM: SVM: Flush when freeing encrypted pages even on SME_COHERENT CPUs
> 
> Sean Christopherson <seanjc@google.com>
>      KVM: nVMX: Defer APICv updates while L2 is active until L1 is active
> 
> Sean Christopherson <seanjc@google.com>
>      KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation to fix a race
> 
> Like Xu <likexu@tencent.com>
>      KVM: x86/pmu: Update AMD PMC sample period to fix guest NMI-watchdog
> 
> Rob Herring <robh@kernel.org>
>      arm_pmu: Validate single/group leader events
> 
> Sergey Matyukevich <sergey.matyukevich@synopsys.com>
>      ARC: entry: fix syscall_trace_exit argument
> 
> Sasha Neftin <sasha.neftin@intel.com>
>      e1000e: Fix possible overflow in LTR decoding
> 
> Xiaomeng Tong <xiam0nd.tong@gmail.com>
>      ASoC: soc-dapm: fix two incorrect uses of list iterator
> 
> Mario Limonciello <mario.limonciello@amd.com>
>      gpio: Request interrupts after IRQ is initialized
> 
> Paolo Valerio <pvalerio@redhat.com>
>      openvswitch: fix OOB access in reserve_sfa_size()
> 
> Max Filippov <jcmvbkbc@gmail.com>
>      xtensa: fix a7 clobbering in coprocessor context load/store
> 
> Guo Ren <guoren@linux.alibaba.com>
>      xtensa: patch_text: Fixup last cpu should be master
> 
> Leo Yan <leo.yan@linaro.org>
>      perf report: Set PERF_SAMPLE_DATA_SRC bit for Arm SPE event
> 
> Leo Yan <leo.yan@linaro.org>
>      perf script: Always allow field 'data_src' for auxtrace
> 
> Athira Rajeev <atrajeev@linux.vnet.ibm.com>
>      powerpc/perf: Fix power10 event alternatives
> 
> Athira Rajeev <atrajeev@linux.vnet.ibm.com>
>      powerpc/perf: Fix power9 event alternatives
> 
> Miaoqian Lin <linmq006@gmail.com>
>      drm/vc4: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage
> 
> Alexey Kardashevskiy <aik@ozlabs.ru>
>      KVM: PPC: Fix TCE handling for VFIO
> 
> Dave Stevenson <dave.stevenson@raspberrypi.com>
>      drm/panel/raspberrypi-touchscreen: Initialise the bridge in prepare
> 
> Dave Stevenson <dave.stevenson@raspberrypi.com>
>      drm/panel/raspberrypi-touchscreen: Avoid NULL deref if not initialised
> 
> Zhipeng Xie <xiezhipeng1@huawei.com>
>      perf/core: Fix perf_mmap fail when CONFIG_PERF_USE_VMALLOC enabled
> 
> kuyo chang <kuyo.chang@mediatek.com>
>      sched/pelt: Fix attach_entity_load_avg() corner case
> 
> Tom Rix <trix@redhat.com>
>      scsi: sr: Do not leak information in ioctl
> 
> Miaoqian Lin <linmq006@gmail.com>
>      Input: omap4-keypad - fix pm_runtime_get_sync() error checking
> 
> Manuel Ullmann <labre@posteo.de>
>      net: atlantic: invert deep par in pm functions, preventing null derefs
> 
> Kevin Groeneveld <kgroeneveld@lenbrook.com>
>      dmaengine: imx-sdma: fix init of uart scripts
> 
> Xiaomeng Tong <xiam0nd.tong@gmail.com>
>      dma: at_xdmac: fix a missing check on list iterator
> 
> Zheyu Ma <zheyuma97@gmail.com>
>      ata: pata_marvell: Check the 'bmdma_addr' beforing reading
> 
> Alistair Popple <apopple@nvidia.com>
>      mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()
> 
> Nico Pache <npache@redhat.com>
>      oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup
> 
> Christophe Leroy <christophe.leroy@csgroup.eu>
>      mm, hugetlb: allow for "high" userspace addresses
> 
> Shakeel Butt <shakeelb@google.com>
>      memcg: sync flush only if periodic flush is delayed
> 
> Xu Yu <xuyu@linux.alibaba.com>
>      mm/memory-failure.c: skip huge_zero_page in memory_failure()
> 
> Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
>      EDAC/synopsys: Read the error count from the correct register
> 
> Christoph Hellwig <hch@lst.de>
>      nvme-pci: disable namespace identifiers for Qemu controllers
> 
> Christoph Hellwig <hch@lst.de>
>      nvme-pci: disable namespace identifiers for the MAXIO MAP1002/1202
> 
> Christoph Hellwig <hch@lst.de>
>      nvme: add a quirk to disable namespace identifiers
> 
> NeilBrown <neilb@suse.de>
>      VFS: filename_create(): fix incorrect intent.
> 
> Mikulas Patocka <mpatocka@redhat.com>
>      stat: fix inconsistency between struct stat and struct compat_stat
> 
> Mike Christie <michael.christie@oracle.com>
>      scsi: qedi: Fix failed disconnect handling
> 
> Mike Christie <michael.christie@oracle.com>
>      scsi: iscsi: Fix NOP handling during conn recovery
> 
> Mike Christie <michael.christie@oracle.com>
>      scsi: iscsi: Merge suspend fields
> 
> Mike Christie <michael.christie@oracle.com>
>      scsi: iscsi: Release endpoint ID when its freed
> 
> Tomas Melin <tomas.melin@vaisala.com>
>      net: macb: Restart tx only if queue pointer is lagging
> 
> Xiaoke Wang <xkernel.wang@foxmail.com>
>      drm/msm/mdp5: check the return of kzalloc()
> 
> Lv Ruyi <lv.ruyi@zte.com.cn>
>      dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()
> 
> Borislav Petkov <bp@alien8.de>
>      brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant
> 
> Borislav Petkov <bp@suse.de>
>      mt76: Fix undefined behavior due to shift overflowing the constant
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>      net: atlantic: Avoid out-of-bounds indexing
> 
> David Howells <dhowells@redhat.com>
>      cifs: Check the IOCB_DIRECT flag, not O_DIRECT
> 
> Hongbin Wang <wh_bin@126.com>
>      vxlan: fix error return code in vxlan_fdb_append
> 
> Rob Herring <robh@kernel.org>
>      arm64: dts: imx: Fix imx8*-var-som touchscreen property sizes
> 
> Xiaoke Wang <xkernel.wang@foxmail.com>
>      drm/msm/disp: check the return value of kzalloc()
> 
> Borislav Petkov <bp@suse.de>
>      ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
> 
> Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>      platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative
> 
> Sameer Pujar <spujar@nvidia.com>
>      reset: tegra-bpmp: Restore Handle errors in BPMP response
> 
> Heiner Kallweit <hkallweit1@gmail.com>
>      reset: renesas: Check return value of reset_control_deassert()
> 
> Kees Cook <keescook@chromium.org>
>      ARM: vexpress/spc: Avoid negative array index when !SMP
> 
> Muchun Song <songmuchun@bytedance.com>
>      arm64: mm: fix p?d_leaf()
> 
> Ido Schimmel <idosch@nvidia.com>
>      selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets
> 
> Dave Jiang <dave.jiang@intel.com>
>      dmaengine: idxd: skip clearing device context when device is read-only
> 
> Dave Jiang <dave.jiang@intel.com>
>      dmaengine: idxd: add RO check for wq max_transfer_size write
> 
> Dave Jiang <dave.jiang@intel.com>
>      dmaengine: idxd: add RO check for wq max_batch_size write
> 
> Kevin Hao <haokexin@gmail.com>
>      net: stmmac: Use readl_poll_timeout_atomic() in atomic state
> 
> José Roberto de Souza <jose.souza@intel.com>
>      drm/i915/display/psr: Unset enable_psr2_sel_fetch if other checks in intel_psr2_config_valid() fails
> 
> Eric Dumazet <edumazet@google.com>
>      netlink: reset network and mac headers in netlink_dump()
> 
> Vladimir Oltean <vladimir.oltean@nxp.com>
>      net: mscc: ocelot: fix broken IP multicast flooding
> 
> Kurt Kanzenbach <kurt@linutronix.de>
>      net: dsa: hellcreek: Calculate checksums in tagger
> 
> Oliver Hartkopp <socketcan@hartkopp.net>
>      can: isotp: stop timeout monitoring when no first frame was sent
> 
> Eric Dumazet <edumazet@google.com>
>      ipv6: make ip6_rt_gc_expire an atomic_t
> 
> David Ahern <dsahern@kernel.org>
>      l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu
> 
> Eric Dumazet <edumazet@google.com>
>      net/sched: cls_u32: fix possible leak in u32_init_knode()
> 
> Stephen Hemminger <stephen@networkplumber.org>
>      net: restore alpha order to Ethernet devices in config
> 
> Peilin Ye <peilin.ye@bytedance.com>
>      ip6_gre: Fix skb_under_panic in __gre6_xmit()
> 
> Peilin Ye <peilin.ye@bytedance.com>
>      ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
> 
> Hangbin Liu <liuhangbin@gmail.com>
>      net/packet: fix packet_sock xmit return value checking
> 
> Tony Lu <tonylu@linux.alibaba.com>
>      net/smc: Fix sock leak when release after smc_shutdown()
> 
> David Howells <dhowells@redhat.com>
>      rxrpc: Restore removed timer deletion
> 
> Kai Vehmanen <kai.vehmanen@linux.intel.com>
>      ALSA: hda/hdmi: fix warning about PCM count when used with SOF
> 
> Vinicius Costa Gomes <vinicius.gomes@intel.com>
>      igc: Fix suspending when PTM is active
> 
> Sasha Neftin <sasha.neftin@intel.com>
>      igc: Fix BUG: scheduling while atomic
> 
> Sasha Neftin <sasha.neftin@intel.com>
>      igc: Fix infinite loop in release_swfw_sync
> 
> Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
>      spi: cadence-quadspi: fix incorrect supports_op() return value
> 
> Sabrina Dubroca <sd@queasysnail.net>
>      esp: limit skb_page_frag_refill use to a single page
> 
> Allen-KH Cheng <allen-kh.cheng@mediatek.com>
>      spi: spi-mtk-nor: initialize spi controller after resume
> 
> Herve Codina <herve.codina@bootlin.com>
>      dmaengine: dw-edma: Fix unaligned 64bit access
> 
> zhangqilong <zhangqilong3@huawei.com>
>      dmaengine: mediatek:Fix PM usage reference leak of mtk_uart_apdma_alloc_chan_resources
> 
> Miaoqian Lin <linmq006@gmail.com>
>      dmaengine: imx-sdma: Fix error checking in sdma_event_remap
> 
> Dave Jiang <dave.jiang@intel.com>
>      dmaengine: idxd: fix device cleanup on disable
> 
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>      ASoC: codecs: wcd934x: do not switch off SIDO Buck when codec is in use
> 
> Miaoqian Lin <linmq006@gmail.com>
>      ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component
> 
> Miaoqian Lin <linmq006@gmail.com>
>      ASoC: rk817: Use devm_clk_get() in rk817_platform_probe
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: topology: Correct error handling in soc_tplg_dapm_widget_create()
> 
> Mark Brown <broonie@kernel.org>
>      ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek
> 
> Tim Crawford <tcrawford@system76.com>
>      ALSA: hda/realtek: Add quirk for Clevo NP70PNP
> 
> Takashi Iwai <tiwai@suse.de>
>      ALSA: usb-audio: Clear MIDI port active flag after draining
> 
> Eric Dumazet <edumazet@google.com>
>      net/sched: cls_u32: fix netns refcount changes in u32_change()
> 
> Peter Wang <peter.wang@mediatek.com>
>      scsi: ufs: core: scsi_get_lba() error fix
> 
> Bob Peterson <rpeterso@redhat.com>
>      gfs2: assign rgrp glock before compute_bitstructs
> 
> Marco Elver <elver@google.com>
>      mm, kfence: support kmem_dump_obj() for KFENCE objects
> 
> Adrian Hunter <adrian.hunter@intel.com>
>      perf tools: Fix segfault accessing sample_id xyarray
> 
> Xiongwei Song <sxwjean@gmail.com>
>      mm: page_alloc: fix building error on -Werror=array-compare
> 
> Kees Cook <keescook@chromium.org>
>      etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
> 
> Anshuman Khandual <anshuman.khandual@arm.com>
>      arm64/mm: drop HAVE_ARCH_PFN_VALID
> 
> Mike Rapoport <rppt@kernel.org>
>      dma-mapping: remove bogus test for pfn_valid from dma_map_resource
> 
> Darrick J. Wong <djwong@kernel.org>
>      xfs: return errors in xfs_fs_sync_fs
> 
> Darrick J. Wong <djwong@kernel.org>
>      vfs: make sync_filesystem return errors from ->sync_fs
> 
> Christoph Hellwig <hch@lst.de>
>      block: simplify the block device syncing code
> 
> Christoph Hellwig <hch@lst.de>
>      block: remove __sync_blockdev
> 
> Christoph Hellwig <hch@lst.de>
>      fs: remove __sync_filesystem
> 
> 
> -------------
> 
> Diffstat:
> 
>   Documentation/filesystems/ext4/attributes.rst      |  2 +-
>   Makefile                                           |  4 +-
>   arch/arc/kernel/entry.S                            |  1 +
>   arch/arm/mach-vexpress/spc.c                       |  2 +-
>   arch/arm64/Kconfig                                 |  1 -
>   arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi  |  8 +--
>   arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi  |  8 +--
>   arch/arm64/boot/dts/qcom/sc7180.dtsi               |  2 +
>   arch/arm64/boot/dts/qcom/sc7280.dtsi               |  2 +
>   arch/arm64/boot/dts/qcom/sm8350.dtsi               |  2 +
>   arch/arm64/include/asm/page.h                      |  1 -
>   arch/arm64/include/asm/pgtable.h                   |  4 +-
>   arch/arm64/mm/init.c                               | 37 -----------
>   arch/powerpc/kvm/book3s_64_vio.c                   | 45 +++++++-------
>   arch/powerpc/kvm/book3s_64_vio_hv.c                | 44 ++++++-------
>   arch/powerpc/perf/power10-pmu.c                    |  2 +-
>   arch/powerpc/perf/power9-pmu.c                     |  8 +--
>   arch/x86/include/asm/compat.h                      |  6 +-
>   arch/x86/kvm/pmu.h                                 |  9 +++
>   arch/x86/kvm/svm/pmu.c                             |  1 +
>   arch/x86/kvm/svm/sev.c                             |  9 ++-
>   arch/x86/kvm/vmx/nested.c                          |  5 ++
>   arch/x86/kvm/vmx/pmu_intel.c                       |  8 +--
>   arch/x86/kvm/vmx/vmx.c                             |  5 ++
>   arch/x86/kvm/vmx/vmx.h                             |  1 +
>   arch/x86/kvm/x86.c                                 | 15 ++++-
>   arch/xtensa/kernel/coprocessor.S                   |  4 +-
>   arch/xtensa/kernel/jump_label.c                    |  2 +-
>   block/bdev.c                                       | 28 ++++++---
>   block/ioctl.c                                      |  2 +-
>   drivers/ata/pata_marvell.c                         |  2 +
>   drivers/dma/at_xdmac.c                             | 12 ++--
>   drivers/dma/dw-edma/dw-edma-v0-core.c              |  7 ++-
>   drivers/dma/idxd/device.c                          |  6 +-
>   drivers/dma/idxd/sysfs.c                           |  6 ++
>   drivers/dma/imx-sdma.c                             | 32 +++++-----
>   drivers/dma/mediatek/mtk-uart-apdma.c              |  9 ++-
>   drivers/edac/synopsys_edac.c                       | 16 +++--
>   drivers/gpio/gpiolib.c                             |  4 +-
>   drivers/gpu/drm/i915/display/intel_psr.c           | 38 +++++++-----
>   drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  3 +
>   drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c  |  2 +
>   .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  | 13 +++-
>   drivers/gpu/drm/vc4/vc4_dsi.c                      |  2 +-
>   drivers/input/keyboard/omap4-keypad.c              |  2 +-
>   drivers/net/ethernet/Kconfig                       | 26 ++++----
>   drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  8 +--
>   .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  8 +--
>   drivers/net/ethernet/aquantia/atlantic/aq_vec.c    | 24 ++++----
>   drivers/net/ethernet/cadence/macb_main.c           |  8 +++
>   drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 ++-
>   drivers/net/ethernet/intel/e1000e/ich8lan.c        |  4 +-
>   drivers/net/ethernet/intel/igc/igc_i225.c          | 11 +++-
>   drivers/net/ethernet/intel/igc/igc_phy.c           |  4 +-
>   drivers/net/ethernet/intel/igc/igc_ptp.c           | 15 ++++-
>   drivers/net/ethernet/mscc/ocelot.c                 |  2 +
>   .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  4 +-
>   drivers/net/vxlan.c                                |  4 +-
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
>   drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |  2 +-
>   drivers/nvme/host/core.c                           | 24 ++++++--
>   drivers/nvme/host/nvme.h                           |  5 ++
>   drivers/nvme/host/pci.c                            |  9 ++-
>   drivers/perf/arm_pmu.c                             | 10 ++-
>   drivers/platform/x86/samsung-laptop.c              |  2 -
>   drivers/reset/reset-rzg2l-usbphy-ctrl.c            |  4 +-
>   drivers/reset/tegra/reset-bpmp.c                   |  9 ++-
>   drivers/scsi/bnx2i/bnx2i_hwi.c                     |  2 +-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c                   |  2 +-
>   drivers/scsi/cxgbi/libcxgbi.c                      |  6 +-
>   drivers/scsi/libiscsi.c                            | 27 ++++----
>   drivers/scsi/libiscsi_tcp.c                        |  2 +-
>   drivers/scsi/qedi/qedi_iscsi.c                     | 69 ++++++++++-----------
>   drivers/scsi/scsi_transport_iscsi.c                | 71 +++++++++++----------
>   drivers/scsi/sr_ioctl.c                            | 15 ++++-
>   drivers/scsi/ufs/ufshcd.c                          |  5 +-
>   drivers/spi/atmel-quadspi.c                        |  3 +
>   drivers/spi/spi-cadence-quadspi.c                  | 19 +++++-
>   drivers/spi/spi-mtk-nor.c                          | 12 +++-
>   fs/cifs/cifsfs.c                                   |  2 +-
>   fs/ext4/ext4.h                                     |  6 +-
>   fs/ext4/extents.c                                  | 32 +++++++---
>   fs/ext4/inode.c                                    | 18 +++++-
>   fs/ext4/namei.c                                    |  4 +-
>   fs/ext4/page-io.c                                  |  4 +-
>   fs/ext4/super.c                                    | 19 ++++--
>   fs/gfs2/rgrp.c                                     |  9 +--
>   fs/hugetlbfs/inode.c                               |  9 +--
>   fs/internal.h                                      | 11 ----
>   fs/jbd2/commit.c                                   |  4 +-
>   fs/namei.c                                         | 22 +++----
>   fs/stat.c                                          | 19 +++---
>   fs/sync.c                                          | 72 +++++++++-------------
>   fs/xfs/xfs_super.c                                 |  6 +-
>   include/linux/blkdev.h                             |  9 +++
>   include/linux/etherdevice.h                        |  5 +-
>   include/linux/kfence.h                             | 24 ++++++++
>   include/linux/memcontrol.h                         |  5 ++
>   include/linux/netfilter/nf_conntrack_common.h      | 10 +--
>   include/linux/sched.h                              |  1 +
>   include/linux/sched/mm.h                           |  8 +++
>   include/net/esp.h                                  |  2 -
>   include/net/netfilter/nf_conntrack.h               |  8 ++-
>   include/net/netns/ipv6.h                           |  4 +-
>   include/scsi/libiscsi.h                            |  9 +--
>   include/scsi/scsi_transport_iscsi.h                |  2 +-
>   kernel/dma/mapping.c                               |  4 --
>   kernel/events/core.c                               |  2 +-
>   kernel/events/internal.h                           |  5 ++
>   kernel/events/ring_buffer.c                        |  5 --
>   kernel/sched/fair.c                                | 10 +--
>   mm/kfence/core.c                                   | 21 -------
>   mm/kfence/kfence.h                                 | 21 +++++++
>   mm/kfence/report.c                                 | 47 ++++++++++++++
>   mm/memcontrol.c                                    | 12 +++-
>   mm/memory-failure.c                                | 13 ++++
>   mm/mmap.c                                          |  8 ---
>   mm/mmu_notifier.c                                  | 14 ++++-
>   mm/oom_kill.c                                      | 54 +++++++++++-----
>   mm/page_alloc.c                                    |  2 +-
>   mm/slab.c                                          |  2 +-
>   mm/slab.h                                          |  2 +-
>   mm/slab_common.c                                   |  9 +++
>   mm/slob.c                                          |  2 +-
>   mm/slub.c                                          |  2 +-
>   mm/workingset.c                                    |  2 +-
>   net/can/isotp.c                                    | 10 ++-
>   net/dsa/tag_hellcreek.c                            |  8 +++
>   net/ipv4/esp4.c                                    |  5 +-
>   net/ipv6/esp6.c                                    |  5 +-
>   net/ipv6/ip6_gre.c                                 | 14 +++--
>   net/ipv6/route.c                                   | 11 ++--
>   net/l3mdev/l3mdev.c                                |  2 +-
>   net/netfilter/nf_conntrack_core.c                  | 38 ++++++------
>   net/netfilter/nf_conntrack_expect.c                |  4 +-
>   net/netfilter/nf_conntrack_netlink.c               |  6 +-
>   net/netfilter/nf_conntrack_standalone.c            |  4 +-
>   net/netfilter/nf_flow_table_core.c                 |  2 +-
>   net/netfilter/nf_synproxy_core.c                   |  1 -
>   net/netfilter/nft_ct.c                             |  9 +--
>   net/netfilter/xt_CT.c                              |  3 +-
>   net/netlink/af_netlink.c                           |  7 +++
>   net/openvswitch/conntrack.c                        |  1 -
>   net/openvswitch/flow_netlink.c                     |  2 +-
>   net/packet/af_packet.c                             | 13 ++--
>   net/rxrpc/net_ns.c                                 |  2 +
>   net/sched/act_ct.c                                 |  1 -
>   net/sched/cls_u32.c                                | 24 +++++---
>   net/smc/af_smc.c                                   |  4 +-
>   sound/pci/hda/patch_hdmi.c                         |  6 +-
>   sound/pci/hda/patch_realtek.c                      |  1 +
>   sound/soc/atmel/sam9g20_wm8731.c                   | 61 ------------------
>   sound/soc/codecs/msm8916-wcd-digital.c             |  9 ++-
>   sound/soc/codecs/rk817_codec.c                     |  2 +-
>   sound/soc/codecs/wcd934x.c                         | 26 +-------
>   sound/soc/soc-dapm.c                               |  6 +-
>   sound/soc/soc-topology.c                           |  4 +-
>   sound/usb/midi.c                                   |  1 +
>   sound/usb/usbaudio.h                               |  2 +-
>   tools/lib/perf/evlist.c                            |  3 +-
>   tools/perf/builtin-report.c                        | 14 +++++
>   tools/perf/builtin-script.c                        |  2 +-
>   .../selftests/drivers/net/mlxsw/vxlan_flooding.sh  | 17 +++++
>   163 files changed, 1037 insertions(+), 702 deletions(-)
> 
> 




Hi,


Please revert :

76723ed1fb89 2021-12-01 | locking/rwsem: Make handoff bit handling more 
consistent

In Linux 5.15.y.

It introduces system hangs running fio test suite :



PID: 3682   TASK: ffff8f489ae34bc0  CPU: 2   COMMAND: "dio/dm-0"
  #0 [fffffe0000083e50] crash_nmi_callback at ffffffff828772b3
  #1 [fffffe0000083e58] nmi_handle at ffffffff82840778
  #2 [fffffe0000083ea0] default_do_nmi at ffffffff8337a1e2
  #3 [fffffe0000083ec8] exc_nmi at ffffffff8337a48d
  #4 [fffffe0000083ef0] end_repeat_nmi at ffffffff8340153b
     [exception RIP: _raw_spin_lock_irq+23]
     RIP: ffffffff8338b2e7  RSP: ffff9c4409b47c78  RFLAGS: 00000046
     RAX: 0000000000000000  RBX: ffff8f489ae34bc0  RCX: 0000000000000000
     RDX: 0000000000000001  RSI: 0000000000000000  RDI: ffff8f47f7b90104
     RBP: ffff9c4409b47d20   R8: 0000000000000000   R9: 0000000000000000
     R10: 0000000000000000  R11: 0000000000000000  R12: ffff8f47f7b90104
     R13: ffff9c4409b47cb0  R14: ffff8f47f7b900f0  R15: 0000000000000000
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <NMI exception stack> ---
  #5 [ffff9c4409b47c78] _raw_spin_lock_irq at ffffffff8338b2e7
  #6 [ffff9c4409b47c78] rwsem_down_write_slowpath at ffffffff82925be9
  #7 [ffff9c4409b47d28] ext4_map_blocks at ffffffffc11c26dc [ext4]
  #8 [ffff9c4409b47d98] ext4_convert_unwritten_extents at 
ffffffffc11ad9e0 [ext4]
  #9 [ffff9c4409b47df0] ext4_dio_write_end_io at ffffffffc11b22aa [ext4]
#10 [ffff9c4409b47e18] iomap_dio_complete at ffffffff82c135b5
#11 [ffff9c4409b47e48] iomap_dio_complete_work at ffffffff82c136b7
#12 [ffff9c4409b47e60] process_one_work at ffffffff828d9061
#13 [ffff9c4409b47ea8] rescuer_thread at ffffffff828d97eb
#14 [ffff9c4409b47f10] kthread at ffffffff828e10c7
#15 [ffff9c4409b47f50] ret_from_fork at ffffffff82804cf2






