Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D277E5E5DA4
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 10:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiIVIjn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 22 Sep 2022 04:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiIVIjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 04:39:39 -0400
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D202BD;
        Thu, 22 Sep 2022 01:39:33 -0700 (PDT)
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay05.hostedemail.com (Postfix) with ESMTP id 25272408D0;
        Thu, 22 Sep 2022 08:39:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id 434D62002D;
        Thu, 22 Sep 2022 08:39:26 +0000 (UTC)
Message-ID: <c4f2d581ef0cbb84c4ad3b244863fc4b7d48fd2f.camel@perches.com>
Subject: Re: Linux 4.14.294
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        Jason Wang <wangborong@cdjrlc.com>
Date:   Thu, 22 Sep 2022 01:39:28 -0700
In-Reply-To: <Yywdpyn814NkBJY8@kroah.com>
References: <1663669061118192@kroah.com> <1663669061138255@kroah.com>
         <e9863ed5576cb93a6fd9b59cd19be9b71fda597d.camel@perches.com>
         <445878e0-d8c9-558f-73b7-8d39fa1a5cde@gmail.com>
         <YywGcg/Qgf8B8wEj@kroah.com>
         <e4852207ed36662a7c53e36fbbc31a71c5a3396e.camel@perches.com>
         <Yywdpyn814NkBJY8@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 434D62002D
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: ppumcdwcfxyu6bh43zqsi4ad7gwy6kyw
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18YY2yeT9IWH06IUx7MEw784gIenAxp/Yo=
X-HE-Tag: 1663835966-172240
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-09-22 at 10:32 +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 22, 2022 at 01:26:59AM -0700, Joe Perches wrote:
> > On Thu, 2022-09-22 at 08:53 +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Sep 22, 2022 at 11:02:21AM +0700, Bagas Sanjaya wrote:
> > > > On 9/22/22 01:03, Joe Perches wrote:
> > > > > On Tue, 2022-09-20 at 12:17 +0200, Greg Kroah-Hartman wrote:
> > > > > []
> > > > > > diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
> > > > > []
> > > > > > @@ -118,7 +118,7 @@ struct report_list {
> > > > > >   * @multi_packet_cnt:	Count of fragmented packet count
> > > > > >   *
> > > > > >   * This structure is used to store completion flags and per client data like
> > > > > > - * like report description, number of HID devices etc.
> > > > > > + * report description, number of HID devices etc.
> > > > > >   */
> > > > > >  struct ishtp_cl_data {
> > > > > >  	/* completion flags */
> > > > > 
> > > > > Needless backporting of typo fixes reduces confidence in the
> > > > > backport process.
> > > > > 
> > > > 
> > > > The upstream commit 94553f8a218540 ("HID: ishtp-hid-clientHID: ishtp-hid-client:
> > > > Fix comment typo") didn't Cc: stable, but got AUTOSELed [1].
> > > > 
> > > > I think we should only AUTOSEL patches that have explicit Cc: stable.
> > > 
> > > That's not how AUTOSEL works or why it is there at all, sorry.
> > 
> > Perhaps not, but why is AUTOSEL choosing this and why is
> > this being applied without apparent human review?
> 
> We always appreciate more review, and welcome it.  Sometimes things slip
> by us as well, like it did for this one.  The changelog makes it look
> like a real fix that is needed.

What part of:

--------------------------
commit 94553f8a218540d676efbf3f7827ed493d1057cf
Author: Jason Wang <wangborong@cdjrlc.com>
Date:   Thu Aug 4 08:58:14 2022 +0800

    HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo
    
    The double `like' is duplicated in the comment, remove one.
    
    Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
--------------------------

makes it seem like a candidate for backporting?

Perhaps the eagerness to backport is simply too high.

