Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E728DA9
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 01:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387997AbfEWXLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 19:11:21 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:50932 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387693AbfEWXLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 19:11:21 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EACE0C00C6;
        Thu, 23 May 2019 23:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558653066; bh=u9/BLbFMWX5K9TbPybc6ta2H5xZwxROFbq94KT4LOLc=;
        h=From:To:CC:Subject:Date:References:From;
        b=BuIOmpZclptRaTY+qH3bTZGf+L2kUJpAqCRGawoN/NlPcdz3diGQt6/8V5gZPB5Ls
         K7r/pEzNotmniOV1P0deQJekDtU8y0+RR9heI+1K3ws/VZH6fpSODBVxiPFR1r5jpe
         2f3GhzlzJ3scHvNAYZu1vBrM+71DhNYLbaUYkIT+NrR/dqtiNB5CjyB2BY1IiQigMP
         u/zbqf0QjLUxV0AX7L9aNEk371D2batmf7mayfODrRdEFX+Qd+659L+b8a3oA2zrKH
         GiMo7x07wwEDkJ65XDd9Ay4Q+yxNIvbrqETp5cAsjdG/iEtFyrsHMJwKmjr0w1TbXJ
         28l+KryqupmeQ==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 56B75A0097;
        Thu, 23 May 2019 23:11:09 +0000 (UTC)
Received: from us01wembx1.internal.synopsys.com ([169.254.1.22]) by
 US01WXQAHTC1.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Thu,
 23 May 2019 16:10:30 -0700
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>
CC:     "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "arnd@arndb.de" <arnd@arndb.de>, "bp@alien8.de" <bp@alien8.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>,
        "jhogan@kernel.org" <jhogan@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mattst88@gmail.com" <mattst88@gmail.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "palmer@sifive.com" <palmer@sifive.com>,
        "paul.burton@mips.com" <paul.burton@mips.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>
Subject: Re: [PATCH 05/18] locking/atomic: arc: use s64 for atomic64
Thread-Topic: [PATCH 05/18] locking/atomic: arc: use s64 for atomic64
Thread-Index: AQHVEKGs9KZlALHlM0GHW5LrArar6w==
Date:   Thu, 23 May 2019 23:10:30 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307501A251D626@us01wembx1.internal.synopsys.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190522132250.26499-6-mark.rutland@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/22/19 6:24 AM, Mark Rutland wrote:=0A=
> As a step towards making the atomic64 API use consistent types treewide,=
=0A=
> let's have the arc atomic64 implementation use s64 as the underlying=0A=
> type for atomic64_t, rather than u64, matching the generated headers.=0A=
>=0A=
> Otherwise, there should be no functional change as a result of this=0A=
> patch.=0A=
>=0A=
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>=0A=
> Cc: Peter Zijlstra <peterz@infradead.org>=0A=
> Cc: Vineet Gupta <vgupta@synopsys.com>=0A=
> Cc: Will Deacon <will.deacon@arm.com>=0A=
=0A=
Thx for the cleanup Mark.=0A=
=0A=
Acked-By: Vineet Gupta <vgupta@synopsys.com>   # for ARC bits=0A=
=0A=
-Vineet=0A=
