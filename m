Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1515648A
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 14:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBHN20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 08:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbgBHN2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Feb 2020 08:28:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D96242082E;
        Sat,  8 Feb 2020 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581168505;
        bh=9vyT7wWLbXknGN5fSvcHlFuzmzZWJUSAC/u7CceJ9Z0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w6w621VXizYQWv//GRX37sAH6BDugKJuSNhO9DIMLqQTaykPuP4XUv99WTI8+Q886
         xcVnrSxk4imXzgG8ic6i2SrQso9ojNST8K69NW9gxDvGhoK2mpg21RKi0cHjoKWDvU
         VQ7JcmupG960ZYZHmnXnpNOkmqlm020QKtyl2DgA=
Date:   Sat, 8 Feb 2020 14:28:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: v4.9.y.queue build failures (s390)
Message-ID: <20200208132823.GA1234618@kroah.com>
References: <e63c50d7-68c0-1ada-dc05-86452d17a76a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e63c50d7-68c0-1ada-dc05-86452d17a76a@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 08, 2020 at 05:15:43AM -0800, Guenter Roeck wrote:
> For v4.9.213-37-g860ec95da9ad:
> 
> arch/s390/mm/hugetlbpage.c:14:10: fatal error: linux/sched/mm.h: No such file or directory
>    14 | #include <linux/sched/mm.h>
>       |          ^~~~~~~~~~~~~~~~~~
> compilation terminated.
> scripts/Makefile.build:304: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
> make[1]: *** [arch/s390/mm/hugetlbpage.o] Error 1
> Makefile:1688: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
> make: *** [arch/s390/mm/hugetlbpage.o] Error 2
> 
> Guenter

Thanks for letting me know, I'll try to guess and pick "sched.h" instead
here and push out an update.

greg k-h
