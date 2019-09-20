Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27531B916C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbfITOLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387562AbfITOLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 10:11:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 158B220644;
        Fri, 20 Sep 2019 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568988699;
        bh=CvUKc5KI+bhP5yt2KDmp4Ddv0A7NljjJ88GhdwlLuzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KgwlSVjJlhsh6EA1k0iJn2qJ7yftAmfCilNcD0kPVQIdYy2bDk88QgH4tONY/eeD4
         X1p8NEaGLgyI84/Q6cqjZclJeqzZFw87Smu3C3BSauknKVUUqFN4ugnA7t6DMiPJCe
         1KAm6HKWGAd3krFVTi6PkT2ACLVVN1P++yCv6VAI=
Date:   Fri, 20 Sep 2019 16:11:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, nicholas.kazlauskas@amd.com,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 0/3] amdgpu DC fixes for stable
Message-ID: <20190920141135.GA588297@kroah.com>
References: <20190920140338.3172-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920140338.3172-1-alexander.deucher@amd.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 09:03:35AM -0500, Alex Deucher wrote:
> This set of patches is cherry-picked from 5.4 to stable to fix:
> https://bugzilla.kernel.org/show_bug.cgi?id=204181
> 
> Please apply!

What stable tree(s) do you wish to see this applied to?

thanks,

greg k-h
