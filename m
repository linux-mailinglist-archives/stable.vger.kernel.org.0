Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566271B341E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgDVApF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDVApF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 20:45:05 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78FB3206E9;
        Wed, 22 Apr 2020 00:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587516304;
        bh=lP4LUL1R/VUken8Vg67EpWoxvi8+s59sw/3TZqsHqI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+YkqAIn1TVglPD1tAO3KB5b1yZwmXmtk/XswqMMVoPPs1V2ZdUV5QhquBtxHegQ6
         Gmpg2IVBO+h0I0Ew6pKYhKa1UxIPmT9imeYg7aAIC7ivmV+OpNf8MwHyODBQcrDBIU
         rxbAWz4mh6RgoeImawRlsFB+MWr34+GTXgPJP9ns=
Date:   Tue, 21 Apr 2020 20:45:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/Hyper-V: Report crash register data
 when" failed to apply to 4.19-stable tree
Message-ID: <20200422004503.GS1809@sasha-vm>
References: <158748916921284@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158748916921284@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 07:12:49PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 040026df7088c56ccbad28f7042308f67bde63df Mon Sep 17 00:00:00 2001
>From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Date: Mon, 6 Apr 2020 08:53:30 -0700
>Subject: [PATCH] x86/Hyper-V: Report crash register data when
> sysctl_record_panic_msg is not set
>
>When sysctl_record_panic_msg is not set, the panic will
>not be reported to Hyper-V via hyperv_report_panic_msg().
>So the crash should be reported via hyperv_report_panic().
>
>Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
>Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Link: https://lore.kernel.org/r/20200406155331.2105-6-Tianyu.Lan@microsoft.com
>Signed-off-by: Wei Liu <wei.liu@kernel.org>

This patch builds on 74347a99e73a ("x86/Hyper-V: Unload vmbus channel in
hv panic callback") which previously failed to apply. Once that issue
was resolved we can grab this patch too.

-- 
Thanks,
Sasha
