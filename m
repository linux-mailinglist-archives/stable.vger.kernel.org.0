Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C0BCE9E5
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfJGQ41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbfJGQ41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 12:56:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682AA2070B;
        Mon,  7 Oct 2019 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570467386;
        bh=sLlO1BtNXZxprEixJGqexnBgXHWW/VwJZOsBQLupDuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TDVBUzHXHjtEUGGOp6BGxBv219RMYbawrzisXGDUZYgUuVGmzqm3S00qXxHLC/3vR
         Yq2NIqup7B9FNEW0K2yULEEiou5XdY/IsLV33i+zcgsQSGsNt4yE2J41ZPhMz2DLC1
         FV+dflFhCXxQmlo0HgC1LHlK/WJPGE2O6megwuJ4=
Date:   Mon, 7 Oct 2019 18:56:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/166] 5.3.5-stable review
Message-ID: <20191007165624.GA1129595@kroah.com>
References: <20191006171212.850660298@linuxfoundation.org>
 <499f5926-a2f0-465b-9e28-466832e6f701@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499f5926-a2f0-465b-9e28-466832e6f701@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 07:34:12AM -0700, Guenter Roeck wrote:
> On 10/6/19 10:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.5 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 391 pass: 391 fail: 0

thanks for testing all of these and letting me know.

greg k-h
