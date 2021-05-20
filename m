Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCE438B2D1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 17:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhETPP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 11:15:29 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60147 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhETPP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 11:15:29 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9F14ACECEA;
        Thu, 20 May 2021 17:21:59 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH v2] Bluetooth: Remove spurious error message
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210518145436.156997-1-szymon.janc@codecoup.pl>
Date:   Thu, 20 May 2021 17:14:05 +0200
Cc:     "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4C168499-2A66-4C69-8F1D-DE044416FC77@holtmann.org>
References: <20210518145436.156997-1-szymon.janc@codecoup.pl>
To:     Szymon Janc <szymon.janc@codecoup.pl>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Szymon,

> Even with rate limited reporting this is very spammy and since
> it is remote device that is providing bogus data there is no
> need to report this as error.
> 
> Since real_len variable was used only to allow conditional error
> message it is now also removed.
> 
> [72454.143336] bt_err_ratelimited: 10 callbacks suppressed
> [72454.143337] Bluetooth: hci0: advertising data len corrected
> [72454.296314] Bluetooth: hci0: advertising data len corrected
> [72454.892329] Bluetooth: hci0: advertising data len corrected
> [72455.051319] Bluetooth: hci0: advertising data len corrected
> [72455.357326] Bluetooth: hci0: advertising data len corrected
> [72455.663295] Bluetooth: hci0: advertising data len corrected
> [72455.787278] Bluetooth: hci0: advertising data len corrected
> [72455.942278] Bluetooth: hci0: advertising data len corrected
> [72456.094276] Bluetooth: hci0: advertising data len corrected
> [72456.249137] Bluetooth: hci0: advertising data len corrected
> [72459.416333] bt_err_ratelimited: 13 callbacks suppressed
> [72459.416334] Bluetooth: hci0: advertising data len corrected
> [72459.721334] Bluetooth: hci0: advertising data len corrected
> [72460.011317] Bluetooth: hci0: advertising data len corrected
> [72460.327171] Bluetooth: hci0: advertising data len corrected
> [72460.638294] Bluetooth: hci0: advertising data len corrected
> [72460.946350] Bluetooth: hci0: advertising data len corrected
> [72461.225320] Bluetooth: hci0: advertising data len corrected
> [72461.690322] Bluetooth: hci0: advertising data len corrected
> [72462.118318] Bluetooth: hci0: advertising data len corrected
> [72462.427319] Bluetooth: hci0: advertising data len corrected
> [72464.546319] bt_err_ratelimited: 7 callbacks suppressed
> [72464.546319] Bluetooth: hci0: advertising data len corrected
> [72464.857318] Bluetooth: hci0: advertising data len corrected
> [72465.163332] Bluetooth: hci0: advertising data len corrected
> [72465.278331] Bluetooth: hci0: advertising data len corrected
> [72465.432323] Bluetooth: hci0: advertising data len corrected
> [72465.891334] Bluetooth: hci0: advertising data len corrected
> [72466.045334] Bluetooth: hci0: advertising data len corrected
> [72466.197321] Bluetooth: hci0: advertising data len corrected
> [72466.340318] Bluetooth: hci0: advertising data len corrected
> [72466.498335] Bluetooth: hci0: advertising data len corrected
> [72469.803299] bt_err_ratelimited: 10 callbacks suppressed
> 
> Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
> Cc: stable@vger.kernel.org
> ---
> net/bluetooth/hci_event.c | 14 +++++---------
> 1 file changed, 5 insertions(+), 9 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

