Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904C891034
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 13:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbfHQLT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 07:19:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45599 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfHQLT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 07:19:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so4231089pgp.12;
        Sat, 17 Aug 2019 04:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tT9e5e3djZBvXYTrpAoLko+EhVz7EVGm5gKcxdsSqSI=;
        b=h6xGZt/fWaNTZ8WYwks/Nm2i17Ay3oEno+M3uEtfYIjlABgl/m02l/rJOopSGKkL1b
         MN+g35sI2KDuSHLLVv5KH1h3hv7Ham54H6hEgj7rqHhu4xslnBJ5ZIMkdSb5OOWxw8R7
         ZHuvYyI6BFAG2IUNuOPSkEQAo2/r96d47OGhULWVai7WVwLdeoZ1w92/zKA9NYa2ej/o
         rGAUtRMa4HWellNWPGC9bYy2cnmBKW3nRfo9l+HesIYL+9uiXbNSN7ANK8dOyZszhACW
         kv1FkU00nQyp90/tIalI775mTluE+6fRnG6skNX4KqDapLz4kSS7mHCl/NjnFQ5CpRKd
         dXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tT9e5e3djZBvXYTrpAoLko+EhVz7EVGm5gKcxdsSqSI=;
        b=XotAGGVENtSIorVC9j4l6X+cqppcGVCTd+h7fxNxCAfbOR1XfKmq30CwTtsrt7/wTv
         USnyS7AcyGtls+jZuwHjt34ug0oQPNa7haJJIuDeCKOtJJP5OwN7WocfnW127Odl3EvV
         +G7DWpnYoHC8Y5Qql+lsm/4IgdOfTT6PxyC35hsE3D/1J9obl/wMmPeHxP6eb/6BFUTq
         2TD+3rjfmtMlwNpJmM/n1yqTwnxJqXulN+om/Q/qO7D/Q9NIqQd/eLKlH7ystILk8Ydg
         XOtofJjEbyI9zbwyijNcFLi3Et6AZ7xBLYoYUesp8i9AZHOvrul/Hdok5zQWm9Em6+/a
         AU/A==
X-Gm-Message-State: APjAAAVcjWKgwGY1Bj3Hkj4FC91uuT1WFovMocS7b/mckRlCCJGBOetP
        063UnKAHvkeE4i1w21dHvuw8fWiN
X-Google-Smtp-Source: APXvYqzUALffdiFd+fntgUkrixW125AemDu7N1dmU+U68nHIxSaAHGG3RdfVD2YtghM/ORO0W03u9Q==
X-Received: by 2002:a63:5811:: with SMTP id m17mr11570494pgb.237.1566040798872;
        Sat, 17 Aug 2019 04:19:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e26sm9634219pfd.14.2019.08.17.04.19.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 04:19:57 -0700 (PDT)
Subject: Re: [PATCH 3.16 0/4] 3.16.73-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
References: <lsq.1566038111.397675943@decadent.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9bfbe161-70c5-d969-98e9-b94c911f09f6@roeck-us.net>
Date:   Sat, 17 Aug 2019 04:19:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <lsq.1566038111.397675943@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/19 3:35 AM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.73 release.
> There are 4 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Aug 19 20:00:00 UTC 2019.
> Anything received after that time might be too late.
> 
Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Guenter
