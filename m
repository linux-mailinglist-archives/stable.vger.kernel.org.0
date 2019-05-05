Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E780114218
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 21:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEET1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 15:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfEET1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 15:27:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD9420675;
        Sun,  5 May 2019 19:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557084456;
        bh=aAgyuKAcmoaq9tiYwAFhGoIslmf89n47ymuZ8M9c/lY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k7DzpxCF4e4XNqOEjLb1XnPqKQDNrmOeYnZiYmSey+uh9gaHuruOQhPkQXIYllwUc
         MeA5dWncoJKKyhMHWi4iiTij0rzi5BDLMPymov5BL/3lGy2tsjWSZFBOEnH2e5k7hv
         6kx1Y60/9zX18avOKphxratCpFRjLSXi1lJ54RPE=
Date:   Sun, 5 May 2019 15:27:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Malte Leip <malte@leip.net>
Cc:     gregkh@linuxfoundation.org, skhan@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: usbip: fix isoc packet num validation in get_pipe
Message-ID: <20190505192735.GC1747@sasha-vm>
References: <1557061272154142@kroah.com>
 <20190505175756.3skj7ecvknerazcm@alum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190505175756.3skj7ecvknerazcm@alum>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 05, 2019 at 07:57:56PM +0200, Malte Leip wrote:
>commit c409ca3be3c6ff3a1eeb303b191184e80d412862 upstream.
>
>Backport of the upstream commit, which fixed c6688ef9f297.
>c6688ef9f297 got backported as commit b6f826ba10dc, as the unavailable
>function usb_endpoint_maxp_mult had to be replaced. The upstream commit
>removed the call to this function, so the backport is straightforward.

I've queued this and the 3.18 version, thank you!

--
Thanks,
Sasha
