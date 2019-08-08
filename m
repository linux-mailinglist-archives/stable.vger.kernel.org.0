Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1785DC4
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 11:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfHHJDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 05:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731427AbfHHJDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 05:03:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF4C217F4;
        Thu,  8 Aug 2019 09:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565254997;
        bh=7PcfaKcDtoJ85wvV4uOWkslIfbf7alXGLB0y2eaQKDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=inF8oSiTMjJoynBeXHI0YcoRLbo/l+qQ18SWmVPAJ4GJW3e7QB4twAzUmpaDEaTKD
         LVnXFJBpSEmVkVOoAFU6f7VcT5VrXAWVsQhWYegTyt0GXv3RSA/wV1pdKmKOv1bI8e
         hHsFwB8feEmhK8EPpcwiCSseGveXfsD5MMpUI3Vc=
Date:   Thu, 8 Aug 2019 11:03:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     =?iso-8859-1?Q?Jos=E9?= Roberto de Souza <jose.souza@intel.com>,
        stable@vger.kernel.org, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        =?iso-8859-1?Q?Fran=E7ois?= Guerraz <kubrick@fgv6.net>
Subject: Re: [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section
Message-ID: <20190808090315.GA6654@kroah.com>
References: <156498469082135@kroah.com>
 <20190805224951.6523-1-jose.souza@intel.com>
 <87mugmkaam.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mugmkaam.fsf@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 10:44:33AM +0300, Jani Nikula wrote:
> On Mon, 05 Aug 2019, José Roberto de Souza <jose.souza@intel.com> wrote:
> > From: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
> >
> 
> commit 6d61f716a01ec0e134de38ae97e71d6fec5a6ff6 upstream.

Now queued up, thanks.

greg k-h
