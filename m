Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760C943F7E0
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 09:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhJ2Hfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 03:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232211AbhJ2Hft (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Oct 2021 03:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29D8261130;
        Fri, 29 Oct 2021 07:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635492801;
        bh=eZCesR13DldsHR5s9AvI5Mfes8FBqKCHNHHUtHtJflk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r5/6YU+Xz3aRDNGlDlIshFq/bnEezW9x7yllK0G8N3HE/x5jq0lkEn1NVcf9vzQ6i
         QEOAvgokUTofZ1eodsnz1yluBh57zLhGN/nOE1QyU7bZN9arbwthVa6P9fldl61WYa
         uXHsW7wglv5nhAuFFTw8kvaGtysIZfTpPcSNwHyY=
Date:   Fri, 29 Oct 2021 09:33:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>
Subject: Re: ext4: fix possible UAF when remounting r/o a mmp-protected file
 system
Message-ID: <YXujv7dUe/Bc9A8C@kroah.com>
References: <264a42f3-0475-215d-aaa5-5deb435f8360@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <264a42f3-0475-215d-aaa5-5deb435f8360@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 01:13:30PM -0700, Tadeusz Struk wrote:
> Hi,
> Upstream commit id: 61bb4a1c417e5b95d9edb4f887f131de32e419cb
> 
> is still missing from stable 5.10 and syzkaller has found the gap:
> 
> https://syzkaller.appspot.com/bug?id=990c7f09780460b8165714b9c9751ae8432587f3
> 
> It should be applied to stable kernels: 5.10

Now queued up, thanks.

greg k-h
