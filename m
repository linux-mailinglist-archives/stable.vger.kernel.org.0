Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49EFC8B4D4
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 12:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfHMKBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 06:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbfHMKBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 06:01:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE6420663;
        Tue, 13 Aug 2019 10:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565690507;
        bh=LjLLfJvuHbYFq+3AfjI5u+pE3eh+1T/xNr8JNcS1wwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fki4XlS+UixZpTQ06877Ms7xM+tkV4R4jID2hM2EsOfxojdI15TNBS0gj6l4CfxYD
         JP6lSEPhT/IxFF/B6cW7h3hjOnoEsH36wS85DQ+Izya19MTAcWiJ70ythLf7zUPmaz
         vWIB+200qPm0Qq4TXkLYVoCKp+NaM0kgZ48l6jH8=
Date:   Tue, 13 Aug 2019 12:01:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alessio Balsini <balsini@android.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "hange-folder>?" <toggle-mailboxes@google.com>
Subject: Re: [PATCH 4.9.y 4.14.y] IB/mlx5: Fix leaking stack memory to
 userspace
Message-ID: <20190813100144.GB16112@kroah.com>
References: <20190812105136.151840-1-balsini@android.com>
 <20190812105503.153253-1-balsini@android.com>
 <20190812142316.GA12869@kroah.com>
 <20190812160714.GA246269@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812160714.GA246269@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 10:27:28AM +0100, Alessio Balsini wrote:
> Oops, you are totally right, I was still looking at the latest
> mlx5_ib_create_qp_resp struct while backporting these patches :)
> 
> Sorry for that,

Not a problem, it's good to have a second pair of eyes on these things
:)

greg k-h
