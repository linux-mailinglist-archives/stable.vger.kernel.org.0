Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8639B221EE
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 08:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfERG7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 02:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfERG7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 May 2019 02:59:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C61F52166E;
        Sat, 18 May 2019 06:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558162748;
        bh=EMhoVhwEkpVUM6D6phrDsnLhmaHk1mVb0othjVqYgA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0ZGVsWTsvoLO6zRCpwh1QY4NU1y1Lqv7KKOzvG/Mo0vie8++0YNC0enVLka0COW6
         Y9mYRZfDZ2SAdswg0F1jp/XLO5JUnu3KIvGY2zKevxZ4S/bDPZ25rbcHoos6F7rAVx
         FMLNJ0/dyz/hdBy02CYrvHMSQhaRK86CWsUsEB5w=
Date:   Sat, 18 May 2019 08:59:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.4] crypto: chacha20poly1305 - set cra_name correctly
Message-ID: <20190518065906.GF28796@kroah.com>
References: <20190517175003.118301-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517175003.118301-1-ebiggers@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 10:50:03AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 5e27f38f1f3f45a0c938299c3a34a2d2db77165a upstream.
> [Please apply to 4.4-stable.]

Now applied, thanks.

greg k-h
