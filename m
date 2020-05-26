Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E71E1D1F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 10:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgEZITm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 04:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgEZITm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 04:19:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DAEF20776;
        Tue, 26 May 2020 08:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590481180;
        bh=9d+CKjDsfeg/CrypEMkS3rgaZuL/VM/MlaKj981aylY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ehTyc0Mo0RQrPUPZLEygUthcnOA0bH77l4UtfJvjHyslxLZbhDmqld471mOuacusL
         514R2Q3ut5NU4YT+Xl/2s9x5MdpUXy3eOVGQ37mngQE6knu1AwmWVEy7yUn5oYNYki
         9zDXFl6V9VoR7RDeUjOY9uiFX2J8K2MwqnmziOXc=
Date:   Tue, 26 May 2020 10:19:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     hch@lst.de, sagi@grimberg.me, stable@vger.kernel.org,
        nirranjan@chelsio.com, bharat@chelsio.com
Subject: Re: nvme blk_update_request IO error is seen on stable kernel 5.4.41.
Message-ID: <20200526081938.GB2650351@kroah.com>
References: <20200521140642.GA4724@chelsio.com>
 <20200526073500.GA8387@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526073500.GA8387@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Tue, May 26, 2020 at 01:05:04PM +0530, Dakshaja Uppalapati wrote:
> Hi all,
> 
> Gentle reminder.

From a patch you sent out 4 days ago?  Covering a long holiday weekend
for most "western" countries?  odd...

greg k-h
