Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0324A11D0BE
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 16:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfLLPRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 10:17:15 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52930 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729307AbfLLPRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 10:17:14 -0500
Received: from callcc.thunk.org (guestnat-104-132-34-105.corp.google.com [104.132.34.105] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBCFH7aW020326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 10:17:07 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id F10FC421A4A; Thu, 12 Dec 2019 10:17:06 -0500 (EST)
Date:   Thu, 12 Dec 2019 10:17:06 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable@kernel.org, Andreas Dilger <adilger@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 27/37] ext4: work around deleting a file with
 i_nlink == 0 safely
Message-ID: <20191212151706.GA204354@mit.edu>
References: <20191211153813.24126-1-sashal@kernel.org>
 <20191211153813.24126-27-sashal@kernel.org>
 <20191211161959.GB129186@mit.edu>
 <20191211200454.GF12996@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211200454.GF12996@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 03:04:54PM -0500, Sasha Levin wrote:
> > I'm confused; this was explicitly cc'ed to stable@kernel.org, so why
> > is your AUTOSEL picking this up?  I would have thought this would get
> > picked up via the normal stable kernel processes.
> 
> My mistake, appologies.

No worries; the intent was that it be backported to stable, and I
don't really care with path it takes.

I just wanted to make sure there wouldn't be confusion if you
backported it to stable, and then Greg tried and then got a merge
conflict.  (Or worse, if the patch was one of the ones where it can be
successfully applied *twice* w/o a patch conflict; I'm not sure if git
cherry-pick is smarter than patch in this regard, but I don't think it
is?)

   	   	      	      	      	    	  - Ted
