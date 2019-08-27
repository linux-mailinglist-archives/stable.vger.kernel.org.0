Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002309DE85
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfH0HPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfH0HPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:15:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D446C206BF;
        Tue, 27 Aug 2019 07:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566890149;
        bh=XnI7L5iLMxMkMurRHf2DDJsO0eqeYD/5Fg/Rfv2wHro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OB2ll/qNjzNiFrwGgB2OvPx8KTbsq7ZdsciAKZxiU4/L/7JwKIB1pZul5AC/JACLk
         OkKwe1WN75sIZzb/vjvgXSojX5LKGrf6vOK+/7/2yxcsnjrNnigRwnkbsuei/l5HBu
         /3dncQ9aIOSB9iVJm8i31HRHG/D5DiBuyaGl4KwA=
Date:   Tue, 27 Aug 2019 09:15:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org, sashal@kernel.org,
        bristot@redhat.com, tj@kernel.org, lizefan@huawei.com,
        hannes@cmpxchg.org, juri.lelli@arm.com, rostedt@goodmis.org
Subject: Re: [PATCH 4.4.y v2] cgroup: Disable IRQs while holding css_set_lock
Message-ID: <20190827071546.GA2880@kroah.com>
References: <20190826185534.56945-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826185534.56945-1-zsm@chromium.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 11:55:34AM -0700, Zubin Mithra wrote:
> From: Daniel Bristot de Oliveira <bristot@redhat.com>
> 
> commit 82d6489d0fed2ec8a8c48c19e8d8a04ac8e5bb26 upstream.
> While testing the deadline scheduler + cgroup setup I hit this
> warning.

Now queued up, thanks.

greg k-h
