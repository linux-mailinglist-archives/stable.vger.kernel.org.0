Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5C313467C
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 16:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgAHPnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 10:43:04 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54638 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgAHPnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 10:43:04 -0500
Received: by mail-pj1-f67.google.com with SMTP id kx11so1231956pjb.4;
        Wed, 08 Jan 2020 07:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VaYDiyKUVmJvWDMGJuT27lJYQZ/YihlSUlgaX0Q70Po=;
        b=hJcPu2D7URepxUGAoP5Zwg5Bp6aGXbR+L4yQld2wRWdqm6OE4I3t17DvyFU4ACI0nf
         g/filK0qQkmI4zqU8WKA7v3VhwnN4Z20WWi26zQX2ZcAToX97CgHZgiZX1ddSS5HVYZ+
         4q1NHG6qH1ZZB8eAABCB2pCkNuzsfaxOJxyDZ5eaEUbqoH1knVGtZ5h8nJrz2Z2U5AuM
         gCouVX+Z7lD6hbkHGMZHHSS7MbXJiNGgZ/VrkRY1E6Ylp8D9WwxeyRL5aNcPzsyNzYmt
         enEh81KZgW7SL/YSkAF9cfVxaC53ZowYJrIeowKNAgKMAJI9JsEEuCuPWJ7VUfP/R5e3
         GUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VaYDiyKUVmJvWDMGJuT27lJYQZ/YihlSUlgaX0Q70Po=;
        b=pxwZyqp7G4ugSLEDSL5ylbYDTq8P08UV2LNZ/NUPo0USbdE3AgKNqu5q7y9hdLtdAj
         piTuk8qnDvotkqLIVcirx5Rdw+EELIyLgGmQ9fmKTFpVhx8dK5QvvAR/KXTd4gm1/xe5
         wlXLtwYE41DWbEJrPU29Dj3FvIIUPV7vuISByrGSbkbFQfuSIN2FHAfdX8LStZK8ZCd8
         Pb4gphaUgeb9QkIIm+agDRZw/382z/kBT6CyfNTnaxlokdntcscPs1dlSfJLl6XtxR7d
         nixmfn3F5X9HhQGm0CgvxQWNRhUv/N6exgJkZriLm0DC8ei1cang724bCNexVVoNkTd7
         A9gQ==
X-Gm-Message-State: APjAAAV/vVu8mHdm3pTkMu1C/N71zvOjD6cw96ICuSYZ58yAk2mKvDaK
        74eggW6gkJM8QlKC8YSq0LmiV3ga
X-Google-Smtp-Source: APXvYqyAhT8tiDk4AYesoJw0msEtDV3fiU7ZCmZlQtqRf0s91c5G+Ekg2BYX5wZ0+lfXG3Y2JUJ0Ow==
X-Received: by 2002:a17:902:aa8f:: with SMTP id d15mr5505288plr.276.1578498183723;
        Wed, 08 Jan 2020 07:43:03 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24sm4266709pfd.161.2020.01.08.07.43.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jan 2020 07:43:02 -0800 (PST)
Date:   Wed, 8 Jan 2020 07:43:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/74] 4.14.163-stable review
Message-ID: <20200108154302.GA28993@roeck-us.net>
References: <20200107205135.369001641@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 09:54:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.163 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
> 

For v4.14.162-73-g404399b2e7db:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 373 pass: 373 fail: 0

Guenter
