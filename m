Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D824BC9A25
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfJCInI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbfJCInI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 04:43:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2894B2133F;
        Thu,  3 Oct 2019 08:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570092187;
        bh=U2TEV2mFQrnhCnfpil+CfIJ8VlxeEAz9jpfNp9n54Ts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aa8S8WG8vhy+UY4duRn2F+LlrRyKDFlTZ1JvzzXyOXVT8f4mV+3NlNYmKN1LaZ7TD
         o90EaOVz6tSL9LsNLy8B13MwdQKAfk10oI3ogddp6X0C5sZSM2q9K4S7UKb+HXwcj+
         u3VTOVfPk0GTlN1WIjE1vpyelHioOr/4j+0IQOH8=
Date:   Thu, 3 Oct 2019 10:43:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     mark.rutland@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "arm64: Remove unnecessary ISBs
 from" failed to apply to 4.19-stable tree
Message-ID: <20191003084305.GA2046371@kroah.com>
References: <156891940813244@kroah.com>
 <20190920135112.kwy5p3cl3btvquxc@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920135112.kwy5p3cl3btvquxc@willie-the-truck>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 02:51:13PM +0100, Will Deacon wrote:
> On Thu, Sep 19, 2019 at 08:56:48PM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Backport for 4.19.y below.

Now queued up, thanks!

greg k-h
