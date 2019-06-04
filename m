Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AF5340A3
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfFDHsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfFDHsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:48:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF0F24CCA;
        Tue,  4 Jun 2019 07:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559634482;
        bh=ic6CL+NMEbKnzoYA7Whb96/XW4ss/ooqGm4TAVSDmLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ld3Q5rut9lJgupvlm6oFHyzGDHyIoOVjXfhESS1+MV3GC39ec905xmOWq7mm/cLF3
         iGLC2JD6BKYIV8Rlj7ebLzFCeLmI1k0QbVtpRvX7IGQlXyAK8Db901Av2WFlrVrKJP
         xqVhaAmzTwrXPLBeIXSxGaq+wfnR60l0Oaxm0B6U=
Date:   Tue, 4 Jun 2019 09:48:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Sparc
Message-ID: <20190604074800.GB6840@kroah.com>
References: <20190603.133826.250539503495002779.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603.133826.250539503495002779.davem@davemloft.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 01:38:26PM -0700, David Miller wrote:
> 
> Please queue up the attached sparc64 bug fix to all active -stable
> branches.

Now queued up, thanks.

greg k-h
