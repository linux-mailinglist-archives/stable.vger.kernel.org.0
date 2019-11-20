Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4F01037F3
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 11:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfKTKwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 05:52:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37550 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbfKTKwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 05:52:31 -0500
Received: from [79.140.122.151] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iXNb3-0004ZQ-Vn; Wed, 20 Nov 2019 10:52:30 +0000
Date:   Wed, 20 Nov 2019 11:52:29 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] fork: fix pidfd_poll()'s return type
Message-ID: <20191120105227.uln6z5d67ita3edj@wittgenstein>
References: <20191120002145.skgtkx2f5dxagx4f@wittgenstein>
 <20191120003320.31138-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191120003320.31138-1-luc.vanoostenryck@gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 01:33:20AM +0100, Luc Van Oostenryck wrote:
> pidfd_poll() is defined as returning 'unsigned int' but the
> .poll method is declared as returning '__poll_t', a bitwise type.
> 
> Fix this by using the proper return type and using the EPOLL
> constants instead of the POLL ones, as required for __poll_t.
> 
> Fixes: b53b0b9d9a61 ("pidfd: add polling support")
> Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: stable@vger.kernel.org # 5.3
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

Applied to
https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=fixes

Will likely send this as a fix for v5.4 still so stable only has to
backport this to 5.3 and not 5.4 too.

Thanks!
Christian
