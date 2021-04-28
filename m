Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D8736D7B6
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 14:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbhD1MyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 08:54:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55808 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbhD1MyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 08:54:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13SCnpPg072564;
        Wed, 28 Apr 2021 12:52:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ULVICSs8icPn1t5sy8trYRinhbnN13m7OxhikZw+/YE=;
 b=Ll3VvTOVRG/clHPvlOEv7Xn+1tWMu5uJPjTVbCHSvO6N+eBMwuMstNl7/zFEqkIaRofe
 EQlo7uD1CpWPUJmH9gvqL/3SyXa8FHj8j0qucl2lboSopq70pCHbHgGYGhh0eLGpyQFb
 uGW2CSI38+THFD3sFHtz4bbc7b5fa65J2Qt2SIQTbj6VSZ5CmRoQpNU5kaXR4DUamcXR
 FeEYUC8wyzSeXHjl6CdZXZvIiYcVRRf+v+DXevHwyei4RVOE6NyP1LsMaC1kfsF4TSFJ
 tYi2CNltA/7JZlsHqiyL31JM/4Ua+mqAl5JyqC75B5GjagyzmaXiEgidGWCO1v47o1yr kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 385ahbrntb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 12:52:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13SCoX0p063188;
        Wed, 28 Apr 2021 12:52:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3020.oracle.com with ESMTP id 384w3ume3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 12:52:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qu/McKVBJ3/VSGEf0kYgzoUWSs1O1NHEXMXnYQK0rRWdyTaZ5HX7L2qeuKXLV2E4le4iaFnmRXwz6JSKSGaVRUOEXror/V7Wt8TJy+1VucvtskV3v4QeFTmmbbC85mGX1EmedcWGDhymWOigU7dbmfVSPl48uQb1Z6M1GUDfi1bD7rNs23rH/dplFXhvNdXXwOx+tYyZqvAGpVUvT1U9haGes3+BjJSHAPx8pHRGNFuLGFo/IyQxh1oKPWo3zepNSvV2ToJN7K4obsnl6csAeNSjxvIixCFMvwFEIcP5Qadk9RU6EI4cORqcMQR41ilJh8shl2QpSsV1IKjGMOktzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULVICSs8icPn1t5sy8trYRinhbnN13m7OxhikZw+/YE=;
 b=dA6PdfsQV9xnqsnN+3cGLI01SnbYybyu1d3XbbmTED95qcrwPlYyS+dzTX3lBZ72RzpiXWNd69nXTDsn8fZ7uG3bgnqBeuZTRBIs/StFLR0gxA28mJltCOxva0gfUXmzGHAHnuLIlUeNorX7/MsGA2IMpfBfWAANSOPsgHWt0mGLcowG7COHwtJKprEauzRaIrUgyEvdFTLWFByIC2K98Uq/6lBXpCHxLgAhM+iMljg26q65NitI5p47yCUZj+O4VR52QsgITboLiIOiHhRMEagg5ful5vyEoR7BQE2hinXxRyoFlhaxY18l2lQ/SC26FTDhYBMLfFLeBbhb/s+UWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULVICSs8icPn1t5sy8trYRinhbnN13m7OxhikZw+/YE=;
 b=ZOiB8bpKO3Mdey2ntFVxu7akrSBwyyK02sJlW5cw+6wxo2jNPXYpKTwGnwhENcCYF95InlF0CqxZGPdfs+Ma3q3UXruE/59fSK8EmZ1SQlVqxY/7l12Dz0ZQFM+6HZv461Z9KniYJcFXUPwNs+fDFmVFrPP0X/maPA78UHUR2yw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB2844.namprd10.prod.outlook.com (2603:10b6:5:65::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Wed, 28 Apr
 2021 12:52:22 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 12:52:22 +0000
Subject: Re: Needed in 5.4.y: [PATCH 5.10 055/126] ACPI: tables: x86: Reserve
 memory occupied by ACPI tables
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        stable@vger.kernel.org
References: <13f5c864-9b15-b2dd-53e1-d71b27a94a74@oracle.com>
 <69f6104e-ca54-5686-4cbf-dc14cb1697f3@oracle.com>
 <YIjrQdJtpJ0br5m9@kroah.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
Message-ID: <db5625eb-f304-2f47-49f3-5fb7b3d019e9@oracle.com>
Date:   Wed, 28 Apr 2021 08:52:19 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <YIjrQdJtpJ0br5m9@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SA0PR11CA0170.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::25) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.222] (108.26.147.230) by SA0PR11CA0170.namprd11.prod.outlook.com (2603:10b6:806:1bb::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Wed, 28 Apr 2021 12:52:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f19485b-1ba1-4fbb-e897-08d90a44775e
X-MS-TrafficTypeDiagnostic: DM6PR10MB2844:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB28448584FC05DB2E5A9770C0E6409@DM6PR10MB2844.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtaFd8AcVvkoV0550WPEO8BXjCCtNvaV688pdozwZNr5mKcp/78OY2eKQkaRMLIMVmsY4W1qMihMaPzNTOKlFhymLedsupxcxpUKR2p6CU9K2yCvervLs2eeRe4yFpqmD8G+l/KCF9gZ9rwHKzB+3OPHv9HIXC7AUTCksjtkNM+HF1KQRibYd4pYaXRPmN5iPv8hrmrv9XLiZ/TUzOVRRQPj2AABOMbbyDCQAqpT50iv3uyffK2VqLtT76DvEJraR6Shkbh4YLp+q2JMNHTlOazAa6y9d/BHU7zyKpkEWBikwHA46h28DPG2HW6XQKUTR8xYfncsMSWsQMMcymkDjyNaP0pzTrGj8IBrWaLv/8xO8O88UDjPYuFog48j+Ax8H5kyB4M7ZfCDGKWqHBOSv/RqhzdGn1ZOAcd0FS5Yn/WEV1AH3URXXA9gNuOQPTKvp+ZNjlt3ukyzsQXuIVE3u+pNeLaPOsfQ2JLoIw530VNdMExKpQQSJ9tmFIeshZkpf0brdN0aLdMGY0JDeZivTQaZi/H8tU5EoTQMMRLBhKMw3RCJZK5FRIfeX4d6imSOSVgeOFpVHxmZ58prm28TIaIRIKFI166HveK8VdnrJViFAnbuN2qRL/TKkMABNlWWCJ3DdUNS35mYaQSXUgCBalbgPzJ7WQMmZHj0bDM5ei6PPLIo5NAr4cgB1VTGV9WG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(83380400001)(36916002)(316002)(38100700002)(8936002)(31696002)(478600001)(5660300002)(8676002)(31686004)(53546011)(2906002)(4326008)(66946007)(6916009)(956004)(26005)(66556008)(86362001)(16576012)(54906003)(66476007)(186003)(36756003)(6666004)(16526019)(6486002)(44832011)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Qm16Y2wxL0k4MGFPNVc1ZmxkTkxIZnBldGZlU1p2MlVWbkpPN3lQTDBVb2Ey?=
 =?utf-8?B?dEZ4cno1d3ozNkhCMGhFMm9QaWRxSmNxNSs3SmNmSHNjWDRlcEYyVVRkQ2JE?=
 =?utf-8?B?eTJrd3ltVXJadW9Ub2VLSGVzdTBva2RYeVRjTWNEUnFQT3g2eE8yVjBWVStX?=
 =?utf-8?B?N1hJaDhhWjBqeiszV01TM1Vsc2VZWjJIMHRwU3JtNXVud0RpYy9JOGdEcFVS?=
 =?utf-8?B?dXJSU1VYYXVtdVpoZ1Z0ZzB2K3NLNC81SFA4dFFER29Tc0R5cjZyL2pWU245?=
 =?utf-8?B?OGpXK2FHN3dTNlhWZ3ZLRXgydFE1ZUFwcFVERklhaFN0RnVueHRleXZMTE5n?=
 =?utf-8?B?RDR3MHpFcEtFRGVCdFloQXNqU2VjZ1djN0pKQnJQWUcvYU8rd3VvdVhmUmVY?=
 =?utf-8?B?Ny9OUHJpUklFNkllRDhQN0RYSjdpWmlLdFNHUGVWTitVczlNS0NvcUZVZmNF?=
 =?utf-8?B?Y0l2NGhTQUhXdHhhNCthTUVlSVM4TXp6Q0prb0dCVFNWbzI0ODduQ04vRjF5?=
 =?utf-8?B?dG15WFJWMnhPUFpjT2RxSUVkc2g2c2NPRFpZRTE0OGZJZ3lZVmhZSHN1TTdP?=
 =?utf-8?B?VGltUHI3Z0dFZjIyZE4vaUZqT2hUb1U1NndiSFNoTGdCMGNGZUljV2ZEN0s1?=
 =?utf-8?B?aS9sMEVWYXZINC9XOFQ1T20wdlJPMy9sbGhLU1kyd2JvZFo3TSt4QmlJVHhO?=
 =?utf-8?B?cFVST0xhTHZWcGlMc3NCMXIwZnlGdHJIbnZhUzZqc2k2RzhWNHYyRUJNcmpt?=
 =?utf-8?B?S2k4S1FkUXJMVEowK1JJcW1mYTJpdWhTTUM4aE0vK2xYZ1FjVkpjcTZFcCtR?=
 =?utf-8?B?TmpFZm15ZENxVCtGNTZVUkpNZHZ5dWRRUkJ0Y3ptMUd2ZXdtUE0wdlM0eWpJ?=
 =?utf-8?B?UkFHQ3gwSDNubUd3dnFQNmpyQU5ZUTVOU0NpRzVDd1ZKdVg5WVpqaS9jOVV1?=
 =?utf-8?B?RnVBd0E1ek96ZldQYk9WN2lEcGdhQWp0ck8xUFFGRXE2RUZrMkZPTlFaZjAv?=
 =?utf-8?B?dGxiSmZTeVUzamhGSStpallLZ2RDNWltbDRxMzBDOXVBMmFEbGJoUU85OVdG?=
 =?utf-8?B?b2NYem5ENGRRYnZnNVRJZWkwajAxelBtelh5YTBOL0hUTEJvdkRGUG5hejdI?=
 =?utf-8?B?OCs5S25sMGZNZ2w0TWVCb0RNQVdtTzhVUW9EeitwaFZZZzNqVUxEVThoRW9X?=
 =?utf-8?B?STNTTVRXeE9kcmR3Z2NtSndYSkt0aWNZTHJDdnM2MWVtMVFLcXlsRnA4Zkpq?=
 =?utf-8?B?TEJ4dzlFdmpNdWNDanhNMmgxUUZWcDZERndacURtZzQrVVpCc24yWjRGczFF?=
 =?utf-8?B?SnZhNDVlRGVHdjVjSVBxdG9acy9pLzM1M3hkR0xPMWpBVXBwQVk1T0tTSTgz?=
 =?utf-8?B?ek5oYXcwbG10Vk1DNlR4S0U5TGtjU2pIa1VOMW9pbFdhKzJZWU1UemJScjl2?=
 =?utf-8?B?bzFqOXR5T0E1aEZJU2JGdFhEWGxxQm9SMTJjZkxhV2N4NGh2TkVCZFJJUlNX?=
 =?utf-8?B?N1VYMGI0WGU1Rm9NNkNiZ01oa0JUQjl3TGJiQldFYnRqc3l2RnlVbGdYcUVB?=
 =?utf-8?B?MTJWS3gwYjNvdFdUUGFCaXdzRkNRRU02UmJEWFNKanRrTVh2WnBGME9sZUhZ?=
 =?utf-8?B?djdoTGpzS0x3OFZ0OUwvTi80UFFyQnBMUHB3Z1phYkFhTm41TCtweXFVMjZF?=
 =?utf-8?B?Z3ROdUVjRnVoYzNSZFpiSnM1TkpoQnRZU011WTB2ei9ldW9WaFdLMGpsS3Vq?=
 =?utf-8?Q?HAEUwF7wgBOdfnYmDaK/634KkbCcFv7rYplmVkJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f19485b-1ba1-4fbb-e897-08d90a44775e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 12:52:22.7677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHjVKaQCX82e11QqCuWLrZk0+aIxkDK3Kyb1FK1Rh7rr7EYi8unX0o+rnQBqV/YqTBAgSWdOtzPSyNIABqKUTDN6zhO9FlZ3gWLn/nrhBx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2844
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280085
X-Proofpoint-GUID: dKIOM_jmfMVXcnUYoDlzXemmU9wZqEDb
X-Proofpoint-ORIG-GUID: dKIOM_jmfMVXcnUYoDlzXemmU9wZqEDb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/28/2021 12:57 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 27, 2021 at 06:18:05PM -0400, George Kennedy wrote:
>> CC+ stable@vger.kernel.org
>>
>> On 4/27/2021 6:17 PM, George Kennedy wrote:
>>> Hello Greg,
>>>
>>> We need the following 2 upstream commits applied to 5.4.y to fix an iBFT
>>> boot failure:
>>>
>>> 2021-03-29 rafael.j.wysocki@intel.com - 1a1c130a 2021-03-23 Rafael J.
>>> Wysocki ACPI: tables: x86: Reserve memory occupied by ACPI tables
>>> 2021-04-13 rafael.j.wysocki@intel.com - 6998a88 2021-04-13 Rafael J.
>>> Wysocki ACPI: x86: Call acpi_boot_table_init() after
>>> acpi_table_upgrade()
>>>
>>> Currently, only the first commit (1a1c130a) is destined for 5.10 & 5.11.
>>>
>>> The 2nd commit (6998a88) is needed as well and both commits are needed
>>> in 5.4.y.
> Is this a regression (i.e. did this hardware work on older kernels?),
> and if so, what commit caused the problem?
>
> These commits are already in 5.10.y, what changed in older kernels to
> require this to be backported?

Not sure. With KASAN enabled the bug is exposed, but only during boot as 
the ACPI tables are freed and their memory re-alloc'd. Silent data 
corruption occurs if KASAN not enabled.

This is a latent bug that in upstream was more readily exposed with the 
following commit:

commit 7fef431be9c9ac255838a9578331567b9dba4477
Author: David Hildenbrand <david@redhat.com>
Date:   Thu Oct 15 20:09:35 2020 -0700     mm/page_alloc: place pages to tail in __free_pages_core()



This is the failure with latest upstream stable and KASAN enabled:

[   22.986842] OPA Virtual Network Driver - v1.0
[   22.988565] iBFT detected.
[   22.989244] 
==================================================================
[   22.990233] BUG: KASAN: use-after-free in ibft_init+0x134/0xb8b
[   22.990233] Read of size 4 at addr ffff8880be451004 by task swapper/0/1
[   22.990233]
[   22.990233] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.4.115-rc1.syzk #1
[   22.990233] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 0.0.0 02/06/2015
[   22.990233] Call Trace:
[   22.990233]  dump_stack+0xd4/0x119
[   22.990233]  ? ibft_init+0x134/0xb8b
[   22.990233]  print_address_description.constprop.6+0x20/0x220
[   22.990233]  ? ibft_init+0x134/0xb8b
[   22.990233]  ? ibft_init+0x134/0xb8b
[   22.990233]  __kasan_report.cold.9+0x37/0x77
[   22.990233]  ? ibft_init+0x134/0xb8b
[   22.990233]  kasan_report+0x14/0x20
[   22.990233]  __asan_report_load_n_noabort+0xf/0x20
[   22.990233]  ibft_init+0x134/0xb8b
[   22.990233]  ? dmi_sysfs_init+0x1a5/0x1a5
[   22.990233]  ? dmi_walk+0x72/0x90
[   22.990233]  ? ibft_check_initiator_for+0x159/0x159
[   22.990233]  ? rvt_init_port+0x110/0x110
[   22.990233]  ? ibft_check_initiator_for+0x159/0x159
[   22.990233]  do_one_initcall+0xc3/0x480
[   22.990233]  ? perf_trace_initcall_level+0x410/0x410
[   22.990233]  kernel_init_freeable+0x54c/0x66e
[   22.990233]  ? start_kernel+0x94b/0x94b
[   22.990233]  ? __switch_to_asm+0x34/0x70
[   22.990233]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
[   22.990233]  ? __kasan_check_write+0x14/0x20
[   22.990233]  ? rest_init+0xe6/0xe6
[   22.990233]  kernel_init+0x16/0x1ca
[   22.990233]  ? rest_init+0xe6/0xe6
[   22.990233]  ret_from_fork+0x35/0x40
[   22.990233]
[   22.990233] The buggy address belongs to the page:
[   22.990233] page:ffffea0002f91440 refcount:0 mapcount:0 
mapping:0000000000000000 index:0x1
[   22.990233] flags: 0xfffffc0000000()
[   22.990233] raw: 000fffffc0000000 ffffea0002f914c8 ffffea0002fa4708 
0000000000000000
[   22.990233] raw: 0000000000000001 0000000000000000 00000000ffffffff 
0000000000000000
[   22.990233] page dumped because: kasan: bad access detected
[   22.990233]
[   22.990233] Memory state around the buggy address:
[   22.990233]  ffff8880be450f00: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   22.990233]  ffff8880be450f80: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   22.990233] >ffff8880be451000: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   22.990233]                    ^
[   22.990233]  ffff8880be451080: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   22.990233]  ffff8880be451100: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   22.990233] 
==================================================================
[   22.990233] Disabling lock debugging due to kernel taint
[   23.047129] Kernel panic - not syncing: panic_on_warn set ...
[   23.048110] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G B             
5.4.115-rc1v5.4.114-21-gf9824ac.syzk #1
[   23.048110] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 0.0.0 02/06/2015
[   23.048110] Call Trace:
[   23.048110]  dump_stack+0xd4/0x119
[   23.048110]  ? ibft_init+0xc3/0xb8b
[   23.048110]  panic+0x28f/0x6ad
[   23.048110]  ? add_taint.cold.9+0x16/0x16
[   23.048110]  ? ibft_init+0x134/0xb8b
[   23.048110]  ? add_taint+0x47/0x90
[   23.048110]  ? add_taint+0x47/0x90
[   23.048110]  ? ibft_init+0x134/0xb8b
[   23.048110]  ? ibft_init+0x134/0xb8b
[   23.048110]  end_report+0x4c/0x54
[   23.048110]  __kasan_report.cold.9+0x55/0x77
[   23.048110]  ? ibft_init+0x134/0xb8b
[   23.048110]  kasan_report+0x14/0x20
[   23.048110]  __asan_report_load_n_noabort+0xf/0x20
[   23.048110]  ibft_init+0x134/0xb8b
[   23.048110]  ? dmi_sysfs_init+0x1a5/0x1a5
[   23.048110]  ? dmi_walk+0x72/0x90
[   23.048110]  ? ibft_check_initiator_for+0x159/0x159
[   23.048110]  ? rvt_init_port+0x110/0x110
[   23.048110]  ? ibft_check_initiator_for+0x159/0x159
[   23.048110]  do_one_initcall+0xc3/0x480
[   23.048110]  ? perf_trace_initcall_level+0x410/0x410
[   23.048110]  kernel_init_freeable+0x54c/0x66e
[   23.048110]  ? start_kernel+0x94b/0x94b
[   23.048110]  ? __switch_to_asm+0x34/0x70
[   23.048110]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
[   23.048110]  ? __kasan_check_write+0x14/0x20
[   23.048110]  ? rest_init+0xe6/0xe6
[   23.048110]  kernel_init+0x16/0x1ca
[   23.048110]  ? rest_init+0xe6/0xe6
[   23.048110]  ret_from_fork+0x35/0x40
[   23.048110] Dumping ftrace buffer:
[   23.048110] ---------------------------------
[   23.048110] rb_produ-210       3.... 7555323us : 
ring_buffer_producer_thread: Starting ring buffer hammer
[   23.048110] rb_produ-210       3.... 17555348us : 
ring_buffer_producer_thread: End ring buffer hammer
[   23.048110] rb_produ-210       3.... 17640105us : 
ring_buffer_producer_thread: Running Consumer at nice: 19
[   23.048110] rb_produ-210       3.... 17640111us : 
ring_buffer_producer_thread: Running Producer at nice: 19
[   23.048110] rb_produ-210       3.... 17640113us : 
ring_buffer_producer_thread: WARNING!!! This test is running at lowest 
priority.
[   23.048110] rb_produ-210       3.... 17640118us : 
ring_buffer_producer_thread: Time:     10000017 (usecs)
[   23.048110] rb_produ-210       3.... 17640122us : 
ring_buffer_producer_thread: Overruns: 4460970
[   23.048110] rb_produ-210       3.... 17640129us : 
ring_buffer_producer_thread: Read:     3807780  (by events)
[   23.048110] rb_produ-210       3.... 17640134us : 
ring_buffer_producer_thread: Entries:  0
[   23.048110] rb_produ-210       3.... 17640137us : 
ring_buffer_producer_thread: Total:    8268750
[   23.048110] rb_produ-210       3.... 17640142us : 
ring_buffer_producer_thread: Missed:   0
[   23.048110] rb_produ-210       3.... 17640146us : 
ring_buffer_producer_thread: Hit:      8268750
[   23.048110] rb_produ-210       3.... 17640150us : 
ring_buffer_producer_thread: Entries per millisec: 826
[   23.048110] rb_produ-210       3.... 17640154us : 
ring_buffer_producer_thread: 1210 ns per entry
[   23.048110] rb_produ-210       3.... 17640157us : 
ring_buffer_producer_thread: Sleeping for 10 secs
[   23.048110] ---------------------------------

2021-04-26 gregkh@linuxfoundation.org - f9824ac 2021-04-26 Greg 
Kroah-Hartman Linux 5.4.115-rc1

Because the failure occurs during boot, syzkaller did not expose this bug.

George

>
> thanks,
>
> greg k-h

