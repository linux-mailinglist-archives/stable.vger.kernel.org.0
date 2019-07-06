Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9172260FDB
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 12:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfGFKfn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 6 Jul 2019 06:35:43 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41425 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfGFKfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jul 2019 06:35:43 -0400
Received: from [192.168.0.113] (CMPC-089-239-107-172.CNet.Gawex.PL [89.239.107.172])
        by mail.holtmann.org (Postfix) with ESMTPSA id 4AA75CEFAE;
        Sat,  6 Jul 2019 12:44:12 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] Bluetooth: hci_ldisc: check for missing tty operations
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190625173215.25999-1-vdronov@redhat.com>
Date:   Sat, 6 Jul 2019 12:35:39 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+79337b501d6aa974d0f6@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@intel.com>,
        Ilya Faenson <ifaenson@broadcom.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <37673EE8-2391-425D-9957-D6FDAEFB03FA@holtmann.org>
References: <20190625173215.25999-1-vdronov@redhat.com>
To:     Vladis Dronov <vdronov@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vladis,

> Certain ttys lack operations (eg: pty_unix98_ops) which still can be
> called by certain hci uart proto (eg: mrvl, ath). Currently this leads
> to execution at address 0x0. Fix this by adding checks for missing tty
> operations.

so I really prefer that we just fail setting the line discipline. These drivers need to check that the underlying transport has all the operations available they need. We can not just ignore them.

Regards

Marcel

