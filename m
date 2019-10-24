Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B44AE2BCF
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 10:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfJXINk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 04:13:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37535 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438028AbfJXINk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 04:13:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id l21so23998204lje.4
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 01:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u9/8DDTsY1owOJwUdO4H+5QAo6+FNikYDww6h44vcoY=;
        b=v6qwyePvookmXBzw/PzawPnJGFQ2Dl1ZpS9EpDSAkexj825hRJm0/wgn8ncLXqMmCr
         1AhcCI3a0JsI6JWZk4NwI1yYbJjLJKtcQV4rrthJSh2GYonILKSbvLfD14vqlS+REOyf
         7Wr0xG513xMJBoYnZGDKEtWkQehXtAJ2sgwcYgodH6PHV6mTd4TkngM2ZjuczFlLUZMO
         ERSP7Qgc4uDgEd+tI8HYdZq8iCaq0G+WzZmfi3EBW8t/xoWQlh9OCrqkfEDxba8pQWwZ
         3SVn+KmkbdrhFnARXct+vnpCMiLcK4NAWcPZrrZsXZNMpcQY7Z3jMb2dlXEiqjDZEoXw
         yAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u9/8DDTsY1owOJwUdO4H+5QAo6+FNikYDww6h44vcoY=;
        b=Cy3G6erVgXRxJQ7Mnt0GHF/+eC+KtTRHdN79F7sakK+zJmEsCs3gQFq7ZFTwXXiTDg
         BTydLemI6tRvfb6/AU0BoiwO0DJ9lkhHlKQiHkKz9BUF5L2/gpx7pJ+QwrGdZ2k3e8Ik
         18PQnYptOmWAVd3HyX1btcQPu27GyTJKP0Jc9c0obeWVHVlfQ/CGFMJSBdmymZW5w42e
         ib21oOdLxHCR05T8YmMQ+JzWbMQnr/wpWucA+H1xToXOZ39iM53Jcax5EKlXz3f0Jwh4
         +01a+F0PoUfPkrVyVarINl8c9Rl0NJ9oIg/KsrC6AXGeZUaZNogiwC5oJOFEV94DCkK3
         qOeA==
X-Gm-Message-State: APjAAAVhK81o0m/rMRt6r0fI6azXDCa+yQGftBJAK2mOcCiM1DvvcvMu
        FcaStvgdlOxPFpUSOQ82+gGG4sq6aufNFA==
X-Google-Smtp-Source: APXvYqy/jU80ZOOuqfFuw/kVlXNVI/FMxsxq/0bo2NYjdeQHM316iagBA89hS86rCi5cvytpuzM48Q==
X-Received: by 2002:a2e:5354:: with SMTP id t20mr25296201ljd.227.1571904818061;
        Thu, 24 Oct 2019 01:13:38 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:247:6f14:2c7d:a606:ebaa:5539? ([2a00:1fa0:247:6f14:2c7d:a606:ebaa:5539])
        by smtp.gmail.com with ESMTPSA id x5sm14260458lfg.71.2019.10.24.01.13.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 01:13:37 -0700 (PDT)
Subject: Re: [PATCH] MIPS: elf_hwcap: Export microMIPS and vz
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org
Cc:     paul.burton@mips.com, stable@vger.kernel.org
References: <20191023152551.10535-1-jiaxun.yang@flygoat.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <f90e516b-17c5-7e35-a661-6005c159972a@cogentembedded.com>
Date:   Thu, 24 Oct 2019 11:13:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023152551.10535-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 23.10.2019 18:25, Jiaxun Yang wrote:

> After further discussion with userland library develpoer,

    Developer. :-)

> we addressed another two ASEs that can be used runtimely in programs.

    I'm afraid there's no such word "runtimely". It's "at run time" probably...

> Export them in hwcap as well to benefit userspace programs.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: <stable@vger.kernel.org> # 4.4+
[...]

MBR, Sergei
