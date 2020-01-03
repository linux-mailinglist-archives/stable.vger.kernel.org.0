Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D972012F91E
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 15:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgACOVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 09:21:15 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52787 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbgACOVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 09:21:15 -0500
Received: by mail-pj1-f67.google.com with SMTP id a6so4665452pjh.2;
        Fri, 03 Jan 2020 06:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U8+hrz1yYNsqd7H6wypQtO4rY7xgJUJr6HYJI5HVygM=;
        b=AwriWlMEwHGJQMZ3ctPoOPOAUejdeH5YRlKLAo/N5fWozY3eJ6ndyQKRqYWogORpmR
         wUADWrLpEYnP076heeJs2jNMT+vofCezA2fTb105cfApvsKy1j7vuirhFj3z5FQr0DFe
         Cpf8uvKGF93XNIMpFvpdoVooI+mzkknm+BrtOX8mWGFSC8dtbA0ircKsWHJ1EOKbIVZl
         +w7ot0YOX++t7Yl4/LbjWKRrjY7WZMSvMOU3IBF+OvY7/D9NgRUc5zXjl7KDA0AMVwt6
         kkY4PKqY91NmD0h5AX568t+4hNFzdM0JOrxf0JtAq1fNgtld7x56kZ8qcaorizXEDXJx
         FKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U8+hrz1yYNsqd7H6wypQtO4rY7xgJUJr6HYJI5HVygM=;
        b=CnXD3MWPZ7UN98IBrVqyWI5wTaPFWGVW2lKlXQrfDJ80l4H1jEJiobS/nSO0tpL5+8
         oO7f8V0Al1MhWV0jQNe4I/Vhi6DD1lvreckZLJNuDGoccDRUSdIOeYunQPsb1to68G5c
         3fWLQu55KU0QuRUzfdvdk3QCo9wLIjHRpYUhOJVs/CGUqbMeIF+wb9yU9YUPX5er9d0y
         2YrMiAT+rHMb3QYzG8Z8GO/INwsUsxkH64b/pWKJ1iFeJwfKPlJvYTf+dU5117re8RGm
         dh1ixIOH/xxH6KDJ2Qiuw1oW5is8FWpP4lXf3R/wpGzH63ncE5ZqmtbCgSBHJ/k7Sj5w
         eZZg==
X-Gm-Message-State: APjAAAXoqkyQPISDK872h5vFFWoQS4pSpgdmzS+cfxXq7Gl70F1Aa3mB
        NLy35Ifr+9/bxbGPyZRbDgHGvG3+
X-Google-Smtp-Source: APXvYqwJseT2ZP/Y8WcToVpoI/t1qlFlHo4fwRjzwZdZllD+09Wvrgy3/RVbkrMhI/0oVL5iskZecw==
X-Received: by 2002:a17:902:a58b:: with SMTP id az11mr92010273plb.147.1578061274807;
        Fri, 03 Jan 2020 06:21:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m71sm15101199pje.0.2020.01.03.06.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 06:21:14 -0800 (PST)
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200102215829.911231638@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <74cea7d2-7a95-76a1-bff8-94ed36151f13@roeck-us.net>
Date:   Fri, 3 Jan 2020 06:21:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 2:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 385 pass: 385 fail: 0

Guenter
