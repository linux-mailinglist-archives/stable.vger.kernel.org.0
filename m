Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF1828FF34
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404688AbgJPHfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404687AbgJPHfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 03:35:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB01620829;
        Fri, 16 Oct 2020 07:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602833729;
        bh=TIuAAGJFE85yWiEpKpaxdkj7ig89kKScIs5nMstaDA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z+w6GSO6aSCH/pyPbtZnHjjJY0VJgZ+TH/8EVLvmP6IBQRyXcmW8sYw4/3zAmfI+t
         SLLFcFDwOGhv/9ZjzjBO9KzMXz/vLgXmo5+Ayyj2/+feXbuE+NtBH8az9p8DCL9k+d
         bQ1XHzkmuZl93yx8diz+m2KVU1jfCKC8xMhvIJ64=
Date:   Fri, 16 Oct 2020 09:36:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Cc:     linux-kernel@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, stable@vger.kernel.org
Subject: Re: [v5.8/bluetooth PATCH] Bluetooth: Disconnect if E0 is used for
 Level 4
Message-ID: <20201016073600.GC578349@kroah.com>
References: <20201015211124.1187822-1-hegtvedt@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015211124.1187822-1-hegtvedt@cisco.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 11:11:24PM +0200, Hans-Christian Noren Egtvedt wrote:
> From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> 
> E0 is not allowed with Level 4:

<snip>

Ok, I think I have queued up all of the backports you sent for bluetooth
now, thanks!

greg k-h
