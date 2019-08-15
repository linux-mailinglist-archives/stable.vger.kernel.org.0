Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD948ECD4
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 15:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfHON3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 09:29:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38941 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbfHON3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 09:29:43 -0400
Received: by mail-pl1-f195.google.com with SMTP id z3so1084021pln.6;
        Thu, 15 Aug 2019 06:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n6xoY9oGmqvarrfQtZv0gq7sMsQniSFkWh+TJOqFkAU=;
        b=Hqgm8+Kb04MyxWrGXkRWRw3wyEXUqcz1eTXDhGZy5b19rFbuR6hV6z4Z/txlIOQQ57
         QQUE6W1fN1YuxhUt08BPUvg7/HgnLTDWbvLJJw3BCfvdSlXvBtdqMvfEBdi+vtM2oJjJ
         YgYfy26B1zH50OBb96UnUZ2J80qjeNeo21q3C5nNjpf2IuY+aILTTwryCJqJdZ54YGCG
         DvrZLhNYhvFUQIXnIJfHrjckuLZUswJnrIZE+0pgl3b8VoROq4ZrzRSuUHrdY+Zs3qE3
         4kSTuunQfO0TaZIt5LM0h79bxHnE9gPZ2iQZYbhofaTe+L7MRrlWZm7oG0m3kO+DSrQ5
         vjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n6xoY9oGmqvarrfQtZv0gq7sMsQniSFkWh+TJOqFkAU=;
        b=rYcDyNx+m1KuAApeiLF0Kjoq0Gz8vh78TFrFWhNvPB4cKPhxyL5FWRIKLD3PFa9wGQ
         tzAtur5cMsTGZInPXy/G7ZcW12weeNpRgC9bzuzC8n99uiaD4LMHMO9NUTHpsys2/Fav
         5bqmRDNTn00l2dJ89pF+7t1def17EFEe+h7XMMAvpZnoj9lxzcWkNqd1ACoN0NyTJDPO
         THA+yntN4PuwOe85X1Jco6D81AHuxFcuVP5xaQTLwBLdiecBji5zchhkJlXQHtU3xh4S
         8fqGtPMwy24ISnfENx4LjkuuPxm9EYRFFDoEp5VkryCigO/ChaIkG0cUl/6CKCgveOOX
         tYpQ==
X-Gm-Message-State: APjAAAVXoM+CZjE/h1vA87TBFgn7sRgA8zIrBkZFWyFBYYqtYkEjJ24H
        9tCR1BDwlCAiQvndC5WSQCahq7RK
X-Google-Smtp-Source: APXvYqzIplY35y3Se1HTUS2ybmIQXvy4mBtj7vxUm4R/7bqjBVL+BH1PAizW72ovulmcP0ehhaL6Dg==
X-Received: by 2002:a17:902:8a87:: with SMTP id p7mr4346149plo.124.1565875782488;
        Thu, 15 Aug 2019 06:29:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r23sm3164020pfg.10.2019.08.15.06.29.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 06:29:40 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190814165748.991235624@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <aa683926-3df0-6f60-841a-7ea5a5e3566d@roeck-us.net>
Date:   Thu, 15 Aug 2019 06:29:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/14/19 10:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.67 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
> 

Building x86_64:tools/perf ... failed
--------------
Error log:
Warning: arch/x86/include/asm/cpufeatures.h differs from kernel
Warning: arch/x86/include/uapi/asm/kvm.h differs from kernel
   PERF_VERSION = 4.9.189.ge000f87
util/machine.c: In function ‘machine__create_module’:
util/machine.c:1088:43: error: ‘size’ undeclared (first use in this function); did you mean ‘die’?
   if (arch__fix_module_text_start(&start, &size, name) < 0)
                                            ^~~~
                                            die
util/machine.c:1088:43: note: each undeclared identifier is reported only once for each function it appears in
