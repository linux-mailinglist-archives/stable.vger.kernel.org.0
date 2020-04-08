Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8EC1A2782
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 18:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgDHQue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 12:50:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44064 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730446AbgDHQud (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 12:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586364632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GEFzxGugHwTrvuv37BPHzwDk2hATRin4OSCD/6R76Ww=;
        b=OiTj39r5z7xrxeFMoBreWjFbu/G9iskbPS3B8ZDE2Ngy6lyG/QyYKZMI5nAAOQk7BF+KCr
        7JkGOx35dy432PXIexQV1JtGsA8n2Dr+4Wy8OPz3ewzaWEbQlY4EatFK1Q+52MEtYHVTQ2
        gI8Ni2pCH0I0FpQqMuG2i8gYA/SfjEE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-4bzAbdqdPqeugIqpG1EdeQ-1; Wed, 08 Apr 2020 12:50:26 -0400
X-MC-Unique: 4bzAbdqdPqeugIqpG1EdeQ-1
Received: by mail-wr1-f71.google.com with SMTP id m15so4680672wrb.0
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 09:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GEFzxGugHwTrvuv37BPHzwDk2hATRin4OSCD/6R76Ww=;
        b=oVokhd/cgKRM1aqrkSkn/J59J5G4f6KJOZqOek2WgpPK0dmhBAZKIRAjTrLk1hqi2I
         7lm/TC4bDhmy2E5B7fx8FETYZVZPsCF/+qhmBxFERxBzAgTNIpi06KpHAd2jhRdc6cbG
         V3/dkmsCsHKTT8W6iTBOsuDV4tRALmLm3sekpDt31DNbJ7LaMzG0+/eglSbYnDcLrKdN
         yDcGR1a1/5wJeyt6JVgzoK0fx5NjTLugb7Oln5NnOTjVzupVgqAv8H2WdvbMYl++gFZh
         blHlFtnUSVXw8bCMRjGYF5rTEj+UG7/GG8AQ1aq9omqlZ5BmoqWLpCuJYX33WuCmkPp8
         DaEA==
X-Gm-Message-State: AGi0PuaG3BqdjSo1YwmO3AMT8Lh680Qjk2dryFdIVNVEsVipr3AKyRY0
        UfSAJ96Sic7VCqRYjfcAOjyxnjipak21JM25A1pJ5zzIU439rILe2POUkZhjWBqRGca5rx+dMlo
        TYMetOLZu9nlhCNV+
X-Received: by 2002:a5d:4649:: with SMTP id j9mr10108924wrs.71.1586364625096;
        Wed, 08 Apr 2020 09:50:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypIfCXLt0kF7cyjpECu6nvaYx1McBhi3w+mzdWBDI5wsboGKzNwv/AeI5PDPDHt+4X21+78plA==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr10108883wrs.71.1586364624737;
        Wed, 08 Apr 2020 09:50:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c71:ae6b:ee1c:2d9e? ([2001:b07:6468:f312:9c71:ae6b:ee1c:2d9e])
        by smtp.gmail.com with ESMTPSA id b82sm193680wmh.1.2020.04.08.09.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 09:50:24 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
Date:   Wed, 8 Apr 2020 18:50:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200408153413.GA11322@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/04/20 17:34, Sean Christopherson wrote:
> On Wed, Apr 08, 2020 at 10:23:58AM +0200, Paolo Bonzini wrote:
>> Page-not-present async page faults are almost a perfect match for the
>> hardware use of #VE (and it might even be possible to let the processor
>> deliver the exceptions).
> 
> My "async" page fault knowledge is limited, but if the desired behavior is
> to reflect a fault into the guest for select EPT Violations, then yes,
> enabling EPT Violation #VEs in hardware is doable.  The big gotcha is that
> KVM needs to set the suppress #VE bit for all EPTEs when allocating a new
> MMU page, otherwise not-present faults on zero-initialized EPTEs will get
> reflected.
> 
> Attached a patch that does the prep work in the MMU.  The VMX usage would be:
> 
> 	kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);
> 
> when EPT Violation #VEs are enabled.  It's 64-bit only as it uses stosq to
> initialize EPTEs.  32-bit could also be supported by doing memcpy() from
> a static page.

The complication is that (at least according to the current ABI) we
would not want #VE to kick if the guest currently has IF=0 (and possibly
CPL=0).  But the ABI is not set in stone, and anyway the #VE protocol is
a decent one and worth using as a base for whatever PV protocol we design.

Paolo

