Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B778B13D459
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 07:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgAPGai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 01:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgAPGai (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 01:30:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CFB12075B;
        Thu, 16 Jan 2020 06:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579156238;
        bh=mtN0ZuEQmmT3ta+tMe8U8aRLezpog+6Ju3JqcttiGjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AKnuMA2ICwlhLLO1ZxGUp9GEkRf59OIrp4Q+bCSKSUucU/iAhpmt9BNN0qOtyJ8cY
         6KszuZuwQLNVuJkF1cUzwO+KV/kVc9cNn6IZaekb72IckWBCcfNs/bZKcSCeRv/bQi
         +XUQRQobew6lQP3l1h6P8OiDlZU7QFgK59sUn/uc=
Date:   Thu, 16 Jan 2020 07:29:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        christian.koenig@amd.com, michel.daenzer@amd.com,
        Jerry.Zhang@amd.com, ray.huang@amd.com, alexander.deucher@amd.com
Subject: Re: ac1e516d5a4c ("drm/ttm: fix start page for huge page check in
 ttm_put_pages()")
Message-ID: <20200116062954.GA1172661@kroah.com>
References: <20200116035501.GA39586@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116035501.GA39586@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 07:55:02PM -0800, Zubin Mithra wrote:
> Hello,
> 
> The patch :
> a66477b0efe5 ("drm/ttm: fix out-of-bounds read in ttm_put_pages() v2")
> 
> has been applied to linux-4.19.y. However, 2 follow-up fixes have not been applied.

How did you figure out that they were "follow-up" fixes?

> 
> Could the following two fixes be applied to linux-4.19.y? These commits are present
> in linux-5.4.y. These patches do not have to be applied to linux-4.14.y.
> 
> ac1e516d5a4c ("drm/ttm: fix start page for huge page check in ttm_put_pages()")
> 453393369dc9 ("drm/ttm: fix incrementing the page pointer for huge pages")

Both now queued up, thanks for letting me know.

greg k-h
