Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8E51381AF
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 15:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgAKO4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 09:56:05 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39924 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbgAKO4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 09:56:05 -0500
Received: by mail-pf1-f194.google.com with SMTP id q10so2612680pfs.6;
        Sat, 11 Jan 2020 06:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gFENvhdwcTkHMIAMPDZsyyz5lEt5cXETOuhyXZqS3c0=;
        b=kDJvQAJPLRPuHLL7mN6NM+nttQ9oxHbWukjVDHuIJPeBuFbFNRKLNqalbyEbliK6Ga
         YwoDHKFZlEFbLL/kWGtm0OhI6+kegr+EtbHQsglCwGOrXPg2xVkAmzkfkThWOaioYvyM
         fVw8at4QG3x0Mxoj7HGeKPnCer/dGhlUXN6sltECQqMNZ6nsx5PPPH7mstpp1GdYuedQ
         jQjv9mCgsDI1+tngi3Y0jPRLVQMca09qHVSdVejDCrxmOMTiKIaYGcy7b/XQvw5/4/U9
         6yUt/+AAcWlYPFgI9upGZB+zDQCJXfUxy+fy/4B+6N905t/xHOsGnhbRTRoQCsWuSPYR
         favg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gFENvhdwcTkHMIAMPDZsyyz5lEt5cXETOuhyXZqS3c0=;
        b=a7+K8UdGcENVcchpcPxG2bVFAXcuHFLWbTqS+EEA8qV++hVtpsqB5SsmEvmmGPI8ZP
         BunEAl6A6T/qVQ/npZvoOrOfiwIZwTr+LfUQYbfJY36sQ9SU9NSIgFJU7L/KeFo7B3Al
         9PtyRYkwygAikTyjpiq6quG9NEKWv2rL5eS4EvEn7O3gd6pwAZkg3ntA8FT0NNBcM+YY
         sWr7VfomJhDarhyr9uQIZIzUTPjZFWhYTKk3jJjF+P7Wmb8GAnxVbMxBJS7QP4Xh1ZQR
         T4UK36kxBuY7JwNnpSnB/dXxTr+a7w2Pr9udd96bHZiWIO4FbPCwF9vKiC47HvoYiMkU
         d1pw==
X-Gm-Message-State: APjAAAWtA3ejkfgTZ21HKj13d3J11zSVwJ8STmY4JCOXRIjb6fdm1K3S
        Vlc0xMpvRESn8RsluUYfcJzkMZvA
X-Google-Smtp-Source: APXvYqwwISHGv4pE0+31Aii3X6QMz9woGMx1fg3/Nx0+AyTssu5IjLRka6FUshFD5awEF6HIsmwX1Q==
X-Received: by 2002:aa7:800e:: with SMTP id j14mr10948558pfi.174.1578754564407;
        Sat, 11 Jan 2020 06:56:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g16sm6858151pgj.1.2020.01.11.06.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 06:56:04 -0800 (PST)
Subject: Re: [PATCH 5.4 000/165] 5.4.11-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200111094921.347491861@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <eebfd768-9b52-f8c5-55f3-e4204cad956d@roeck-us.net>
Date:   Sat, 11 Jan 2020 06:56:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/20 1:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.11 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Guenter
