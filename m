Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7884201F2
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 16:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhJCORM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 10:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhJCORI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 10:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C3E61B00;
        Sun,  3 Oct 2021 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633270521;
        bh=POD6hUJrDtD62teKhNkWnpjnDcNOyxwki9svbwjc0Uw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nym5VF/zZemfEWnFpzzUJlrTW5T7a9oarOYRrFpPwaCJb/8iVI8lAxV4hl6CQwdPa
         0JpXN0uKv7AKHcLEK6V2vONnCFofE+3KYwNlUUZoEXA30N3b0M7cUiZo9USUh8Ilz0
         Z/dzd+LgS1sBEdNAAmQ6w3/FtMrcf9xNskl/hUMQ=
Date:   Sun, 3 Oct 2021 16:15:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     dje@google.com, mathieu.desnoyers@efficios.com,
        pbonzini@redhat.com, pefoley@google.com, shakeelb@google.com,
        tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: rseq: Update rseq when processing
 NOTIFY_RESUME on xfer" failed to apply to 5.10-stable tree
Message-ID: <YVm69hXIo2j4bf82@kroah.com>
References: <1632660262120183@kroah.com>
 <YVIcAy/nf+0bBdqG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVIcAy/nf+0bBdqG@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 07:31:15PM +0000, Sean Christopherson wrote:
> On Sun, Sep 26, 2021, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> 5.10 backport sent: https://lkml.kernel.org/r/20210927192846.1533905-1-seanjc@google.comb

What about 5.14?
