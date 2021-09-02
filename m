Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCA13FE8C0
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 07:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhIBFgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 01:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhIBFgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 01:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 264FC610CC;
        Thu,  2 Sep 2021 05:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630560905;
        bh=HHbZCxZqUbJ+TgD0LYpgf4qHcGVfKhVUTUgHZl2aSo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T6u9wtRYw8reTCc7pbISkvNLwM2ZXCuItxRHQY0sfgnYAJIdhEns5o60jErfqspas
         iCvJCDxlFtgAz08vI+s6q9WqkUPVmOWkimC3LzEqkbp+a/ToURBdm0fhKQWTGqoczW
         yFtsIskxy4+HEGEZ7mzvv8v1QN+BVos3pwyrmL4U=
Date:   Thu, 2 Sep 2021 07:35:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     stable@vger.kernel.org
Subject: Re: Linux stable GitHub mirror stale
Message-ID: <YTBihMQq7H9vWazh@kroah.com>
References: <YTAL8S9qxfhsO/iG@relinquished.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTAL8S9qxfhsO/iG@relinquished.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 04:25:37PM -0700, Omar Sandoval wrote:
> Hi, Greg,
> 
> https://github.com/gregkh/linux seems to have gone stale. The last
> update was about 24 days ago. Do you know what might have happened
> there?

Yeah, my script acted up if one of the "mirrors" started failing, then
the remaining ones would stop being updated as well.  Should now be
fixed, thanks for letting me know.

greg k-h
