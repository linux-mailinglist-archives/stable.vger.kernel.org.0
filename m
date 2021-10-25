Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF83439B62
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 18:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhJYQWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 12:22:36 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:38952 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232362AbhJYQWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 12:22:36 -0400
Received: from omf04.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id F1E1330C9F;
        Mon, 25 Oct 2021 16:20:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf04.hostedemail.com (Postfix) with ESMTPA id 872D5D1513;
        Mon, 25 Oct 2021 16:20:11 +0000 (UTC)
Message-ID: <a1e76a303ec4dc1ffd53e1d22634363bdb0ffcd0.camel@perches.com>
Subject: Re: [PATCH 1/2] staging: rtl8192u: fix control-message timeouts
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Johan Hovold <johan@kernel.org>, cocci@inria.fr,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 25 Oct 2021 09:20:10 -0700
In-Reply-To: <YXbSfYIuyj3PI6pm@kroah.com>
References: <20211025120910.6339-1-johan@kernel.org>
         <20211025120910.6339-2-johan@kernel.org>
         <fdb677be-6e06-fef9-811d-bb2c71246197@lwfinger.net>
         <094a8f50ccef81e0317c89d0a605c327c825d5cb.camel@perches.com>
         <YXbSfYIuyj3PI6pm@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.61
X-Stat-Signature: s57wnjk3sazm6ya3cfjfmqterpgjdyme
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 872D5D1513
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18H09QZhcxyfnc+dKXrrgxF7zoOKHJVloU=
X-HE-Tag: 1635178811-876912
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-10-25 at 17:51 +0200, Greg Kroah-Hartman wrote:
> Look at the lists, he's sent a bunch of fixes for this today to all the
> subsystems...

Yay Johan. Thanks for doing all of them...

