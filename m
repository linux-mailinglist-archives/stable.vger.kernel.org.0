Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC12132644
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 13:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgAGMf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 07:35:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51866 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgAGMf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 07:35:56 -0500
Received: from ip-109-41-1-227.web.vodafone.de ([109.41.1.227] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ioo5K-0001qX-1o; Tue, 07 Jan 2020 12:35:46 +0000
Date:   Tue, 7 Jan 2020 13:35:49 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amanieu d'Antras <amanieu@gmail.com>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        linux-um@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] um: Implement copy_thread_tls
Message-ID: <20200107123548.5fzu4v6czrlhrhmh@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200104123928.1048822-1-amanieu@gmail.com>
 <20200105151928.qrmhnwer3r5ffc77@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200105151928.qrmhnwer3r5ffc77@wittgenstein>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 05, 2020 at 04:19:28PM +0100, Christian Brauner wrote:
> On Sat, Jan 04, 2020 at 01:39:30PM +0100, Amanieu d'Antras wrote:
> > This is required for clone3 which passes the TLS value through a
> > struct rather than a register.
> > 
> > Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> > Cc: linux-um@lists.infradead.org
> > Cc: <stable@vger.kernel.org> # 5.3.x
> 
> Thanks. I'm picking this up as part of the copy_thread_tls() series.
> (Leaving the patch in tact so people can Ack right here if they want to.)
> If I could get an Ack from one of the maintainers that would be great;
> see
> https://lore.kernel.org/lkml/20200102172413.654385-1-amanieu@gmail.com
> for more context.
> 
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

I've this up as part of the series link in above ^^ and moved it into
https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=clone3_tls

If I hear no objections I'll merge into into my fixes tree today or
tomorrow.

An Ack from one of the maintainers would still be appreciated.

Thanks!
Christian
