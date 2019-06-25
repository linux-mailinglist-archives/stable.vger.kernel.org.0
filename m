Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D3525B4
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 09:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfFYH62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 03:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbfFYH61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 03:58:27 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B824820863;
        Tue, 25 Jun 2019 07:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561449507;
        bh=5A3PI1ZvVawj2tn0uQPXu99o3FBtD7mCo0iLFhT/uAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yCaeCAXpUd/+2S7eMgCzoHe56RK/WqHZs+5b2SMXPraJHV0NOfkrkKhdv9jCfYq3y
         E9vavlK6U9szaVBT2E44wCg2NONstkftewRAIk0xHp/XRqqHSoIzTN57V6T0oBXqNC
         yPbWQt1g+zasuxmlg6QpvT2MJN0O6oWu4LStt7YY=
Date:   Tue, 25 Jun 2019 15:57:18 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/uaccess: Introduce user_access_{save,restore}()
Message-ID: <20190625075718.GB2988@kroah.com>
References: <20190625073944.b7wnwuihhz5st67g@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625073944.b7wnwuihhz5st67g@linutronix.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 09:39:45AM +0200, Sebastian Andrzej Siewior wrote:
> Please backport commit e74deb11931ff682b59d5b9d387f7115f689698e to
> stable _or_ revert the backport of commit 4a6c91fbdef84 ("x86/uaccess,
> ftrace: Fix ftrace_likely_update() vs. SMAP"). It uses
> user_access_{save|restore}() which has been introduced in the following
> commit.
> 
> I stumbled upon it in latest v5.0 tree and verified that v5.1.15 is also
> affected. For reference, the commit I'm asking to backport.

Sasha, I think the commit should just be reverted, can you do it?

thanks,

greg k-h
