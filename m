Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A798EF26
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 17:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732675AbfHOPRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 11:17:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40097 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbfHOPRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 11:17:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so1477834pfn.7;
        Thu, 15 Aug 2019 08:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KMzP02BPacGQD3M/HlwsPXFYICW6UDU/hIwuUTbGnQQ=;
        b=fENOOSSjY9z7pGGou77lkGPNyGKHdzxoB0SNjx4SVMoHcmH2N+Zv24GpYOFSizmbPA
         i6kG2LtCnqODbgH10wx6544d8cLJCWKW9bIIDUvkVqCUdU48HZN3CXv906J05uc98ddn
         t4CXjrHSF2GwT9JHiiLEkoOyxjPaJUOO7GjG2GpIrFWb4LRhhNqauz1rhws5tgKPXsVV
         fgSGYsV77KajTvYyiTWlrV5I0zEr5ObRxssqOvAnUyeaKtPz7km6quEE4LwoLzOHwf8B
         CqFXDdpW7/lIKrJRVlNwo3T9ZEAIznhTmoAxg6flsXHyavtTiqFJUZ6l7gyPCG/wQM78
         3xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=KMzP02BPacGQD3M/HlwsPXFYICW6UDU/hIwuUTbGnQQ=;
        b=Q5F7T5xoVlE1VnzSr4DWurc5Kji6PBjGjZFKKntOSarguK9U6yMBZbs5p5lXbmByBb
         IuUJHnRkYbIH37o+vSMlLnRAh5C9RX4b1RtQG1eatRYT+R2YGsC2MzhTuvSMUAG3DZj6
         ITHbWWece7HutpZv1pyk4OuJFQo3MUH4LuimcD6RJYsOFMBXX7U+S6GH7jhwFuVtToYz
         DqFxqEDSNAx9XQECfSV/GCC37dLeKeXN2uX511XdMyqwKPQk9cNQf/XYQcWTkO71UPoJ
         5a4wu7ow6A7r969DRGwOpQrJK6BoXWvP12nn+qyrrqPpV9YTSnMRq0RmT8exVEeHBCao
         4+UA==
X-Gm-Message-State: APjAAAUNboJxJ3LGlG5/zQSoqopLJqov+yAZMDZl4Gd3mxCB6fMkViCg
        OrFDj7X+u9eVpKkgDHt4qDA=
X-Google-Smtp-Source: APXvYqxXg+7KQhjYmgLHbWmv+M8hwtPI7iJq5qzGb50X8f98oBdgLWO92EeszrtiHZQ0AlrPTNSr6Q==
X-Received: by 2002:aa7:8189:: with SMTP id g9mr6012302pfi.143.1565882228095;
        Thu, 15 Aug 2019 08:17:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5sm1608773pjl.32.2019.08.15.08.17.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:17:07 -0700 (PDT)
Date:   Thu, 15 Aug 2019 08:17:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.139-stable review
Message-ID: <20190815151705.GA23562@roeck-us.net>
References: <20190814165744.822314328@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 07:00:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.139 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 

Guenter
