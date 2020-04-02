Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD3519CAB1
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388289AbgDBT7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:59:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50652 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731823AbgDBT7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:59:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E27515C75C1D;
        Thu,  2 Apr 2020 12:59:33 -0700 (PDT)
Date:   Thu, 02 Apr 2020 12:59:30 -0700 (PDT)
Message-Id: <20200402.125930.1715113142516280666.davem@davemloft.net>
To:     will@kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        g.nault@alphalink.fr
Subject: Re: [PATCH 1/2] l2tp: ensure sessions are freed after their
 PPPOL2TP socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402173158.7798-2-will@kernel.org>
References: <20200402173158.7798-1-will@kernel.org>
        <20200402173158.7798-2-will@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 12:59:33 -0700 (PDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Sorry, you will have to repost all of these l2tp patches with proper
cover letters for a patch series.

In this particular case it's even more necessary, you posted two patch
series.  One with 2 patches and one with 8 patches.  Do they depend
upon eachother?  If so, which one goes first.  What is each patch
series doing?  How is it doing it?  And why are you doing it that way?

Those are the questions answered by a properly written header posting.

Thank you.

