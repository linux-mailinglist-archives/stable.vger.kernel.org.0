Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8970394E40
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 23:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhE2VVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 17:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhE2VVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 17:21:19 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD71C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 14:19:42 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 203A26851; Sat, 29 May 2021 17:19:40 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 203A26851
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1622323180;
        bh=+jfpZ9rYcWGiXVGrOCJynqBeee5HUS7B/P70KivDr58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OPO7GYMWfXTGsEtAV+ZqzyjvM8QDmsS9M2wBZ6tqmZY7vQTfT7DA6SXU5Fr0uhEWC
         NcoA/bRDU3KTSIWhaTD3QLNSZG6JXPKE2i/+zdoT2rmp1DkmbAk9xau5mXGWTBzU6B
         kykBPr9Vsz7elZewEdfHMiX21aCEHsIgWckcQ1V4=
Date:   Sat, 29 May 2021 17:19:40 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [CI] drm/i915: Disable atomics in L3 for gen9
Message-ID: <20210529211940.GA6698@fieldses.org>
References: <20210528172543.GA7385@fieldses.org>
 <YLHRKI+RZ0nvIe/P@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLHRKI+RZ0nvIe/P@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 29, 2021 at 07:29:12AM +0200, Greg KH wrote:
> On Fri, May 28, 2021 at 01:25:43PM -0400, J. Bruce Fields wrote:
> > Would it be possible to apply
> > 
> > 	58586680ffad "drm/i915: Disable atomics in L3 for gen9"
> > 
> > to stable kernels?
> > 
> > I'm finding it quite easy to crash my Thinkpad X1 Carbon 6th gen with
> > Blender on Fedora 34 (which is using the 5.11.y kernels).  It applies
> > cleanly, and I've been running 5.11.16 with the patch applied and seeing
> > no obvious ill effects.
> 
> As 5.11.y is now end-of-life, and has been for a week or so, what
> kernel(s) would you want this applied to given that 5.12.y is the latest
> stable kernel tree?

Oh, apologies, I hadn't realized.  That's fine, then.

--b.
