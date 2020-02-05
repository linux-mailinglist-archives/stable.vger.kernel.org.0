Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3EF215339E
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 16:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgBEPGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 10:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgBEPGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 10:06:09 -0500
Received: from localhost (unknown [212.187.182.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E577A217F4;
        Wed,  5 Feb 2020 15:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580915168;
        bh=rtrVh0sqihSzBYosYZJUZNh6GwTvtj59e+FjqGSwKc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MqB1wnd1W9YMMaYltSVqsP1w92MM7DyZOxEQm7Yyf9vvXMOb/V3UtthdyTGklfTLX
         VWocG1EBn+V9183Yxpq0UCiWOVexehjpNGQZUZj7MQWo9GWZ05InTVSOeW5cGQtrVf
         EwSNaAceG6ijeD+8zJru7KuX9zrNFVFcL4sqh9A4=
Date:   Wed, 5 Feb 2020 15:06:05 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.18-stable review
Message-ID: <20200205150605.GA1236691@kroah.com>
References: <20200203161917.612554987@linuxfoundation.org>
 <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 06:37:38AM -0800, Guenter Roeck wrote:
> ---
> Building riscv:{defconfig, allnoconfig, tinyconfig} ... failed
> 
> Error log:
> arch/riscv/lib/tishift.S: Assembler messages:
> arch/riscv/lib/tishift.S:9: Error: unrecognized opcode `sym_func_start(__lshrti3)'
> [ many of those ]

Dropped the offending patch here, thanks.

greg k-h
