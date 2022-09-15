Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FD05BA26B
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 23:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiIOVln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 17:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIOVlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 17:41:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5531152E70;
        Thu, 15 Sep 2022 14:41:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+I823g4WYjdC4Jgb6foDdbW7XE1EorabGDhzv+Sr4iSxiLI3m38NmbQ+ZeM8fbT1DA/EiK5TumlcwyuzIBtWx+Xgs72xOdhzGFxCvwTrDB1kMVDR6d1Pzkamk1mlVv1SidWUGwmLQheKhEr56y9kDnYMA/wJJFR1U/n8xLurSEYhaGjsF+KpYIioYoZsDTr33wE9nHHxZMozihbdkE2SypxPaQGTxe1zpj/FqQcq4BSPQw0C0Vi/WVfAsiO/USgj/RAXcQTSl2QziCpIq2oGDckZVJqS/hTZUiPeF6OQkATOHdotG9/MsnAbS44a+oGSAcC3iChPvnVTcr5tgIsqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XtCGV2Qp5ceQWDKlZkLE1b5pwvhEdm/3f2v0nGRU2s=;
 b=m0uLNLQZQgZGCMURW3rCHDke3PVU2tQLGRekl4JVKpHxJJLgbjzGzVrysGwm0EsZGZ6jnvdFgtnkuDLJGms48pJCy2O/j0ltdWXu43gW7Ze9ZYz+faIMcx+1dh9knQ1d1m0wexDTxOl+5wmldXFdJjZz6Ixnrk2iRPBqvmY+A3G73yQxSQlowoynXDgLvrFESRvmlxH3ES6S5B0fRB47YrehsKfRobXeJME6GXSeC2c224R27XPL3GMh3mVnbScsj7OFamXgMF5xH7aCpINLmQfJlGKpYnzsBjpDLgzLPdIDMhkjCbc4IuGgeshFoi/BMNQVGIamiyCSOEOw4kSWrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XtCGV2Qp5ceQWDKlZkLE1b5pwvhEdm/3f2v0nGRU2s=;
 b=W2hMAUmoDO8r1NHKmVoHmqLr214idpS1LnGgTy5KmJU+ydIfQ6Mb9ivUzVUjJEiSLc+C7s7uQ/wjnEEdTQA0IGL/1Iqc260mGcp/XT4khpFyE0bDfHtGd0VNend5q3ggmZmzY/hkjxW+sh1Zo6KRP/KYVNnzr+y+x2paN+1ovQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 SN7PR12MB7228.namprd12.prod.outlook.com (2603:10b6:806:2ab::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.20; Thu, 15 Sep 2022 21:41:30 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::184c:bf06:be40:27c9]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::184c:bf06:be40:27c9%7]) with mapi id 15.20.5632.016; Thu, 15 Sep 2022
 21:41:30 +0000
Message-ID: <4871fc14-0a6b-92f2-1b6a-2e6537fa42ad@amd.com>
Date:   Thu, 15 Sep 2022 16:41:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        joro@8bytes.org
Cc:     suravee.suthikulpanit@amd.com, vasant.hegde@amd.com,
        Mike Day <michael.day@amd.com>, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
References: <20220914190330.60779-1-kim.phillips@amd.com>
 <20220914190330.60779-2-kim.phillips@amd.com>
 <22464516-0235-dddf-09e4-6f4580b04869@arm.com>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH 2/2] iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and
 ivrs_acpihid options
In-Reply-To: <22464516-0235-dddf-09e4-6f4580b04869@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:c0::25) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|SN7PR12MB7228:EE_
X-MS-Office365-Filtering-Correlation-Id: f65f0d71-8321-47a8-3d7e-08da97630c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +8zE7cdWa9I2yQaJwxilITEErKbzGt1skwhv/f/KxD2wNlhbY4ayq4i2W+iswe77mXFcpo7qJ11fERvX6ILZgRw2vfx9yjDS2GhzXNQFnZlWa02Aj5c8nzwqJFZy+hImlabozAB4FEnmp4YnZjblWvMBwRUTYeoVqvbJ9rwGdD9L9jJwl+BIqgxdaXu/xayJs2aYnzmc2VNV9prN+cIpgPfETYaz19zwafAunT2X/WR+vC5tsY+UzwsoxDaBMHa7kyUTzH5c3t+uTAGtRFZnN3OihNzpO4/LUToxGrMFLcBmlubq4BOk6XxGsiXazNFt+mdOEWGv+XXszoKCaMQ+aw1oh/qtOOZlaw5Grw4TzQqT1wAmTRaAIBREzl+foyk9UfYo0VLBp2buDOJu9pMkkm+bXJLStzIdINRYo3P7hs4z79x4Bq2o5AM+T/cqNFPmiVFa39kY+q1/EN5RvY9/YZmW+LkDm3V44b0FznaHIh4pqSDKKxtprq+K7tCgXhZZSCzULxz1S1sPu/ZTosFy3OEkwG4P6Ltv0QI3wbmyUq4uRja0YMwbEJGs8tRNqCEQDG2g53ymwpcoa2OQV/siH4Hm/CzGe9+q5ost7l4i40zLWLWjOrzVCmKrEJ3N23hgvXmHaOOQqTGofrgOp8oclQAtsgJAymWXS2o0+LlP8JOSzKjopfyuLgov9qSBzsh6yCEf6eWI0JsJbFwoFN33uIKxf4Zd7eaYvlum1hIp8wUguqPLda2Ndw0Wd9aaxSuVngdr7qMtXIQ6/WBQHAby+H5A/AoTDqgdxd4ItnUuIto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199015)(86362001)(8676002)(2616005)(4326008)(478600001)(6512007)(66946007)(66556008)(6506007)(2906002)(53546011)(31686004)(44832011)(83380400001)(38100700002)(316002)(6666004)(5660300002)(36756003)(8936002)(31696002)(6486002)(66476007)(186003)(26005)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVVFUG55MldYVE9QSlFDYytDa2NXSUhUQi9sbkZVNjZXWVFYMFUzYUJ3dEp6?=
 =?utf-8?B?OUhkNE5vb3o4MERCZEVvME03RFdhdnd3bll2Z1pkM1crc1ZGenplT285Y2Nz?=
 =?utf-8?B?ZWVNdEkrL0ZSRmVvaVcrYyt5VjZJVGlGV1htUUx6N2NTVFBQb3JzTTRGemRa?=
 =?utf-8?B?dzJNY2JqUVpzcUpJMUlySHRLYnZQV3VuNnF5K2d0NjAzejZGM01ONFEwVlhv?=
 =?utf-8?B?Y2FyMk9TdHNhZ29vQVFoeUw1eFNlL1FPNi81MW5jQTdya2EyVXV2Z2hUVWZI?=
 =?utf-8?B?ZXVKc3oxbWh4ZEpTaGlPbXJwRmFVVXQya0ZUUjlnMnBnNmIxVit0Ny9Ka1Fl?=
 =?utf-8?B?UUE4alZuRzgvZjFXUTExdE56VHdjSHdCejhtWTc0dnJnZ2tLRlRVR2RZNzZv?=
 =?utf-8?B?ZmllZ2ZXeHRBVU9uektHUTc0Z0RjMi9rL2pMOUw4WkhTUHVVOG0zLy9PeW1y?=
 =?utf-8?B?ZjBPKzVFN3VuSW14UUlMeUI2ZmpNcUlsbGRrUUYvdTkyQVB2ckxCdnNiQkIx?=
 =?utf-8?B?T1ZhNmxGc3dmZnZaQzJucUlwTVAwTHlpbGpoVUxsU3JMcjhhUFZTL2NYMU40?=
 =?utf-8?B?dkJMeXBES1BNRkxFM0pVbWQ4bzFWdEdwY2tySlZWdzJoSWpXdDlZWDliVjJv?=
 =?utf-8?B?cGMyeFZJOHdnYmlHQ0NXMUxLMDdiMmhUdTZtVHVZNzNTUkpkRXhSRE9mb1V4?=
 =?utf-8?B?dHIxNFdUOVA3OE9lNmN2NndzT2R5cXBtS0tnSGhmR0cwNzNTOEVDQVQ0MVRP?=
 =?utf-8?B?MVFmK1FLMU9tVXNVUUtnODJlRytsQ2VlS3Vwc1JsaGVXY2I4Ni8xQnpuT0Qx?=
 =?utf-8?B?SnBKd2NyWGdwdHNMdmFUZTNTSUlNdzlsc05rbk5HODVWUTBZNXlYdHZNV0lE?=
 =?utf-8?B?VlBhcUFWc2w5cmx5ak1aVjZtNFRSQ014SVgvQzJ3ZEpoU3FwbTNRS0l0QTgy?=
 =?utf-8?B?cFlWZXRNRDgzak9vRkNwRzlnVUZZejdGaERaY08vckx4ZDZtRzdBQ2J6ZHZ3?=
 =?utf-8?B?djhPRnBTNDVZUkR0endDMXhna2Nldnk3OE9xcVNYejhoN053S3Mwc2h6RXJM?=
 =?utf-8?B?OEkzdzhNbi9pc2xyUFlBZHhxdXgzVFFPVmhnR3pXTEMvcE5qSXJ1dHlnZ252?=
 =?utf-8?B?eURWWGxyM042ZjJXVHV0R3VVR3lNSW9abUhqY3RxdXFHenpnb2ptTk8vbDRD?=
 =?utf-8?B?bldQYzJmTDVSV3pWUHFWOCtzc0xySGppNlFJSzB0dDIyKzhQeEpDWndFM2Rz?=
 =?utf-8?B?Z1hkN3BjZ2puWEpuNW5VWCt6dExmd2FrNFFSQ0Y1YmZqS0ZtQ3RrSitaZzIy?=
 =?utf-8?B?aXdpdlJiY1lhQ0kzeGZnQ201WDh2c0ZhOHo2K3RCcnNMK1lKN3IyOE1vR01B?=
 =?utf-8?B?MDdkd0VnT1B4bGYrS1U3d3R4cjB2VFZQd2RnN2tERmpHdWJSZHRLSGM2V1VH?=
 =?utf-8?B?MkFOWFFoOTdKUW42SFkwNFdEak50Q04yaWRNbWErdzVMVjZOeDNqaENZMnN2?=
 =?utf-8?B?OFFKaFQrTjFOZFVHcDd0WGVnbEtSN0xoQ0YrVU55Wlo3anE0UUJFeTlGOWYx?=
 =?utf-8?B?b1pKQTduTEg5Y1NyRTBDYko3UGVhbnZtOWhLOG45MmFCSjBIa3dTZHl1b3hS?=
 =?utf-8?B?WHEzcGRnd1JSU2dOVzRDdkdweUVuZnU0aWtQdmZxMVAwQ3NydFE0UWl4dkdn?=
 =?utf-8?B?TFNBUWlPakp3SHdoUDlKUDVmZWI4dnVFZ1M3djBRTldKdW1KZGRhMjh6SmFj?=
 =?utf-8?B?SFkwNVB4dkx0NXJmWlVXUnc0RTEyVVEreXJINC9TcWhGeXh2VXRQblJadGhi?=
 =?utf-8?B?Q1hNQ1ppaGFQREJnUlQvWS91ZlBBSjdmNVduS3EwNEYrUDdUUkRpUzdSN1Zo?=
 =?utf-8?B?RHFnT2NoVGY5M0p0Yk1pNE5BTE1zZ2prWno2WHBvUTA0dUVKeDQvSkRENi9Q?=
 =?utf-8?B?NWhSSmJURmoyOTVHZW1KZHArSXF5d2VsVHNIakc1QnExSmprYlozS2VCamhH?=
 =?utf-8?B?RWhNU0FKc1JxNGNaM09GRkNLMkVzSWxNU2kzNllpWkgvMWFxZlMrNDhPOW8w?=
 =?utf-8?B?cDZ1bGxEY3VrR1NsRE5oZ0lLVFMvSXlYV2x1U2JxTFN6UCttT0wrWCthUzdD?=
 =?utf-8?Q?i147BQ683PzWHv+CmP+azi39A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f65f0d71-8321-47a8-3d7e-08da97630c74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 21:41:30.3160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rBr7uQo3UA1G93xQ9tRz7DYcbE4CKm6bSW1tzE4AQsya/Vm+eCevjs3qyNSiZ/lltX4HLRD5Zb95AVQfV+nSRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7228
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/14/22 4:04 PM, Robin Murphy wrote:
> On 2022-09-14 20:03, Kim Phillips wrote:
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index d7f30902fda0..23666104ab9b 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2294,7 +2294,13 @@
>>               Provide an override to the IOAPIC-ID<->DEVICE-ID
>>               mapping provided in the IVRS ACPI table.
>>               By default, PCI segment is 0, and can be omitted.
>> -            For example:
> 
> I wonder if it might be helpful to cross-reference the "pci=" option and spell out the general "<id>@<pci_dev>" format?

I wouldn't want to reference pci= because pci= contents
suggest a whole slew of other options that may make users
wonder about what may also be available under ivrs_*=.
Also, pci= syntax may change without ivrs_*= syntax
changing, and since they have 0 code in common, that
would be bad.

>> +
>> +            For example, to map IOAPIC-ID decimal 10 to
>> +            PCI segment 0x1 and PCI device 00:14.0,
>> +            write the parameter as:
>> +                ivrs_ioapic=10@0001:00:14.0
>> +
>> +            Deprecated formats:
>>               * To map IOAPIC-ID decimal 10 to PCI device 00:14.0
>>                 write the parameter as:
>>                   ivrs_ioapic[10]=00:14.0
> 
> ...then we could just say that there's also a deprecated "ivrs_ioapic[<id>]=<pci_dev>" form. But then maybe it's hard to concisely express that the [] are literal here rather than denoting an optional value like everywhere else, Hmm...

Yeah, in ivrs_*[<id>]=, <id> is now optional, too.

> Anyway, my underlying thought here is that providing an equally detailed example of what people shouldn't use as of what they should seems somewhat at odds with the message that they shouldn't be using it.

The old syntax has been around since 2016, and because
of the Fixes: and stable, I think the rationale here is
we want to make sure users of the old syntax that the
old syntax is still possible.

Maybe stable is too much for patch 2/2 though.

>> @@ -2306,7 +2312,13 @@
>>               Provide an override to the HPET-ID<->DEVICE-ID
>>               mapping provided in the IVRS ACPI table.
>>               By default, PCI segment is 0, and can be omitted.
>> -            For example:
>> +
>> +            For example, to map HPET-ID decimal 10 to
>> +            PCI segment 0x1 and PCI device 00:14.0,
>> +            write the parameter as:
>> +                ivrs_ioapic=10@0001:00:14.0
>> +
>> +            Deprecated formats:
>>               * To map HPET-ID decimal 0 to PCI device 00:14.0
>>                 write the parameter as:
>>                   ivrs_hpet[0]=00:14.0

[There's a cut-n-paste bug here: I made ivrs_ioapic= -> ivrs_hpet=.]

>> +++ b/drivers/iommu/amd/init.c
>> @@ -3385,18 +3385,24 @@ static int __init parse_amd_iommu_options(char *str)
>>   static int __init parse_ivrs_ioapic(char *str)
>>   {
>>       u32 seg = 0, bus, dev, fn;
>> -    int ret, id, i;
>> +    int id, i;
>>       u32 devid;
>> -    ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
>> -    if (ret != 4) {
>> -        ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
>> -        if (ret != 5) {
>> -            pr_err("Invalid command line: ivrs_ioapic%s\n", str);
>> -            return 1;
>> -        }
>> +    if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
>> +        sscanf(str, "=", &id, &seg, &bus, &dev, &fn) == 5)
>> +        goto found;
>> +
>> +    if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
>> +        sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
>> +        pr_warn("Deprecated option : ivrs_ioapic%s\n", str);
> 
>  From a user PoV this message seems unfairly confusing, since it's not actually the option that's deprecated, it's the format of the value of the option...

That could depend on what one considers is on the LHS vs RHS of the '='...

>> +        pr_warn("Please see kernel parameters document and update the option.\n");
> 
> ...and having messages split across multiple lines that get interleaved with other output, and are twice as wordy to be unhelpful than to simply say what was expected, is even less pleasant.

This isn't common, but yes.

> I'd suggest:
> 
>          pr_warn("ivrs_ioapic%s option format deprecated; use ivrs_ioapic=%d@%04x:%02x:%02x.%d instead\n",
>              str, id, seg, bus, dev, fn);
> 
> which is concise* and consistent with how other deprecated IOMMU options are reported; It's not like we didn't understand what was passed, so we may as well make it as easy as copy-paste for the user to do what we're asking. Similarly for the others below.

Granted, done.

Thanks,

Kim
