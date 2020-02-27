Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72241171703
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 13:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgB0MVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 07:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbgB0MVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 07:21:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B6C124693;
        Thu, 27 Feb 2020 12:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582806105;
        bh=HyQBtBzFFsIjOFZaLIhI8j9H5C3tI0DVSahDASWb5j8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PG0b3FXsKIzbilt+SZqOYSc4VtOyGHyReXhIeP0Cox3oJ9VKUliJXGE+IerjnbzG8
         jP/4rEC7Cit59qmt3Y69/TyFEGbI/7wmCDInmqE5iqiBfFNmpXCoEmP5n0WQ1DcRrS
         21IpgC3akOHIJaNIet1OaFkS+RqO7LMb0m0Z0PdY=
Date:   Thu, 27 Feb 2020 13:21:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bhawanpreet.Lakha@amd.com, Feifei.Xu@amd.com,
        alexander.deucher@amd.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amd/display: fix dtm unloading"
 failed to apply to 5.5-stable tree
Message-ID: <20200227122143.GA896418@kroah.com>
References: <1582805969210220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582805969210220@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 01:19:29PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.5-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Note, it applied, but broke the build :(
