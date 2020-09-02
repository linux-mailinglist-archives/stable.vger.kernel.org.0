Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACD425A6C2
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 09:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgIBH1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 03:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbgIBH1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 03:27:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B304F2072A;
        Wed,  2 Sep 2020 07:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599031663;
        bh=eEiAOxnUWzoHc78+GZUoOt2YeG3TFdfkLzmJE78Vccw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZlGhmSN/ibr4TOa3bebYaoOlu87Fe9VoznwdFjHB4JWwP/x7gPnbsNU38eY9uxh/M
         T/hqmlryYt902Hmvmq7Kg6QKVAxElP7iOx1MPyFKiWX8ZgYZOirlROgHi3o12LDj4f
         8Cc3CKamv/xA5WflQYIv5jzV+k3wk0NdhZDK8aI0=
Date:   Wed, 2 Sep 2020 09:28:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Fwd: [PATCH] io_uring: Fix NULL pointer dereference in
 io_sq_wq_submit_work()
Message-ID: <20200902072809.GB1610179@kroah.com>
References: <20200902015948.109580-1-yinxin_1989@aliyun.com>
 <be051730-4ffe-0907-65c3-ace0ce070e09@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be051730-4ffe-0907-65c3-ace0ce070e09@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 08:12:52PM -0600, Jens Axboe wrote:
> Hi,
> 
> Can you queue this for 5.4-stable? Thanks!

As I need to do a -rc2 for this version, I've now queued this up,
thanks.

greg k-h
