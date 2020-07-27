Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DD722EB1F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 13:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgG0LXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 07:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgG0LXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 07:23:13 -0400
Received: from mout1.freenet.de (mout1.freenet.de [IPv6:2001:748:100:40::2:3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A449CC061794;
        Mon, 27 Jul 2020 04:23:13 -0700 (PDT)
Received: from [195.4.92.163] (helo=mjail0.freenet.de)
        by mout1.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (port 25) (Exim 4.92 #3)
        id 1k01Dm-0005jy-Pt; Mon, 27 Jul 2020 13:23:06 +0200
Received: from localhost ([::1]:46310 helo=mjail0.freenet.de)
        by mjail0.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1k01Dm-0004lS-ND; Mon, 27 Jul 2020 13:23:06 +0200
Received: from sub4.freenet.de ([195.4.92.123]:57894)
        by mjail0.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1k01B3-0002eG-2V; Mon, 27 Jul 2020 13:20:17 +0200
Received: from p200300e707499d00609b6223302c0355.dip0.t-ipconnect.de ([2003:e7:749:9d00:609b:6223:302c:355]:53622 helo=[127.0.0.1])
        by sub4.freenet.de with esmtpsa (ID viktor.jaegerskuepper@freenet.de) (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256) (port 465) (Exim 4.92 #3)
        id 1k01B2-0000V7-Vs; Mon, 27 Jul 2020 13:20:17 +0200
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>,
        Mark O'Donovan <shiftee@posteo.net>,
        Roman Mamedov <rm@romanrm.net>
From:   =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
Subject: Please apply "ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb" and the corresponding fix to all stable kernels
Message-ID: <81f07366-59e4-bfc9-c7a6-95c8e686c5e1@freenet.de>
Date:   Mon, 27 Jul 2020 13:20:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Originated-At: 2003:e7:749:9d00:609b:6223:302c:355!53622
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha and all the others,

Hans de Goede requested to revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
from all stable and longterm kernels because this commit broke certain devices
with Atheros 9271 and at that time it seemed that reverting the commit would be
done in the mainline kernel. The revert was done in kernel 5.7.9 etc., however
Mark O'Donovan found a fix for the original commit - which avoided the revert in
the mainline kernel - and this fix is now included in 5.8-rc7 with commit

92f53e2fda8bb9a559ad61d57bfb397ce67ed0ab ("ath9k: Fix regression with Atheros 9271").

To be consistent with the mainline kernel, please apply the original commit
again (or re-revert it, whatever is appropriate for stable kernels) and then
apply Mark's fix. I have tested this with the current 5.7.10 kernel to confirm
that it works because I was affected by the bug.

All relevant people are CC'ed if someone wants to object.

Thanks,
Viktor
