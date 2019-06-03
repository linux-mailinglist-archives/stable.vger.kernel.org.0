Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463ED32A3E
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 10:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfFCIBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 04:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfFCIBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 04:01:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1E427D35;
        Mon,  3 Jun 2019 08:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559548899;
        bh=ROAQyZWhtymGPVTUIxt1+1WwCa2VVXeH5b59WE/rFNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DWfVPVc5B2lQtOSYNooof9+l1iXQHNHhu3JZpOm6VLiZmK9gr+I5rGdP7QS+MQjGF
         pWNE+4xTSatSrwRReWJpMuJQOSr3S80GJGs/YdT3VwwpJO0W1pIPgHMYR9Rtc3+zAu
         Xohgiz64mThup287uyZ7Az2oQtJHIM+tn4qAgeiA=
Date:   Mon, 3 Jun 2019 10:01:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Yaro Slav <yaro330@gmail.com>, stable@vger.kernel.org
Subject: Re: pstore backports to 4.14
Message-ID: <20190603080125.GG7814@kroah.com>
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

How about I wait until your fix is in Linus's tree before backporting
these?  They will also be needed in 4.19, right?

thanks,

greg k-h
