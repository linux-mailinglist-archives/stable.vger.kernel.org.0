Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF2A415C05
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 12:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbhIWKgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 06:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhIWKgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 06:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C6260E08;
        Thu, 23 Sep 2021 10:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632393306;
        bh=/oMcB38peSEm5eJWmjgTEgvUZiehyV7psg1RYfGdza8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZKhO04fNm+sOi0gW2ikgeY6r9ERaQ2RU2HKN/lIEMTDkptCA6nkWxC6kZyVDB5Yyg
         8cZieSr3Bl0gYXTaql23k2S7KXUBeV0yoCSFZyA3rAHG8vE+RyOvdwTOcboZ4T+dK9
         cg0BR5aOwyne+RYp0AoUsTaP6gMRZ33p/X37IO34=
Date:   Thu, 23 Sep 2021 12:35:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH stable 4.9 v2 0/4] ARM: ftrace MODULE_PLTS warning
Message-ID: <YUxYV/m36iPuxdoe@kroah.com>
References: <20210922170246.190499-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922170246.190499-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 22, 2021 at 10:02:42AM -0700, Florian Fainelli wrote:
> This patch series is present in v5.14 and fixes warnings seen at insmod
> with FTRACE and MODULE_PLTS enabled on ARM/Linux.

All now queued up, thanks.

greg k-h
