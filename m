Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A172810564A
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 17:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKUQAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 11:00:31 -0500
Received: from imap1.codethink.co.uk ([176.9.8.82]:55344 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUQAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 11:00:31 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iXosd-0002vX-2D; Thu, 21 Nov 2019 16:00:27 +0000
Message-ID: <6a987be69356a33cf60ec61df2304404a4f41a3a.camel@codethink.co.uk>
Subject: Re: [Y2038] [PATCH 6/8] lp: fix sparc64 LPSETTIMEOUT ioctl
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Bamvor Jian Zhang <bamv2005@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 21 Nov 2019 16:00:25 +0000
In-Reply-To: <CAK8P3a34sty4kTfFSKz8e-D+B14e3oTUPaACzGq_1SjYeuoytg@mail.gmail.com>
References: <20191108203435.112759-1-arnd@arndb.de>
         <20191108203435.112759-7-arnd@arndb.de>
         <41baf20a190039443cb2b82aea0c2a8ec872cfed.camel@codethink.co.uk>
         <CAK8P3a3U0GWCyU9WOnrGQ2tqnHoyAbJ=HdYJGfTHuxVqcww0wg@mail.gmail.com>
         <a187cb75cc15ba8ee4a7b652fae8317cb9b03020.camel@codethink.co.uk>
         <CAK8P3a34sty4kTfFSKz8e-D+B14e3oTUPaACzGq_1SjYeuoytg@mail.gmail.com>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-11-21 at 15:04 +0100, Arnd Bergmann wrote:
[...]
> As Greg has already merged the original patch, and that version works
> just as well, I'd probably just leave what I did at first. One benefit is
> that in case we decide to kill off sparc64 support before drivers/char/lp.c,
> the special case can be removed more easily.
> 
> I don't think either of them is going any time soon, but working on y2038
> patches has made me think ahead longer term ;-)
> 
> If you still think we should change it I can send the below patch (now
> actually build-tested) with your Ack.
[...]

I would like it, but since you convinced me the current version works
correctly it's obvious lower priority than the other changes you have.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

