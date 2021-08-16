Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D293ED8E8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhHPO0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 10:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232136AbhHPO0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 10:26:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A1AA6108D;
        Mon, 16 Aug 2021 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629123951;
        bh=FzRXCnI/+DmzP/QAqCIadtAQAvDayP0+WSVvqGKYvY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QCbQhnDGuSQyErqUSoS+wxGbzO1o9C7sjVD1t2x9mqPHMy3i3UbtKjDt+sGk061t7
         atoAFUpYMQ57dAoCHcYsPepUYc8o+QHRJvQ+7ervEnIM0ybIF+AYdSCG74YVCDHet/
         6k8YlkRXPpX8ZZJ/fabsIpz3uyalxTtS2jPJTLP8=
Date:   Mon, 16 Aug 2021 16:25:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 5.12.y] KVM: nSVM: avoid picking up unsupported bits from
 L2 in int_ctl (CVE-2021-3653)
Message-ID: <YRp1bUv85GWsFsuO@kroah.com>
References: <20210816140240.11399-6-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816140240.11399-6-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 04:02:34PM +0200, Paolo Bonzini wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ upstream commit 0f923e07124df069ba68d8bb12324398f4b6b709 ]

This is not a commit id in Linus's tree :(

And 5.12.y is long end-of-life, take a look at the front page of
kernel.org for the active kernels.

thanks,

greg k-h
