Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B49CE2AC
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 15:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfJGNGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 09:06:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33099 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727742AbfJGNGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 09:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570453597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=/mnF3tIB9bsHM3jBrIHJXbHh7EqEOSQkIRLqfcvq4zc=;
        b=UPpWACnuMXBrtndPSHjA7BYYdTTawBZkpmJm2WCEOrHUX2rQ+15RitQy3ufNEZTGGrlchR
        aCnSEpar2UHYDPm3hlON7/nXbYH4wV48QHUNKMnyGXpRqpYklifjleFojstBVYOZOtl54i
        Jt7OBemZdaBIluYL3tUpIE4VJqTh6rk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-rgUEEvl4PhKk7fKgAq_xzg-1; Mon, 07 Oct 2019 09:05:32 -0400
Received: by mail-wr1-f70.google.com with SMTP id w8so7535369wrm.3
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 06:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ki3SLnX233wXVke+cnEMWJZ1XFu5UG1iN+r0BHw5b8A=;
        b=IqXZVpe99NA7zfOi/yymCnGW6QlOHLs1t9G2gri+jUPcO8mePCkUhRu3tP0s3bOdzS
         hLR0oK07oori2E9jBqYBkZ2ey6NRNUs6wSYKpfif8ud0Mw/GqwdYf4cNv8IpH7YLdCWq
         JGw1CSPmHXh+cO2KM/Gd2bSNU4TFh7RqI/lz3E8WzAxA46NQXa8cq2ImNMQvYm7NV7k4
         urVUkqTtKwDuvHpIjhRKkS0rZbWcGLjAv4KwGDz8xC1pCClDoAukVEpEMy9/AajhS1tB
         pIKjFs9RZQijBf4eDYxSnlF2/x2ClVufd93Iz7EliBWLVOnJIsdJP1SRD5nZVQ49Xq+l
         J06A==
X-Gm-Message-State: APjAAAXshD7Hwov/kCpL98FdctFQRU6xUUswpcNdaIpa1hNqxCRKflna
        b2Tm8HEVKj57eZQYPFpw4EUTPM6GhcqeM0Zw/C7dQCvoE/ZkSnCy5yb+rAbpRr7cvKgNR2/uTIL
        i9dvBtnKjrSVc3QyM
X-Received: by 2002:a1c:f714:: with SMTP id v20mr21265962wmh.55.1570453531340;
        Mon, 07 Oct 2019 06:05:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzdfqTu2Tya4+bFQFY21i7KQLu9u9p84q+GlcBeY4TJm5fOnd2c1ptwwodl0C1WKtYtRnNBfw==
X-Received: by 2002:a1c:f714:: with SMTP id v20mr21265929wmh.55.1570453531025;
        Mon, 07 Oct 2019 06:05:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id s9sm15156590wme.36.2019.10.07.06.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 06:05:30 -0700 (PDT)
Subject: Re: [stable 4.4/4.9/4.14/4.19] KVM: nVMX: handle page fault in vmread
 fix
To:     Jack Wang <jinpuwang@gmail.com>, gregkh@linuxfoundation.org,
        sashal@kernel.org, stable@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20191007123653.17961-1-jinpuwang@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2fed8f4e-c2df-9bde-9d0f-7d0882aa19a4@redhat.com>
Date:   Mon, 7 Oct 2019 15:05:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007123653.17961-1-jinpuwang@gmail.com>
Content-Language: en-US
X-MC-Unique: rgUEEvl4PhKk7fKgAq_xzg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/10/19 14:36, Jack Wang wrote:
> From: Jack Wang <jinpu.wang@cloud.ionos.com>
>=20
> During backport f7eea636c3d5 ("KVM: nVMX: handle page fault in vmread"),
> there was a mistake the exception reference should be passed to function
> kvm_write_guest_virt_system, instead of NULL, other wise, we will get
> NULL pointer deref, eg
>=20
> kvm-unit-test triggered a NULL pointer deref below:
> [  948.518437] kvm [24114]: vcpu0, guest rIP: 0x407ef9 kvm_set_msr_common=
: MSR_IA32_DEBUGCTLMSR 0x3, nop
> [  949.106464] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000000
> [  949.106707] PGD 0 P4D 0
> [  949.106872] Oops: 0002 [#1] SMP
> [  949.107038] CPU: 2 PID: 24126 Comm: qemu-2.7 Not tainted 4.19.77-pserv=
er #4.19.77-1+feature+daily+update+20191005.1625+a4168bb~deb9
> [  949.107283] Hardware name: Dell Inc. Precision Tower 3620/09WH54, BIOS=
 2.7.3 01/31/2018
> [  949.107549] RIP: 0010:kvm_write_guest_virt_system+0x12/0x40 [kvm]
> [  949.107719] Code: c0 5d 41 5c 41 5d 41 5e 83 f8 03 41 0f 94 c0 41 c1 e=
0 02 e9 b0 ed ff ff 0f 1f 44 00 00 48 89 f0 c6 87 59 56 00 00 01 48 89 d6 <=
49> c7 00 00 00 00 00 89 ca 49 c7 40 08 00 00 00 00 49 c7 40 10 00
> [  949.108044] RSP: 0018:ffffb31b0a953cb0 EFLAGS: 00010202
> [  949.108216] RAX: 000000000046b4d8 RBX: ffff9e9f415b0000 RCX: 000000000=
0000008
> [  949.108389] RDX: ffffb31b0a953cc0 RSI: ffffb31b0a953cc0 RDI: ffff9e9f4=
15b0000
> [  949.108562] RBP: 00000000d2e14928 R08: 0000000000000000 R09: 000000000=
0000000
> [  949.108733] R10: 0000000000000000 R11: 0000000000000000 R12: fffffffff=
fffffc8
> [  949.108907] R13: 0000000000000002 R14: ffff9e9f4f26f2e8 R15: 000000000=
0000000
> [  949.109079] FS:  00007eff8694c700(0000) GS:ffff9e9f51a80000(0000) knlG=
S:0000000031415928
> [  949.109318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  949.109495] CR2: 0000000000000000 CR3: 00000003be53b002 CR4: 000000000=
03626e0
> [  949.109671] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  949.109845] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [  949.110017] Call Trace:
> [  949.110186]  handle_vmread+0x22b/0x2f0 [kvm_intel]
> [  949.110356]  ? vmexit_fill_RSB+0xc/0x30 [kvm_intel]
> [  949.110549]  kvm_arch_vcpu_ioctl_run+0xa98/0x1b30 [kvm]
> [  949.110725]  ? kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
> [  949.110901]  kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
> [  949.111072]  do_vfs_ioctl+0xa2/0x620
>=20
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  arch/x86/kvm/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index f6b0f5c01546..3bfdbb5fced5 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -8026,7 +8026,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  =09=09/* _system ok, nested_vmx_check_permission has verified cpl=3D0 */
>  =09=09if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
>  =09=09=09=09=09=09(is_long_mode(vcpu) ? 8 : 4),
> -=09=09=09=09=09=09NULL))
> +=09=09=09=09=09=09&e))
>  =09=09=09kvm_inject_page_fault(vcpu, &e);
>  =09}
> =20
>=20

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo

