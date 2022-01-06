Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337604865A1
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiAFN43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 08:56:29 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:40665 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239519AbiAFN43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 08:56:29 -0500
Received: from smtpclient.apple (p4fefca45.dip0.t-ipconnect.de [79.239.202.69])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9F1E3CECD5;
        Thu,  6 Jan 2022 14:56:27 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH] btbcm: disable read tx power for MacBook Air 8,1 and 8,2
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <29D6266D-7470-4423-B37C-B702C8E85546@live.com>
Date:   Thu, 6 Jan 2022 14:56:27 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <C2F0CFD6-D6C4-492B-B6B8-BAFEB5D27BD7@holtmann.org>
References: <29D6266D-7470-4423-B37C-B702C8E85546@live.com>
To:     Aditya Garg <gargaditya08@live.com>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aditya,

> The MacBook Air 8,1 and 8,2 also need querying of LE Tx power
> to be disabled for Bluetooth to work.
> 
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Cc: stable@vger.kernel.org
> ---
> drivers/bluetooth/btbcm.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

