Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6806D4CEBCC
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 14:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiCFNt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 08:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiCFNt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 08:49:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E8A275F7;
        Sun,  6 Mar 2022 05:48:33 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2268Z3Wt028756;
        Sun, 6 Mar 2022 13:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BmSw2Slul0udLlvNG6wHBCQiSLnnsCJjqiE0NzS7eX8=;
 b=fALsT4+y/u603a8v7eaNqbon9iBx0497dz71srzQQwesB15oQYcyQ8SCIM+vI4dg5i9F
 r5usdH4qjQgAotW07CNo4HY+DIrvg4n4LKLQBuQWt66Boc5gfPRFcxoGOgNzaCDWFdMT
 xa2ldulF7jYkk+YF560EVhylvcdcHsMn8eKkLcOQslpoFOZvK8U98wfcN95iXS9XETKn
 i6PMBXcxFY6oP4lbKCqgcWEjcU/QeWFV49wH1qM8Ccy4Ue6CfIVqgJD5vMeym3Qw+tiq
 MV6NUu/PvkHOSKrAK90KFSLSOy1tF6Zj/blX7vY2AlE2cPKCXXW5ByICIOL6b2fBW9im 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfs9vhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Mar 2022 13:48:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 226DkY3U056552;
        Sun, 6 Mar 2022 13:48:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 3em1agv4dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Mar 2022 13:48:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2YJCL+v8QIaBvWFkdV1/L4xDTXZeSzKTrTq3Inel8JbJqhghhOeU6bJmR5WVNpNAFZzpa1/+VOLS8VmEQEaF8Q9ztcYumuDutPJ6pvBBiA0F6R0SQ30pgMmLGUgEsAJHWMZGANL+ndwXm/P5b5iy79JhkDleI73g0ttpyDv0F21yZT0W0enb1O4nE5k3xLQ4UN/etrDQIIpBUEzdZP4J4WA0k2DsUmoPrf+lll9fQCvPWwIz62mI8UVzzM1O7ox2gCVYVegxnBDcbKEW7RYNhu60ZojIJAxZlwftFbknjxf5/TA+OHWJEFHO56USf0Tr9PAg95dAVqf48gAMJGjRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmSw2Slul0udLlvNG6wHBCQiSLnnsCJjqiE0NzS7eX8=;
 b=IafWKHEndMxhuY7w9wahKYCWBfwJjb+AdjhXxzuovsUSlAzW1G2P1cbLTDh1u8CBP7Pd1wyCQN5B0nQFIh0Y3sN7pCWhvEs3cV2zLJAVNyIJmhLeTMqqrF3ZmsHRsFlovJ23bkNUMqEGYdgHyGRAkmAwgdm+UL87tbZ0b+2bdTad1N6W52LX5VMUCKzXTsBWmfPEyYK2loSMV4ocpAL73QqKxmweivICHsFUMDD1SuspsAQ7dgjvujEKG/gIlAMxKeWi10yWV3J6+dpm2w5vaVNU9cpn8/rjTgYi7KANTek+tfWpdWY6VH8niTCSX+48Q06iv+lAS6Vogkh4/uMMRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmSw2Slul0udLlvNG6wHBCQiSLnnsCJjqiE0NzS7eX8=;
 b=q3nEK0pfV6hbM9Gz7d8/O06zoGW+GTuXCJfxDx3keiQ1SIwj3BJP92h7Vm7Z1Et43PTCHvkuwzddQOQ3CdJYGrmdxliVWfBbEmejTlxl7UwzOoP8vXzyV3ABlJRXrxkOvhyED9oJIZn4YfWPCY45tgkJ0prIY9KQmflXaf0seSc=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by SJ0PR10MB5785.namprd10.prod.outlook.com (2603:10b6:a03:3d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sun, 6 Mar
 2022 13:48:22 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d469:7ab:8ae2:1e6f]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d469:7ab:8ae2:1e6f%6]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 13:48:22 +0000
Message-ID: <48a4a70a-909b-ea81-0912-fa16974b813d@oracle.com>
Date:   Sun, 6 Mar 2022 21:48:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH stable-5.15.y] btrfs: fix ENOSPC failure when attempting
 direct IO write into NOCOW range
Content-Language: en-US
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <4d7223dc5a3e02562e48012334f76ed598bc9792.1646313523.git.anand.jain@oracle.com>
 <YiNnK4HMpZSg41Gc@kroah.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <YiNnK4HMpZSg41Gc@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0121.apcprd06.prod.outlook.com
 (2603:1096:1:1d::23) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2eb99da-6402-4ad5-c1d5-08d9ff77faa3
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5785:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5785BF7B427DAA285DEA0D05E5079@SJ0PR10MB5785.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqqAMY1SSalHlpz098i3VoBCO/WaDoPrAOgsav+w9kPPckgWByTEiWwbB9rpByCUj0ZU8TeVY4auTpXh70y+pM/3KCqHhR0vq7mXaYDRi9qg6sBMwesEWP5kRw0ZBYk6aEYApn9eg0qbH7z8KDdn4cpoTq9MxLHnviD2J9X4tKT0+zZm2YGGdiy2alSZfafjm+/PJZYUM8xSfEQx41WE7iBGfwkgW3OHZRfn3SJ48AV7nPnJtrt9jhCo5VyrzsTU6NbyTjab7Hw04dBbt5SkoOzkUvY3qb5Du18IHMyzKDTsaHTYbAnzrl9b9QXXjdo7/pGMO5HO8MUfNaeCNe1FHTQAdAqmge2VNHzq6RApuxx4Q/BK8X5Rcx+haPCST/BLQ8PO9T7FOpz/nlTU8OLOVr/o3Q11a5HCdKs982beU/ou/5f4e5NQgI78XXMJgm3PHXnhi2Wtyb/XzuTd7ZeSJZsIMJFrN/AoGm+ydvCgURfQJd/l+RKBoLi/eZYSnkxBAuNfwYxRtGjiplG90uIliNaR9PgTOsNnGzJVsKkyfF8/GXMKcdf8LT3h6pVuqwgEy5YEf/tsmZiLe3e+JpEb8/KTaETBCms67xZMKQjtbhTIhznnBY2PKRRrDcgT3PmYyc3/bhbfhfNqNAebAlAtzmwld93E0ct5FDTgPBmyiG3fbG5Ost87N89Femalu0pBawWydCH2APy3rbzrzHzuuZkX3xpxnTLqrmrWVRbuI70=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(31686004)(5660300002)(53546011)(8676002)(4326008)(6506007)(26005)(186003)(44832011)(8936002)(2616005)(6916009)(316002)(66476007)(86362001)(66946007)(508600001)(66556008)(6486002)(6512007)(38100700002)(36756003)(6666004)(2906002)(54906003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0JqSTVaTFBwem5qZ0hSMEZndGJNeXZWbDFEQ3BDMmNPS0Z6YkZoVmpEQUFm?=
 =?utf-8?B?cGl1dlZrK09PR1BsOTZSdVVxR0hvMlNwMlcramdjMWpvRzh6dG8rWVVKZUxY?=
 =?utf-8?B?dDZNOXFJdnBQUzg4VjVjN1dmaEZqZ04yVGpUSkNvN2tIOEdzc0w3S2RmU2J1?=
 =?utf-8?B?MkdMcW03VnBRUkdzVXNEa08xWHV6MUpRMm94d3hUYi93Z2xNUkFIalR6K3ky?=
 =?utf-8?B?U1lJSXpMSEQ5Y2Q2SndvcTdXUnhOM2thTk9ta1JqTFgxZGd6bW1xOXl0Sm90?=
 =?utf-8?B?b2hkQW5yaWUxTlMrWlM1WEF4aU5DeldKNjBBVXB2MW1WUnp2bkZpMDZvTVBm?=
 =?utf-8?B?K2E0cXFMejBrQ0tOR3JNbnNNZDhsRTN3MkxtNGtJR2tMUG83UU8zSVlYL1FT?=
 =?utf-8?B?T0E2UzJBakkzSFBGakVNbU9Ndkkrc0EzZ2ZhWitKcE9HcDVqQVNwb1V5WVVu?=
 =?utf-8?B?b1YrWnVmRG1VcWNMNGhOWUVWUlVpN2lqZGNiMThqVW82RFZKamxBYzFIUkFo?=
 =?utf-8?B?SUhBMFNPeXpycUJSODFDK3RmZ3RwbDJlaHdlOXl1clpRLzg5STVJdXJqeUt4?=
 =?utf-8?B?T3FEdHZ4c0lQR0U2OGZwL2t0S2h2MjlLbThjdklRMjJiNW1tblFOR2F6K2xK?=
 =?utf-8?B?WGFjSm56bThET1NmVUl0WFhYWWEyaHZMM2s1N2ZvZVB6R3JBck5mNThENkRm?=
 =?utf-8?B?OW1XWjR4WCtQMXU2M0ZZWnNPNGt1UUs4dVZya3g1VnNCeHF3ZjdRbUpmSHBR?=
 =?utf-8?B?M2V1V2h3MnhoTmxwVDhsTXdTQ3Z0cldQWFl5a3RjWHZIbGphNE91UCt6TlBE?=
 =?utf-8?B?bXpWcE8rY1Y5SzFrQ1ZETFlzTXBvUVNaUUNyNWVDTjVmdFZqZ29YQmxmck1m?=
 =?utf-8?B?a05SYkVjeERSbUxFY2pKc2UxdmVTdm9GSU5VVXBGQkNBYUN1ZVZuMEdPY1hW?=
 =?utf-8?B?TkV2Q0hCS2pIaG8weXFHTWE4T0V6RkxYRm9TeXpNU2ExeFpLb0U1elJEVE5a?=
 =?utf-8?B?Yk5NYzBjUFRMQktHbXE3dXIyRTduY05nNlBGUm8xQ283aWFIMnV3bW1kMWZK?=
 =?utf-8?B?K3Z1YmVMSU1ZRktLMHc3YXd0UGxlL25wK25BQk5oSWliTXluMDNUZUVsaGVX?=
 =?utf-8?B?bmlpZ1ZMeTR3MmhoRkh5b1N3OXQvUXlqRlBZcGl2dGgvNUUyd1l0eERrRGhD?=
 =?utf-8?B?U01PV00xbENlNmJMUW5kckFPUm9kNlMzWGUvd01MNkkyeHdPVU1hRUhQeVhk?=
 =?utf-8?B?aHhhU25hTzRscHFPS214NkVoQWdOdzlwVXNDbEt4SDI0WGVJd0hRUXpaS1V6?=
 =?utf-8?B?ZXlwTWtLNWNoQllrNCtFUys5OGgyYTVBcGgrQ1pyZlo1M1BFazhxVXBmYlUz?=
 =?utf-8?B?ejl0SkhNYXhRaEozQW5HQWhyOVp2OW1ROFMyNDhyNXowVXd3Z1l3dTkwdmd1?=
 =?utf-8?B?UWVDcm9wNmJyMW9SY2p6N0ppaFJQS3QrREQ2dDRrMVdyeE1vYk5LN2tQcTBW?=
 =?utf-8?B?R1kxU3FuTHRyaXFNMXhKSWh6QzJ3ZmF1dTRkQ1JIZWhzcENYbml4TnBPZVhx?=
 =?utf-8?B?NzdPUHpjOVVlcmJEeVc5VVpQL01odEtRM0pLRUpscDUyQXl3WjE5ZUl0dUh0?=
 =?utf-8?B?UkZPSmRYL3ByQTFIMFVNY3AwaFN0cUc1UXJ6TS9teHJuS3VuL2V2aG1IeHlW?=
 =?utf-8?B?dXFwZkI5QUgwY3dmUStKcWV4aFhBem1nZXlmTGZMVUk4Qzc4cXJETklYbDhu?=
 =?utf-8?B?U2tUYkt0cGtCenJGMmVMcTdGOVBRK1g2N3NGaEVoaXpIYjhPNTJCQW5UcW8r?=
 =?utf-8?B?NEpqZnVQTmVMUE9NSlBHNnFtTXdkbWRSc2FCZVZjT3VFTkZFN2cwRVpRZFhF?=
 =?utf-8?B?M0RhSnRHNWlzSU9MelZubzRsTzlET1hXaEJ3R0xDNk9aUjFCdFBxbktOdjVt?=
 =?utf-8?B?dnFqNnVhRUE3ZGlwc1lpUTZMYjdiVzV1VjlWR1VXK3JpS0lKU3NUT1FoK3pD?=
 =?utf-8?B?MUZsc1dNRkgrS1lUR2JuRkI4MTc1ZHVweTIvVFVLbDZ5M2U5S3hMYTZNTXpl?=
 =?utf-8?B?Z1VHK0paVmNQcVhRK1dJNzRsRndWSG9yZWh3YlJQdGFUWWlLTkhFK3d3a0lG?=
 =?utf-8?B?T3pyaHFISW5kRmFBSmdQU2hUWEhWL084bGY1Yk1GVnZXUFlVcDdFUStBWTFX?=
 =?utf-8?Q?BfoeLBV9GGJ+//MKVG5PhEA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2eb99da-6402-4ad5-c1d5-08d9ff77faa3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 13:48:22.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPvqEn9myukMylcSXNmFEXNwcw/lDXdEagS1BbNH0/5K3xE/pfTAsqNu2AuVNs0pB3l2keiyrjqClESII0ckYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5785
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10277 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203060093
X-Proofpoint-GUID: sIKmCL0wWDsELHwAwTTPinohevVeU6ar
X-Proofpoint-ORIG-GUID: sIKmCL0wWDsELHwAwTTPinohevVeU6ar
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 05/03/2022 21:35, Greg KH wrote:
> On Thu, Mar 03, 2022 at 09:30:31PM +0800, Anand Jain wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Commit f0bfa76a11e93d0fe2c896fcb566568c5e8b5d3f upstream.
>>
>> When doing a direct IO write against a file range that either has
>> preallocated extents in that range or has regular extents and the file
>> has the NOCOW attribute set, the write fails with -ENOSPC when all of
>> the following conditions are met:
>>
>> 1) There are no data blocks groups with enough free space matching
>>     the size of the write;
>>
>> 2) There's not enough unallocated space for allocating a new data block
>>     group;
>>
>> 3) The extents in the target file range are not shared, neither through
>>     snapshots nor through reflinks.
>>
>> This is wrong because a NOCOW write can be done in such case, and in fact
>> it's possible to do it using a buffered IO write, since when failing to
>> allocate data space, the buffered IO path checks if a NOCOW write is
>> possible.
>>
>> The failure in direct IO write path comes from the fact that early on,
>> at btrfs_dio_iomap_begin(), we try to allocate data space for the write
>> and if it that fails we return the error and stop - we never check if we
>> can do NOCOW. But later, at btrfs_get_blocks_direct_write(), we check
>> if we can do a NOCOW write into the range, or a subset of the range, and
>> then release the previously reserved data space.
>>
>> Fix this by doing the data reservation only if needed, when we must COW,
>> at btrfs_get_blocks_direct_write() instead of doing it at
>> btrfs_dio_iomap_begin(). This also simplifies a bit the logic and removes
>> the inneficiency of doing unnecessary data reservations.
>>
>> The following example test script reproduces the problem:
>>
>>    $ cat dio-nocow-enospc.sh
>>    #!/bin/bash
>>
>>    DEV=/dev/sdj
>>    MNT=/mnt/sdj
>>
>>    # Use a small fixed size (1G) filesystem so that it's quick to fill
>>    # it up.
>>    # Make sure the mixed block groups feature is not enabled because we
>>    # later want to not have more space available for allocating data
>>    # extents but still have enough metadata space free for the file writes.
>>    mkfs.btrfs -f -b $((1024 * 1024 * 1024)) -O ^mixed-bg $DEV
>>    mount $DEV $MNT
>>
>>    # Create our test file with the NOCOW attribute set.
>>    touch $MNT/foobar
>>    chattr +C $MNT/foobar
>>
>>    # Now fill in all unallocated space with data for our test file.
>>    # This will allocate a data block group that will be full and leave
>>    # no (or a very small amount of) unallocated space in the device, so
>>    # that it will not be possible to allocate a new block group later.
>>    echo
>>    echo "Creating test file with initial data..."
>>    xfs_io -c "pwrite -S 0xab -b 1M 0 900M" $MNT/foobar
>>
>>    # Now try a direct IO write against file range [0, 10M[.
>>    # This should succeed since this is a NOCOW file and an extent for the
>>    # range was previously allocated.
>>    echo
>>    echo "Trying direct IO write over allocated space..."
>>    xfs_io -d -c "pwrite -S 0xcd -b 10M 0 10M" $MNT/foobar
>>
>>    umount $MNT
>>
>> When running the test:
>>
>>    $ ./dio-nocow-enospc.sh
>>    (...)
>>
>>    Creating test file with initial data...
>>    wrote 943718400/943718400 bytes at offset 0
>>    900 MiB, 900 ops; 0:00:01.43 (625.526 MiB/sec and 625.5265 ops/sec)
>>
>>    Trying direct IO write over allocated space...
>>    pwrite: No space left on device
>>
>> A test case for fstests will follow, testing both this direct IO write
>> scenario as well as the buffered IO write scenario to make it less likely
>> to get future regressions on the buffered IO case.
>>
>> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/inode.c | 142 ++++++++++++++++++++++++++---------------------
>>   1 file changed, 78 insertions(+), 64 deletions(-)
> 
> A normal "cherry pick" worked here, right?

  Yes. A normal cherry pick worked.

> Also this is needed for 5.16.

  Right. It applies to 5.16 as well.

Thanks, Anand

> 
> thanks,
> 
> greg k-h
