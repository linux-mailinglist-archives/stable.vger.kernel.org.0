Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24507479F
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 08:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387617AbfGYG7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 02:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387668AbfGYG7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 02:59:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A8522BEB;
        Thu, 25 Jul 2019 06:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564037974;
        bh=Pq9fozASFcfomK2hseakSjLqbWaWNYkD9hbjSe2MWjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHUxENneJE0dWmco4XfJiYivLlKtejKxa5l2/Fp0L3k26OJ8YK6hBWx0/ptXUbkzL
         JsVO/u9zeZKaCxywSrEnrEhm1rcxmU5IHj4ri4WPtRq2AuR/VURyg8PL83ApUOAMKz
         6HSyUjLJ/I4K+9vmI9mtzlvuhbnKAp0H/c8s6JOo=
Date:   Thu, 25 Jul 2019 08:34:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] sd_zbc: Fix report zones buffer allocation
Message-ID: <20190725063422.GC6723@kroah.com>
References: <20190725060453.26910-1-damien.lemoal@wdc.com>
 <20190725060453.26910-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725060453.26910-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 03:04:53PM +0900, Damien Le Moal wrote:
> From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>

Again, I did not write this patch either :(

