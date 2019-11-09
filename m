Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD562F6016
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 16:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfKIPlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 10:41:39 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41181 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfKIPli (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 10:41:38 -0500
Received: by mail-pg1-f196.google.com with SMTP id h4so6116504pgv.8;
        Sat, 09 Nov 2019 07:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5HpX5PwNsqHJHqGmeUKyTd3WOTik2ZjBcG7P7nV31DU=;
        b=BZkaO7df1z2/35NLcEIZoK2CXwGfFEl4qcSQ9TeNUf3zQuAovUpOrgQ57MQPZ3DGcU
         2KFg//+jzASDaL4f7vAZ9vhUzqNarYL2EvIqrgm86NrgVlDWijutCbevVpWP9jG+TBNn
         Ru6bb5bgCmdaXymtagUjS1dx7m9ne/L7m2Ty47JW5O3rHEA75GPVx4x5N6j99RSupo4q
         0IvJp/JL3UYsfzHvt8SByC1TZpDncRqQdo980n9f2ylTyEv46IwM0coQyXACTdWQLk5W
         9rKZdZGR8GT7NVXvnqCr8fuSiVXx33u4KV9Qj3YKCk4h3HwnjL/SmvqKtKdWizCPjAhL
         qPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5HpX5PwNsqHJHqGmeUKyTd3WOTik2ZjBcG7P7nV31DU=;
        b=dBcfdOV+npQqYErvB7eSAsZ/2O3fj450TQlsTCrtUynG/VRWrsp2XU+UcWVV36H/NS
         tDFo9kItCz/TQWBEbAOZkmh5Ff2tzS7VytmKpBgdvz7S+L+08kGvn8ywD45ZglmzbKZt
         lWF/aGUNeWnQfZUfNISYxZ2Rl8JyJgZMzGjgoCLqbIKf7A8W28fu6D/Nq46kLnktgXjK
         UwiktjZbO5+ReoANPmEiKZVwpqz9EZw7ZlY40qw2/j2JBo7qv0GVR58rvC/11I+AB+7J
         R6QaNYyyAiCi1wnGM5/9aMOVQt8xT6TGBEquM7f60JN+p2fIwFXTeEG9Rc74fuIdVkKb
         R3Tg==
X-Gm-Message-State: APjAAAUCrGEzWJT9Sucyi9F2y+FZIUQjJ7Z6Ct+fbwuZ02L4n8DBEA0x
        EduB1XS7baheAwKLFDuDzJF792sp
X-Google-Smtp-Source: APXvYqze3JiZlrbs0eNxxf79Q7yAxedbUMy9cRq9tJL1s8XpeLYk4V2PpiLhn5Jx5x5kYoHHDhM2xw==
X-Received: by 2002:a63:c849:: with SMTP id l9mr2954841pgi.330.1573314097906;
        Sat, 09 Nov 2019 07:41:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x29sm11219232pfj.131.2019.11.09.07.41.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 07:41:37 -0800 (PST)
Subject: Re: [PATCH 5.3 000/140] 5.3.10-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191108174900.189064908@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <d7a6de48-3022-bdc4-8a94-941a2f8fd38f@roeck-us.net>
Date:   Sat, 9 Nov 2019 07:41:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/19 10:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.10 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
