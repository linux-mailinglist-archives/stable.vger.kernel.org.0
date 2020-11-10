Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2062AD4D5
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 12:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgKJLZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 06:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJLZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 06:25:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0402E20659;
        Tue, 10 Nov 2020 11:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605007539;
        bh=NEBrld6dnHgdBahGFLyJh9NgZNdYanUCBj9rEaVRI3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=itETPhfg8r3ZZ1/kf4oEAw9KrxqG5CZ7DBxvSCKaqIhZ5U75RGVNF3hH2nPOxS4C1
         spmaQTWDpPmvRnAXZxWbJOOZCQIGx3yHBtyc+FtTzzOH5MaALGw5L71+5p4wDw0Zz4
         Ol2d3e0DNp74oEBOjWD3C6DI/GTdfrSbp3lBVQ/I=
Date:   Tue, 10 Nov 2020 12:26:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Benjamin Berg <bberg@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, Vladimir Yerilov <openmindead@gmail.com>
Subject: Re: [PATCH] usb: typec: ucsi: Report power supply changes
Message-ID: <X6p47IJA7T1RlENp@kroah.com>
References: <20201110103350.16397-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110103350.16397-1-heikki.krogerus@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 01:33:50PM +0300, Heikki Krogerus wrote:
> When the ucsi power supply goes online/offline, and when the
> power levels change, the power supply class needs to be
> notified so it can inform the user space.
> 
> Fixes: 992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
> Cc: stable@vger.kernel.org
> Reported-by: Vladimir Yerilov <openmindead@gmail.com>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

No tested-by tags?

