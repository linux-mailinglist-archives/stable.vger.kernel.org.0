Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E83F2D5AD6
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 13:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgLJMtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 07:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbgLJMsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 07:48:54 -0500
Date:   Thu, 10 Dec 2020 13:49:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607604494;
        bh=ur76zKCAva2ixqFVH7Ip3qvitsbakId0zleFhu1U6g8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=U9qodzzMfO/6u1KNAEcK243vRC+X7R00jLz8OOUgjkBEovKkVisKwbDDA0WjNviEA
         Lk39lH8jBw9AlmJR68uTrw2wyc9mfKhI//jeNQ+HXvIsiRiljoN7Q/1ZDqGpEXrfnZ
         c/mkE0r+lcQDpdgdQNyT6HtUsCPFk3vNzfuwvPcM=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Fix userstacktrace option for
 instances" failed to apply to 4.4-stable tree
Message-ID: <X9IZWcMVpAyBfTFQ@kroah.com>
References: <16075030712612@kroah.com>
 <20201209121938.50430114@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209121938.50430114@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 12:19:38PM -0500, Steven Rostedt wrote:
> 
> This should be the fix for 4.4.

All now queued up, thanks for the backports.

greg k-h
