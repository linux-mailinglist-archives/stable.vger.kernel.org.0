Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D1E3F0038
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 11:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhHRJU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 05:20:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38020 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbhHRJUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 05:20:25 -0400
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C1DC64D2DFA8D;
        Wed, 18 Aug 2021 02:19:31 -0700 (PDT)
Date:   Wed, 18 Aug 2021 10:19:24 +0100 (BST)
Message-Id: <20210818.101924.2211584682779714222.davem@davemloft.net>
To:     petko.manolov@konsulko.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: fixes of set_register(s) return
 value evaluation;
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210817140613.27737-1-petko.manolov@konsulko.com>
References: <20210817140613.27737-1-petko.manolov@konsulko.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 18 Aug 2021 02:19:33 -0700 (PDT)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Please resubmit with a proper Fixes: tag, thank you.
