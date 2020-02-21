Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4619C16815E
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 16:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgBUPVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 10:21:40 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:36332 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727851AbgBUPVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 10:21:40 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1j5A7P-0007ni-Fo; Fri, 21 Feb 2020 15:21:31 +0000
Message-ID: <9f719752c33321fca7280a5cc59a886e1dd0dfda.camel@codethink.co.uk>
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Date:   Fri, 21 Feb 2020 15:21:30 +0000
In-Reply-To: <4e8cb265-4745-4249-45e4-86bd84f068ed@roeck-us.net>
References: <20200221072349.335551332@linuxfoundation.org>
         <4e8cb265-4745-4249-45e4-86bd84f068ed@roeck-us.net>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-02-21 at 06:28 -0800, Guenter Roeck wrote:
[...]
> Building powerpc:defconfig ... failed
> Building powerpc:mpc83xx_defconfig ... failed
> --------------
> Error log:
> drivers/rtc/rtc-ds1307.c:1570:21: error: variable 'regmap_config' has initializer but incomplete type
> 
> as well as various follow-up errors.
>
> The second problem affects both v5.4.y and v5.5.y.

This seems to be caused by commit 34719de919af (rtc-i2c-spi-avoid-
inclusion-of-regmap-support-when-n.patch).  These branches will need
commit 578c2b661e2b "rtc: Kconfig: select REGMAP_I2C when necessary" as
well.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

