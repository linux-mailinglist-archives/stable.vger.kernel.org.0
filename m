Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F528CE9A1
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfJGQqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbfJGQqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 351A020659;
        Mon,  7 Oct 2019 16:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570466777;
        bh=ImESnMo6BCmGdrP/rT424mhKjNAkOdoXsDT8bNd3LHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kQpaMl8QKUUxcp9ukMApHTPtM72hB26fCmFcM9FSixKUp1Kj91wyzeuwSYVpsx4L9
         bvZuk6qpu46G6df6D8tVXkgI2KVz4n+SqrHI774ox0hEn5v2SE/meDJzAKIel+Jx7/
         IRxiQu0QU/823HoByDxRdLe56b4cWLGXeb2jRbPM=
Date:   Mon, 7 Oct 2019 18:46:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux@roeck-us.net
Subject: Re: [PATCH 5.3 000/166] 5.3.5-stable review
Message-ID: <20191007164615.GA1090238@kroah.com>
References: <20191006171212.850660298@linuxfoundation.org>
 <7148ff93-bac0-f78a-df3a-b9dbbee3db1a@linaro.org>
 <20191007164411.GA1054518@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191007164411.GA1054518@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 06:44:11PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Oct 07, 2019 at 11:25:35AM -0500, Daniel Díaz wrote:
> > Hello!
> > 
> > 
> > On 10/6/19 12:19 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.3.5 release.
> > > There are 166 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.5-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Results from Linaro’s test farm.
> > Regressions detected.
> 
> Thanks for testing all of these and letting me know.

Ugh, I read that wrong.

Oh wait, you typed it wrong!

it's monday...

greg k-h
