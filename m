Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8857E2CA220
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 13:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgLAMJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 07:09:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbgLAMJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 07:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606824460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXfc/kqkacP1UiqS7nvKt7QqE8tU45M98d6kX6CKfRY=;
        b=dGQXU55HFWtwAM1XWDqS48zAdfz+Q9yNytlel86KShSs25y049xBYDVKXn+q/hz5h75Xw9
        Y0kZBbn7HMPk4K7bojIeLldJPO2ra/DNsCeUdb2wFWsShQCtzKeRRKzd+TnUT0pJmwWYXT
        1jTtHcNSzJlfNQprsG2EYj4A8glXVtw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-1EZSgYHuPoiv3Lp5P53Ryw-1; Tue, 01 Dec 2020 07:07:38 -0500
X-MC-Unique: 1EZSgYHuPoiv3Lp5P53Ryw-1
Received: by mail-ed1-f72.google.com with SMTP id f19so1106454edq.20
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 04:07:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PXfc/kqkacP1UiqS7nvKt7QqE8tU45M98d6kX6CKfRY=;
        b=daL/rTGjvdGmdBbtweeVRJCfChFOeyASFhiNeggPnBagKi6XBov6XcUGvq8F1EZh75
         l4MU5NZnkastiqNR2qcplcHvxNX2OLGEBmoFZqX50lKXclkrCq114LjenJG/bRoJY03O
         BCT/c42B9AhRlGpYlqrphm9tptnhgbOlF/clccHZAzMkhRtG4hnJcTZufzXDPRH1s190
         2bDmRpYWvbKvJViK+OmbktZxtyZqn5+EjLFapQT75hvuaQ09ssIonkf3FokYs6QHUspu
         DJeLXbIbbe0kj/yK7Ftc5x4J+6+TuMRxwcSLI9ufBlMHbI9vFhnTV7t2D0ItHiNUeenj
         FdSQ==
X-Gm-Message-State: AOAM530LnxH/uxa3TV8J7x990Up27Tlyak0FIGITo+C0PUgvOClQieZK
        A3+L82LnJDaZpxaMAcsZuXLIWfrdKxakV7D8+bFY1C1/c3gBp/bWyabkY4yu0b0YlTQmFvJodkh
        Tp53W0QovAvZpoRIu
X-Received: by 2002:aa7:c403:: with SMTP id j3mr2619821edq.217.1606824457752;
        Tue, 01 Dec 2020 04:07:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1DxtyPC6a1zqrYWrdj42DEWp1B5nUpOxzqYzTrKSPNVvFKMo0ahsqcxwarIESgnaxjNMXjQ==
X-Received: by 2002:aa7:c403:: with SMTP id j3mr2619797edq.217.1606824457604;
        Tue, 01 Dec 2020 04:07:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u19sm750026ejg.16.2020.12.01.04.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 04:07:36 -0800 (PST)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Nikos Tsironis <ntsironis@arrikto.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org>
 <d29c4b25-33f6-8d99-7a45-8f4e06f5ade6@redhat.com>
 <X8YThgeaonYhB6zi@kroah.com>
 <fe3fa32b-fc84-9e81-80e0-cb19889fc042@redhat.com>
 <X8YY2qW3RQqzmmBl@kroah.com>
 <d3311713-013b-003c-248b-22ebf1e45c7c@redhat.com>
 <X8YlUlSXLH5/RckV@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
Message-ID: <41931e4a-45a5-5ef2-317d-a2a5ae649357@redhat.com>
Date:   Tue, 1 Dec 2020 13:07:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8YlUlSXLH5/RckV@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/12/20 12:13, Greg Kroah-Hartman wrote:
> If you look at the section onhttps://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> that starts with "Additionally, some patches..." it will show that you
> can add "#" comments on the cc: stable line to let me know pre-requsite
> commits if you know them, and want to do that in the future.

Yeah, I guess that one applies even if it was submitted in the same pull 
request.  I have used it in the past but not for patches that were 
submitted in the same pull request, so in this case I should have marked 
patch 2 like this:

Cc: stable@vger.kernel.org # 4.4.x: 123456: kvm: patch 1 in the series
Cc: stable@vger.kernel.org # 4.4.x

instead of marking both patches with just "Cc: stable".  Upstream commit 
fcb3a1ab79904d54499db77017793ccca665eb7e is one case in which Rafael did 
this.

Paolo

