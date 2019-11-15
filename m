Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD97FE0E1
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 16:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfKOPIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 10:08:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbfKOPIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 10:08:05 -0500
Received: from localhost (118-163-138-88.HINET-IP.hinet.net [118.163.138.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 259DB2073A;
        Fri, 15 Nov 2019 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573830484;
        bh=sk0qDzO8+JG88Qd8WBcHPVKJ3Xr/w7MRVKVMQ/Kc6TQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2FWnyoDz8XHneDEOj0n+kAAsxsYW1mEeIdrfX+e69sSfFBZ3kdzUeavA1BBW0e19b
         PfwN+9ijr3hsPBXB+7zO2jd4XA95aFmZjfI8oHGtynSPv4aIGSkFkIopuqLmXLmMjP
         odRmIE0bEUJc9rEecQcN0TstS+XhP/7yzVyISCG8=
Date:   Fri, 15 Nov 2019 23:08:02 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/31] 4.9.202-stable review
Message-ID: <20191115150802.GB375474@kroah.com>
References: <20191115062009.813108457@linuxfoundation.org>
 <64c3a414-36d1-aa79-ad5d-75b5a57225cd@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64c3a414-36d1-aa79-ad5d-75b5a57225cd@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 15, 2019 at 05:56:18AM -0800, Guenter Roeck wrote:
> On 11/14/19 10:20 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.202 release.
> > There are 31 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 17 Nov 2019 06:18:35 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 172 pass: 172 fail: 0
> Qemu test results:
> 	total: 356 pass: 356 fail: 0

Great, thanks for testing both of these and letting me know.

greg k-h
