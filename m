Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B468B9B1F9
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 16:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393804AbfHWO2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 10:28:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35460 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733026AbfHWO2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 10:28:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id d85so6592243pfd.2;
        Fri, 23 Aug 2019 07:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZxRYDHMuqRWVzlmvTk6Z05hM8dippMyS+5yDjsNQJMI=;
        b=cqOU95RPVhAuAwdJlxJJM2aJW92BTqAtAMt8ttV8g8MCsAYT0D8mkZwCz9vhuw9stP
         bb3vmNHl7NzpK7eOsnQdzZRfCGIu61hCdVGcgYfkALYBtcg4QHjpKZWvHBt7aqOUB8yP
         D97BAueZ2Tr6HxMQZDJi2JAinXdQUBZesyM9Mdybx6P8JJdAIdLBiApSmZLzFHWuiCdE
         5uNZlAIUWtze0487YZeCbdm6lVyZcwq/+0QMRAnL6k8M1PVbVYqirFlZw0t7gKGKKF8Y
         cI1shblRzJonoUVG0YGj6rZRiRR7OCqkL+j6f+/MSGBvHK/H++AXqLM9TL8dXmmmJKzt
         zcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZxRYDHMuqRWVzlmvTk6Z05hM8dippMyS+5yDjsNQJMI=;
        b=OepPBGKcdqHcbQ6tSXLGLdUMzONqMIsDcWS2aaS3ukqmQiplHb62ABveYiN47p5nkX
         h1rWTtjddurIUtQFdhtDIQImAwIhWqaeb2IlhGD555ZR0SYSLfFvNbNeMUxWI3py5kbk
         OUleHa50AoJtAfvWk5kv4hHRTT60h6AARpWiUESkSBLyBRkExp2IPpB5L33zBHatNSDH
         qRCsbFj/3itvbCGVyVN90uoSxYLvxsArKB//czZdiTvaxmsue7tU997gygdef4P9v2ep
         m/02DMdhdtDCvaEQvQ9W2IAfKIO+q6kMF00quKqS12FYdEGgBEqV5lFhzGFwsR20l1+r
         B95A==
X-Gm-Message-State: APjAAAUy2eVcoraTXXhEWKY83VGFWeCD35qZn2tyVw8YhWXKcHr/b+8s
        hSO6Bfjh7sSRqxHeOCVf0oxQyhW+
X-Google-Smtp-Source: APXvYqwWGTifqrKrkTV8PUn7Dmbcc/IznMYpXDumP9Ky5nUxJpVvOhV0Kb+NU1W+231jtSyerUmQQQ==
X-Received: by 2002:a17:90a:3266:: with SMTP id k93mr5693207pjb.46.1566570513618;
        Fri, 23 Aug 2019 07:28:33 -0700 (PDT)
Received: from server.roeck-us.net (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id 195sm3047020pfu.75.2019.08.23.07.28.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 07:28:33 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/71] 4.14.140-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190822171726.131957995@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <57e3bd23-c511-0237-0d69-a7760ab7ba96@roeck-us.net>
Date:   Fri, 23 Aug 2019 07:28:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/22/19 10:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.140 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 24 Aug 2019 05:15:46 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
