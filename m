Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2B2D40AF
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 12:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgLILHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 06:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbgLILHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 06:07:30 -0500
Received: from hera.aquilenet.fr (hera.aquilenet.fr [IPv6:2a0c:e300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BB5C0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 03:06:49 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by hera.aquilenet.fr (Postfix) with ESMTP id 86DAB14B6;
        Wed,  9 Dec 2020 12:06:48 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aquilenet.fr
Received: from hera.aquilenet.fr ([127.0.0.1])
        by localhost (hera.aquilenet.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PArvwQak0pJN; Wed,  9 Dec 2020 12:06:48 +0100 (CET)
Received: from function.youpi.perso.aquilenet.fr (unknown [IPv6:2a01:cb19:956:1b00:9eb6:d0ff:fe88:c3c7])
        by hera.aquilenet.fr (Postfix) with ESMTPSA id DF58C14B0;
        Wed,  9 Dec 2020 12:06:47 +0100 (CET)
Received: from samy by function.youpi.perso.aquilenet.fr with local (Exim 4.94)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1kmxJ1-0064tb-6c; Wed, 09 Dec 2020 12:06:47 +0100
Date:   Wed, 9 Dec 2020 12:06:47 +0100
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Greg KH <greg@kroah.com>, stable@vger.kernel.org
Subject: Re: [PATCH for 4.19] speakup: Reject setting the speakup line
 discipline outside of speakup
Message-ID: <20201209110647.3uuxkwjejesprnv7@function>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg KH <greg@kroah.com>, stable@vger.kernel.org
References: <20201209102640.yn7mdn52sm7bfbgm@function>
 <X9Cs/hMXQ4grRDql@kroah.com>
 <20201209110324.lnx7jmnm456jovim@function>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201209110324.lnx7jmnm456jovim@function>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Samuel Thibault, le mer. 09 déc. 2020 12:03:24 +0100, a ecrit:
> Can you apply them with -l, or should I fix the whitespacing?

Don't bother, I found the difference, will post fixed patches.

Samuel
