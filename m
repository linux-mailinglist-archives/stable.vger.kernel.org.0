Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF923BB78C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhGEHPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhGEHPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 03:15:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12B88613E1;
        Mon,  5 Jul 2021 07:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625469158;
        bh=Vna4oajZuvLzvcsjivNmu37UU2qWHxuhBDBfFUi7FJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HY1mazg5/KU0gQ8mP6bWUmqiY2tSQFhIBzKCu/JuYInmWdaGRIBQRGwq5BPbVp4T6
         CCQWt6fLzLNteKDYeu39qH6gVKI7XFV1hVF7BplU0FSeACkVlIbyVD1l5OpsXGsLVN
         YmIqEnIwbn7IICvQpWsPuvSiqktPkhrc7jrsgLoA=
Date:   Mon, 5 Jul 2021 09:12:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Fujinaka, Todd" <todd.fujinaka@intel.com>
Cc:     Philipp Hahn <hahn@univention.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "892105@bugs.debian.org" <892105@bugs.debian.org>,
        Ben Hutchings <benh@debian.org>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "Bonaccorso, Salvatore" <carnil@debian.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
Subject: Re: Cherry-pick "i40e: Be much more verbose about what we can and
 cannot offload"
Message-ID: <YOKw5MzGaUNjxx/y@kroah.com>
References: <937dd880-f902-aa9c-67d5-2d582a29e122@univention.de>
 <BYAPR11MB360618A581F56D9054B2148AEF029@BYAPR11MB3606.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB360618A581F56D9054B2148AEF029@BYAPR11MB3606.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 06:20:30PM +0000, Fujinaka, Todd wrote:
> I think I accidentally deleted the forward from the intel-wired-lan spam filter. Re-forwarding and adding Alex's gmail address.
> 
> Also, 
> 
> Todd Fujinaka
> Software Application Engineer
> Data Center Group
> Intel Corporation
> todd.fujinaka@intel.com
> 
> -----Original Message-----
> From: Philipp Hahn <hahn@univention.de> 
> Sent: Tuesday, June 22, 2021 11:19 AM
> To: stable@vger.kernel.org; 892105@bugs.debian.org; Ben Hutchings <benh@debian.org>
> Cc: Alexander Duyck <alexander.h.duyck@intel.com>; Andrew Bowers <andrewx.bowers@intel.com>; Bonaccorso, Salvatore <carnil@debian.org>
> Subject: Cherry-pick "i40e: Be much more verbose about what we can and cannot offload"
> 
> Hello,
> 
> I request the following patch from v4.10-rc1 to get cherry-picked into
> "stable/linux-4.9.y":
> 
> > commit f114dca2533ca770aebebffb5ed56e5e7d1fb3fb

Please provide a working backport, that you have tested works properly,
as it does not apply cleanly.

thanks,

greg k-h
