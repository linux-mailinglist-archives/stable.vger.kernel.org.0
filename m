Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836CD4442D
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbfFMQfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730729AbfFMHod (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 03:44:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E66420851;
        Thu, 13 Jun 2019 07:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560411872;
        bh=FDY3EbCYfqIylx76nrlTyRFXz1d840DAeUxP7f3gToo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2tWqx2gA0hWG3PDgirHi3q4AeRz0ENWpp/SWzJDdKuOFtAKFx8WL8Y31ptOz2AqvE
         GUUoNL/OyyY40xMI46QOHW/YWYpIIRPvOgFxJufOK/96BO9jAakr6uJxAcCFJwhUIg
         p0AgNt8gQipQIpUDQ7nrMTSwtzlPkmxVxNofiHHI=
Date:   Thu, 13 Jun 2019 09:44:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-5.0+ 1/3] nvme-tcp: rename function to have
 nvme_tcp prefix
Message-ID: <20190613074430.GA19685@kroah.com>
References: <20190610045826.13176-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610045826.13176-1-sagi@grimberg.me>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 09:58:24PM -0700, Sagi Grimberg wrote:
> Upstream commit: 7e6e5ffa7ed2 ("nvme-tcp: rename function to have nvme_tcp prefix")

There is no such commit in Linus's tree :(

