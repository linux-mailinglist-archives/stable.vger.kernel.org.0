Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BCB2C9FDB
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 11:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgLAKe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 05:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729962AbgLAKe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 05:34:27 -0500
X-Greylist: delayed 716 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Dec 2020 02:33:47 PST
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1150DC0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 02:33:46 -0800 (PST)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 0B1ALg7b011606
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 1 Dec 2020 11:21:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1606818102; bh=rGH49zP9+FasWP0dJiWldr+YWQmFKSJG1F382TsTZQ0=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=IJY4chW6t83bzFMuA51zaY3w0lTbRuXpJ2Ms2qM/wq8VwqSCBsgcbRF35SRVNPJdn
         CVsDvEvOAEXaVYbAwWK1EWvAJg25hyYXypuU2yXLfxGXlvGadsFJ+zdXKZJxAyiXPa
         vdWQHT9f2n7x3Bf89CN2pTWwwI4wXz/DFrof1tSM=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kk2n0-0009vV-44; Tue, 01 Dec 2020 11:21:42 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org,
        Sebastian Sjoholm <sebastian.sjoholm@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: fix Quectel BG96 matching
Organization: m
References: <20201201100318.37843-1-bjorn@mork.no>
        <X8YYdVk7LQ+VcpPf@localhost>
Date:   Tue, 01 Dec 2020 11:21:42 +0100
In-Reply-To: <X8YYdVk7LQ+VcpPf@localhost> (Johan Hovold's message of "Tue, 1
        Dec 2020 11:18:29 +0100")
Message-ID: <87tut5bzd5.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Tue, Dec 01, 2020 at 11:03:18AM +0100, Bj=C3=B8rn Mork wrote:
>> This is a partial revert of commit 2bb70f0a4b23 ("USB: serial:
>> option: support dynamic Quectel USB compositions")
>>=20
>> The Quectel BG96 is different from most other modern Quectel modems,
>> having serial functions with 3 endpoints using ff/ff/ff and ff/fe/ff
>> class/subclass/protocol. Including it in the change to accommodate
>> dynamic function mapping was incorrect.
>>=20
>> Revert to interface number matching for the BG96, assuming static
>> layout of the RMNET function on interface 4. This restores support
>> for the serial functions on interfaces 2 and 3.
>>=20
>> Full lsusb output for the BG96:
>
>> Cc: Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
>> Cc: linux-stable@vger.kernel.org
>> Fixes: 2bb70f0a4b23 ("USB: serial: option: support dynamic Quectel USB c=
ompositions")
>> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>
> Thanks, Bj=C3=B8rn. Now applied.

Thanks. But I see that I managed to type the stable address wrong.
Sorry.  Hope you can get that fixed somehow.

Patch for checkpatch next, I guess...



Bj=C3=B8rn
