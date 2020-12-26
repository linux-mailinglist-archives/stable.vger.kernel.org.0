Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A182E2E78
	for <lists+stable@lfdr.de>; Sat, 26 Dec 2020 16:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgLZPL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Dec 2020 10:11:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgLZPL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Dec 2020 10:11:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50FE5207CC;
        Sat, 26 Dec 2020 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608995476;
        bh=JSKNSVXpjNMLf4SVRmb5eoueSSA+2hv4xDYgtvSgHoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lMjGQAAZtVDj9oD8xCRAXxicI9UUYXdOYQzoy2Ms95dyPIxAjaSjUkkTHVh+cMDhy
         RbRabfbgn5rYyXEIcmGkCsg+9YaPpvqHiqjutEVoErHbeg9jwweC+eyOUWHb7pd4Zf
         mJMJEvunstJB/1lcZL3npJ5aJwrGhIrHGtn9Cm3s=
Date:   Sat, 26 Dec 2020 16:11:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Please apply upstream commit 0a4e668b5d52 to v5.10.y
Message-ID: <X+dSkMUL0vnXQUvo@kroah.com>
References: <4f601cab-d7b5-2cfa-4e77-4cc5f8e389f7@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f601cab-d7b5-2cfa-4e77-4cc5f8e389f7@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 04:07:02PM -0800, Guenter Roeck wrote:
> Hi Greg & Sasha,
> 
> please apply commit 0a4e668b5d52 ("hwmon: (k10temp) Remove support for displaying
> voltage and current on Zen CPUs") to v5.10.y.
> 
> I used to think that it was a good idea to report CPU voltage and current for Zen
> CPUs, but due to lack of documentation this is all but impossible to maintain.
> Better to get rid of it entirely. I would like to have the patch applied
> to v5.10.y because that is a LTS kernel, and I don't want to be bugged
> forever with "values are incorrect" reports.

Now queued up, thanks.

greg k-h
