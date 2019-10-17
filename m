Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002FFDB5D0
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406598AbfJQSVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406489AbfJQSVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 14:21:34 -0400
Received: from localhost (unknown [192.55.54.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C25920854;
        Thu, 17 Oct 2019 18:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571336493;
        bh=6VXGQ2Hba2UkWGqz9XmJOchSLmrxQVxSPAfCJ4c9SR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vBzfXQngTE7c5pH4Ctz3+daPMLHmgd5K2PHrGqtjRsMgesUc3PI7AgBgcPaLJVrNu
         JTXrDhJwUAp3chRxDsTujr3v8aVgbIvei322ZgtgxVAYTsQM1G8XnsC7b1VBAUiK+a
         z1GRbfxKc+cg/wt678tQOPm6H7r4KLrCCRMJr2zg=
Date:   Thu, 17 Oct 2019 11:21:32 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
Message-ID: <20191017182132.GA1095858@kroah.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191017180432.GE29239@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017180432.GE29239@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 11:04:32AM -0700, Guenter Roeck wrote:
> On Wed, Oct 16, 2019 at 02:49:52PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.7 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 391 pass: 391 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
