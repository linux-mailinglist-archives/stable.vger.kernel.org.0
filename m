Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987D7231DAD
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 13:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgG2LwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 07:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgG2LwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 07:52:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7DA22076E;
        Wed, 29 Jul 2020 11:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596023524;
        bh=M8quHpQ9vmlwuu+3VoSXawSGQWvaclrSwN6lEdPV0mQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYCm/k3DgRESOqJi0GM40oX+qOCRoPwTykf+sWwO2wqqkXF3EjrInaDUTHRYrEOOi
         pYGZRpBXVx1oRI3FdLbN0bNGTtjvoReCb7bP3rkiXqAW2lov5Gt915LDO4jdfubZag
         d7rqQeOd78qDfgkKj0xIAOwTy+voyQhymTwiJNIw=
Date:   Wed, 29 Jul 2020 13:51:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org, Miles Chen <miles.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        Oscar Salvador <osalvador@techadventures.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 4.14.y] mm/page_owner.c: remove drain_all_pages from
 init_early_allocated_pages
Message-ID: <20200729115155.GC2674635@kroah.com>
References: <20200727191746.3644844-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727191746.3644844-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 12:17:45PM -0700, Nick Desaulniers wrote:
> From: Oscar Salvador <osalvador@techadventures.net>
> 
> commit u6bec6ad77fac3d29aed0d8e0b7526daedc964970 upstream.

This is not a valid git id :(

