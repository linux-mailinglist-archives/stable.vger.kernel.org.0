Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87028252B6A
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 12:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgHZKad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 06:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbgHZKa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 06:30:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B80A20737;
        Wed, 26 Aug 2020 10:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598437826;
        bh=CJhuN2JucdvS7hX2/B2GnJK07GXZam4dt4scwgwXddk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNtd1JLzrVc3x3SctvHHjuVD20nIXbeKf+w/dyW/XnQmu5bmPraXXQkewZrNuwGUc
         RtMqeyE1azbsrUxsZVHFreoi3wd2W6oPT4rS4+o6Huq63lhpfaosvNjjhfQzD2gHgI
         ++gZI6wdihwiEVJPz22Yv4n5ndFWSaa7scO8jDLM=
Date:   Wed, 26 Aug 2020 12:30:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: 5.8 stable inclusion request
Message-ID: <20200826103041.GB3356257@kroah.com>
References: <eac5cc64-641f-58b9-5f58-7bc1c4393bbb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eac5cc64-641f-58b9-5f58-7bc1c4393bbb@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 04:42:35PM -0600, Jens Axboe wrote:
> Hi,
> 
> Can I get this patch queued up for 5.8? It's a backport of two
> commits from upstream. Thanks!

Now queued up, thanks!

greg k-h
