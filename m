Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C13A109F9D
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfKZNyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbfKZNyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 08:54:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A25EB20656;
        Tue, 26 Nov 2019 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574776445;
        bh=WB68jC+jemRFQsyYyY7vTIqpOvzaGEr1Zo2arfN6Pcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYR9Ny8Nwj+2LhVPyTgC3E+b/PGJc0sW1x2kOSf8XTEkRO2Qfq12xRl90RScLGaa5
         MNafBn2bsCyoqMJcr/i/EbNjnT8Kba0ygss+lE0/XfNeK5UP9886FXAoOvV5N+jm3I
         ZRlrPoOIhmNJZslpiLisb+lQ2Zz8u97tvHTNc8Kk=
Date:   Tue, 26 Nov 2019 14:54:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     stable@vger.kernel.org, davem@davemloft.net
Subject: Re: Patch "mdio_bus: fix mdio_register_device when RESET_CONTROLLER
 is disabled" has been added to the 5.3-stable tree
Message-ID: <20191126135402.GA1429066@kroah.com>
References: <157468851123632@kroah.com>
 <20191125144538.276daf86@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191125144538.276daf86@dellmb>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 02:45:38PM +0100, Marek Behún wrote:
> Upstream reverted this commit (2c61e821da7a) and then used 6e4ff1c94a04
> instead.

Thanks for the info, I'll go make that change here too.

greg k-h
