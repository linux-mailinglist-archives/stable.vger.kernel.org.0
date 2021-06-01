Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD92B396DEC
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 09:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhFAHbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 03:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFAHbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 03:31:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F60C061574;
        Tue,  1 Jun 2021 00:29:32 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnyq7-000UO1-7m; Tue, 01 Jun 2021 09:29:27 +0200
Message-ID: <1266031f7d408606ea2b3424e04ed341bf943621.camel@sipsolutions.net>
Subject: Re: [PATCH v4.14 00/10] wireless security fixes backports
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 01 Jun 2021 09:29:26 +0200
In-Reply-To: <YLXhbpr9RrraHaws@kroah.com>
References: <20210531203135.180427-1-johannes@sipsolutions.net>
         <YLXhbpr9RrraHaws@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-06-01 at 09:27 +0200, Greg KH wrote:
> On Mon, May 31, 2021 at 10:31:25PM +0200, Johannes Berg wrote:
> > Some of these patches here were already applied since they
> > applied cleanly, but I'm resending the whole set for review
> > now anyway.
> 
> I've applied your updated versions just to make sure that my backports
> were not somehow messed up, thank for these!

I'm sure they were the same, I just cherry-picked them (cleanly) :)

Honestly, I was just too lazy to dig out the stable queue, apply the
patches from there manually, and then not send them etc. ... when
cherry-pick was easy.

Thanks,
johannes

