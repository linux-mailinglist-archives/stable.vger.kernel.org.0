Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CD37479E
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 08:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387660AbfGYG7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 02:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387617AbfGYG7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 02:59:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4550F2070B;
        Thu, 25 Jul 2019 06:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564037971;
        bh=5ffa+yqOvwNnhMrp63jrzm22Vzp+PY/fRYzhCrr2P/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iG5sDm6fXA6pr7CAoMOj+FMnxBB8oobTQdlCK7L725wn+e6NvKi/58OWFA12l9Eyq
         JrSTBLByz2yqE3pOPZif53AO+ATRdQc50vgGmi+XVOD75Qc4JbFd14jReqix1fEXPb
         Sqzh21BcRQqELsfuL7K+h0jcV5EtPK21OrNP3G9s=
Date:   Thu, 25 Jul 2019 08:34:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] block: Limit zone array allocation size
Message-ID: <20190725063408.GB6723@kroah.com>
References: <20190725060453.26910-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725060453.26910-1-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 03:04:52PM +0900, Damien Le Moal wrote:
> From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>

Nope, I didn't write this :(

Please fix up your email system, this isn't in a format that I can take.

greg k-h
