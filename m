Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105B21A4454
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 11:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgDJJOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 05:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDJJOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 05:14:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B2E206F7;
        Fri, 10 Apr 2020 09:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586510052;
        bh=PTZBy+t6fKfHwGwwwUASVhbIbdAP1k2z3aDuQjx3OoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wCWK8uNf2+0P4p9pgt4skgm2ZpoGwLNMkmU3jI7f6jdWc58duWB7ebK7tjKCff4Bl
         SB5WcBrglEAqDwmlR3MfsTukCIPIEsOWfcJicoaIgAR8egxN9ujL40Hn2nGxFRPJPk
         62wqb5sFQV8R0MbgWFmQaBMtwCE3K0b/gB6cKOUI=
Date:   Fri, 10 Apr 2020 11:14:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Sasha Levin <sashal@kernel.org>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/2] stable CephFS backports
Message-ID: <20200410091410.GF1691838@kroah.com>
References: <20200408105844.21840-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408105844.21840-1-lhenriques@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 11:58:38AM +0100, Luis Henriques wrote:
> Hi!
> 
> Please pick the backports for the following upstream commits:
> 
>   4fbc0c711b24 "ceph: remove the extra slashes in the server path"
>   b27a939e8376 "ceph: canonicalize server path in place"
> 
> They fix an ancient bug that can be reproduced in kernels as old as 4.9 (I
> couldn't reproduced it with 4.4).

All now queued up, including for 5.5.y, thanks.

greg k-h
