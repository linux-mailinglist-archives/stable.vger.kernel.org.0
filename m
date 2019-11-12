Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0CCF986D
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfKLSS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:18:58 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38047 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfKLSS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 13:18:58 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so12387820pgh.5;
        Tue, 12 Nov 2019 10:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a2ALGpNR46GQXLJRqvyvMcnFF85whvW4nf2mcwTjj4c=;
        b=pHsdxoQ24WxJD5pQGKckCJjtMqn9Di4iT+GZ+vw4PrrMfZGhCWVv2OSiT3XtaZmkZh
         gaL/b9vsRv9PQi75f2VCNU1MqjajBndQcfAXIYNE1FQLtpyvLUL1BMrTHG+9ex4Ac+KP
         7+Y8CZo+oTQYNcCtZcFqdNtjB/t95MtK6TidWy/2W1vgoNid5Ktq4ie64c08t9dqUlaO
         tL5zc3qyEB2NDSFLN1vykbqQfFURumHOzEgLi6PZh18fnWLUBVWR8njkPStKWR09B8JA
         JoibYiu7JHB0Qrkc/AZ9eL0GGezIa1tYCsxSNYhoxwQDmZgb/kISK+wVdM12Mcj+Y3iI
         rMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=a2ALGpNR46GQXLJRqvyvMcnFF85whvW4nf2mcwTjj4c=;
        b=Y1QLXZNZxJq0DLydwuKGzbTmVl0ANZlAt0hUsdDe7dhuFlO+Vz3MEK7g0HbrMxt2Ms
         4maQOR3dRxtGJ0dFWXNJFnJ1HKUmE9DSoEXUWT2c7owBZFdqvFN4z/rxzj8bNiqEF2nH
         JuuQdhbAiGsn7QKn/egpG2chkfGTDqQ20bC99xLVHm/wegr8gCvHjN96btozNEbqMw8U
         tY+uMNfnqMZdiyo4MgF0kvbZY9WFyQK8OatKwaLyg0PemXE+sSpZZfEZVL1foxOLmO5P
         N7Slb0+5ZqvkQ3seIvUxhlxK0QYGuI5tKbaSMy6E4GvEqW2hzlAZgHs0Rrs+nc3KqUrs
         7f0A==
X-Gm-Message-State: APjAAAXQyCLd/f+73nbY2AxApsKgRa9OpgnT2KhawZDwnNwTLWzGWImH
        5Q8aHEkgfAgG433At0T0fdk=
X-Google-Smtp-Source: APXvYqw5iiM0fB94L2sc+wuf8WXMkoiSR2vleMwgYFfok5PUN3HIbXCc94HVv892N6JM9JCPAPLCSg==
X-Received: by 2002:aa7:9618:: with SMTP id q24mr9979123pfg.229.1573582737886;
        Tue, 12 Nov 2019 10:18:57 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id hi2sm2896575pjb.22.2019.11.12.10.18.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 10:18:57 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:18:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/43] 4.4.201-stable review
Message-ID: <20191112181856.GB30127@roeck-us.net>
References: <20191111181246.772983347@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:28:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.201 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
> 

For -rc2:

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
