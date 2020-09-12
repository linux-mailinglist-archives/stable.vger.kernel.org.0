Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED04D267A6B
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgILMra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgILMog (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:44:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E19B621548;
        Sat, 12 Sep 2020 12:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914675;
        bh=PQJxx/loe7odx8BZu10EFsNT3ixnUsgixukZxlqpMJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hoNzDr3mCiu7IiIG6kiGXYPcbENcEkX2tWM4xbj2h8LtXU/dOHeiQueacyGZy5n40
         5jVgnSfD+1j/JLKBoBntwFebafbgp8R3iX0hANyICrGZDEB0B6DXPPitC7ooxhVNBu
         mqows/2/M1D60DCDl3L4aCQxh3dxXD99wRXvP5uM=
Date:   Sat, 12 Sep 2020 14:44:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/16] 5.8.9-rc1 review
Message-ID: <20200912124439.GC539446@kroah.com>
References: <20200911122459.585735377@linuxfoundation.org>
 <20200912021912.GD50655@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912021912.GD50655@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 07:19:12PM -0700, Guenter Roeck wrote:
> On Fri, Sep 11, 2020 at 02:47:17PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.9 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of tehse and letting me know.

greg k-h
