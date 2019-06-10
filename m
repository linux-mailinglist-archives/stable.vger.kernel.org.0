Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBAA3B79D
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389282AbfFJOmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:42:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45393 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389178AbfFJOmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 10:42:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id s11so5423691pfm.12;
        Mon, 10 Jun 2019 07:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lysVkCXZE1N1pszgGn3d3NjjI/mk1GY/iek2DaxLeLs=;
        b=CjFlVrzWAptiSiFPiWoYB2LiWJsGQ3EsR8d69jxkBAfQ80BYjrKfrasEylF3bpp9Ph
         Q1FmgDtiTQwL1yqoxupQjMmH2cExRNDFZcSwkaq5ZjZPAnCM8gBnVxoA0X9MVc6KWfRt
         eSCxaEZeqfi9HZABgeP4GhEiazruQNnRdNRie6zVbaLSfwqCpUfMA7VFGph9kH6AX02X
         RYeTYg+4dqA3sSuFpbxXXUaTZ+10W7MCMLdsEpBd7SPhkqGS4xaBgv5szHkh6N8zvUDw
         jUMDdNOLvj+t/ryMpMk1RLHvbzBBUEBOdaHoW9Z7gCLsbFdSsxNQgPABHg5gAYPDsQzj
         9/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lysVkCXZE1N1pszgGn3d3NjjI/mk1GY/iek2DaxLeLs=;
        b=kE8nakkBeWdmOJrETFFQSPQGFGLUfSPwla86dakBPPUHhOQlna6hmlJ7vuZHExCqie
         KOTnj/D607nXA9C3uq74mMu2GazOpM30Dya9ubkghHujTg/g4IqE8yX4e8AoV3fLg/UD
         D+HaVA8sTfEG1nBTqbklUvXhMFD2gxPM+E1XavMmg5GCG2bZz7h+KyY32OlgTqgHPrpq
         JFX0xbwIReM8nWlbhn9Pmh5TcYW1UK0ZwZHqGZRDCbI6Tg0xjy0lxmxHWxir/Kn+0idT
         XHox/1dB8eB3sZp5Xn+pWaxALBIMbZDaakMX4i0j9T9Ax5uU17BTNCPwHRRoMswn9AX5
         5RkA==
X-Gm-Message-State: APjAAAXhGodqaXBLFfAsSviiSJXCl+IRPmuX5L4es3S7TN616hfTZWvt
        bayohFZI9dtmlAXBE1RT2EU=
X-Google-Smtp-Source: APXvYqxUaY4YgF6AiKdAaetcR7MqipVvfCC3JH0SzGVgPI/LeCdpjH7QNWaxwRHebRP7x2xcc/wgsg==
X-Received: by 2002:a17:90a:658b:: with SMTP id k11mr21856022pjj.44.1560177756932;
        Mon, 10 Jun 2019 07:42:36 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 16sm10643578pfo.65.2019.06.10.07.42.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 07:42:36 -0700 (PDT)
Date:   Mon, 10 Jun 2019 07:42:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/83] 4.9.181-stable review
Message-ID: <20190610144235.GB7705@roeck-us.net>
References: <20190609164127.843327870@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 06:41:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.181 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:39:58 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 322 pass: 322 fail: 0

Guenter
