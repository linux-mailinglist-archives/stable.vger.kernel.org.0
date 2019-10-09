Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDFAD1C2E
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 00:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732220AbfJIWtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 18:49:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35350 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730815AbfJIWtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 18:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570661371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=nZonk2/mRB1boKLTxfgV+UfH1DuBLDAVVaiBeToXo30=;
        b=bOV9OdO0VtwlYcGRSZ+BKNID87Nj0VRkzyLMyDc13bsC8Qpcm358TBVwYyF5gzdhQJY0Gh
        ask6g2tAQUZeOgLMUHu3xkdkVUVYjcs3y4pe2I2NJ9P73LeObPd0j40JFtB5BevzLWugKl
        +6wbcmvM4OY5dKQyYVlyuIcGf9FrFRw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-HN_Ks2LHNJaVRR_XiztoBg-1; Wed, 09 Oct 2019 18:49:30 -0400
Received: by mail-wr1-f72.google.com with SMTP id w10so1775786wrl.5
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 15:49:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DoZLlJIxnv792llQ86N6fFnpfG9V6Pvfi/VrOtQ0Pc8=;
        b=Bn32RVDwEi+ORxlcwGrgnlhpMUcwzMB3m5SB+obbzg09wBrGKo8tRgTcrUndBab85t
         Nkk+bV7R9jLELTl5WsNPaLumIGFFqaOkSjwyDpthHs/pg3vre1t4LUyNXfTd8LMzW+Kf
         SbFVA12bAqCfL9wSDTqvWf/lBAxPv+bkF5YvUQsegZqoKdTj8nvsNoyAljmcarkC7Pvl
         1PNJ39He1xXsfoJPutzPMLNkVgkLvS731eHsd07gmrqpCyG4vmf9BMhFcHqOokFrGR7f
         DN4UP0a5VXRBjcmUt9wVZ0yornvofitETr+RuD3VAHQYL5Kc2Gd3bAhYShHKWNN/mkmy
         94QA==
X-Gm-Message-State: APjAAAWMsICEhPW3pUg0g0M5/a/2aYvSkPAgcnD3kNma33AUFY6eFLYu
        oJcAAPPjQlL9WurPsxqgfRhA+Jt9vUzlbBXj79g2SlC/jTBwh3ua0DVUbJYt4YnI9lePzVTZ/CJ
        F7RBRqRjZwu1xjRMY
X-Received: by 2002:adf:f188:: with SMTP id h8mr4848474wro.38.1570661369310;
        Wed, 09 Oct 2019 15:49:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyCjAafIgWlXkt+EEzwJgcMSKSzRjfxUDjH4uZYPg9/cb0j2rQX3I0mCOAOmAnjEozoSdrEPg==
X-Received: by 2002:adf:f188:: with SMTP id h8mr4848462wro.38.1570661369059;
        Wed, 09 Oct 2019 15:49:29 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z125sm4451630wme.37.2019.10.09.15.49.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 15:49:28 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 4.19 08/26] kvm: x86: Improve emulation of CPUID
 leaves 0BH and 1FH
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Marc Orr <marcorr@google.com>, Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
References: <20191009170558.32517-1-sashal@kernel.org>
 <20191009170558.32517-8-sashal@kernel.org>
 <5fcb0e38-3542-dd39-6a1c-449b4f9f435e@redhat.com>
 <20191009224129.GX1396@sasha-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3855e044-f2d1-6371-018a-c2d32031d8fb@redhat.com>
Date:   Thu, 10 Oct 2019 00:49:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009224129.GX1396@sasha-vm>
Content-Language: en-US
X-MC-Unique: HN_Ks2LHNJaVRR_XiztoBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/19 00:41, Sasha Levin wrote:
>> Is it possible for KVM to opt
>> out of this AUTOSEL nonsense?
>=20
> Sure, I've opted out KVM and removed all KVM patches from this series:

Thanks!

Paolo

> c1fac4516a61d kvm: vmx: Limit guest PMCs to those supported on the host
> 75b118586ec81 kvm: x86, powerpc: do not allow clearing largepages
> debugfs entry
> 06cd1710feaed KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if !X86_BUG_L1=
TF
> c89fc5c082aa6 KVM: x86: Expose XSAVEERPTR to the guest
> 1eec6b4068e2e kvm: x86: Use AMD CPUID semantics for AMD vCPUs
> 5c56e6ba0afc8 kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
> 94a3c6f010bd2 kvm: x86: Fix a spurious -E2BIG in __do_cpuid_func

