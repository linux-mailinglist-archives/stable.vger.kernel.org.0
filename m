Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B56C7B238
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 20:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbfG3SnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 14:43:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36177 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfG3SnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 14:43:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so30300838pfl.3;
        Tue, 30 Jul 2019 11:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XQ1HEShJ5s73d/yzmaGNdklZsr1H4GUBmJKRPpDPWac=;
        b=pGmY/e7mYn6/fhUsdIx/RoglIfB/4X9OYqdQsHGhi82reiyeOfK9FHszatzzMzp8Lk
         KNeIX9Ly0NpN6VwGaTD3N+RuRjlr5UCft0cwvhatUWbShDdFUO27XeE7zTwJXZgIq+sd
         Vm7xlJy2DLWrQ0bREA1OZqqQwshO2T5IWnvFqS0H2ZtZeMsVATpEU/PtZCwPilWI0spX
         TQQ1dU23LhXJX3Oy0E7/XPG6VjfGokLJQt7Dg6HfKLbZl8GUUVy6AU601PyXQwhUzvQH
         BzvKNM5W6lAmcVVneI9lpL2J0uKkY5gXGYuTfmrcMNtdzmWiiO0SRjcsfgkPqNe24grP
         EW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XQ1HEShJ5s73d/yzmaGNdklZsr1H4GUBmJKRPpDPWac=;
        b=Xl7uUuoZ8q+9L+H1C9h10Hyd+Mk5TFrpUzNu4gIsl0yV4CRDztc8vpo7/CtMtlTStv
         y546V/51oGcVaXxTHQhQ7f3EbnbjUruoFsNvLlFb8e56PUTZpBpM6P1vs2eNHbVEcn6A
         tLwHUW17KrU5LUaJx+kc88xIyR5hv/7NPs/IYjvfNliZVy0SX30uCdu5Qt2lPStT6ua/
         U6AqOSBDkK6pyq1rm4o7OlLEXZXR2SXH4etfQd9+72/uAuMIWJ4lzGPchSGo0Hczc21X
         v/ctsD4aNGgH43z0lunoDTfNRutpUV2j3wPhVITw4yEmgJL78JDoEGGaLN8IZqoOcJ+T
         7wmw==
X-Gm-Message-State: APjAAAWGncmngnjdD3++e0DQJQeLitB4IcbC5eRBGEGdR30/sh9+EM5J
        WzjAojWqrNqDMNg6NN0qVdfAGmAn
X-Google-Smtp-Source: APXvYqwfjsNS8DEHByj9xWPHciC5KhmAfnuAb5KgUSFcj2zvbHeQnoxqiLY7hLOW5eaHFqfJD1Dgmw==
X-Received: by 2002:a63:484a:: with SMTP id x10mr51948768pgk.430.1564512187173;
        Tue, 30 Jul 2019 11:43:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f7sm64284652pfd.43.2019.07.30.11.43.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 11:43:06 -0700 (PDT)
Date:   Tue, 30 Jul 2019 11:43:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/215] 5.2.5-stable review
Message-ID: <20190730184305.GD32293@roeck-us.net>
References: <20190729190739.971253303@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 09:19:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.5 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
