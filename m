Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57872176F99
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 07:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgCCGna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 01:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgCCGna (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 01:43:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3891C214D8;
        Tue,  3 Mar 2020 06:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583217808;
        bh=/seh9noA2y+G4uU2rgQplJ4w7I9eSkw1HnEqO5vOnKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=spc1dZWeT41qg9B1TCdwjlko7tBXO2Mxgc//mpaCkVlyBxFZZi/N8r5nqHDj96Heo
         HDUnqj5MZWszVExWE8ZSFCsrc/2KMoxhtPf/LhswQyuM9K28sogZhBp5yDp+uPDitY
         3/jN7p/1gyZyJuQDKxRBqpyoB+Bgy6+0/Cy1h73o=
Date:   Tue, 3 Mar 2020 07:43:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        ecryptfs@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH 4.4, 4.9, 4.14] ecryptfs: Fix up bad backport of
 fe2e082f5da5b4a0a92ae32978f81507ef37ec66
Message-ID: <20200303064326.GA1105859@kroah.com>
References: <20200302203912.27370-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302203912.27370-1-natechancellor@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 02, 2020 at 01:39:13PM -0700, Nathan Chancellor wrote:
> When doing the 4.9 merge into certain Android trees, I noticed a warning
> from Android's deprecated GCC 4.9.4, which causes a build failure in
> those trees due to basically -Werror:

<snip>

Thanks for this, now queued up.

greg k-h
