Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B19A1A3360
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 13:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgDILnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 07:43:39 -0400
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:45665 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDILnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 07:43:39 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2020 07:43:39 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1586432619;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=dnROBck2MmsFtNlpz/IkbmQXUbQm4A1CETm+vG0i0OU=;
  b=bjd6U7mmVhuhDlUko8UnXkJ+P5A9p2rU/KvEn8iS4Zk8G9BRpOCzp2ND
   0UxB0YamxiSsIzcS2NGJXe6fYTtpWsq1s96lLq4nn7d53iK/sJ5mLXkxL
   TurnLpnUGqfRQWLjohj/rp4S67T7a+X/wxar+cMtHIe81KwQclpx/IR2S
   8=;
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=andrew.cooper3@citrix.com; spf=Pass smtp.mailfrom=Andrew.Cooper3@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa6.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  andrew.cooper3@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="andrew.cooper3@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa6.hc3370-68.iphmx.com: domain of
  Andrew.Cooper3@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="Andrew.Cooper3@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa6.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: mMtBJu/58+SwnHmY2rBetlSq7vlbSSSqGjkKx2ICCOzCZF7qaw0N7dsxlOsNOPN1VAUsj2A3JI
 ICGEpfkGBnyPiZqR7H+TUQWC1px3RqAfta/6HgJo0+H7omcD1vLEDihb9TLL1B5mRwvPPxUjkd
 NKUWe+AOwuxyPSabiAwUg6bWJvjsqf0MMl+/rd/CM1NgUIVvQYMR1oyfLLLbzFS6VmBsf27c72
 xY3+DJo3aFib0wW6oz3BnUpeEHLfX55cUkonXVg1grKmUKASfqzPoWqvlVcKACTAmZ2R5yXMnj
 fEA=
X-SBRS: 2.7
X-MesageID: 15829938
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.72,362,1580792400"; 
   d="scan'208";a="15829938"
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
 <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
 <87d08hc0vz.fsf@nanos.tec.linutronix.de>
 <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <5e79facb-292d-eeae-b860-81a0bee9ef4c@citrix.com>
Date:   Thu, 9 Apr 2020 12:36:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL01.citrite.net (10.69.22.125)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/04/2020 05:50, Andy Lutomirski wrote:
> On Wed, Apr 8, 2020 at 11:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>> On 08/04/20 17:34, Sean Christopherson wrote:
>>>> On Wed, Apr 08, 2020 at 10:23:58AM +0200, Paolo Bonzini wrote:
>>>>> Page-not-present async page faults are almost a perfect match for the
>>>>> hardware use of #VE (and it might even be possible to let the processor
>>>>> deliver the exceptions).
>>>> My "async" page fault knowledge is limited, but if the desired behavior is
>>>> to reflect a fault into the guest for select EPT Violations, then yes,
>>>> enabling EPT Violation #VEs in hardware is doable.  The big gotcha is that
>>>> KVM needs to set the suppress #VE bit for all EPTEs when allocating a new
>>>> MMU page, otherwise not-present faults on zero-initialized EPTEs will get
>>>> reflected.
>>>>
>>>> Attached a patch that does the prep work in the MMU.  The VMX usage would be:
>>>>
>>>>      kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);
>>>>
>>>> when EPT Violation #VEs are enabled.  It's 64-bit only as it uses stosq to
>>>> initialize EPTEs.  32-bit could also be supported by doing memcpy() from
>>>> a static page.
>>> The complication is that (at least according to the current ABI) we
>>> would not want #VE to kick if the guest currently has IF=0 (and possibly
>>> CPL=0).  But the ABI is not set in stone, and anyway the #VE protocol is
>>> a decent one and worth using as a base for whatever PV protocol we design.
>> Forget the current pf async semantics (or the lack of). You really want
>> to start from scratch and igore the whole thing.
>>
>> The charm of #VE is that the hardware can inject it and it's not nesting
>> until the guest cleared the second word in the VE information area. If
>> that word is not 0 then you get a regular vmexit where you suspend the
>> vcpu until the nested problem is solved.
> Can you point me at where the SDM says this?

Vol3 25.5.6.1 Convertible EPT Violations

> Anyway, I see two problems with #VE, one big and one small.  The small
> (or maybe small) one is that any fancy protocol where the guest
> returns from an exception by doing, logically:
>
> Hey I'm done;  /* MOV somewhere, hypercall, MOV to CR4, whatever */
> IRET;
>
> is fundamentally racy.  After we say we're done and before IRET, we
> can be recursively reentered.  Hi, NMI!

Correct.  There is no way to atomically end the #VE handler.  (This
causes "fun" even when using #VE for its intended purpose.)

~Andrew
