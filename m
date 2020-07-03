Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82ADC2130F2
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 03:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgGCBVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 21:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgGCBVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 21:21:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C12E20748;
        Fri,  3 Jul 2020 01:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593739301;
        bh=+5wO+QJJrYc8VRHYL25WNGnnFuegM0jrilNl/Q8HEr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KZ/ApJR02Zz+o+VlQ1HWLcItQV9qFVZnFr5SL9ee9u56Dgbd9A8ne6tTnZtmuxKT7
         cO+2GZMm3c8Ky4//CCFjB4aR5m4KBCo5v32XhLDNr/pGguUofM5nZFGWygwYw7eixU
         VKY1Or5g4QCc0AWhhqPwOzBauqEAHi52TlEl6PXo=
Date:   Thu, 2 Jul 2020 21:21:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     bp@suse.de, pipatron@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] EDAC/amd64: Read back the scrub rate PCI
 register on F15h" failed to apply to 5.4-stable tree
Message-ID: <20200703012140.GF2722994@sasha-vm>
References: <159343061095220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159343061095220@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 01:36:50PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From ee470bb25d0dcdf126f586ec0ae6dca66cb340a4 Mon Sep 17 00:00:00 2001
>From: Borislav Petkov <bp@suse.de>
>Date: Thu, 18 Jun 2020 20:25:25 +0200
>Subject: [PATCH] EDAC/amd64: Read back the scrub rate PCI register on F15h
>
>Commit:
>
>  da92110dfdfa ("EDAC, amd64_edac: Extend scrub rate support to F15hM60h")
>
>added support for F15h, model 0x60 CPUs but in doing so, missed to read
>back SCRCTRL PCI config register on F15h CPUs which are *not* model
>0x60. Add that read so that doing
>
>  $ cat /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
>
>can show the previously set DRAM scrub rate.
>
>Fixes: da92110dfdfa ("EDAC, amd64_edac: Extend scrub rate support to F15hM60h")
>Reported-by: Anders Andersson <pipatron@gmail.com>
>Signed-off-by: Borislav Petkov <bp@suse.de>
>Cc: <stable@vger.kernel.org> #v4.4..
>Link: https://lkml.kernel.org/r/CAKkunMbNWppx_i6xSdDHLseA2QQmGJqj_crY=NF-GZML5np4Vw@mail.gmail.com

The code we're patching got moved around in dcd01394ce7c ("EDAC/amd64:
Drop some family checks for newer systems"). I've fixed it up and queued
for 5.4-4.4.

-- 
Thanks,
Sasha
