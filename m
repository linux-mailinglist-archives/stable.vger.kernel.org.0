Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF88F833B
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 00:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKKXFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 18:05:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35916 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726924AbfKKXFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 18:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573513548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=q3bU1y6/w3lsCZ4mK2/2iMcVIQyk5otgwImYycb24yA=;
        b=H4/Nt/1U6wdfKBje+zpcFTX0V7tMDzfDXWWrjdQxDZ47EDx+9K0T4i6XltA+t6tKdC2JWC
        30DpZ90w2e86AolI1RxdcWZWWpmuyOPPS3dXhhgpnrCkxq7wUA7qdoXaxi8QBR8nK2xDjC
        OWLxus9xEepKN31umm9m7MNq1sNBcF4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-H9WJ4eXwMsmSMwa-9-EcQQ-1; Mon, 11 Nov 2019 18:05:46 -0500
Received: by mail-wr1-f70.google.com with SMTP id u2so10866475wrm.7
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 15:05:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s1xtP0FWH3mk9taRWJxAZqcAwLn3T+udkKG0yP0FnPk=;
        b=firanVwU6GJYCUSSVxTudJg02WKt6n4XbWFwn4x0RL49y/0gkD6fSHTPe+t9P0e2zm
         D+RJI+Lrr22G+DNDEIqbaaTDheqq3RdB1c0aMN4VvAwokfVDJ8JdOrXzmCP6yupmduMI
         D/NX7xCi9sQUseYnv3zU7UZpQ1RgUxhXXFNY/7yUlis0a0FBYZzvspOFMbwOhFfmKm2H
         jCOwx5igXVkcufilaEY7p7ObplbPcenV4d6PTTA1j82VpWcTKO//Cr+V12NnSgEgh3HR
         35Zbplp4m5KbKyFHfbXn9+Krhq7WrkjvtDg35QA1itdeRc2KrbeTiSEKUnySJDjrSszd
         c0Og==
X-Gm-Message-State: APjAAAXvZR5w4qNmnR99pO5kjd82H7QcXT/L3Ihd7X6n3MMVnoJzr3fu
        oCaBuRkQG5dpUyCElJiiS4ojj/rYCunhRu9a/bo4pLLaEq4gSjQKSnoWho1gULAq5HIbvYWvT75
        VLEd7y3wHKNpxwIZY
X-Received: by 2002:a05:6000:1083:: with SMTP id y3mr21859098wrw.290.1573513544875;
        Mon, 11 Nov 2019 15:05:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqwP0hMQwUe3Rb9JqlVvtLWb4ETL344DFvxUp8KFGJe7FlLiSWTMYnjYvoLgjbyZvFWyxgbB3w==
X-Received: by 2002:a05:6000:1083:: with SMTP id y3mr21859084wrw.290.1573513544562;
        Mon, 11 Nov 2019 15:05:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id i71sm36679380wri.68.2019.11.11.15.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 15:05:44 -0800 (PST)
Subject: Re: [PATCH 4.19 STABLE] KVM: x86: introduce is_pae_paging
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org
References: <20191111225423.29309-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aecfcc9e-dcab-2b52-ebdb-373a416a4951@redhat.com>
Date:   Tue, 12 Nov 2019 00:05:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111225423.29309-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: H9WJ4eXwMsmSMwa-9-EcQQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/19 23:54, Sean Christopherson wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
>=20
> Upstream commit bf03d4f9334728bf7c8ffc7de787df48abd6340e.
>=20
> Checking for 32-bit PAE is quite common around code that fiddles with
> the PDPTRs.  Add a function to compress all checks into a single
> invocation.
>=20
> Moving to the common helper also fixes a subtle bug in kvm_set_cr3()
> where it fails to check is_long_mode() and results in KVM incorrectly
> attempting to load PDPTRs for a 64-bit guest.
>=20
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [sean: backport to 4.x; handle vmx.c split in 5.x, call out the bugfix]
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx.c | 7 +++----
>  arch/x86/kvm/x86.c | 8 ++++----
>  arch/x86/kvm/x86.h | 5 +++++
>  3 files changed, 12 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 6f7b3acdab26..83acaed244ba 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5181,7 +5181,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
>  =09=09      (unsigned long *)&vcpu->arch.regs_dirty))
>  =09=09return;
> =20
> -=09if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
> +=09if (is_pae_paging(vcpu)) {
>  =09=09vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
>  =09=09vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
>  =09=09vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
> @@ -5193,7 +5193,7 @@ static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
>  {
>  =09struct kvm_mmu *mmu =3D vcpu->arch.walk_mmu;
> =20
> -=09if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
> +=09if (is_pae_paging(vcpu)) {
>  =09=09mmu->pdptrs[0] =3D vmcs_read64(GUEST_PDPTR0);
>  =09=09mmu->pdptrs[1] =3D vmcs_read64(GUEST_PDPTR1);
>  =09=09mmu->pdptrs[2] =3D vmcs_read64(GUEST_PDPTR2);
> @@ -12021,8 +12021,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *v=
cpu, unsigned long cr3, bool ne
>  =09=09 * If PAE paging and EPT are both on, CR3 is not used by the CPU a=
nd
>  =09=09 * must not be dereferenced.
>  =09=09 */
> -=09=09if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu) &&
> -=09=09    !nested_ept) {
> +=09=09if (is_pae_paging(vcpu) && !nested_ept) {
>  =09=09=09if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)) {
>  =09=09=09=09*entry_failure_code =3D ENTRY_FAIL_PDPTE;
>  =09=09=09=09return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6ae8a013af31..b9b87fb75ac0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -633,7 +633,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
>  =09gfn_t gfn;
>  =09int r;
> =20
> -=09if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
> +=09if (!is_pae_paging(vcpu))
>  =09=09return false;
> =20
>  =09if (!test_bit(VCPU_EXREG_PDPTR,
> @@ -884,8 +884,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long =
cr3)
>  =09if (is_long_mode(vcpu) &&
>  =09    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
>  =09=09return 1;
> -=09else if (is_pae(vcpu) && is_paging(vcpu) &&
> -=09=09   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
> +=09else if (is_pae_paging(vcpu) &&
> +=09=09 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
>  =09=09return 1;
> =20
>  =09kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
> @@ -8312,7 +8312,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struc=
t kvm_sregs *sregs)
>  =09=09kvm_update_cpuid(vcpu);
> =20
>  =09idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> -=09if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
> +=09if (is_pae_paging(vcpu)) {
>  =09=09load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
>  =09=09mmu_reset_needed =3D 1;
>  =09}
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 3a91ea760f07..608e5f8c5d0a 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -139,6 +139,11 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
>  =09return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
>  }
> =20
> +static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
> +{
> +=09return !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu);
> +}
> +
>  static inline u32 bit(int bitno)
>  {
>  =09return 1 << (bitno & 31);
>=20

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

