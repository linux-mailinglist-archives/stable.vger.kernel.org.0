Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099A010E354
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 20:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfLATg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 14:36:58 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38478 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfLATg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Dec 2019 14:36:58 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so4675636pfc.5
        for <stable@vger.kernel.org>; Sun, 01 Dec 2019 11:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DYmOSMD1BcpuuFPMlel8kjHsCHX2fxH+HvnEIQAuE+A=;
        b=hP1mLjIcOS+hJ4kvQ6XJalDfc+M5rKCS60CDWFbU0nIiInusDOeAV5fLS1Bpe1gyO9
         glE/sYEzK6VYQQKhFiDDXvimInPsX4irDBcKEmP8yzbH4249cpOgLp3Df+9+QhNcrN7v
         rqABDHh8c9HOOs/9ov5xUBH8WqP6hJ2fkLHhlE6+tpOrA9G9q9ZDbT1LAk/hwkzPfumH
         l6sUJ/oKDrJZYBip6ki9IvDqi5zw9A+PWZhsUKHJyDzOYKFFZKgxQPPWM4acAvnlHPvV
         bOVIjahzZwfMdYTHlhUmeRmHQ/+OiMy9tDweBM9SEAe16LPMFU9GissoDvxegpxoiXUA
         Z2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DYmOSMD1BcpuuFPMlel8kjHsCHX2fxH+HvnEIQAuE+A=;
        b=FhAbNABwk4Xy/rw2/mZUzjbmh/SmxCzhlUKV3v9mGxHVwlcrlPw1wmorwLjEqN1MHu
         jV/0K3v/qdyKD1p7oKS2Xy8HpyqbpTZlccBOgxDNb/EQpRxW2GbpRJKRcyZo9kdsCshB
         16ADfNBrCLiiYCkRgYDjaBcUDLzZxS718Npjusum+10ftjChtBTRDbLV9VKBf06Uu+IB
         XIGanZMkK54e/dG8wOAH5OUQyPatVpTZ4TMe3TdZLO6NNA6SY8jDegnnY0ZZF43UIAIh
         CYmiyz0r7LAT5fWQUHMpL+MOdhZWGdUktricwZP6e0IpvpI9Fmt4TO40bBcmEcwlHm6T
         p7vg==
X-Gm-Message-State: APjAAAUB3JdlomP/w/vUV9LEOys/1XBJaSW/djqN++Vb6DGuSYdCGF/R
        73kUZp8Od3bCw+t5fgWl+jFgSA==
X-Google-Smtp-Source: APXvYqw/7HI6F49FkvsvGgEqZf7bYFDsdw4FONQdLWlPm5IRyO7lgjqfLDZlH0NRoSILfNxrsg5Miw==
X-Received: by 2002:a65:578e:: with SMTP id b14mr28090389pgr.444.1575229017183;
        Sun, 01 Dec 2019 11:36:57 -0800 (PST)
Received: from debian ([171.49.192.254])
        by smtp.gmail.com with ESMTPSA id i3sm31485662pfd.154.2019.12.01.11.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2019 11:36:56 -0800 (PST)
Date:   Mon, 2 Dec 2019 01:06:49 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.4.1
Message-ID: <20191201193649.GA9163@debian>
References: <20191201094246.GA3799322@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191201094246.GA3799322@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 01, 2019 at 10:42:46AM +0100, Greg KH wrote:
> I'm announcing the release of the 5.4.1 kernel.
> 
> All users of the 5.4 kernel series must upgrade.
> 
> The updated 5.4.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h

hello,

the following readings are from testing performance of 5.4.1 with  5.4.0
the readings are from 5.4.0 to 5.4.1 in 1 is to 1 mapping.
the test results may not be accurate.


5.4 0
-----

real	149m25.803s
user	57m32.082s
sys	5m54.858s

real	141m55.929s
user	52m0.091s
sys	5m15.312s

real	144m18.779s
user	53m1.508s
sys	5m24.352s



5.4.1
-----

real	124m44.923s
user	56m26.547s
sys	5m35.978s

real	104m16.500s
user	51m11.444s
sys	5m1.046s

real	106m1.086s
user	51m45.339s
sys	5m4.815s


--
software engineer
rajagiri school of engineering and technology
