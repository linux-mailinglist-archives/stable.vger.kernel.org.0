Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA544FCEA9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347669AbiDLFQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235023AbiDLFQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:16:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7514134649;
        Mon, 11 Apr 2022 22:14:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C1JwX1014133;
        Tue, 12 Apr 2022 05:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nmZ8Jn6awFhS6grbT1iOCsv4aPGprm9xow7xXqYc3nk=;
 b=wWSZUXyNFfeTUvcvd4EwcKm4oNU/o1wOBwPYhlirUQfZDvIksIJoylkASTGTgjx8x0qy
 tVdvn13ky49wBjFTa4qA32fTKzdWxIOOvtSqjZn8CQKGkrGrFMVzdCjjHadBm08TE6zU
 swQNer/rktlIjc/NCfk1fWo0Pdi1t7qk27Yae9+Zg1CQP+qS1vrME2TlhdswD7nDAIZW
 OXhSUMGdKDQIdiTuo63mJXxGRGdPAKqVBUT6i6J0Ra9oSW4mPuLah81rFtbDG541OhVH
 vJAvrPLj20nEPP1QEbpRORDc0tQHVNZ9tw/+qFHHsdKg20pfTZuz1kzGGO5bu6ec37TW 8g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptwnnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:14:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5BkaB009951;
        Tue, 12 Apr 2022 05:14:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2h4w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:14:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8VyAMmw6Wbiv/V0l0x6xpMTsGjgArexy00Dvv1ytdoHL5riC8jJNfXUdf/sn0tII6Yn2oWxcRsopFzDPTiYMgR7ZnoLuIzIVr5bSsXiOL8J0Y2QC/3gUYY85ADuBI5kF9yjlqCVar7HNE6S2GTNMhPGhjU2GjnEnle+Wcv3TfBSYelzsa9UP0fc549CmGvjUV9fqBrLM9Jiujt/yA3NmlMItqLrMHUxA5ldvUjzBUvyKOePRbocu51fmOvQH2GM2edwwghxz0qpkw69iLLDnyUVb5hM3btwGzJSMPqH7atkeBIP08Uz96VGlopfhW5y/ZFFwVmeVvjFT6bkuDg8qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmZ8Jn6awFhS6grbT1iOCsv4aPGprm9xow7xXqYc3nk=;
 b=ZJsZffaRBOFVhI8nTaa95vGMroxsYHMR+WdpjHwqXOn8Q+IFw4DNfnhMhgkxOLmrUSnO6mINh2WgqDFOUrJHTyjW72nmUdgG1ctF87yRgKKZE9jdfGePDvhzheA4bg3xF/wJcDYBEUvUw+7n/oY6m/JtR/R+OHQhIhkJYaFHAaxsaw2a7GYTiAen9/f3xV/d1WceVvC93CMPQKPYmnMHSUl7jM0e7JU9t9Xnc8x7Q4tcj+i4ZXcBDwsSNemsEUWAx7ckM1X5MFBHgCM1wp+RfZ2ZW5AXZ6l14gkjBMmTWm8QrE6jgitYQUNHFgVv5gWzBgy3w/Hs4kWYYRlNtEfjfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmZ8Jn6awFhS6grbT1iOCsv4aPGprm9xow7xXqYc3nk=;
 b=hUt82oJh69D9tzRvxNkk0W5iM2SqKAuiQcdg8MhZxMHKciy3uWZwiujpnCS5OTHVPZn6KvPtsyjLnvMcu05YDe3wwAzi3Q7dajhhNg6POmJoJDbCORd7o/o3JNQ+uV4mYICqWb5vF3cA1B+Njp8RbkSopuO4ZXTBPKd8x3Uu648=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BYAPR10MB3256.namprd10.prod.outlook.com (2603:10b6:a03:152::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:14:26 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:14:26 +0000
Message-ID: <82b27315-ee40-4a57-3973-5fcdce6ff82b@oracle.com>
Date:   Tue, 12 Apr 2022 13:14:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 00/17 stable-5.15.y] Fix mmap + page fault deadlocks
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Filipe Manana <fdmanana@kernel.org>, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, agruenba@redhat.com
References: <cover.1648636044.git.anand.jain@oracle.com>
 <Ykq9UXXZLTZOJ6N+@debian9.Home>
 <e9805474-f672-3c29-a294-0fce060037b5@oracle.com>
 <YlPdiqAxpS1HJDrc@kroah.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <YlPdiqAxpS1HJDrc@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0144.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::24) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3d08ebe-a656-4883-e6d6-08da1c43502a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3256:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB32568B4186FBA936FF703BEAE5ED9@BYAPR10MB3256.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VWW9oHw3gTCQ9SFfz/QT4qZ5LjtL5jRM1M8A6oahq518lAxnUDOq0xtV/jaSLjZDSwl+zuxdjJbJuzUFJGlU6jKbC08YDxpKFJeiWFvkBz90p+uWj1RJwI8a1OE1CgN/3ze1hAiEpw3eH7fOiYLxY3rZ3B1+tbDCrmN6OYPZsRz1gJWAV2ZWT8nkkpbsOHp0jXhaBYjG5z5B4brdNCLrJYW5C0uVzXQDy5xOBA3g5W/dPmlCNMN8Rv86GMjij6Qy1SvnMfHWB3kCtco/6PwB7VWD6OM3YOGuMPIX9bXtz48iJT90V6OoJn1gsScWa6plC64jZhw4KLnDyOQl9qj8pmdnx+CgCrw7NkV8Ktf1D0A9x7LX4nUOVO1/XzZKemR4/iSbc0CcCfS32lV6TTKavFYxUXEBjrPffGhwd6l85heM6txUCGfgTu57JIDBc39EsVB0uqVe5NjRN/vQG+iUSmS9Mv112jlUNHJbnLW8Y7VY6dchZcLzcvvYcenPA7G6KXGLuDn4UKhTEI7zWsSMGFbSbQfjx1vZzwkm5iBTVhJ8/SUKnHPSQmVYII1Xo/4lWm5KL0WPtAF67UciAV/tywm4kgnlOp3dF9INOTFlvvQKVtq0jQaTdffT8HFEzne1NNVnAhFdGlf+nfIiSQhz3eEjOJj40ZAqVEipMLXxB7qY3cDsXxwab7GU+pzAzvmAaw9QFSo7Jlw7Mpn2qw5difcBWO/Dc9Tvgpi2P6p9gNE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(5660300002)(2906002)(83380400001)(6512007)(31686004)(2616005)(66476007)(44832011)(53546011)(26005)(186003)(6506007)(6666004)(508600001)(66556008)(66946007)(6486002)(86362001)(36756003)(8676002)(4326008)(6916009)(316002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3BNUHhBdXdSTVVEZUFGeXhHQm1Sc3ZIWjNJc2JndXhkeGNDWWovSzVLZ3N3?=
 =?utf-8?B?anpKYitQVHlybGtjUGp2OVFhdzZ1QzN3NXFMaS90TWxvS09xZUxsenEvY1Yr?=
 =?utf-8?B?TWp0ZmZJVnZSa05wQWdHc1NIWjZMa2h4WitEUzBQRnM4YkY0TVJwYmlpbGdQ?=
 =?utf-8?B?UWpNTGp4ODBvRTlBdnZYR0NJb1NLd2R1WFVZM2ttYS9sTGlYZGs4N0Fpc0t1?=
 =?utf-8?B?NHN5STNIaFZhLy8veWMwZTBTMUhmTm5mWFBlNTcvWE5QNmJncUM0Q2RpV25W?=
 =?utf-8?B?Vks2UEhJYTNWbU13ai9iUHYzSzBOcUtqdkN0cWRJQ01ZNXM0cmZvdkJkREZU?=
 =?utf-8?B?Zlc0djY4andRV1lSd0FpSHk3U2VFVTR6UUZ0bmZtU1J0VTliSVVwc05yWXVj?=
 =?utf-8?B?T2F3S3k4SGdOUzU0eis1VTFpNk91RXhkOUg5Q1V0VUpqMmcxQStlcXZGQTRu?=
 =?utf-8?B?NmJUNkdxRHZaZ0VVSWE5emtUQlNJTGdQb1JPekl6Rzk0QzVKNTJvK2FBSGxz?=
 =?utf-8?B?T0lyT1JMU015VzNoa2pFdTNOKzZLMWtDaHFDWm54bXJIZXNHMlhkSGVhRGlO?=
 =?utf-8?B?YlpNNFA0NHVzRUMyZ0cxVW5temNyc3YwVTR2QkFMcWVYaUlpNTcweHcyaXZQ?=
 =?utf-8?B?VkxMelZkaWd5Qkp6SXFYZXRwbGV5RWZicmV0MDM1Nmx6QWVhcG9BNkdTb05V?=
 =?utf-8?B?NU1BKzkvZEdha0ptVVBZT2NldmRCVWdYZkZvYXIyOTliVlRWdmQ2ZkdjbnFL?=
 =?utf-8?B?M3FHNlYxZEwvLzN5dWwvbTdVNFVyOExDc3k4R0t2UGVxWGRFV2xXdmlHNGhS?=
 =?utf-8?B?RWpEeFhWMkV6OFBCVlhYZDNRM0FtVlMwdmJEaWdhalNYdTdtSDFONEhLaEJI?=
 =?utf-8?B?azVHa2N1Ly9KdE5IWEtGYnBPR0N0QW56S1ZrVk5WN1ZMR1ovVmFtdGxoeFJv?=
 =?utf-8?B?SW5CajJGSjFwbmxERnBVOGFsb2lhZURBUmtHZmZDSlVvOFF3YUFwVmkyZkI3?=
 =?utf-8?B?SmVBbWQ5OFJKK1ZyekY5ZlZrdUI5UFpSRTZSMUttYzlpQk1VSDF5aStTNDZT?=
 =?utf-8?B?WTVSbTI0V3c2bTJwYjFuUGhWWmhIenFaM0NCZ0tvZVQxbnhRM1lTcUowbUYr?=
 =?utf-8?B?ZVdhTnovUHU0NE1JMUhOa3lKeUtPR3IraUhzdXBsYzBFUVZjZW9BbGJaanZ4?=
 =?utf-8?B?eERmNTNxYTFENHhrNzh6MFlNcE5wY2Zrek9wV1BBSzFJcWtsSmZlcmJiRXpp?=
 =?utf-8?B?THpBSmJaanFkdVJ2Vzd1ZVpXY3dvc2JNQStSSTNNSmZYbGFEdkRkK3ZSdFZs?=
 =?utf-8?B?a2M4R3JrLzBIczMyS0k2Mmt2Z2o5VlZ1YjIyNjN1SG5MeCtvV3ZVbUVMeEZ0?=
 =?utf-8?B?MW15bmNhTHcyMWh2bmRPbmczK2NINTdZZEtqTTRsbkd3c2RUZWhOQmNpMm5i?=
 =?utf-8?B?cWlkTlFJWFFvTTZla3pvSWczTmd5Q0xrTzIyb2lqZStuaXQzV0FDai81RXBy?=
 =?utf-8?B?bmdzanFFZEFHbzJjWlI0cjMybk5qa2xXUU1wZ2YrZ1BzMVpUZUdVeHV5S1dn?=
 =?utf-8?B?WGFONnJaTWNHVXdjdGVRTFdtdjdVOTdnKzVld1ZjZmpRSUVqenVGYUpubXhz?=
 =?utf-8?B?RDdIUk1pWVdoSVAvT3dPQnlCcndDK0xwNVVlVzFFck82QS9XeWpYVjJPT2JT?=
 =?utf-8?B?WmN6V1VRNVUvdnB4VVVuSTk0TkZiK0lIMlZJbVBYcHg1RGZad1MySlRzM3Er?=
 =?utf-8?B?N1hJL3ZhUVJ6T3RzNURKMno4U1RBSzZtSWxrMHVCK0ZFUVJsRVRiRmF0RWtV?=
 =?utf-8?B?eFlxaW1Ha1lhUGVQN3JFSHU4TEhDMVFnUkhWRlB5UzBNMk5JNWxPdENlMDZH?=
 =?utf-8?B?R2lxbWNCTThVanhnOVpnMnFBWjhTOVlNOHdIbTBEM0JxQkxWSUo3aVhTVW41?=
 =?utf-8?B?Y2hFaU1OaVpDRU15VnhGK21LNVJBL05WQ2JHczJhbW9PcmdPcU90MUUyYWNU?=
 =?utf-8?B?SXdhYTVOaENSeE9LeGFlOWRBS3o4eE53YTYwaFByaDY3bml2bFRoQUdqdGRx?=
 =?utf-8?B?dVVDMHVxaWRiV1BPajdjVi9SemFaZk1LYWVrRXExRnNpZUdDaks3Yi9Pampy?=
 =?utf-8?B?ckcrYzI0WWJBa0xuQXV0QnJPTFZlZ3l1M2QwRjZ5MFFSeURxcC92Y0pFTVRs?=
 =?utf-8?B?YkNDblVWNExDcmJGMk8zT3o1VzdZUk1JUUtZSW82NUhLUmtmN2hsMkJYYWkz?=
 =?utf-8?B?RDRMeFA5SXFsTGlMS1MzK3orRk55UVlUbGpvZEEvYjlVSzhYd25FNkN6WVli?=
 =?utf-8?B?NEhBVStCTWc2TXBUSGN0Wko5dE9lMy9YZldJSWpOdHE5eThHU2NQUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3d08ebe-a656-4883-e6d6-08da1c43502a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:14:26.3014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwhQAG5OmRH1oOTE5tA6SZ8Ki9DKsuZUeSYErKmrSNcetPjifWZO63bKMHqLN3E73Hy/Bme3zDcGNK2u3FdRyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3256
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=934 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120023
X-Proofpoint-ORIG-GUID: 4VeVO-gEQL4-6G8v4TZLgtrrJn68F18y
X-Proofpoint-GUID: 4VeVO-gEQL4-6G8v4TZLgtrrJn68F18y
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/04/2022 15:49, Greg KH wrote:
> On Tue, Apr 05, 2022 at 07:32:11PM +0800, Anand Jain wrote:
>>
>>
>> On 04/04/2022 17:41, Filipe Manana wrote:
>>> On Sat, Apr 02, 2022 at 06:25:37PM +0800, Anand Jain wrote:
>>>> This set fixes a process hang issue in btrfs and gf2 filesystems. When we
>>>> do a direct IO read or write when the buffer given by the user is
>>>> memory-mapped to the file range we are going to do IO, we end up ending
>>>> in a deadlock. This is triggered by the test case generic/647 from
>>>> fstests.
>>>>
>>>> This fix depends on the iov_iter and iomap changes introduced in the
>>>> commit c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2") and they
>>>> are part of this set for stable-5.15.y.
>>>>
>>>> Please note that patch 3/17 in this patchset changes the prototype and
>>>> renames an exported symbol as below. All its references are updated as
>>>> well.
>>>>
>>>> -EXPORT_SYMBOL(iov_iter_fault_in_readable);
>>>> +EXPORT_SYMBOL(fault_in_iov_iter_readable);
>>>>
>>>> Andreas Gruenbacher (15):
>>>>     powerpc/kvm: Fix kvm_use_magic_page
>>>>     gup: Turn fault_in_pages_{readable,writeable} into
>>>>       fault_in_{readable,writeable}
>>>>     iov_iter: Turn iov_iter_fault_in_readable into
>>>>       fault_in_iov_iter_readable
>>>>     iov_iter: Introduce fault_in_iov_iter_writeable
>>>>     gfs2: Add wrapper for iomap_file_buffered_write
>>>>     gfs2: Clean up function may_grant
>>>>     gfs2: Move the inode glock locking to gfs2_file_buffered_write
>>>>     gfs2: Eliminate ip->i_gh
>>>>     gfs2: Fix mmap + page fault deadlocks for buffered I/O
>>>>     iomap: Fix iomap_dio_rw return value for user copies
>>>>     iomap: Support partial direct I/O on user copy failures
>>>>     iomap: Add done_before argument to iomap_dio_rw
>>>>     gup: Introduce FOLL_NOFAULT flag to disable page faults
>>>>     iov_iter: Introduce nofault flag to disable page faults
>>>>     gfs2: Fix mmap + page fault deadlocks for direct I/O
>>>>
>>>> Bob Peterson (1):
>>>>     gfs2: Introduce flag for glock holder auto-demotion
>>>>
>>>> Filipe Manana (1):
>>>>     btrfs: fix deadlock due to page faults during direct IO reads and
>>>>       writes
>>>
>>> If this patchset is backported, then at least the following two commits
>>> must also be backported:
>>>
>>> commit fe673d3f5bf1fc50cdc4b754831db91a2ec10126
>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>>> Date:   Tue Mar 8 11:55:48 2022 -0800
>>>
>>>       mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
>>>
>>> commit ca93e44bfb5fd7996b76f0f544999171f647f93b
>>> Author: Filipe Manana <fdmanana@suse.com>
>>> Date:   Wed Mar 2 11:48:39 2022 +0000
>>>
>>>       btrfs: fallback to blocking mode when doing async dio over multiple extents
>>
>> Thanks for pointing it out.
>>
>>> Maybe there's more that need to be backported. So cc'ing Andreas in
>>> case he's aware of any such other commits.
>>
>> I have scanned through the commits. I didn't find any further Fixes
>> for this series.
>>
>> I am sending these two patches in a new patch set as part2. Instead,
>> if it is better, I am ok to include these and send v2.
> 
> Please rebase the series and send a whole new one as I think there will
> be at least one change you can drop as it has been accepted already, and
> trying to deal with two different patch series is hard for everyone
> involved.
> 

  Sure I will do it. Thanks for pointing it out.

Thx, Anand

> thanks,
> 
> greg k-h
