Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA7612D2C0
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfL3Red (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfL3Red (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 12:34:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 881DE206DB;
        Mon, 30 Dec 2019 17:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577727273;
        bh=8RPCPn6R0ifvPEDQDZscee2RptmYZl9FLtJO4ZxM7l8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vODQzAv+9eE3z2HT2GxHQF7pVkoD98Ywyk9h9yz0N2K8UVq7PlWbRK7zIkR1y+iBH
         hE18PDDUdI4e5ImFLjC+cHbqxMDGG9K/sGZ/OEfPgX0D1qC12A/WfE7lLgaUdg+G3s
         EI27BVqUcvLyHgioEFn6910lr1MjK0vmlRN/ktiY=
Date:   Mon, 30 Dec 2019 18:34:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/161] 4.14.161-stable review
Message-ID: <20191230173430.GA1350143@kroah.com>
References: <20191229162355.500086350@linuxfoundation.org>
 <20191230171220.GB12958@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191230171220.GB12958@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 09:12:20AM -0800, Guenter Roeck wrote:
> On Sun, Dec 29, 2019 at 06:17:28PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.161 release.
> > There are 161 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 172 pass: 170 fail: 2
> Failed builds:
> 	i386:tools/perf
> 	x86_64:tools/perf
> Qemu test results:
> 	total: 373 pass: 373 fail: 0
> 
> util/probe-finder.c: In function ‘probe_point_inline_cb’:
> util/dwarf-aux.c: In function ‘__die_walk_funclines_cb’:
> util/probe-finder.c:971:7: error: implicit declaration of function ‘die_entrypc’; did you mean ‘dwarf_entrypc’?

Should now be fixed, will go push out a -rc2 with the resolution.

thanks,

greg k-h
