Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C24710D2AA
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 09:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfK2Ivy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 03:51:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfK2Ivy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 03:51:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2B9A2176D;
        Fri, 29 Nov 2019 08:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575017512;
        bh=hD42nUg99Rz/8HdFyMo6SgfAxJfUWnVYcASfacCMKek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c0BXQV5fg0S2pmGMs8hI9v4+xRv5gAXLH8OFmtyzHnmQ4LjOWlS0ZLkZzQtP63YyD
         p86nCAWtz8eP1UnvNntBX5cTRdMBa7Rv5VvSuo6437do921V7PSbSou0Ajavdk0nWf
         Uq9Sm5rRJAKj6kVyTm3RLU3ydagpGjV98L4FrtBM=
Date:   Fri, 29 Nov 2019 09:51:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/66] 5.4.1-stable review
Message-ID: <20191129085150.GA3584430@kroah.com>
References: <20191127202632.536277063@linuxfoundation.org>
 <ee4a83ba-e746-42f9-34c1-18caf2e369c8@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee4a83ba-e746-42f9-34c1-18caf2e369c8@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 10:47:54AM -0800, Guenter Roeck wrote:
> On 11/27/19 12:31 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.1 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 157 fail: 1
> Failed builds:
> 	mips:allmodconfig
> Qemu test results:
> 	total: 394 pass: 394 fail: 0
> 
> The mips build failure is well known and inherited from mainline.

Thanks for testing all of these and letting me know.

greg k-h
