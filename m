Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EC330574A
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 10:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhA0JrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 04:47:05 -0500
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:35248 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbhA0Jow (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 04:44:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1611740691;
  h=subject:to:cc:references:from:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iDcnlAgIL2oAhRt9z7jQyrjVk8qxAj04sZ/SbjpbnWs=;
  b=deTvVjQpI98q7DXUAAI8IOa4a59U9853NHFNwBnqIndDfajb64ooGGCO
   8jueICSNF38geTGXb8meBaQJ4Uys9mKeS4B0nDMv1Icc2x/DAqNqn0CAj
   GaESXyWSSTwGozSKQnZhXtO7g5YtY/MOQaWjhrO+RZosSf3NcnGgqTUeq
   U=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: PLTFgBR7BKCv9kAbjEsBtI+57i/sVAjAvB7LnRlwEFZIowt4+5WEFXhaeSgBbKUR7hh2mitJr2
 TrTnxYYkSyvhqo5DNRR1vNu1/vLcXj/R/jK31blewmqVB6KO1mpOZkuSLgzWwzQEtl4j8u2azr
 AAqL9jmBQBuqx+EnJC9MpSdQlHOa1G6yZh19i+JAta7TziJ5s+1VPME31p+al8Z8vVF+AnwyIn
 jvb0fj74/xDjn8y8YpfoDucw18pFo3AmYRe+Ey41YtjTLoQmxDK8cqYYYoYeGfSgBa9vHFigOs
 Uko=
X-SBRS: 5.2
X-MesageID: 37261422
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.79,378,1602561600"; 
   d="scan'208";a="37261422"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOgW7rR0m8pTvdWT3nENCtJZhQxMq8SGTlqYdzMR8q7i2g2kTEIuithtg68JS1NwK0g1PotZwB+fzVI07cHElbcrXj//rGusKcb+z4dQcN8H0sNxGloL+NCFPsxvR3fMQiP5tGNhLWqW80BAS/lj/WhzTvc+zbevL++nZbmr+cF4GeMtcwMvpRDB+KYnYGnmz3p6iY01J4smStM4GDTaeValWifv+NVQ69qsIr4m//574LZmDnIdnaWa/4TCQ5rBCaXbWaNX+4X39pKe1C/21qEtD3CFxoa/pj+/xoaqDU3NOeWEJ6tljSlEQc5/VKUPhNdwIm00JrVjN/QogPbESQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qD6hixH2FpJz5wfaTZ8Bu7e+a+vsNQyqtxNknJYYGR4=;
 b=Iad0HYRLYeiWsvkSVib5vwLQiUyptxN4zXVgeCV9BTmpP1SAHg0RhoL4GAx+XwD1VRdLhv0LQ4jBNFH4Z8mrgQU4dve3lPmv5/0gj77JMHFdQMokqIJXyr2tjvG32xyUkUSGQ6nE+UYvOND/STEJDRjSY0YHCfzzwjbPre5LWWX8/UEMUeA1j/OZfh6DKE3N7O7K/WxNbdZjVE/dnm4qZGzUX9RGO6lAzDniMVtuKRBVBW0cR2lN32pOY4i3O0bIbn4iyHiiyfjdFcbcHXvodsCgToheP3wGVokjnnTEsgIF88ZbHox3NAMw42pyvklkCutxmqffZuf+OrngnM1mZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qD6hixH2FpJz5wfaTZ8Bu7e+a+vsNQyqtxNknJYYGR4=;
 b=V+BbOczXYbkHpwIm9y7b+fsS1YEUSBLpwmP+DM6NSJxY48jfXUNSwACLB5p83igX10jzIcQVwRKROtdnfv0Fy4gkJMWiArxRNaz43EuH+S3pvB3Q1TIXCqiBAvuFbxze8g++iVZM4ekHkCeC/oG4dpVq4jMcwfl2pqB7vfqCWaI=
Subject: Re: [PATCH v2] x86/xen: avoid warning in Xen pv guest with
 CONFIG_AMD_MEM_ENCRYPT enabled
To:     Juergen Gross <jgross@suse.com>, <xen-devel@lists.xenproject.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        <stable@vger.kernel.org>
References: <20210127093822.18570-1-jgross@suse.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <fb2305a4-4741-c641-9639-5b17b63f2baf@citrix.com>
Date:   Wed, 27 Jan 2021 09:43:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210127093822.18570-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: LO4P123CA0466.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::21) To BYAPR03MB4728.namprd03.prod.outlook.com
 (2603:10b6:a03:13a::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a159071d-3c4b-4a8e-0936-08d8c2a806a4
X-MS-TrafficTypeDiagnostic: BYAPR03MB4454:
X-Microsoft-Antispam-PRVS: <BYAPR03MB44548885C95C1A2C642FD3A7BABB9@BYAPR03MB4454.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAFU0Y+dsQ1f7fiSGF39oj3hCLkzmUo7bjxiAeO/C70vF+Lx83uqnpoBtii6ZI9ZwfW2cxbafAz2rQgoe83CuCvH+sSxq4Yk1p06WP4YlBnFWlRlSUK4jYZuRWmMah6yZWjMbeWFQgmayP0XEWQ8QoEISDy69Upw45fl6NgOY7MSM5dcU5htz2FW5m7Xzg/r+01aBMGHFGC6PTEUZawJ56A01N79V0EwFpsP3drg/lHuwxo7Jn17upr+7GwYcXtvLgDrgLJcD5ZL4i4d/7DHUPQFBS9yqssFP8JdkFBcGSrVnDkpoBdlnccKkQ9CFUQTxFWcbwgf/tE37RH47gqvizuJayQp46ZxaQq491QBEnOBrfILfZushEY5EVuiUzLTvy39iiTdqwJHxlcz1I8PvtrzK0gpCZxc4o1GGT2OLQsP3BuyWnu6W9OV1cW/KnJAggtC/ImzfOeZJ2lusZ3cnF4ULZCt8MoUu78GZW3umiE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB4728.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(5660300002)(86362001)(4326008)(31696002)(36756003)(31686004)(478600001)(316002)(54906003)(2906002)(7416002)(8936002)(66556008)(66476007)(66946007)(4744005)(6666004)(16576012)(6486002)(26005)(53546011)(16526019)(8676002)(186003)(956004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aWNnTFNPbnIwakV0SXUrVHdOOEdUUW5yMEM5MW1UV053SDdFOVRwUkozNmhh?=
 =?utf-8?B?bEpkUWU5MVVLbmhGcFVRUS9PVHM4bFcycS93NDJ4SWFIN0NMWGdScjZPRXZk?=
 =?utf-8?B?RU53MFVRcUx0SkZqTzhzVllabGhzczh3LzFSTjc4a0kxdi9Ld3pKQnZqRGw1?=
 =?utf-8?B?OUVBRDUva0JyVXdmM1JQUUROS254MDFZRElZbjZTOXpmbzNOclZMNnhibldQ?=
 =?utf-8?B?UzMzbUFaY2liRlVLN0taQ0NpUFpqOUUwREowSFZQZ0lwY1M3N1hMdkRBV2hR?=
 =?utf-8?B?V2pTdkhPRUIvdTVyNlgzVjRIWUJkZXhHNUw5bzE4VEtmcFh4UUVIUG1hNTJO?=
 =?utf-8?B?UThreWc2ZFd2STBkNFM4cmtZaUt2aWFiMUFKdUE3OG9rSDhZRmVYdHN2c3hX?=
 =?utf-8?B?Q3N5SndTYkV6YUc5M3FxbGpJZWtTVzhxekxKVkttd0o1b1lySmhzMDIxNGEr?=
 =?utf-8?B?U0ttWGV4V2cwZjZocFpCR2ZNazhPbHJwT3FYMCtaNFoxUjJ1eU83RExvUHY5?=
 =?utf-8?B?a0d3eDgyZkRseTdxTmlGRmJFQ1pkZkJzZ0NhZkR0R2ZxYi9uQnFhMDNEMnRw?=
 =?utf-8?B?V0JsL1F6MGNIY3ZMT2lFZENlU2p1enhjdE5xSVlkb2RmcUd2RjNXeXpHb0dX?=
 =?utf-8?B?VHgrRzlab2lxdVhMa3Z5Zk9aZWRDUmh5YUN1Q0VVTnhjVDMzR0JENnFqcWRJ?=
 =?utf-8?B?V25nV3FlTzVycmErd3FGVFN3a01jTkszYy9scVluMlZaUjI0MHpIR0JoaFhV?=
 =?utf-8?B?TGZFTis5Q1pBV1N4Tm96b1ZCdWdNMHJwcFIxWlFUUmlDMUhhRTAzdDY4N3BC?=
 =?utf-8?B?NzJQRk1XK3V3amExYzFtU0Z3TUdHZ2ozQ2ZRcjIxOFVWdENGZHQ0Lzl3YjEr?=
 =?utf-8?B?Mm9nK0R6TFczUExxZk5QU1BlanVTTklTOTd3T2ZYSzJCUnhBc0hDTWFJZ2JH?=
 =?utf-8?B?N3hZczJNQ0xZVHVzaTFlVHNvK09FdWhyRmc3ZmJ3cyt6T1VEK3JDTldUSFI5?=
 =?utf-8?B?c0RTdVJzMUk4UHlaaWFMZmI5Q2IveU9kRnk0YjJkbjRCWkYrbGlOZWlKemd2?=
 =?utf-8?B?ZDV3bERhNXNxZlJIRTJPRVh4Zy9MV0krTXZWWnkzdENwcWtTWWEreXk3Wk5t?=
 =?utf-8?B?Zm54KzJWSUE5TlZqSDFrVFRIL0tQa0xUSlpvczdPYUg2K2UrQkpjSEppZVVy?=
 =?utf-8?B?d1N1VnFuU3hubGNLRHRZYTJYWWkzSlFoTUlQeU9Ba2NOT1phSXg3VlZ3MjYw?=
 =?utf-8?B?U20rYnljUVl6dThoVVd4WjJHeHR6MTNFTERDcHRVeUNWR1Zqd2twMnRzSzdJ?=
 =?utf-8?B?dFYwQk1uS0RWNGN3UHdMRzh2NCs3SWd2THJTSktINCtRU3VsVmMrM3FZRUo5?=
 =?utf-8?B?cTVxM0dVNmVOMU55QUFsaUFqL1dKN0h0Mlgzc0djSkpjVDBtVXNmVmZzckpz?=
 =?utf-8?Q?rlUn3h6T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a159071d-3c4b-4a8e-0936-08d8c2a806a4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4728.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 09:43:39.7261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKz1qP+oixGYlrxmH/ox+CWTn9NXK4SAqa0MHQO/HvtQRuIcpknIrGYL94Kly/trj5ZMjcCUFozWy2RpuXrkovJ3NJ2b3LJfBczI4oQuwWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4454
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/01/2021 09:38, Juergen Gross wrote:
> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
> index 4409306364dc..ca5ac10fcbf7 100644
> --- a/arch/x86/xen/enlighten_pv.c
> +++ b/arch/x86/xen/enlighten_pv.c
> @@ -583,6 +583,12 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
>  		exc_debug(regs);
>  }
>  
> +DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
> +{
> +	/* This should never happen and there is no way to handle it. */
> +	panic("Unknown trap in Xen PV mode.");

Looks much better.  How about including regs->entry_vector here, just to
short circuit the inevitable swearing which will accompany encountering
this panic() ?

~Andrew
