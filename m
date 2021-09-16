Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB7540E8D2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356176AbhIPRpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355829AbhIPRmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0480660E52;
        Thu, 16 Sep 2021 17:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631812640;
        bh=Xl0MqgGUErm/sYem7R3RIgWW127lzoLhMkEaK65ZDoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AW3xB4jb224Lj280eH2qtgJPOkAzxTYnzYPgiq0Zpx7p67vhbr/MGbQVE66qCg0uH
         +ZcQJduTFcba/estADZYRjJDYO6M4QGOlC3POVD7UcP3mXFlmqufqKB0G3iFWxf/TA
         JqJqo3QSkbpK2+SDOjwWzIKWfTkM+BvQ4tAdM0DQ=
Date:   Thu, 16 Sep 2021 19:04:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     Michel =?iso-8859-1?Q?D=E4nzer?= <mdaenzer@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Quan, Evan" <Evan.Quan@amd.com>,
        "Lazar, Lijo" <Lijo.Lazar@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when
 GFXOFF is disabled" failed to apply to 5.14-stable tree
Message-ID: <YUN5CMN8MtE6vyVd@kroah.com>
References: <163179752354221@kroah.com>
 <7fe8e175-efdc-b7d9-ab86-44aeec60c2e9@redhat.com>
 <YUNLMkxQPw/empni@kroah.com>
 <e5b4ad1d-4a4f-ae47-5c85-22842c1b44cc@redhat.com>
 <BL1PR12MB514443A3990D3E9CEF5F1251F7DC9@BL1PR12MB5144.namprd12.prod.outlook.com>
 <YUNkQgB2hJLLWvgT@kroah.com>
 <BL1PR12MB51446E52A8B46EAA5210CB8AF7DC9@BL1PR12MB5144.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR12MB51446E52A8B46EAA5210CB8AF7DC9@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 04:05:05PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Thursday, September 16, 2021 11:36 AM
> > To: Deucher, Alexander <Alexander.Deucher@amd.com>
> > Cc: Michel Dänzer <mdaenzer@redhat.com>; Koenig, Christian
> > <Christian.Koenig@amd.com>; Quan, Evan <Evan.Quan@amd.com>; Lazar,
> > Lijo <Lijo.Lazar@amd.com>; stable@vger.kernel.org
> > Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work
> > when GFXOFF is disabled" failed to apply to 5.14-stable tree
> > 
> > On Thu, Sep 16, 2021 at 02:42:42PM +0000, Deucher, Alexander wrote:
> > > [Public]
> > >
> > > > -----Original Message-----
> > > > From: Michel Dänzer <mdaenzer@redhat.com>
> > > > Sent: Thursday, September 16, 2021 9:55 AM
> > > > To: Greg KH <gregkh@linuxfoundation.org>
> > > > Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; Koenig,
> > > > Christian <Christian.Koenig@amd.com>; Quan, Evan
> > > > <Evan.Quan@amd.com>; Lazar, Lijo <Lijo.Lazar@amd.com>;
> > > > stable@vger.kernel.org
> > > > Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work
> > > > when GFXOFF is disabled" failed to apply to 5.14-stable tree
> > > >
> > > > On 2021-09-16 15:48, Greg KH wrote:
> > > > > On Thu, Sep 16, 2021 at 03:39:16PM +0200, Michel Dänzer wrote:
> > > > >> On 2021-09-16 15:05, gregkh@linuxfoundation.org wrote:
> > > > >>>
> > > > >>> The patch below does not apply to the 5.14-stable tree.
> > > > >>> If someone wants it applied there, or to any other stable or
> > > > >>> longterm tree, then please email the backport, including the
> > > > >>> original git commit id to <stable@vger.kernel.org>.
> > > > >>
> > > > >> It's already in 5.14, commit
> > 32bc8f8373d2d6a681c96e4b25dca60d4d1c6016.
> > > > >
> > > > > Odd, how were we supposed to know that?
> > > >
> > > > Looks like the fix was merged separately for 5.14 and 5.15. I don't
> > > > know how/why that happened. Alex / Christian?
> > >
> > > The fix already landed in drm-next, but since this was before the
> > > merge window, we wanted to make sure the fix also landed in stable, so
> > > I cherry-picked it to 5.14.  I'm not sure of a better way to handle
> > > these sort of cases.
> > 
> > You gotta give me a chance to know what happened.  As the drm developers
> > do this a lot, they have been putting the "cherry picked from" line in the
> > patch because they can not merge between branches and keep the git id the
> > same.
> > 
> > So try using the '-x' option to 'git cherry-pick' next time?
> 
> I can do that, but historically, I've gotten a lot of flack for that
> because the commit doesn't exist in Linus' tree yet at that point as
> the merge window hasn't opened yet.

I totally agree, and would argue that this is NOT the way to do it
either.  But it seems like this is what the i915 developers have been
doing for a few years now and honestly, it's better than nothing.

But I would like a real solution here, this gets very annoying every
-rc1 cycle for the DRM subsystem.  You all are the only ones with this
problem for some strange reason :(

greg k-h
