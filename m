Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49D9EFFA6
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 15:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfKEOZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 09:25:49 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37723 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbfKEOZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 09:25:48 -0500
Received: by mail-pg1-f195.google.com with SMTP id z24so9762214pgu.4;
        Tue, 05 Nov 2019 06:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5EgGi10+FNufFnXShlw/r3jkB00ye3VHRPspoxEUf0k=;
        b=NJl6DEWloBzYv8XhZrIQ073j93gY0/X/ffzJGOyPUVqQiEepzoSwbNvcWa8m+m0/53
         B5+kfGNV8yowZG6j9+hNqha1dPzGCROTxsnPpAPhDxGomFmbN0tsrJ5X70FQHjIJ3YeI
         1U2PC6P1RTi67A84dFZuSBg+OWFUmPNqjJ70DkKvsUiTwsCfLpXdvrPelRaMb6rrnV/x
         zDNpAuUioZFq5+l0XlbYfqK0yBEqKhztRNacWMfdqirS8B2BqSiY+sj0UaSm0iZrEwUM
         pTGTXsbm8/PcUAjZCE6mxAlQ0RwGKAs5oAnhS+xMeO3nosDsWU+uZis0CjutMo7wHMGV
         qK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5EgGi10+FNufFnXShlw/r3jkB00ye3VHRPspoxEUf0k=;
        b=nLJw9d07SqsueQn9SQXX3Wa/6x4b/Knuh6TW3ou/R/zx2zDQKYHK6wn0Q+OnATPQR3
         iiyFqBcC7CmzzEYKbOU39o+ABCja9wp5DtUW8gIe0Clxrxo/4UiWgZNjD2REGnyLTieI
         Nj0nMYwS1GXZrEeARNPCZkhbCobx5pZnlyawQzIrpBd27s5XexMYSvjpXIvDci1IhcI+
         abeT6iWnFL3dRe9+IeZS0VBl2/LoTJgK2S0OIGkMQ6YJHCzfuYbxgIzwU2vBG4KfPe/q
         G8pJyId1cQvRDHPZzMjp5JaX8uTCocuAL8+brWeYABygAc0KSfy2ZsJ/uHz/AOEUVUK9
         ArHg==
X-Gm-Message-State: APjAAAVJeyK5eSzQ5bcRL8HQPtwYuk9okAMym3RMK0OyWqXm+PqZkXrN
        0bSWho0qfET2KjI8pY7eSnIlWKkH
X-Google-Smtp-Source: APXvYqyf059a+RsJAi98b1LI4W1wp7OFw+CXG2tqTBX5XeN5/2fH9ZezIDuJKb4jACYNsKhG6PFJ9w==
X-Received: by 2002:a17:90a:f982:: with SMTP id cq2mr7074437pjb.34.1572963947737;
        Tue, 05 Nov 2019 06:25:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d139sm32935432pfd.162.2019.11.05.06.25.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 06:25:47 -0800 (PST)
Subject: Re: [PATCH 4.19 000/149] 4.19.82-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191104212126.090054740@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8716681d-1abc-4b07-7224-884bff06a4c5@roeck-us.net>
Date:   Tue, 5 Nov 2019 06:25:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/19 1:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.82 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
