Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9192F2FBB15
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 16:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbhASPXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 10:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbhASPXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 10:23:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5392E22D2A;
        Tue, 19 Jan 2021 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611069786;
        bh=pqyZ0jdGM2NW4JqDQHaY/YHHjqBTFdzRAExrriAwkf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E93roEyk0HlKAwPu8VnBBSpf9m7sK2vnrtivH4G7zrhcNzqWOCv5vJECButDO1tLe
         Km5YMNt5EO3+cnrS7Ydo2Qw32jytvvsI25+W5xRrnTweCo6GYrDDEgiIzcDAdwOBLO
         zWH0R/Qur3RBxtFnIFYxKJorEOZkbYMYssXaC4Lc=
Date:   Tue, 19 Jan 2021 16:23:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arthur Borsboom <arthurborsboom@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v2] xen-blkfront: allow discard-* nodes to be optional
Message-ID: <YAb5WHSglwumI77O@kroah.com>
References: <20210119105727.95173-1-roger.pau@citrix.com>
 <20210119123622.zweul6uqfg54erj3@Air-de-Roger>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210119123622.zweul6uqfg54erj3@Air-de-Roger>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 01:36:22PM +0100, Roger Pau Monné wrote:
> Forgot to Cc stable for the Fixes tag. Doing it now.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
