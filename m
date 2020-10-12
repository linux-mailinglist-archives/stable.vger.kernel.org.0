Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E1928B466
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 14:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388330AbgJLMNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 08:13:11 -0400
Received: from mailout12.rmx.de ([94.199.88.78]:42939 "EHLO mailout12.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388209AbgJLMNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 08:13:11 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout12.rmx.de (Postfix) with ESMTPS id 4C8yHl73kRzRqC1;
        Mon, 12 Oct 2020 14:13:07 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4C8yHP2Vmdz2xjy;
        Mon, 12 Oct 2020 14:12:49 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.102) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 12 Oct
 2020 14:09:00 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <u.kleine-koenig@pengutronix.de>, <wsa@kernel.org>,
        <stable-commits@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: Patch "i2c: imx: Fix reset of I2SR_IAL flag" has been added to the 5.8-stable tree
Date:   Mon, 12 Oct 2020 14:08:59 +0200
Message-ID: <4806347.2qqPzs43qk@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201012082059.GA3798940@kroah.com>
References: <1602406113214120@kroah.com> <6827529.2cDsNes8Pd@n95hx1g2> <20201012082059.GA3798940@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.102]
X-RMX-ID: 20201012-141305-4C8yHP2Vmdz2xjy-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday, 12 October 2020, 10:20:59 CEST, Greg KH wrote:
> On Mon, Oct 12, 2020 at 09:38:30AM +0200, Christian Eggers wrote:
> > Hi Greg,
> > 
> > the patch below has meanwhile been reverted by Wolfram Sang [1], because
> > it has been superseded. Although the patch itself is not wrong, you also
> > may want to revert it in order to avoid conflicts with the next version.
> > 
> > Best regards
> > Christian
> > 
> > [1]
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5a02e7c429cb5e082e5d7be6e5b768828014ba70
> Thanks for letting me know, now dropped.
> 
> greg k-h

Got just a bunch of notifications that this patch fa4d30556883 has (again) be
applied to all stable trees. Somebody must have even backported it to < 5.8...

Best regards
Christian




