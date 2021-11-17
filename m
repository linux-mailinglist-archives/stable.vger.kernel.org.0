Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACFC454C94
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhKQR5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 12:57:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhKQR5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 12:57:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35079613A4;
        Wed, 17 Nov 2021 17:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637171665;
        bh=zvad9MUkFW38ZqWgHyh0cb5juq9e2M0j2ExtsG6v/V0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BM6PBujIwdxf+1JWxaTY7DBjAKHkeXIDZwlWMqrMQ0pxy1hlxdTIwZMHATsNKs3FH
         IXk8dIHMZnplBlXXe89HRPhrhR08we2SPY8ezxjUlW3tHqlyDxUjgizkGbfDNgZVYA
         hEtMB7S8/PwcEt/Wr6uMxWxBNs2OjfaVcGjJzA8g=
Date:   Wed, 17 Nov 2021 18:54:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, wklin@google.com, mfaltesek@google.com
Subject: Re: Please apply commit 19221e308302 ("soc/tegra: pmc: Fix
 imbalanced clock ...") to v5.4.y
Message-ID: <YZVBzyilo5YjYQ9U@kroah.com>
References: <20211117143845.GA3996107@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117143845.GA3996107@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 06:38:45AM -0800, Guenter Roeck wrote:
> Hi Greg,
> 
> We see the following build warning/error in v5.4.160.
> 
> drivers/soc/tegra/pmc.c:612:1: error: unused label 'powergate_off'
> 
> The problem isn't that the label is left-over, the problem is
> that upstream commit 19221e308302 ("soc/tegra: pmc: Fix imbalanced
> clock disabling in error code path") is missing in v5.4.y. Please apply.

Now queued up, thanks.

greg k-h
