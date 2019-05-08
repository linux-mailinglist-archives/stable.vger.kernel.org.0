Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A93E17B51
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 16:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfEHOGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 10:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfEHOGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 10:06:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C447920675;
        Wed,  8 May 2019 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557324408;
        bh=Xkzsie3FbQaGp4gy2CU9zdtI/NF6YHLpPdU2TmOh+cc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m+tLl/nMBRnTGqumubQ0zGvurU+x6oHfXi8kkZfcT7DkhebXLDj55++mdhy5VXgWm
         /ENMBPj7oXTscf7dF3Ao5yfmFX1eRn3R2NBogJm+MJAB6Dzqt+VYpl7Wvbw9bsv51K
         Pb0YvAsFtNrbGNPG9me5U93bWK2jsvJU49sJxDx0=
Date:   Wed, 8 May 2019 16:01:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Please apply commit b90cd6f2b905 to v4.19.y and earlier
Message-ID: <20190508140102.GA18939@kroah.com>
References: <41f58f37-314b-2f4e-441f-46961a2d7b88@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41f58f37-314b-2f4e-441f-46961a2d7b88@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 06:32:50AM -0700, Guenter Roeck wrote:
> Commit b90cd6f2b905 ("scsi: libsas: fix a race condition when smp task timeout")
> fixes CVE-2018-20836 [1]. Please apply to v4.19.y and earlier releases.

Queued up everywhere, thanks!

greg k-h
