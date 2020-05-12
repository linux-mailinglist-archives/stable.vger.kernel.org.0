Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF371CF089
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 11:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgELJA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 05:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbgELJAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 05:00:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BB732082E;
        Tue, 12 May 2020 09:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589274009;
        bh=Dn8ds4VFFh9AIkYJl0U2iaPdqlpsd99KoHCzIBVpxPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JcxKC7DO3c6hxdmSyp9Gt01Bd1XR6fEVS/hzSc0jUzLpTAXEmAHpb+Mqw8uW4tTAm
         6GXFW5jNEb8lV96yyqWx4dsFAXRBa8a75QwEtMP58mRuWEYn9fFRXFcbSi8e03xoC+
         gGnkPPu553CighCjvhovLfwxv6xn7JHgtvfaFcPQ=
Date:   Tue, 12 May 2020 10:59:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200512085915.GA3596975@kroah.com>
References: <20200511.174133.1445015219140385364.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511.174133.1445015219140385364.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 05:41:33PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.6 -stable, respectively.

Now queued up, thanks!

greg k-h
