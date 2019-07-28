Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2F777E40
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 08:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfG1GWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 02:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfG1GWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 02:22:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4349D2085A;
        Sun, 28 Jul 2019 06:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564294935;
        bh=i2iFqiRgqUwkzxykGYDgQJuVL1DpyhAtJzOkbfYJPug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJydwrCl2c18dEq5gxxDNN0uYOMPJfOk3zxr8dWe27tM5B5cM72GYiOTDVi/g+Brq
         kehBFhfuntNy9YZ5fJwo/v76MgvD2MQliKGA02FvsN7YUs0NirPLQzaxh1wIx4MnlG
         2gYvJJIuyQnMDGbRRhLiCrDbIkrl1zFlOTayavI4=
Date:   Sun, 28 Jul 2019 08:22:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/66] 5.2.4-stable review
Message-ID: <20190728062213.GB21371@kroah.com>
References: <20190726152301.936055394@linuxfoundation.org>
 <9e69ade0-419d-a024-8b5e-988cbd69d4b4@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e69ade0-419d-a024-8b5e-988cbd69d4b4@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 27, 2019 at 09:07:49AM -0700, Guenter Roeck wrote:
> On 7/26/19 8:23 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.4 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
