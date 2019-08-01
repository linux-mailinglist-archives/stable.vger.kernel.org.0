Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BA37D50F
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 07:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfHAFzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 01:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfHAFzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 01:55:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFEB3206A2;
        Thu,  1 Aug 2019 05:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564638946;
        bh=hRJ0geXIy4MdnlPNUpxz4GKyyCE+uH7rwILyiOD94t0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mj+asmTMwh6DLhjfQsxrBzyXifnC5Wxxrnz5DV/m4y7zXOTRPjX4xDFweoSQ1ZIsf
         KxsDosS2uRc2D8pc6yG8hrPrnepAd9PzibRY+DhHiNb+zCEX53Vynbh9kNVFwKjOif
         XDsNKb/XugGdQwHqY+VjT8jEnIVw/kmwW+9mnPlg=
Date:   Thu, 1 Aug 2019 07:55:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     mka@chromium.org, rafael.j.wysocki@intel.com,
        syzbot+de771ae9390dffed7266@syzkaller.appspotmail.com,
        ulf.hansson@linaro.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cpufreq: Add QoS requests for userspace
 constraints" failed to apply to 5.2-stable tree
Message-ID: <20190801055543.GA24496@kroah.com>
References: <15645886047744@kroah.com>
 <20190801022225.owe6y34rwlomwf5r@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801022225.owe6y34rwlomwf5r@vireshk-i7>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 07:52:25AM +0530, Viresh Kumar wrote:
> On 31-07-19, 17:56, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.2-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Not sure why you tried to apply it to stable tree. This stuff got
> merged in 5.3-rc1 window only and shouldn't be part of 5.2.

Sorry, looked relevant for 5.2, thanks for confirming.

greg k-h
