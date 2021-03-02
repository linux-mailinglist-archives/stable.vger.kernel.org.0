Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D83C32B0E2
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbhCCAkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1445517AbhCBPxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 10:53:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C419064F23;
        Tue,  2 Mar 2021 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614695713;
        bh=oGvuvybsltwMRQCLRiwCtaJm/FQqciSkGyu/hxWExlw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wLIHqKAyarWV2Rtd6VvLR06vOr59tQJDbEJTfAtvN/jozciQjO+Ar+ne2TWM0DBzm
         6YwrmfPGKheMOuqTGZYmDKZVtmSygCGscGCua3rRRu9RQMVUjT1PDfxYPw//OvvoyL
         D4uqB/2ZR6FN4iBkYrnC9oTWz9LLM8SbcXchSetU=
Date:   Tue, 2 Mar 2021 15:35:10 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Coelho, Luciano" <luciano.coelho@intel.com>
Cc:     "ihab.zhaika@intel.com" <ihab.zhaika@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] iwlwifi: add new cards for So and Qu
 family" failed to apply to 5.11-stable tree
Message-ID: <YD5NHvewMnvkk/L0@kroah.com>
References: <16145936091141@kroah.com>
 <f5fd7a304a92280467e1c6bfb465c408ba9fd71c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5fd7a304a92280467e1c6bfb465c408ba9fd71c.camel@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 02:17:25PM +0000, Coelho, Luciano wrote:
> Hi Greg,
> 
> I tried to apply this path on the latest linux-5.11.y branch
> (27e543cca13fab05689b2d0d61d200a83cfb00b6) and it applied cleanly.
> 
> Maybe there are other queued patches that are conflicting with this? Is
> there a branch somewhere that I should use?

It applies cleanly, but you failed to build the kernel with that patch
applied to see the error that it causes :(

greg k-h
