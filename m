Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4E924C67F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgHTUCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgHTUCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:02:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B60C061385;
        Thu, 20 Aug 2020 13:02:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c10so2965283pjn.1;
        Thu, 20 Aug 2020 13:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wj46JBpmm2roeihztaG1/VpTwaofm1SmtD6k2fW57K4=;
        b=hx07zC15XnfOH7alyU2DQFVA/hJawlOOAD8OubI4PuKQhTIBmOr4ivUJRcssCaBGct
         Yac34Th3f69ZTqet39bTaPMxeLxVGJ10XM1HAXVCi0fjcw7o+e/c/qEXlXRgZLePlOSN
         lr2OEpFBjjXRDSFutf/jjrJajT0kXHj0aKAyr3zasvOQaexaEQMolhVsDgJUXjfEKugn
         /sGlrBte/R42c1DahBKUB7ZajrKnzbLNXNSNm9jYWlq4X+3rq1W2ofz1fIpoPc3FDAeL
         8mnaWUiGRfGxyn8Tyq1hW0SmSj0kLwtfxP9l0VuU0InmTLA7xJEn8SQC/wmJYwMY0utM
         Mc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wj46JBpmm2roeihztaG1/VpTwaofm1SmtD6k2fW57K4=;
        b=oDoyRcfeaBV6G6BoG60Re6l6SxkkaF1qd8KDTqmJqpGMRqx6PP5ZEUBN7HJc1j8nyi
         4EeZDwioXc1ZfISxmYS9MRVPpggkB2yooQB5e+11inMrQt2LdggtyWdUu7bpLgzYOSmD
         SCV0Sn64Bu8Tj6AbobyQ5cTNyEYRpIGLLM1PNsNkjZKNbaT/s++ZHuzOd6TxG6JhcPB0
         8loSEGAFL3zgR6ulL586UorIj6QOBChWKPYfm206oZF/7kdvvfZlVufJDFmE+KFBZtW6
         q9vvQxpBA6QyUYmG1wIGlhyh8Aeovf2JnvOBVuLb/iVlsR9ISTY6EL/c8TZF+UX0SKkN
         QZYw==
X-Gm-Message-State: AOAM531BJqwisbLWNMb39rHvXIHCtTwz2Xn2wKOM+5/7Osjp+RRKt8N4
        HYDVIh4SxcR0oqwVGDfRnK4=
X-Google-Smtp-Source: ABdhPJyhKH2KBws+HtMgupOwShqkyVY0yV9/cPUchWgX7dDn0u63V1gbDTUl0RYIQI9bmLrYDLJOvQ==
X-Received: by 2002:a17:902:7245:: with SMTP id c5mr3686330pll.317.1597953762963;
        Thu, 20 Aug 2020 13:02:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id np4sm2787676pjb.4.2020.08.20.13.02.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2020 13:02:41 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:02:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/212] 4.9.233-rc1 review
Message-ID: <20200820200240.GC84616@roeck-us.net>
References: <20200820091602.251285210@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:19:33AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.233 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Guenter
