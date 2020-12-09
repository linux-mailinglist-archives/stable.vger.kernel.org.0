Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4E72D409B
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 12:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgLILEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 06:04:07 -0500
Received: from hera.aquilenet.fr ([185.233.100.1]:44076 "EHLO
        hera.aquilenet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730161AbgLILEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 06:04:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by hera.aquilenet.fr (Postfix) with ESMTP id 2AE6614B0;
        Wed,  9 Dec 2020 12:03:26 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aquilenet.fr
Received: from hera.aquilenet.fr ([127.0.0.1])
        by localhost (hera.aquilenet.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XNUmJQcNtsuE; Wed,  9 Dec 2020 12:03:25 +0100 (CET)
Received: from function.youpi.perso.aquilenet.fr (unknown [IPv6:2a01:cb19:956:1b00:9eb6:d0ff:fe88:c3c7])
        by hera.aquilenet.fr (Postfix) with ESMTPSA id 7E06FCF5;
        Wed,  9 Dec 2020 12:03:25 +0100 (CET)
Received: from samy by function.youpi.perso.aquilenet.fr with local (Exim 4.94)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1kmxFk-0064m8-I0; Wed, 09 Dec 2020 12:03:24 +0100
Date:   Wed, 9 Dec 2020 12:03:24 +0100
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for 4.19] speakup: Reject setting the speakup line
 discipline outside of speakup
Message-ID: <20201209110324.lnx7jmnm456jovim@function>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg KH <greg@kroah.com>, stable@vger.kernel.org
References: <20201209102640.yn7mdn52sm7bfbgm@function>
 <X9Cs/hMXQ4grRDql@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X9Cs/hMXQ4grRDql@kroah.com>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH, le mer. 09 déc. 2020 11:54:54 +0100, a ecrit:
> This, and the 4.14.y backport, fail to apply:
> 
> patching file drivers/staging/speakup/spk_ttyio.c
> Hunk #1 FAILED at 47.
> Hunk #2 succeeded at 187 (offset -4 lines).
> 1 out of 2 hunks FAILED -- rejects in file drivers/staging/speakup/spk_ttyio.c
> 
> What tree(s) did you make the patch against?

I used 4.19.162 and 4.14.211 tarballs. But now I realize that I used
patch -l, without it there are small whitespace differences. Can you
apply them with -l, or should I fix the whitespacing?

Samuel
