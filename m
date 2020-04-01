Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A86019A71B
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 10:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgDAIUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 04:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgDAIUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 04:20:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 556D72078B;
        Wed,  1 Apr 2020 08:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585729248;
        bh=eFOFzuHnc4zeJvKTIWoh6Ztnd2/Z06wg6wJ16ZTmYaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=opFNnLLbFU01fOHnCLkpWjgARva/UTy5i9K4ZG/xU4XdLBoZzPuosTpy8G/8K7Fl7
         cMBQepuPuefqKK8jpgrjQhLUPFu3P0FCFIpA/pmYAoFxEPKMERahwW3P6vQJXBluea
         j9aPp2j2aPFb6ICrF3pk9F1jSrbjyQ3i8FhLywkU=
Date:   Wed, 1 Apr 2020 10:20:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
Message-ID: <20200401082046.GC2023509@kroah.com>
References: <20200331085308.098696461@linuxfoundation.org>
 <2ae5cda8-b9a7-b498-ef2e-9b5a038ac36a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ae5cda8-b9a7-b498-ef2e-9b5a038ac36a@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 07:25:48PM -0700, Guenter Roeck wrote:
> On 3/31/20 1:59 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.1 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 02 Apr 2020 08:50:37 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Wonderful, thanks for testing these and letting me know.

greg k-h
