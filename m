Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920E226329D
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 18:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgIIQrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 12:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730999AbgIIQrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 12:47:08 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6C0C061573;
        Wed,  9 Sep 2020 09:47:07 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a3so3017926oib.4;
        Wed, 09 Sep 2020 09:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n3Y+1un3H1D6oJKWN3rI/d5EPhk7L+MJ/htHdyocAoA=;
        b=qAQAXtOzsZ0sv3YdGzm6xc5j7lysX+ULODN3Fq9+2UQq9/VHPmsThip6XfnudOeKvL
         Mokc60xqwZAm08xseabSB5eDVTcPMKEcJpQ2IqZ2PO6hjJt1mPHa/NpaOSK8Ng0Y3xEi
         AEZZpNZFolJy3If3zVDLeu9tPJvqwJtiYvs8oESLMdmaoh0O8oRCNJ3TCnOapH19RoSc
         cwQBgfD079XNoaOBlCQqiMjs7zlYbM6Eu29UfSIRh85ZjWQgx8XtRdVP4oo9qGrv5au3
         kUAqS0q2EyNcwUKbq15qUiYCEc4MG49OMlIS4/oZMGoei3yb5+4Cd1FUL5Ih3ThyGP0f
         WBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=n3Y+1un3H1D6oJKWN3rI/d5EPhk7L+MJ/htHdyocAoA=;
        b=GL0QL6eJ3pr2888bMHAdp5SvcYnROHYOhgxrv25b+uK+1CptmWWEWOCwMfy7/nTihS
         NJVL0oWcsdkFKS/uEKW/C0+A4qfmEaWRDqsw4mh7/PvWn/nkiAjwQlJDw4eZxtYlHK4g
         EhAHqKLHM4GQzY8+zBKqGRuTMR3XWKVzptffVNKo90h/nU/eJU+0kc998iD65cxglHhN
         O6Kboea/1vJ986+HozaSnVK9WzwYWHkxS1IsZgXneWF1ojd1W6A7N1Bk+TMlca6/7PBx
         So+KvMf+TdzUYaL1o4xbiW2g+r8Ahn2PdRbg+k5t8JgV75ubQNYi0rByfSXcbaQ4BtuJ
         sjnQ==
X-Gm-Message-State: AOAM532wI+Z7MU8YnVBpNie4mfd71Ao9aCdYfHkxaaKSas446pJub8/Q
        vm3+ku9EMb/gBfQuxlPm9Jf/1cV52t8=
X-Google-Smtp-Source: ABdhPJzNLIwCZKb6actD3gqsnpt2pv3CoJ0V79tILh6f9Hfne/GydDWQZDoIMsjZyftM6MSMefkAxA==
X-Received: by 2002:a05:6808:1a:: with SMTP id u26mr1168579oic.78.1599670027117;
        Wed, 09 Sep 2020 09:47:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k1sm456972oot.20.2020.09.09.09.47.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Sep 2020 09:47:06 -0700 (PDT)
Date:   Wed, 9 Sep 2020 09:47:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
Message-ID: <20200909164705.GE1479@roeck-us.net>
References: <20200908152241.646390211@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 05:22:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.8 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	powerpc:allmodconfig
Qemu test results:
	total: 430 pass: 430 fail: 0

The powerpc problem is the same as before:

Inconsistent kallsyms data
Try make KALLSYMS_EXTRA_PASS=1 as a workaround

KALLSYMS_EXTRA_PASS=1 doesn't help. The problem is sporadic, elusive, and all
but impossible to bisect. The same build passes on another system, for example,
with a different load pattern. It may pass with -j30 and fail with -j40.
The problem started at some point after v5.8, and got worse over time; by now
it almost always happens. I'd be happy to debug if there is a means to do it,
but I don't have an idea where to even start. I'd disable KALLSYMS in my
test configurations, but the symbol is selected from various places and thus
difficult to disable. So unless I stop building ppc:allmodconfig entirely
we'll just have to live with the failure.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
