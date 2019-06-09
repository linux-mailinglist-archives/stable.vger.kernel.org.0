Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E703A494
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfFIJuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbfFIJuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 05:50:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ACFA208E4;
        Sun,  9 Jun 2019 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560073807;
        bh=ReX7REDFkdTOqFV4wu5g/+cD2b8z8XgrO8MyBrRRpRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sicm7EFe3cRreXbRdAI6cSxTrAxBCo8nLQdtzwKqH8U+W0bCzrZffWR7LU7Q8Xyx4
         K5s9V3lk/jPnlPgrVOra4YHYLTne4WUsRgm2KVmikGm3uSZI+1KqeHWW0f9+/gDexB
         vykcyf1+BWvSBeiBbWFXSu0VD3rUrWfZ+3tDU5Vs=
Date:   Sun, 9 Jun 2019 11:50:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Yaro Slav <yaro330@gmail.com>, stable@vger.kernel.org
Subject: Re: pstore backports to 4.14
Message-ID: <20190609095005.GA20602@kroah.com>
References: <201905310055.F37C37E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201905310055.F37C37E@keescook>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 01:06:15AM -0700, Kees Cook wrote:
> Hi Greg,
> 
> Can you please add these two pstore fixes to 4.14 please? They are
> prerequisites for another fix I'll be sending to Linus soon that'll
> be needed in 4.14 (to fix the bug Yaro ran into).
> 
> b77fa617a2ff ("pstore: Remove needless lock during console writes")
> ea84b580b955 ("pstore: Convert buf_lock to semaphore")

These also were needed in 4.19, so queued up to both trees now, thanks.

greg k-h
