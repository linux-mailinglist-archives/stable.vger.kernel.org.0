Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB20461451C
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 08:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKAHg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 03:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiKAHg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 03:36:26 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1CC1837D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 00:36:25 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 8F2A1240103
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 08:36:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1667288183; bh=F1AGMlUiQmzyk2ea/0PgKOUGTIg8r+pUfVdnang/zqU=;
        h=Date:From:To:Cc:Subject:From;
        b=hoekcet2WrT4G3XB5WL2YzF335CU2CnwHEcvRey1Vyf/X4yjGSQShStAumUMVYq+5
         5zjLrp3xVOeM2vLvzXBy5TaVSgew4dBdJjCQPtE++iXvAhBfcIqlCXK163LyyZyEMa
         tKeU7xzPXJRCmFkVtZ775DRueCgSWjYp7OIFYWHJAFfh0WsZahovz9V9JZdykVx6sL
         LVmhVCIE/A5ZCr0GylMywX6NVl9pWP3runt4z/4KWhm6T1fLa63S9l6WTZ4FD8Bn3N
         pGfmy+d+aMK5cEhzMp8Pt8Rx+HtDBQvp4+PUCdtYlaP1Q1PltSL/ZgpTO0c2KNVHLP
         OEDbzUw5haQnQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4N1hfG09JLz9rxS;
        Tue,  1 Nov 2022 08:36:21 +0100 (CET)
Date:   Tue,  1 Nov 2022 07:36:21 +0000
From:   Nils Freydank <nils.freydank@posteo.de>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks
Message-ID: <20221101073621.lxjxnn3svdxmgkzb@pygoscelis>
References: <20221031223652.17717-1-nils.freydank@posteo.de>
 <Y2ClyVc7J0g6pdFS@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2ClyVc7J0g6pdFS@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, den 01.11.2022 um 05:51:21 Uhr +0100 schrieb Greg KH <greg@kroah.com>:
> On Mon, Oct 31, 2022 at 10:36:53PM +0000, Nils Freydank wrote:
> > commit b37fe34c83099ba5105115f8287c5546af1f0a05 upstream.
> > 
> > This fixes a compilation bug introduced in commit
> > e9847175b266f12365160e124a207907da3dbe8e (platform/x86/amd: pmc: Read SMU
> > version during suspend on Cezanne systems).
> > 
> > Signed-off-by: Nils Freydank <nils.freydank@posteo.de>
> > ---
> > 
> >  Backport patch applies and compiles with linux 6.0.6.
> 
> This is already in the 6.0.y queue, but thanks for sending it again.
> 
> Next time, be sure you keep the original changelog text _AND_ authorship
> and signed-off-by lines, and cc: those developers as well.  Stripping
> that off is a bit rude of them, don't you think?

Thanks for the clear instructions, I'll keep them in mind for the future.

> thanks,
> 
> greg k-h
