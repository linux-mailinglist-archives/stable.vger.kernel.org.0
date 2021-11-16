Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC5452DD1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 10:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhKPJYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 04:24:19 -0500
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:46080
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233006AbhKPJYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 04:24:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDC/blY5RvLLVCRuMw1VF+2SBF4EPYa5UCbdGzA0RXbJx+5rjFAWOwiQsIWPW2lAKJTQ12w07P6vTgljMeN8WRPeJPD7U33uSw9UDfB5GAbsFn8OlTL5oimwQLZbne7uH6CL2rGWMWmQMwVtJOUTMqg9xYxusgaJhP39K5QwoMHXrIPQk1yCGsFS+xfmUlwld+4/2eg/1llx6cJXYKu1IeJiM5G+nF76B6EXyjY4LxTKloAhDbn9fLirdaoBDzbVnlFryhy63yGWtLXBvNfTNwga93A+VCqk6nrzXqVIFr+euroLKhxkwx46AnPAgksimcdgIn5uW7LjkNRZrBfw6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RAi6+nHlkGYMOPgBAL+hJ3Uw0MkCsu8lwmj6lqefHZ8=;
 b=Fef5jwpl+v2CcaToTWYUNjkSAFgZq8ujbdkroDD5JOOa9i6HTHftjtnivt3yO2kwT8cHy58S11pwd4wQsx8QwKhWZqu9j3wwQ7j18d5Z3gj1Yxtjhi3qU+Ao8oa2YwEteozlr2NXn1h2NT6SHcN1N8tbTWeU03JKnfi58O6qvNyEdeO6mEIJ7WwpxCgZySC6L9c6cDjtTpZIO80vqB/O+7xhKgcZKmEoaurxqGvuTCcQ3j1X2PEG1mXNC+f5Md1jJBaFRt7Ly2QdgksiZuUmLzjYGuALKLAMQkX3tpvGNezBsB21gI7c3MUzoZ5zejHvHVcO4dL0qRcaY12zuxkEQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAi6+nHlkGYMOPgBAL+hJ3Uw0MkCsu8lwmj6lqefHZ8=;
 b=gJ3WMHx1iiOBp3jnZqWbl5/Gu2+AFPMVJ5y5j5d9QTRTDHPU3U5Y4ER3BbBSVfWvALIcAQAqfaQLfmvTlHP+E+hSDTK6Z9gt7HumZZVJBAuTepaUYi9VJ2GPRdWgUTuSNL5kk2bKHifJVOgcGifthwRnYG5PYmOC281MbfU8beyAVupB7nNrSNXEDOHYd8n8ksg1B33dgzPJ1Q9kjapEZqIHWvgW8cny4dIlbMG26G1qPRX1Vqg2tkDIztJFvJdtZNof1VhbanjGhvj9lNpHUdle81QmoZKTEnSTimJhydcGugrA4J+S8fFoOj1QZrad+M+IUNOCdIKCzH3jRw5EIA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5103.namprd12.prod.outlook.com (2603:10b6:5:392::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.15; Tue, 16 Nov 2021 09:21:07 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86%9]) with mapi id 15.20.4669.016; Tue, 16 Nov 2021
 09:21:07 +0000
Subject: Re: [PATCH 5.15 000/917] 5.15.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Anders Roxell <anders.roxell@linaro.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211115165428.722074685@linuxfoundation.org>
 <CA+G9fYtFOnKQ4=3-4rUTfVM-fPno1KyTga1ZAFA2OoqNvcnAUg@mail.gmail.com>
 <CA+G9fYuF1F-9TAwgR9ik_qjFqQvp324FJwFJbYForA_iRexZjg@mail.gmail.com>
 <YZNwcylQcKVlZDlO@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <dabc323f-b0e1-8c9f-1035-c48349a0eff4@nvidia.com>
Date:   Tue, 16 Nov 2021 09:20:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YZNwcylQcKVlZDlO@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0053.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::17) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [IPv6:2a00:23c7:b086:2f00:5a53:1500:28ae:ff6a] (2a00:23c7:b086:2f00:5a53:1500:28ae:ff6a) by LO2P123CA0053.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 09:21:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 235daa9c-c72d-45a9-23e6-08d9a8e26b7d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5103:
X-Microsoft-Antispam-PRVS: <DM4PR12MB510337EBEC97E943026A0187D9999@DM4PR12MB5103.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FXx8FG8UYHlqM/Fustd+G2cQAvq8DygPmZXeIaowtCp/nllTb52uZNbQ1b4y3jowXr9guZUnf1RXjFtqmFtRXcBlW94UJWvLWDL7t7a/oItNZFbJE8b8Fq2Qtsvfo8yKSv8ks1dAT1EPPhuFueg79Ivt5IGVOvOwOoluv67QU4jVhysrUbd+Q2fbcUPJdA1GhEo+lNM/R6v9EB+6veivGi5IToFMdmIPOcsNkin8fNYk28+gc/HNixjmg1qGfDtacKO2CKp8I2wjSOp7Wpuda6ja98qFfdw0z06cKfegf+SAGg4EqRPH5iheJFKfBGq2eGpha0TVr/qWIoUm6A1InqW36kxiQBhrBd1+4hBlEzlCQcUBgGEOKMIy/tN/e7ePNex+cLg3fj8TyDjVL4/SkbujuUql3izbcrysA+ARCKW7JVsc8RPk00l+JepGPTuU6mV/mpFw6NzRo3m1QseeyMGY4DdOpxKRxxSVFaOd7WwVOCSDqVdOeANY1nLdt0Yz2lJ3i2N97AS20xV/P14y+xrS9Pg0Bhbw3i7RBBwpBZv7nmFPAeGZcSgAyLYXoryD2C7H6NONgswItumCPykZDkj5rsZluOZB5IVXKgSsGbAoxpdsoGAqUEyzuY1vWRDjiuy0IDMI4arSkztH3zDM+1r8QUYL7HpHJ0tOzsOKSDT7E/XBC1xiE5S3jlCKPZ6S3H+4f6ipyeSoqYzxckgOy+91YCt4N122VjUaKuK2ChVhsCE9XVHGoN4IWIH4PxxSselGO/4+5rKP2Ex2kZ/Oh3sEvAYqL9Z+tASMkja1Vynbj5VzVMJ4QAx1LHMd+S+aYaUmGqcfD8GASw6HPFdB9sDAUsk7ormTHGG4i9HAYI33bukv7IE9gHvlA4RvGGsG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(86362001)(66946007)(5660300002)(66476007)(53546011)(2616005)(31696002)(186003)(54906003)(966005)(7416002)(4326008)(6666004)(8936002)(66556008)(31686004)(316002)(6486002)(8676002)(508600001)(110136005)(38100700002)(36756003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWkxd2k2VHlmVVZmWE5nZ0JnSEUwUUZycTg3b3M0T0ZjU0s3VkJSTTgyRUJr?=
 =?utf-8?B?clRhV084M2d2clBaK05PRmZ2Q3FVa3JKaSt6TmZTMm9ZTUU1UGc0OEFtSlZ3?=
 =?utf-8?B?T1RCcEl2dUdzOHh5TkgrMFFGSWs4RWJMR0NRSVIvdGdNRGg4Z3V6eWlyYlZi?=
 =?utf-8?B?UGpMcnQ1QUtad0ZzQWJXWEFqSXUrdjlrWlZMMGpFTkFxSVpZQy9HaHpCdlBy?=
 =?utf-8?B?cXBDVXZENjhqS3hKS2ErRzkvcldjT09FU1hvQ0VaZktla1MrTlRWUmEwT21K?=
 =?utf-8?B?VExxLzhaSnJPWWZsVUFjSDNqMlRyb1RWMlVPWERBSkhPTFpPWHpEazdKbjkv?=
 =?utf-8?B?cGxlamdocHE0VDJtUENldE5hU1NlazYyZTgzT0xURmd2UU5RWkJBYkNYN2Vn?=
 =?utf-8?B?Mk9BM0xqb3BTaEZJK0J0a08wSkFwTGJJMlZNVzVGbENtYkRzNjlzMk5ERzVv?=
 =?utf-8?B?dzNPSG1LRFNMVFF6N2hnTytiL2Q4WVdKU0FmQjM0dXNENldLYjJLSDdhejhN?=
 =?utf-8?B?WEpTNG93Um9weFJUd2hndmk5ZmdoQ2dZZlJ6SFg5RmxMbEUydU53Ynh6UWFI?=
 =?utf-8?B?NU1SdldsMUdRSzhGTnlvOFUxTkhYMW1qRkFrWWIxYnlhWWNOKytIb3lFZkts?=
 =?utf-8?B?VXIyZ1M5TTUvSlp6N2ZKQlhUN251NzFCU1loaEdLaEFWblVtbXJma0c4SEV4?=
 =?utf-8?B?dFB0TUhkM3p1QW0xSmc3T3ZMcHRjLzFQYVNqQ05hN2h4NzdFZHd0NlkwTnIv?=
 =?utf-8?B?ays1VWthVmZwSnBDdHlRSnZCSHViRmZqemFWcnk3Z3VndkJRUG5GV1pnbXBD?=
 =?utf-8?B?YzVQVmpOSk84b2NuM01raUw5M3Blc3AvSy91RzlZYUI4UFFlYTJlSXNhc3pZ?=
 =?utf-8?B?aGc3YVdhS3RMK1RqYk9CU3Ruakl0RWxYalVtdWh3M09EdzNBaXpJdlQwUC9X?=
 =?utf-8?B?K0k0eTNVTWRvcU9kS1RXQ1ozZEhiQXFuVTVZUFkrYzA5TWZKNmVHclRhc1p6?=
 =?utf-8?B?NlU5eUsxVkFzb3RXQm93NGQzV0I2R0xuV0RmbUt2V2NZOTNqYUhFZXNYVlVT?=
 =?utf-8?B?R1ZCTXlTYzViTy9hRENxUkVRSDNLYmZoai80OVJmMElic2I0RVlpWlp5RXNC?=
 =?utf-8?B?NzkyNjVUYkE1UmFmQkFQT0JHTTVxMnZScG9zaHZ4eGtGemRzWStsZlgzdVZV?=
 =?utf-8?B?bnRxZkROYTlSM1ZTSFlNQmZ2dFlCbFBkVFJhREhQS0dBUEppZWVaK3IrR0dl?=
 =?utf-8?B?R0ZNT2hFQ0hDT1lUdmhFdEh5VEljbjRoWnl3YlRPN21RYUxNR0ptYTJWbFBB?=
 =?utf-8?B?ZERtcVl2UnJ4R1lrUFNUOW0rcnFUZFRpK05GVnNrMWxkWTJpWTBkM3luMWJD?=
 =?utf-8?B?YWYra0pNSHZ1ZVVTOVpQNllLUStlbHhzUkROaWNBVytwYklkb3h1WjRRMGpp?=
 =?utf-8?B?K1lHakV0SFBuSGF3VGJTZ1V3S1pUS1BsWjFxRDBSTzR3c09tY1hGaDBCOXFo?=
 =?utf-8?B?NTgvdU43Uk1YWVFHNEI2Zi9UcXVKR3pmR1ZBOVMrMTkwbzRQY3JJQi9ZMkFv?=
 =?utf-8?B?RnU3a3ZxY1hsWGQ0d1Vqb3pCVGUvWXlGWUxibDN6c3l4R0Y1NDJHN0ZSY2Iv?=
 =?utf-8?B?aThCZnlHVHdWa1MrSnBmTjljQU5ORHZndGZFNUtqS1FKbTVxeXc3RThsazdu?=
 =?utf-8?B?M1BDM0NJUXlQNEE3c3JOOUpadmpQV0tWSVBBT3o0L0VSS1JiNm9tQ3psZkJk?=
 =?utf-8?B?Wk5LcFdJWE1NWEVtWmxsanFBWS9aZEVrZWY2Ung3KzU1bHl2VWZrZnhRZTZF?=
 =?utf-8?B?RysrNDJFNkhLS254UGw0TC8vMk1wd1E4SVJHOHJhVEpia1F5ZTFmVHNvUjJh?=
 =?utf-8?B?c3VqanFnNmJvcDAzZ1hJWnJyWDVBTGVaak1vVis3MWxmaGZZSDBocUtqRDZ3?=
 =?utf-8?B?eTR4OUp1dWl2cDZ5ODJLUk5USTJtMGpBRnJLRXBNdWhObUxlYnI2aHRzVWM2?=
 =?utf-8?B?UmtFYWtIMEQybzVZTjg0djgvMWhtN2lRTjluZHZ4UTV3a1IzVVpEQitVbGZp?=
 =?utf-8?B?OWdZRVFsckZmK0YvTk5VUEwvemdEYUF3c2JpWTluNTN2Ui9mUWRhSzIzU292?=
 =?utf-8?B?K1k0M0hrd1VvcE45dVFJOGNMMjVRNXhwRXBVZmhFLzh5VC9mRStiQVpqZWx0?=
 =?utf-8?B?NDlNVHg1YjlQOCsyUzVvbEdPK0twZ1RVdzJMaUgvbEV6MW50dWd6NWFUbzF2?=
 =?utf-8?Q?c2JnuPwzTPelHiYP9r9omOmRGRf7jGPgzXKnakoM5M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 235daa9c-c72d-45a9-23e6-08d9a8e26b7d
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 09:21:06.9880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYTfc5N+BuJemt7bA3L94/SNAA59sZuSpgZrCA5X1wgPVAtQRQOZhRIhfb4Zn1sRBIXzAAGS/xQct9ksNss9AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/11/2021 08:48, Greg Kroah-Hartman wrote:
> On Tue, Nov 16, 2021 at 02:09:44PM +0530, Naresh Kamboju wrote:
>> On Tue, 16 Nov 2021 at 12:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>>
>>> On Tue, 16 Nov 2021 at 00:03, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> This is the start of the stable review cycle for the 5.15.3 release.
>>>> There are 917 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc1.gz
>>>> or in the git tree and branch at:
>>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>>
>>
>> Regression found on arm64 juno-r2 / qemu.
>> Following kernel crash reported on stable-rc 5.15.
>>
>> Anders bisected this kernel crash and found the first bad commit,
>>
>> Herbert Xu <herbert@gondor.apana.org.au>
>>     crypto: api - Fix built-in testing dependency failures


I am seeing the same for Tegra as well and bisect is pointing to the 
above for me too.
> Is this also an issue on 5.16-rc1?

I have not observed the same issue for 5.16-rc1.

Jon

-- 
nvpublic
