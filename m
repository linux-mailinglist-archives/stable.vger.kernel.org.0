Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B939116813B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 16:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgBUPPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 10:15:13 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:36054 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728804AbgBUPPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 10:15:13 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1j5A19-0007bf-5j; Fri, 21 Feb 2020 15:15:03 +0000
Message-ID: <9a4b6a0a2cbc6264e691b501ac962767283f08ad.camel@codethink.co.uk>
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Date:   Fri, 21 Feb 2020 15:15:02 +0000
In-Reply-To: <45ea9919-8924-fd56-6c78-3cf7f23bb7ff@roeck-us.net>
References: <20200221072349.335551332@linuxfoundation.org>
         <45ea9919-8924-fd56-6c78-3cf7f23bb7ff@roeck-us.net>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-02-21 at 06:22 -0800, Guenter Roeck wrote:
> On 2/20/20 11:36 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.22 release.
> > There are 344 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build reference: v5.4.21-345-gbae6e9bf73af
> gcc version: x86_64-linux-gcc (GCC) 9.2.0
> 
> Building x86_64:allnoconfig ... failed
> --------------
> Error log:
> arch/x86/kernel/unwind_orc.c: In function 'unwind_init':
> arch/x86/kernel/unwind_orc.c:278:56: error: 'orc_sort_cmp' undeclared (first use in this function)
> 
> Affects v{4.14,4.19,5,4,5,5}.y.queue.

This seems to be due to commit 22a7fa8848c5 (x86-unwind-orc-fix-
config_modules-build-warning.patch), which is only valid after commit
f14bf6a350df "x86/unwind/orc: Remove boot-time ORC unwind tables
sorting".

Ben.

> 
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

