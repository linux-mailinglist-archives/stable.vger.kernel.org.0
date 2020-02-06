Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACF9153EEA
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 07:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgBFGzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 01:55:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727860AbgBFGzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 01:55:21 -0500
Received: from localhost (unknown [213.123.58.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A8E206CC;
        Thu,  6 Feb 2020 06:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580972120;
        bh=jgcG7WRCoEyib8ZxD6qKXDoWou3n8rPcDkpX9UiF1ag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VCfA/N7zefXEjT+bE6sNlI2e5X7JIs47pXSYO01iTqpsxrOXVwp+UlDF6nXFM9UZH
         tGdL+6EIGTwrlU9TRhxBJQEOa11lG9WSg2G9M2eo0bMBtMaFziJnfsGwqqUMZt0etq
         hND2rqHewvGe5hgVrqib2mpOf6ErAuyrf1uWdN9g=
Date:   Thu, 6 Feb 2020 06:54:18 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200206065418.GA3254676@kroah.com>
References: <20200205.150749.1633074676301319375.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205.150749.1633074676301319375.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 03:07:49PM +0100, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.5 -stable, respectively.

All now queued up, thanks!

greg k-h
