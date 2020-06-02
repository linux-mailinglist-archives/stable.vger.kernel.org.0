Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC671EC26C
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 21:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgFBTMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 15:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbgFBTMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 15:12:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD7EC08C5C0;
        Tue,  2 Jun 2020 12:12:08 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z64so5554244pfb.1;
        Tue, 02 Jun 2020 12:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Fc+POCcccpHuzZ177s1ogPM1HUKCod90SUUzBCyoC0M=;
        b=EM7aPO8kk/Zwnd7dSem1aSG0/loXoUBW6Bu6ko85Ha88U5qs8uXA37ifjrlTVySpXT
         gxZ+VuexgwJZgv7A+kz5lTziOKeN3xMgdOataJRQA/uYPMAk2WrKwBruGznNOaJoNHGy
         F+sCkQdvblWvFf3hIbaBY93lNIi11PjMcN+1CZNQXMOew+3p5YHMZfKXDGZsO385YrZx
         QmkI6pYUXnBxiiMHebQhVwnE85TROcZO+3Kyg3y4P2TvwR7bjGVnIyrtpVYHgJ3BjORc
         B9EpMxm+SAP040ksz1BMYNPD90E83m5WQqYH4yXXlY0AWH4BCRfsaxnoEnKldqwBmllR
         X6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Fc+POCcccpHuzZ177s1ogPM1HUKCod90SUUzBCyoC0M=;
        b=I01UKFlb/OrI/cE2gAL1yIgHDXoe/R6etX+L58BweP6YD+oJKmEYlIa4iJfyUASw5R
         w6/gctr2R+ICYUelyOnwFxcmjA3Gg7bAQ/p5+9bVtfHnXQe7OLFjRVUKAw+vLUAHEspf
         w6nTNcxD7HRE+1uaVSBzfwFCT0TTgCeuK+CfYtnR6q/3qpPRBdsnDZaW58e1Szxj1Dju
         j6UneSdRgLxs45JYozdifWtQbX99cWf3z9Sr27/xXGGKxrU0uwjZqKAsSpCKiUiy6Txs
         ngj0UpJqaekvRHtboCe6K7OsxsEHxEKT7YdNkt3744LTwTjlpGMNB7iyXH3+K27PVbwh
         juBg==
X-Gm-Message-State: AOAM533A/eaASzQCU0BQVLJB1FUNRqqACBbIOd41PjMBOBP1sym2/FS8
        25Cd97DjDzha6wfhI7AxHeY=
X-Google-Smtp-Source: ABdhPJwmoBaniSTK5kA600PXjpl2HqPaVChcGdoXd8QlUKbhs+iYjlTCUJ0sz4MbkV+4qDAS3yjnRQ==
X-Received: by 2002:a63:7016:: with SMTP id l22mr25024733pgc.284.1591125128091;
        Tue, 02 Jun 2020 12:12:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o25sm2667682pgn.84.2020.06.02.12.12.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jun 2020 12:12:07 -0700 (PDT)
Date:   Tue, 2 Jun 2020 12:12:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/47] 4.4.226-rc2 review
Message-ID: <20200602191206.GA203031@roeck-us.net>
References: <20200602100034.001608787@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602100034.001608787@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 12:16:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.226 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jun 2020 09:57:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 331 pass: 331 fail: 0

Guenter
