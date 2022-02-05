Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95604AA8D8
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiBEMxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:53:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43652 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiBEMxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:53:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DF6660E9C
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 12:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012CFC340E8;
        Sat,  5 Feb 2022 12:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644065626;
        bh=mgVuFp59P5KDidEYoE+6Qb0k+hrrX7gcWguKx/3smAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RGLcKjjm4uWLDUDkDcA7/vDDOg4SEHJDy1qIFmrC9Ipfj2rBEiPhJ7JIxmVR9Dq+H
         m9U/akRp7ctlHZea5SPS8qylMPDYKV9En3B7umHxQcBt2ObhJXWh6zKdL7WlGutOwk
         CywnDV8ezs3SnQR8ZEBacpMdGarMFoKxKOk+cWvc=
Date:   Sat, 5 Feb 2022 13:53:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Kleiner <mario.kleiner.de@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Uma Shankar <uma.shankar@intel.com>
Subject: Re: drm/i915: Disable DSB usage for now -- Backport to 5.15-stable
Message-ID: <Yf5zVwOF3wWXe/z7@kroah.com>
References: <CAEsyxyjjsOugaA4VOpayCVNGCtHoZsyBpadLeDoVVUNDsBLW-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsyxyjjsOugaA4VOpayCVNGCtHoZsyBpadLeDoVVUNDsBLW-Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 05, 2022 at 05:38:56AM +0100, Mario Kleiner wrote:
> Upstream commit id in Linux 5.17-rc:
> 99510e1afb4863a225207146bd988064c5fd0629 ("drm/i915: Disable DSB usage
> for now").
> 
> I'd like to nominate that patch for application to the 5.15-stable
> tree. It applies trivially after dropping the  ...
> 
> .has_pxp = 1, \
> 
> ... line of context. That line of context was introduced by the
> unrelated feature introduced later by
> 6f8e203897144e59de00ed910982af3d7c3e4a7f ("drm/i915/pxp: enable PXP
> for integrated Gen12"), so can be safely dropped.
> 
> Disabling use of the DSB for GAMMA_LUT updates should fix corrupted
> display colors on Intel Tigerlake, Rocketlake, DG-1 and Alderlake-S
> Generation 12 graphics. Good explanation is in the upstream commit,
> but for reference here the bug report which led to the bug diagnosis
> and fix:
> 
> https://gitlab.freedesktop.org/drm/intel/-/issues/3916
> 
> This would make high color precision and HDR display modes usable on
> Gen 12 graphics with Linux 5.51-stable.

Now queued up (also for 5.16.y)

thanks,

greg k-h
