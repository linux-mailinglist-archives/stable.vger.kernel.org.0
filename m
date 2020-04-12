Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A441A63C4
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 09:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgDMHeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 03:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbgDMHeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 03:34:25 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE40AC008651;
        Mon, 13 Apr 2020 00:34:24 -0700 (PDT)
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07FFD2076A;
        Mon, 13 Apr 2020 07:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586763264;
        bh=5tRMSuqLMFSJVVCs9qTWdKiqGZSNGUKDkz5sxOAY5zc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J1roHItHnG9VDqm0mzs/8c0nQGN2w5upyltGdgywOzIqSNbWKpfPsYQWsrZykR6zL
         xemjjCf8Cb8ZYp+U5bt1yMx2iOufFRoSAvgYotyK/dgdQ0IBBltm2tzkmEkAf/HqjM
         YCtbGPV2KGIsSgIn4oGyPF3SS/Dyfhtb+lQiet1M=
Date:   Sun, 12 Apr 2020 10:07:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/38] 5.6.4-rc1 review
Message-ID: <20200412080728.GA2710231@kroah.com>
References: <20200411115459.324496182@linuxfoundation.org>
 <001e15f7-a755-82ca-0c43-aa8c0c2ab573@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001e15f7-a755-82ca-0c43-aa8c0c2ab573@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 11, 2020 at 01:43:16PM -0700, Guenter Roeck wrote:
> On 4/11/20 5:09 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.4 release.
> > There are 38 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

THanks for testing all of these and letting me know.

greg k-h
