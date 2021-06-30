Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE383B8017
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhF3Jil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233026AbhF3Jil (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 05:38:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1484E61C9A;
        Wed, 30 Jun 2021 09:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625045771;
        bh=bpZ+VvH0FO7FAkI5yZooXRQ/ZHgF1QWhTHv/+o1nc6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EdN9Xc37rq4Zw72WFvkwSV1KCRLKINTI5f3bj/5GWddkYG7ohsIZfxn+5QWD431Ge
         6iQJULeTw4OnYFRktBmNoXLJQ4W6cw2hlLvyx5WtgPdy78OqlCSlfikhZxOzg+gfFY
         NwKp6LANZHxDU6iWB9ZYDhE9uN65X4GpdPRlDxSs=
Date:   Wed, 30 Jun 2021 11:36:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     kan.liang@linux.intel.com
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        yao.jin@linux.intel.com, stable@vger.kernel.org
Subject: Re: [PATCH V3 5/6] perf/x86/intel/uncore: Fix invalid unit check
Message-ID: <YNw7CT2sBE0l8aNf@kroah.com>
References: <1624990443-168533-1-git-send-email-kan.liang@linux.intel.com>
 <1624990443-168533-6-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624990443-168533-6-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 11:14:02AM -0700, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> The uncore unit with the type ID 0 and the unit ID 0 is missed.
> 
> The table3 of the uncore unit maybe 0. The
> uncore_discovery_invalid_unit() mistakenly treated it as an invalid
> value.
> 
> Remove the !unit.table3 check.
> 
> Fixes: edae1f06c2cd ("perf/x86/intel/uncore: Parse uncore discovery tables")
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/events/intel/uncore_discovery.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Why is a bugfix that needs to be backported patch 5 in the series?
Shouldn't that be totally independant and sent on its own and not part
of this series at all so that it can be accepted and merged much
quicker?  It also should not depened on the previous 4 patches, right?

Andi, you know better than this...

greg k-h
