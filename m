Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0998844425
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbfFMQfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbfFMHpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 03:45:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A89120851;
        Thu, 13 Jun 2019 07:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560411919;
        bh=Ve5kxPS/OdBmjGqaSC2/nptgjH8VL4zcWWMD0ib7XHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i1C8ShzEciBOKMvbbrHO7y542HaIiYyAZcicf6L25k/+2dYuULB+J7sCm7H1XYJu7
         3yhuy9Tp0YJhoxFovjmUql4ByLVjPcH2m43h2CHGOT+aylbAea2hXTcz0KlXVk4a+B
         hMKmfTkrarZV8Yt0beYsNVoPqp3lov8TNkpFwm6k=
Date:   Thu, 13 Jun 2019 09:45:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-5.0+ 3/3] nvme-tcp: fix queue mapping when queue
 count is limited
Message-ID: <20190613074516.GB19685@kroah.com>
References: <20190610045826.13176-1-sagi@grimberg.me>
 <20190610045826.13176-3-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610045826.13176-3-sagi@grimberg.me>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 09:58:26PM -0700, Sagi Grimberg wrote:
> Upstream commit: 0ddbb30d5acc ("nvme-tcp: fix queue mapping when queue
> count is limited")

Again, no such commit :(

Can you fix all of these up to have the correct git id and resend?

thanks,

greg k-h
