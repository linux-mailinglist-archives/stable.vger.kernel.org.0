Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7924F61FF8
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 16:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbfGHOB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 10:01:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43619 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbfGHOB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 10:01:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so7663850pfg.10
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 07:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ru93OrCqoNyiaVfi1TlJTSGjvxdsyzldWNy2voNhj0Q=;
        b=KIPhjLfSe9201vY7vemZeG53qruJ/2dwExr1eyAREYdNmjLg+yp+EfTGMQMlFjHteG
         gWeylDcvI+MtNP2MqSVD6QDkcT4NFwd+CQBZRqVHvciNNYEwZJ+WNoJSyYfCzCMFIoMs
         RCcXlnNFTB4ojBQu6EsKB8VbbR3eU4LlfgkS9aPL6g/yTXRyO08miueIh9yRZi/JjLWz
         VaathuJjbF1vGDokn9p06orV7mAs+xc3BNqb0Ds8WITqD/vpufVuiKs5zgiHVr99Ca1Q
         GQVD/SRHexW5WSwAwBC9tRd3fhfw3HeDzp9gvIEwC2fSt67IyOPt7/FDGmz8v+6+4Vya
         9hnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ru93OrCqoNyiaVfi1TlJTSGjvxdsyzldWNy2voNhj0Q=;
        b=D1LVnN+Gmylm76iE+jgaDhFBDcBbzOoO8IIAKzSgGzSksSokaJ7h00CjN4PHfhsAeB
         YLD9WFgbZYSmezQGif5VboxcVj8jnNTelTB9XDgoot2w8Yl7MqC9ZjTWkW+NBjtrWeDi
         mtdWtRACsGspK4OGKZkGpi1HjZx1hmBaDvf7cqTQ3BHBmfvIQvmqgsTGIKuKRnvBFPMc
         XXdUpLQLa5ksBU3f6AqwOwQ/lzholKdJcxEzix+RlfABaM/CPemVQTmqk4D/CFUQfLZD
         XzQwOvlybajI7xIdv6NTxTtExQhPNFb+s5bejgaJXa3jmTSHN+JvBloD49A4cYXGsGvz
         jNTg==
X-Gm-Message-State: APjAAAWyKjjr87aKMqbHzbYMz9OVuA/MP4Gke+gnB3QDB6+K923pfp3U
        Tm0pfNMq4Pa0ZU6+A3kUWIZu9x+1
X-Google-Smtp-Source: APXvYqyOaToJ2+IxNaTCstaGfLo6pMvGkbrSBpkraTJsVHSuMkaXKJfYW2ZTps2DCvI0Ush6Q868aQ==
X-Received: by 2002:a63:7e17:: with SMTP id z23mr22863721pgc.14.1562594516902;
        Mon, 08 Jul 2019 07:01:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b6sm16678192pgq.26.2019.07.08.07.01.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 07:01:56 -0700 (PDT)
Subject: Re: Build failures in v4.4.y.queue, v4.9.queue
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <1d749d61-a489-11e2-bb6b-21408e1057ff@roeck-us.net>
 <20190708135519.GA2900@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1bb7fdb7-0ad5-6ef9-53d5-1e089fa4e2d0@roeck-us.net>
Date:   Mon, 8 Jul 2019 07:01:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708135519.GA2900@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/8/19 6:55 AM, Greg Kroah-Hartman wrote:
> On Mon, Jul 08, 2019 at 06:21:31AM -0700, Guenter Roeck wrote:
>> Various cris builds:
>>
>> init/built-in.o: In function `repair_env_string':
>> main.c:(.init.text+0x106): undefined reference to `abort'
>> arch/cris/mm/built-in.o: In function `do_page_fault':
>> (.text+0x44e): undefined reference to `abort'
>> arch/cris/mm/built-in.o: In function `mem_init':
>> (.init.text+0x12): undefined reference to `abort'
>> arch/cris/arch-v10/kernel/built-in.o: In function `cris_request_io_interface':
>> (.text+0x219e): undefined reference to `abort'
>> arch/cris/arch-v10/kernel/built-in.o: In function `cris_free_io_interface':
>> (.text+0x2644): undefined reference to `abort'
>> kernel/built-in.o:(.text+0x416): more undefined references to `abort' follow
>>
>> Caused by commit commit b068c10cde7f3e ("bug.h: work around GCC PR82365 in BUG()").
>> Reverting it fixes the problem. I would suggest to undo the cris specific changes
>> in that backport. An alternative would be for me to stop build-testing for the
>> architecture if there is no further interest in keeping it alive for older branches.
> 
> Odd, why doesn't that trigger in mainline?
> 
> Oh, cris is gone upstream, that makes sense.  I'll just go drop that
> hunk from the patches so that things keep building.
> 

It builds in v4.14.y.queue, so I assume there must be additional context patches
making it work. Tracking those down didn't seem to be worth the effort.

Guenter
