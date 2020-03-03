Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E621B177AED
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 16:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgCCPsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 10:48:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbgCCPsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 10:48:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA36520870;
        Tue,  3 Mar 2020 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583250496;
        bh=tqIdCK44HCwZ7SB3/ZCasst08E8YpC0L6JiNkZ/wwmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rN6StGaaqkT2huHDDUKxU70wo/U2D5HKZH77SBmiRj02fYE9eA2JKLAeAE+o3sZtR
         SjerAMpTIDxZhgK/iPQEwBUQRyJ6n3j27Laa6l2zQ4zjEUmVVjMfTNZQc4GWPjq0y6
         g7hHpFUzXf717X8bwQkLscbNQlY0IP4wW/bWQF8Q=
Date:   Tue, 3 Mar 2020 16:48:14 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ravi.bangoria@linux.ibm.com" <ravi.bangoria@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 4.19 "perf stat: Fix shadow stats for clock events"
Message-ID: <20200303154814.GE372992@kroah.com>
References: <191de78a6356926ed080b67be0b79398c5f57915.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <191de78a6356926ed080b67be0b79398c5f57915.camel@nokia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 07:47:04AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Hi Greg, Sasha,
> 
> Can you please include this perf stat fix to 4.19?
> These two commits needed:
> 
> 
> commit eb08d006054e7e374592068919e32579988602d4
> Author: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> Date:   Thu Nov 15 15:25:32 2018 +0530
> 
>     perf stat: Use perf_evsel__is_clocki() for clock events
> 
> 
> commit 57ddf09173c1e7d0511ead8924675c7198e56545
> Author: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> Date:   Fri Nov 16 09:58:43 2018 +0530
> 
>     perf stat: Fix shadow stats for clock events

Both now queued up, thanks.

greg k-h
