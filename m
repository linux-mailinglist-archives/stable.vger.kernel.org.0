Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CD4BA173
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 10:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfIVIOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 04:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbfIVIOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 04:14:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73DA420830;
        Sun, 22 Sep 2019 08:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569140077;
        bh=Sddh5NZ+U1GIdh5WazzQKIVjWnv18VMZN5PN/kJ/AzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7z4noi8M6Ooigyv7kMMAuiBraprSTWIfe/N7wnDGojWynT9vOwokCYMXKZ+UkE5P
         mUPxl+BMPzJGdWNWzNGT4i6t6H4vPRBvcpB3zo6Qyox0YEJFJchSJ4iQ0NH8tzwKYo
         o3WA+QrlrJVUM2SmNC4YsLSk7UOt5AXwTxYbY1R4=
Date:   Sun, 22 Sep 2019 10:14:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>
Subject: Re: [PATCH 0/3] amdgpu DC fixes for stable
Message-ID: <20190922081434.GB2524798@kroah.com>
References: <20190920140338.3172-1-alexander.deucher@amd.com>
 <20190920141135.GA588297@kroah.com>
 <BN6PR12MB18092E39C33B29F34E93702FF7880@BN6PR12MB1809.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR12MB18092E39C33B29F34E93702FF7880@BN6PR12MB1809.namprd12.prod.outlook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 02:15:11PM +0000, Deucher, Alexander wrote:
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Friday, September 20, 2019 10:12 AM
> > To: Alex Deucher <alexdeucher@gmail.com>
> > Cc: stable@vger.kernel.org; Kazlauskas, Nicholas
> > <Nicholas.Kazlauskas@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>
> > Subject: Re: [PATCH 0/3] amdgpu DC fixes for stable
> > 
> > On Fri, Sep 20, 2019 at 09:03:35AM -0500, Alex Deucher wrote:
> > > This set of patches is cherry-picked from 5.4 to stable to fix:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=204181
> > >
> > > Please apply!
> > 
> > What stable tree(s) do you wish to see this applied to?
> 
> 5.3 and 5.2 would be great.  Thanks!

All queued up now, thanks.

greg k-h
