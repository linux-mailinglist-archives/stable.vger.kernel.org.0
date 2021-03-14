Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC09933A366
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 08:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhCNHUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 03:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234322AbhCNHUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Mar 2021 03:20:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 538CA64E75;
        Sun, 14 Mar 2021 07:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615706429;
        bh=YmiP+MpyW8XPIaC+P/Q/0Iq5qqC9W1MJ3WaKYN5ls+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y9g71OO/X3hUvgnUgUmrnRDbjEsoQT8ssshFL9+q+oSPXSl4oZAAYC4z2RaAnEWL2
         5u/8agbReVzDUkxB1QM/ShB5KBEqgNp/TCcgnVW2y9QH8EuXyQ1U9DhTHzsLxzzY66
         4MTWgG0kHgZG7zJDXi0CqGuzjgJfT9FLWtixsAhY=
Date:   Sun, 14 Mar 2021 08:20:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anton Eidelman <anton@lightbitslabs.com>
Cc:     stable@vger.kernel.org, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de
Subject: Re: nvme: ns_head vs namespace mismatch fixes
Message-ID: <YE25OKl9g+cyl3iy@kroah.com>
References: <20210314040705.1357858-1-anton@lightbitslabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314040705.1357858-1-anton@lightbitslabs.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 13, 2021 at 08:07:03PM -0800, Anton Eidelman wrote:
> *This message is sent in confidence for the addressee 
> only.  It
> may contain legally privileged information. The contents are not 
> to be
> disclosed to anyone other than the addressee. Unauthorized recipients 
> are
> requested to preserve this confidentiality, advise the sender 
> immediately of
> any error in transmission and delete the email from their 
> systems.*

This text is not compatible with kernel development in public, email is
now deleted.
