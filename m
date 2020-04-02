Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4092319C54F
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388923AbgDBPCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 11:02:11 -0400
Received: from poserver.naic.edu ([192.65.176.209]:44509 "EHLO
        poserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388234AbgDBPCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 11:02:11 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2020 11:02:10 EDT
Received: from mailserver.naic.edu (mailserver.naic.edu [192.65.176.45])
        by poserver.naic.edu (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id 032Erb2v021311;
        Thu, 2 Apr 2020 14:53:37 GMT
Received: from monopoli.naic.edu (monopoli [192.65.176.208])
        by mailserver.naic.edu (8.12.8/8.12.8) with ESMTP id 032Eraik026816;
        Thu, 2 Apr 2020 10:53:36 -0400
Received: by monopoli.naic.edu (Postfix, from userid 205)
        id 4BD348533D3A; Thu,  2 Apr 2020 10:53:36 -0400 (AST)
Date:   Thu, 2 Apr 2020 10:53:36 -0400
From:   Giacomo Comes <comes@naic.edu>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     Giacomo Comes <comes@naic.edu>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] kernel 5.6: baytrail hdmi audio not working
Message-ID: <20200402145336.GA19483@monopoli.naic.edu>
References: <20200401225317.GA13834@monopoli.naic.edu>
 <20200402135203.GV13686@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200402135203.GV13686@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Score: undef - 192.65.176.45 is allowed always.
X-CanIt-Geo: ip=192.65.176.45; country=PR; latitude=18.2500; longitude=-66.5000; http://maps.google.com/maps?q=18.2500,-66.5000&z=6
X-CanItPRO-Stream: default
X-Canit-Stats-ID: Bayes signature not available
Received-SPF: neutral (poserver.naic.edu: 192.65.176.45 is neither permitted
        nor denied by domain comes@naic.edu)
        receiver=poserver.naic.edu; client-ip=192.65.176.45;
        envelope-from=<comes@naic.edu>; helo=mailserver.naic.edu;
        identity=mailfrom
X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.65.176.209
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 04:52:03PM +0300, Ville Syrjälä wrote:
> On Wed, Apr 01, 2020 at 06:53:17PM -0400, Giacomo Comes wrote:
> > Hi,
> > on my Intel Compute Stick STCK1 (baytrail hdmi audio) 
> > sound is not working with the kernel 5.6
> > 
> > I have bisected the kernel and I found the commit that introduced the issue:
> > 
> > commit 58d124ea2739e1440ddd743d46c470fe724aca9a
> > Author: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Date:   Thu Oct 31 12:26:04 2019 +0100
> > 
> >     drm/i915: Complete crtc hw/uapi split, v6.
> >     
> >     Now that we separated everything into uapi and hw, it's
> >     time to make the split definitive. Remove the union and
> >     make a copy of the hw state on modeset and fastset.
> >     
> >     Color blobs are copied in crtc atomic_check(), right
> >     before color management is checked.
> > 
> > If more information is required please let me know.
> 
> Should hopefully be fixed with
> commit 2bdd4c28baff ("drm/i915/display: Fix mode private_flags
> comparison at atomic_check")
> 
> Stable folks, please pick that up for 5.6.x stable releases.

I can confirm that the commit indeed solves the problem I have.
It should go in the stable 5.6.x release ASAP.

Thanks.
Giacomo
