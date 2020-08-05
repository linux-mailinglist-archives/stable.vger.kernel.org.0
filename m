Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5279223C637
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 08:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgHEGtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 02:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgHEGtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 02:49:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D182076E;
        Wed,  5 Aug 2020 06:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596610146;
        bh=nHAdrx5BZZZITabV/RKNvd/itEpnrjcyUmBvqr6Fl5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bwz3bu2iG3iiMcBRs9r5afBH2UVQIUEkFc3seAdFRDMmz+ga07ZJViK92JUauY8/d
         GgHQg1OMy3zTF24HnOBrO8aWhvPlcNpsSisD0MKJYiohKhjERkgxG54YLmocvV14Gz
         XCJh+16G1QWlFmCPzGA+6x80BoypqVg76/4/NVg8=
Date:   Wed, 5 Aug 2020 08:49:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Stable <stable@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] smb3: Incorrect size for netname negotiate context
Message-ID: <20200805064924.GB608152@kroah.com>
References: <CAH2r5mudEo8bmFMrq-9hsbKrBVbJKV0he7OyocYsbrN2cSy61A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mudEo8bmFMrq-9hsbKrBVbJKV0he7OyocYsbrN2cSy61A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 10:22:24PM -0500, Steve French wrote:
> commit df58fae72428b "smb3: Incorrect size for netname negotiate
> context" (patch was added in 5.4) turns out to be more important than
> we realized (fixing a feature added in 5.3 by commit 96d3cca1241d6
> which sends the "netname context" during protocol negotiations).
> 
> commit df58fae72428b should be cc:stable for 5.3

5.3 is long end-of-life and not around anymore.  See the front page of
kernel.org and https://www.kernel.org/category/releases.html for the
list of older kernels that are currently under maintance.

So there's nothing I can do with this, sorry.

thanks,

greg k-h
