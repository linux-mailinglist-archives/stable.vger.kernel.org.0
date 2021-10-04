Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35894209B9
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 13:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhJDLJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 07:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230200AbhJDLJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 07:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C36613A3;
        Mon,  4 Oct 2021 11:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633345685;
        bh=I583AJ68NUEWjIUOqqmUOoeFTHfU2mouUrYgZ8mgdX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rChq6nHClY7vj8hs5Z13q1TUmg7hspnNMJH//VLVMBBAVf3SmDyFUkRJPbINne2oy
         oMHWOOFSVnMeWuwxNJCe2CZWHYYrZAmQ9HWdIdZI63B9BSU2H+/9v/lM3DmsBNhZu+
         HQDMNF3r2kkfm8mP2bALqp/haIoDy/nMIH6KfJ00=
Date:   Mon, 4 Oct 2021 13:08:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH stable 4.9 v3 0/4] ARM: ftrace MODULE_PLTS warning
Message-ID: <YVrgkv30/BtCnHER@kroah.com>
References: <20210927210316.3217044-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927210316.3217044-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 02:03:12PM -0700, Florian Fainelli wrote:
> This patch series is present in v5.14 and fixes warnings seen at insmod
> with FTRACE and MODULE_PLTS enabled on ARM/Linux.
> 
> Changes in v3:
> 
> - resolved build error with allmodconfig enabling CONFIG_OLD_MCOUNT

All now queued up again.

thanks,

greg k-h
