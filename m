Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1896B144E56
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVJMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVJMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:12:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D49322465A;
        Wed, 22 Jan 2020 09:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579684360;
        bh=v9bvt8Gscx2GT8F2r5lav4J36LbFKUfgh/vaKsSP1no=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yKzNXYBS98U1LHCpdh555l5Yguy1kGGcEbbtYnVRlgw+VSzz9Hlnb9ZAkSAJdbNXZ
         LFBWaOVN/l6L7EDSFpM3NBQTbOVns4evluJlaGHsjCugrQNIlXnbaZhX5J/7Jbw+PR
         Z1T2I7BbW+0CWP61IQrYCCjqXqaEk2K695oQIHYw=
Date:   Wed, 22 Jan 2020 10:12:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Hebb <tommyhebb@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 2/2] usb: typec: fusb302: fix "op-sink-microwatt"
 default that was in mW
Message-ID: <20200122091238.GB2643799@kroah.com>
References: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
 <0da564559af75ec829c6c7e3aa4024f857c91bee.1579529334.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0da564559af75ec829c6c7e3aa4024f857c91bee.1579529334.git.tommyhebb@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 20, 2020 at 06:09:06AM -0800, Thomas Hebb wrote:
> commit 8f6244055bd3 ("usb: typec: fusb302: Always provide fwnode for the
> port") didn't convert this value from mW to uW when migrating to a new
> specification format like it should have.
> 
> Fixes: 8f6244055bd3 ("usb: typec: fusb302: Always provide fwnode for the port")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
> 
> Changes in v3: None

Not true, you changed the stable address :(

