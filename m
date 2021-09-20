Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91097410F25
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 07:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhITFCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 01:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhITFCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 01:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EDA460F48;
        Mon, 20 Sep 2021 05:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632114047;
        bh=SAAFIBCTlMvHcxiOaZR0P2LnXmk54optXmYs7GE19rU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P4z64WN8H9YlAle+bsWv+IAtGmsOm4293x3+9x11URYrzZw7zYSJPM9xfItetY+fm
         57vqOirnCW5rGpgyv8bRKeWG0f+RorTqbLGfna+feV20G2zHU4D6qss8QEi2GKPc+b
         aJ6RPTHj1olFovza4Jy186A6WI2XnumDhtwux0yU=
Date:   Mon, 20 Sep 2021 07:00:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kevin Hao <haokexin@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 5.10 033/306] cpufreq: schedutil: Use kobject release()
 method to free sugov_tunables
Message-ID: <YUgVfJFQQhMnUWfF@kroah.com>
References: <20210916155753.903069397@linuxfoundation.org>
 <20210916155755.075805845@linuxfoundation.org>
 <bb93bcd1-b9b3-fc11-0321-7be6eee5beb0@intel.com>
 <YUN89bXPrsLsTAYB@kroah.com>
 <175d4888-1147-9a2f-32d6-7c90c2628af5@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175d4888-1147-9a2f-32d6-7c90c2628af5@ispras.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 19, 2021 at 09:36:20PM +0300, Alexey Khoroshilov wrote:
> Hi Greg,
> 
> I am trying to get familiar with stable release process, because we
> would like to start testing stable release candidates. But I cannot get
> all the nuances how to get automatically information regarding rc code
> ready to be tested.

You might want to start a new thread and not bury it down in a response
to a specific commit in order to make sure that people see it.

What specifically have you tried that did not work for detecting the -rc
releases?

> Also I wonder how we could automatically detect situations when stable
> release is expected to became diverged from the rc, e.g. like
> [PATCH 5.10 033/306] cpufreq: schedutil: Use kobject release() method to
> free sugov_tunables
> was dropped from 5.10.67 without announcing the 5.10.67-rc2?

Look at the stable queue tree, that has all of the information in it,
right?

thanks,

greg k-h
