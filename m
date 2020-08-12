Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E959C242935
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgHLMR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 08:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgHLMR5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 08:17:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FEF4207DA;
        Wed, 12 Aug 2020 12:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597234676;
        bh=Vx3SUapsiak1SXoO4I605KbSoXPU/IvEEMX9g6E2uus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Reyo1Q0Uey/CL9hFpd0wnRVzELCgO9nFFmuxBnSRqHn07mgyRpTJCC/3F80JJJnit
         zOFkSMbw/YaGrQz9hgDdRcU17oXXi5HtYgfFvWMTbZsGXPoGmfgd+b1Aqziom+stXb
         wZZl7ySnjR9gbiQPbpU5JfLsq001OCfyVMqCWPL0=
Date:   Wed, 12 Aug 2020 14:18:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Plamen Lyutov <plamen.lyutov@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Nvme patch
Message-ID: <20200812121806.GA2095697@kroah.com>
References: <CAOLo7rqADzuZ6nXwhDNO4e0-CBoPa3=JVQxoMcDTZtOOOR2Wfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLo7rqADzuZ6nXwhDNO4e0-CBoPa3=JVQxoMcDTZtOOOR2Wfw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 03:10:01PM +0300, Plamen Lyutov wrote:
> Is it possible 5bedd3afee8eb01ccd256f0cd2cc0fa6f841417a to be
> backported to 5.4.xx to fix c64141c68f725068440fbc13eb63dbb283e99168
> as it was backported to 5.7 as
> 02963f5752032ab987fae7b450d5e1e357e7425b to fix
> e2cb0c5635ecf7d8f2bde9971edbe00a0b8b8536

Now queued up, thanks.

greg k-h
