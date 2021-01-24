Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF67301AEE
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 10:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAXJwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 04:52:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbhAXJws (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 04:52:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D2EE22ADC;
        Sun, 24 Jan 2021 09:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611481925;
        bh=OztNuqTmhiYMZ7ywXbRxNWCXp2fVQvn+H7ZK7FksmpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SbFfuC48zou3y9J5RWgci42MxXBsNg+7xGMODp3HqodWky8nJhIyadUox/JfTwIw4
         S+KtwVEQSdncnpqGQqCMpP7CJr0VCVcXp5c1AodubdNObJHcuYChc+skpptPScKtsw
         zWOOKfsv84JjTIBgaPbqqnQJ8v8/dHSEX4vlPFS8=
Date:   Sun, 24 Jan 2021 10:52:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     paul@crapouillou.net, vkoul@kernel.org, kishon@ti.com,
        zhouyanjie@wanyeetech.com, aric.pzqi@ingenic.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PHY: Ingenic: Fixes: compile phy-ingenic-usb only if
 it was enabled
Message-ID: <YA1DQY0Bp+lHnjTq@kroah.com>
References: <20210124094249.51591-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124094249.51591-1-hqjagain@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 24, 2021 at 05:42:49PM +0800, Qiujun Huang wrote:
> We should compile this driver only if we enable PHY_INGENIC_USB.
> 
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
> v2:
> Add a Fixes:tag and Cc linux-stable

I don't see a Fixes: tag here :(

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
