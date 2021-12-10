Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A036346FABA
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 07:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhLJGqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 01:46:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54382 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhLJGqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 01:46:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F3D7CE29F5;
        Fri, 10 Dec 2021 06:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E31C00446;
        Fri, 10 Dec 2021 06:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639118587;
        bh=1o9uYn87Vnh04Sc9CImuxM/RMkn6GYPUKWR1WL/rh6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/iLusVGSAZC/Fzp7LTmS7jA5GWGfbjsJ/xjBmLrbU3EfQGj47iczvpFhASosdn8c
         zLSaUiRprLN4O3/UOFSVid8stEtieZHx7pExmfkAdZ8Z4WvZPYTEKLYv6Njqpx5r7A
         JOQbNYYkyeBDe7qlFakg+h0qIUr62+n0PY16K4nA=
Date:   Fri, 10 Dec 2021 07:43:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Komrakov <alexander.komrakov@broadcom.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hoi Kim <hoi.kim@broadcom.com>
Subject: Re: [PATCH 1/1] Calculate the monotonic clock from the timespec
 clock to genereate pps PPS elapsed realtime event value and stores the
 result into /sys/class/pps/pps0/assert_elapsed.
Message-ID: <YbL29NfWUIy3m7cm@kroah.com>
References: <70960a71e92f34bfa0d0f3cd82fb289d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70960a71e92f34bfa0d0f3cd82fb289d@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 03:28:32PM -0800, Alex Komrakov wrote:
> -- 
> This electronic communication and the information and any files transmitted 
> with it, or attached to it, are confidential and are intended solely for 
> the use of the individual or entity to whom it is addressed and may contain 
> information that is confidential, legally privileged, protected by privacy 
> laws, or otherwise restricted from disclosure to anyone else. If you are 
> not the intended recipient or the person responsible for delivering the 
> e-mail to the intended recipient, you are hereby notified that any use, 
> copying, distributing, dissemination, forwarding, printing, or copying of 
> this e-mail is strictly prohibited. If you received this e-mail in error, 
> please return the e-mail to the sender, delete it from your computer, and 
> destroy any printed copy of it.


Now deleted.
