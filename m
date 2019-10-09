Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756A7D1C39
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 00:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732412AbfJIWuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 18:50:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44461 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732402AbfJIWuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 18:50:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570661415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=CbgpBG69W3Xxb5a6Ssxl5LP9mZoRKPa/mOy1gfjgbK4=;
        b=EevMpKCocoNeQSzR5WkgzAxXnFM8Bd87LncM9NXkqJTS9dNAnqu0jnG2vq15z2c8WI4IDv
        H7Lsh37nlfdf2/N7rdgDleCF8/tTgTHhI1XIR59DMN35H4UF1IM+L0wh38mNbfoERAD9ZI
        f6Ex1TE0GsHKZ5iFBfa92GrIIwZwmac=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-gUNastFkP92oGUtVhSml7A-1; Wed, 09 Oct 2019 18:50:12 -0400
Received: by mail-wm1-f69.google.com with SMTP id 190so1712862wme.4
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 15:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xsA6d1N0yHId/YtP2xKnkBmHpHSNLVq87w9E1zgqoSY=;
        b=B9oHnp1JfbmXugAjvbL2L3LFPlG9LUrm9RveKIqK33vhBtoWdqrQTtXCjh4m/bjA6H
         VJKjEJi0RhZ8wayudnUeAJBSb7FxEuUm450u7gQX38JyPDYIfZbZhpf3PMcKSXZvKe4f
         CjjAwRf/ANpVvTgKvzuLKZ+8oI8590Ihun8adBc1JfTvuWZXPlQsIm9uK8MKoLK2sKZa
         0HC3esRzhLDK8XnawMZxkpIDY7sqzoj47GZsgs2Ah05+pYyyIzn/THx5dmDqKm6R1+Ye
         sYjJa18tGp+ig0ZxLjNic3wizy0uWj16uZtaBdAsDRBFrGm6HHiLBjd9OepuVavJfB5d
         bl7w==
X-Gm-Message-State: APjAAAWMNx0/Ejg/EoMNoblcIMcJT9IdOP+qrzcxAzrh1wPnghLvtDFs
        lttDnf502qeo8L2Q8Lq+gwQKdEcNBz4c4YaSWPeG9T/RTFMubtqnGHD5QMvXsmOYvQ1XxF23+L1
        Ak3SpITWeMjhYfgIr
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr4921132wrw.10.1570661411381;
        Wed, 09 Oct 2019 15:50:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy07hu4yFjDInGnWEM/eAkittSfEadjpJ+GUEnHkJRlZCXURorVeclhCVbEO1u3sqOAb5pfZw==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr4921118wrw.10.1570661411126;
        Wed, 09 Oct 2019 15:50:11 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o1sm5141619wrs.78.2019.10.09.15.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 15:50:10 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.3 28/68] KVM: x86: Expose XSAVEERPTR to the
 guest
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kvm@vger.kernel.org
References: <20191009170547.32204-1-sashal@kernel.org>
 <20191009170547.32204-28-sashal@kernel.org>
 <05acd554-dd0a-d7cd-e17c-90627fa0ec67@redhat.com>
 <20191009214048.irolhz4rwfdiqf2e@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7119916d-462e-8ba8-300c-c165d9df045a@redhat.com>
Date:   Thu, 10 Oct 2019 00:50:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009214048.irolhz4rwfdiqf2e@linutronix.de>
Content-Language: en-US
X-MC-Unique: gUNastFkP92oGUtVhSml7A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/10/19 23:40, Sebastian Andrzej Siewior wrote:
>>>  =09const u32 kvm_cpuid_8000_0008_ebx_x86_features =3D
>>> +=09=09F(XSAVEERPTR) |
>>>  =09=09F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_S=
SBD) |
>>>  =09=09F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
>>> =20
>>>
>> Yet another example of a patch that shouldn't be stable material (in
>> this case it's fine, but there can certainly be cases where just adding
>> a single flag depends on core kernel changes).
>=20
> Also, taking advantage of this feature requires changes which just
> landed in qemu's master branch.

That's not a big deal, every QEMU supports every kernel and vice versa.

Paolo

