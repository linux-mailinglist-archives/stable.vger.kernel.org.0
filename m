Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB0941446C
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 11:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhIVJEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 05:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233792AbhIVJEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 05:04:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8307D611C9;
        Wed, 22 Sep 2021 09:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632301387;
        bh=8gP/u9N5huICEkUnE4kaEm5HMqw1gmGxSmQ3669TcMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VpmXvImnymWxG55MsznoyJshUYpglt+Q1vMoMhJxajN0kg0lMM8JrYM28VWcxXdvl
         5LcGDVLl+cs4DBok+0pGGpYsPtD0VvxUn3iPdn/eDZbyXtvh0uIKU+b+vq4JEuwuYZ
         d9xNMAUI9CVaS++5NBQDvM6tnxvt8iNxmdlsBFwo=
Date:   Wed, 22 Sep 2021 11:03:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Roman Bacik <roman.bacik@broadcom.com>,
        Bharat Gooty <bharat.gooty@broadcom.com>,
        Abhishek Shah <abhishek.shah@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 082/122] PCI: of: Dont fail
 devm_pci_alloc_host_bridge() on missing ranges
Message-ID: <YUrxSFInrltkGh1j@kroah.com>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163918.481485606@linuxfoundation.org>
 <20210921213456.GB29170@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921213456.GB29170@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 11:34:56PM +0200, Pavel Machek wrote:
> Hi!
> 
> There is something is wrong with the Subject. Commit says "Don't", but
> subject says "Dont". It confused me for a while.

Odd, the patch says "Don't", perhaps git send-email doesn't like that in
a subject line.

greg k-h
