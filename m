Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2055637ABF8
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 18:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhEKQdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 12:33:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhEKQdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 12:33:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BGF348098417;
        Tue, 11 May 2021 16:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=qWv6aG/E8LXn50TwO8APTmxXH3KakfFAJtJDCvTK8IM=;
 b=MzZVpHw2PguxzkUMBrlEG9dKCRE6TDyuhEL/8PubNDnPu1gj5nAHagBzLzpiVCTTq0rz
 VU845Zkvah8r906kTKPt/j52lPAS4hfGBHFfg9ZgUvPdqEcOeBDmZgtJ1LJ1nwNxIrCA
 Pk1dYDRXGIRoC0VQAE7o1GNj/k+ktyqW/debuviff0JjSn6KOdv9bJgaENUJI7Sxknlj
 BEpLDTkQr/K8N/u6BlPb7bQ4hB8W7YyMJtzdOLV0k7Qxp8Qs7/2IlY4gCxPv8Cxm9cRW
 JB34lIW6Vi5ncvd26UfDUhl06cN+X/nO01h3tlWTMDJueRhfQNk1lKQpCV909EWwuSOk 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmfchs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 16:31:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BGTp09133429;
        Tue, 11 May 2021 16:31:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 38e5pxj58t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 16:31:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiDNtKxQEAzg8mhaBh0bV4hckGSuHJYX8OO/C5+Jj275R3Sn8UTK1ZPvdYzoY8pquoFirMtprRnAxPqjP8PsBCScPS76yF8h5DH/ZJky0t4Spz/F+HbY0xAObOW+Oaz5mX+3eFFqxSLNs3MAPz6HEIqKABD8facMqRYtD/KLjlP0C2s0ajrS3tCkg/qLKGxXOE8WdGgVVLdf/daIrqFUw5Z3kG6b2m1tn0xhDK1CGl+zIXjirtu5b18DKLsPUA0Hk6FrjGD578I2oNIj65f9F2XnkGQCV09jmO6Bz3XHA6K8PEwmi6wGDWMYfqPvN/mRgm0PpuWeQyk6YL24TQLwBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWv6aG/E8LXn50TwO8APTmxXH3KakfFAJtJDCvTK8IM=;
 b=HBKELtuahtHoHN4Jf+UPGyLQ2XooHlOdQGM/gYtj5ad+rpLCAMG6JHRJsBTfuAYJ9PuH7OmTkwKhPAKJhZI0GkKmY86lw4nhCjchWy+iEmQkNzd+6j6G6CUqU7SAeBYhaO6wh/tIQxlbsFUyB4PbzP/2XL8NF38T700Nl8tPKim1GQQDfXx3xCv01UCB4o/L3+/RWv8MWC2Q+O0jnQAiuhkadZXnyqJ3yP7MGARpkNPeecT//hAUdkryWIu/x91EVXB5g9ikx7Gv1BYoKxmI70hXDakCODiVHWep3D7neoIg3ao252F/dfjEenYyNsd9Fh1U1en34RP1r4isy5W7/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWv6aG/E8LXn50TwO8APTmxXH3KakfFAJtJDCvTK8IM=;
 b=0MjzD1CLC4hO2Q9BJZSRRHhyvqBYTvgg2fQ4/Etkty3CF+yeF8Nj8RAlHPanE7PL/vG/opLxG2k40Cy2HD30RADWNdLXSSD/nUlrtaRqLLKoQ2kO8al/vihaduHTb85tKSijJkfgbWm0c46gktBdWYbqb1IeNZ7CSj0siYqADmI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB4251.namprd10.prod.outlook.com (2603:10b6:5:21d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 11 May
 2021 16:31:51 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4108.032; Tue, 11 May 2021
 16:31:51 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Dhaval Giani <dhaval.giani@oracle.com>,
        Dmitry Vyukov <dvyukov@google.com>
From:   George Kennedy <george.kennedy@oracle.com>
Subject: 5.4.y missing upstream commit 4b793acd, causing: WARNING: in
 hsr_addr_subst_dest
Organization: Oracle Corporation
Message-ID: <b61a6d19-2c54-c75b-bf9a-39f5c2b89c6f@oracle.com>
Date:   Tue, 11 May 2021 12:31:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SA0PR11CA0115.namprd11.prod.outlook.com
 (2603:10b6:806:d1::30) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.246] (108.26.147.230) by SA0PR11CA0115.namprd11.prod.outlook.com (2603:10b6:806:d1::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 16:31:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba7dd095-5eb4-4944-9cdd-08d9149a47f8
X-MS-TrafficTypeDiagnostic: DM6PR10MB4251:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB42517A3EB557086B8E5B1ED8E6539@DM6PR10MB4251.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e90aNkogdkQzEl1BpszytzDWwzaZhQaOyEEukqDa+CnWEIihn8AFG0BJht7N02QHEI9Lv1ziOt+1r/vqh/eaGgvsBPuNKrMOCYnjSRq7dRLXpPdOKxrLuf53AgSWQQF5veQABDGNARpxyb0MTnrfD20DmeFLaBzIva/3mCTCml6ghvIWnUPCG1ry0D+1E+zwJeSIoKMSIZu0R5Rc/WG9AFzCqirkZyHeMgFw2L3dEXL20YXexGvTPukjO8yrln0PJvIqSpmFdAaYHPIqvfxnW7c8XCqa9Gmiv3WDPP5XiEEjAdLByJnNaMl7ForZiD3nCZsAYDqA1UcIL8BzDxcLDeDdZGurKABq2tPXZJ7spjt+IqNc783ASsvYcbUQ6xfXJflqj2x6nbCbx+R1zvFAkNpPmPfOhh9en87EP/bcJV/5IBMCG9gd2vfGlxSvCe5Dk4bDZ277gsZJBI0oaQD12Nl8crIrvdORe/TFUamwqV9TE+ecomjdDyVwYzj+c1ZzbwVJ5kgXqXC7Limf5R4S/A6mQvc+/Xww/1Rwee82kRLRtEC64BDzCDD/tIra27wx87NEx9+QPKiGZOCJGvGpJjy1f139F47WORQEnIz82KOo1VLGdsqU7lxfGUNpG10NDWaED8yrsbBWKHLcx213WJe7+pcuvj47mNJDQRr8QB/x1sgK9bljE53Ok2DxiI/XDy97Oe1DT2cFEnZUli00euh4MkKTNVZHsnrvgiE37H1YKS2dC2tVdp6g9fpYJqbKcU4pmXJMOKsofXo9m+2rz8T7+vi5OgOsxpS1fctFHHMIez1GnBG24OQajZ+5+VAlaHJkJ+wgT3ymYL369XcgpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(39860400002)(366004)(38100700002)(966005)(478600001)(36756003)(5660300002)(8676002)(2616005)(86362001)(956004)(8936002)(16576012)(54906003)(6916009)(26005)(4326008)(6486002)(66946007)(16526019)(36916002)(2906002)(31696002)(186003)(66476007)(66556008)(44832011)(83380400001)(31686004)(316002)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1hwWUxWSVJTZC9NNCtieERqYkN1K1V2V2Z1OUhLTzRsdXdnb1h1N1ZLVTNP?=
 =?utf-8?B?U0pkL3V6UTMrUXVrdWpUS0NqWGVmMjFZTWdjRVJERVgwZmdIK0Y1Q0loSWE1?=
 =?utf-8?B?MThUb0wvbXFLNENqbzMrSGVNcllyeU02bFZ5ZGdZekZ4bXpFN0FlTk4zdjNt?=
 =?utf-8?B?c3J4QTJ1V2s1eVpESlROKzZYSlBBa1JrRVpHME1CV3ZNL01mcDd5a1ZRdDU3?=
 =?utf-8?B?bmxFbWkzelpuUnpReSt2clFscUhodVlxNjRLUkhxTUdCUjRBY2JIWXZUN0c1?=
 =?utf-8?B?YUlqb3JDN0h5NGhnTDIraVZKWjh5TTA2SW1uUkdndTh6SVJ0ajRWc2xxdVBu?=
 =?utf-8?B?YU5mSWZnaG4vZTh0eTFiS3cxcDcrc3gxYTYxWlI3SWpHcmhRcnZPbVptOG5V?=
 =?utf-8?B?V0pSMTk1ZWxnOEV1c2NoNDRDTXJ5VnZ1YkhWWmZyV3FXSE9YSnZqM0Y0b21C?=
 =?utf-8?B?ejJpc280aUltcmRDaW9LQnczL0xPTmFITyszNi9GdnRlUnFsV054MlFGczc2?=
 =?utf-8?B?c3lqelB2L0VBY09hYWtycjJyTDlrT2ttQzhTWVRMclo2anU3VC9wbmRLS0M2?=
 =?utf-8?B?VjQyMWRuUHFacndFdEovaFVZVThwYktjZjBJSU0rSmxiS2E1a1FpVkJVVTJs?=
 =?utf-8?B?V2tHRTV3VkdSMlpCUk9JY3M2MFU5SWV3dDJwUnhTUmRkbGQzZTZkek82dUJ6?=
 =?utf-8?B?Ujk5Ukt1Wi84OGdFaTM5bFhtNjhvRDhBbVFuT3ZqZVh1OEJaTTc1NUtuczc1?=
 =?utf-8?B?VjZlazE5QUlmaVQ1Z0I5UXBVUEpYNjZUaUh2ZSt6Qkh2L1EzQ0dUNlFrT3ZW?=
 =?utf-8?B?clQ0alVyUG00WE8yOVBwQ0F2ZzdxYUUzbjEvU3YrUHFLbDNGSWkwY3gvejEr?=
 =?utf-8?B?S2twakNQSDlabHRwMnp3NGErdVFEZ0lEaVJNV2R2SmI4SUlzc3lFd0c4b2ZN?=
 =?utf-8?B?M2NFcy94VWJlcUhaUVp2TzFXTHEzNCs5OThTbGRBOHM5RjZrRGJBSlhYSlRw?=
 =?utf-8?B?bTY2T3Fnbk5vNkxFSExkTXBwNi94R013blF0a20rdGhWbnJleGZHYWxXTWM4?=
 =?utf-8?B?TytPTWZwNEMwc3pXVWRiU1l5cTU1aG9wVXczaHhQbkFGUGU5S1g3TW1TcXhs?=
 =?utf-8?B?ckJNaWRsNlRQdDQ3QWZjZ09LL0lhS2k3SmlyaVNsVjNOZXI5anNPYzNJZzVV?=
 =?utf-8?B?TC9GRWNvN2tGYnFWdEJjWDZiT2dIcERQcXRsVHZMT1hkdVVuUEpVSS9yemtE?=
 =?utf-8?B?YXlzVzRyb3BDdnUybkRySlllenQ2ODduUWQ2SnFXRGt6eE1RMmxzT2RVcGpJ?=
 =?utf-8?B?MGlldDdUOGFUNlBTTndCdW5GVTBUdEVqT2IxcmxoM1VPZGpZSC92bEdZWStH?=
 =?utf-8?B?S3BrMExrUFNXZVBzMUUwbE5PSkk1WWdJenVQb21hSi9Ea1RPNjljUTZJK3Av?=
 =?utf-8?B?b2M4dlQrcm9pOFVmZjVXYzBiaDdqNXBJMk8xSU1JTEVHOXJhN25ZODdSZW1j?=
 =?utf-8?B?UzVnYmtUMEJOYnAvd0RibUFuZ3Iyd3YxaXJWSTA3UlhHanRGUXFxOE0vMDls?=
 =?utf-8?B?Zjh0MUQvMVdXb0xDTE94ZTU1SUhzU25JK2pyOVNjdUh1OU1lbVlDWUVDbEZk?=
 =?utf-8?B?dkcxNDBRSWh0aVVzalRmNDducDdrM3BucUVlL3hYY2c1OVdNU2l5UWFWZ3Jl?=
 =?utf-8?B?TWhlMnZCbHVGQkNMbkdxRVdpZm1kYnpyUHRVSlZkODV3ZWw3RU1YUVlJMDRq?=
 =?utf-8?Q?cqTN0EwTpSTtZwrunEi15vrvze5GTZy7tyl7kyn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7dd095-5eb4-4944-9cdd-08d9149a47f8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 16:31:51.5819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oY0umdDGrmLTKxi6t2CC5s78HmKObXATl0WcdduGrTR6g/W7RvCQUylQJMFRaN/8VROsjgSX45ASRKpO8efGUKOyes9qUwg9n9b/xr1FJtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4251
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110117
X-Proofpoint-GUID: 3bQ-0Ie-9WbDmaLv0tf7b8YlHuuL1Crr
X-Proofpoint-ORIG-GUID: 3bQ-0Ie-9WbDmaLv0tf7b8YlHuuL1Crr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110116
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

During Syzkaller reproducer testing on 5.4.y (5.4.118-rc1) the following 
crash occurred:

WARNING: in hsr_addr_subst_dest
https://syzkaller.appspot.com/bug?id=924b5574f42ebeddc94fad06f2fa329b199d58d3 


We cherry-pick'd upstream commit 4b793acd to 5.4.y and the crash no 
longer occurs (rebooted 10 times with the fix commit - no failures).
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4b793acdca0050739b99ace6a8b9e7f717f57c6b 


The cherry-pick of upstream commit 4b793acd was clean.

[   63.452196] ------------[ cut here ]------------
[   63.453371] hsr_addr_subst_dest: Unknown node
[   63.454993] WARNING: CPU: 2 PID: 16155 at net/hsr/hsr_framereg.c:321 
hsr_addr_subst_dest+0x456/0x510
[   63.457170] Kernel panic - not syncing: panic_on_warn set ...
[   63.458557] CPU: 2 PID: 16155 Comm: 924b5574f42ebed Not tainted 
5.4.118-rc1-syzk #1
[   63.460377] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS ?-20190213_084539-x86-ol7-builder-03.us.oracle.com-1.oci.el7 
04/01/2014
[   63.463426] Call Trace:
[   63.464038]  dump_stack+0xd4/0x119
[   63.464873]  panic+0x28f/0x6ad
[   63.465643]  ? add_taint.cold.9+0x16/0x16
[   63.466624]  ? __probe_kernel_read+0x194/0x1e0
[   63.467700]  ? __warn.cold.12+0x14/0x2f
[   63.468636]  ? __warn+0xdf/0x1d0
[   63.469430]  ? hsr_addr_subst_dest+0x456/0x510
[   63.470509]  __warn.cold.12+0x2f/0x2f
[   63.471407]  ? hsr_addr_subst_dest+0x456/0x510
[   63.472486]  report_bug+0x279/0x300
[   63.473339]  do_error_trap+0x105/0x170
[   63.474263]  do_invalid_op+0x3b/0x50
[   63.475142]  ? hsr_addr_subst_dest+0x456/0x510
[   63.476223]  invalid_op+0x28/0x30
[   63.477040] RIP: 0010:hsr_addr_subst_dest+0x456/0x510
[   63.478368] Code: fb db 07 00 0f 0b e9 a0 fe ff ff e8 84 f6 72 f4 48 
c7 c6 60 9a f9 8f 48 c7 c7 20 9a f9 8f c6 05 c6 e5 d4 05 01 e8 d5 db 07 
00 <0f> 0b e9 7a fe ff ff 4c 89 e7 e8 4b 44 b2 f4 e9 65 fc ff ff e8 21
[   63.482793] RSP: 0018:ffff888100527648 EFLAGS: 00010286
[   63.484054] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffffffff81882886
[   63.485753] RDX: 0000000000000000 RSI: ffffffff815ff026 RDI: 
0000000000000001
[   63.487454] RBP: ffff888100527688 R08: ffff8880b2c6ae80 R09: 
ffffed10216660c9
[   63.489150] R10: ffffed10216660c8 R11: ffff88810b330647 R12: 
ffff8880b2e1a8e0
[   63.490853] R13: 00000000e3ffe048 R14: ffff8880b2e1a8e0 R15: 
00000000ff39fffd
[   63.492568]  ? __irq_work_queue_local+0xa6/0xe0
[   63.493667]  ? vprintk_func+0x86/0x120
[   63.494585]  ? hsr_addr_subst_dest+0x456/0x510
[   63.495660]  hsr_forward_skb+0x1329/0x1cb0
[   63.496655]  hsr_dev_xmit+0x115/0x190
[   63.497560]  dev_hard_start_xmit+0x13f/0x630
[   63.498592]  ? __sanitizer_cov_trace_cmp4+0x20/0x20
[   63.499760]  __dev_queue_xmit+0x1e4a/0x2860
[   63.500769]  ? __kmalloc_reserve.isra.54+0xf0/0xf0
[   63.501917]  ? netdev_core_pick_tx+0x300/0x300
[   63.502988]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[   63.504278]  ? alloc_skb_with_frags+0x38e/0x540
[   63.505367]  ? prep_new_page+0x13d/0x330
[   63.506317]  ? __kasan_check_write+0x14/0x20
[   63.507355]  ? __mod_zone_page_state+0xa5/0xd0
[   63.508430]  ? __kasan_check_write+0x14/0x20
[   63.509459]  ? copyin+0x85/0xd0
[   63.510223]  ? __sanitizer_cov_trace_cmp8+0x18/0x20
[   63.511391]  ? _copy_from_iter+0x2dc/0xb20
[   63.512390]  ? __virt_addr_valid+0x247/0x310
[   63.513432]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
[   63.514740]  ? packet_parse_headers.isra.64+0x347/0x490
[   63.515995]  ? packet_parse_headers.isra.64+0x12a/0x490
[   63.517242]  ? tpacket_destruct_skb+0x570/0x570
[   63.518336]  ? __sanitizer_cov_trace_cmp4+0x16/0x20
[   63.519513]  dev_queue_xmit+0x1c/0x20
[   63.520403]  packet_sendmsg+0x198f/0x2ee0
[   63.521368]  ? tpacket_snd+0x4050/0x4050
[   63.522319]  ? selinux_secmark_relabel_packet+0xe0/0xe0
[   63.523577]  ? selinux_socket_bind+0x163/0x980
[   63.524650]  ? __sanitizer_cov_trace_cmp8+0x18/0x20
[   63.525821]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[   63.527114]  ? security_socket_sendmsg+0x99/0xc0
[   63.528227]  ? tpacket_snd+0x4050/0x4050
[   63.529180]  sock_sendmsg+0x155/0x190
[   63.530068]  __sys_sendto+0x27f/0x3b0
[   63.530959]  ? __ia32_sys_getpeername+0xb0/0xb0
[   63.532048]  ? packet_do_bind+0x470/0x990
[   63.533018]  ? packet_bind+0x169/0x1c0
[   63.533933]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[   63.535228]  ? __sanitizer_cov_trace_cmp4+0x16/0x20
[   63.536406]  ? __audit_syscall_entry+0x43c/0x580
[   63.537516]  ? __sanitizer_cov_trace_const_cmp8+0x18/0x20
[   63.538810]  ? syscall_trace_enter+0x498/0xdb0
[   63.539886]  ? trace_event_raw_event_sys_exit+0x280/0x280
[   63.541180]  ? __audit_syscall_exit+0x791/0xc30
[   63.542273]  __x64_sys_sendto+0xe6/0x1a0
[   63.543226]  do_syscall_64+0xe6/0x4d0
[   63.544118]  ? prepare_exit_to_usermode+0x1bf/0x280
[   63.545291]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   63.546515] RIP: 0033:0x4332a9
[   63.547263] Code: fd ff 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 0f 83 bb ad fd ff c3 66 2e 0f 1f 84 00 00 00 00
[   63.551678] RSP: 002b:00007fff7655df08 EFLAGS: 00000216 ORIG_RAX: 
000000000000002c
[   63.553473] RAX: ffffffffffffffda RBX: 0000000000400328 RCX: 
00000000004332a9
[   63.555172] RDX: 0000000000000011 RSI: 0000000020000140 RDI: 
0000000000000003
[   63.556872] RBP: 00007fff7655df30 R08: 0000000000000000 R09: 
0000000000000000
[   63.558575] R10: 0000000000000004 R11: 0000000000000216 R12: 
0000000000000000
[   63.560267] R13: 000000000040e3b0 R14: 000000000040e440 R15: 
0000000000000006
[   63.562771] Dumping ftrace buffer:
[   63.563604] ---------------------------------
[   63.564685] rb_produ-210       2.... 7283224us : 
ring_buffer_producer_thread: Starting ring buffer hammer
[   63.566936] rb_produ-210       2.... 17283292us : 
ring_buffer_producer_thread: End ring buffer hammer
[   63.569115] rb_produ-210       2.... 17365464us : 
ring_buffer_producer_thread: Running Consumer at nice: 19
[   63.571415] rb_produ-210       2.... 17365467us : 
ring_buffer_producer_thread: Running Producer at nice: 19
[   63.573721] rb_produ-210       2.... 17365468us : 
ring_buffer_producer_thread: WARNING!!! This test is running at lowest 
priority.
[   63.576489] rb_produ-210       2.... 17365470us : 
ring_buffer_producer_thread: Time:     10000059 (usecs)
[   63.578750] rb_produ-210       2.... 17365472us : 
ring_buffer_producer_thread: Overruns: 3881100
[   63.580827] rb_produ-210       2.... 17365475us : 
ring_buffer_producer_thread: Read:     3590700  (by events)
[   63.583167] rb_produ-210       2.... 17365477us : 
ring_buffer_producer_thread: Entries:  0
[   63.585128] rb_produ-210       2.... 17365479us : 
ring_buffer_producer_thread: Total:    7471800
[   63.587213] rb_produ-210       2.... 17365481us : 
ring_buffer_producer_thread: Missed:   0
[   63.589173] rb_produ-210       2.... 17365482us : 
ring_buffer_producer_thread: Hit:      7471800
[   63.591256] rb_produ-210       2.... 17365484us : 
ring_buffer_producer_thread: Entries per millisec: 747
[   63.593506] rb_produ-210       2.... 17365486us : 
ring_buffer_producer_thread: 1338 ns per entry
[   63.595587] rb_produ-210       2.... 17365487us : 
ring_buffer_producer_thread: Sleeping for 10 secs
[   63.597728] rb_produ-210       2.... 37929811us : 
ring_buffer_producer_thread: End ring buffer hammer
[   63.599913] rb_produ-210       2.... 37951467us : 
ring_buffer_producer_thread: Running Consumer at nice: 19
[   63.602208] rb_produ-210       2.... 37951471us : 
ring_buffer_producer_thread: Running Producer at nice: 19
[   63.604506] rb_produ-210       2.... 37951472us : 
ring_buffer_producer_thread: WARNING!!! This test is running at lowest 
priority.
[   63.607272] rb_produ-210       2.... 37951474us : 
ring_buffer_producer_thread: Time:     10092798 (usecs)
[   63.609540] rb_produ-210       2.... 37951476us : 
ring_buffer_producer_thread: Overruns: 195330
[   63.611593] rb_produ-210       2.... 37951479us : 
ring_buffer_producer_thread: Read:     1469527  (by pages)
[   63.613901] rb_produ-210       2.... 37951481us : 
ring_buffer_producer_thread: Entries:  4193
[   63.615917] rb_produ-210       2.... 37951482us : 
ring_buffer_producer_thread: Total:    1669050
[   63.617991] rb_produ-210       2.... 37951484us : 
ring_buffer_producer_thread: Missed:   0
[   63.619945] rb_produ-210       2.... 37951486us : 
ring_buffer_producer_thread: Hit:      1669050
[   63.622016] rb_produ-210       2.... 37951488us : 
ring_buffer_producer_thread: Entries per millisec: 165
[   63.624245] rb_produ-210       2.... 37951489us : 
ring_buffer_producer_thread: 6060 ns per entry
[   63.626315] rb_produ-210       2.... 37951490us : 
ring_buffer_producer_thread: Sleeping for 10 secs
[   63.628448] rb_produ-210       2.... 48317537us : 
ring_buffer_producer_thread: Starting ring buffer hammer
[   63.630703] ---------------------------------

Thank you,
George
