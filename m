Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30AB71589
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbfGWJzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732236AbfGWJzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 05:55:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42C22239F;
        Tue, 23 Jul 2019 09:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563875700;
        bh=WFJLQqilbc4Hg2pOAEFhZ6o/OV1Ebodp4SgdyOvnzrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aMfLmqafR3JetdNa8MSf0QfrQf6REp/VwFYzUP2KeUKNLrKF5TaaRtJJIZcA9V4u3
         0ec4AKNfrTdnr4uUg98mdYg3c7CzxjZaPtckMp1L0YPkmL07BdOEailxzmtnZmZIca
         VncPQKlDFtzj0cUYJeXiYOdzy/EfzXN0kkdUAbKo=
Date:   Tue, 23 Jul 2019 11:54:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     devel@etsukata.com, rostedt@goodmis.org, stable@vger.kernel.org
Subject: Re: [PATCH for 4.4, 4.9] tracing/snapshot: Resize spare buffer if
 size changed
Message-ID: <20190723095440.GA3931@kroah.com>
References: <156231680279219@kroah.com>
 <20190718051841.6890-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718051841.6890-1-nobuhiro1.iwamatsu@toshiba.co.jp>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 02:18:41PM +0900, Nobuhiro Iwamatsu wrote:
> From: Eiichi Tsukata <devel@etsukata.com>
> 
> commit 46cc0b44428d0f0e81f11ea98217fc0edfbeab07 upstream.

Now queued up, thanks!

greg k-h
