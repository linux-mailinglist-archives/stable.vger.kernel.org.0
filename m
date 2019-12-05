Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E4311425D
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 15:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfLEONK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 09:13:10 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36593 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbfLEONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 09:13:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id k20so1314004pls.3;
        Thu, 05 Dec 2019 06:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RZcEOEoQ1Ughn8KOzfbOlCCz29dtJuXQaobrI9mJRBw=;
        b=FQfQxT8+gKQj+Awe8Hw4NIKGLR1uxBFtWD55Xjn1CYo2z0kcmkjx9xSVUf4k08inow
         wPQBaXHMIhEjslVYKtLfPdloDcgggQwNPATVrUKuDjsO1noH2MwGwIvYShoQ6cOS0ei0
         xYgaKRkLM+JvZAq0ERfSip3umvjQnscVn7RaA+MTbMfVeYk82xttHPbOdv1m6P+gF0+C
         t8GdKRpumrD7Q5/k6GeqCqGmOoRlIlyTa684SgSzOq/ZqeZfN2xO435D4UDUbBsW9/ys
         wODlQuX+BrNythZ9KsSmYJ/+y2fjugcWXj4AHGP1wRw3UoQmv5wi5xf1FPDIFT2VMlF3
         7H3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZcEOEoQ1Ughn8KOzfbOlCCz29dtJuXQaobrI9mJRBw=;
        b=hjrs2MmtNNo9AePKMQ1iToC72kppxleiiQKfu+F34Uo3BLfsvJh9yoPXZFivRQOHD/
         6jmkVJ9tSczh90YniqA206WZ8QKD9sPUXk95DZnsMd44tcTfuMUrusFCSx/bnLU1Ycyd
         JO+mx1n6gCVEsjU2lvaazyy0a1nkTyfF8xhvHRn2sZrgmJn6dx8YQcOqnZI/strP2Co0
         GJB2XPTyizU4hIN0WglvZO/b10tWsUiuw+YfHLz0fj2XuNW4mykRRXMh/Dc7gPmLqspm
         bOXjefvtOZ1iMJ4q7Gj1xSlbXucRqqIzQ6RX8oNM5bFbkCpB8HvMJJeKSsJeKovaAZSy
         +HPw==
X-Gm-Message-State: APjAAAXmMYnnXPCACnarf0hw/WBKi7BGZK72kZD90v0ANC7BuLz+Eep3
        fR0VnH/juKqYPEpQXrdKdCex+nEB
X-Google-Smtp-Source: APXvYqx8lDEbgIIM10bc3y/R0Za1zxoiEKGmnvdlFtS/74zoXG09XIqBWXUWUDJ9z/tPxiRnB8yWNw==
X-Received: by 2002:a17:902:a516:: with SMTP id s22mr9028956plq.295.1575555189484;
        Thu, 05 Dec 2019 06:13:09 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gc1sm10367539pjb.20.2019.12.05.06.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 06:13:08 -0800 (PST)
Subject: Re: [PATCH 4.4 00/92] 4.4.206-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191204174327.215426506@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <483c712b-40a9-4ae8-b4a9-c650634f720b@roeck-us.net>
Date:   Thu, 5 Dec 2019 06:13:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/19 9:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.206 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Dec 2019 17:42:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
