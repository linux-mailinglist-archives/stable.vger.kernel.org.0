Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEDD169B28
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 01:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgBXASs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 19:18:48 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44048 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgBXASs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Feb 2020 19:18:48 -0500
Received: by mail-pf1-f196.google.com with SMTP id y5so4407502pfb.11;
        Sun, 23 Feb 2020 16:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=msaxM/XYb5vFcTfJ0attyQX0gh6Xc8mYm1sTKVy4Bvo=;
        b=XCiWRv5pqhub4Zq9DgvECdVcaY+RMsw4m0kP6/uzSQSpreY3h1aHKUg9xj8kFoYDI+
         njQxr6g7HbZQqjKkwPJjR5Mb28OxBGw1i5eSmK6Mb4QgcxdgyiIGsyVu9G0+onTVlCnZ
         A/MRXk91uxk/fIoOGozREJ90R5cEgqu1CyNAOJFId4DivzeidcZFyTF9NTSuyY35RTj+
         BWFcbhmw69N87WiYcd5JK3ec4+XqgR/H1N+9jw4e+jlK3/FQDUTBWL2M697PHxLKCbNO
         LUIj0CL0xcoFG1Z68U9zI72aa6i92xpKb0QPp4O+tm4DTUG3SMLskb6kCtFZjnV0kSli
         AIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=msaxM/XYb5vFcTfJ0attyQX0gh6Xc8mYm1sTKVy4Bvo=;
        b=AQFjxLCQfeLgS8OnJTEolFm1mCZglABANHK+RYUzI/HtW2PXM2d9VnQ6Pr8X5Y6P2t
         j95Y9RHMA427YfcscRNB14wqzlPq2B6TamBDOXmkoIED1Yinq1rZreAZgQJn2nICYB2Y
         lln6MOrTnEr2tHVUTxgy8ZK1c78R++CAoJit777ucLPulWXSMwzzulBYwE1aHSiNy1R7
         BJTKSg2/EspGR69r5/x+6dmd7pxs/wMoQthZimfa0qNZ1zjRyIPrR1pBkECUDDhdP5JK
         Y5YrYED/fDZ5yWbotpX00yslUG9+ygWFJh0aG/ZW/E8C+Yf0jSEFzNc6+G/JJ2rHiRIo
         CqrA==
X-Gm-Message-State: APjAAAXhw5Xw2aF/YzGt/UEIgJ8x4+BNA3gHksOwu9ToutYTLNv6jcXb
        /nUQs7cNGAMd05jWzRBDBHH2xFRM
X-Google-Smtp-Source: APXvYqz3CRInoTcpCH+GilHY34/ZKsxnyeBWc3HuUaPGtMAkIIdes0hndC0oKLwehAX3fDf12NlnyA==
X-Received: by 2002:a63:be09:: with SMTP id l9mr28439399pgf.439.1582503527747;
        Sun, 23 Feb 2020 16:18:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g18sm10146124pfi.80.2020.02.23.16.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 16:18:47 -0800 (PST)
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200221072402.315346745@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <f0283e80-9f30-9c17-579f-91e3d5d66a04@roeck-us.net>
Date:   Sun, 23 Feb 2020 16:18:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/20 11:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.6 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 

For v5.5.5-393-g8ba99698af46:

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 416 pass: 416 fail: 0

Guenter
