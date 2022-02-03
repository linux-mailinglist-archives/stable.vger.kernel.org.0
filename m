Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B244A8B22
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 19:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiBCSDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 13:03:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35636 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiBCSDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 13:03:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D7261871
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 18:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4770BC340EF;
        Thu,  3 Feb 2022 18:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643911390;
        bh=b6mi3XBQpn2C9fBq5r1WNOIixn2E+w544dSP1gAzPeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TtiQeSCg6kaY4UBszBMqrWbYxHxulNBpRVCFqT0Q26S+6vh+MLx1gcyTln0j9olV3
         ofSvKG4CF7O9Vjs15jveZrcEa4/NrvdJd5jb26YwvHCp1kbTy0SKKl6/urDgCJghkh
         pViKz9Lbi7qEaogZxQyjJL4Q5PFxPGv7XUyqBoUs=
Date:   Thu, 3 Feb 2022 19:03:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Phil Elwell <phil@raspberrypi.com>,
        Tim Gover <tim.gover@raspberrypi.com>,
        Dom Cobley <dom@raspberrypi.com>,
        Michael Stapelberg <michael+drm@stapelberg.ch>
Subject: Re: [PATCH stable] drm/vc4: hdmi: Fix improper merge conflict with
 CEC
Message-ID: <YfwY3FMBfcad2Yr6@kroah.com>
References: <20220131114323.406007-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131114323.406007-1-maxime@cerno.tech>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 12:43:23PM +0100, Maxime Ripard wrote:
> Commit 20b0dfa86bef0e80b41b0e5ac38b92f23b6f27f9 upstream.
> 
> The original commit depended on a rework commit (724fc856c09e ("drm/vc4:
> hdmi: Split the CEC disable / enable functions in two")) that
> (rightfully) didn't reach stable.

Now queued up, thanks.

greg k-h
