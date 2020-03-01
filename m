Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E82174ED7
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 19:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgCASHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 13:07:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54986 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726359AbgCASHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Mar 2020 13:07:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583086059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ig5r6fSee1QFqpemi9CPBFpYi2TpDI3RfRjEQ272n0A=;
        b=EAn+GQgiT26H8PjQEQMecxDA0PPtY49T9/guEMmNdyc7UGdeRysysXdM/tnpRg+7D4qtDz
        nxfOPJzzycO9xQ8CpfEyEDZVP4OzSWdjkSi4r0gfSn3Cf8EzG8zKnEX18t1z2cprcPyF43
        PPpaUNarM6tUmB8/mbghvfwZlWe2VmU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-usNR3zxuNzeFHMqJglzGWw-1; Sun, 01 Mar 2020 13:07:38 -0500
X-MC-Unique: usNR3zxuNzeFHMqJglzGWw-1
Received: by mail-wr1-f72.google.com with SMTP id o9so4564547wrw.14
        for <stable@vger.kernel.org>; Sun, 01 Mar 2020 10:07:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ig5r6fSee1QFqpemi9CPBFpYi2TpDI3RfRjEQ272n0A=;
        b=RiP781ZsntxbKmVpf3vMXRelt24RvisQU2FNgTEEBFsOAdLkUQjb02J4WzFsy2+ytF
         kFy1vQObnpNDmGW5WpoDjLxl0A8+8IuyJ+BHnXcnRZKlzIvzEZ8E97PpT64cdKuJjugc
         dJdsCS1wBorqwtqkI3q64gcmVmAtt3BRFliOQl+zL7aY0DXPzA+bLBoS1c5KMftNZB8v
         vlRLYqXp5EK0AOQdkhcrCERyGhsXRPY0IcOgodNtee0ag4T/9e65kSuEpRKGcB48ENbW
         SCJe6mZiLxKZXp2TbCPiPRPRQbidAFkLeYxHnBtLLNYH1fCp5xXsWsSkm8LqYGixVudT
         KMjg==
X-Gm-Message-State: APjAAAX8ovSw/X0chEYvbiGlyEQC34VEjnvmooHHymeKPFiFDkKRRELI
        ElP9fyt1qFiYa5vZ6JT0FidxxS8EUTy26QTyjFqsUorNQEAeUDX6OuptK7EEaULZt1ig1G2DPJz
        4TzrN8qLp7Be/FtkH
X-Received: by 2002:a5d:6b88:: with SMTP id n8mr17730698wrx.288.1583086057407;
        Sun, 01 Mar 2020 10:07:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqzWQcsoqWwtOc8xPBJfQgT3wZlKw7dK/uhojpnVEhO1zcAxRwvH4xUK4ugn/tWYxOmPIiIxsQ==
X-Received: by 2002:a5d:6b88:: with SMTP id n8mr17730676wrx.288.1583086057125;
        Sun, 01 Mar 2020 10:07:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e1d9:d940:4798:2d81? ([2001:b07:6468:f312:e1d9:d940:4798:2d81])
        by smtp.gmail.com with ESMTPSA id v131sm12318867wme.23.2020.03.01.10.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 10:07:36 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: check descriptor table exits on instruction
 emulation
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@web.de>, stable@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
 <20200229193014.106806-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <33933412-384e-1131-77b1-1a91118a8a8b@redhat.com>
Date:   Sun, 1 Mar 2020 19:07:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200229193014.106806-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/02/20 20:30, Oliver Upton wrote:
> KVM emulates UMIP on hardware that doesn't support it by setting the
> 'descriptor table exiting' VM-execution control and performing
> instruction emulation. When running nested, this emulation is broken as
> KVM refuses to emulate L2 instructions by default.
> 
> Correct this regression by allowing the emulation of descriptor table
> instructions if L1 hasn't requested 'descriptor table exiting'.
> 
> Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
> Reported-by: Jan Kiszka <jan.kiszka@web.de>
> Cc: stable@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 63aaf44edd1f..e718b4c9455f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7204,6 +7204,17 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>  	case x86_intercept_outs:
>  		return vmx_check_intercept_io(vcpu, info);
>  
> +	case x86_intercept_lgdt:
> +	case x86_intercept_lidt:
> +	case x86_intercept_lldt:
> +	case x86_intercept_ltr:
> +	case x86_intercept_sgdt:
> +	case x86_intercept_sidt:
> +	case x86_intercept_sldt:
> +	case x86_intercept_str:
> +		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
> +			return X86EMUL_CONTINUE;
> +
>  	/* TODO: check more intercepts... */
>  	default:
>  		break;
> 

Queued, thanks.

Paolo

