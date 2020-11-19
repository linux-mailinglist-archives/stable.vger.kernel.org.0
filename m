Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9162B9131
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 12:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgKSLhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 06:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgKSLhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 06:37:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4BFD246EE;
        Thu, 19 Nov 2020 11:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605785864;
        bh=Ic1LI1ndEpNL1CRHxmWJlR2k7qMI4FsuU2JtiUF1ZTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bQPsB1lbl7iHhgNjBBcu7OsEHZgGwoimOOeJXq0vFJjYvv81CJoRv51iey0r9SGeC
         bbmnIq/5Bb85Z2vH6nJjwkgcM/tUP5nXJs5ARKkE1X0yQ+wiM4HS6cYpF4IQ1+WFsc
         YNfdyOcPZ8qXyUD9NmmWOIwm//fgqw6cAQpONuCg=
Date:   Thu, 19 Nov 2020 12:38:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Richard Narron <richard@aaazen.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.9 099/255] mac80211: always wind down STA state
Message-ID: <X7ZZNDyeETPlZVZW@kroah.com>
References: <alpine.LNX.2.20.2011181915260.441@thursday.test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.20.2011181915260.441@thursday.test>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 18, 2020 at 07:30:25PM -0800, Richard Narron wrote:
> This patch is 5.9.9-rc1 but is missing from the new 5.9.9 on kernel.org.
> 
> Is this desirable?

Yes, please see the email thread on the mailing list about why it was
removed.

thanks,

greg k-h
