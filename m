Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29783B9468
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 17:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhGAP7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 11:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233694AbhGAP7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 11:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC429613CB;
        Thu,  1 Jul 2021 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625155027;
        bh=Mvg6KAWXEBQjhq9pM1HR24KRbekHvHVxXc9geIjw5n4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F34Jllbo0DobTWbxH0ElDhdv5RUYvzFuusOb0wZOTy9rYMJCnwBl8wZT70lgIM67H
         64anJeypI5SRAjnMLsQGDivZIw1RQD1f2NiYcvz6sxTdauOObYEfnj9kF5z/Xpa4a+
         95dicGzr08RzTW/sekZ3l7p1F8luqrWmGpMXQ28U=
Date:   Thu, 1 Jul 2021 17:57:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tim Ross <tim.ross@broadcom.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Revert of no-map commits
Message-ID: <YN3l0OBmCmyRMSm/@kroah.com>
References: <CAKzR7o9DG0d75RVvC=ENUiFC6Zu3AHknd3uY4HFwP+H2RHpOeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKzR7o9DG0d75RVvC=ENUiFC6Zu3AHknd3uY4HFwP+H2RHpOeA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 01, 2021 at 11:01:34AM -0400, Tim Ross wrote:
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

Now deleted :(
