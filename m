Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F4D3ABAB
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 21:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfFITmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 15:42:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44478 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfFITmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 15:42:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC61D14DE9A60;
        Sun,  9 Jun 2019 12:42:03 -0700 (PDT)
Date:   Sun, 09 Jun 2019 12:42:01 -0700 (PDT)
Message-Id: <20190609.124201.324963439100634725.davem@davemloft.net>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190609072610.GA3392@kroah.com>
References: <20190608.162722.431283354419982623.davem@davemloft.net>
        <20190609072610.GA3392@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 12:42:03 -0700 (PDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Sun, 9 Jun 2019 09:26:10 +0200

> On Sat, Jun 08, 2019 at 04:27:22PM -0700, David Miller wrote:
>> 
>> Please queue up the following networking bug fixes for v4.19 and v5.2
>> -stable, respectively.
> 
> All now queued up, except for the duplicate sparc64 patch that you sent
> last week which I already applied :)

Oops, my bad!
