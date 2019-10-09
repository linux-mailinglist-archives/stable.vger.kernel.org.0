Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2F7D1AAB
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 23:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731937AbfJIVPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 17:15:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25527 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731916AbfJIVPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 17:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570655714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7VmgJlX8pTLTmeUK2iuzqG3qzkbe72v0AjNOA3U4FSc=;
        b=F105KaKWPHqMzppfSmfp+5U/ZXXDIj+JZMyuMJtA4wY8uDI/nXcTLiy0gyTdvL/soOQpN0
        r+eqY6MTwOWgpAgr5uWSNkKoVRz25kBCvmB2tYmr5eRSKpVYCydT18Xfo7pq42Bg7WDmFf
        CSjn1CffjrjCmm+1Ck7PbA5YJyOvAQI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-sR5cpQTZMkSSXzYn-3Kswg-1; Wed, 09 Oct 2019 17:15:10 -0400
Received: by mail-wm1-f72.google.com with SMTP id g67so1140278wmg.4
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 14:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i6l3KX7zHJ5HDKx9SqXKsfD5zGuc3xvROj8VyAucjM0=;
        b=TwqWA0f15+xRv0mU+c4d49BS0IqWniinqs6hPeR3WV3Qo3LN6twIuLJ75HayEJP6Hf
         dDhRJR48bXtljQDd/qs0mBNI1kAxZDu+zVa+QMlHsw43zSwl2JBMfiv/uKuCm/pSHJFf
         v76uyJZEQtIi2PRQULgg+ur8CBgc4zOxk+n7m4NaUeeMIetf7ecMpSAxPDpu8hIF5xL0
         MlM0p0+vkBJFs5IapMLWDBpiM84+Jn6mD7Ml2hhBizexTY73uQVCrf7AoUtwTY1ORwiX
         JQurbfR9r4bcGFNx5dNSmg3zP8OTLHPE6oEad89CjC3uG7lGRhHdNtAfelfAkW7pSSx0
         TXYA==
X-Gm-Message-State: APjAAAVCPD6RISIcGvPbTMuQD+Y+HVMCUAlFuNsZ2m1jEDCvRw+YY0f/
        qyWpxq+vMKBjXIuzXgrdijTdaKfEsmlZ6QJCKnIZw56h6G14fqXLTUL1DmXI9vJefTApVS8E8ev
        keQuE+0AXuQepdo5/
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr4103779wmj.91.1570655709796;
        Wed, 09 Oct 2019 14:15:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyZjJA1LTm5EeJ/fmz3nZAMmXsY1yAaPjxR1Gi2GVNEpEkekFZxvaPx1RlKODkjSwiZVB8kTw==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr4103761wmj.91.1570655709497;
        Wed, 09 Oct 2019 14:15:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1032:7ea1:7f8f:1e5? ([2001:b07:6468:f312:1032:7ea1:7f8f:1e5])
        by smtp.gmail.com with ESMTPSA id l9sm2821110wme.45.2019.10.09.14.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 14:15:08 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.3 28/68] KVM: x86: Expose XSAVEERPTR to the
 guest
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
References: <20191009170547.32204-1-sashal@kernel.org>
 <20191009170547.32204-28-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <05acd554-dd0a-d7cd-e17c-90627fa0ec67@redhat.com>
Date:   Wed, 9 Oct 2019 23:15:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009170547.32204-28-sashal@kernel.org>
Content-Language: en-US
X-MC-Unique: sR5cpQTZMkSSXzYn-3Kswg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/10/19 19:05, Sasha Levin wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>=20
> [ Upstream commit 504ce1954fba888936c9d13ccc1e3db9b8f613d5 ]
>=20
> I was surprised to see that the guest reported `fxsave_leak' while the
> host did not. After digging deeper I noticed that the bits are simply
> masked out during enumeration.
>=20
> The XSAVEERPTR feature is actually a bug fix on AMD which means the
> kernel can disable a workaround.
>=20
> Pass XSAVEERPTR to the guest if available on the host.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/kvm/cpuid.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fd1b8db8bf242..59b66e343fa5a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -479,6 +479,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_en=
try2 *entry, u32 function,
> =20
>  =09/* cpuid 0x80000008.ebx */
>  =09const u32 kvm_cpuid_8000_0008_ebx_x86_features =3D
> +=09=09F(XSAVEERPTR) |
>  =09=09F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSB=
D) |
>  =09=09F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
> =20
>=20

Yet another example of a patch that shouldn't be stable material (in
this case it's fine, but there can certainly be cases where just adding
a single flag depends on core kernel changes).

Paolo

