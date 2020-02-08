Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C115681C
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 00:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgBHXKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 18:10:31 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46807 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbgBHXKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 18:10:31 -0500
Received: by mail-pl1-f194.google.com with SMTP id y8so1241947pll.13;
        Sat, 08 Feb 2020 15:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NCcMx70teoQiOg6LUVBh4OLmpwuahCWUkU/QQ+wXF6s=;
        b=l9wXAntFWNcNJWAoEFD3Xktnr+U2gj1vgPpcpFW3Vw0ikC4QHoPswGso03ku6ikmPJ
         iiia93HuD96zXGiGhfWge5wiekvQJOOdIHobgebRM4AZrY6qAPnB3aMH/iLpy/+tLNIZ
         l0j1phCrlBalDNxKms3NZJILeI7d8jQOXGrOA7rnxDLPnhW0neI4AOilDK4AUe77zLyg
         rsdEIV8lyKZ57nN95I9KjdY5a6Y1T2f9au8IswfBbgN6uQuNOXOPkk4hOUBe02IdMFns
         yH3ojkwLh5PL7oNnTPIwtBk7QK8gVZfNOLF14Zmp8BuYj0+kAVP9V9co/QGPQGvvqKmF
         xhvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NCcMx70teoQiOg6LUVBh4OLmpwuahCWUkU/QQ+wXF6s=;
        b=c95TwcGDdy82exC35TvDEMRu32INGEp36OSU+aqjaY/iyKj86NDtomtSBieEJbCaYF
         vKDkgnDaifjzUHFiriWmIxu5EeulZ/kJe01n1+AqnrXotZu6Lnz9R/g8DTKRcFzI5INb
         abiYQscQs1WF2d+Je7e1kXcCIpFfxWsNwbmAVtZ1iQXhBthnR9liuAl5bVkmLHlUVuzW
         mu9UBhRTEq9VAfuBv2XSPoQuiy6hnm9aHBshfwQnNF0CLoSvIVI5FyrUn6zgf5OVMJeW
         oiVkoESnLwxM0shVBzF1FDEt7nWc6vdHHRYEMqBCbhXBbkrOzUHt0yGkqx2WlW77EkWn
         Zn3w==
X-Gm-Message-State: APjAAAUggBuF2kBqtHnAh5qDo5p+z9ylUlFzsgRLkAFNL0xVJsCvKfj0
        BqwvSKcLyFh3dXOIO9Q4PH4=
X-Google-Smtp-Source: APXvYqwLyRUAiXEZrLb3Y5cq44xcaY3CMeCZg149Pb1FP/qNvTIm6I/S8Hsvfouca2X/cwE+8wwY5Q==
X-Received: by 2002:a17:902:ba93:: with SMTP id k19mr5948228pls.197.1581203429472;
        Sat, 08 Feb 2020 15:10:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m128sm7337462pfm.183.2020.02.08.15.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 15:10:28 -0800 (PST)
Subject: Re: [PATCH 3.16 000/148] 3.16.82-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
References: <lsq.1581185939.857586636@decadent.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <60c66967-afb5-a1a5-0c16-af212aa49465@roeck-us.net>
Date:   Sat, 8 Feb 2020 15:10:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/8/20 10:18 AM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.82 release.
> There are 148 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Feb 11 20:00:00 UTC 2020.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 227 pass: 227 fail: 0

Guenter
