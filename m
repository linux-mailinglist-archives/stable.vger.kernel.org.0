Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE6A3186A
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 01:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfEaXtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 19:49:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfEaXtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 19:49:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 744F01503AD4A;
        Fri, 31 May 2019 16:49:16 -0700 (PDT)
Date:   Fri, 31 May 2019 16:49:13 -0700 (PDT)
Message-Id: <20190531.164913.1785238168456092697.davem@davemloft.net>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org
Subject: Re: [GIT] Networking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531221810.GA7311@kroah.com>
References: <20190531.141626.1051997873999042502.davem@davemloft.net>
        <20190531221810.GA7311@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 16:49:16 -0700 (PDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Fri, 31 May 2019 15:18:10 -0700

> On Fri, May 31, 2019 at 02:16:26PM -0700, David Miller wrote:
>> 
>> Please queue up the following networking bug fixes for v5.0 and v5.1
>> -stable, respectively.
> 
> Now queued up, thanks!
> 
> Note, 5.0 will be end-of-life after this next release, so no need to do
> any patches for that kernel anymore.

Thank you Greg.
