Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5043B6C31E7
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 13:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjCUMmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 08:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCUMmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 08:42:23 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F9764D428;
        Tue, 21 Mar 2023 05:41:46 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id AECCD92009D; Tue, 21 Mar 2023 13:41:06 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id AB0FA92009C;
        Tue, 21 Mar 2023 12:41:06 +0000 (GMT)
Date:   Tue, 21 Mar 2023 12:41:06 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg KH <greg@kroah.com>
cc:     Pavel Machek <pavel@ucw.cz>, Willy Tarreau <w@1wt.eu>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
In-Reply-To: <ZAx0Fhih9Ckbk07M@kroah.com>
Message-ID: <alpine.DEB.2.21.2303211125090.55912@angie.orcam.me.uk>
References: <Y/rufenGRpoJVXZr@sol.localdomain> <Y/ux9JLHQKDOzWHJ@sol.localdomain> <Y/y70zJj4kjOVfXa@sashalap> <Y/zswi91axMN8OsA@sol.localdomain> <Y/zxKOBTLXFjSVyI@sol.localdomain> <ZATC3djtr9/uPX+P@duo.ucw.cz> <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org> <ZAw3tt9xISOdb5sS@1wt.eu> <ZAxp0KaKq7x7ZKlz@duo.ucw.cz> <ZAx0Fhih9Ckbk07M@kroah.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 11 Mar 2023, Greg KH wrote:

> So no, forcing a maintainer/author to ack a patch to get it into stable
> is not going to work UNLESS a maintainer/author explicitly asks for
> that, which some have, and that's wonderful.

 FWIW I'm happy to ack patches for stable backporting (and I tag patches 
of mine for stable as I deem appropriate).

  Maciej
