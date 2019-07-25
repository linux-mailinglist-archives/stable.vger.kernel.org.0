Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A6974CFF
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391821AbfGYLYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:24:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35704 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391813AbfGYLYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 07:24:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so44382176wmg.0
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 04:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RjbdG3nViJvxOOUD7oJ8kV9hETSbuqoaOubZjfcu3IQ=;
        b=CbhZEc/nPyb0GBbxNOs28Wr9uyj0Ti91oKr5tPI8YmCde7ec703llPOOFdc1/s+7a2
         aLr75RXD7ufpTDAw+XmhSv0ghv9kbvqOdMvNM3lhyK6KjzMyu3RjIRqoAuiw8YSbPDr/
         FqMDAFstzz2PBWZKacGLCb508ZPisLMPexjm30AW3Ryt6lukl576FJ/WB1vasRssbsKF
         c5A5TAhgCvtgs6SstG+DclyFYunNZ+wxRb4qQ/XYQEFuAMCSaAE9HGyoulZKBzstgR4I
         PQEArHKeUvh9wne7kBhgpTC0NPURKQ9CI5l05aGrF3XV/q2MUV4MsZGmMVWXqAAD7Xgl
         u6+Q==
X-Gm-Message-State: APjAAAVf2FMHneDG3qSxCXzXrpxRL+XzgKtAj2SRZzfh2jUOzLAHO+2n
        j2dZ46J1g+PFJKqFywYWuMbByg==
X-Google-Smtp-Source: APXvYqzdtuI6MnxEnBnPgCfGVAMefcNKRGR3/m2Mtw0Ia+Lfly9vb5NT90uj+luQR/pqs+tcN1zdRg==
X-Received: by 2002:a1c:3:: with SMTP id 3mr80318202wma.6.1564053868317;
        Thu, 25 Jul 2019 04:24:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cc23:f353:392:d2ee? ([2001:b07:6468:f312:cc23:f353:392:d2ee])
        by smtp.gmail.com with ESMTPSA id k124sm79155642wmk.47.2019.07.25.04.24.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 04:24:27 -0700 (PDT)
Subject: Re: [PATCH stable-4.19 0/2] KVM: nVMX: guest reset fixes
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190725104645.30642-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b0ca6477-ac1e-bf92-3e3a-902243707f54@redhat.com>
Date:   Thu, 25 Jul 2019 13:24:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725104645.30642-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/07/19 12:46, Vitaly Kuznetsov wrote:
> Few patches were recently marked for stable@ but commits are not
> backportable as-is and require a few tweaks. Here is 4.19 stable backport.
> 
> Jan Kiszka (1):
>   KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
> 
> Paolo Bonzini (1):
>   KVM: nVMX: do not use dangling shadow VMCS after guest reset
> 
>  arch/x86/kvm/vmx.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks Vitaly for helping out.

Paolo
