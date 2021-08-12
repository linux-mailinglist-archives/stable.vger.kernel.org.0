Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E343E9ED6
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 08:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhHLGuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 02:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhHLGuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Aug 2021 02:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19F461019;
        Thu, 12 Aug 2021 06:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628751026;
        bh=c+4J0FBEXZ/2tJWPz7C9GfE7YiH9bbjcw8SPYAJS6ro=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=GJ0TZ7WtpRHEqU1S1DGcFW6ofointi9Ktt2jnsFJ9MuJk9kmCdalPbTE4K+kGUop5
         TRMDRvP7ty7D4KjrBIteDDIr0Yaq9ei88ekggTyNBe+XCJeom8qz8Y38G6nxGM8iu0
         4r3mOwaUFy0vE6OZG+vCFrOlDA8mbR6zyUxBZ9pGZiIKJJ3uWzwGzTmimU/14q17RY
         7RcirRQ7Nq2hx2WFJTVX9d5o2tpsh88QJhItKHtFqiAmPXmyxw/MxRen3f6Kk32oV/
         W1IePoKNBNSUdIDtg6mU5M+8XQmzj2TZLLUmGTYQcVHQkDlOsbafrMo650ccj2iu/a
         MSgnM/nyzex3g==
References: <1628739182-30089-1-git-send-email-chunfeng.yun@mediatek.com>
 <1628739182-30089-2-git-send-email-chunfeng.yun@mediatek.com>
User-agent: mu4e 1.6.2; emacs 27.2
From:   Felipe Balbi <balbi@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Laszczak <pawell@cadence.com>,
        Al Cooper <alcooperx@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Eddie Hung <eddie.hung@mediatek.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/6] usb: mtu3: fix the wrong HS mult value
Date:   Thu, 12 Aug 2021 09:49:36 +0300
In-reply-to: <1628739182-30089-2-git-send-email-chunfeng.yun@mediatek.com>
Message-ID: <87pmujyx5f.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Chunfeng Yun <chunfeng.yun@mediatek.com> writes:

> Use usb_endpoint_maxp() and usb_endpoint_maxp_mult() seperately
> to get maxpacket and mult.
> Meanwhile fix the bug that should use @mult but not @burst
> to save mult value.

I really think you should split this into two patches. One which *only*
fixes the bug and another (patch 2) which *only* corrects the use
usb_endpoint_maxp()

-- 
balbi
