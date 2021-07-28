Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4EA3D8EA7
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhG1NKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 09:10:15 -0400
Received: from mail.zeus.flokli.de ([88.198.15.28]:39370 "EHLO zeus.flokli.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235942AbhG1NKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 09:10:15 -0400
Received: from localhost (80-62-116-241-mobile.dk.customer.tdc.net [80.62.116.241])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: flokli@flokli.de)
        by zeus.flokli.de (Postfix) with ESMTPSA id 63CF51151A51;
        Wed, 28 Jul 2021 13:10:11 +0000 (UTC)
Date:   Wed, 28 Jul 2021 15:10:10 +0200
From:   Florian Klink <flokli@flokli.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Moritz Fischer <mdf@kernel.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        linux-kernel@vger.kernel.org, gabriel.kh.huang@fii-na.com,
        moritzf@google.com, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Revert "usb: renesas-xhci: Fix handling of unknown ROM
 state"
Message-ID: <20210728131010.v42ocedxt2tg5hbb@tp.flokli.de>
References: <20210719070519.41114-1-mdf@kernel.org>
 <c0f191cc-6400-7309-e8a4-eab0925a3d54@universe-factory.net>
 <YPhRu/DWbs58hgvq@epycbox.lan>
 <20210728123755.md5zvbeeop3shmve@tp.flokli.de>
 <YQFTKug7VeUcuMG9@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YQFTKug7VeUcuMG9@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> > I'll put up an RFC in the next couple of days ...
>>
>> Is the RFC already out somewhere?
>>
>> Regardless of that, maybe we should push the trivial revert to
>> linux-stable first, so users don't run into this unexpectedly.
>
>It's already merged in the stable trees, right?

It's in 5.13.6, which was pushed 27mins ago ;-)

Thanks!

Florian
