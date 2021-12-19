Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B447A0B9
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 14:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbhLSNxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 08:53:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234475AbhLSNxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 08:53:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639921992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6y4s59fRDhRXZ+MFWbqd48C+ut3PapB8I0wNJafkmy8=;
        b=Dh6A97MN4jEPXiJoa7bWXbaDTJ5cX6mQjOpJqc5c+N3fL3Kk3sgurLrHiFAZJYqWkyKvI1
        zZ5rrsBwDX4pZf8yUFJbndIcUZ38hYOcpbNMnC7gMtMapgNZ8JVPAVGFoB8E/Py+E2xzD+
        RBZFIsLJ8CPTxZqtJHGFm7O0p/SpzH0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368--UIWnGR4NfqaPTaPdt_5Vw-1; Sun, 19 Dec 2021 08:53:11 -0500
X-MC-Unique: -UIWnGR4NfqaPTaPdt_5Vw-1
Received: by mail-wr1-f69.google.com with SMTP id v6-20020adfa1c6000000b001a26d0c3e32so1207325wrv.14
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 05:53:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6y4s59fRDhRXZ+MFWbqd48C+ut3PapB8I0wNJafkmy8=;
        b=hRDQ3jiOPFbF3iJfqtLGSoYwAjPXaOcvBQoirQ1hhC8U6sreU4cYRvJ70aSpmsvZYf
         1bgyvv3OhPWnu4nPSi5qojjV7FoRZ/PLS1LlG5wRfhxoJ0HcphwRYbQsoi5xSImG0zKq
         7qaABT8QUDfQNGdDkuZRIl7FN56UXx/pil2+KdH2xfASKjXbigljlp55xpte3T7lhUOi
         i92QfRUlBUIz3+S97xrjHht1Mqu794aPZ03gjdK/fkTieg1cmo+rTsJC8XmL8YbEAAZy
         1bcjWU1pIVmI2axEhOHVqvWa2b60PvlsOfN37dVtxFvsNOPiH6zILVQdssCHDWJjkA3e
         rsvA==
X-Gm-Message-State: AOAM530j8Za5TiAI+qE2TuJsd/aQ3RlooomqIzdlTveZBPkFOlPlTM2V
        Z9SPqTFmx06RGSKefMjnFR6AvkOdLoPMJvSXBzpSQQyf3hz/jhLK+j+c5Ntz7ldFRqTIYL8TCKd
        tvHuKEUOyVot5EnGD
X-Received: by 2002:adf:9004:: with SMTP id h4mr9692858wrh.593.1639921990365;
        Sun, 19 Dec 2021 05:53:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyypGLj1tKxFj+LSvvFpiaauxTLO+snS8pEJl5hCgc9MrMvK2mCfttd2iYEcvhftK55oUc5Fw==
X-Received: by 2002:adf:9004:: with SMTP id h4mr9692849wrh.593.1639921990179;
        Sun, 19 Dec 2021 05:53:10 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.41])
        by smtp.googlemail.com with ESMTPSA id w17sm14564116wmc.14.2021.12.19.05.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 05:53:09 -0800 (PST)
Message-ID: <54749944-d33d-8364-ad17-6297abf883f5@redhat.com>
Date:   Sun, 19 Dec 2021 14:49:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [regression] kvm: Kernel OOPS in vmx.c when starting a kvm VM
 since v5.15.7
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>, kvm@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     doc@lame.org
References: <f1ea22d3-cff8-406a-ad6a-cb8e0124a9b4@leemhuis.info>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f1ea22d3-cff8-406a-ad6a-cb8e0124a9b4@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/21 06:01, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> TWIMC, I stumbled on a bug report from George Shearer about a KVM
> problem I couldn't find any further discussions about, that's why I'm
> forwarding it manually here.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=215351
> 
> George, BTW: if reverting the change you suspect doesn't help, please
> consider doing a bisection to find the culprit.

This should be fixed by commit e90e51d5f01d.  I'll send it to 
stable@vger.kernel.org.

Thanks,

Paolo

