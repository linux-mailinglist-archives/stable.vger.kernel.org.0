Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C7C67C34
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 00:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfGMWDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 18:03:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37666 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbfGMWDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 18:03:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so6451216plr.4;
        Sat, 13 Jul 2019 15:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5w54gVlwlcQ2bynC44gyRnaULScT04VVjWvEfAe5cPw=;
        b=XJ8EJiGFJQykC0NGGlUACEnLvAin6s72tUzIu31fgFBrQojgiaD8eT6TU7LBgFkhGK
         Y94xUp0xtmSIflbwjhAVhWSpawVrtIaeVvuUfwAFriJksb3cmiXjkPT69vqnirCWuSoS
         iqRUJIuWQ5w1WiISqcECwPVLla3WCHcK+mKtTmlqfVtgZ7ktBsn37PHssRW6k5cA63vG
         8UXpPRaIROzskDEl1Pl7jaUakvPG+xN/jFdbC9ngQtbREJw2q8tq49avIDimtJH6/1tu
         4akvDvq4YOjYsdgK/x+B91M5M3qhhZsehLnvJgJC+r2jysmyoogQs3VmHnYLcp4rnTUG
         51FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5w54gVlwlcQ2bynC44gyRnaULScT04VVjWvEfAe5cPw=;
        b=jDgDBBkTBIdq3fXiVrVNPvnhsYSI257gJLi8VkFtYuwXRniHS1mz28RX3kSOixyMFR
         mACSyh4d2IWbTmGIQp7NJmWxHTLbTc2IYmL8hxtAnsvIiClrUYDKy4fIqBv7270NtNyI
         0xn9gxfSU//OpRw5JVTsPMIu1BJnl3CWGEAdaUNwglSOb4o0V5teWsMj9k5WeoceA3aJ
         jgZjATTqFauY3QMTXoi1M6yb7fjZXUNTuNLhahIB2lkGxE8GZ4UTEl9Qfe44UiyGG+oF
         VNW5CulBgVWVLIrf2QDfHWHo4lVx256PQiAD/eb9RWKDoK3716NJ0/o5dpOb28b11jIC
         QLyA==
X-Gm-Message-State: APjAAAUERc+ORla7xyuRMApHLc8omkB2FyRL2DHxTqYFC9snTQzOj7QW
        ee29KNVcQIo9d9po3V2TW+RTBCG2
X-Google-Smtp-Source: APXvYqyz40vUjl2K6LvlfysI+xNzCPhx+mw8uDN4SNQQWw2FZ0AXSyN5zz3ZUnPizy3zihmIxEILYw==
X-Received: by 2002:a17:902:8c98:: with SMTP id t24mr20265659plo.320.1563055413757;
        Sat, 13 Jul 2019 15:03:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y22sm15105759pfo.39.2019.07.13.15.03.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 15:03:32 -0700 (PDT)
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190712121628.731888964@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <cc4c0a5b-0aae-431b-4ee7-dc267c5310ed@roeck-us.net>
Date:   Sat, 13 Jul 2019 15:03:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/19 5:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.18 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 

For v5.1.17-134-gd68c746af314:

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
