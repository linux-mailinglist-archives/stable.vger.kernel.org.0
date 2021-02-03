Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED34B30DA32
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 13:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhBCMvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 07:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhBCMtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 07:49:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5074764F8D;
        Wed,  3 Feb 2021 12:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612356522;
        bh=8hGvr6jFsmCSlE/7YH5A3ALtgvskzsxjpIeahvOLffo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=b3SwI7l6LTjhoWZMAv8Ulcyo2DZGc/hVAHp0txsB2u/GWng79g1w6x2fVmlmndsJi
         sJTcAwpMmlCwTp98nfEjQ5+lbf+anh7ZNn7rGPtdUaJEb8qqUKvBhr0Ic9oQczU5ya
         5xRIr9IA0o2KxSOTAKs2I5eXIqpmcn4ZSrJKQf41QAg7Tdrt1BvGMjxFEzG6tE/6T3
         9WAhiZVabav013ewV3G9CLXUFcRU5/UEph+zAHdqi9sQVms+PRywDoENLs+d4Dz/Dc
         cjG2nyqe/XRfUDofxU5fmTl3Uq4uK0HULZoznH/vkGmw9LI9je0ZK47jkhkVjLToev
         RxkwEq2IyQOpw==
Date:   Wed, 3 Feb 2021 06:48:40 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     =?utf-8?B?5ZCz5piK5r6E?= Ricky <ricky_wu@realtek.com>
Cc:     "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] misc: rtsx: modify rts522a init flow
Message-ID: <20210203124840.GA188081@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c836b619b5da47c69165a738d7200014@realtek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 03:13:58AM +0000, 吳昊澄 Ricky wrote:
> > -----Original Message-----
> > From: Bjorn Helgaas <helgaas@kernel.org>
> > Sent: Tuesday, February 2, 2021 8:28 PM
> > To: 吳昊澄 Ricky <ricky_wu@realtek.com>
> > Cc: arnd@arndb.de; gregkh@linuxfoundation.org; yuehaibing@huawei.com;
> > ulf.hansson@linaro.org; bhelgaas@google.com; linux-kernel@vger.kernel.org;
> > stable@vger.kernel.org
> > Subject: Re: [PATCH] misc: rtsx: modify rts522a init flow

> > > Cc: stable@vger.kernel.org
> > 
> > Per https://www.kernel.org/doc/html/v5.10/process/stable-kernel-rules.html
> > (option 1) this is sufficient.  You should not include stable@kernel.org in the
> > cc: list above.
> 
> I am not very clear, I want this patch to Stable tree, so I added this Tag(Cc: stable@vger.kernel.org)
> If I remove this Tag, it means this patch not go to Stable Tree?

Never mind, please ignore my comment.  I think I was mistaken.

Bjorn
