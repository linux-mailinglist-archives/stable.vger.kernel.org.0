Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B16CD0B97
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfJIJoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:44:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34806 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729817AbfJIJoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:44:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iI8Vo-0001DF-HQ; Wed, 09 Oct 2019 11:44:04 +0200
Message-ID: <fd0c407c9507ba22741af5a9360ddba79971af29.camel@sipsolutions.net>
Subject: Re: [PATCH 4.4, 4.9, 4.14, 4.19] nl80211: validate beacon head
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <greg@kroah.com>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Wed, 09 Oct 2019 11:44:03 +0200
In-Reply-To: <20191009094310.GA3945119@kroah.com>
References: <1570603265-@changeid> <20191009094310.GA3945119@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-10-09 at 11:43 +0200, Greg KH wrote:
> 
> > +	for_each_element(elem, data, len) {
> > +		/* nothing */
> > +	}
> 
> for_each_element() is not in 4.4, 4.9, 4.14, or 4.19, so this breaks the
> build :(

Oh, right. I had previously also said:

You also need to cherry-pick
0f3b07f027f8 ("cfg80211: add and use strongly typed element iteration macros")
7388afe09143 ("cfg80211: Use const more consistently in for_each_element macros")

as dependencies - the latter doesn't apply cleanly as it has a change
that doesn't apply, but that part of the change isn't necessary.

johannes

