Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F44A5BF2
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 19:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfIBRvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 13:51:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfIBRvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 13:51:37 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83093154014E3;
        Mon,  2 Sep 2019 10:51:36 -0700 (PDT)
Date:   Mon, 02 Sep 2019 10:51:36 -0700 (PDT)
Message-Id: <20190902.105136.532571712657194431.davem@davemloft.net>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190902163016.GA12364@kroah.com>
References: <20190827.174250.1230182945543056034.davem@davemloft.net>
        <20190902163016.GA12364@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Sep 2019 10:51:36 -0700 (PDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Mon, 2 Sep 2019 18:30:16 +0200

> On Tue, Aug 27, 2019 at 05:42:50PM -0700, David Miller wrote:
>> 
>> Please queue up the following bug fixes for v4.19 and v5.2 -stable
>> respectively, thanks!
> 
> 
> Now queued up, sorry for the delay.

No worries, I'll probably be dumping another batch on you in the
next 24 hours anyways :)
