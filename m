Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8D9A05F8
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 17:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfH1PQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 11:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1PQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 11:16:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 904A522CED;
        Wed, 28 Aug 2019 15:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567005412;
        bh=vF94YeXzGVrgTQeae3Oh2crRe9jKf8lXQ/zQxC/i2ns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hI1YlP03grEBRCC5XWLzrzJMGAiOE1cWYh3YYUnv2z8YIMjMwae80Qs8INMYCU95L
         BuGqiTQGc2N2YHtonyrOLxodPKFJ/7ignJxTxJq02cH5+roI0OFBjcfREeGY9sYZ/N
         kZfE7b+q7PNl/PgtebPCo7TBWq1F75xuKBccn1bc=
Date:   Wed, 28 Aug 2019 17:16:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/162] 5.2.11-stable review
Message-ID: <20190828151649.GE9673@kroah.com>
References: <20190827072738.093683223@linuxfoundation.org>
 <20190827172550.GD31588@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827172550.GD31588@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 10:25:50AM -0700, Guenter Roeck wrote:
> On Tue, Aug 27, 2019 at 09:48:48AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.11 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 390 pass: 390 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
