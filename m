Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5AE2C832
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 15:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfE1N5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 09:57:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42781 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfE1N5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 09:57:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id l2so20356008wrb.9
        for <stable@vger.kernel.org>; Tue, 28 May 2019 06:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RDHAz/uNRTlAuvbMTky/K+5WAqU95asj2GuckNTPrPw=;
        b=O0gwBRLE2bvLTTBgVqV1t6bfn+gpJBngDtl+jkFjACXdyByR9CYsKsTs0CAlRupFvj
         nttTyi6t/YyF4vDKCPEl7IQ1zD6uJwNfcehXxhaYFqwVJ1q55KTyEO0gaZmYv34b9vfx
         Tr9f3h9ysbRZphO/W83Xmcj0upIXOHrd71r+dnEYtV75ZXTDhTh6zFIcfUNtW7yq2tUP
         BDdLGXTFKA8voqgPy0iFH6JhSU88eCV/xHpeP1bD7+LmJwClUBX3VkerJweI2gN+q8tp
         fctvEG/dur8IP3xU3bN4xo5Blz7SimoEz8Go0pIN1HFE8CSrxhz0f8pQVfr6wF+bw+Oq
         QAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RDHAz/uNRTlAuvbMTky/K+5WAqU95asj2GuckNTPrPw=;
        b=M9otGvMqX4yNWC38XUWgNhujeJOPrhJGJE1DktRDdHRMuqDj3AvcMGp1PB/x7eM4qA
         /P7BbvFYgX6gK6o/NDglWBzUkUslkz2XGwgjqZRXmEaoSP4wPExbV/ll1DN4k2aMe7S6
         fuqSNAKxQR+5TjB5qI9WXr/ZdJ/9NhlV90W9fqoaTJ/SMnUYfK126RSBn3vgVD4dNCip
         rAqcorP+w7BA7L/A/IHdjFhgcKktjaHv7UND2PepJWNpB9Nr6yKBz4yJ7Ji64cFzV0IO
         WQXVpCO3ko6wBmNS4LEXvm8CfRF1g6QeEycx2UFOt1zBxgDJW9pVBufBtUpGzqqlhz7g
         kpvg==
X-Gm-Message-State: APjAAAWr21KGzTmeWPODNID3pCON9mOhqzv38sQIGgWp9maHhmJt88dc
        7iHyKd/P5qQ+akKVELg1e4nTUw==
X-Google-Smtp-Source: APXvYqzCRfQOGvbLesnlwSBxQtBXBVcya0Sa9gKp2gOr2HzpoKcdhNtfsct3zZ/Vfwq/Pxu7K+3PkA==
X-Received: by 2002:adf:c601:: with SMTP id n1mr73203219wrg.49.1559051859805;
        Tue, 28 May 2019 06:57:39 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:d562:72eb:4113:d5e7? ([2a01:e35:8b63:dc30:d562:72eb:4113:d5e7])
        by smtp.gmail.com with ESMTPSA id a124sm4034922wmh.3.2019.05.28.06.57.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 06:57:38 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol flush
 regression
To:     stable <stable@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
 <20190505223229.3ujqpwmuefd3wh7b@salvia>
 <4ecbebbb-0a7f-6d45-c2c0-00dee746e573@6wind.com>
 <20190506131605.kapyns6gkyphbea2@salvia>
 <6dea0101-9267-ae20-d317-649f1f550089@6wind.com>
 <20190524092249.7gatc643noc27qzp@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6ad87483-711a-f205-8986-2217dab828d0@6wind.com>
Date:   Tue, 28 May 2019 15:57:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524092249.7gatc643noc27qzp@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 24/05/2019 à 11:22, Pablo Neira Ayuso a écrit :
> On Mon, May 20, 2019 at 10:35:07AM +0200, Nicolas Dichtel wrote:
>> Le 06/05/2019 à 15:16, Pablo Neira Ayuso a écrit :
>>> On Mon, May 06, 2019 at 10:49:52AM +0200, Nicolas Dichtel wrote:
>> [snip]
>>>> Is it possible to queue this for stable?
>>>
>>> Sure, as soon as this hits Linus' tree.
>>>
>> FYI, it's now in Linus tree:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8e608982022
> 
> Please, send an email requesting this to stable@vger.kernel.org and
> keep me on CC.
This is a request to backport the upstream commit f8e608982022 ("netfilter:
ctnetlink: Resolve conntrack L3-protocol flush regression") in stable trees.


Thank you,
Nicolas

> 
> I'll ACK it.
> 
> Thanks.
> 
