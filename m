Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B115E7FAC
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 18:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIWQZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 12:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIWQZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 12:25:24 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976FFA831A;
        Fri, 23 Sep 2022 09:25:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7yqOGXGbEuwN0M/bZV0ws+jPImaQOAwft6la/8cNUgVaajxLEjFeVcWwATDSvfkpFpKs8J6+I7o/WliqUyKacpey7b/c8cUrWPWM8tADHsjMpknYCpSpYVp48bnX6WWJ4bEWtfFv4CplFOJWuCKiWDnJg5MXAXokB3M4VgDw7+2HsHb50ZAPPfd2DpfV+1zRtDv0AHe6JrJhdo02EcMOzlZPISofzBUbvupGjY1OtZSxj5Lbt3V7vqeShAhgKUvnD1AT1eZiPHxh7i5UO2k3PiapjpUoAPnOGsUjitc3kmm7ZEsgtlVHTB6viYVz9froFfkGnfWb9ybhVIjn7LTJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9ACFRlDEGvF9E4S4pItGVHCEcC1swWoZZ6ih+5rmCk=;
 b=CPYfSfxfkTWmPAC4SDjbOMLIS38XfWZ3Uh+O9pP1RBGbBuLxVjV09CB/ktqRsCBt1WLc916sd+GbqBFEq93h/uEI/wCOG/f4Go0n63xP1+u4fk60/6u0vCINMZC9/8hVv/e1jcHzhB8ulKJJMktAphnytcsGCUtsSFd9HMNdZiMGbd1TMlCI5TAbwED/MBE1AOOHsxRm6BPiTkG3lWN3LQiUN5qZxYmPAXxIloatoIHimHHS74SXoh35ArcqkG4x7nzX1Jt1iAa3X8zlDFs5uvrZ/sZ5VuP+SBHczu5dKSzngq00XM5ZOuGZGaV0YuXyvTFV9vb60Q4OTmBRDe0fqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9ACFRlDEGvF9E4S4pItGVHCEcC1swWoZZ6ih+5rmCk=;
 b=Kjb/5piqb1Rd1IKTGxZwMMYYROmHSakiyhSRRgl4isoaBhMBIXnh4Hytd5oNQxlYE+6Ev3F5rCcdNob41y1sonZJHClmpFy8DEPKnL41/n7bhuKeg+KVJwsZL5hks79OZKY7T0oJjrn9mhcX50KM1+ORWyYe3Wxf4lHZCtoqbjI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13)
 by CH2PR12MB4294.namprd12.prod.outlook.com (2603:10b6:610:a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 16:25:21 +0000
Received: from SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33]) by SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33%4]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:25:21 +0000
Message-ID: <f020defb-df73-35ff-5d97-c07773bafb67@amd.com>
Date:   Fri, 23 Sep 2022 21:55:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD
 and Intel processors
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
References: <20220923153801.9167-1-kprateek.nayak@amd.com>
 <Yy3U0fQ0GZYZnMa1@zn.tnic>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <Yy3U0fQ0GZYZnMa1@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::9) To SN1PR12MB2381.namprd12.prod.outlook.com
 (2603:10b6:802:2f::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:EE_|CH2PR12MB4294:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ad43c0-a1a2-4bca-22a9-08da9d8035d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOXk0majXb8ivMz3Na/D9/B/vC748TSSpoN+xyaCYx+ZmalMwGcVD9o9LWD+kmf8Yi6qn42XH/FSyU55M4tcnqzQaNJHs3ISh/HpF8OxU3j7ZChzNp0b4ZQ3GjFIrSUfUTSzDPGHUIe/yoBvjIVMYlKXUz0IyFvSCBNqSSo5uMlSf2e7SB/UsCvUyjsw+HNt9fs+OOhPNnKKsaFgdatcUgr+4dAfvvPO2adroAfSF3QnGXJp44cLm7TGeRk/sHM/1aZ32Lj59+mseAIQtpHqRWbQQsdv+JMsr0Z53pNGYZ5ohfvB4ROVRqoPDk4ATzywDLYPruO3tcgUp3u+RRhb0DuD3htrGA9kfYbFQa9yHbGHuLOxB1Jkn3HoCBypD/9aewOqYSOs5KYIv/b2aJ7L8KMuYQzKKdDYlcd8+UInc/Tu5hvGyNQQOl2p36JAn6NLKDokZMDgWpxz6ZxC3oZeOAdWhN2ydv+pAqIl6fe6e+sdgRyLx6OD/UT9fhEZJZoZK2gjfQjmEue9HVftJGituzCGnQ8HbxWbAKH4IzxZmLQ1su38jee5Sfd30ot6BaafogMID7pvmRY+M7WflhJ8FIYc1k7YwpqLoHjhkfkexK4rNjiDSdcFp9OxdIuBKuoGX9uQiyZhoS1UV1P740gz1Na4rZvxnUF+rxAWRA6MDgN1GANLjPPe0Lidedo7NgVXL3plLKyqtV/IVOS19OoF6w23l0hwYSbFJp3OtUYKYS1XDKhSnpnK1bNDvkGzw+q97cra6SCS+eV3Q4EqljQFhGA6ISJe3dgCi3x/dlkaSPjVOEjeCfUBB9KpH7jW3DuelJglaAzrkAQoP2e75nGUTaYqSBxYbENiUke7gawHJn5JWXbR3paM4vdu/r0Kiwlc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199015)(4326008)(66556008)(66476007)(66946007)(478600001)(6506007)(53546011)(6666004)(41300700001)(966005)(316002)(6916009)(54906003)(8676002)(6486002)(86362001)(38100700002)(2616005)(186003)(26005)(6512007)(31686004)(31696002)(36756003)(5660300002)(7416002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SS8zcEttQVIremJHM09ja3RLNncwdHZEaThLY0E1a1hMRUlSMXM3RkVQYVlX?=
 =?utf-8?B?cDdGTWc4aFZCd1UxaEtrTVg0L2R1TGo5cmhVdVhIaGF6TlFJYXA5eXJSaTVx?=
 =?utf-8?B?MGxSR1VrYW9qVDlNUi9PdndyM1Q1KzFKV3MxREtWL2dqWkpuNkptMVZZR3hG?=
 =?utf-8?B?S3dBRDhKOWQrTUU0azhTWU5TcDRwc2hiOTViNmFiK05zck56L3dCMThibWpY?=
 =?utf-8?B?djhvTGxaRG1QeiszaURWME5DRWNDQ0V1TUQxTS9yYmJUTmF3bEV0RENlZ2l1?=
 =?utf-8?B?UEpvUjh1SlFXUE1OUnpHNlNlTU5VK3V2b1lWWXRTMHlINU13VlpDcWNmV1Rt?=
 =?utf-8?B?NzJNakVIY3pKend3R2puT3AzYUNjY3RSQ24xb3FpaFhMSk5wQk5CL2NXNGd5?=
 =?utf-8?B?czgvY1cvY1Foakk2YmtabGwvb0lXZWVPWEN6ZjE0NVEwYXhLUHA3d3hOSTN5?=
 =?utf-8?B?MFplTjNEUkVoRXBWZkNMVzJKYVRyb0tYMkErWUp3Zks3b1VVb0pQd3R3c2J6?=
 =?utf-8?B?Q3UzSE5YT05Ob2VXcURZMHJVaHZCMDgwbXlsQzlTKzZhNnhIOG5KSGRwdU9Z?=
 =?utf-8?B?MXlRVCtGdnV2RVNKRHBITTV4dmxoQ00xQkd4VFR2UTFMNjQ1VzdpTTJnZTRB?=
 =?utf-8?B?ZmZzN05hSnk1RGowUmR4aGxXem0xUGcrb2NDQTdEU0ZTMi8zZFpSWCtXeGxX?=
 =?utf-8?B?Y0d6RXd6cldBRnRPUU0vN3Rsc1U0Ti90dzFJN2d3c1NibEMzUy95K2wyUEVL?=
 =?utf-8?B?MWhmOXN4aEx6ZEdMMHY4ajdFNkt1NC9jZDFzT0FINmJod1o4c2RZdzQ2ZkRP?=
 =?utf-8?B?QkYraWR4eGhIU245QTdIa1BGQkJGaFFvUWU2RHZHZ3BhR200V09Ud21CNlZ6?=
 =?utf-8?B?akJsdDBHck5GUzNRZWRHZ0dwNGNMaFA1cmJUeU9XR2VxZmJ5dWlDaXhTOVU3?=
 =?utf-8?B?c0xRSlM3TEIxVzdxd1VuckQvZXJBQ0ZtR3IyNFc4Zk9XZldXU2ZrcDdwSEs2?=
 =?utf-8?B?L25CMk9VQU9WSzVObThQQjA5R0loYVk5LzlvWk9pd0hLbnQrT3VlWjVnZzJj?=
 =?utf-8?B?d2t0aEg3MDFkRUg5cXB5MVpkdW05a1V6YmV1eEdnaG13MVFZbG1WeFRycW9n?=
 =?utf-8?B?dkRGdDdOM1ZQd1Vzc0Q4WlFBSDVLMUF6cTBBZjBSMDRqMW9lSkdPMnVsUlhz?=
 =?utf-8?B?dEtIZisyYkNpb2g2SGdDMEYyWFRKT2RtRGRiZ0ZMM09WL3dsZW1qaTZEZWpz?=
 =?utf-8?B?aGhZeE8yWHFWbFJ0WERLRkNJblY5N3RGK2JPMjRxeGx3bEY5L1FuWWJtZjhE?=
 =?utf-8?B?OG8wWWEvbUcxK1ZjMVpENFF0QXVvS3dHckorSXc2aFB6WEtnMEF5RFpFZ3Nj?=
 =?utf-8?B?bEdsNTlSYys0aEhZRTVpb2NHTXpDa1oyOUF3bkd1alp2U0w2eUIzVXh4MWxS?=
 =?utf-8?B?bm1LNVgrZ3dWWTdhbCtLeFhoUTV4S2xrS1ZMbWxWelM1L253dmp0S1NrdUZY?=
 =?utf-8?B?V0k2b25KaTBZeXBsY3BnTWp6OGxQcHRSeHdxb0tqdit6ZHBRZkpNU0V6dWJD?=
 =?utf-8?B?ZlNZNW8vbzByL2ZOVCs0dkZYbEdLRmQ2bWZsZmFyMlZCOU83QWhjSUZ2a0dh?=
 =?utf-8?B?dTJkcDAyR25NdkdnMkhKc1RGcGZMc01GWWg2Y0EzVVhIalIzMzRPcmMwajh1?=
 =?utf-8?B?RUU1L0FPTWxGRmNQVjAzS0N4MUFpb3lCR1EzcHlqSXdOVW1jemFlYmtBWGN3?=
 =?utf-8?B?V1lkeWJweHhUU2Y5N21HcWdFcVVUSE91T2NLOUFFZTVqeVo5R3R3SmF0c2h1?=
 =?utf-8?B?c1hFay9adTJqUU5QSWx3Q0NNeWR0QXVPdUFLS2lSN1pwWC9JOWNibnYyc1V3?=
 =?utf-8?B?cDFZVGNMWC9IMVk4emIrS0oxQUMvSldOdWJYazNTcEc3M3hUTG9obzVLcGpi?=
 =?utf-8?B?VUI2a21YNXpTWUJKRDU1R2lXMm9DQjhVSitMZ1Z2TllKU1ZWQTRRY3BFNjkr?=
 =?utf-8?B?cG5nUlhZOFRjSmV0dzlnL2NIU0VxaTJqK3lMYmlKcDhrZ0Yzc0x0YmFSZnph?=
 =?utf-8?B?QXZ1dzhVQXNiMEdHS1ltYWxKK1lDaVNNQUNzMGdRblRrRmpwQ28vZC9uSjly?=
 =?utf-8?Q?bNvec0WPCkrWyv1F28apQ3+9P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ad43c0-a1a2-4bca-22a9-08da9d8035d8
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:25:21.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfDus/v0tTf97BSkomYlurvXGKyrQcDSxqaqNDKP7fB3X8rwtIY/HdnSDye0AUM2BRXBPUSTTcwsgMQM3t4xpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4294
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Boris,

On 9/23/2022 9:16 PM, Borislav Petkov wrote:
> On Fri, Sep 23, 2022 at 09:08:01PM +0530, K Prateek Nayak wrote:
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index ef4775c6db01..fcd3617ed315 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -460,5 +460,6 @@
>>  #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
>>  #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
>>  #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
>> +#define X86_BUG_STPCLK			X86_BUG(29) /* STPCLK# signal does not get asserted in time during IOPORT based C-state entry */
> 
> What for?
> 
> Did you not see this thread?
> 
> https://lore.kernel.org/r/78d13a19-2806-c8af-573e-7f2625edfab8@intel.com
> 

Yes, I did see the patch, but Andreas replied to Dave's patch attached
in v1 saying that he had seen this issue with AMD Athlon on a VIA
chipset back in 2006. (https://lore.kernel.org/lkml/Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de/)
Therefore, Dave's patch is not sufficient.

Dave suggested the use of AMD vendor and family check, but Peter then
pointed out that we would also need the Hygon vendor check.

Hence I worked on the v2 which addressed these with the help of
X86_BUG_STPCLK so that we can avoid vendor specific checks inside the
common acpi code.
--
Thanks and Regards,
Prateek
