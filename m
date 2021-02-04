Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0E530F5DF
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 16:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhBDPLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 10:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236973AbhBDPKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 10:10:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AA1464F45;
        Thu,  4 Feb 2021 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612451373;
        bh=tkDlMHHqepzeM0VrJlPfGZnG/uafYoFSoRP87UG4zOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tMKiBCwE5AGlR/j1Mhq1+kmov4KNb01ba3qUignkjX2tDYZw02Y/kpINTGQEpDAzy
         ATMd3G5gf+HUdLkyIlyRBSNzuEzoKxz8BIxlj6qrbEPmvuObiR7TT8YFUPo9VJTBi8
         9ecKkRP1YZtbL0LOV8qZ7qtzMxkcXaHk3ig//5Y0=
Date:   Thu, 4 Feb 2021 16:09:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Enke Chen <enkechen2020@gmail.com>
Cc:     stable@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        ncardwell@google.com, enchen@paloaltonetworks.com
Subject: Re: FAILED: patch "[PATCH] tcp: make TCP_USER_TIMEOUT accurate for
 zero window probes" failed to apply to 5.4-stable tree
Message-ID: <YBwOKp29Nby9OtJV@kroah.com>
References: <1612271736170158@kroah.com>
 <CANJ8pZ9z+2+2NnKz+67Dip8SEPhAD-87xVhNyJo0yk2aksQR4A@mail.gmail.com>
 <20210203012225.GA2913@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203012225.GA2913@localhost.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 05:22:25PM -0800, Enke Chen wrote:
> Hi, Greg:
> 
> Attach is the ported patch for the 5.4-stable tree.

Now applied, thanks!

greg k-h
