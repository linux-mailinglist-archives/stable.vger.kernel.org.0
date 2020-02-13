Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2B915CE0C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 23:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBMW1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 17:27:36 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36132 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgBMW1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 17:27:35 -0500
Received: by mail-pj1-f65.google.com with SMTP id gv17so3045011pjb.1;
        Thu, 13 Feb 2020 14:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PTOvmX++Ot7D+SDBSFFIqqTI+TOj77rI5cOlwAJFUtU=;
        b=r5UlR2alyeO348xdmUtZ9Cp+xvhwFTl2j1ZYVj5aEzB+SwDEJaVuKrv12DpVYZx5MK
         t2a1uftgQ5hShMJh1Mrl+Htoifr7oQVOYiz+IN3ExK5J2iTZ0gUSqL+8kR1eG58ZM0qO
         nQOZrkxvBrFfLWbPz+ljlANNxLxxH+6VqsTqZbe271dp5ixbbURyW2hAOvRMAKmFON1I
         0CwU8tO7zt9YdWlCNihOuP6xo7iLAhNAYktxBwryowYxVzHObjSv4jaVQaS/hibPfFOp
         ExYspDfHJ5qI4CT/biOf2pVLtbhKxjSpZ/NvvUOv2Vyk5nF1/gCvJTjPQOKrTnYyQYD5
         FUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=PTOvmX++Ot7D+SDBSFFIqqTI+TOj77rI5cOlwAJFUtU=;
        b=QRa1xxlXCu/U0h003GpSDnraZyS5q+UR6y+uMyY8RfpV5X0/bPxY2R+707tP1MPtbe
         /Hbn5mXmyt28ffWB9bqxuCdsdSqTYsW1bZHDcxmvCFwI8LuNpjudYJvxd8TYPUCLrg2b
         BBxPI+kb3JFHGo1FTnVlYw0c4Z6ZLwl4WbdiXIn9KYMnHFg7Pf2N0TeQPPBn959pe6Nn
         O+Z3hLYzh0Gic98swvkjdM1iszK01NwNNsdHOzadgPQGYf/ATbD6WFq3J3QCJTx+hJTt
         o6YjRm+tCl8VU8qQgrkLsYb2ksNVM7tZsuEZSoITlfLRJJXB80adiu3AGaJ9mbkrGtNL
         sGZQ==
X-Gm-Message-State: APjAAAX2my9/fkHpSlVaYTLwi/nra4XSSwY4jUhHFv48ipw0BrISWFLR
        4hKvCrNFQBhgDidJJiSw1Z8=
X-Google-Smtp-Source: APXvYqwewiPN8d2fd5zsHsGWxKEnFQXYATEI8A5xKLudpLMBwuj3hG213YUe3ciUrEYjR0Dw10TMuw==
X-Received: by 2002:a17:90a:b008:: with SMTP id x8mr7877313pjq.106.1581632855191;
        Thu, 13 Feb 2020 14:27:35 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b42sm3737747pjc.27.2020.02.13.14.27.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Feb 2020 14:27:34 -0800 (PST)
Date:   Thu, 13 Feb 2020 14:27:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/96] 5.4.20-stable review
Message-ID: <20200213222732.GA20637@roeck-us.net>
References: <20200213151839.156309910@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:20:07AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.20 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
> 

Build reference: v5.4.19-98-gdfae536f94c2
gcc version: powerpc64-linux-gcc (GCC) 9.2.0

Building powerpc:defconfig ... failed
--------------
Error log:
drivers/rtc/rtc-ds1307.c:1570:21: error: variable 'regmap_config' has initializer but incomplete type
 1570 | static const struct regmap_config regmap_config = {

Bisect log below. Looks like the the definition of "not needed"
needs an update.

v5.5.y has the same problem.

Guenter

---
# bad: [dfae536f94c22d5fd109d5db73cd5ed7245a764c] Linux 5.4.20-rc1
# good: [d6591ea2dd1a44b1c72c5a3e3b6555d7585acdae] Linux 5.4.19
git bisect start 'HEAD' 'v5.4.19'
# bad: [f52a8d450b1431b775d993cd8586f0cfd5fe25e1] ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
git bisect bad f52a8d450b1431b775d993cd8586f0cfd5fe25e1
# good: [99323d91be3464a8ff87c7b16c72e7134b7b5075] selftests/bpf: Test freeing sockmap/sockhash with a socket in it
git bisect good 99323d91be3464a8ff87c7b16c72e7134b7b5075
# bad: [4ece240000532dbe0628f28f3f5466ed4091613b] rtc: i2c/spi: Avoid inclusion of REGMAP support when not needed
git bisect bad 4ece240000532dbe0628f28f3f5466ed4091613b
# good: [3a0805bedf5a29ff659d82b34ccf8f393820a5f1] NFS: Fix fix of show_nfs_errors
git bisect good 3a0805bedf5a29ff659d82b34ccf8f393820a5f1
# good: [bd35cae202fa94fe8349ea63ea082f190b31692c] NFSv4.0: nfs4_do_fsinfo() should not do implicit lease renewals
git bisect good bd35cae202fa94fe8349ea63ea082f190b31692c
# good: [d052da5a3c584de39b4b74176b37925d58ab4239] rtc: hym8563: Return -EINVAL if the time is known to be invalid
git bisect good d052da5a3c584de39b4b74176b37925d58ab4239
# first bad commit: [4ece240000532dbe0628f28f3f5466ed4091613b] rtc: i2c/spi: Avoid inclusion of REGMAP support when not needed
