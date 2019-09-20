Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F123B90E1
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 15:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfITNpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 09:45:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37018 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfITNpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 09:45:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id y5so4551530pfo.4;
        Fri, 20 Sep 2019 06:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ojmHmo8XFekuW2Eo/U0LbJMPHHysze4khKG4aZaPrl0=;
        b=kcdCLS5vIWNE6sa5s3YGOpk7vTCtxDI+WH8buw+rK3m8FAw2ZHhm0zPRAK503H1NLE
         IHorKBGA7iZM5EpZ+6kj/Xc5/liZkYbeJTWjqD/N86VlZWuQ2vJd+qh94Ak1FiGi4ena
         BPp9BrlwOffu+ARHVq0Cnv2lKDPM6rvMX3CvuLFnZafS5syZEpqsE9h00VMtI30RTOjM
         mymnmh/tvNm+WRvmk8c1JxaT1u8ZdfAPR9OM0OxDYaf3iGwSBfjhwJTgJi8ocHpyBAPb
         J0y4aIxkvy2WnoudALtSkAjhLcFncWbG7VY4XTlaLD45OeC22Tf74RL2OSmHpsyhjS7y
         bFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ojmHmo8XFekuW2Eo/U0LbJMPHHysze4khKG4aZaPrl0=;
        b=JAps7Ieox4TriS40fjgo8zEec5gKqxlJTF6efyfTq6TX23z2AAWa0BttyQGqTVh86/
         Hce0IlY+UqVEH6f2FLJkAzj0xkyLbsXoF0S+flC78n7uy7l2dXFWfXYkQU64OnirjGrF
         DEIEVQOPJCoJm7GcNMHsfyt9wSQhhd4Rg3DhYQNmWsNT2rR9lhgvmSjf4W3NePimZzjF
         vlZ6WjKXrnMrj3PcX2q47O61huVlI6SZtakRnfytI6SyY/Fin6A7YjMiSnHYXPMxWjCR
         Z0r8V5AX7uJrbDL9knYROaDDPAzHwGMUwviKp/JVFkth2VHimzSecgTSr4J8BKvO5gj9
         ioCQ==
X-Gm-Message-State: APjAAAWrZ2s++INvl+fz9VulPusiQJ8VQgBh6bpBBkGJ6q9+J8xPQgXv
        GtrPElfgfFR1fb5EzvEIzWSH7Aqq
X-Google-Smtp-Source: APXvYqyJyO/bAKlyDnP/SUGUobEZsxSP6aF/kyuTGKFt8bg/DwKCEnTNxxgEOSU6hdbN8R5qX+BTRQ==
X-Received: by 2002:a63:c03:: with SMTP id b3mr9759349pgl.23.1568987116155;
        Fri, 20 Sep 2019 06:45:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ep10sm32957534pjb.2.2019.09.20.06.45.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 06:45:15 -0700 (PDT)
Subject: Re: [PATCH 5.3 00/21] 5.3.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190919214657.842130855@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <69a64b52-1227-e53b-c26e-312416df5141@roeck-us.net>
Date:   Fri, 20 Sep 2019 06:45:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919214657.842130855@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/19 3:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
