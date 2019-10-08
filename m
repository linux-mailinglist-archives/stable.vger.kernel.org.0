Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E170D0023
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfJHRsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfJHRsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 13:48:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CB36206B6;
        Tue,  8 Oct 2019 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570556880;
        bh=h9Hb+tm14uBMlcm8CMxUsJoQmyndBLAzSeWq6AloG1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bkKqHEXhZTvKxp9Jryyc3lJ5MJMBnCl33MXL5dRellXKcDpp6ZTUJ9SkQh4BD0bQL
         +05D8Q+ujNV1x8mQeyt0+mNKWdVf+1k/chseIsY15bGpAtka5ctQo8k8OySB8exfwG
         y0ngHfKociP8fwNSllO1O5dlOZX/HK/6R7SPWyzU=
Date:   Tue, 8 Oct 2019 19:47:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     dchinner@redhat.com, stable@vger.kernel.org, srostedt@vmware.com,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [4.9.y PATCH] xfs: clear sb->s_fs_info on mount failure
Message-ID: <20191008174758.GA3013565@kroah.com>
References: <1569965031-30745-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569965031-30745-1-git-send-email-akaher@vmware.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 02:53:51AM +0530, Ajay Kaher wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> commit c9fbd7bbc23dbdd73364be4d045e5d3612cf6e82 upstream.

You have sent a 4.4.y and 4.9.y, but what about 4.14.y?  I can't take
this patch for the older kernels without a 4.14.y patch, sorry.  We
don't want anyone to upgrade and then hit a fixed bug.

thanks,

greg k-h
