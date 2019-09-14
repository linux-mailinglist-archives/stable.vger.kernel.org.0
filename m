Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5033CB2AD8
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 11:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfINJoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 05:44:13 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:33476 "EHLO
        manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfINJoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 05:44:12 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Sep 2019 05:44:12 EDT
Date:   Sat, 14 Sep 2019 11:37:36 +0200
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
Message-ID: <1568453554@msgid.manchmal.in-ulm.de>
References: <20190913130440.264749443@linuxfoundation.org>
 <aefa6832-073e-493c-8576-5b2f06e714fb@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefa6832-073e-493c-8576-5b2f06e714fb@roeck-us.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Guenter Roeck wrote...

> Is it really only me seeing this ?
>
> drivers/vhost/vhost.c: In function 'translate_desc':
> include/linux/compiler.h:549:38: error: call to '__compiletime_assert_1879' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)

No :)  I ran into this as well, but only in a some of my configurations,
and now I stumbled over your message while preparing a report. But it's
also in the kernelci.org logs.

Good to see you're working on this.

    Christoph

