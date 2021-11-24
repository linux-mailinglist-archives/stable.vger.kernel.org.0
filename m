Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6458C45C9B9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbhKXQVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:21:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhKXQVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 11:21:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B5D960FD8;
        Wed, 24 Nov 2021 16:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637770689;
        bh=RPg75/RPp6Ne52H/aj5G1CgdY10Uh3p1QQbimhcUY10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1dYHRJrg5+J5p3mUg7OOgfS2ee2egAl3L252dhvlQNZbogkSwzd2gKCkjVN6elnKk
         pqmALsMsap6dp2IeAHfu4lW9Y9NUSf4jStkeGeRL8r2tmWhm+gnJixMRlIU3H32I8+
         qK9+3GJtlqmrCldx4fRyiV6VkmJyPQAy0/WdX5NI=
Date:   Wed, 24 Nov 2021 17:18:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Daniel Black <daniel@mariadb.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: uring regression - lost write request
Message-ID: <YZ5lvtfqsZEllUJq@kroah.com>
References: <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
 <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
 <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
 <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk>
 <CABVffEM79CZ+4SW0+yP0+NioMX=sHhooBCEfbhqs6G6hex2YwQ@mail.gmail.com>
 <3aaac8b2-e2f6-6a84-1321-67409b2a3dce@kernel.dk>
 <98f8a00f-c634-4a1a-4eba-f97be5b2e801@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98f8a00f-c634-4a1a-4eba-f97be5b2e801@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 09:10:25AM -0700, Jens Axboe wrote:
> On 11/24/21 8:28 AM, Jens Axboe wrote:
> > On 11/23/21 8:27 PM, Daniel Black wrote:
> >> On Mon, Nov 15, 2021 at 7:55 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 11/14/21 1:33 PM, Daniel Black wrote:
> >>>> On Fri, Nov 12, 2021 at 10:44 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>
> >>>>> Alright, give this one a go if you can. Against -git, but will apply to
> >>>>> 5.15 as well.
> >>>>
> >>>>
> >>>> Works. Thank you very much.
> >>>>
> >>>> https://jira.mariadb.org/browse/MDEV-26674?page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel&focusedCommentId=205599#comment-205599
> >>>>
> >>>> Tested-by: Marko Mäkelä <marko.makela@mariadb.com>
> >>>
> >>> The patch is already upstream (and in the 5.15 stable queue), and I
> >>> provided 5.14 patches too.
> >>
> >> Jens,
> >>
> >> I'm getting the same reproducer on 5.14.20
> >> (https://bugzilla.redhat.com/show_bug.cgi?id=2018882#c3) though the
> >> backport change logs indicate 5.14.19 has the patch.
> >>
> >> Anything missing?
> > 
> > We might also need another patch that isn't in stable, I'm attaching
> > it here. Any chance you can run 5.14.20/21 with this applied? If not,
> > I'll do some sanity checking here and push it to -stable.
> 
> Looks good to me - Greg, would you mind queueing this up for
> 5.14-stable?

5.14 is end-of-life and not getting any more releases (the front page of
kernel.org should show that.)

If this needs to go anywhere else, please let me know.

thanks,

greg k-h
