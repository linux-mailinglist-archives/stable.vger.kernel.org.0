Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1066377C82
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 08:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhEJGxk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 May 2021 02:53:40 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:49002 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhEJGxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 02:53:40 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2021 02:53:40 EDT
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C6D0A60A357B;
        Mon, 10 May 2021 08:43:46 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ag207uelseHz; Mon, 10 May 2021 08:43:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 8361B60A3594;
        Mon, 10 May 2021 08:43:46 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6SnSquGD1gcN; Mon, 10 May 2021 08:43:46 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 5CEB660A357B;
        Mon, 10 May 2021 08:43:46 +0200 (CEST)
Date:   Mon, 10 May 2021 08:43:46 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Joel Stanley <joel@jms.id.au>
Cc:     stable <stable@vger.kernel.org>
Message-ID: <1496964795.7092.1620629026246.JavaMail.zimbra@nod.at>
In-Reply-To: <CACPK8Xe9K5QzfY5RnfhGeX_x7x7r69+uYSZLnafbh7j4B525jA@mail.gmail.com>
References: <CACPK8Xe9K5QzfY5RnfhGeX_x7x7r69+uYSZLnafbh7j4B525jA@mail.gmail.com>
Subject: Re: JFFS2 Backports
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: JFFS2 Backports
Thread-Index: v7dVIZs4nLFDzQ9Xp1ScwChoCA2VkA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Can we please have the following jffs2 patches added to the stable tree:
> 
> 960b9a8a7676 "jffs2: Fix kasan slab-out-of-bounds problem"

This one is already marked for stable inclusion.

> 90ada91f4610 "jffs2: check the validity of dstlen in jffs2_zlib_compress()"

Acked-by: Richard Weinberger <richard@nod.at>
 
> Both patches fix issues that date back to pre-git history. I am
> interested in seeing them applied to v5.4 and v5.10.

Thanks,
//richard
