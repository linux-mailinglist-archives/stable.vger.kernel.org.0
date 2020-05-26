Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732D81E1B11
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 08:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgEZGNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 02:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgEZGNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 02:13:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15CA62087D;
        Tue, 26 May 2020 06:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590473622;
        bh=Pb/wWqmGBhlfB8kqhJG3Bq0aPMUGokABvtW5MHGfY1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qb7b9KVwj3XfsLK9w9NX+vHTgZSiYn5zeDa4dyV1D6N9aIiNtfSp/NkgivnpyY4jI
         yy2T3BUT76WV48J/477bo2DyqtV+lCQ6neML4RhBWT5bL8+B/z9JaZ93looRFhqohy
         ZwCwuDmRectw0MubePVxp4geDi4EpYrQ94HZ/Imw=
Date:   Tue, 26 May 2020 08:13:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     kernel test robot <yidingx.liu@intel.com>
Cc:     stable@vger.kernel.org, "Li, Philip" <philip.li@intel.com>
Subject: Re: 2 kvm tests failed on v4.19 stable
Message-ID: <20200526061340.GA2577681@kroah.com>
References: <2de6a643-a6f5-8433-76c9-88e8fb0ab069@intel.com>
 <04f35d3c-495d-aec4-7de6-ba4f2df6e1b4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04f35d3c-495d-aec4-7de6-ba4f2df6e1b4@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 08:16:46AM +0800, kernel test robot wrote:
> 
> On 5/25/20 10:14 AM, kernel test robot wrote:
> > Hi, all.
> > 
> > We noticed that below 2 tests passed on linux/master v5.7-rc6 but failed
> > on v4.19 stable.
> > 
> > Maybe we should do a backport. ;-)

Backport of what exactly?

> > Test on v4.19.124
> > 
> > ```
> > 
> > selftests: kvm: platform_info_test
> > ========================================
> > ==== Test Assertion Failure ====
> >   platform_info_test.c:58: run->exit_reason == KVM_EXIT_IO
> >   pid=6803 tid=6803 - Success
> >      1  0x000055698f76829a: ?? ??:0
> >      2  0x00007fc894fb0e0a: ?? ??:0
> >      3  0x000055698f768409: ?? ??:0
> >   Exit_reason other than KVM_EXIT_IO: 8 (SHUTDOWN),
> > 
> > not ok 1..1 selftests: kvm: platform_info_test [FAIL]
> > 
> > selftests: kvm: sync_regs_test
> > ========================================
> > ==== Test Assertion Failure ====
> >   sync_regs_test.c:138: run->exit_reason == KVM_EXIT_IO
> >   pid=6828 tid=6828 - Invalid argument
> >      1  0x000055f54209140d: ?? ??:0
> >      2  0x00007fc4675fae0a: ?? ??:0
> >      3  0x000055f5420918e9: ?? ??:0
> >   Unexpected exit reason: 8 (SHUTDOWN),
> > 
> > not ok 1..3 selftests: kvm: sync_regs_test [FAIL]
> > 
> > ```

Are these new features that the new tests are running for, or is this a
regression from older 4.19.y releases?

thanks,

greg k-h
