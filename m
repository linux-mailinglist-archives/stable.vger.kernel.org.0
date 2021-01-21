Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234272FF402
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 20:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbhAUTNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 14:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbhAUTNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 14:13:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8597E221E7;
        Thu, 21 Jan 2021 19:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611256349;
        bh=gePeo1d++9CotISBWeKzhTR/pKZ+NFGN4GknjJNIk/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ilpozm4oEOgOeuinhxdzZwVAmejw2ovGgagbCX3evNiZlJet+cOeVyYnSZqtO85SV
         oiFMzKeozXMWhu1hFdKYmcSU5u/N+kqS7b2OKuaTCaW8HjEjkly0+XGkTFSOARcGhV
         Q3/T09iuuH2ArriOXnC25AaHh15SeUXCAxPmwoQc=
Date:   Thu, 21 Jan 2021 20:12:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] driver core: Fix device link device name collision
Message-ID: <YAnSGo05jjlQwnor@kroah.com>
References: <20210110175408.1465657-1-saravanak@google.com>
 <10c82099cb39f176dde96c16d9cc6100@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10c82099cb39f176dde96c16d9cc6100@walle.cc>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 21, 2021 at 08:01:24PM +0100, Michael Walle wrote:
> Hi,
> 
> Am 2021-01-10 18:54, schrieb Saravana Kannan:
> > The device link device's name was of the form:
> > <supplier-dev-name>--<consumer-dev-name>
> > 
> > This can cause name collision as reported here [1] as device names are
> > not globally unique. Since device names have to be unique within the
> > bus/class, add the bus/class name as a prefix to the device names used
> > to
> > construct the device link device name.
> > 
> > So the devuce link device's name will be of the form:
> > <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
> > 
> > [1] -
> > https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 287905e68dd2 ("driver core: Expose device link details in sysfs")
> > Reported-by: Michael Walle <michael@walle.cc>
> > Tested-by: Michael Walle <michael@walle.cc>
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > ---
> 
> Greg, any news here?

Burried in other patches...

I'll go pick this up now, sorry for the delay.

greg k-h
