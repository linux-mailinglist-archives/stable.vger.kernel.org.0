Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA7FF6010
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 16:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfKIPj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 10:39:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38783 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbfKIPj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 10:39:28 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so6133646pgh.5;
        Sat, 09 Nov 2019 07:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KWzuU9z/vEKIxU8p66qUaLH2GrI3EdHq0Df1UC2xjm4=;
        b=IT9Sn20Lh0yesB0A08IjHcKN0A/ft/etalDsn4/M8EP/mtjbvZHrv8/UHI8KaFeYuB
         98XqVqZ8//Ha0daCIY7CRf4tPcBuqcM8UvppqE43G4RSLyqpa5CJRUFmnHxBMnGWHjyN
         4I4qa9aFaIphTXU+M3E1hbAy0rPaYSaGqVlm7xu8zpZ/TCywNGyyEZabqvUOkxOkwIvl
         wWVVmOQrQI31MQTAefIq2uq7N2MG5STsTceoeelgeIROdnpymEh5wtMQ42nDg3wKv5X9
         yUNiZu0OgU1HCTcWme2hupzlaG68wBSplHNswHEN4sK4CZ6qimfeTVR1DzpHute3F4B9
         BkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KWzuU9z/vEKIxU8p66qUaLH2GrI3EdHq0Df1UC2xjm4=;
        b=e+HwdRXDcR0szPOHcCeN4kgO4LVKxtrHPz4r7pcJYkeNNgS7FOqGnTMu9AKMOzXK9S
         9ULTjGC/dO9gvLqiKjUZCFhuudkoyxG7gMbF7HZ3/LWmgkHgrtknxg/qYghKyv4TIcUx
         3VhXLylHXbdcZ6dHwL2d53d18Y9VrWXYZ8616gehqHlc1Js1KXCtPX/G/r3WYZFRhIpO
         PviA2x9YIm6NBjHAw+hH4/KK2cWab//6cIVRYKndGarA35B5QLxG1U4LEjMScxvex90o
         jyjVCcsxBsPTTrihqUZjtNGK3fHN3lQrT4QJanQRMQGE2xQBfKORCfkeDTl7bWt2WXyI
         9UzQ==
X-Gm-Message-State: APjAAAUUHRIY8o9XToWpLaVhhQsYyajxGoI87HO4+uGYRk1998y73MMU
        UlbWXtDg8+DM+EogMCGe6aqaKDVB
X-Google-Smtp-Source: APXvYqzM7FofbpO7Kkd78hiabwvIgJtaNgq6ALcp92ul+XGqBW6qEglX00gC8xwtawwTO6GhSvVOqg==
X-Received: by 2002:a62:7796:: with SMTP id s144mr18664277pfc.37.1573313968013;
        Sat, 09 Nov 2019 07:39:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b26sm9914666pfo.158.2019.11.09.07.39.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 07:39:27 -0800 (PST)
Subject: Re: [PATCH 4.9 00/34] 4.9.200-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191108174618.266472504@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4f43c737-72f8-efe7-b9a3-c9d03c45196e@roeck-us.net>
Date:   Sat, 9 Nov 2019 07:39:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/19 10:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.200 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
