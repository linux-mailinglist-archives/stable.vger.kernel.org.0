Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534AF4F7CA
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 20:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFVSVK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 22 Jun 2019 14:21:10 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47135 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFVSVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 14:21:10 -0400
Received: from marcel-macpro.fritz.box (p4FEFC3D2.dip0.t-ipconnect.de [79.239.195.210])
        by mail.holtmann.org (Postfix) with ESMTPSA id 36213CF187;
        Sat, 22 Jun 2019 20:29:36 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v5.2-rc5] Bluetooth: Fix regression with minimum
 encryption key size alignment
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190622181349.8C8F320862@mail.kernel.org>
Date:   Sat, 22 Jun 2019 20:21:07 +0200
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F46C65F2-411F-4B24-BD3C-ED9F39F5E65E@holtmann.org>
References: <20190622134701.7088-1-marcel@holtmann.org>
 <20190622181349.8C8F320862@mail.kernel.org>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: d5bb334a8e17 Bluetooth: Align minimum encryption key size for LE and BR/EDR connections.
> 
> The bot has tested the following trees: v5.1.12, v4.19.53, v4.14.128, v4.9.182, v4.4.182.
> 
> v5.1.12: Build failed! Errors:
>    net/bluetooth/l2cap_core.c:1356:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?
> 
> v4.19.53: Build failed! Errors:
>    net/bluetooth/l2cap_core.c:1355:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?
> 
> v4.14.128: Build failed! Errors:
>    net/bluetooth/l2cap_core.c:1355:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?
> 
> v4.9.182: Build OK!
> v4.4.182: Build OK!
> 
> How should we proceed with this patch?

either you reapply commit d5bb334a8e17 first or I have to send a version that combines both into a single commit for easy applying.

Regards

Marcel

