Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95323F5E03
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 14:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbhHXMdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 08:33:24 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39587 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhHXMdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 08:33:24 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 17OCWWJf025474;
        Tue, 24 Aug 2021 14:32:32 +0200
Date:   Tue, 24 Aug 2021 14:32:32 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul =?iso-8859-1?B?R3L232Vs?= <pb.g@gmx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "USB: serial: ch341: fix character loss at high
 transfer rates"
Message-ID: <20210824123232.GA25435@1wt.eu>
References: <20210824121926.19311-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824121926.19311-1-johan@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 02:19:26PM +0200, Johan Hovold wrote:
> This reverts commit 3c18e9baee0ef97510dcda78c82285f52626764b.
> 
> These devices do not appear to send a zero-length packet when the
> transfer size is a multiple of the bulk-endpoint max-packet size. This
> means that incoming data may not be processed by the driver until a
> short packet is received or the receive buffer is full.
> 
> Revert back to using endpoint-sized receive buffers to avoid stalled
> reads.

Sorry for this, I didn't notice any issue here (aside for the chip
working where it used not to). I have no idea what these zero-length
packets correspond to, nor why they're affected by the transfer size.
Do you have any idea what I should look for ? Because without that
patch, the device is unusable for me :-/

Thanks!
Willy
