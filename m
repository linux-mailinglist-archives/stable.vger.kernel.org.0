Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F13163C32
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 21:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfGITyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 15:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbfGITyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jul 2019 15:54:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38619214AF;
        Tue,  9 Jul 2019 19:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562702063;
        bh=GKsSuH6iNMH8ffm3zcAhlQSl9U+nHrSHsV9Oe0bfSPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hBGLHKaGVorfYcgA67guusEoQj37A/1zq7wm+U/p1oX9DoCStyfJ+n2gZud8xUTL1
         901ueFRXkd3ZRewBzJVbuF1ufXeskHDTiF4ZcdVISKbXoxUMmsEGlRxUWqUNjokk6v
         MuL/30gzNmfIgEHpELASgRJCX+l14NElMEd1Hvdk=
Date:   Tue, 9 Jul 2019 21:54:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190709195421.GA17036@kroah.com>
References: <20190708150526.234572443@linuxfoundation.org>
 <20190709184154.GD2656@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709184154.GD2656@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 09, 2019 at 11:41:54AM -0700, Guenter Roeck wrote:
> On Mon, Jul 08, 2019 at 05:12:32PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.17 release.
> > There are 96 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
