Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5571B34A826
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCZNdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhCZNc4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 09:32:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F01FA619C2;
        Fri, 26 Mar 2021 13:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616765576;
        bh=PAGq1kALaiGusgwXGDowM22BOWQx/23/PDLw7wmwLkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WdnZSM6m2go6T/RSqFvWA+wYCVSljgmdsa+st73E+v9oTml1PBtxQAKaUvmgkbSNe
         yB3eKzAd84UPTgP9XQpLu26UQcYCBfzFx6rSJHd9VJeXwcbmmFTyU2cjwh0pnt+VtT
         CWZ0k6G2JYBEZsIDnJuVVTmlukgtLjdvQoC1rJ1U=
Date:   Fri, 26 Mar 2021 14:32:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        John Youn <John.Youn@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>, stable@vger.kernel.org,
        #@synopsys.com, 4.18@synopsys.com, 5.2@synopsys.com,
        Felipe Balbi <balbi@ti.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH 0/3] usb: dwc2: Fix power saving general issues.
Message-ID: <YF3ihMf3cHESK0cq@kroah.com>
References: <20210326102400.359EFA005C@mailhost.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326102400.359EFA005C@mailhost.synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 26, 2021 at 02:23:58PM +0400, Artur Petrosyan wrote:
> This patch set is part of multiple series and is
> continuation of the "usb: dwc2: Fix and improve
> power saving modes" patch set.
> (Patch set link: https://marc.info/?l=linux-usb&m=160379622403975&w=2).
> 
> The patches that were included in the "usb: dwc2:
> Fix and improve power saving modes" which was submitted
> earlier was too large and needed to be split up into
> smaller patch sets. So this is the first series in the
> whole power saving mode fixes.
> 
> Each remaining patch set have dependency on previous set
> and will be submitted after each of them are integrated.
> 
> The series includes the following patch sets with multiple patches
> by below order.
>  1. usb: dwc2: Fix power saving general issues.
>  2. usb: dwc2: Fix Partial Power down issues.
>  3. usb: dwc2: Add clock gating support.
>  4. usb: dwc2: Fix Hibernation issues

You only sent 3 patches, not 4.

So this makes no sense to me, what am I supposed to do?

confused,

greg k-h
