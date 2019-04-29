Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA7BDFAE
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfD2Jnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727351AbfD2Jnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 05:43:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45E4A2075E;
        Mon, 29 Apr 2019 09:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556531012;
        bh=aSHmGzzq/V1JxyY2tqNTpgwP94DZg2qxTfI03dMWZtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ahGBurIgPWOS3WsQsutYLZ5WEdIWgNAgGce5qJR6KDIJp5dSb24myXD0gOAdJWQIG
         +BWmrv9xwZQd/j4Tm5eXFQAVnyq/0T9I16m+hpniR1B6mYQCqDSehqAHTlVCM9Ms3a
         eHQIf9wAQkc8/+em7W3Qy27EqfYPJ2Ne+rQA8YnY=
Date:   Mon, 29 Apr 2019 11:43:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org,
        diana.craciun@nxp.com, msuchanek@suse.de, npiggin@gmail.com,
        christophe.leroy@c-s.fr
Subject: Re: [PATCH stable v4.4 00/52] powerpc spectre backports for 4.4
Message-ID: <20190429094330.GA30526@kroah.com>
References: <20190421142037.21881-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190421142037.21881-1-mpe@ellerman.id.au>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 22, 2019 at 12:19:45AM +1000, Michael Ellerman wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi Greg/Sasha,
> 
> Please queue up these powerpc patches for 4.4 if you have no objections.

All now queued up, thanks.

greg k-h
