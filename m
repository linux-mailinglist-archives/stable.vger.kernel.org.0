Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5464F2D4
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 02:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfFVAnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 20:43:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32815 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFVAnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 20:43:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so3774774plo.0;
        Fri, 21 Jun 2019 17:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v+macD4yTxAIwzLigxcQw2TAJJDPNJw4mVS21N5VxcA=;
        b=kRJ1m24+fQ48uvdVz6jVcX9BUwHyKTxWPHFXGS8a/On4jEiNyyYVMMy82+EWAd+bZL
         7fMyqrqYp5t0KyPeYuKKA8yD5PvQt/NmNvXnQcI1AFtsDZFn/QQ2jwhQMAe0EUVgzFIr
         DUsu1m324wg8i4fNLjAdqTeqD5qgYERJgbtc2uxv7A10cf6zulp073mbbtNxxc8iHUaY
         z1Xv/PJbj4+heM3SAaSnon0cr/hFx051dVq0Q7xKGHs87breI6Bq6LwgzYFz1tYVdQsC
         3oEwKeWP1uiOdz6lbPyqcZm56WcYjwXL/lm+l/Cp2l8jNP46cA6Be8MCU3bdFuW8Zl3G
         ty8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v+macD4yTxAIwzLigxcQw2TAJJDPNJw4mVS21N5VxcA=;
        b=BuozbI/I/COQiaJYkjzC4CtMKoMeFsX9WoHBiIGa/MpflCCM20To8PG+oKgxbSDN1o
         g/RVkzG6K031lTI0JgBOAMHjw1UbYJjA6ZIrl+SLgkbT/48FETC0qE0lFRucu6IsI8Ip
         PQWYSHwyqfGcwSTjoE+XDjlW6WKWfEDnrsFVRiNF/nNjnU2SN26KaIfGU7R8Kw2garxP
         blMNvRgcwd3BoRbKDWx4JEacm21F1/SL1K9Zrm5wO9+l26IXWyPEORhskkj5Kdx/Grbg
         9nySgh2tEMbf76dcgFP1pEoCQhSg2la2K6CaxEgXG3V+khEXRGuPsn/sraEJdMhowi4A
         Jorw==
X-Gm-Message-State: APjAAAW7NCytESDMTtcFLN6fALxeuAduDdGSatnUi/HtVtR7n5UsTHEW
        PQhB1U3f0w2iwJ1lMYYMUQ0Y4HJJ
X-Google-Smtp-Source: APXvYqzoUavooEfNUIUK3XYJQKn2kAVzE2ChTQ6iG/9VqWekXuwfmfD9tVFg7tiISzdgV02F741ODw==
X-Received: by 2002:a17:902:8649:: with SMTP id y9mr56741687plt.289.1561164211029;
        Fri, 21 Jun 2019 17:43:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p27sm4917761pfq.136.2019.06.21.17.43.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:43:29 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/84] 4.4.183-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190620174337.538228162@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b581efee-d8a8-c354-5497-663499ed2dc0@roeck-us.net>
Date:   Fri, 21 Jun 2019 17:43:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/19 10:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.183 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 307 pass: 307 fail: 0

Guenter
