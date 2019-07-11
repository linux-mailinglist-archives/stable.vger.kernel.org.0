Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D196265E3B
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 19:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfGKRKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 13:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbfGKRKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 13:10:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD8E921537;
        Thu, 11 Jul 2019 17:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562865000;
        bh=iqt11D3yYy4AyXEPP/ImIL22aAKhf2+50wIwpFS2uNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xRDR0CwgyJsMCxKNr6Unhfi3hvKuWYB4j8kk+bVHIsPuPXT1GiUuocBcKuWjamHzS
         Z84WmJ3FtFkYiTKXy+8xtlAHWEIhjOKsaO+wd4p0gMLh+evj5lFniFO+ShAmI1QFOg
         tsFItazz4SbnDrBopAjnunKTrmyrqDi1+tQnvDrM=
Date:   Thu, 11 Jul 2019 19:09:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Hongjie Fang <hongjiefang@asrmicro.com>
Subject: Re: [PATCH 4.9] fscrypt: don't set policy for a dead directory
Message-ID: <20190711170957.GC7544@kroah.com>
References: <20190711164148.230281-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711164148.230281-1-ebiggers@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 09:41:48AM -0700, Eric Biggers wrote:
> From: Hongjie Fang <hongjiefang@asrmicro.com>
> 
> commit 5858bdad4d0d0fc18bf29f34c3ac836e0b59441f upstream.
> [Please apply to 4.9-stable.]

4.9 and 4.4 patches now queued up, thanks!

greg k-h
