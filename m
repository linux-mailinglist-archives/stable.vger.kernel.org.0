Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D88ED1FE38
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 05:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEPDiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 23:38:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42529 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfEPDiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 23:38:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id 145so818759pgg.9;
        Wed, 15 May 2019 20:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Bu85xa+oGpfKWUXTTWhVK7NPT1VZHocCH7WbLlHTUY=;
        b=oS/zhVxqKSTumhxK+DyJ4eGRqdPp4KE5Th57CWQNTAQ5xXjwmP3e3QisW0hx5cO8VP
         cWg94efqHn/7nS6Zk/nAF0UzqXg8Jzu7G5UEiXLIaBwLRQsxcG7pWnTGF8um/1x2t4Hp
         4k6/btGYtPblEdvGot1phoQgfERw3hqPJ3uV7kyGbtp6lllfBS+zHYZyBYYA4jXdFa9n
         CR624VQGBMohj6dbORLvvnfc7kv8j4ctjXWfwLlllhkgPaQzpB8X+uJjB3r2ldVBQJNQ
         ZnSQ28V0FT1HLSBvNnsK8OBPbl4Uhi7vz+UaPmGKIB446o8ap8aNth4z5PkGtVmNBUJT
         vvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Bu85xa+oGpfKWUXTTWhVK7NPT1VZHocCH7WbLlHTUY=;
        b=W8c2tciNuyqXsCPxCocHtfOPxGuQufVgnAFdVgcV+ktk4lcGyBux//zknyzn7zn1qt
         scbIiO2gXM+moorHfJcsql0fpdQ1rF165rl2QhBR/k1oS7koawALAbGpwlfmF46txiTP
         KUtI+t6NYWOZQ0wIv4cYB0CTJDSzrCtwH+heWqRAV7H1dhNhxTJJyrBsCMp6igADQwT8
         cuYQsZkyOY+rgQrySM0fJ7LcGCQcDljsHR1H573aEtJdzTraJlYoweFASCR39liC4QXV
         tZPXgCOweC5PV4N0fP0yEcEnlKiYsxjvOWCuFbH6kvfSmu7v62j/UKqC/pPOXH6HNfHr
         3P4g==
X-Gm-Message-State: APjAAAVE1zwzEwL+hSuJ8sEQD5mKrzgqYWnt57C9s4bWNpgda1OJKwUH
        zUkdlNdABvBf8RPkeq6mrBR4KczK
X-Google-Smtp-Source: APXvYqxfxH6juT+VApES0GFlg2umrioBPUq1wWs23ySsl6+dq3VHssGTdqcGCny1jNQJUlQ8a3mDLA==
X-Received: by 2002:a63:1048:: with SMTP id 8mr47654856pgq.70.1557977889806;
        Wed, 15 May 2019 20:38:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j19sm4790490pfr.155.2019.05.15.20.38.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 20:38:09 -0700 (PDT)
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190515090616.670410738@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <f3eeb4bb-8ef3-ebf1-839e-6a9ac85d7335@roeck-us.net>
Date:   Wed, 15 May 2019 20:38:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 3:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.3 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
