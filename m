Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDF4213B7
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 08:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfEQG25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 02:28:57 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:52363 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfEQG25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 02:28:57 -0400
Received: by mail-it1-f193.google.com with SMTP id q65so10219249itg.2;
        Thu, 16 May 2019 23:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aE+x5+dl9MX2p1ad/5FbE3e7gAOZarlIFaZtG6NZuCg=;
        b=Ma+CFUX83bsuUP3ZNQlhk6w3YI7Yn1WdN6pUiv8rgKcT8+hRadEStf1y3O9iobpev3
         zU8Cm9984+4t6ARgbeBeJqx4rAJpTJ80EbRVYBi3QvElELfBHHIBX51zTc5j/pJoDFnQ
         u7l7pZSKgcJzspc3OD7pWfjw/tTkwIDoHBckQgwtVYAEqJO8ZytkY9TmHgyDaB4PzYJd
         5NoBScJ2vyXuJe7w2PCwOHAA2LVrVh+I4NgY9oWKxuQy0YyQzC6ZLlLNcdJf98PXfAUH
         h1vIKjwZZPepXSUe1ibpEAcb6Nj1QvH6lxnnIMTsoX62YMoojfmgUoJaIc5i2PpZtB1T
         3HRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aE+x5+dl9MX2p1ad/5FbE3e7gAOZarlIFaZtG6NZuCg=;
        b=cOLXRRLL2eWThERvWD7GyJPkS4/7l/DOAYTgeja2RU5pSMXvOCOKfbRjTLy+uGIh2c
         sCH4PEOTaUw9RjeBxkoIx1d7TE9xnaFai2j31DoO0OpjEGBmVmw1GKWjiDvhba7ePT2+
         948r+x9WLzFFR+udCI5+BrFmvXM6huH9A+C8irV68U8Te6bKuI/e2+WG4lHmik2kSX9i
         eR/6mYvVf/atUinZdhmFIeOWihKFierWq22La8uJXP8MkZIuCPNrQPeFowKkd8q0IN7T
         JF9a9WmFHhxQXMfl+8968dVhJG4hwp149zuq0KG/FeYrQ/uo2NUR+CVa3v2kGA4m/Jf3
         ExwQ==
X-Gm-Message-State: APjAAAUvccGGBAcXmQ4KM5zHdr7m1gPHrOdVB1LQegMC+//XRb4wrHvZ
        h0fa6EEjMB78swKIvWKwDWotL8P6LA7bLQ==
X-Google-Smtp-Source: APXvYqy7xQyujiJGFabdtV39mMRi/hVsb0QAvzo+QfogaLuvhZsQUBUN/osrCBI0geqJfiIynZq3JA==
X-Received: by 2002:a24:97d2:: with SMTP id k201mr16059903ite.151.1558074536343;
        Thu, 16 May 2019 23:28:56 -0700 (PDT)
Received: from asus (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id p136sm2444380itc.29.2019.05.16.23.28.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 23:28:55 -0700 (PDT)
Date:   Fri, 17 May 2019 00:28:53 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.0 000/137] 5.0.17-stable review
Message-ID: <20190517062851.GA2303@asus>
References: <20190515090651.633556783@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 12:54:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.17 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:31 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no dmesg regressions on my system.

Cheers,
Kelsey
