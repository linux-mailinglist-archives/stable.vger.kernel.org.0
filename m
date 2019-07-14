Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FA167D8B
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 07:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfGNFfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 01:35:13 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41271 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfGNFfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jul 2019 01:35:13 -0400
Received: by mail-io1-f68.google.com with SMTP id j5so24654629ioj.8;
        Sat, 13 Jul 2019 22:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9lj/erD8IpI0rjWR4phN2Ciw/3iidG1wDsFftGGugIk=;
        b=TXKdJSIChpSuSQkpACXU1wLqz9LK4BBJ/33UWHGxvcRaY5g8CsVKfATMgFddLEixhv
         XUbS7OEk+Il41/3tma5E4fJbqIx9yaCKkSlarcEttrpiZ9u83XjQAHk3NBOueXgxvizk
         GyBgXQLFqP1/ksVV1KO31LSKOCOixDDlAHCQ0JM06Q6fz5J4TtuqM35/EvoJObcdlb+L
         +HhjFHFzfBGtJcCl7G+EG8raJuQqvi7Dp26HOjdfBewAsvXKed72G3bmpiSm9wd8akl+
         jARLhwg8OSPXFUbxoXJHr28OP09CSTxI7WoMxzlVc7D4S19R/60H/QOhyc2gjf0S0Ywh
         v4Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9lj/erD8IpI0rjWR4phN2Ciw/3iidG1wDsFftGGugIk=;
        b=e9bbvD9pm+IpOHxtzDWYZV5gI6GM275fasz8DI1hXqPc+P6E4UP9Jz6Q2LpNuRh02P
         vtDg4aKgUusRZ1WEtuyi4U4wGO3t4r3om1zRlFyL6f91afet0wT3lP5BbVILhjAEOrbJ
         lwTvcIYEGu3y65wN5+PUr1WT5t8rQlsPwflCWyo/evRR8IHAMgQfDSdbfLWQno7HYi5i
         MxjvYRNfNDmCIcIqIKoxjp/X8q3tMa2mHUpiV6a3XGitOi0nA17NclGpm43jNgzYOzXP
         CyY6U4HYeU0a8P9RUnNd+BM4xJbDpzgNFojipL0y1l9mOPE0V0HTV2aLaGIyGWUHSIfx
         hr0w==
X-Gm-Message-State: APjAAAUY9p8hXjTdCwoRYLb1LLQ3ararH6USsGhz/XyT1GJM1330UBjT
        xx+POzJVnkbYiho631X1yD0=
X-Google-Smtp-Source: APXvYqxJDsXSv+sUe5ZmDjErLKwFuFKorO+R9B0C1gunuhoUIQTxoBi4ozW5ocuqR2aqQSYyRv+q7Q==
X-Received: by 2002:a5d:80cd:: with SMTP id h13mr19651694ior.259.1563082512570;
        Sat, 13 Jul 2019 22:35:12 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id r24sm10158627ioc.76.2019.07.13.22.35.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 22:35:11 -0700 (PDT)
Date:   Sat, 13 Jul 2019 23:35:10 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190714053510.GC2385@JATN>
References: <20190712121620.632595223@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:19:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.1 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Compiled and booted with no regressions on my system.

Cheers,
Kelsey
 
