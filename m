Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DB915352F
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 17:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgBEQZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 11:25:26 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39466 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBEQZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 11:25:26 -0500
Received: by mail-pj1-f66.google.com with SMTP id e9so1201844pjr.4;
        Wed, 05 Feb 2020 08:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OSi7/fFI6sqk2cAAPyCRPawwvSLhgaIHJ/zZTgqB4K8=;
        b=tCk4Z9ymZ+f5+7FLygwYW8twEEDMetJKRXDV1xXhPxw6ZtXzvRioGFCpXANXNDJXAh
         Xqyge0370CDgYQIho8sxDPw90aX4UEm8I0TtY57RfAiePIg7+nJSzcwsIJ+oMOPvRXaY
         zU6TcyZR+fPgKYJOu0ReDtHr7sG4Q8njDEBLbZrLn3QMsH6rlDndfEB7ZIwDAjp9YIgz
         nmZAWiKKpIZ3kkl3tE1ZD2UlWm+/arucfCRldh9RcfUkt301HW/VhmBkK6WZgVnaTdPh
         l3BiUmYHNJoqx52v4DE7ZikpB0ECgfR6ZPZJrTdA07sF5wXrJZigD5x7Gtgx7904OpXL
         jo7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=OSi7/fFI6sqk2cAAPyCRPawwvSLhgaIHJ/zZTgqB4K8=;
        b=cdZSegUAgOTMAWigpqWTz48waMEm5JtbXCNuq1p0UAWG2a3QSfpy742UFDq8Vc3aeb
         3PORz1JPzuPWWEW+5r57GuWz8RmdlEJSUSJjYzcBMs1VsvVozT2fwqtGddEZqlbRVPWc
         8fq46W5yAmEybnXpSj1tNJfqB5Cbcg2oWRmwmEpVerohSg1WT6I+zmWlxunFvlvV3HQI
         eUg+Yh0Yppcwdot248GkXrB0MHnBAKY1P1QuOrsACBz4cOgmdGtc2NRCBhukNGB9qHHr
         mmPQefe38tcOlDhdy2IzW8z4t2MZz7vPF1+tMrZwgk8ToHj6r8EvzY9k/5/06vFcnbeC
         oDBA==
X-Gm-Message-State: APjAAAXOvRJlSwnAph4f3jjaIyx/JR0JnbdAn9jgCfBn4prCA+Z6d6tY
        kLD7chnct1zRuT60dXcvOAU=
X-Google-Smtp-Source: APXvYqwiDy4frwgCMmuJbsulnS1Im5oMvcfQ2R82W5I/1AEBEwTO0REkuIdRerDRFk8ADA18/h/Idw==
X-Received: by 2002:a17:90a:f492:: with SMTP id bx18mr6681271pjb.118.1580919925328;
        Wed, 05 Feb 2020 08:25:25 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fz21sm265692pjb.15.2020.02.05.08.25.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Feb 2020 08:25:24 -0800 (PST)
Date:   Wed, 5 Feb 2020 08:25:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.18-stable review
Message-ID: <20200205162524.GC25403@roeck-us.net>
References: <20200203161917.612554987@linuxfoundation.org>
 <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
 <20200205150605.GA1236691@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205150605.GA1236691@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 03:06:05PM +0000, Greg Kroah-Hartman wrote:
> On Tue, Feb 04, 2020 at 06:37:38AM -0800, Guenter Roeck wrote:
> > ---
> > Building riscv:{defconfig, allnoconfig, tinyconfig} ... failed
> > 
> > Error log:
> > arch/riscv/lib/tishift.S: Assembler messages:
> > arch/riscv/lib/tishift.S:9: Error: unrecognized opcode `sym_func_start(__lshrti3)'
> > [ many of those ]
> 
> Dropped the offending patch here, thanks.
> 
This problem is indeed fixed with v5.4.17-99-gbd0c6624a110 (-rc4).

Guenter
