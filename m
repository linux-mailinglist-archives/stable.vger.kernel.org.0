Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F5D3959E7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhEaLyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhEaLyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 07:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E551160FEB;
        Mon, 31 May 2021 11:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622461947;
        bh=hYS95Qb8RPzCbALywlrdQD2RJ+jdlY8i4+sesJjapTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cBx5gvBVQicwDJ/x9Q3MWV3tQi/TWjZWfuLhIQP5yS5mSTfvxLO0by051j8nVEKch
         dSkY9LpkVBz6OcUDzdRut2jfQaSIPt0rtgZJjPCxPC70ln70VaTlOp8jRBzdC1yVtq
         J+4wYSscWrNvbsSe4PabygKOu+FAxEV9Uqth6eOY=
Date:   Mon, 31 May 2021 13:52:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2 | stable v5.4+ 0/3] x86/kvm: fixes for hibernation
Message-ID: <YLTN+IeJ9d42N4sL@kroah.com>
References: <20210531110053.14640-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531110053.14640-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 01:00:50PM +0200, Krzysztof Kozlowski wrote:
> Hi,
> 
> This is version 2 of aa backport for v5.4+.

Patch 3 does not apply to 5.12.y, so perhaps you need 3 series of
patches here?

And patch 1/3 looks about half of what is in Linus's tree, are you sure
about that?

thanks,

greg k-h
