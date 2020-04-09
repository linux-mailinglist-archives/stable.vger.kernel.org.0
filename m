Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188D41A3453
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 14:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDIMrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 08:47:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726647AbgDIMrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 08:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586436437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cZpoXND/3gmTzh1oxxwwcgLLTs9FadoYX5XJNUdgHA=;
        b=fH6LdExSrkljXZ2lxX4P8iaK3PU6FsYq++ql/rxBd7QsgDk9AX5Vdo4dtU9E8wcp5/nPp/
        igBheOIqvhY+1ZBSEsEQ7ZTGAPKdK36LlswVAUmRLI/a5WRZfh73WO8oZd3F2ytRAch1I/
        OIFQBgq/79alpDl0y7h3tMFj5HTG24w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-kWJryTDAMMKCRHbmb8NTVw-1; Thu, 09 Apr 2020 08:47:13 -0400
X-MC-Unique: kWJryTDAMMKCRHbmb8NTVw-1
Received: by mail-wr1-f70.google.com with SMTP id e10so6304949wru.6
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 05:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9cZpoXND/3gmTzh1oxxwwcgLLTs9FadoYX5XJNUdgHA=;
        b=l1lUKVQUdKNgdxYzw/atm9dsYHYRL1eRBB341ESsZFZAAlzR/e85Uk+1CXhM5Dr8aO
         zEYtyco/BSXY975ESIpN3V30Uqc3o4d9aO1cPP0U0CCc+hjsIf7NQYvSjIbl5NVpwqSh
         KbjnYN+u9kgNI6r/CFAfZk3Ck2a8s67MmpxooGbuhwpmPy+eANdv2ARDE/tgK+hLjS6E
         93rcEvHacCUb1T3OcPXYwhnII8EFO3ixmHk3ECNiNrYSzZZmocoe1PVtbQxNZ9//WDlq
         k6kTYxFPlLQjIfIkJj6j5AZkZenAhuWEVAKSBDX0MevsP2G/zd2mjHBDQRNXV3EFO1vO
         y62g==
X-Gm-Message-State: AGi0PuYhXKbIEsBpZxUUVTwVFekS50KvKOMo54sWK78VBf/Rjjeug18p
        RtCdVyklBMZeRVjRrohEP82O/+XkvpqMIoS1Er+FhBfyyVVWRmLe4Ul+oDSaXI9ZdS35/9mdmP3
        v+uwRA4T0fmmMvLNl
X-Received: by 2002:adf:de82:: with SMTP id w2mr11650495wrl.169.1586436432413;
        Thu, 09 Apr 2020 05:47:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypKfSpr+zznIlqiZ5jTI4LNgxdDVUTFZ2rVYdzR0Z4HJ8TlV+mOfJmxmxC04UJ8VX5gcDOs3wg==
X-Received: by 2002:adf:de82:: with SMTP id w2mr11650477wrl.169.1586436432152;
        Thu, 09 Apr 2020 05:47:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e8a3:73c:c711:b995? ([2001:b07:6468:f312:e8a3:73c:c711:b995])
        by smtp.gmail.com with ESMTPSA id f12sm40384763wrm.94.2020.04.09.05.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 05:47:11 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <04aca08a-cfce-b4db-559a-23aee0a0b7aa@redhat.com>
Date:   Thu, 9 Apr 2020 14:47:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/04/20 06:50, Andy Lutomirski wrote:
> The small
> (or maybe small) one is that any fancy protocol where the guest
> returns from an exception by doing, logically:
> 
> Hey I'm done;  /* MOV somewhere, hypercall, MOV to CR4, whatever */
> IRET;
> 
> is fundamentally racy.  After we say we're done and before IRET, we
> can be recursively reentered.  Hi, NMI!

That's possible in theory.  In practice there would be only two levels
of nesting, one for the original page being loaded and one for the tail
of the #VE handler.  The nested #VE would see IF=0, resolve the EPT
violation synchronously and both handlers would finish.  For the tail
page to be swapped out again, leading to more nesting, the host's LRU
must be seriously messed up.

With IST it would be much messier, and I haven't quite understood why
you believe the #VE handler should have an IST.

Anyhow, apart from the above "small" issue, we have these separate parts:

1) deliver page-ready notifications via interrupt

2) page-in hypercall + deliver page-not-found notifications via #VE

3) propagation of host-side SIGBUS

all of which have both a host and a guest part, and all of which make
(more or less) sense independent of the other.

Paolo

