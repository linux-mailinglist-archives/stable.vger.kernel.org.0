Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426AAB6B39
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbfIRS4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 14:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387658AbfIRS4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 14:56:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D99222BD;
        Wed, 18 Sep 2019 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568832996;
        bh=VgF4oxnkm95abC04U+ZEJWH733Bi1oVy4TQp3hrbazQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DrrKUVaynHppU8RftJRmiED3I0GmjXAt16neo7L6j7CQl6M4zuSf79pznAOlT2zIe
         XD0Pm2REG84TYWgx0lBRC+C4Eavabpu+a0N9cwqtcqhQUKLEz1lrorJlxNS7qvM69B
         gP9b2SIe+ZvbGtjYYRhwIW7z7PeX/euxcnSMv1Uc=
Date:   Wed, 18 Sep 2019 20:56:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vineet Gupta <vineetg76@gmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <lkp@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        arcml <linux-snps-arc@lists.infradead.org>
Subject: Re: stable backport for dc8635b78cd8669
Message-ID: <20190918185633.GB1944551@kroah.com>
References: <efb68643-3750-e94b-8387-6e4cacb3a82a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efb68643-3750-e94b-8387-6e4cacb3a82a@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 10:40:32AM -0700, Vineet Gupta wrote:
> Hi Stable team,
> 
> Can we please backport dc8635b78cd8669c37e230058d18c33af7451ab1 ("kernel/exit.c:
> export abort() to modules")
> 
> 0-Day kernel test infra reports ARC 4.x.y builds failing after backport of
> af1be2e21203867cb958aace ("ARC: handle gcc generated __builtin_trap for older
> compiler")

So is this only needed in 4.9.y and 4.4.y?

thanks,

greg k-h
