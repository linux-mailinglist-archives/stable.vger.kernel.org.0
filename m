Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF696CE54A
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfJGOcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:32:21 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42711 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfJGOcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:32:21 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so8770019pff.9;
        Mon, 07 Oct 2019 07:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=av7WK3nWwWqHdotmTQajvEKheic3cbI0jZ+/KYmjCsg=;
        b=qvQMexDsYNyJubfoxwfxMWod3Se1uMPnLxL4pf5JJagcneS/nMHS+QiAVMPOeFkZ7D
         699YlTCTXQ4Z5e6NZFPth2ltmkSDclDoaJlYQyxu/EwL1kqugneJTmCK7PCJu3HUPyHD
         iJvVp5yTjs86lN/ilblgJ8kmtqNRdD+aUOj4ju5cWP8B9doeeBEcUgLO9ErSMkYPoahw
         FxynkED+rXXCMo68lzKN1ysMs0BZp/GL/YgiYcnZbN7wMffLblM4IX2P0KfF1kJkvmBD
         A05pGEGMS7LRQgwZKvM/d9a3f3J9G2F2pPMZ5KFL5M7mJRRWV/M4UmbIs0e6Rc08Qyyf
         Fl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=av7WK3nWwWqHdotmTQajvEKheic3cbI0jZ+/KYmjCsg=;
        b=fjckMc0ueN8Tw2sj876B7550VNUivZE6faTS/fl6eywVY0OvLC/u9ce7ZR8a2GnmEs
         DiNJci2vrM7mq0e6sYjz76YbN+K5j3C97NSMaPxUpzNxVBid1WE7Sw7EE6YQ+TglYDD/
         tpx7b7xeIq9It3wAGqnWNFAprOGJLvyviCcoGuHaUtihO8vNkmlabjINYlHC5C9+wZQ2
         hTYKCbUl3gHS0kWJPKNN3GNrPhkHVviqAF2SAx9rTngcNu77ajrR7e67+2erX9uAiOcx
         pRi1VnPw+9zydwvdZ0WqoZON43ACjbx53BqnkRGoAf76h9weRoSTNCGxnlM43L41hKBn
         in9g==
X-Gm-Message-State: APjAAAU0iI0BzKweaGJ0PmDXFt98mSFYuMALwjzDloOfONLbN6JzFQ0I
        7Ju3PY9F4/7xhgWw/RDJ31JRAcLy
X-Google-Smtp-Source: APXvYqwpI8lJvsxGNpQw0NNHcLkLTLhEH1MgPHFrM01nwcz2cGdYVbVmR6W5JgBe5vNKBFUj/WqmFg==
X-Received: by 2002:a17:90a:1996:: with SMTP id 22mr34695321pji.17.1570458740687;
        Mon, 07 Oct 2019 07:32:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y4sm12513684pga.60.2019.10.07.07.32.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 07:32:20 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/68] 4.14.148-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171108.150129403@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <caf3e229-4a45-7ce2-a6e0-4eb8095202f4@roeck-us.net>
Date:   Mon, 7 Oct 2019 07:32:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/6/19 10:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.148 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
