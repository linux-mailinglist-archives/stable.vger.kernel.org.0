Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C982DBDE5
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 10:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgLPJpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 04:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLPJpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 04:45:47 -0500
Date:   Wed, 16 Dec 2020 10:46:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608111906;
        bh=seQggb4utKwClqFIasDCuqvix7gXeYYsNkHFzZNp+qM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=qb732cSp4pe5jCq2Hn4t3oPjzycBN8Crjyd2kc4ptYDsrOuLcHNqmN+vHz1fqQPmH
         TdnkrJSh/33c0VR3EzP/yblY8/wh9aWtNxhVNfTwqnlwuklQAZHF72xkttT/3+Pxzr
         KukF6KzI7YdlaLMzvjpinGJKB0JU5kcFipjuKDmY=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>, stable@vger.kernel.org
Subject: Re: [PATCH V2] kvm: check tlbs_dirty directly
Message-ID: <X9nXX4h1mkcu0mw4@kroah.com>
References: <ea0938d2-f766-99de-2019-9daf5798ccac@redhat.com>
 <20201215145259.18684-1-jiangshanlai@gmail.com>
 <X9kEAh7z1rmlmyhZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9kEAh7z1rmlmyhZ@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 10:44:18AM -0800, Sean Christopherson wrote:
> Note, you don't actually need to Cc stable@vger.kernel.org when sending the
> patch.  If/when the patch is merged to Linus' tree, the stable tree maintainers,
> or more accurately their scripts, will automatically pick up the patch and apply
> it to the relevant stable trees.
> 
> You'll probably be getting the following letter from Greg KH any time now :-)

Nope, this was fine, I don't mind seeing the patch before it hits
Linus's tree (or any tree) at all.  It lets me know what to look out
for, nothing was done incorrectly here at all from what I can tell.

thanks,

greg k-h
