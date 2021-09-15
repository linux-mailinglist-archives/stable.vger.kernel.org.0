Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9E640CCD2
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 20:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhIOSym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 14:54:42 -0400
Received: from rfvt.org.uk ([37.187.119.221]:50458 "EHLO rfvt.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhIOSyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 14:54:38 -0400
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id 31013827CB;
        Wed, 15 Sep 2021 19:53:15 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1631731995;
        bh=Pl+SCjVxOGRBsYE8vcs3O6K0c2ynaEeUUoB+PvutJhA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=GI4TJ4+jzQKA/QOlhjDMPOXyFSM0UPj1TINNZ2Ly6Ex2/XoJoLSPEPzXuo+jtTP14
         fjp5sLL7iXCWfBiogcFVtlKvQcWDn1wRN5mo056g+vcWiQXuR6/kP+NIIQLCr0J5dX
         55VzWCF4h57dkqYvJtcLlicf9gzxhn1FaUhqCUDvhOekEam4+aHnc6gtCnNDdvakn+
         RpZIQ1BVVgQLW63WWb2gf2NTtubbdhE5p2aI77ucUADZh3mEsgiFp48hJUmcG/ZoUW
         6Q56PpIu+v6PQBSJptX5KZhTBSZWCQjXZEEVw5efExayNXmSsgr4uRdMnkymwgkG5D
         JnKGcf8AfdO0A==
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24898.16666.838506.586861@wylie.me.uk>
Date:   Wed, 15 Sep 2021 19:53:14 +0100
From:   "Alan J. Wylie" <alan@wylie.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in posix-cpu-timers.c (was Re: Linux 5.14.4)
In-Reply-To: <YUI26QI7dfgjUioT@kroah.com>
References: <1631693373201133@kroah.com>
        <87ilz1pwaq.fsf@wylie.me.uk>
        <YUI26QI7dfgjUioT@kroah.com>
X-Mailer: VM 8.2.0b under 27.2 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

at 20:09 on Wed 15-Sep-2021 Greg Kroah-Hartman (gregkh@linuxfoundation.org) wrote:

> Does 5.15-rc1 also fail in this same way, or does it work ok?

It fails

# uname -a
Linux bilbo 5.15.0-rc1 #1 SMP PREEMPT Wed Sep 15 19:19:48 BST 2021
x86_64 AMD FX(tm)-4300 Quad-Core Processor AuthenticAMD GNU/Linux

# su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --off"
PHP Fatal error: Maximum execution time of 0 seconds exceeded in
/var/www/htdocs/nextcloud/3rdparty/symfony/console/Application.php on
line 65

Regards
Alan

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience
