Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5641A4449
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 11:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgDJJLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 05:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDJJLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 05:11:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 499D0206F7;
        Fri, 10 Apr 2020 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586509873;
        bh=YpxlVmPYi+NSw+xpT2UWVm4utTIwhweYdVPnobktmNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gEyEuuipppc3t9Ldh2C9Hb9JtoteeiAeWYJBkYFmMRdBzeBHA+uF2XMlbnsUCeMNo
         VsI5ESQrGdBMQCK6aD0NlgOH6/WQa7JDglQIUG3xgnUQQR7SKmlLifuUTrw1ZnrPGG
         rQYl+pz8vME0uD39I6j1x0p1ly2S1F2lN+qkXeik=
Date:   Fri, 10 Apr 2020 11:11:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Sasha Levin <sashal@kernel.org>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: Re: [PATCH 5.4 1/2] ceph: remove the extra slashes in the server path
Message-ID: <20200410091111.GE1691838@kroah.com>
References: <20200408105844.21840-1-lhenriques@suse.com>
 <20200408105844.21840-6-lhenriques@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408105844.21840-6-lhenriques@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 11:58:43AM +0100, Luis Henriques wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> commit 4fbc0c711b2464ee1551850b85002faae0b775d5 upstream.

You forgot about 5.5.y :(

