Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A7E3FD709
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243733AbhIAJmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243736AbhIAJmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 05:42:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4AD360F3A;
        Wed,  1 Sep 2021 09:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630489282;
        bh=f3k2CHMiTBjqah7Li/8VLITq7G0/slCniOMbtoDpqIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zt0W1K9laG5wB/3Fo+giSLRaolQt5KL+JA+M8fpBeJBlDuzKgDac2FgrqTyXuflcD
         CwPy/9hj+OL6MUp5KIREmA0xx2owOsHA/m8xNCh8V7d5HJokjgrUwMq1J/U7AU5ctP
         URNyOiG5owlHxQ96Tgtdj8uFbpgCfXXMS9wLIlbQ=
Date:   Wed, 1 Sep 2021 11:41:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 4.14] KVM: X86: MMU: Use the correct inherited
 permissions to get shadow page
Message-ID: <YS9Kv10Y5ZS80qyF@kroah.com>
References: <20210820131229.3417770-1-ovidiu.panait@windriver.com>
 <b30ed8a7-8e5d-0ec5-ce22-f86cf850c424@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b30ed8a7-8e5d-0ec5-ce22-f86cf850c424@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 29, 2021 at 06:03:00PM +0300, Ovidiu Panait wrote:
> Hi,
> 
> 
> It seems that this backport missed the last 4.14 release, could it be
> considered for the next one?

Now queued up, sorry for the delay.

greg k-h
