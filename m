Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B6114F3BA
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 22:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgAaVZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 16:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgAaVZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 16:25:52 -0500
Received: from localhost (unknown [83.216.75.91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43AD820CC7;
        Fri, 31 Jan 2020 21:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580505952;
        bh=U2tdWdd//gj3E/qEf6hNMN7AusN8QViKoTuYnUp76RQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F/xuC23PYWsc/3DOjyoj6GYTxs2/wTfEYGGrsJxiEmExHNM4u4FeDeK5iBRgB/3dH
         ICHVdlkvZjwdUp4EJILqWve9u+PKNkbnIWwNHKowxleY5GF0X/cimXxNppkWhpYEqF
         H12fIckbOLTG6yMrlliCHIWt1ZGCqZo6/d/PqsD8=
Date:   Fri, 31 Jan 2020 22:25:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/56] 5.5.1-stable review
Message-ID: <20200131212549.GC2278356@kroah.com>
References: <20200130183608.849023566@linuxfoundation.org>
 <20200131173257.GC16567@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131173257.GC16567@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 09:32:57AM -0800, Guenter Roeck wrote:
> On Thu, Jan 30, 2020 at 07:38:17PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.1 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 388 pass: 388 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
