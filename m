Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71643059AD
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhA0L2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:28:14 -0500
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:61744 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbhA0LZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 06:25:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1611746717;
  h=subject:to:cc:references:from:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R6nQ7HGU/s0s6LAoEgdBUKYsNClcpf60fTivNq5cCjM=;
  b=dsgQsi9ObBPSX9MuZkqs6eHXZtbuGm86vph7P9wMYIJsVfzzeJIDSbhy
   jUQSu7aCYFVrtIs/KwFtUa3zRaJjyv6poXZa1mA3Aylrqq1B2xNG9CJP8
   zJUQ90IE3REzWPr8LN6lRggmeNMFRhD/j4ZPskC7n3D40k2vwwS56+iG4
   o=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: GgGyFyPvfVGFDgz7Ah7jbpv0MW8fELnKeqA08POMt3VhH9Z0lJ/2Radm66g91KdJTERMnDjNKO
 5nH/QWkpovgHz5Z7Ma7VYVfOK41ylXJ4lKGK9NYVjDGvNWjcjns6n0vI6IWfvG4ilSJRnPrNZF
 U/TqExJn8ASgIsKhbP7hOu7F/TdEDVnS2VOkkFCPCxkqYmo41VMKgPT8rFqlUG+sEOA7J4WItW
 uNXIzhcCdxfzngrJVY79yBBcSYOZGy9QNNO6HrTTMzHe926n2C//CfguuKDOBUwNSagJezz0G3
 qcA=
X-SBRS: 5.2
X-MesageID: 37266880
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.79,379,1602561600"; 
   d="scan'208";a="37266880"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Frq8nvpRr0lKjDlmgHk1hbOPKeV1/HnWY7QSkdzc2xFvHWcnQTLK5IHUrj8LQLS0qo8xzf4i89Z2y8aCM/cGxtSqrRnP4O8w7z4+KvixL5nOVeE6alxxUiIe7PptXKhloblyGDPl2TjTgZpj0jP1elVh3YABbYnnarWdRRs7ouZ8tIvG/N4L0tkMZhgU5c1OjjNbWzN8qTMT3sCbZcBjsRTHl+441XrxVU/ZLLaGJsY5SfIddtdw3JRMIsY9gcfI8pgDZPqt5YJTLVVQYQEh4/Qb8eKRt2oFF1EQqtbZutihZd99GU8Wfbxk5euFgt9RxQ3BaMhO8st3KMNfcM24Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6nQ7HGU/s0s6LAoEgdBUKYsNClcpf60fTivNq5cCjM=;
 b=c1pcS9u6YKggZtlKUfH9bFNddhuEqzXlDBY5OJJ8QuuYKNZ+xwDH5EclSlhJdpXV4Wc5K1oC9CZiJFaIkEA523SEKzKpV15CpFlThbxTN7PI/cdFPA3X0i3Bw3uMbfzP4ihTdIl38ucjOoS4EAW4QM3TkxcNlhqSCu6LXvw7k1NcTazy5QfnMeaxy/T+8x32K0bcoAeTUX6kdvxJaqW42llpNyECa9Bd+mz3gH6y/rgeGm6l0FZiG4t+oVF5ijaoStLcI+rhvDB4Y8Whhm1Jo0MXOW1xgXvvl4Iqy+2gjh37OHwVYf3ykfDgjYvieuN0xoi/2vNitW+89DjM5oFabA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6nQ7HGU/s0s6LAoEgdBUKYsNClcpf60fTivNq5cCjM=;
 b=DJn8DAnTQsMXirVzQ9J3dIst1t9vFpHVNQAz4uWaN0pqK86wOv1SlmTx2ID9kfV9Y8p5aNTI7VPX3zz0DpAuQXZozsSC7vkSudLoIVhfN+fEOJNl0CaSA1WOjaXNiKE5Wc3N0y8NNlTg8lQZHp5m17IbCRunSz1qcOhTX4jYZqI=
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
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <6ca7dcf3-2588-3797-b90c-5eaca542a65d@citrix.com>
Date:   Wed, 27 Jan 2021 11:23:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <2dc49fae-bf35-7c7d-2d86-338665db27ca@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: LO2P123CA0015.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::27) To BYAPR03MB4728.namprd03.prod.outlook.com
 (2603:10b6:a03:13a::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8606082-cbab-4d1d-2a37-08d8c2b60d45
X-MS-TrafficTypeDiagnostic: SJ0PR03MB5952:
X-Microsoft-Antispam-PRVS: <SJ0PR03MB595271874836D7C302B33428BABB9@SJ0PR03MB5952.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: csy7sqoWPw1n9RgeMLCSOUo1+8YfTHOVYC2IsP2iVb2LZ9tNrihbikUgb/H90Hm6PsJvJoAE/F1+PV93ZdzFekc9dtoN9kvIo8hNiO3xulqcaWbGPl77iqSFf9qD6cxc6r+IrS/qtmcHMKMnN9fyrsx+xjkYrZ+w1vmzIM0mvYmgvhJISKRpUQ6epnpuJVoo5h2Qh5v5o6TpFYaqVE1tdvqReI+XI+N86OtOdXUcDeneE5SRDw4DSZ8qA0E8FeVIp94V35r4dCLq64NpFQkI4EbAmO+q8dlZgjh90yglp4VAZHX4avTx8AzuqwIUEG3WKe0NB+mwIyauQnwlLysj3Eg8wqkzMEs0heEXLiCDgM5Vh9Co8iMYxAR33lIuWPN+xmEQZQRm8GCATHHFbry+LqvffctoDNNa4dAebaJPIEZA8tXIF03fWA1eoqDbe59SRHusnJU7BL2rlKaITeZX3Suh+yzyPDqop9hrS+NFng0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB4728.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66946007)(66556008)(6666004)(4326008)(36756003)(5660300002)(956004)(478600001)(7416002)(66476007)(2906002)(16576012)(2616005)(26005)(8936002)(31686004)(316002)(186003)(6486002)(16526019)(8676002)(53546011)(86362001)(31696002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dGNuTmg5Sk9BSm4zSnhjWDJIUUNjUWJOZlhVNzUvTFJISFYrenlOTjNkV1BX?=
 =?utf-8?B?dUlrSk9XeHZNYTR0b1lCUkZRUXlhV0p4ZTRSUkQwOVd1UTcreXhnblYrTFhn?=
 =?utf-8?B?RWJWWFJqd1BUbzRpWDYweGpLY0NoS05vcVRIRkJsN3hHNUxoRzRyQWd0cUNx?=
 =?utf-8?B?YkNDblpNbHdrWWJqTkY1Snprd0x6VlBnQ3ZyOWhTM0lDQTA0NGRmWEJzSk9i?=
 =?utf-8?B?WnhMaDB5UVZMaExrMlNJKy94TGJKbzE5bCtZdGZ5YnJIYjh4R0hnT2o3blZx?=
 =?utf-8?B?QzdYeDNMMVdtTHZLWG1KMjJzelByM1NVMEJnb0tsMkFmNStqcXhocDE2K0Vm?=
 =?utf-8?B?M3p5QVU3RFJabXVtT0w2QmJkTkhxektCSGFXcHdzSG5rYUZ3Q0xzajJqbDNp?=
 =?utf-8?B?aGdRdjZaWksvNTBRYnAwTUxsVmFmSzdPZURqRUQ4SzZsZ3BKVnlpU3NCMlIy?=
 =?utf-8?B?VTdXSC9qWTFqa2p2dHVLS2IzMVdabWk4Z0QrcFNMUTc2T0JsUTk3UEc3UGZr?=
 =?utf-8?B?cnEzYjNySFk0c3N2c3o5QkVaMGFTWHdiQ09YUTdCL2twSFJCTVV1b2lXK3kr?=
 =?utf-8?B?RHFIUHIzY0VpcitaQXRra1V5bm9DL1g3Z3BGWFB6cXAxMy9jMFB4RXE2Vk5O?=
 =?utf-8?B?MkUvNjMzc0ROS3FkeUlCVWI2eFhUZ1dqdzN0T1o1V0UzcmFnQ1VvemM1ZUpa?=
 =?utf-8?B?cS9XWmJxUmRyY2FxcnNJUXZZUjlTcllmRVJxZUw3dWthLzFDRHg0OVA1ZWUz?=
 =?utf-8?B?YkxwL3hsSG5jSXNISWNXMGlsQzhjWjRYSlBsMUNuUTg0dUd4YkYyZ3ZuK0Fs?=
 =?utf-8?B?Q3BjcUZaRjRoTElCLytqN0pxbkNsaStaSE4xWVlqeG43QlJicVVTNDc1ZjlY?=
 =?utf-8?B?SHczRnkwWU1iM21oQnBNNGQrNVljRXdSTnRIRHBnLys3SHdmRi9tLzFra0hm?=
 =?utf-8?B?eFQvSXNRVmNDTS9HVEUwTlh6RGtBRTlYc1prSmdicWtwSmZkVUo4eXYzbm5k?=
 =?utf-8?B?UFpqc3g3eWFLTGtMZTBYNFhsbmIrNjBHMmV6cnFhMGt3TTMrOUFkdUwvbm5E?=
 =?utf-8?B?V3I1YmhqZ09nRmQ2WTFzMi9oYjZnMWpLOXFBYk1xeVpOZTJtOW14elVrNXpl?=
 =?utf-8?B?VzBob3VSWm5lZ08rMW45Z2tOUjMyTk9zdVlod0RWT1BhODMweXc3VU1oVXc4?=
 =?utf-8?B?ZTQwNEVXZ2RVZnlDaEFvYVdzUk1KUkljZTdVRFlFQ2d5eW93VHdmM0QwZXFx?=
 =?utf-8?B?Q3QvRTgrSUlCT1ZaVXduQnkvNk9ZWGpOdW5teDZEaGNEUXJHQm0zdUZzWXFp?=
 =?utf-8?B?MjAzNGhWUGxZdkVCMFU5bzdFajZCMTR1ZWhPQ0xVN2FHNWdnMVJRWXVBdjFG?=
 =?utf-8?B?RUhETm5BWDZ6WmM1R2VYdndOaWF5UFp1cTFUOVZHZjliVTVYSmtTUVhLTnlS?=
 =?utf-8?Q?Y2lFgSZM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8606082-cbab-4d1d-2a37-08d8c2b60d45
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4728.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 11:24:03.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kDBZXnuDo4YTax66hKhnbJwfCC6OFBMrr17dPgRE50rn5rY8zB1Cv0Ry705bayPS1K+Zioz48ieyKRKT0VAZ2tF1i/S0POMEBXRLVnrnmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5952
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/01/2021 10:26, Jürgen Groß wrote:
> On 27.01.21 10:43, Andrew Cooper wrote:
>> On 27/01/2021 09:38, Juergen Gross wrote:
>>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
>>> index 4409306364dc..ca5ac10fcbf7 100644
>>> --- a/arch/x86/xen/enlighten_pv.c
>>> +++ b/arch/x86/xen/enlighten_pv.c
>>> @@ -583,6 +583,12 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
>>>           exc_debug(regs);
>>>   }
>>>   +DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
>>> +{
>>> +    /* This should never happen and there is no way to handle it. */
>>> +    panic("Unknown trap in Xen PV mode.");
>>
>> Looks much better.  How about including regs->entry_vector here, just to
>> short circuit the inevitable swearing which will accompany encountering
>> this panic() ?
>
> You are aware the regs parameter is struct pt_regs *, not the Xen
> struct cpu_user_regs *?

Yes, but I was assuming that they both contained the same information.

>
> So I have no idea how I should get this information without creating
> a per-vector handler.

Oh - that's dull.

Fine then.  Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
