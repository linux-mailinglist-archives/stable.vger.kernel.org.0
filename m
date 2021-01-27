Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6656A305E60
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 15:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhA0OdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 09:33:01 -0500
Received: from esa5.hc3370-68.iphmx.com ([216.71.155.168]:27158 "EHLO
        esa5.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbhA0OcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 09:32:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1611757921;
  h=subject:to:cc:references:from:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jj14pedKkncpqIXLBcI9CBl1Vb6UH4rswwObh9LJYYY=;
  b=E8Bd7J+wEIPvWQzM0G2ZzoIg3IRurDh0wn202Br5j25AXHRDmBsFWDJ1
   /eW9eUwOUQqTLkXuquuvNufXicHKsyILrupfkR5g3QGDAgH2EA9QxX16n
   j58clvC/JfOhn8/LmJr13vGnZCMKS7vXPmITMTQbDM61YcnaVq6YRpihP
   s=;
Authentication-Results: esa5.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: Nwjm5BZ86zTKKfEyQvuLDIm2cRYQqTVZOaV8H8OUoKTDquOHrxfi1Q8G1S3iXsQNpYwwKFkCDC
 L8dnWcwxJQn68vjg01g0Q1Rh1kMa4+wioH7+e54H+LsubQfsC2kIMzmsf0rQvqfOyMZEyJuY5m
 C+PR3WDRL/7oWAJ4WvmqSAd+Vb40C3/boHsP4kmKBLUDbqYI2fMnTl8cYAL4prPC1t+UVqjTVA
 w51uQxIgFfxQlWUT3n+HJvaS5eBGpnzdbO4TNjDfkTjEZNt3Z1pjVPAtlQnnkoCCxcbsRN6HAw
 LqE=
X-SBRS: 5.2
X-MesageID: 35927514
X-Ironport-Server: esa5.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.79,379,1602561600"; 
   d="scan'208";a="35927514"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4oX6rhIsZz16fDKDxtxY/qKsXQugds3y2tlTm2CM1RARSBlt4HpwHT+FB5tGYJa4R6JF2U/STn1ymfllEnDqVC5TWTWBCyUTnb+MN9c4u6zixZW6VCG/CX1unR2sULgBS366GunB/HuoLB22zMEfsIJrIyYWObd6TFZgM6P/qGb0s9qwZ9ekjWJF8pOmkExI3SdzpJMVD/n6+IfMomVoJ1usaKm9/iXsIwAEJ3rKiJ9ZR2JK6HLiMdEFv3zeqRMzLu4oIqdD0WNpY6Ti3LDVZ40azUMLQsw4APRjROzgvsJfCJBpjsXaYEVBy8oDxk+YMflHJeQvMlxEmg8Gi1VSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jj14pedKkncpqIXLBcI9CBl1Vb6UH4rswwObh9LJYYY=;
 b=WYnLsoIkyxgm+TBWOrVBixrM+5amMdRLYc88+d5tWSEGv+0VCmIMW6ngML/QPLAUeYYsqOBPs6dQ6iYwcmhMiOImRFFkZb9y9LKq4g8Cp/bar33gAl7nSKAWzVxdFNkaVIJSnfWNTG/T8A8SHHyP6WHOajP8TpiIF97pcxTD+NY7fkVRFmb/E6mdk30jtPlIooRHs1T72x3Q5lBi+AQOmHvE+IaC6uvzRHv4tmboZ8QMecsGDtK58MAKmO1WNviHnaofua1s7PrOKJS8qbxWpI5JHsBSpV/tc4Hu82CLStKlMa/Dur3ShZDt9v4Qst8Uh9W8cPiY24sPfDgCZdNqCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jj14pedKkncpqIXLBcI9CBl1Vb6UH4rswwObh9LJYYY=;
 b=Cefh48yEEVqbUIeZ4xFYA1CZ+4gunBADudG3/zfByEy1AIwPo6o4MXNVduhd8uQ6u/y4XVi6/Qe0yvO+bydkOq6CxqIDirtz6Y4ne72TiU8/6ozGoo1WTyCb5cS/q08cbxmG1FaL+fNeCfAlumCkN8dJcODaxcvl0E9VUkbu/to=
Subject: Re: [PATCH v2] x86/xen: avoid warning in Xen pv guest with
 CONFIG_AMD_MEM_ENCRYPT enabled
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        <xen-devel@lists.xenproject.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        <stable@vger.kernel.org>
References: <20210127093822.18570-1-jgross@suse.com>
 <fb2305a4-4741-c641-9639-5b17b63f2baf@citrix.com>
 <2dc49fae-bf35-7c7d-2d86-338665db27ca@suse.com>
 <6ca7dcf3-2588-3797-b90c-5eaca542a65d@citrix.com>
 <27d2b0bb-3232-a99b-a577-e61014dd04bc@suse.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <ff870de0-5d14-78b3-b143-3b59acb9fb4d@citrix.com>
Date:   Wed, 27 Jan 2021 14:30:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <27d2b0bb-3232-a99b-a577-e61014dd04bc@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: LO3P123CA0001.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::6) To BYAPR03MB4728.namprd03.prod.outlook.com
 (2603:10b6:a03:13a::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 020a3a9f-f10e-4845-14bf-08d8c2d02388
X-MS-TrafficTypeDiagnostic: BYAPR03MB3733:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3733AC6F26E02ACB13CE805BBABB9@BYAPR03MB3733.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dje7YP9uh6XbUtJs8rONl86DvPgSMfY+PhUlwneWum5oA1LakXHDgF36p+SisT3A6ik9R/27APypwP3M2CUewEAAkZ1rqMN2MGd/aRartErhvsOZ1QgsGJzoNP5Vc+4/1U9QE+zU3qY/B1tY88SizkTQJoGaKzf0z383FR93ArwAAy3kzNrhz/WiXVpCb4saaGEis9tJ9HvCJJhKI7/JoW7jsrwnKFbzhd4zOgsZf+pbRxwS3WCW/zaHLY06H7qV71okkEL6CAZ3iacQlAA7yO/bJKQxKwCvWYkwOVm8wQaaF3zsFLcSB9wtgNn2dvJ0dSYh1/kToWVBelY3nYmNyMphyGUoQZjUHhnMZlUW5QE6t/Jsg6m6xqPwuBBPoL1RVuVVfV8HNFgEL2dWeygZpuRRtjxSx6cx66J330tUZ5V/CrFxh1wFjfPkC6PSTNw/F47hOsQGo1B4Sfol0UfBsk2JM0Fw85jgKFsIo/yDwmj16NNP77g6uDgXFX63OrI6agVfxXrXot1rxZPx7rMKPQuQS1MUpdzYkpGHuoY9Myx9eZQ3zlsh3/vWVOG54b+i9kXRBf0GVc2RRilMzURPv39B84llS0eL/Ixkw5/F7zs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB4728.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(54906003)(956004)(66556008)(53546011)(2616005)(31686004)(8936002)(6486002)(186003)(31696002)(478600001)(316002)(16526019)(36756003)(6666004)(66476007)(2906002)(83380400001)(86362001)(16576012)(4326008)(7416002)(5660300002)(66946007)(66574015)(8676002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ams0bVYxaHhNWmxvYkZhWDhGN2dJWGlYVlNRMTc2VEptMUFlZW5URVdOZHhS?=
 =?utf-8?B?cEtwZ3g4S2s2OEJqSUV4ODduMFVHenFuMlNUbld5akdVUUtTOVUzSVlNYlB3?=
 =?utf-8?B?SkJsU0djUERpK1liVEp2UTA4NGV1Y2lYOHgxY0RsNUk1WnE4S2hNT29jbmdX?=
 =?utf-8?B?ZXJXdmhQQ052cE8zOTFVYmhpSm9IZFJDeElZd3k4WWprQnRrbUdGVjh2NlhY?=
 =?utf-8?B?ZUxIcnpuZytWMkpjZGEvczcwSFRVS2VJSk1iUTFDcFVuemMxdWcxVnBVRDZH?=
 =?utf-8?B?VUU4TkNOczlJVHEwTWcxUDFFS3JkazR1Njc1Qng1K3VvTGxDdG1abHhTMjYz?=
 =?utf-8?B?UzJYNmg0dUtIb25VeldtcUNCL0NsUnZPVGY3d0VwNmw5R2Y0encxaWU5RlVE?=
 =?utf-8?B?T0x2cFJTbnl5aFF1dk5CT2dMZGtDQmt5OHhZazE1M2lXQlZrNUQxb1J6YkQ3?=
 =?utf-8?B?MU51eG9YVEpnWkxwbFliT2V0eWVoWDZLcGpDaWZIWi8xUmNBbTFzcmNQak9N?=
 =?utf-8?B?SXpsVmJlTWVDSmZ5ei91T0RYYmgvL1NHVUU0ajJGSkh6N3RZazNGUml5cHBt?=
 =?utf-8?B?bG9CSVRKaTlYZmNmRWU1R2JkMkNTdmtYdmcrOXY0NHdMU1FJQ2M1U1E3cU9s?=
 =?utf-8?B?d1dvdkZ1ME9hR1Y3aEwzL0gxWnA0a3ZFdUVBWUZ1MEZFNVl3aHh4SzlEZmg3?=
 =?utf-8?B?cXFwNzFHb3pNczdkTUFJSlliZHBUY3RiK2I5dFhIR3A1RVkyV0VGY1JSVEZ5?=
 =?utf-8?B?ZVRWNmdMVGZRQzAwR0NEREZDNFNKckpkTkl3VVdiN1BobUYwdmhobVdRZzJN?=
 =?utf-8?B?ekZPU1lMSm9Yb2RlTGExSXZ5eWVhZ2QyS3dTL3lCSEQrQ3JkZDF1QTJreFk0?=
 =?utf-8?B?dXRJYkMxdEIvci9zYXFFWTNKZ3lJTWV0L1hiMU5iYUwydkRCQUlrK0M4TWgv?=
 =?utf-8?B?c3lUa3o4WFFZUFJwQzVHellneUNDYWkxT3dLOWJESjVZQkZhRlIvWTUzRXpI?=
 =?utf-8?B?TEdBQTRhRFRsYVJBdWo2VElmV2JkcytUUmJRTXFUZjBCR3d0VmRqNDQxekhs?=
 =?utf-8?B?bTJZVi9ncHhLbE85SzE2YWlEektaYlkyeWxmT01NaE1YRm92MzRLZ0ZTY1p1?=
 =?utf-8?B?V2ZCUVUwOVNBN0xGWk5wSk5rVTgvekh3TlluaTZFei9xejY3SnIwS2ZibDJr?=
 =?utf-8?B?Sm4xYkpJYjFGOURGejgzRXhuaHdueUpzVXJhWGNzcDZjUEx0RStTT21oNUxs?=
 =?utf-8?B?amhPQ3BieUJ1dkhVMHAzMWVSejlDQzcxOHZ4RlIzLzF6UnhDNjFJUmo4Z1ox?=
 =?utf-8?B?T2FKMkhFY29rV1o4dzJDZWNxRkdkQTA5cTdrNE51VEVjTDBYWlBKUUNJMnI5?=
 =?utf-8?B?RWNLNndFN2hvRjhGblpjVGVhUC90cXZCV0NFQjNYMjB3VXY0T0JzQ2tlR2Uv?=
 =?utf-8?B?MHhSMEx6VlpMVVArSlRFTTV3TUEwdTZCUEhvZWxRPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 020a3a9f-f10e-4845-14bf-08d8c2d02388
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4728.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 14:30:48.0860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYcNwz5X9WmPDQlYeBk4rQa5X50kTpv3jTiJ6MqG7mLBHf8Ad0v01Z8VWJmzJPFBnVvgxgb9sJ0O0U+0WCU+qa0pnNwm7NGDIOWMm36w7mY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3733
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/01/2021 13:59, Jürgen Groß wrote:
> On 27.01.21 12:23, Andrew Cooper wrote:
>> On 27/01/2021 10:26, Jürgen Groß wrote:
>>> On 27.01.21 10:43, Andrew Cooper wrote:
>>>> On 27/01/2021 09:38, Juergen Gross wrote:
>>>>> diff --git a/arch/x86/xen/enlighten_pv.c
>>>>> b/arch/x86/xen/enlighten_pv.c
>>>>> index 4409306364dc..ca5ac10fcbf7 100644
>>>>> --- a/arch/x86/xen/enlighten_pv.c
>>>>> +++ b/arch/x86/xen/enlighten_pv.c
>>>>> @@ -583,6 +583,12 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
>>>>>            exc_debug(regs);
>>>>>    }
>>>>>    +DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
>>>>> +{
>>>>> +    /* This should never happen and there is no way to handle it. */
>>>>> +    panic("Unknown trap in Xen PV mode.");
>>>>
>>>> Looks much better.  How about including regs->entry_vector here,
>>>> just to
>>>> short circuit the inevitable swearing which will accompany
>>>> encountering
>>>> this panic() ?
>>>
>>> You are aware the regs parameter is struct pt_regs *, not the Xen
>>> struct cpu_user_regs *?
>>
>> Yes, but I was assuming that they both contained the same information.
>>
>>>
>>> So I have no idea how I should get this information without creating
>>> a per-vector handler.
>>
>> Oh - that's dull.
>>
>> Fine then.  Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
>>
>
> I think I'll switch the panic() to printk(); BUG(); in order to have
> more diagnostic data. Can I keep your R-b: with that modification?

Yeah.  Sounds good.

~Andrew
