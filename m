Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C4E114269
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 15:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfLEOQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 09:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbfLEOQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 09:16:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DD9120707;
        Thu,  5 Dec 2019 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575555387;
        bh=vs1PNPmAweI6TVl/Y75Dkni0Ku5XONrlhhsW4qbB4zY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VY2N0m35aF/bH1FtkUI7gkeen4568psDvR0TGmihIMoGpqP3ADMUB91NhVWSGGj6b
         k5XXY2lhxUTxCM++1TL9fJRGGprp56dJsZbfgAuoXdwHbJGVqhpQm9UPA+hgShMvel
         zPXHdXfN3t0td0PZC4sR5YrnrDEt5mb/F1Z2oFbQ=
Date:   Thu, 5 Dec 2019 15:16:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
Message-ID: <20191205141625.GA691622@kroah.com>
References: <20191204175321.609072813@linuxfoundation.org>
 <01657715-38a1-2f19-9f98-22b2fb4dafc8@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01657715-38a1-2f19-9f98-22b2fb4dafc8@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 06:14:08AM -0800, Guenter Roeck wrote:
> On 12/4/19 9:53 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.158 release.
> > There are 209 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 172 pass: 172 fail: 0
> Qemu test results:
> 	total: 372 pass: 372 fail: 0

Great, thanks for testing and letting me know.

greg k-h
