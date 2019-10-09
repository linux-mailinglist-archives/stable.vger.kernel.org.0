Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50485D0B29
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfJIJ33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:29:29 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34544 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfJIJ33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:29:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iI8Hf-0000my-5O; Wed, 09 Oct 2019 11:29:27 +0200
Message-ID: <d7ba3bc67cab0ca0caffcb62de9ff419c8ce24ef.camel@sipsolutions.net>
Subject: Re: [PATCH 4.4, 4.9, 4.14, 4.19] nl80211: validate beacon head
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <greg@kroah.com>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Wed, 09 Oct 2019 11:29:26 +0200
In-Reply-To: <20191009092702.GA3901624@kroah.com>
References: <1570603265-@changeid> <20191009092702.GA3901624@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-10-09 at 11:27 +0200, Greg KH wrote:
> On Wed, Oct 09, 2019 at 08:41:09AM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Commit 8a3347aa110c76a7f87771999aed491d1d8779a8 upstream.
> 
> I don't see that commit in Linus's tree :(

Hmmm. Not sure what happened there. I had created this in reply to
Sasha's bot, perhaps it told me a different commit ID or something.

Or maybe ... yes I think the bot had actually applied a *patch* rather
than picked one up, and I didn't really know what to do, but forgot
about this then.

> Is this f88eb7c0d002 ("nl80211: validate beacon head")?

Yes.

johannes

