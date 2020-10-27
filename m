Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96C29A492
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 07:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506444AbgJ0GWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 02:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506441AbgJ0GWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 02:22:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3728B216FD;
        Tue, 27 Oct 2020 06:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603779741;
        bh=OX6Gx1/fazV7MgcdQVipYlPzthf7xQVRu6z13u2l37g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HTJ1CB3eGJLWuPKuMtrCh2xzKMlhQJzY7OyRAEsQkiyXoPuPQ3/UIjGDGEqhF+yiJ
         /JPjDYkCvD4H+1UIX0jaI6YuJn7BO30UI5CnA+4On75ZvM89inOD78+DF0csBaErG6
         F1x+QZ7ywt8xKjBsnK57ByYzRrtRKf0Opyz+4ATM=
Date:   Tue, 27 Oct 2020 07:22:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        b.zolnierkie@samsung.com, jani.nikula@intel.com,
        daniel.vetter@ffwll.ch, gustavoars@kernel.org,
        dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        rppt@kernel.org
Subject: Re: [PATCH 1/1] video: fbdev: fix divide error in fbcon_switch
Message-ID: <20201027062217.GE206502@kroah.com>
References: <20201021235758.59993-1-saeed.mirzamohammadi@oracle.com>
 <ad87c5c1-061d-8a81-7b2c-43a8687a464f@suse.de>
 <3294C797-1BBB-4410-812B-4A4BB813F002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3294C797-1BBB-4410-812B-4A4BB813F002@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 10:00:11AM -0700, Saeed Mirzamohammadi wrote:
> Thanks, adding stable.

Why?  What are we supposed to do with this?
