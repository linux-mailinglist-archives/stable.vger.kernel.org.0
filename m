Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E63E3E5328
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 07:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhHJF7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 01:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhHJF7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 01:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3068E60F55;
        Tue, 10 Aug 2021 05:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628575167;
        bh=2LTjYYiiOsECPpgzn7qQUNKNgoIH+e638fvwG2EC8UI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IqzwWw+cnDBg9fXgHHyyIucYsH+EkBdCnKnO0vmv2O/UhLzEFv3P9lq1BlIXVGyww
         YzxBPye38I5HKbRi5qKWg6mvQZnjqjyvsyJPaAHuywX9IS3nj8j8i/JBxOh+56rmCj
         GA2exh5bYPFSxe9uL+R8Es44BG5K2aRkfKmgYgPA=
Date:   Tue, 10 Aug 2021 07:59:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: dts: qcom: apq8064: correct clock names
Message-ID: <YRIVvdoUizu1h0MY@kroah.com>
References: <LW7LXQ.P4TOHDR1NF9O1@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LW7LXQ.P4TOHDR1NF9O1@ixit.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 09:38:45PM +0200, David Heidelberg wrote:
> commit 0dc6c59892ead17a9febd11202c9f6794aac1895

What commit id is that?  I do not see that in Linus's tree :(

> Hello!
> 
> since the commit b0530eb1191307e9038d75e5c83973a396137681 (just before 5.10
> LTS) - this fix is needed for running Linux kernel on the APQ8064 and since
> is this fix apq8064 specific, shouldn't in worst case scenario break
> anything else and it's tested on the Nexus 7 2013 tablet, I'm proposing
> backporting it to 5.10 kernel.

What commit exactly?

confused,

greg k-h
