Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA3F10CCB0
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfK1QVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:21:48 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44451 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1QVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:21:48 -0500
Received: by mail-oi1-f196.google.com with SMTP id s71so23691286oih.11;
        Thu, 28 Nov 2019 08:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ROLFe53saAFC47gBos/sXEaQxo/HwRqEwLRCW7ni3J8=;
        b=K2oqZIAkJXv7Kec1vaw7bJeixMFCkbNzp3tFpH8iIjHS8/qaVHF9mZZDAnjaaCq6MI
         0OkKIE6ohvM6Fkqv4Lx3dLzLxUdY1rXAGCpa2+5iL17nVhnZdGQa8brJkuHpmfwPkEfr
         ihz3Doh3hYYd5RMaLjGD87y+HVgtqG5dPm2mpOsBZ0z3IomYla7pzNSbRQ94M3HUWT62
         CtpcDmhNiLg32jKbYwls19Kdlg/26dEMrIenV1C1A3A8r2hNaDqClSviBaoRK4xC2LVp
         ZRFJv7s7qLrkj9LsvU3/c/9wKyp/1JOj2wh0LHOSHKROlZoh4R5pAPi13dBJo+ILaypa
         ngWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ROLFe53saAFC47gBos/sXEaQxo/HwRqEwLRCW7ni3J8=;
        b=lc847OigZiIFvydC0wMQZbQqRYRo/iYRPi+IZWN8PFgTwQUmmYE2XINjdS9xNkLIzF
         OO86uNlTxLPSpxXhUBtNdbs2wRl7IHMvFDGf9LEyNyv/LIMS4/8RV6KcXcILLopEOpml
         lngKY24hjAE+sxeHKws4GAL49ytGFDJDdqAHQNgvQlLKGuzyEb9c849a7rZmW242K4/q
         9bJGx90nkwBNePwTFFvbKin5e5wwEJFH0WPIJBWHBsGKEITfAYs4eY1JBVaJ6AixOy29
         HpjeoIxBC11iq5QTbXsJaZIfi5sbe9OqoQOkW7qyYsKQTV8/0I1C4bcZ3ANvKEqXNJCn
         PvHw==
X-Gm-Message-State: APjAAAVrLV0bXDzKKV1oh/FYzw12XealQUlcND82uErEgS24mxQHuFZV
        yKbWRhTGbZ2MJ16111Gu1cnnvJZa
X-Google-Smtp-Source: APXvYqyneXmDfPlBUP6GChNm4UjPunM+fMpOrqQFGu4Ys9isyJ61rp9p/e0OrZohEtXRKeOn5G1pfw==
X-Received: by 2002:a05:6808:ab4:: with SMTP id r20mr9293834oij.166.1574958107081;
        Thu, 28 Nov 2019 08:21:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 202sm6281526oii.39.2019.11.28.08.21.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 08:21:46 -0800 (PST)
Subject: Re: [PATCH 5.3 00/95] 5.3.14-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191127202845.651587549@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b1e94ecb-ff95-489f-73bf-e579c7f81b73@roeck-us.net>
Date:   Thu, 28 Nov 2019 08:21:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 12:31 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.14 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
