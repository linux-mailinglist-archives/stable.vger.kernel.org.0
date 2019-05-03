Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF85132FD
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 19:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfECRPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 13:15:52 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38817 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfECRPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 13:15:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id a59so2989606pla.5;
        Fri, 03 May 2019 10:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B099toNmIURM1p32hc4OKNpqz70rzLCyjQd4AdJRI1U=;
        b=epeoE16tDkZvigGCC3DyainNa+3YXPLvIRnmZvlV8wtkY+IOKRTnJ9gOA0A60DmYd3
         AJ2+Sow4UcOm24twl2zN82MhcKWU7PM1ZT78BDrJkNeP9JLgKaFEehrJyUn7Vdy0UBK3
         adQpdvPseM4g7ZW7FbEgT8X4kPEOuUCXMM9YaiyoSQevCNhQVKnKxe2tdIvkxqwXSnC1
         cd5JWKUBkJHA/PaVjmoQa8zsJ4hS3Oi/qMIKgWejE/2r+9gN6VoPuJMl4JIxh4XUNCbc
         AQFqAk1WkuVFTcXJUjPEU16KxArPy3YLvPfi5w5Gy3iTn1tlT3QMur+plfn3tHuSAW4A
         TuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=B099toNmIURM1p32hc4OKNpqz70rzLCyjQd4AdJRI1U=;
        b=JW02Pok/fopKeJ3jzbTRI/0Z5xmWbQGQ4wP/xHJv8YbtWIfv2jtV96NByVLHQHENKf
         Z3qKmVKo2MOIDCyz8EuMw3YvOPg35109xhB3Y7sE+JgpIZAwZOPR/bR3F1+bnwNualw2
         MJTi3HOoEqex7NzYan3BDH1VCmzuArPsd5/MRG6uZH7fI/RArkdBqOH0DK9/jPAb9Bzi
         2fZl2kfSDLF+deM1nmRQeX3giYh8td9rG+ocOyOmATGLC9Lnl6LrBgQFklPQqu6l5lDE
         Ezd/rYMnd1JAAkmjuHwIRv9+m4qwmr2ttlmmQf0p6twVZJ8rBSgbqHELxNAWoG4rqhxR
         EGVw==
X-Gm-Message-State: APjAAAUs/dFFYue3yAEQLnXVO2nRNw7nbw19CEhxFZcPiahqhhuJBh1T
        W9iMIgq3eL57MzjXM932rRk=
X-Google-Smtp-Source: APXvYqyZCpz3WW2xulO8vSu8HT4XxZO6BIlbZRGgETTVe8dxX+FXkHS/WEIqPpip81CSy847jZktVg==
X-Received: by 2002:a17:902:6b01:: with SMTP id o1mr11985507plk.318.1556903752099;
        Fri, 03 May 2019 10:15:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n15sm8056942pfb.111.2019.05.03.10.15.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:15:51 -0700 (PDT)
Date:   Fri, 3 May 2019 10:15:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/49] 4.14.116-stable review
Message-ID: <20190503171550.GB2359@roeck-us.net>
References: <20190502143323.397051088@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 05:20:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.116 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:06 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
