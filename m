Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068AF33A367
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 08:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhCNHVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 03:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234322AbhCNHVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Mar 2021 03:21:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F2D64EB6;
        Sun, 14 Mar 2021 07:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615706465;
        bh=9VXxuoLV4wGzeDj3NbaaZCpxcjYGhSW13fKdCoA3YXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4CYWq3gg/0CqzYaysbBVgsAL7++pGlonPsn7o/wNXbOGDO4oOYBzneU4zF+937Gn
         gdc6D/ILeIyoXV6rOhgWVGfVyqpTY6o6Sau0goZLtYJ/K2cZMGV7GfYbNe43yD8Cdk
         VVIqLIrmCGoUSis2JnjNrfP+QQUQM121/K2u4DLg=
Date:   Sun, 14 Mar 2021 08:20:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anton Eidelman <anton@lightbitslabs.com>
Cc:     stable@vger.kernel.org, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] nvme: unlink head after removing last namespace
Message-ID: <YE25W2Mzyd6pKaQJ@kroah.com>
References: <20210314040705.1357858-1-anton@lightbitslabs.com>
 <20210314040705.1357858-2-anton@lightbitslabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314040705.1357858-2-anton@lightbitslabs.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 13, 2021 at 08:07:04PM -0800, Anton Eidelman wrote:
> *This message is sent in confidence for the addressee 
> only.  It
> may contain legally privileged information. The contents are not 
> to be
> disclosed to anyone other than the addressee. Unauthorized recipients 
> are
> requested to preserve this confidentiality, advise the sender 
> immediately of
> any error in transmission and delete the email from their 
> systems.*
> 

email deleted.
