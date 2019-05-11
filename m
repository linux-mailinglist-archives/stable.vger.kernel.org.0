Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11CD1A6C3
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 07:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfEKFwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 01:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfEKFwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 01:52:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA8B2173B;
        Sat, 11 May 2019 05:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557553932;
        bh=h2hwiaTD8KSp2XlyHTp3rmWJSFEDfvytaV4vBlaT30c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=msPnFv7yJpO489IwLhFJAlOBF/5aTICXpFa4KBVh/uE8ATK0+eMTpjA9eecoDCsdl
         dXJf71yinKLBp34gPyLGVQz+QUrnQbY3N5oC1Rm9zrT7vJxeRrhWYWToesWFZuZ3j0
         Xrcyk+vW/D4UZH+z5QhRtqquRXuZevKo8JcpD1RA=
Date:   Sat, 11 May 2019 07:52:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: Linux v5.1.1
Message-ID: <20190511055210.GF14153@kroah.com>
References: <CA+icZUWSJSnKcoYeh__v_BLnXP5O0XGewLdGenz13extauRr_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWSJSnKcoYeh__v_BLnXP5O0XGewLdGenz13extauRr_w@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 09:47:14PM +0200, Sedat Dilek wrote:
> Hi Greg,
> 
> I have seen that all other Linux-stable Git branches got a new release.
> 
> What happened to Linux-stable-5.1.y and v5.1.1 release?

Dinner happened before I could get to them all :)

> Is there a show-stopper?

Nope, nothing was "supposed" to be released until today, according to
the -rc announcement, so there's no real issue.

Dealing with 5 stable trees at once is not trivial, please give us a
chance...

greg k-h
