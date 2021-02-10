Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAAD3168AA
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBJOFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhBJOFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 09:05:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95B0A64E28;
        Wed, 10 Feb 2021 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612965899;
        bh=QrL3tHcjVKvTJDhd2yGtWEOvrJvx/0OQDO443ZqEEzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b9f0AKoPPd+6BEv5XQXqy8NQQuzi5Q/69dAjT7duo5hTHGyf+6dKU5MUXjXiHH6fx
         803+qYcN26oXH9P4OlP2M/eVgsnUtvZxGNJKapD8jnWZD0P/qbuDiCiPXLVEZGepVX
         D7wLf5Fsme4nqOFs9MWDDeK2cz7bbwNbr7Sc0BgY=
Date:   Wed, 10 Feb 2021 15:04:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, Jianlin.Lv@arm.com, rostedt@goodmis.org
Subject: Re: [PATCH 4.19.y v2] tracing/kprobe: Fix to support kretprobe
 events on unloaded modules
Message-ID: <YCPoCC/Cd/qEKliL@kroah.com>
References: <161295270391.312585.12986150404367194307.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161295270391.312585.12986150404367194307.stgit@devnote2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 07:25:04PM +0900, Masami Hiramatsu wrote:
> commit 97c753e62e6c31a404183898d950d8c08d752dbd upstream.

Thanks, all now queued up.

greg k-h
