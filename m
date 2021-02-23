Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609D4322501
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 05:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhBWEuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 23:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhBWEun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 23:50:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873FF64E20;
        Tue, 23 Feb 2021 04:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614055803;
        bh=p+5nWh0Oxfc+zyfHWmZ2xOuFoBePfPAebKd83o/+1pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lsZp5zMTKlFrsnYU/p0hfm43kJsFZ0wqBU6AC1fvkx3rjyh0cX9ngqjohUXxEI6Ua
         Fz0fpzSBLueOjZol81I8OzT13jD3noCwnw7+tzcsFiu1Oob3Tea9ZI4OCS21cqT05F
         kPVPY9HthTu3UHTWn9fC+ltcohqs8tTy/63VJboo=
Date:   Tue, 23 Feb 2021 05:49:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5.10 03/29] vdpa_sim: store parsed MAC address in a buffer
Message-ID: <YDSJdmc/14/gmnJp@kroah.com>
References: <20210222121019.444399883@linuxfoundation.org>
 <20210222121020.153222666@linuxfoundation.org>
 <20210222195414.GA24405@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222195414.GA24405@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 08:54:15PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > commit cf1a3b35382c10ce315c32bd2b3d7789897fbe13 upstream.
> > 
> > As preparation for the next patches, we store the MAC address,
> > parsed during the vdpasim_create(), in a buffer that will be used
> > to fill 'config' together with other configurations.
> 
> I'm not sure why this series is in stable. It is not documented to fix
> anything bad. 

Please see https://lore.kernel.org/r/20210211162519.215418-1-sgarzare@redhat.com
