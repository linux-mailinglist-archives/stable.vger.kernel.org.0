Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C46B595FB1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 17:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiHPPzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 11:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiHPPzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 11:55:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8C553D1B
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F5ABB818DF
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 15:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5A8C433C1;
        Tue, 16 Aug 2022 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660665145;
        bh=+MlLRoQgzXsWUZlON/gGD6FRwKwtBB3t945803noKzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1xyDGn5+9q9D5tuEKxzvKuC8RsggCMlOjyZmjwOu9F5m150xvEZcd7OKW8ehB7ky+
         ntIfTGxX0tyTmlYpGuGH8WzUL84pvVcycSVeVvIcTVglTMroFqajIa9YZVQIUAlkfa
         x5BtozvN8D1p4JXVn0sTsnh6RDndBmmgWuDZwucE=
Date:   Tue, 16 Aug 2022 17:52:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for
 122bb8ac (stable-queue)
Message-ID: <Yvu9NUhdV0n4dnmT@kroah.com>
References: <92005.122081607111901341@us-mta-567.us.mimecast.lan>
 <YvuFfp/wfn4UFYpn@kroah.com>
 <CA+tGwnk-oaPVFzbRebJbtrkgiPtaQRr=d83kzdxZZGGjQUuCbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+tGwnk-oaPVFzbRebJbtrkgiPtaQRr=d83kzdxZZGGjQUuCbA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 05:36:39PM +0200, Veronika Kabatova wrote:
> On Tue, Aug 16, 2022 at 2:05 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 16, 2022 at 11:11:18AM -0000, cki-project@redhat.com wrote:
> > > Hi, we tested your kernel and here are the results:
> > >
> > >     Overall result: FAILED
> > >              Merge: OK
> > >            Compile: FAILED
> > >
> > >
> > > You can find all the details about the test run at
> > >     https://datawarehouse.cki-project.org/kcidb/checkouts/41055
> > >
> > > One or more kernel builds failed:
> > >     Unrecognized or new issues:
> > >           x86_64 - https://datawarehouse.cki-project.org/kcidb/builds/218267
> >
> 
> Hi Greg,
> 
> we fixed the issue that caused the lack of notifications for build failures
> (hence me sending the email manually yesterday), and that in turn
> caused some super old emails from May to go out. That was less than
> expected, and we're sorry about that.
> 
> > Am I going to be forced to click through to find out the problems with
> > all of these reports?  Why not provide the error log?
> >
> > The error log isn't at that link, where are we supposed to find it to
> > figure out what went wrong?
> >
> 
> The logs would normally be available, but as a consequence of the
> old emails going out, they were already deleted.
> 
> We're also working on a reporting mode that would add the failure
> log links into the email directly, and for build failures, embed the
> traces in the email body too. Would these two provide a suitable
> solution for you?

That's a good start, yes.

> > > If you find a failure unrelated to your changes, please tag it at https://datawarehouse.cki-project.org .
> > > This will prevent the failures from being incorrectly reported in the future.
> > > If you don't have permissions to tag an issue, you can contact the CKI team or
> > > test maintainers.
> > >
> > > Please reply to this email if you have any questions about the tests that we
> > > ran or if you have any suggestions on how to make future tests more effective.
> > >
> > >         ,-.   ,-.
> > >        ( C ) ( K )  Continuous
> > >         `-',-.`-'   Kernel
> > >           ( I )     Integration
> > >            `-'
> > > ______________________________________________________________________________
> > >
> >
> > I have no idea what the subject line means, sorry.  A random git commit
> > id with no context isn't helpful, what are we to do with that?
> 
> Would it be more useful to provide a branch name in the subject as well,
> and a commit description in the body? Or something completely different?

Think about what you would want to see in an email to try to figure out
what it is trying to say.  Make it obvious what the email is about and
referencing and what needs to be done about it.

thanks,

greg k-h
