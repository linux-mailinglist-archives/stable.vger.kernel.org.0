Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181184391DA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhJYJBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 05:01:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232371AbhJYJBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 05:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635152350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzTYvmR+Baxf4vvutXG9y4UJh2DkglRXKqKaxVfskag=;
        b=VuGkDbgFL0RGyvNjrAxqVvc2yiy+d78WfAGs/ngA6u6/gXWmYvIkCiygsdzXwn7ITlKnfE
        ekMkeHOoEk5AaZkBWwjBaEuIIDPx7V0fjoeij9SDwz5CzdzTJneF68jNPgT7uZ7D7fz/pK
        28OmnNgkPOXQKic86VVPG13pK4pBMvE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-Ous8Q5sZM1GaOhmoJOHd9A-1; Mon, 25 Oct 2021 04:59:09 -0400
X-MC-Unique: Ous8Q5sZM1GaOhmoJOHd9A-1
Received: by mail-ed1-f71.google.com with SMTP id g6-20020a056402424600b003dd2b85563bso6525971edb.7
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OzTYvmR+Baxf4vvutXG9y4UJh2DkglRXKqKaxVfskag=;
        b=Rec+P5sOzApHTE/bxd9AgPPUyniH7mXTi3KbaClTRHgxr4H43dd7ApyGx4HsmzJTIq
         YI41b9OSDjIEMwuClG6F9EFDeBDui+JdTolQiQOFKrDq7dOCPfIgUOeSeTCCJb5GXGLO
         3hE+kAODeHFWl2HUqfEdyBw2GxEljbhU/9SsZijwcml4nhy3zw7gAEv1bifwmQPoPoxD
         YDH6HssfM9wHhsXja6gsD/+qmi6GC1xe95sdJtyz+5zJvVvvdbGNF2YA2Qz/F0vMS7XU
         +Jn57tX25lgL+pav+sZoM6hVLW+WCjrSElu7mNcymi0oPYHcuJQi/4QUtfQR4XYI0AKD
         B3oA==
X-Gm-Message-State: AOAM532kb4f5YPHEqS0ZNIlQJAAISRUPTkQbwcNEf8uUuNciN02sGk7o
        iTMeuu3w/4tccxLk66XtA5QnYeGkTPk8ugEIhLGsbu+oKUeOgrym5BsTOuPczZn73nuU2jLNMZH
        9mplLOpG0Z6LSqcGp
X-Received: by 2002:a17:907:7f11:: with SMTP id qf17mr10287103ejc.437.1635152348474;
        Mon, 25 Oct 2021 01:59:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkmP22ASf0et7zE/OEQYMrGgdxDWBcd2eTY+zIf1qIM2FQEJlIVcKFfdA+RQYOcmccNWPBtw==
X-Received: by 2002:a17:907:7f11:: with SMTP id qf17mr10287084ejc.437.1635152348257;
        Mon, 25 Oct 2021 01:59:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id he14sm3901907ejc.34.2021.10.25.01.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 01:59:07 -0700 (PDT)
Message-ID: <707a0a5d-413e-b80d-89be-17bfca8fc44c@redhat.com>
Date:   Mon, 25 Oct 2021 10:59:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/8] KVM: SEV-ES: fix length of string I/O
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
References: <20211013165616.19846-1-pbonzini@redhat.com>
 <20211013165616.19846-2-pbonzini@redhat.com>
 <CAA03e5F8qvkbnPNvDHjrnM1hLs2fu5L_Mxtuhi3T5Y7u+_ydrw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAA03e5F8qvkbnPNvDHjrnM1hLs2fu5L_Mxtuhi3T5Y7u+_ydrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/21 03:31, Marc Orr wrote:
> I could be missing something, but I'm pretty sure that this is wrong.
> The GHCB spec says that `exit_info_2` is the `rep` count. Not the
> string length.
> 
> For example, given a `rep outsw` instruction, with `ECX` set to `8`,
> the rep count written into `SW_EXITINFO2` should be eight x86 words
> (i.e., 16 bytes) and the IO size should be one x86 word (i.e., 2
> bytes). In other words, the code was correct before this patch. This
> patch is incorrectly dividing the rep count by the IO size, causing
> the string IO to be truncated.

Then what's wrong is _also_ the call to setup_vmgexit_scratch, because 
that one definitely expects bytes:

                 scratch_va = kzalloc(len, GFP_KERNEL_ACCOUNT);

Paolo

