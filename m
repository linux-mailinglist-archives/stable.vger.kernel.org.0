Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72F1FAFFC
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 14:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgFPMQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 08:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgFPMQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 08:16:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B8AA207C4;
        Tue, 16 Jun 2020 12:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592309767;
        bh=43Vs6jCcZl/pQK5si4FWccww2N6eI4JpVWYpdLn5Zm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H70wjgpBYsb0+NYqxRGP+ZlZHLYokEEVeGisMnGKVkJI3SnaF30p2+aQ5Z6aahAsd
         ApLe50FXvnuZ1e5dgD21jJ7DVkzNcD88InsRjI45WqOUsC6BQQqaRIm0CQVHc2T3NQ
         ShitAd0OA+d47fcz8dyiG8/64W/lBTizUZzJtTnw=
Date:   Tue, 16 Jun 2020 14:16:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mattia Dongili <malattia@linux.it>
Cc:     stable@vger.kernel.org
Subject: Re: sony-laptop fix for 5.6 and 5.7
Message-ID: <20200616121601.GC3542686@kroah.com>
References: <20200607035055.GA8646@taihen.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607035055.GA8646@taihen.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 07, 2020 at 12:50:55PM +0900, Mattia Dongili wrote:
> commit 95e2c5b0fd6d7a022f37e7c762ea093aba7b8e34 upstream

I do not see that commit id in Linus's tree.  Are you sure it is
correct?

thanks,

greg k-h
