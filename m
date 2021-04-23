Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F9136959B
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242901AbhDWPHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243040AbhDWPHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B75DD61463;
        Fri, 23 Apr 2021 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190391;
        bh=j/NPnkYzQTbuETvdABAMr/hmote8rgWDGQYyg3go4bA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yKwOMAt1DBbqwCXqHtiL5C044I1DEpiDGfIF+fwKXGq0OkwAybWVAdJ2sPJyksfX+
         JP0kF36OEfNRfXTIeOgPF2Hu86JLFQ32Xvayw7RVjDxEyjZdk/3dtjINPLSIaSXIds
         y6a47JPDC7Aol5LyALzk5qAGN7KTn1yi0cak+YEE=
Date:   Fri, 23 Apr 2021 17:06:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: bpf: Add probe_read_{user, kernel} and probe_read_{user,,
 kernel}_str helpers
Message-ID: <YILidB5mlvXB12q8@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
 <cc783450-ee5e-c847-2e29-b18e8bd89491@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc783450-ee5e-c847-2e29-b18e8bd89491@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 04:08:19PM +0300, Zidenberg, Tsahi wrote:
> commit 6ae08ae3dea2cfa03dd3665a3c8475c2d429ef47 upstream

<snip>

Why was this commit sent twice?

thanks,

greg k-h
