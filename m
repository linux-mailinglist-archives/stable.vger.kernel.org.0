Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EEC5153DF
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 20:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380100AbiD2Snc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 14:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377444AbiD2Snb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 14:43:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78EC627D;
        Fri, 29 Apr 2022 11:40:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id k27so10022106edk.4;
        Fri, 29 Apr 2022 11:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mnSEQFOJN2GT/ZAH6oJe8b7uE3bkbU1pdEJmyyDCypU=;
        b=YaRTsZdersFKBk1HjsvKXK2BWufL+FyYpSPvVA8fPYc0gzYrUQ7R3XckGfG5vzTfkE
         e8ZjWsviOJwl6fzERV2itgaUNPw0LrPuucLvtGUpdO4RyV5q63hUf7JwYDRSCS9r6ZnD
         z1/1soUqfnE9sQOYD886eXIZqwMkHpsXkoDvpAhd7vuufx8F8ZtyRujoF8a7dz1/4pbg
         iMM04PoeROXdEnz8pbWKm52DIIcQkwzFgpgMoW5uDwlv/fKGX+H4dR19CPK7UPtl7yPf
         dfzj5j4N1EbDgMBk5k+5rPI6rcYKSPtE7OJnT3YvcD7d/BjvTTIVnvV8DBjz7GPSly+Q
         RDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mnSEQFOJN2GT/ZAH6oJe8b7uE3bkbU1pdEJmyyDCypU=;
        b=095l44qmMpG/sOgR27LrquUEi6rjkUpOS4pYOpoROJoRso1FpL32xdpsE8TKFa4Ck1
         ru+W3zwobZrN/ZEYQClcotvqgCKmfDb2qR4m+29+WvJfTGQDQe5/qbzvWALqwgLXiCZG
         TjIrhrZTQGjWJt5sASK1rDuUD20RoupKynop0gFUEtT3KVThD6laYhzG5PBx7V33SV0Q
         +goSqKsJz4XLmzKTDTOTKJvuw8zQeXFQ/b7bCP6CONs9xQE5/Mpo1SyUkd2BZlr+Q9hr
         We0kblrni/BLaKFoNivVFLTk4PBlZAp4P8zAKQnGe6wKws/WQKl+ilCN73g30aONi73l
         N04A==
X-Gm-Message-State: AOAM5314I3v32cG0G3kcbFmGLJ3tJDU6+Xrvc/GeZANCpNhukyag2joR
        5N262SbDBOadZWcEfDdQPNc=
X-Google-Smtp-Source: ABdhPJyNfOwR7GW+nWHp9Ieh+kwlDNBFDmCITFq/xV5/LieqANSp2b+lGKUeWT2yEhQNWOm5Rcf1UA==
X-Received: by 2002:a50:9986:0:b0:413:bbdd:d5a1 with SMTP id m6-20020a509986000000b00413bbddd5a1mr636363edb.26.1651257608134;
        Fri, 29 Apr 2022 11:40:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id w25-20020a170907271900b006f3ef214dd6sm878115ejk.60.2022.04.29.11.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 11:40:07 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <91d20901-8ab2-2b8f-3453-b86907e5acfc@redhat.com>
Date:   Fri, 29 Apr 2022 20:40:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/3] KVM: x86: make vendor code check for all nested
 events
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
References: <20220427173758.517087-1-pbonzini@redhat.com>
 <20220427173758.517087-2-pbonzini@redhat.com>
 <f38141478fa37ddff287b48c146261fe7d878379.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f38141478fa37ddff287b48c146261fe7d878379.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/22 22:40, Maxim Levitsky wrote:
> 
> Wasn't able to test on my intel laptop, I am getting out of sudden in qemu:
> 
> 'cpuid_data is full, no space for cpuid(eax:0x8000001d,ecx:0x3e)'

Sending a patch soon, it's a QEMU bug that we have to work around.

Paolo
