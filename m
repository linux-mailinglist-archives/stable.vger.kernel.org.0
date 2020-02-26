Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A9116F49E
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 02:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgBZBAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 20:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgBZBAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 20:00:06 -0500
Received: from localhost (lfbn-ncy-1-985-231.w90-101.abo.wanadoo.fr [90.101.63.231])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 532E021927;
        Wed, 26 Feb 2020 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582678805;
        bh=T4YrZ3QSyXAzpcDB+QtRd+ZBTLb9XELepdyL9uU+9Mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WUnYLk31blOWf5bl+CIzwywqpBcuU3EJgSoA2fk2+PHNPm0MtkhkRUm0hTzpI/tje
         tBQGoGY1/XAb599DpMWrDq6+s52Si48xIk1NTR4IuNjGs7TzbG/6Z4evAHiKO1WMiW
         0LgfE4Aq273j5CGtWWSKhvW7Odzaw2KfFoA5MVQg=
Date:   Wed, 26 Feb 2020 02:00:03 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: Re: [patch 01/10] x86/entry/32: Add missing ASM_CLAC to
 general_protection entry
Message-ID: <20200226010002.GF9599@lenoir>
References: <20200225213636.689276920@linutronix.de>
 <20200225220216.219537887@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225220216.219537887@linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 10:36:37PM +0100, Thomas Gleixner wrote:
> All exception entry points must have ASM_CLAC right at the
> beginning. The general_protection entry is missing one.
> 
> Fixes: e59d1b0a2419 ("x86-32, smap: Add STAC/CLAC instructions to 32-bit kernel entry")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
