Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140B3351C76
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhDASRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 14:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbhDASMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 14:12:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20715.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::715])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E90C0F26D4;
        Thu,  1 Apr 2021 08:00:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzWpl0N4V6jSY3uV23nqCynqG+WaoNDkzIate1NLgCP6SIKztAazzC57ERF8vBDltwbNABDMbcQRcpGczfLKPXl0MAm3ZFVqWFscbVkNPtpzEPRkwUD84XchwmdwxJJwRy8CI53XrDlKWwls0d6/k9VNn82wEdXFMnNSiaUdq+uhkToO2k0yq+y4s5WSXi4n1O/PCgdPcN7k4vWBaNUZjnccdNQLosW7r2TrPuv9FX+ZTmHkP8jL67v+07+d9hpOxt8589AZnYxFtOKcsZQIRMKbMPXa62FBRauRZiQsI1VTEPX/UUI/P5RVT2612oqU84pkceTv5KbkQOgRSRGcqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk50osyxG5ibOOBJUet75pQrKnfanhwwUCkzx5S1I08=;
 b=J+StwQsVQieS2Iz8Cn10vZjOCizlczS4V9mtDkMPiP1N6i6Uv6m8bgVIW6SImM8K3fPJjGw989HRgRTFNIEbRU+nSHz2LJL0Ua4N8eQDPc3SHKP6aATv0WJrU5lK0Z+pxFQ/pbUdmkSVLqyq77REbMqzB4gxhDsOc43wBVdC3Ize9cJwYWiUBtISjwTEh7USErRk5YZJB2DPuVuliE32+5eHyKQdrU+o97rwAT6bE3NS9UQnEtdCHHEiOtRw7edg8tfZsBRGDZCoU1ECEtPQuPp6pdH6O/3V8saV87pvicFtH9/XeIMjUZcTWl75rgBXMB+zVYE40arB8CM7sI5gcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk50osyxG5ibOOBJUet75pQrKnfanhwwUCkzx5S1I08=;
 b=N9GxcS13PKd9VBJgYxlm5lP28H8F589m02Xda3t8vKk86fjvNQheEqYqmnNQhcR/I9hrG/Y6L9PSXxbqObRxUyd0Psjrgxi9guWxAgFNNjO/3Jnt6MjdnVsTUCNW1P1UPxZY6rZX9gx1jFUnJu84i7jCoSom4yhcsPQ0vYbBHOx8rvLvGUDXP2ZbQ7Fe8rv30Fl7rdP7IEPgNolxoRF1KdwdICfX/jxcEQsRYBg13bWcPJKUAzLUOMeP/x622bJvYVoK/XuxsgLm36EIGHxM0IIx9Ynu8AanfSjZ32M4qxPs72MwtbfsF9qWevXeCN7206mHo9uDwa9+szwNwYB/RQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6119.prod.exchangelabs.com (2603:10b6:510:d::10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.29; Thu, 1 Apr 2021 15:00:28 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 15:00:28 +0000
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
To:     Greg KH <greg@kroah.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, dledford@redhat.com,
        linux-rdma@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        stable@vger.kernel.org
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329140922.GP2710221@ziepe.ca>
 <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
 <YGVi7uT9kyfk7Mo7@kroah.com>
 <5d90f5b0-c161-bba7-5151-4d8a1c679b44@cornelisnetworks.com>
 <YGXUu88J811vV+p8@kroah.com>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Message-ID: <b44629f3-c091-3485-4608-c9eef2f7ce18@cornelisnetworks.com>
Date:   Thu, 1 Apr 2021 11:00:19 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <YGXUu88J811vV+p8@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.154.216.5]
X-ClientProxiedBy: BL0PR01CA0036.prod.exchangelabs.com (2603:10b6:208:71::49)
 To PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.40.159] (24.154.216.5) by BL0PR01CA0036.prod.exchangelabs.com (2603:10b6:208:71::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Thu, 1 Apr 2021 15:00:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 416e26f1-d58e-4adc-0d7b-08d8f51ee312
X-MS-TrafficTypeDiagnostic: PH0PR01MB6119:
X-Microsoft-Antispam-PRVS: <PH0PR01MB61199C51BD397EA01CA3C092F47B9@PH0PR01MB6119.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EcwFSTTaJy7l3dl+fxZ2fNtoer9ovG3vzlb+sb5uQSPPnEDSjCAsXVBL+zvffjVhznaTOVRRkpdYn5f6NROhgiEzJP6MqyHxYvjE7PJJaKF88JFxX8vw2RxxooJpc93OygHrV+Gb6Y8wWcwwaRXWZNqZUCTtNw9kyzH0QLixP9w8CWt5aOYFm5o9RrrxnRwbQiuw2sXomMEy2UDXkDojlAieiKewPatrRRPWerV5xeAYez3RMaAYsRJuF/FrHhNEQp8+RQAcZYY3XQckL3ik7E7qXx/+/gnyyl2EL231gPYY7A+ChI2HUFvvYEnuALJMI7VxUfaT9IPP/+5+DtUBOL2XDV+yCfNmh3YiAfJhDoDWFWd5wPnesm+W9kEnU7fHTcEjroVnXNtvVRyT3DJFKZ8c20xfVxJ3MsvvLJSfcmlPkC4zEsV46qMoAKIaEp06o3WARu+sral3eGyYaJgjDYZp46J57tBo4FudfQFGkdEcnuKQcNeNo1f2eLJmQ9DAi2FXdQjFIiewuSI6EfHSQOLzAtKUrvoTd8q4e5pW5BI1TuNbP2q2ptSX7dnKEL2XF9dJXtysMBv3VKsyg0gD/NFonCMep4lXMEnx/oKc9izUKOu1IWkssi5l1CWMnQBq3iI8T8tmi/qC1AaQN9rSENj8X9aMtiGBN+GqNCuZsicPSFqlrqpH/MOeDv49ud3uIJYeT5MeSXObsHZZ3RWxU9AkDOo99h3jlBjIdrtkFAZTOLYJvNPDNY9X1Q8MbLwgpHXvdV2FoI8tlxN190PQ0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39830400003)(366004)(396003)(31686004)(5660300002)(52116002)(16576012)(186003)(966005)(66476007)(2906002)(83380400001)(316002)(86362001)(53546011)(31696002)(38100700001)(4326008)(6666004)(54906003)(66946007)(66556008)(6486002)(956004)(2616005)(8676002)(16526019)(36756003)(6916009)(44832011)(8936002)(478600001)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b3IvTEtPVFA3bGMyYk5ldnQxenZOMFJjK3haSFd0N3FwS2xMR0pTc3lGVlRQ?=
 =?utf-8?B?NlVhanVkdWx3YVJBMVJ2YlRibTNmdFBDNzRRUVd4WDJjR25ld1FGVjBjRGtm?=
 =?utf-8?B?eVlxMFlKbVhENS9NL3I2MXcwMllUTExKeFZlQzFoazlGa1pmaGpkODg3NWE0?=
 =?utf-8?B?M3NpMTBYVWJjdFEwWVpuN05ZdTBPRWRMKzRsUVd4WU1oQzVjSEpBZUszRUFy?=
 =?utf-8?B?RUdmallVU21LVmpzRmp6dVZyM2JNY05tYlZ2RHhlcS9YRkdmMERmRXM4WVVN?=
 =?utf-8?B?aFgzMjhOd1VTdExHcWxSWkljMEx2T092Q3hqWDMvdGNBUXVjVnhML0dOSjU0?=
 =?utf-8?B?ZG9WWm04R2haVGRqREQzQXhQWWNzNFdrckw2MTFBcldwMWJIY2FBeVpkK2o0?=
 =?utf-8?B?cm5ra2NrcklManJVRFlGeXRBOUhNazR0TmdNTXM0UFpnL1RXM0NsYnVqOW9M?=
 =?utf-8?B?V1BkM0xBY0VoNUREZFNlMnJlZklpZVVGSXJ2SkV5SEFscW81WW93cTljRnZD?=
 =?utf-8?B?bW1EUkxjeXhSZnU1aWY3RTJDWFNxUnI1bzB6ZnNYY0tBeCtEZ1RCWE5vM3Zq?=
 =?utf-8?B?WXROTVR0a2tGaXdBaGo4cjJOSytyZTlocGdLNzdrRzd4M1ZrV3I2UlFDOFh4?=
 =?utf-8?B?ZzUzV1JpdUlJUUdRRzRqeXFJb3RSZUE0RG9Bak96cmlPVzc3Sm55MWVZVU9p?=
 =?utf-8?B?MzVTbDJadjBxY3VRZjI5MVR1UnozdFFYV3hBNitTNnJJbkUyTWQyWXRaWkRv?=
 =?utf-8?B?MlNRcWt5WTdaK1VzNDY4YTQyWjNYZlhPem1CaE1TWVpBZEwxanJpdjROek12?=
 =?utf-8?B?RzJmTmh4WkJGVEQ2U0trL1JHc1NjTkI1R251RDFiaGdKQy83S20vWnVxUkly?=
 =?utf-8?B?TGVjUkxJZlJsVldCMWIzTGxHZGFlaXAwdEEwVTdhMHF1VGtzWEE2OTBZcWtw?=
 =?utf-8?B?K0FSMERkdHJ6SmFnN0hHaFRlRWVXd1U0eFNESmZaZmtva1dVMXpVeEJlOWtE?=
 =?utf-8?B?cUZ6RlFicVE4MXZodTVnUGFYNXJvSnluRGdvcjB3M0JIUExBUHRpeHIzdFcw?=
 =?utf-8?B?aTVvWnZRRXc4R0NzR0Y5b1JjbU9JRnVNOERkWE5Pb2k0TFVLYURDaTh3SFNI?=
 =?utf-8?B?RWQ1UWZOVjZxdldmMWYyK0pyYVRxMzZwbjh5cG0yR1c3SzU0RzFmZERmNEJk?=
 =?utf-8?B?RnA2UFgrVGhRQXJ3MmprUHlnZmNuQUxrWVp4VXlYR2FlSnViYXhCTHdaZzRQ?=
 =?utf-8?B?NGdaYURYRXdySGl4Z3A5MDFtZWc2MndtbC82VkhxcXFuM3JJaDQxRFN6eEFl?=
 =?utf-8?B?RE9FU09IdFJ3ZFZwOWdiZXBSODFhOENsL3BYM0xlMElsVjBOTVZsbzhjWXlT?=
 =?utf-8?B?bzR3YzFBTFhIalkzNmlCUVoxNWNydm1RMWdFQ2tnR21ycTMwd1krdFBoakpS?=
 =?utf-8?B?bTdqSDZZeEhueWdoWGplY2l3V0hsVlJNSjQ5eTdXdXhoeHRuUWhlOEFEOU83?=
 =?utf-8?B?dXAvU09nN1dyV0RGRlhmakhzR1pwdlJxYUVPSVN5SmtHLzUwMXZaaGgzYU16?=
 =?utf-8?B?YUVwdTRLZXo5ZTE5NFZlUWkzNWJwdDlsMldodWJsNjAra3BvSkxjQXdjUk5q?=
 =?utf-8?B?MnZKN1ZtS24vV1IyQXRkbnlXOW13M2xtK0pnNHg3Q292RjMxK241U1hqekJJ?=
 =?utf-8?B?dE5TVmxIY0xIdXZNU2t0UXE4akRCOU9MRGM2QVZTTEs1Q0M1c0d1RFJkaFUr?=
 =?utf-8?Q?pvX4phePIi87cT+8sHgq85d2W/yZFxIbirgx78W?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 416e26f1-d58e-4adc-0d7b-08d8f51ee312
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 15:00:28.1684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGtqARRjIx3DyaFCJzD9xq4OQzaOo9QaMnJAEd1wrKzJMuXggQ5HIvBrDfNgO1kfnC9G12nnVM/Oux+Cm5aP/7UmriKNbIuPc21PNxSekT8nZe4piCr2pPfIcaB6Mydm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6119
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/1/2021 10:12 AM, Greg KH wrote:
> On Thu, Apr 01, 2021 at 10:02:30AM -0400, Dennis Dalessandro wrote:
>> On 4/1/2021 2:06 AM, Greg KH wrote:
>>> On Wed, Mar 31, 2021 at 03:36:14PM -0400, Dennis Dalessandro wrote:
>>>> On 3/29/2021 10:09 AM, Jason Gunthorpe wrote:
>>>>> On Mon, Mar 29, 2021 at 09:48:17AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
>>>>>
>>>>>> diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
>>>>>> index 2c8bc02..cec02e8 100644
>>>>>> +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
>>>>>> @@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
>>>>>>     void hfi1_netdev_free(struct hfi1_devdata *dd)
>>>>>>     {
>>>>>>     	if (dd->dummy_netdev) {
>>>>>> +		struct hfi1_netdev_priv *priv =
>>>>>> +			hfi1_netdev_priv(dd->dummy_netdev);
>>>>>> +
>>>>>>     		dd_dev_info(dd, "hfi1 netdev freed\n");
>>>>>> +		xa_destroy(&priv->dev_tbl);
>>>>>>     		kfree(dd->dummy_netdev);
>>>>>>     		dd->dummy_netdev = NULL;
>>>>>
>>>>> This is doing kfree() on a struct net_device?? Huh?
>>>>>
>>>>> You should have put this in your own struct and used container_of not
>>>>> co-oped netdev_priv, then free your own struct.
>>>>>
>>>>> It is a bit weird to see a xa_destroy like this, how did things get ot
>>>>> the point that no concurrent thread can see the xarray but there is
>>>>> still stuff stored in it?
>>>>>
>>>>> And it is weird this is storing two different types in it too, with no
>>>>> refcounting..
>>>>
>>>> We do rework this stuff in the other patch series.
>>>>
>>>> https://patchwork.kernel.org/project/linux-rdma/patch/1617026056-50483-11-git-send-email-dennis.dalessandro@cornelisnetworks.com/
>>>>
>>>> If we fix it up in the for-next series, what should we do about stable?
>>>
>>> What does stable matter?  WHy can it not just take the same patches that
>>> end up in Linus's tree?
>>
>> Guess it's more of a general question. What is the best way to handle things
>> if the code changes drastically in Linus' tree, to the point where the bug
>> no longer exists there, but does in stable?
> 
> Documentation/process/stable-kernel-rules.rst should be your first stop
> for stuff like this.  Why not just take those "drastic changes" into the
> stable kernel as well?

Yep, indeed it was my first stop :) and right at the top, it cannot be 
bigger than 100 lines, must fix only one thing, etc etc. That's what got 
me wondering about all this.

> If for some reason that is impossible, then just email a patch to stable
> and document the heck out of why this is not in Linus's tree and what
> you have done to ensure that this change is correct.  And get the
> maintainer to agree.  And be ready to fix it up again afterward as 90%
> of the time we do this, the "new patch" causes problems :)

Makes total sense. Definitely not the route we want to take, and not 
applicable for this current patch anyway.

Appreciate the advice!

-Denny

