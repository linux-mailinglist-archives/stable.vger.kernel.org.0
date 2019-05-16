Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A213A1FE2B
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 05:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfEPDd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 23:33:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35942 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEPDd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 23:33:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id v80so1065986pfa.3;
        Wed, 15 May 2019 20:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UmIyH2QV58g1wQQu0RtCCr57U2+OV0nzDo73nB2SjmE=;
        b=Cy15sJVSIYHQ9on7MHoCA7KMpNvts5xSBVOpBswhRHuBsG2Of0IuvfO7FM+fSjd3M5
         yRM7CvG3bAKYQZ4VaDva7JKi8WCgQKG0Z2uS7R+JIV+YBwBAYPMb07PRHUWYKS9EYnAj
         XXq4acq7butPZfTu0mG3TlolqqVsa2UmPcNQeMUuijvezP6hF+WPUahebwVOeO0+THq9
         uaoz9YY4GX7B0/roOlX7R/tLjq+X4Wmuopj3ztcEcLepJ6HZp0Ltli7D9VcWrfaiiDZ3
         zvz7k2CgU/ih7CYGwxT97/xA44iJztOYn2lFikr9UjXVAScRR0fZHN2xwbnsQM9IX7kb
         Lz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UmIyH2QV58g1wQQu0RtCCr57U2+OV0nzDo73nB2SjmE=;
        b=OzMXQHGbkMkIjl4b9WEC04n5/aFmcSdhQ4CYa/+cMhk8D7FGq+fl6JHrvXwEdQ/U+o
         tiDG9c1AML3d1n1Nnmv21I+jXs4gqW/SCLDMDuo3g6Ui79ycFqvbe8PCE0tl2fCYosXc
         jhQXrpxHWhWZra3VUHiFhzV4cZNp6gevRnGMAPqidl8d/PePNKXqixRrPy6mAXSFlyRX
         f7XrqPygw0Hoq0SkVBVguQ6vCwNGPOqwCSLLMbLo8eVnPF8FD6r7AgYA2mh2/l6NmxYJ
         e1b3OFUschDq2yrCJWTgHS38KDkh4s8oGk3EdA/ekLH8HwkEzdDYpNid2rXIQgnfVeSD
         m32A==
X-Gm-Message-State: APjAAAX7su89xOgRejBlL9F/CA9Xf0aF0RZiznRe2ECrETsCrKPkkg/0
        iF4Si3w++Vr+/LkaOByNeMrCFxa7
X-Google-Smtp-Source: APXvYqyzJoRi5B2ScdZGgiTS19l+uV1hAg8VafNDJqbM1r/Te9FZ2qlzgGCqCj8kZYcOF6fHl01zDg==
X-Received: by 2002:a62:4d03:: with SMTP id a3mr52577940pfb.2.1557977606187;
        Wed, 15 May 2019 20:33:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x16sm4305212pff.30.2019.05.15.20.33.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 20:33:25 -0700 (PDT)
Subject: Re: [PATCH 3.18 00/86] 3.18.140-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190515090642.339346723@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <eb52b96d-0d34-9c59-5cfe-a3170cdba1d0@roeck-us.net>
Date:   Wed, 15 May 2019 20:33:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 3:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.18.140 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:45 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 230 pass: 230 fail: 0

Guenter
