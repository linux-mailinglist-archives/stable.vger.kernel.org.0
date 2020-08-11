Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4003241C50
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 16:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgHKOYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 10:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgHKOYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 10:24:18 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD331C06174A;
        Tue, 11 Aug 2020 07:24:18 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d22so7704458pfn.5;
        Tue, 11 Aug 2020 07:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=updXGWSOW29Vw1+fG5VsWeXmE7P81YCKziqItMKLflA=;
        b=RWzWoVoIus/t7pGw2Et3w9FGYm+apgs5pl5opjY4XcFmukDzHqCAfTRrsqPS/gn6qM
         QwiIflE84KC79fDzszwD7lZgGEyCheQMWL6vlOPeDxLNu1azSf9gTEfnkA+7Coq21FWE
         7QmekgrCb/pSRxR5StnLY3Kv2zmXLpV34pV3Q3qDtcJQxI+kjGWKAgRxGpYF1H2oKuFt
         HxGi0AoSEzTEthOdIPtfpxWRjZvfrDFjwWQNH36TPUKseeF9XuOW+m4u5FTwXSGZ86se
         uPcVIG/dxvbrxj0FDwcYsWAf3uGbhBqpTcXMO6DUq0S7BlKpl2OdeltLBHxQeO6ROIzY
         2WKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=updXGWSOW29Vw1+fG5VsWeXmE7P81YCKziqItMKLflA=;
        b=jTqgBV/HpYUwj7TwwkIeS2iUSYnrtsrEVpNLyyFdv7maKBic+saaZ0VSdKAuBdaVvt
         dCaye3qe5tnXF1R/b0Ep1sO/w94qw+BwbC4ZLCQ0mipVzK1fTWi+52YzZsnvCvdBI/uw
         PmetgvZIbA4RaCGUntbn5KNeNHFW6pL3Q5lstCYOsNK4ESBpmlWv9MffyDCvPKnXHAeE
         BIU12W3ICDgf9QgVRdTWZ+wSzgx1iL72YBguPm9TrowpCRaMkszXQYOgeihj1WYwTfKa
         9bk1fxu4qBzAGOk+8RDGWKa0oGRgGaSnd6a8rRW2CJZCLkv1vJGAj/Gjt8P3xJqCfOms
         Jkkg==
X-Gm-Message-State: AOAM532qWGeW7Jk6617y/XVw9hJfSt6x+aoeTfyFHNT9uougxFud7rFM
        5a9EEI4A1QwUdQCCJTC8MZw=
X-Google-Smtp-Source: ABdhPJzGQzBOa+85pfKEqi4dyJ7fztoNWN8gLpghTv7/N7dZMpJ9f0/gQ5qEc1jL+L4YN6sBqR/W5A==
X-Received: by 2002:a63:e23:: with SMTP id d35mr972384pgl.435.1597155858358;
        Tue, 11 Aug 2020 07:24:18 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b23sm18696563pfo.12.2020.08.11.07.24.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Aug 2020 07:24:18 -0700 (PDT)
Date:   Tue, 11 Aug 2020 07:24:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/38] 5.8.1-rc1 review
Message-ID: <20200811142417.GD195702@roeck-us.net>
References: <20200810151803.920113428@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 05:18:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
