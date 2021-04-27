Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2DD36C7FA
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 16:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhD0Ovo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 10:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236173AbhD0Ovn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 10:51:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 998C4613B2;
        Tue, 27 Apr 2021 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619535059;
        bh=JbNnkJ9mJ2GpiCHJRhd7wH771HJ2kG1rStLIQBzvBSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6gcRXzqgQ2NViCjbfwnnlAEoltwPPL3qCLhGYU06MKrhRdXbP5M/dAbpzQEfjOPL
         NJ+Es4B17Z9f3WxCAL9zpHyYLzx3C67cJ+liVQDTA1j0HpC8fs/agOqhXpN7Reuo7A
         pWVI1+4S7RwccPCZ0B26JQc76HAena3jLZaR+cWY=
Date:   Tue, 27 Apr 2021 16:50:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-kernel@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "3 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH 041/190] Revert "ACPI: sysfs: Fix reference count leak in
 acpi_sysfs_add_hotplug_profile()"
Message-ID: <YIgk0Dydbn42D7zI@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-42-gregkh@linuxfoundation.org>
 <c7451c62-69fe-bd8f-f90c-5574cf70b60c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7451c62-69fe-bd8f-f90c-5574cf70b60c@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 07:54:23PM +0200, Rafael J. Wysocki wrote:
> On 4/21/2021 2:58 PM, Greg Kroah-Hartman wrote:
> > This reverts commit 6e6c25283dff866308c87b49434c7dbad4774cc0.
> > 
> > Commits from @umn.edu addresses have been found to be submitted in "bad
> > faith" to try to test the kernel community's ability to review "known
> > malicious" changes.  The result of these submissions can be found in a
> > paper published at the 42nd IEEE Symposium on Security and Privacy
> > entitled, "Open Source Insecurity: Stealthily Introducing
> > Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> > of Minnesota) and Kangjie Lu (University of Minnesota).
> > 
> > Because of this, all submissions from this group must be reverted from
> > the kernel tree and will need to be re-reviewed again to determine if
> > they actually are a valid fix.  Until that work is complete, remove this
> > change to ensure that no problems are being introduced into the
> > codebase.
> > 
> > Cc: Qiushi Wu <wu000273@umn.edu>
> > Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks for the review (and on the other acpi patch), but this commit
looks like it was correct, so I am going to drop the revert from my
tree.

greg k-h
