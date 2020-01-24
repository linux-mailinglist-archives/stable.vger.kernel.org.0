Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFBFD14922D
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 00:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgAXXyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 18:54:37 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:38331 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbgAXXyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 18:54:37 -0500
Received: by mail-yb1-f193.google.com with SMTP id n7so1838274ybm.5;
        Fri, 24 Jan 2020 15:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rY863w4ohydiguAuhd2D0igZ+dgkI0oC1SxRg/YymQk=;
        b=TySAfI5R1ZQOdpqjUiGv6x7hcA6H1PND0kPFgprOzZwxkBySp/z6LoxD0JVLl1mz6/
         MTo8+is0Pn9UeQ0jtYk119NJb7T3o0Cnq+cRYyOB43RstXoVsc859RCWaHSpG/Cbh5Cr
         VvWoY1bjjWH7LzjVOqXJqaKWfbHbMydPA4whwUr82Ji/CvZiTM+uHwWRYrDVSUwIX7DW
         5u2IV2uCAkzzsIDCX2cqzqC33v+PlZ6xxnfJlvwNqUPTnAAMt7mHp04kYbO58rHnl26H
         7kI55BMbdUi6yu+mN2Nzx8/sTdH6G28b2lUBD0N/e7lKfGG5LXKkfnVe3kF0sRynjncS
         Fx9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=rY863w4ohydiguAuhd2D0igZ+dgkI0oC1SxRg/YymQk=;
        b=YfxFV5SSNC4hfmXgS4vaNYAu8Y/WJC2x/AOaNXgN4jo7Re+lTM4CHpz5KcIAXRpXxt
         dtH/MYYw94Sw6IKTSBlisVbzORC2Qzm3wCmkrtaOB3MibbAqR4v8xw8LbWAUdtMNv1tv
         4UlFCzj5H/FJ0vg8d3DvqoHCgWI/hqyTbb8tdAAAkufxdDSK6nH/fHDt/V1+NoVCcimy
         6t9AE5LgLr0PoD26F/o0M4NM1ToQd5CRVqtfogbaY29xRMPaRPHzwZvsG4t8ez6M7/Lq
         ctPMkkV+Uff+i5zB/h3fDzVtAORTq5RilK2AWj2M0aCEFYht6vCj3qe7O/JLA9yQ8PCn
         y0+g==
X-Gm-Message-State: APjAAAUS6y/Xrl8UpG/rfFGCQkTf5Nr2oL29zTFoaamGN23UpqNjCixz
        s2CLKtpEGbczDwINLGhMTOo=
X-Google-Smtp-Source: APXvYqyWxgame77DVx5w+HYolBxM/uJRnVdER43Qt/LlFkQztcMF1w4wJHJ9PuIDa3kwUcZ5k7L7vA==
X-Received: by 2002:a25:7302:: with SMTP id o2mr4548744ybc.521.1579910075962;
        Fri, 24 Jan 2020 15:54:35 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y129sm3078648ywd.40.2020.01.24.15.54.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Jan 2020 15:54:35 -0800 (PST)
Date:   Fri, 24 Jan 2020 15:54:33 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/343] 4.14.168-stable review
Message-ID: <20200124235433.GA3467@roeck-us.net>
References: <20200124092919.490687572@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 10:26:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.168 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Jan 2020 09:26:30 +0000.
> Anything received after that time might be too late.
> 

For v4.14.167-342-gc38faa17d730:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 375 pass: 375 fail: 0

Guenter
