Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17CE4122ECE
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 15:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfLQOdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 09:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfLQOdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 09:33:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC35421D7D;
        Tue, 17 Dec 2019 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576593201;
        bh=bex6ErfzhcBInBMSGQXwaj+78VMOHN9BNaFtE8Gpn6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TtAcxE8zkCPpCVEr0noO9pFNKn8zCQUtAW3zw+iSKRiDLmBkvecMIsDZ2QRfjT5vt
         M0DLRZR4CZDmXkFHzHS1i9QK25mak36/wp/ybYGuhNL56FpLnEYTaPqYEFUbZGqj5Q
         6plmkf9hq05T2ZIsYeJTI/nC6BUA4fhb1WkiSh/8=
Date:   Tue, 17 Dec 2019 15:33:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
Message-ID: <20191217143319.GA3624714@kroah.com>
References: <20191216174848.701533383@linuxfoundation.org>
 <20191217090548.GA2801817@kroah.com>
 <CA+G9fYunRMLr8Fi7S7FTXK1dskE_w10=5XdE7Ew__HDFvHy_2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYunRMLr8Fi7S7FTXK1dskE_w10=5XdE7Ew__HDFvHy_2Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 07:58:25PM +0530, Naresh Kamboju wrote:
> On Tue, 17 Dec 2019 at 14:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > There is a -rc2 out now to resolve some reported issues:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.159-rc2.gz
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for the quick turn-around.

greg k-h
