Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0895EAECEA
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 16:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbfIJOZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 10:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbfIJOZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 10:25:33 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 727CD20863;
        Tue, 10 Sep 2019 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568125532;
        bh=Nbzny/yDkm0sjw7EzZG5BiIYeL502qvWnE4uTPYnM+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TBshlNE2S/CQswJWYj6gBHnnyG5uaT586SPjpcWeC5FHhZFnoQhqwJAUNt8oRfL1B
         voHVwdOKCnnK1eDh93tw3YjFLBsY4KRb2EbzZoY1psYYrkJ0LYtz4l3ii0vqFpJFwn
         ZXMEATEhsA1R5cikdOiNPnunP0xRl6M53HyVeWz4=
Date:   Tue, 10 Sep 2019 15:25:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        xiyou.wangcong@gmail.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au
Subject: Re: [v4.14.y, v4.9.y] xfrm: clean up xfrm protocol checks
Message-ID: <20190910142530.GA3362@kroah.com>
References: <20190909195457.56783-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909195457.56783-1-zsm@chromium.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 09, 2019 at 12:54:57PM -0700, Zubin Mithra wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> 
> commit dbb2483b2a46fbaf833cfb5deb5ed9cace9c7399 upstream.

Thanks for the backports, now queued up.

greg k-h
