Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDB143971B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 15:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhJYNHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 09:07:39 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:55526 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhJYNHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 09:07:39 -0400
Received: from smtpclient.apple (p4ff9f2d2.dip0.t-ipconnect.de [79.249.242.210])
        by mail.holtmann.org (Postfix) with ESMTPSA id A49AACED17;
        Mon, 25 Oct 2021 15:05:15 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH] Bluetooth: fix division by zero in send path
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211025113944.4350-1-johan@kernel.org>
Date:   Mon, 25 Oct 2021 15:05:15 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <608F4C62-7E22-4736-B032-13F4F3BE563D@holtmann.org>
References: <20211025113944.4350-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

> Add the missing bulk-out endpoint sanity check to probe() to avoid
> division by zero in bfusb_send_frame() in case a malicious device has
> broken descriptors (or when doing descriptor fuzz testing).
> 
> Note that USB core will reject URBs submitted for endpoints with zero
> wMaxPacketSize but that drivers doing packet-size calculations still
> need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> endpoint descriptors with maxpacket=0")).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> drivers/bluetooth/bfusb.c | 2 ++
> 1 file changed, 2 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

