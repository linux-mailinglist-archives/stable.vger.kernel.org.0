Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39E30203
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 20:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfE3Sfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 14:35:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32826 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Sfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 14:35:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id h17so2522435pgv.0;
        Thu, 30 May 2019 11:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HfvY90edLevEkYjerC5bKK1r0svYqEJjxT1hRYqn0HQ=;
        b=DYvgxBsyf12dWrWqbIJXHMU7QfhApHKcsSdbrZt+HDjYdLgWleRzHi9Vk/ASIWQR4N
         7IIOJMplrAK4WFU8OF3j9QOdxz9PdeBf9cqN1bX2w6x8GLdUdZDvEVDH6JyQsxMhUwjI
         0O0cKebhGm6jOdD24IdUMPb3NwXxuaBZ6pvvH4ny3vryNjj7EhP4yPf9CrnRRQ8K4so/
         n+qhmbdCby7J+BO2FgDMap2u4h6FiBxfiCQOdVUwAogTyn11i8njEdeEjYMohpVIueMh
         EnpCmPpo4OcHBp6C7NPvCQY8KpAek1YtYoXY7Ort/GTzuDS5tltx9T86Mcs757LlItKg
         b7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=HfvY90edLevEkYjerC5bKK1r0svYqEJjxT1hRYqn0HQ=;
        b=Ngfzjo6yzg0S+OCn9f5yhaF0RZF69Hrpjl5DOoq3xo0yaqYPEVR/uQtrGzy4ouhL92
         ul/VT23QjAR30ygtu9bOLTn3x+22IOmf032kR/m0XQv6ons15kFLH2n5hpH3E6y5mJo5
         6OU5hudyEEGpTXn4lr6hWwQXgaRnBuVe5uJMPMNIlycnGyNNoJfmjwqZcD7AfuynDV+Q
         vJz0ymZ09uPrP58XLkSNxDbH947Jo87PJ8ZfVDAjw5hfnodqgueyksODytl0Gqtz+rcc
         hO5XAJmGC3QfxF9DqoAAu3e9H4wK9ls19y5JbUvxbO2a/dBgctBwJWqALVER8hiHzYFk
         i4Yg==
X-Gm-Message-State: APjAAAU7bgIbDkoYjg2UGezeo4MXEdBX+WxFBEEl6t1yl8ijKUgdlIQr
        L0V/bCTBj9Ysr38bje5TdvA=
X-Google-Smtp-Source: APXvYqyZqmkoix3NOJxupw0lYKJbKv5ZCpoNuvG4jKjd2REp25Tgvb6XsT5Ry4/wkdFxna2NX1BL1Q==
X-Received: by 2002:a63:520a:: with SMTP id g10mr4915717pgb.136.1559241351375;
        Thu, 30 May 2019 11:35:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k190sm7368243pgk.28.2019.05.30.11.35.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:35:50 -0700 (PDT)
Date:   Thu, 30 May 2019 11:35:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/405] 5.1.6-stable review
Message-ID: <20190530183550.GB9720@roeck-us.net>
References: <20190530030540.291644921@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 07:59:58PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.6 release.
> There are 405 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:01:59 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
