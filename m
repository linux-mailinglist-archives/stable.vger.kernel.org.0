Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB2B48D826
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 13:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiAMMmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 07:42:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34126 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiAMMmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 07:42:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B8D861BFA
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 12:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B5AC36AE9;
        Thu, 13 Jan 2022 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642077722;
        bh=2/hzQ3SqxV1WVv44wWIKv4DtIAEHdthlE3fxdqqyNIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2hhFgdJgzQFJC+mXwGkfwjhuSSFbjh5F2XlNiP+SgLhFdnpCNd8UgqIfOAjJqN/n/
         WZL8Dxz0Co3TSS57TO5paZP53c0z3LBkPVobhuToGlrF/5nI+D0fCd8OvbSaRNGB/2
         870hUExi9x/z/CHQ5wdUrc8XZojEkT/rc1ZtaiWw=
Date:   Thu, 13 Jan 2022 13:41:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH][BACKPORT] mfd: intel-lpss: Fix too early PM enablement
 in the ACPI ->probe()
Message-ID: <YeAeF8r1JHEnb6Nj@kroah.com>
References: <450A01BA-8DFC-423E-8376-906C4FA9FF65@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <450A01BA-8DFC-423E-8376-906C4FA9FF65@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 12:09:01PM +0000, Aditya Garg wrote:
> The patch below has been upstreamed but I believe has not been back ported to stable. The patch fixes a bug which arose in kernel 5.15, thus I request you to back port it to 5.15 and 5.16 as well
> 
> Original commit in Linus’ tree :- c9e143084d1a602f829115612e1ec79df3727c8b

It has not been backported yet as we normally wait for a patch to be in
a release before doing so, this will show up in 5.17-rc1 first.

But I can take it now, thanks.

greg k-h
