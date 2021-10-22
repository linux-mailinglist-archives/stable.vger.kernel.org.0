Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7F043717F
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 08:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhJVGEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 02:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhJVGEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Oct 2021 02:04:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44F766023E;
        Fri, 22 Oct 2021 06:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634882525;
        bh=fDQdulB/6nOb4yj3V1XwE1WZ0LB2Q3eZR0TYXf3Vz9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fI5jW672S5eFZCXM2ELJyHCa8W+9PNtIwqXj1pIrq6pe53T6rg99vqTHYYFYz7luV
         Fwhi1pzfWcQiB3XbR54/IWDFrKKKnIyZrp3ZL0ctl+9TFo1V6Q64+1ab5PtUlVb7e9
         /YfMNIIiWJB8pXlGUl90m/11NO2C69f0wjFuwrl0=
Date:   Fri, 22 Oct 2021 08:02:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Message-ID: <YXJT2OoM+9BwXfSv@kroah.com>
References: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
 <YWV4bnbn7VXjYWWy@google.com>
 <FC366D8C-0360-49B2-B641-5A3FD50E3398@live.com>
 <YWg/1zcfMN2+vuiJ@smile.fi.intel.com>
 <YXFL05vXfoCV/Go/@google.com>
 <054143A2-888C-42DF-947A-8CEAFF155292@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <054143A2-888C-42DF-947A-8CEAFF155292@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 22, 2021 at 04:24:47AM +0000, Aditya Garg wrote:
> 
> From 76d8253d90233b2c2d3fbc82355c603bf0eb9964 Mon Sep 17 00:00:00 2001
> From: Orlando Chamberlain <redecorating@protonmail.com>
> Date: Fri, 1 Oct 2021 13:30:19 +0530
> Subject: [PATCH] Add support for MacBookPro16,2 UART
> Cc: stable@vger.kernel.org
> 
> Added 8086:38a8 to the intel_lpss_pci driver. It is an Intel Ice Lake PCH-N UART controller present on the MacBookPro16,2.
> 
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
>  drivers/mfd/intel-lpss-pci.c | 2 ++
>  1 file changed, 2 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
