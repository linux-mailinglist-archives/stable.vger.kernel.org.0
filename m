Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A4F341B54
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 12:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhCSLVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 07:21:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45316 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhCSLVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 07:21:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12JBJAQA003733;
        Fri, 19 Mar 2021 11:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NVMu9Racx+W2kfqHY95/qWwWgX/IzndcZa6S6tkiyn4=;
 b=RPtRCXgQh8yja7Nyga2uUXpFU4JxO1P8DONzaJvupRdFEwRSkp0Nvu0a+I4annd3oXi2
 0crUu22vLV19n212yXvkTxkr7gc3zOReb8/QrgM6n7hwclxZ2GZpeU39lb5ZdpmKi85I
 qbaveFDhH6fP6kQTdeIj604A2l75PZ+xkN4kF4Jp+kcy65a2mss1rY/dKKYT1Eh9kgEa
 rqVuc/gy+jnZ9l4tu6jf9vTuybd59NhPZYYdMBILu2QZz/yXAUIweUqcwQjqtsv7088Z
 2nlrL5kqX57Lr/BCSsbp7J61w0E42K7nRUpVSRxv7Bc1C1jNT25cwC8IK/Trbb4BGNeg Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 378nbmjpg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 11:20:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12JBJhCJ063913;
        Fri, 19 Mar 2021 11:20:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 37cf2bn97s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 11:20:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PChUYwfQ9EqQxi/z0zTJrEcpiwdBInrzAnXskhTE/YMjGdgKeaEpn9JigXvaSlVDlDmNP0at5IgCeh96kEmQwpaE9QVxZFn1iVKcYa+KueX/teLxoAIVJCEQyv6dbNcPO5SqyC/Fu+D15qDmhHFpXo/+6cEWj1d7K4+iMTXoVKhWXyDhVwdOb3Lh6U+n8wvkd6QsQqF1SAMwG+Ai/tWeVtF2QNjedOMkiTZEt0Zmj0bTdjxmAAr/lCE0SzGDPEPcdCp8UXOr9mdmuPr2ne4SNOR1jHJwUMjAMerk602sKY770+deA/8n/A2qUdQ77O5wrZoAek2Fi/mxZ73ddG2usg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVMu9Racx+W2kfqHY95/qWwWgX/IzndcZa6S6tkiyn4=;
 b=GoKbAeugPe3sJ3aKQEzWuwJAtuGiBBodl3HG5eboCsBXvK4yjUgs08Du5KN6RMyBKk/Vc3tyBWqCG76gMCLCJrk0ZCIi/525z8OoB7JJqzR1/YVjk5d6qcmjAtPURM1ImQF8H1VyHg7RHOuYBgeD21tWKx/eXeHnxbBfCZd7eyyLmew5NvElh/8mjs5sV4shNoMyfAXW6rF1PDJtF1z+9n6zsawvdMgPgxJ70uNe7aDRNbXpveatdQgcy0v7wIPfH6WwLcATKbSK2U0cIRyDZ6hSf2MDZpU/oxRdwpIWDCHV35EsqecHEIf4s/hbRgqyP2d2AVzD5GQogqSSFgNwJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVMu9Racx+W2kfqHY95/qWwWgX/IzndcZa6S6tkiyn4=;
 b=NVRZBs/7awSUvi+yG7jPs0QXfYEPPJYyXrFLV/QB1xTnQfqrWBEdd4qnyxqfHIfHT5lUI5/7aHwcoUzJKtZfrd1kWs2rX3WuUNhGSFWJTVdDhKXqTR8lu0kfgoP1LY1gmT2VUdQGo+6lD2OxHuI36EpyIj5cF72u/znWoa8L6f8=
Authentication-Results: lists.ozlabs.org; dkim=none (message not signed)
 header.d=none;lists.ozlabs.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH0PR10MB4905.namprd10.prod.outlook.com (2603:10b6:610:ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 11:20:30 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::652c:d431:87f4:b6e]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::652c:d431:87f4:b6e%7]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 11:20:30 +0000
Subject: Re: [for-stable-4.19 PATCH 1/2] vmlinux.lds.h: Create section for
 protection against instrumentation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Boichat <drinkcat@chromium.org>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210318235416.794798-1-drinkcat@chromium.org>
 <20210319075410.for-stable-4.19.1.I222f801866f71be9f7d85e5b10665cd4506d78ec@changeid>
 <YFR/fQIePjDQcO5W@kroah.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <b5d3d0ed-953e-083d-15f6-4a1e3ed95428@oracle.com>
Date:   Fri, 19 Mar 2021 12:20:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YFR/fQIePjDQcO5W@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [92.157.39.73]
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (92.157.39.73) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 11:20:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29a2d591-69d4-410e-2558-08d8eac90107
X-MS-TrafficTypeDiagnostic: CH0PR10MB4905:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4905DDBD05D14A36ADFADF349A689@CH0PR10MB4905.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pFev7Hh1S9LxbS80FyRX+xbcsUC5uQAZzuondD3cL+lzrb8L4LvUTWHLg5VW7CoIGWmV3uRAOK9DedszNTW5679bOvNtJ4U3vjDt3eLLEvTHDcxP5sITwmQhNAk7khpwy5i8TUMTb0YE6FdWoGbvlEg0SpSTfESmHqK4y+LKWB0qSD9SMpMN2hhwE07QI6Qvbv7Qbm7I0UzuTrrnIfLmQAgTuiPBrJ/CTFkOtHRbLJHzRO5+hHECWzgAJDU7lWyNJdiRldw1BwziBOH8pvAmfexfwY0tdQf7R3VbenmBEtCQ88d6tMH939D5jYViVq2/5PKI0SfuI0T44x1ixYFkS74hR8yKSKUVD3Ms/joODLqdJmsW7ze5/aiKM7Z5/sdb3/YzVwDb5RYdQTesMqt8FYA9vF8Zb853CFcPoQ7Tg1YbiCRQKh+1HM02XnSIoh7bHgjEf75mnjK8mB8pAO1VT7x5CqFVp36HPFlDEj4tqlKfhaCe6QBCw4Fv+8CUhwISX+oczwoSV3hVrFqfcTOh+chM11JUIGpHI6wDHfIBZyAp9KL14upv2GtinwKJf3Zdb37pavpyeZA6FaooEnfs1zevyJnSmxz51J4eyk5/bH/TzOnmYiYUTD5OHG0xvtKrZfzX1P7IlCcSyPaROvLIc+5fqBKSiCA2c+h0UAxhAVlCoyWfOC5IQ9Y59JgKCy7M8TqW+bUzlmr70xPrVyaFtSY1D0ChjpZXw20Oxr6vKtMQhUPlxypVQflj9B0/+7nDn1mqyfOuSfzHTPdnEuAIvxu7jJ0SS4+Ol11V1vKOm5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39860400002)(376002)(346002)(26005)(36756003)(186003)(2906002)(16526019)(83380400001)(53546011)(6506007)(8676002)(5660300002)(478600001)(966005)(44832011)(316002)(31696002)(54906003)(38100700001)(4326008)(8936002)(6486002)(66946007)(66556008)(66476007)(6512007)(7416002)(31686004)(86362001)(6666004)(2616005)(110136005)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QysrS0JNVndjeXA2TjlyRmxzdERxSFBTVEVHeG9WbldwV0Ezdmk2TTRpWVFU?=
 =?utf-8?B?NDNFb0hVWjlDZG0yOHN5SGd4Tmp6T1AyeE9wMTdKbmNBMEpJMTh3b2ZyaWsv?=
 =?utf-8?B?d2FoSmZ5Tk9paC9CMytqNElteGl1RlVuRjhnK0ZDcHNVWVYvY0g4QnJvZ3lp?=
 =?utf-8?B?VGQ3VUpYdDNlbFRKSkx1WktmSW1BRHdUazV5WDg0dnRSZ2dObTFSZXZwOE9l?=
 =?utf-8?B?ZDAxeEt2bHF1dkJkSE1CTWl2WEhlWnVtVCt2c201a1dmeHhsRkFZaGc3K3JY?=
 =?utf-8?B?UUt4VENCOXFPTnhoVDJnR2ZlUjJjNkFBVW9PbUE4OEpLZ096NmNvRC9VTEJ2?=
 =?utf-8?B?cnNXMWdHbENicjUxM3BpV1FldDBsMnF6RkdPd2FFOFpiWDZaSmxYTnhDQS9z?=
 =?utf-8?B?cWlsbVVvaklnSHlONE9uQVh5aTQ4UUZyNk8vMVZYNXowTklqNmQ0QU0zNnpp?=
 =?utf-8?B?QWZxL2gvZVhSdUthNkVYZEZ4WkVpV2FsM0Z2Z3Z3a2xzcWdIT3JaQU1iYzdi?=
 =?utf-8?B?cCtjRmpMajVyMTlrejl3R24rNDNmcFJCRTcyTTVuM3VCeU5ITzRNK2pUYndh?=
 =?utf-8?B?OEpqcTRXR2RSa0laNHRudzFwZUk3K3daTE1UbHZoZnVwejY3eEM1N0hGSEEr?=
 =?utf-8?B?L3o4SFJKVlFsVnYvUW1kZUZEUmFWcEtJSkt2YUZhb2tpSENwQTdYQWxFZGV4?=
 =?utf-8?B?cit5a2c4dTFlUlNRa0tvNEdDL1ZuRFl1eFdMbm45YlEvcDVsSDFWMEo5cTdC?=
 =?utf-8?B?TTlrblZqT1ZlMWVNK3pLMnh4RXBwakxyaHI2VlZha2lwTmptMEExeVovUlFL?=
 =?utf-8?B?MytlRTRabDB6RmZRbVVUdU1kZVVYa1VQUFFiN1RHSklYWTc3N1pvaUJGYmhz?=
 =?utf-8?B?NGlLaStmWEdTbk1ia0dwY0M4c3NkQUdoWERXVkhhYmMzUkVwVUQvTDNTelc3?=
 =?utf-8?B?MjM2WjdKby82M3owNHBud09TemdpN0Q3cVVwMEpBYXgyZTdHYzM1dEtjR2FN?=
 =?utf-8?B?YjBKNUVFbTZWVit3eDZCMDdoUWtzOERzUTVhdmpiVXc1ZjJaL2VJSC9CaVR5?=
 =?utf-8?B?ZCtsYWJONCs3ZldHd3hob2I2dS9jNWhKK1BOYnNKeGk1NzZmZkUxc3hLWHhj?=
 =?utf-8?B?QVY2c1IzRDFuOXQxL2JxR1JTaVFjQnN3ME9lMTdtWURnNnllRXkzbjd4SnVC?=
 =?utf-8?B?OTYrclQ3UldFdldzdFBybjlzZDhIeFlPVWIraW5mOUdXOVpqWHBnU3NWK1ZG?=
 =?utf-8?B?eExEM3pGRzBSWkJQZENBMXh1aXk1THJEaHpxY2JhLzh2SkZ3dWlHSUk5VVFr?=
 =?utf-8?B?WUplV21EUjdVTzRWOEdJVkZjYXpkY3dsMTFUQnJTRGRMQTFCQk5EUkJuOXlt?=
 =?utf-8?B?KzAyVjRndHYyelZYMkhRWWtmanMzRUR4dUZNNDVMbGFJbm5JN1c0Qzh2R2dp?=
 =?utf-8?B?dW5RYUFHYUFDSFZOVDFTWkhvZG5qcnZnMmNTb09hRlQ4bGtSeGIxNEtjbEdn?=
 =?utf-8?B?UGFYTm95dzNlTnhiWWEydnd2Z0FzWnBWckhwbmdLRFVsekN0dHUzMzJLcERv?=
 =?utf-8?B?S0RWOExGY3VDRndpTkRCMHRxeHBOSEVZSENqRDdPN2xaREswTmRacU8vc1Nn?=
 =?utf-8?B?bmcrTkIzZGtMWUEzVlRONkh0QUVLU1VXNzRhd2ppNFEwYWV5QmlCNGxMN0Yv?=
 =?utf-8?B?RDhmdnluZ0xyL3ZFeVdEYlY3Ulg0TEdQU0VETnZSWnNRMGFYRDVTdXQ0cERH?=
 =?utf-8?Q?Jd3kyf02BO9cMiYfleQwvjqy6EJC7xyqw8cMbaP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a2d591-69d4-410e-2558-08d8eac90107
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 11:20:30.1498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6g2WCUkDwnrY7K2EzWv028BmVRjJJAvJ3hkNvjxk8waf0pQ1LTkWyEcNLioULrc9qD53S5hXdMyB0nx69+3fDg2/kFOynU5V0dZRCy+frvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4905
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190082
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190082
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/19/21 11:39 AM, Greg Kroah-Hartman wrote:
> On Fri, Mar 19, 2021 at 07:54:15AM +0800, Nicolas Boichat wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> commit 6553896666433e7efec589838b400a2a652b3ffa upstream.
>>
>> Some code pathes, especially the low level entry code, must be protected
>> against instrumentation for various reasons:
>>
>>   - Low level entry code can be a fragile beast, especially on x86.
>>
>>   - With NO_HZ_FULL RCU state needs to be established before using it.
>>
>> Having a dedicated section for such code allows to validate with tooling
>> that no unsafe functions are invoked.
>>
>> Add the .noinstr.text section and the noinstr attribute to mark
>> functions. noinstr implies notrace. Kprobes will gain a section check
>> later.
>>
>> Provide also a set of markers: instrumentation_begin()/end()
>>
>> These are used to mark code inside a noinstr function which calls
>> into regular instrumentable text section as safe.
>>
>> The instrumentation markers are only active when CONFIG_DEBUG_ENTRY is
>> enabled as the end marker emits a NOP to prevent the compiler from merging
>> the annotation points. This means the objtool verification requires a
>> kernel compiled with this option.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>> Acked-by: Peter Zijlstra <peterz@infradead.org>
>> Link: https://lkml.kernel.org/r/20200505134100.075416272@linutronix.de
>>
>> [Nicolas: context conflicts in:
>> 	arch/powerpc/kernel/vmlinux.lds.S
>> 	include/asm-generic/vmlinux.lds.h
>> 	include/linux/compiler.h
>> 	include/linux/compiler_types.h]
>> Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
> 
> Did you build this on x86?
> 
> I get the following build error:
> 
> ld:./arch/x86/kernel/vmlinux.lds:20: syntax error
> 
> And that line looks like:
> 
>   . = ALIGN(8); *(.text.hot .text.hot.*) *(.text .text.fixup) *(.text.unlikely .text.unlikely.*) *(.text.unknown .text.unknown.*) . = ALIGN(8); __noinstr_text_start = .; *(.__attribute__((noinline)) __attribute__((no_instrument_function)) __attribute((__section__(".noinstr.text"))).text) __noinstr_text_end = .; *(.text..refcount) *(.ref.text) *(.meminit.text*) *(.memexit.text*)
> 

In the NOINSTR_TEXT macro, noinstr is expanded with the value of the noinstr
macro from linux/compiler_types.h while it shouldn't.

The problem is possibly that the noinstr macro is defined for assembly. Make
sure that the macro is not defined for assembly e.g.:

#ifndef __ASSEMBLY__

/* Section for code which can't be instrumented at all */
#define noinstr								\
	noinline notrace __attribute((__section__(".noinstr.text")))

#endif

alex.
