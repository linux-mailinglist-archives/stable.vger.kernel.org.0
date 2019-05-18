Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD401221F0
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 09:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfERHAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 03:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfERHAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 May 2019 03:00:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E40216C4;
        Sat, 18 May 2019 07:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558162806;
        bh=fMUJJGZFtAxiTJX0hKgXymQmFFZCJoPdAlsyrqRZ3RY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pP/k6X+Sl2UQBFOuI1jQCQ87pxXutvL+Wf5vgi9A50nOHzKBNpHpoa24NE9dc3N3X
         HRONvTejTODG1vAo5pKcZOQnzo01RgO3SSa9sQh2dq0FbCGs8tKBp7u2YbZjbFMTNX
         i9LUpRuIFXkCVLNG4+IhR7dz0CXuQJAHqzL9Kvkk=
Date:   Sat, 18 May 2019 09:00:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.4,4.9,4.14] crypto: salsa20 - don't access
 already-freed walk.iv
Message-ID: <20190518070004.GG28796@kroah.com>
References: <20190517172558.56229-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517172558.56229-1-ebiggers@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 10:25:58AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit edaf28e996af69222b2cb40455dbb5459c2b875a upstream.
> [Please apply to 4.14-stable and earlier.]

Now queued up, thanks.

greg k-h
