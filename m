Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2DC2570AA
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 23:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgH3VP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 17:15:28 -0400
Received: from gofer.mess.org ([88.97.38.141]:60329 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgH3VP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Aug 2020 17:15:28 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id B4117C6410; Sun, 30 Aug 2020 22:15:26 +0100 (BST)
Date:   Sun, 30 Aug 2020 22:15:26 +0100
From:   Sean Young <sean@mess.org>
To:     stable@vger.kernel.org
Cc:     grumpy@mailfence.com
Subject: Re: Please merge ea8912b788f8 to v5.7 and earlier
Message-ID: <20200830211526.GA666@gofer.mess.org>
References: <20200830192752.GA30468@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830192752.GA30468@gofer.mess.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 30, 2020 at 08:27:52PM +0100, Sean Young wrote:
> Hello,
> 
> This commit is in v5.8 but it is affecting users in earlier kernels. I'd
> like to propose this commit for merging to all earlier stable kernels.

See:

https://sourceforge.net/p/lirc/mailman/lirc-list/thread/nycvar.QRO.7.76.2008301313570.2090%40tehzcl5.tehzcl-arg/#msg37097213

> 
> $ git log --oneline -1 ea8912b788f8144e7d32ee61e5ccba45424bef83
> ea8912b788f8 media: gpio-ir-tx: improve precision of transmitted signal due to scheduling
> 
> Thanks,
> 
> Sean 
