Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02022268A7
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 18:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfEVQxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 12:53:01 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38060 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbfEVQxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 12:53:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id b76so1633932pfb.5
        for <stable@vger.kernel.org>; Wed, 22 May 2019 09:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ypcYEpjp0khfSVcB1kWAVjJU1oMEQIieG1l4bfT2yUw=;
        b=UarX8JMsGKc0sFN2r3gaxWT6A3bWxpk7jMhsI2GKdKIP3+/0cWADfjkJU4PitQw/a1
         Ls6CDn3hhMUKLb6BPQe185/NaM4WafeGRPzvCeUl966lgr6M+EWWg/NhnHgUYChP3JjX
         kwLua1qvdlISz4YhQ6udy1wkuBl9G51h5STIlBod+3wZlVFvKjrjSto95risdkHMsFC0
         xh7bcmAsEQmO2Q+5CULLaDPTtDzMA5Rp87+/KBvoBIlM10aNeLYyzjxDBefZ4XuMzlGS
         9fnkeuURfeG7i/1B8X8iBjIGs+k5r0cGCq2JBaKIWx9snpAQj487juu4qirlFBVrcnS5
         7DLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ypcYEpjp0khfSVcB1kWAVjJU1oMEQIieG1l4bfT2yUw=;
        b=W4w524la8jfChH7CP/NIr5rQlLNrsqG+dpUxY5WEwp3PotQhHuo0Ai2LQykWg/+kab
         Q5DPzwiUMrs/obTwA94EJWm/sbKkkDq+4K0dHSkcgneGIqEEGh7YLCFqWATe+HX9n4AN
         0Hv73jtP55adQIvwBCOzFl/Vq5+ytEuZ4UUZuXpsRCHKy7KsvNyIhBiXA56eVNewLe2a
         aRpLHUt4q4zjD7BDxrXGxfDITDnxdBEmKsnj9TAvLt5c7ILXTfcdwEELYQ4cGxrePOJm
         CgKMc0a2xo09LGhwgKgkc531X/KRamRh6kCANrumcdqiM8lEnLU9h2JJuU5MzRWDHf2p
         8MyQ==
X-Gm-Message-State: APjAAAUI9KnfRFhulqm9Agz1TFspvyiBlljAoNeMPVsn2ZrsVoOQ09Nz
        Bq7UIKTve65syUXu0FBpUOVANqad
X-Google-Smtp-Source: APXvYqxtWjILogMfcQu/GuISNyJdOhtHaUldLdf6NeqGrevfvGaM/MLldBcplXPRwyWWNy6e8wn5gg==
X-Received: by 2002:a65:608a:: with SMTP id t10mr90196352pgu.155.1558543979989;
        Wed, 22 May 2019 09:52:59 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f892:82c5:66c:c52c? ([2601:282:800:fd80:f892:82c5:66c:c52c])
        by smtp.googlemail.com with ESMTPSA id f29sm60627836pfq.11.2019.05.22.09.52.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 09:52:58 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] ipv6: prevent possible fib6 leaks" failed
 to apply to 4.14-stable tree
To:     gregkh@linuxfoundation.org, edumazet@google.com,
        davem@davemloft.net, kafai@fb.com, syzkaller@googlegroups.com,
        weiwan@google.com
Cc:     stable@vger.kernel.org
References: <155854389617965@kroah.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <84edd412-c07d-28be-1723-a4727ae2ea56@gmail.com>
Date:   Wed, 22 May 2019 10:52:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <155854389617965@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/22/19 10:51 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

As I recall it only needs to go back to 4.17.

