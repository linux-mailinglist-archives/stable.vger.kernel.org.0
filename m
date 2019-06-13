Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586CB4391F
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732804AbfFMPLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:11:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35324 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732294AbfFMPLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 11:11:37 -0400
Received: by mail-pg1-f196.google.com with SMTP id s27so11134547pgl.2;
        Thu, 13 Jun 2019 08:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j6uLYgb9QUdzdOV+EOdPf7OIqvEJL4woU3/ylFU7b/E=;
        b=AUUE0h4mfwO+9oLPVlcfntVXYuJjpD/YvgN/OCriJDEhw6YWT9XSyFNOpC6eVIGC/X
         EzOUR7LqN+yMEDzKNgyRFJ13yD8V/WiPtupw1/OhZBuvumEn2A0tPD7ZJimwBNnlJvez
         loJQbFqwUbtO2IqiajTQU0I7EGYDI1WPRayuKt1LXPUPda3QO3ctpwahDc/bj9U4EDrK
         5O+2yzU3fC/ajDh92fJpVU608LH//GJKBoIT84FJcYuiBh+szce99d70cDvaz3jOh7BH
         zOPuOQ+xZt0AyplE7XzElpcSur9TZTmasyswP2RWEBQfAQWOustFJzoj9CjcQsIJXztn
         dA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6uLYgb9QUdzdOV+EOdPf7OIqvEJL4woU3/ylFU7b/E=;
        b=TW2Qrdj28KEJzmKiBX+wvDbDJJGD//+31nts9/kZwGwah8AN8tix3jzFHh3lU/400e
         O+jOgfiaPqH7SibfIrGRZmq5uWlTNqN94snZiNYnjNjQBX4W5KVLyF3caelpWYpdrCB5
         STuyDF1qWWCu6qRZipPFuPHwJ+vyc1t2KcL+J1bXK1ytlgMvAEM3sqkOFdRluIWXTM/e
         8xlFUYLRLse3Fch0q0IwM2qCFB0tsRDsM0pT41wwB6EOnqgC/U1ARFMnpIJRyf8078IO
         t09qkn6qI+V0OC2MtkYv7ENR0gjAKiDGZqfy2nkOtC15KKgbl/9mPtVDvCjxkBbgUceK
         yZIQ==
X-Gm-Message-State: APjAAAUgU4rCkR21/shgtwrm2v3UPl+Tl0EUQ4qhT8F47vSVN7XwIlxn
        Vez7GumMH+HV+9cGpHeznUOeFkY8
X-Google-Smtp-Source: APXvYqyoOI8zf5byMPkbdIwPwjTQvGI4rR/4FIYmFfGEuz1rg6rJfAIcEmG/zEHXT2m8mYaSrsFR8A==
X-Received: by 2002:a63:3381:: with SMTP id z123mr1470380pgz.164.1560438696218;
        Thu, 13 Jun 2019 08:11:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d5sm22655pfn.25.2019.06.13.08.11.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 08:11:35 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/81] 4.14.126-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190613075649.074682929@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1139f9d4-1a0a-b422-276d-546e7cb1bc85@roeck-us.net>
Date:   Thu, 13 Jun 2019 08:11:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/19 1:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.126 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:51 AM UTC.
> Anything received after that time might be too late.
> 

[early feedback]

Building mips:nlm_xlp_defconfig ... failed (and other mips builds)
--------------
Error log:
/opt/buildbot/slave/stable-queue-4.14/build/arch/mips/kernel/prom.c: In function 'early_init_dt_add_memory_arch':
/opt/buildbot/slave/stable-queue-4.14/build/arch/mips/kernel/prom.c:44:14: error: 'PHYS_ADDR_MAX' undeclared

The problem affects v4.14.y and all earlier branches.
PHYS_ADDR_MAX is indeed undeclared in those branches. It was introduced
with commit 1c4bc43ddfd52 ("mm/memblock: introduce PHYS_ADDR_MAX").

Guenter
