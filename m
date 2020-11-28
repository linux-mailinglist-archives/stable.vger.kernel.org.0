Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE5B2C73AB
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbgK1Vtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:55 -0500
Received: from mailout01.rmx.de ([94.199.90.91]:43624 "EHLO mailout01.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387736AbgK1UsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Nov 2020 15:48:21 -0500
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2020 15:48:21 EST
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout01.rmx.de (Postfix) with ESMTPS id 4Ck2nc54cBz2SVJC
        for <stable@vger.kernel.org>; Sat, 28 Nov 2020 21:16:20 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Ck2nL0SVfz2TRlg
        for <stable@vger.kernel.org>; Sat, 28 Nov 2020 21:16:06 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.20) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sat, 28 Nov
 2020 21:15:53 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <u.kleine-koenig@pengutronix.de>, <wsa@kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: Patch "i2c: imx: Fix reset of I2SR_IAL flag" has been added to the 5.4-stable tree
Date:   Sat, 28 Nov 2020 21:15:52 +0100
Message-ID: <2749996.lFCkXiQ3ky@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <CADVatmO2irK-zhsmxceyr0Ami-C16y+7e8BZxpnQibMWk3Y_yg@mail.gmail.com>
References: <1606575438136209@kroah.com> <2394419.nDFh2rNouh@n95hx1g2> <CADVatmO2irK-zhsmxceyr0Ami-C16y+7e8BZxpnQibMWk3Y_yg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.20]
X-RMX-ID: 20201128-211612-4Ck2nL0SVfz2TRlg-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sudip,

On Saturday, 28 November 2020, 17:57:50 CET, Sudip Mukherjee wrote:
> Hi Christian,
> 
> On Sat, Nov 28, 2020 at 3:11 PM Christian Eggers <ceggers@arri.de> wrote:
> <snip>
> > Although I am happy seeing my patch in the stable series, I think it should be
> > applied to mainline first.
> 
> Stable trees can only take fixes which have been applied to the
> mainline. This is in mainline since v5.9.

I cannot see it in 5.9-stable:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/drivers/i2c/busses/i2c-imx.c?h=v5.9.11

regards
Christian




