Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB3FAE149
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbfIIW6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbfIIW6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:58:52 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF0D21479;
        Mon,  9 Sep 2019 22:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568069931;
        bh=OQvV4zekp6IPajT4IoW+3ng32vZbZ8998Jg+2NYLoGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMSsA6/7iSyW48rViNSVdZCWAFwV2LXBO7zXnRCiq56XCA34FnKVmqVgC1fI1pXDx
         o3sC3eUE9iVDWp+bAGcDeSSnejF0Ze5kvrqmVv/GDNUw0yQSc7o1EyVEznHM6xoS0P
         9LwfMMJysNmrfokC5DFnipj6srGVdYXOmXlZBkUw=
Date:   Mon, 9 Sep 2019 23:58:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/94] 5.2.14-stable review
Message-ID: <20190909225848.GB26405@kroah.com>
References: <20190908121150.420989666@linuxfoundation.org>
 <20190909194007.GD22633@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909194007.GD22633@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 09, 2019 at 12:40:07PM -0700, Guenter Roeck wrote:
> On Sun, Sep 08, 2019 at 01:40:56PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.14 release.
> > There are 94 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 390 pass: 390 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
