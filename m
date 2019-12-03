Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EE810FAC1
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 10:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLCJbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 04:31:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36011 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725773AbfLCJbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 04:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575365481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ccF0ajXP8HBc8ijEIbPxb/SW3cou8LZhbpgUuAl6x/w=;
        b=R1ul3ac7fxG4eGFSN9xr0wFmxRaGQmCdb5z/GbXib5PNBcyNGobhxc5ub6nUvPc1I2Np7M
        CXHoPxXfQMt5vMd8PFeulCPD2F+cdI3EYGUuiN+O+kJChLIOYLZ9q6UR4KKhrcyfBg5QW4
        VE1D8jrorZ3h9jaOzpWZVSldmIshi8k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-NCUEbCQLOeyvrRChc5HxCg-1; Tue, 03 Dec 2019 04:31:17 -0500
Received: by mail-wr1-f69.google.com with SMTP id 92so1461839wro.14
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 01:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pqLIE58UAw3dvThIrcQE32eMUDCSJr2Vnkr2jVztGkA=;
        b=KMR578JnURiNZ1GUbrGnmVbGxiZ3Br5lYACqD6Y8eb8iTeSh2bORr7ZqMkTK/y8uaT
         qY6UKqLaHs5uw7GtPQK7iumeuk6LdCBmmj2epO5xDd8EPMTNkRtt3SgpED+lTFnXz9wE
         9aBLe45fI/T8mXo8fSl9XdG0iKNwXd4fRiUDG1hDaa6AIz//7u8g7d/Vo7Y4o0vA9xYt
         v2CA6CtpfW4WNvI2mMcQOUBUrd2nmQMiGScscJx/CYFAJ2377xFtXXqXlb18/BoGzrz8
         RLOFIzU+yK00bHuzAn7oPyN5uYkbutvStc3jWNpXA8tiYyK2PL99N0b7gu00IAgwcTMN
         FqVA==
X-Gm-Message-State: APjAAAV/3G0d0KV7WROKNL5t6fKuSAK1znSDqS/2xzVM76uCGEzIcgL8
        N0WYcVx6/rfBWV/t75kmqhoJ1+L1Go13oGpJ3p/1I79yczt4Kf9Xz6jLqWnnguEWOyQEdB8poaT
        H2gbfPBDo3oi7Lkf2
X-Received: by 2002:a1c:2745:: with SMTP id n66mr32903746wmn.171.1575365475980;
        Tue, 03 Dec 2019 01:31:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqxv/8chgzjepA9kVkC4EBIYQZG5mCLApSK9DTOrQR3Wnj2da3SiM30rKwmR/e/7TAIKVntRKA==
X-Received: by 2002:a1c:2745:: with SMTP id n66mr32903710wmn.171.1575365475660;
        Tue, 03 Dec 2019 01:31:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id r6sm2783864wrv.40.2019.12.03.01.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 01:31:15 -0800 (PST)
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
 <20191202145105.GA571975@kroah.com>
 <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
 <CA+res+SffBsmmeEBYfoDwyLHvL8nqW+O=ZKedWCxccmQ9X6itA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <828cf8b7-11ac-e707-57b6-cb598cc37f1b@redhat.com>
Date:   Tue, 3 Dec 2019 10:31:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CA+res+SffBsmmeEBYfoDwyLHvL8nqW+O=ZKedWCxccmQ9X6itA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: NCUEbCQLOeyvrRChc5HxCg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/12/19 10:21, Jack Wang wrote:
> Paolo Bonzini <pbonzini@redhat.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=882=E6=
=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=884:09=E5=86=99=E9=81=93=EF=BC=9A
>>
>> On 02/12/19 15:51, Greg Kroah-Hartman wrote:
>>> On Mon, Dec 02, 2019 at 03:40:04PM +0100, Jack Wang wrote:
>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B4=
11=E6=9C=8827=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:30=E5=86=99=
=E9=81=93=EF=BC=9A
>>>>>
>>>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>>>
>>>>> [ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]
>>>>>
>>>>> In preparation of supporting checkpoint/restore for nested state,
>>>>> commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_ru=
n()")
>>>>> modified check_vmentry_postreqs() to only perform the guest EFER
>>>>> consistency checks when nested_run_pending is true.  But, in the
>>>>> normal nested VMEntry flow, nested_run_pending is only set after
>>>>> check_vmentry_postreqs(), i.e. the consistency check is being skipped=
.
>>>>>
>>>>> Alternatively, nested_run_pending could be set prior to calling
>>>>> check_vmentry_postreqs() in nested_vmx_run(), but placing the
>>>>> consistency checks in nested_vmx_enter_non_root_mode() allows us
>>>>> to split prepare_vmcs02() and interleave the preparation with
>>>>> the consistency checks without having to change the call sites
>>>>> of nested_vmx_enter_non_root_mode().  In other words, the rest
>>>>> of the consistency check code in nested_vmx_run() will be joining
>>>>> the postreqs checks in future patches.
>>>>>
>>>>> Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_ru=
n()")
>>>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>>>> Cc: Jim Mattson <jmattson@google.com>
>>>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>> ---
>>>>>  arch/x86/kvm/vmx.c | 10 +++-------
>>>>>  1 file changed, 3 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>>>> index fe7fdd666f091..bdf019f322117 100644
>>>>> --- a/arch/x86/kvm/vmx.c
>>>>> +++ b/arch/x86/kvm/vmx.c
>>>>> @@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct kvm=
_vcpu *vcpu, u32 *exit_qual)
>>>>>         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_ac=
tive(vcpu))
>>>>>                 evaluate_pending_interrupts |=3D vmx_has_apicv_interr=
upt(vcpu);
>>>>>
>>>>> +       if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit=
_qual))
>>>>> +               return EXIT_REASON_INVALID_STATE;
>>>>> +
>>>>>         enter_guest_mode(vcpu);
>>>>>
>>>>>         if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROL=
S))
>>>>> @@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcpu *v=
cpu, bool launch)
>>>>>          */
>>>>>         skip_emulated_instruction(vcpu);
>>>>>
>>>>> -       ret =3D check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
>>>>> -       if (ret) {
>>>>> -               nested_vmx_entry_failure(vcpu, vmcs12,
>>>>> -                                        EXIT_REASON_INVALID_STATE, e=
xit_qual);
>>>>> -               return 1;
>>>>> -       }
>>>>> -
>>>>>         /*
>>>>>          * We're finally done with prerequisite checking, and can sta=
rt with
>>>>>          * the nested entry.
>>>>> --
>>>>> 2.20.1
>>>>>
>>>>>
>>>>>
>>>> Hi all,
>>>>
>>>> This commit caused many kvm-unit-tests regression, cherry-pick
>>>> following commits from 4.20 fix the regression:
>>>> d63907dc7dd1 ("KVM: nVMX: rename enter_vmx_non_root_mode to
>>>> nested_vmx_enter_non_root_mode")
>>>> a633e41e7362 ("KVM: nVMX: assimilate nested_vmx_entry_failure() into
>>>> nested_vmx_enter_non_root_mode()")
>>>
>>> Now queued up, thanks!
>>>
>>> greg k-h
>>>
>>
>> Why was it backported anyway?  Can everybody please just stop applying
>> KVM patches to stable kernels unless CCed to stable@vger.kernel.org?
>>
>> I thought I had already asked Sasha to opt out of the autoselect
>> nonsense after catching another bug that would have been introduced.
>>
>> Paolo
>>
> Hi Paolo,
>=20
> Should we simply revert the patch, maybe also
> 9fe573d539a8 ("KVM: nVMX: reset cache/shadows when switching loaded VMCS"=
)
>=20
> Both of them are from one big patchset:
> https://patchwork.kernel.org/cover/10616179/
>=20
> Revert both patches recover the regression I see on kvm-unit-tests.

Greg already included the patches that the bot missed, so it's okay.

Paolo

