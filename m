Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164B24456A3
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 16:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhKDP7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:59:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33002 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231395AbhKDP7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 11:59:09 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4FtRAh007643;
        Thu, 4 Nov 2021 15:56:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6iI3dZjA1r1YLhi0I3cKEArQZIA2GcYQ+WPrNcay3+E=;
 b=zz1LiqhE9Swsa48CA4BgSKfjsPXvTxCfcafbny3VXEM9sXcwFykN9KVHAMN64yq4puBM
 sPYkNE7ap2fs01GwVFZxX7kiKe+UumDuqQzjjIz2jeAQtQ8MtDYJY5lAA3FKiDcMXXk9
 m3NleSbHxWMrrgX2XEDVjzVKjCZ9+LcDX5ju4ZIp2NMqOwhPX/2Ea9zVjfuu6vQKCar9
 jXwNhSrKBSuhT1rcxD6dwIxy/sdhJn1EbonM5J39x5g3kKpzMaefqqzB3ImFe2ZSeMoF
 n2pZ9NfkY5DP9wxKRdJSMbZuGvOEYzM+gzhiLIBlANzaF7mvaYRCr8Z6yuh9GiL9ziFV Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mt5h8gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 15:56:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4FaOGF177826;
        Thu, 4 Nov 2021 15:55:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 3c1khxdc7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 15:55:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxQ8uvZLNyZFbo409FopsHq7kE1hoVsGJ3AyeFLPt6fRr+s+1af4bFkVzIju+EAiSYmkl1hEptGUeFGoBN6/TBIKzdOsr2nqIFBKGHX29S2JYk1+Dtyb6Ett0jiEvcWZK7cQ4SlmUyaJgTdCcO5GfApGmoEibAEZXb+qxbjw7CblDvPlQ4dTe33VdYVojk7lniu6rO/+vwLPS2ccvHF4THIHqygbOjdi52c9dFYKmAvEpUl/ZvjfYY03BnyX+KsoaBKN5QTMLcphWAzwD6osPmXgF4pVcLrnewq9zH4EMXjPbkih46VcjPmlFZDa0QYnAmMHnUez8iRrZdL5yrB4vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iI3dZjA1r1YLhi0I3cKEArQZIA2GcYQ+WPrNcay3+E=;
 b=BTNNEjkniLxsNZx4Li5MQtNC6KW5Bs+8qMrbLKEU0yADIVI0SsuAmlhUBAaNdgaCmZjYyDSlytYKwZlOQFV0cva1hTRnH0CV/bFJ6V07Yh+VxFrpDD1u2LBqqoijjZlAXC3Dur8Y58Mn+Tsu9BLXub/rEQXPCXhr60NjMFRqt+A4eyKBn/My34/DE69hz8q7q/Y6W/81ENHd0rMzwtAOICziOzmRXuCDbCWHUFyw1zQCoREneg/aQfguOdqZpyeSXnsIeb3joB4OtpMFRXeyQzEAnthMTTFE0BPhTGxrgKlRdjxnyLvhkiVGHdio+LFsn3YeGXQKt++GTFoWMiA9ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iI3dZjA1r1YLhi0I3cKEArQZIA2GcYQ+WPrNcay3+E=;
 b=VmTuZp1w1Q+xzwcYWQWhEfUfrLqGYsUGHZjIZmB7fd4N4NuRxWxQ0S/fg4P5833iLFFs5X6QxJ8IUImbfKfatha28AD4/o6JHAstOkx4LC14vha9/NhSFn0chTSzX0MOnujpJVmmENikzwGQzY+qdwQsHXJ9FKuZdZJV39N2HWU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BL0PR10MB2865.namprd10.prod.outlook.com (2603:10b6:208:72::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 4 Nov
 2021 15:55:40 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 15:55:40 +0000
Message-ID: <f8e52acc-2566-1ed0-d2a3-21e2d468fab7@oracle.com>
Date:   Thu, 4 Nov 2021 11:55:34 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v4] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Content-Language: en-US
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20211102091944.17487-1-jgross@suse.com>
 <f986a7c4-3032-fecd-2e19-4d63a2ee10c7@oracle.com>
In-Reply-To: <f986a7c4-3032-fecd-2e19-4d63a2ee10c7@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.104.20] (138.3.200.20) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Thu, 4 Nov 2021 15:55:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7fbeb1d-2c1d-4526-4561-08d99fab8d37
X-MS-TrafficTypeDiagnostic: BL0PR10MB2865:
X-Microsoft-Antispam-PRVS: <BL0PR10MB28658F11D15CC9F818E64D2B8A8D9@BL0PR10MB2865.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DxQGjVyIB5XmLkdvsRexmk08/wrLch8DD/LNcep4OMk0I/jONuvjnCVGDNYewiusHjGuRJ0vtvXvbbUFaJaCH6ftz8LRz4AvFte/9zvYnFU/ygt6+sTYUsjt8rJRe/bO9ZWdmAtFXIal7RZmtuF4CWPhV9+7EX19gNH2104oVK87CUTDmhETbwOQ0I4p0EggzIkMypCdhdJ33ouC8qkjg1ynTLfZ17DL+mtF+pGHdOQ8KfhrsySLx9tUKmWvByMewAdDM07GvOjksCkZKL9696/tqSSFzTy8lOVzQ8cV5jwWIyrpwSYwhPtYmVzIHEcrH4XBXXzp0G7bh1l0GQRxg6mrf/7MPWXn0Nmxe4v2+J63auznkHMDXykcnjGpTGj5IZE1HJUjmsXOj03/CKP9MnHlW2oViuQr1g6AZkzgbni53QO+CScjyrlrP8FjL2PfPSYP1zpuJmWBQtUhhl1ThQrJK6FqPjRdejAzzk6ccoDBsZ+bqPJ0pPdABzwP2vjYOAugKcQXEPba2l9qikMx3QG5ElqYJeqEw2y5ERmdjj6EQ/JS8inZhF/eSw77K6y1Y1shoU/vUbUPO0zlsmzOL59zyV93vB2MLvvpfNrBa843bCn8gsFwCmAllfR4TQe8E9OXRLKf/OY6TBWZu2OJ+CHdXeYL2qGaRscgacOZ12f9tTsH4lLmUiGXmLKqKOlM0N6+5c94luNjhPV24320uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(31696002)(53546011)(66476007)(2906002)(44832011)(66556008)(956004)(8936002)(186003)(6486002)(8676002)(5660300002)(26005)(83380400001)(66574015)(2616005)(66946007)(316002)(36756003)(16576012)(38100700002)(6666004)(4326008)(31686004)(54906003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTZHdHlRdUtlM1NaRUxjRlltcjNnWGkyRmd6Q2JxQU9IUnRnZ09KRE1XRDRq?=
 =?utf-8?B?dU83MVBSQWxUR0tKLzVaa2JXZjhQMld4dWp0R1VHQUJoSkZlRy83UzRkOTNw?=
 =?utf-8?B?QXZwTmhVM3RhMnRwOW1kOUtaaWhaWk5iaXdxellNNWsvZzZHOTNib1Q3VVB0?=
 =?utf-8?B?WFVSOGx1UFI5TktHVVlwZktINVVJenFUVHcxSkFWbmI1cUVKc3NobGpQcThI?=
 =?utf-8?B?MzdYdDlTODNQK3kzMlVjUHFEVS9uOTRGcHNOZEZabi9SUUVVMUgxQUhXVFV2?=
 =?utf-8?B?UVoyeHFxNUhaWC9DOXRPSEhDT0hKak82VTVweUZyK2VLNVlSQThzS3BWL3Vs?=
 =?utf-8?B?VFV1VXp2N3pGY3c5a0Vsam9OYmRyRHoyaEU0MTBIK3AwZnlyc1VTeEpycXUr?=
 =?utf-8?B?N1RpMWduQ0c2Ky9FbFFUdXRkODV2Y2FFRkp6TXhsNlQrVHd5VXFFdXBERWJz?=
 =?utf-8?B?alJBd1N6bTdtbjgvMTdNNGVIRG1zTlZjdDNER1lERHhSSDhtUnh6RjdKTktU?=
 =?utf-8?B?RElvNktLd3VESk8xeTJUcGFTK2oycXhhaXJDV09haEFoKzRsNFB0eUZPZ3k5?=
 =?utf-8?B?WXExdWNVNlZyZkNYamQ5QzZFSEhqbFRwNTUvSDl1NWdVSVBoZ0xIQzErcHh5?=
 =?utf-8?B?WFJ2OHppaURIOEpwL1RtSGZIS3ROaTNldTkvTUtRcVUwai9FK1cwcFVmcjIv?=
 =?utf-8?B?WUN0YmdXN29ydXdtbWhYR01qbUE5aDB3dEZ4UlhGczZOMnV5N2RpWEpaUzUw?=
 =?utf-8?B?V3pValpXdzhLb0xwQTk3Z2JEaUdEeHBDWjRGdExSSzVWcXBJR0x2dytHcTRD?=
 =?utf-8?B?dGVpU3dHNTFXNkNXWVRtRFZiMXhMeUJ6bWNkeUM1OXRLQTRyRUZUdHhhcXR1?=
 =?utf-8?B?VUNucE90MkxQQWdMbEJRMVJUM2VLRUcrUEZPUCtnczZweW50SVRJcTFlY21r?=
 =?utf-8?B?VGNHMGsyeXZnRHY2WFF6dFVYU3lKMWh1ZDVoMzU2aDAzVjJTRjNQMElVOTNY?=
 =?utf-8?B?LzRGNzd4TjB3S2h1SFR1Slo5eWRNN1VnUDJ3QUFkUkI1WjhpUk94VmdaVDBM?=
 =?utf-8?B?ZUo5NFJEelFIM2w4VDV5UFppMG1KMjZLbUs4SkpUQ1ZCVEZBaEE2eGxVTGJx?=
 =?utf-8?B?VkF3UWpabXlXZ2R0Z25PWEUzeHc0Wmw0MXFRNXRXZDdTZEhuVXNzL3JHOW9v?=
 =?utf-8?B?MDU4VWo4Zzd0WklXanVuczlCbHJOSCt1N1dqNTJ0Z2NSdXRIMWI0UzUvRFND?=
 =?utf-8?B?UmNaV1RQcW03YWtnMXQwRjRJQ3F4UW1uOFdYVjZoUlFyWVM2ZU5HNmJEVW5H?=
 =?utf-8?B?a29YSEdYRngyRG8wYzRlemFOSGNFRTNrRDMwTVRaQXA0QWR4a0Y2bGlSMHpK?=
 =?utf-8?B?NWVOWFh2YVBHNFJKbzNVa2NzQjBUdlV1QWV2YTlvdEpHMnJQYUdZZmY5MGJs?=
 =?utf-8?B?UHRmTUNONHBiOEF6OVk2aFB6SWxuaVc0THJybTI1a0EzdVRaVm4wdlRRV3NO?=
 =?utf-8?B?UThKVktWdDM2M1Z5MkY0QzJqUldHSll5ZHAvQnJXOEx6SGdEMXdSZDl5dy9C?=
 =?utf-8?B?VHo5U0dMc2JZUEhZakdvaVlUUjQvOUlvVFgyT2JOdjdFQ1ZoY2xDVExqWFpD?=
 =?utf-8?B?L3NKN1FyT3EwcCt5aXpJZXBWN3dBTUxZS3IrOThoQWtyclVieTgvS2FlaTR5?=
 =?utf-8?B?UDhTRlZvNmNIN1R0STNnRDh5cFdvcTE0TEdSZURJdjhjdkxRS3hLREJxN0tZ?=
 =?utf-8?B?c1kvMTZOSER0enR2MlRyYk9kUGhCcEVBVno0OC9Ba1NMRWpZNk5qWHpLTnpa?=
 =?utf-8?B?YmRNODNiZFlwbHpYWkF0NG8xMkI0dTM3TFFjcWk2NVd0OGt4YlhkYmFKNExE?=
 =?utf-8?B?VlAzdzlNb2xwQzViQTNYS3JldTl0cWltZitDMDFMRnFnL0NVVitGU09JRUtC?=
 =?utf-8?B?b2hYVDFaYk40c3l0aVVpWjRlYVhBdmxZOTZTSEZFTEJSWWZQT0ZpMnFsYXVj?=
 =?utf-8?B?RVRrWnZrKzFBLzdTQ0hPTUtsT0lmZ0kzVmcxVWRSNWgwb3FNcHRSY2RIOXlO?=
 =?utf-8?B?R1F4dCt6N1FmL25obU9nRlZ3WWw1N1BwLzd3MEJ4V3dYRTFCazNFanQxZVRk?=
 =?utf-8?B?MFl0RFpmNUFQdDZzUVpHYnZTcjdhZ0grQy9aMU1XZGh0UWJudDAyWFVabHh4?=
 =?utf-8?B?QUVtY1RXZGd2dnFMMW83eERDdDR6MmhhNXN4L1ZlMndxQm9CdFNJVmhiQ0VG?=
 =?utf-8?Q?lMIM8eQ8ojlY5NuiqaghEEiL3bnO6rDWP7UU1BmyJo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fbeb1d-2c1d-4526-4561-08d99fab8d37
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 15:55:40.8762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XzUNb1QSgK0nKpvlgzZbZM+g4olrKY65sokOSlsxeBKqdRplmP78LPEZN1uViEyae68MkaTGhhSECWOPKEaRKWjwiIjGeqtANrjE5rN0Odk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2865
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040059
X-Proofpoint-ORIG-GUID: 3m0PyIltpDF4PZMgd8lxRO8nwPvbnZqL
X-Proofpoint-GUID: 3m0PyIltpDF4PZMgd8lxRO8nwPvbnZqL
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/3/21 9:55 PM, Boris Ostrovsky wrote:
>
> On 11/2/21 5:19 AM, Juergen Gross wrote:
>> When running as PVH or HVM guest with actual memory < max memory the
>> hypervisor is using "populate on demand" in order to allow the guest
>> to balloon down from its maximum memory size. For this to work
>> correctly the guest must not touch more memory pages than its target
>> memory size as otherwise the PoD cache will be exhausted and the guest
>> is crashed as a result of that.
>>
>> In extreme cases ballooning down might not be finished today before
>> the init process is started, which can consume lots of memory.
>>
>> In order to avoid random boot crashes in such cases, add a late init
>> call to wait for ballooning down having finished for PVH/HVM guests.
>>
>> Warn on console if initial ballooning fails, panic() after stalling
>> for more than 3 minutes per default. Add a module parameter for
>> changing this timeout.
>>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>
>
>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


This appears to have noticeable effect on boot time (and boot experience in general).


I have


   memory=1024
   maxmem=8192


And my boot time (on an admittedly slow box) went from 33 to 45 seconds. And boot pauses in the middle while it is waiting for ballooning to complete.


[    5.062714] xen:balloon: Waiting for initial ballooning down having finished.
[    5.449696] random: crng init done
[   34.613050] xen:balloon: Initial ballooning down finished.


So at least I think we should consider bumping log level down from info.



-boris

