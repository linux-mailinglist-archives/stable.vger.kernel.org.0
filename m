Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D92C10F809
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 07:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfLCGqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 01:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfLCGqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 01:46:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7E620684;
        Tue,  3 Dec 2019 06:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575355612;
        bh=/Mo9HSkPUIP0snHkRVyoPuoH/qFyDQrQXyQCn8YlUPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k9eeFnu/8hvOQj2U5k8486taRPhHK4817bBQXu0QX3aGpZbOsH+GHSSccMwHqPIun
         gX8CxsF9HKOrw3pYwa7QEPNjbkL7MeA/BZ5HQNIqLjvFQrSTghcczy/KJlQCJtgnBG
         EPO2ZTZiS3Z4bdi8FPP9A0csjtEIOyP8JHE7SCA8=
Date:   Tue, 3 Dec 2019 07:46:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191203064650.GA1791585@kroah.com>
References: <20191202.192147.358235389178300029.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202.192147.358235389178300029.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 07:21:47PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.3 and v5.4
> -stable, respectively.
> 
> Thank you!


All now queued up, thanks!

greg k-h
