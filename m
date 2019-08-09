Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 771D48758D
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 11:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405992AbfHIJSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 05:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406148AbfHIJSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 05:18:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97DB921783;
        Fri,  9 Aug 2019 09:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565342291;
        bh=J9JxlSVc+VcAq8wWfpY7psJx4wzlPpqh5EcOUbwS310=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kA9aFs0ZH2KTp0P0tq1D2sBjo+XlMv1n5b/iyAkKB/EIMbjMSqkkWNwevkAoHq2pd
         rxx2QRhxOjHlH5ChRnhDccX4D1Sh9gv1To7mmT29UNqqqkTRtYpu36PyMpANbz6GLK
         QR1BaR6eTarsHfYtr2iA8l7oVEfwgZyHKWIhaUI0=
Date:   Fri, 9 Aug 2019 10:44:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable <stable@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Grand Schemozzle, 4.9 backport
Message-ID: <20190809084444.GA9820@kroah.com>
References: <1fcba38ae50cb4e740839c825fb2eb96b3c54956.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fcba38ae50cb4e740839c825fb2eb96b3c54956.camel@decadent.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 01:05:28AM +0100, Ben Hutchings wrote:
> Here's a lightly tested backport of the Spectre v1 swapgs mitigation,
> for 4.9.

Hm, you backported 64dbc122b20f ("x86/entry/64: Use JMP instead of
JMPQ") which is not in 4.14.y, yet you did not backport 4c92057661a3
("Documentation: Add swapgs description to the Spectre v1
documentation") which should go to this kernel too, right?

thanks,

greg k-h
